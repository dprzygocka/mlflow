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
0	Default	s3://mlflow-storage/0	active	1715629171558	1715629171558
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
SMI - Power Draw	15.12	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
SMI - Timestamp	1715629422.47	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
SMI - GPU Util	0	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
SMI - Mem Util	0	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
SMI - Mem Used	0	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
SMI - Performance State	3	1715629422489	0	f	a03a7115d19e465daa6771e836e1db39
TOP - CPU Utilization	104	1715631609016	0	f	a03a7115d19e465daa6771e836e1db39
TOP - Memory Usage GB	2.4194	1715631609016	0	f	a03a7115d19e465daa6771e836e1db39
TOP - Memory Utilization	7.8999999999999995	1715631609016	0	f	a03a7115d19e465daa6771e836e1db39
TOP - Swap Memory GB	0.0005	1715631609041	0	f	a03a7115d19e465daa6771e836e1db39
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1715629422256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	0	1715629422256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.5682	1715629422256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629422285	a03a7115d19e465daa6771e836e1db39	0	f
SMI - Power Draw	15.12	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
SMI - Timestamp	1715629422.47	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
SMI - GPU Util	0	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
SMI - Mem Util	0	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
SMI - Mem Used	0	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
SMI - Performance State	3	1715629422489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	160	1715629423259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629423259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.5682	1715629423259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629423284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629424261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629424261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.5682	1715629424261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629424282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629425264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629425264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8004	1715629425264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629425285	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629426267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629426267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8004	1715629426267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629426842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629427269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629427269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8004	1715629427269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629427292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	154.5	1715629428273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629428273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.834	1715629428273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629428304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629429276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629429276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.834	1715629429276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629429302	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629430279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629430279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.834	1715629430279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629430315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629431282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629431282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8357999999999999	1715629431282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629431303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629432284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629432284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8357999999999999	1715629432284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629432304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629433287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629433287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8357999999999999	1715629433287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629433314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629434290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629434290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8353	1715629434290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629434308	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629435292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629435292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8353	1715629435292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629435321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629436295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.999999999999999	1715629436295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8353	1715629436295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629436323	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629441338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629449359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629456384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629460393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629464399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629479414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629479414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3676999999999997	1715629479414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629728055	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629728055	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2882	1715629728055	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629729057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629729057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629729057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629731062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715629731062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629731062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629732066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629732066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2915	1715629732066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629738100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629744097	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629744097	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629744097	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629745100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629745100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629745100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629761143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629761143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2870999999999997	1715629761143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629771197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629772199	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629773201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629780216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629782212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629786234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629909521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629909521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2976	1715629909521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629910548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629916564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629917576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629921556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629921556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715629921556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629931584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629931584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629931584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629932587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629932587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629932587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629934592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629934592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629934592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629935594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629935594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629935594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629947646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629948652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629952660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629953669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629957670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629958680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629437297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629437297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8359	1715629437297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629438332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629439327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629447357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629452363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629453369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629454378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629457375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629458385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629459399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629461394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629468385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629468385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.839	1715629468385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629473399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629473399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3618	1715629473399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629475404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629475404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3618	1715629475404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629476406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629476406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629476406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629483423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629483423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629483423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629484426	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629484426	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629484426	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629485428	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629485428	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3695999999999997	1715629485428	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629486432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629486432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3695999999999997	1715629486432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629728080	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629729083	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629731087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629733069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629733069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2915	1715629733069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629740103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629744125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629745125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629771168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629771168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925999999999997	1715629771168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629772171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629772171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925999999999997	1715629772171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629773174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629773174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925999999999997	1715629773174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629780189	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629780189	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931	1715629780189	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629782195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629782195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931	1715629782195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629786205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629786205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931999999999997	1715629786205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629437315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629440326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629442334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629443341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629444346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629445352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629448329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.999999999999999	1715629448329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8354000000000001	1715629448329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629450362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629455380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629465403	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629466406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629467401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629469411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629470416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629471418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629474401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629474401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3618	1715629474401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629482421	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629482421	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629482421	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629730059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629730059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629730059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629734071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629734071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2915	1715629734071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629735103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629736102	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629737106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629741117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629746130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629747131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629754153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629755154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629757152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629758160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629759164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629760166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629766156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629766156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629766156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629767158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629767158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629767158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629768160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629768160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629768160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629774176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629774176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2933000000000003	1715629774176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629775178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629775178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2933000000000003	1715629775178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629776181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629776181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2933000000000003	1715629776181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629779187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629779187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2938	1715629779187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629781192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629781192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931	1715629781192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629438301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629438301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8359	1715629438301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629439304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629439304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8359	1715629439304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629447326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629447326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8354000000000001	1715629447326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629452340	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629452340	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8371	1715629452340	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629453343	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629453343	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8371	1715629453343	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629454345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629454345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8371	1715629454345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	108	1715629457354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629457354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8369000000000002	1715629457354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	108	1715629458357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629458357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.837	1715629458357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629459360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629459360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.837	1715629459360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107	1715629461366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629461366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8372	1715629461366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629462368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629462368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8372	1715629462368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629468401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629473424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629475435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629476439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629483452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629484450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629485455	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629486459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629730087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629735074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629735074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2922	1715629735074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629736077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629736077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2922	1715629736077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629737079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629737079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2922	1715629737079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629741089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629741089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629741089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629746103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629746103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629746103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629747105	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629747105	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629747105	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629754124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629754124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629754124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629755127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629440306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629440306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629440306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629442313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629442313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629442313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629443316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629443316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629443316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629444319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629444319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629444319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629445321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629445321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629445321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629446324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629446324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8354000000000001	1715629446324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107	1715629450334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.6	1715629450334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8363	1715629450334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107	1715629455348	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629455348	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8369000000000002	1715629455348	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629465377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629465377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8386	1715629465377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629466380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629466380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8386	1715629466380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629467382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629467382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.839	1715629467382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629469388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629469388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.839	1715629469388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629470390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629470390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.1425	1715629470390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629471393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629471393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.1425	1715629471393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629472396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629472396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.1425	1715629472396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629474422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629482441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629732092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715629738082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629738082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629738082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629740087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629740087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629740087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629748126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629749137	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629750138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629752146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629753141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629768179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629769190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629777183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629777183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2938	1715629777183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629441310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629441310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8362	1715629441310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629449331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629449331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8363	1715629449331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629456352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629456352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8369000000000002	1715629456352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629460363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629460363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.837	1715629460363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	109	1715629464374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.6	1715629464374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8386	1715629464374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629472414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629479442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629733086	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629739113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629748108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629748108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629748108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629749110	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629749110	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629749110	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629750114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629750114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629750114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629752119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629752119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629752119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629753122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629753122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629753122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629765153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629765153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629765153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629769162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629769162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629769162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629770197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629777200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629778212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629784200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629784200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2921	1715629784200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629785202	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629785202	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2921	1715629785202	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629910523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629910523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2976	1715629910523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629916541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629916541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629916541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629917543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629917543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629917543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629918570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629921584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629931603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629932607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629934619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629947624	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629446340	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629451336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629451336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8363	1715629451336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629462392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629463404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629477433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629478439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629480446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629481445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629487457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629734099	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629742092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715629742092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629742092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629743094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629743094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629743094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629751116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629751116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629751116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629756130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629756130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2904	1715629756130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629761168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629762171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629763165	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629764179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629911525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629911525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2976	1715629911525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629918546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629918546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2989	1715629918546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629927595	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629933616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629938601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629938601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629938601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629939625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629954670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629955673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629956679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629959682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629964696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629971715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629981740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629982744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630003774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630003774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.302	1715630003774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630007783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630007783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630007783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630008785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715630008785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3022	1715630008785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630009790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630009790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3022	1715630009790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630010792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630010792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3022	1715630010792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630011795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629448356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629451358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629463372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629463372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	1.8372	1715629463372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629477409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629477409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629477409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629478412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629478412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3688000000000002	1715629478412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629480417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629480417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3676999999999997	1715629480417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629481419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629481419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3676999999999997	1715629481419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629487435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629487435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3695999999999997	1715629487435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629488437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629488437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629488437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629488467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629489439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629489439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629489439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629489466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629490442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629490442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629490442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629490469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629491446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629491446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.372	1715629491446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629491471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629492448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629492448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.372	1715629492448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629492472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629493450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629493450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.372	1715629493450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629493470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629494452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.999999999999999	1715629494452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.37	1715629494452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629494473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629495454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629495454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.37	1715629495454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629495480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629496457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629496457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.37	1715629496457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629496484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629497459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629497459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3712	1715629497459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629497486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629498461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629498461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3712	1715629498461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629498482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629499464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629499464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3712	1715629499464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629514500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629514500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629514500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629520514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629520514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2756	1715629520514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629526529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629526529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2769	1715629526529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629531541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629531541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2771	1715629531541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629533570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629534578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629535576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629546606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629739084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629739084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629739084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629742124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629743114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629751144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629756156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629762146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629762146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2910999999999997	1715629762146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629763148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629763148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2910999999999997	1715629763148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629764150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629764150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2910999999999997	1715629764150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629911553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629927575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629927575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2979000000000003	1715629927575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629933589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629933589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629933589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629935617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629939603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629939603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2964	1715629939603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629954642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629954642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629954642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629955645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.4	1715629955645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629955645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629956647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629956647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629956647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629959654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629959654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629959654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629964667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629964667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629964667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629971688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629971688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715629971688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629499496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629514520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629520542	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629526555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629531571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629534549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629534549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2783	1715629534549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629535552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.999999999999999	1715629535552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2783	1715629535552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629546580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629546580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2781	1715629546580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629755127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2925	1715629755127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629757132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629757132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2904	1715629757132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629758135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629758135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2904	1715629758135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629759138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629759138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2870999999999997	1715629759138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715629760140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629760140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2870999999999997	1715629760140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629765175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629766183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629767186	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629770166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629770166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2914	1715629770166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629774204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629775205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629776206	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629779215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629781216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629787207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629787207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931999999999997	1715629787207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629912528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629912528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629912528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629913530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629913530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629913530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629920551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629920551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2989	1715629920551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629922558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629922558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715629922558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629924567	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629924567	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629924567	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629925569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629925569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629925569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629926572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629926572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629926572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629928600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629500466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629500466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629500466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629510489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629510489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629510489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629515528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629527561	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629532564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629778185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629778185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2938	1715629778185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629783222	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629784226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629785227	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629912548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629913547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629920572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629922586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629924594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629925596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629926607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629929580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629929580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2979000000000003	1715629929580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629930582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715629930582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629930582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629936596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629936596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629936596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629937598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629937598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629937598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629938620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629944642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629945647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629960683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629962688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629963690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629974725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629979740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629986754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629987757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629989735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715629989735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.301	1715629989735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629993747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629993747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629993747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629995752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715629995752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629995752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630000765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630000765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715630000765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630001768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630001768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715630001768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630002770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630002770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.302	1715630002770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630004776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630004776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629500494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629515502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629515502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2752	1715629515502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629527531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629527531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.276	1715629527531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629532544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629532544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2771	1715629532544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629783197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629783197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2921	1715629783197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629787226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629929600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629930602	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629936619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629937615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629944616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629944616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629944616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629945619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629945619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2962	1715629945619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629951726	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629962663	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.399999999999999	1715629962663	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629962663	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629963664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629963664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629963664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629974697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629974697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629974697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629979710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629979710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2992	1715629979710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629986728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629986728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715629986728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629987730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629987730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.301	1715629987730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629988733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715629988733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.301	1715629988733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629989763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629993774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629995781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630000794	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630001797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630002797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630004802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630015830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630024845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630025862	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630026833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630026833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3013000000000003	1715630026833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630026859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630033850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630033850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011	1715630033850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630035883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629501469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629501469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629501469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629503473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629503473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3725	1715629503473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629504475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629504475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3725	1715629504475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629505477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629505477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3725	1715629505477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629510518	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629513515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629516531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629517533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629518534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629521542	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629522546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629523541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629524548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629525554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629528553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629530566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629536554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.6	1715629536554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629536554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629537575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629543600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629544605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629788210	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629788210	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2931999999999997	1715629788210	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629790214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629790214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629790214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629797264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629801245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629801245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629801245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629808262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629808262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629808262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629809297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629820321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629824331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629828339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629829338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629833329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629833329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629833329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629842352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.3	1715629842352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2954	1715629842352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629947624	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2962	1715629947624	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629948626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629948626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2981	1715629948626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629952636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629952636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629952636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	111	1715629953639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.1	1715629953639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629501501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629503496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629504502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629508485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629508485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2719	1715629508485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629513497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629513497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629513497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629516505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629516505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2752	1715629516505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629517507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629517507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2752	1715629517507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629518509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629518509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2756	1715629518509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629521516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629521516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629521516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629522519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629522519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629522519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629523521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629523521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629523521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629524524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629524524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2769	1715629524524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629525526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629525526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2769	1715629525526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629528534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629528534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.276	1715629528534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629530538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629530538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2771	1715629530538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629533546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629533546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2783	1715629533546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629536581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715629543572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629543572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629543572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629544575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629544575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629544575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629788238	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629797235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629797235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2905	1715629797235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629799270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629801270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629809264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629809264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629809264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629820295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629820295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629820295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629824304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629824304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2952	1715629824304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629502471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629502471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3716	1715629502471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629505507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629506507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629507509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629509487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629509487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629509487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629511492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629511492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629511492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629512494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715629512494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2759	1715629512494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629519511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629519511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2756	1715629519511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629529536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629529536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.276	1715629529536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629537557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629537557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629537557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629538583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629539588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629540590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629541597	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629542590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629545602	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629547602	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629789212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629789212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629789212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629793223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629793223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629793223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629795230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629795230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2905	1715629795230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629796261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629802273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629803275	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629807287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629810267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629810267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629810267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629811270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629811270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629811270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629813276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629813276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629813276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629825307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629825307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629825307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629826309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629826309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629826309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629827312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629827312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629827312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629831351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629834360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629502502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629506479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629506479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2719	1715629506479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629507482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629507482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2719	1715629507482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629508505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629509512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629511516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629512520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629519537	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629529569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629538560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629538560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629538560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629539562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629539562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796999999999996	1715629539562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629540565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629540565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796999999999996	1715629540565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629541568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629541568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796999999999996	1715629541568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629542570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629542570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629542570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629545577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.799999999999999	1715629545577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2781	1715629545577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715629547582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629547582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2781	1715629547582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629548584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.199999999999999	1715629548584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629548584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629548613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629549588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629549588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629549588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629549614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629550590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629550590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629550590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629550618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629551593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629551593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629551593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629551622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629552595	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629552595	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629552595	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629552626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629553597	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629553597	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2796	1715629553597	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629553615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629554600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629554600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629554600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629554627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629555605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629555605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629555605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629555637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629556635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629557638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629559615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629559615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.281	1715629559615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629560642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629561620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629561620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2818	1715629561620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629562622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629562622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2818	1715629562622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629565658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629569639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629569639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2816	1715629569639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629570667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629571643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629571643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2816	1715629571643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629573648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629573648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2826999999999997	1715629573648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629574650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629574650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2826999999999997	1715629574650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629575652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629575652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2821	1715629575652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629576654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629576654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2821	1715629576654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629577657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629577657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2821	1715629577657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629578685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629581693	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629583697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629588711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629591710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629594717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629595724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629596724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629597729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629598728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629601737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629602748	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629604755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629606756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629789238	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629793243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629796232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629796232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2905	1715629796232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629802247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629802247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629802247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629803250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629803250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629803250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629807259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629807259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629556607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629556607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629556607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629560617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715629560617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2818	1715629560617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629565629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629565629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629565629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629570641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629570641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2816	1715629570641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629578659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629578659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629578659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629581667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629581667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2815	1715629581667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629591690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629591690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2842	1715629591690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629595701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629595701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2843	1715629595701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629597707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629597707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2851999999999997	1715629597707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629598709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629598709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2851999999999997	1715629598709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629601717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629601717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629601717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629602720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629602720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2856	1715629602720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629604724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629604724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2856	1715629604724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629790242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629791245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629792247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629798259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629800242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629800242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629800242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629812273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629812273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629812273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629814279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629814279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629814279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629817286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629817286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2939000000000003	1715629817286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629818290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629818290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2939000000000003	1715629818290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629819292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629819292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629819292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629821297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629821297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629821297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629557611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629557611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.281	1715629557611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629558636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629559640	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629561644	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629562647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629569668	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629571669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629573674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629574683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629575671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629576682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629583671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629583671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2815	1715629583671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629588683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629588683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629588683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629594699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629594699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2843	1715629594699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629596704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629596704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2851999999999997	1715629596704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629606731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.700000000000001	1715629606731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2863	1715629606731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629791216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629791216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629791216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629792219	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629792219	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629792219	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629795255	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629799239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629799239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629799239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629800272	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629812299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629814307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629817310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629818317	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629819319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629821323	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629822325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629823327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629831325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629831325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629831325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629832342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629837370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629838361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629839370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629840370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629841378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629843383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629953639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629957649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629957649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629957649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629958652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629958652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629958652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629960656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629558613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629558613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.281	1715629558613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629563649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629564657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629567654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629580665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629580665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629580665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629590717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629593715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629599731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629600735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629603742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629794225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629794225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629794225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629798237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629798237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629798237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629804278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629805280	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629806287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629815307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629816310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629836362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629844386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629845386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629960656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629960656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629961682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629965691	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629966701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629967702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629968706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629975724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629978729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629980741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629984749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629991768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629992771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629994779	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629996781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629997862	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629998787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630005805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630012797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630012797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971999999999997	1715630012797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630021820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630021820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630021820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630023825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630023825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3015	1715630023825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630028838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630028838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3013000000000003	1715630028838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630030843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630030843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630030843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630035857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630035857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630035857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630036879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629563625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629563625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629563625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629564627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629564627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2798000000000003	1715629564627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629567634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629567634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2813000000000003	1715629567634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629577685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629580695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629593697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629593697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2843	1715629593697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629599711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629599711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629599711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629600714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629600714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629600714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629603722	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629603722	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2856	1715629603722	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629794260	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629804252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629804252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629804252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629805254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629805254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629805254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629806257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629806257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2950999999999997	1715629806257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629815282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629815282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2948000000000004	1715629815282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629816284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629816284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2939000000000003	1715629816284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629836337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629836337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629836337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629844358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629844358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2937	1715629844358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629845360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629845360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2937	1715629845360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629961659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629961659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629961659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629965670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629965670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629965670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629966674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629966674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629966674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629967677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629967677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629967677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629968679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629968679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2973000000000003	1715629968679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629975699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629566631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629566631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2813000000000003	1715629566631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629568636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629568636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2813000000000003	1715629568636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629572646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629572646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2826999999999997	1715629572646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629579662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715629579662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629579662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629582669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629582669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2815	1715629582669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629584673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629584673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629584673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629585676	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629585676	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629585676	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629586678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629586678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2836999999999996	1715629586678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629587680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629587680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629587680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629589685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629589685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629589685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629590688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629590688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2842	1715629590688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629592714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629605748	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629607753	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.294	1715629807259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629808281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629810300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629811292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629813297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629825332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629826337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629827330	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629834332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629834332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629834332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629835334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629835334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2946999999999997	1715629835334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629846362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.1	1715629846362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629846362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629847365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629847365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629847365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629970686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715629970686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629972692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629972692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629972692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629973694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629973694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2995	1715629973694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629566662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629568675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629572664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629579685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629582694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629584703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629585704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629586701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629587705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629589712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629592694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629592694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2842	1715629592694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629605729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629605729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2863	1715629605729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629607735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629607735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2863	1715629607735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629608737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629608737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629608737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629608762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629609739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629609739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629609739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629609767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629610741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715629610741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629610741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629610761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629611744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629611744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629611744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629611761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629612747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629612747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629612747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629612769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629613752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629613752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629613752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629613780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629614754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629614754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2875	1715629614754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629614782	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629615757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629615757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2875	1715629615757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629615786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629616760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629616760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2875	1715629616760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629616780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629617762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629617762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629617762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629617781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629618764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629618764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629618764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629618785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629619766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629619766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2829	1715629619766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629623777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629623777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629623777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629624780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629624780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629624780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629625783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629625783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629625783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629626785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629626785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629626785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629630824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629636835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629637836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629639834	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629641822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629641822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629641822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629646835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629646835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876999999999996	1715629646835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629648864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629665912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629666915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629822299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629822299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2952	1715629822299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629823301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629823301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2952	1715629823301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629830322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629830322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629830322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629832327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.399999999999999	1715629832327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2918000000000003	1715629832327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629837339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629837339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629837339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629838341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629838341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629838341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629839344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629839344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629839344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629840346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629840346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2954	1715629840346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629841349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629841349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2954	1715629841349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629843355	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629843355	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2937	1715629843355	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629975699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2984	1715629975699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629978708	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629978708	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2992	1715629978708	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629980713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629980713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629619787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629623796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629624808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629625808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629626813	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629636807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629636807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876	1715629636807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629637810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629637810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876	1715629637810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629639817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629639817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629639817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715629640820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715629640820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629640820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629641840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629648842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629648842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2865	1715629648842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629665885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629665885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629665885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629666888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629666888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629666888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629828314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629828314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629828314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629829320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629829320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629829320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629830350	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629833358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629842376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629976702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629976702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2984	1715629976702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629977706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629977706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2984	1715629977706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629983720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629983720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3005	1715629983720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629985724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629985724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715629985724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629990737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715629990737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629990737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107.9	1715629999763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629999763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629999763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630006799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630013825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630018812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630018812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2986999999999997	1715630018812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630020817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630020817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630020817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630022823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630022823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629620769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629620769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2849	1715629620769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629621771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629621771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2849	1715629621771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629631797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629631797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2879	1715629631797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629634803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715629634803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629634803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629635805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629635805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876	1715629635805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629642857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629645833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629645833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876999999999996	1715629645833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629651851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629651851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.287	1715629651851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629655860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629655860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2848	1715629655860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629656863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629656863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629656863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629661874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629661874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629661874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629663881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629663881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629663881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629835356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629846390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629847393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2992	1715629980713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629984723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629984723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715629984723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629991739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715629991739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629991739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629992742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715629992742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629992742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629994750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629994750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2998000000000003	1715629994750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629996755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629996755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629996755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629997757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715629997757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629997757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629998760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629998760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715629998760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630005778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630005778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630005778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630006780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630006780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629620791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629621795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629631825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629634829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629635828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629644856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629645858	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629651879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629655888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629656890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629661900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629663909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629848367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629848367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629848367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629849371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629849371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629849371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629850373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629850373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629850373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629854382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629854382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2958000000000003	1715629854382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629857390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629857390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2953	1715629857390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629858422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629859421	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629860415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629861431	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629868443	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629869445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629870447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629877460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629882474	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629885486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629895512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629907534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629981715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715629981715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3005	1715629981715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629982718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629982718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3005	1715629982718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629988761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630003794	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630007812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630008812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630009815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630010821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630011823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630014829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630016824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630019814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630019814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2986999999999997	1715630019814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630027836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630027836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3013000000000003	1715630027836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630028857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630030870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630036860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630036860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630036860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629622774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629622774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2849	1715629622774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629632799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629632799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629632799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629646852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629647860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629649876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629650874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629654877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629658891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629659895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629662898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629848394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629849400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629850400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629854411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629858393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629858393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956	1715629858393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629859395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629859395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956	1715629859395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629860397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629860397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956	1715629860397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629861399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629861399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.296	1715629861399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629868418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629868418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.293	1715629868418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629869420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629869420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.293	1715629869420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629870422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629870422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629870422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629877440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.1	1715629877440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629877440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629880448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	4.3	1715629880448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965999999999998	1715629880448	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629885460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629885460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629885460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629895485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629895485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629895485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629907516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629907516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2943000000000002	1715629907516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.302	1715630004776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630015805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630015805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715630015805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630024828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630024828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3015	1715630024828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630025831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630025831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3015	1715630025831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629622796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629632821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629647837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629647837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2865	1715629647837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629649846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629649846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2865	1715629649846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629650849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629650849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.287	1715629650849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629654857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629654857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2848	1715629654857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629658866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629658866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629658866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629659869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629659869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629659869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629662877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629662877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629662877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629851376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.399999999999999	1715629851376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2944	1715629851376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629852378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629852378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2958000000000003	1715629852378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629856388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629856388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2953	1715629856388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629865410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629865410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965	1715629865410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629866413	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.1	1715629866413	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965	1715629866413	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629873430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629873430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2959	1715629873430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629874458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629876466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629882452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715629882452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629882452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629893505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629894515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629898516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629900523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629902503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629902503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629902503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	112	1715629904507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629904507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2945	1715629904507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629906512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629906512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2943000000000002	1715629906512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630006780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630012822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630021845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630023857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630029840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629627787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629627787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629627787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629628790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.7	1715629628790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2862	1715629628790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629629793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629629793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2879	1715629629793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629630795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629630795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2879	1715629630795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629633821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629638836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629642824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629642824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629642824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629643847	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629652853	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629652853	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.287	1715629652853	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629653855	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629653855	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2848	1715629653855	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629657864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629657864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2847	1715629657864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629660872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629660872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629660872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629664883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629664883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629664883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629851403	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629852398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629856414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629865438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629866441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629873454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629876437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629876437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629876437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629880477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629893480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629893480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2968	1715629893480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629894482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629894482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629894482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629898493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629898493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629898493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629900497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629900497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629900497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629901500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629901500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629901500	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629902522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629904539	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630011795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971999999999997	1715630011795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630014802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630014802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629627808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629628820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629629821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629633802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629633802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629633802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629638812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629638812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2861	1715629638812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629640849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629643827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629643827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2866	1715629643827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629644830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629644830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2876999999999996	1715629644830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629652876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629653881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629657892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629660901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629664907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629667891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629667891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629667891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629667909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629668896	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629668896	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629668896	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629668924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629669900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629669900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629669900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629669921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629670902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629670902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2893000000000003	1715629670902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629670928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629671904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629671904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.288	1715629671904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629671933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629672906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629672906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.288	1715629672906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629672923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629673908	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629673908	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.288	1715629673908	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629673927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715629674911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629674911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2878000000000003	1715629674911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629674939	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629675913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1	1715629675913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2878000000000003	1715629675913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629675942	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629676916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629676916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2878000000000003	1715629676916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629676944	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629677918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629677918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2896	1715629677918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629677935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629679949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629680956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629686942	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629686942	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629686942	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629695967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629695967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2883	1715629695967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629708018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629709023	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629712032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629715044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629716048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629720035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629720035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2912	1715629720035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629721037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629721037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2912	1715629721037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629724073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629725074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629853379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629853379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2958000000000003	1715629853379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629855386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629855386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2953	1715629855386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629857410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629867415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629867415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.293	1715629867415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629871425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629871425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629871425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629872427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629872427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629872427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629874432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629874432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2959	1715629874432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629875463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629879445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629879445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965999999999998	1715629879445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629883455	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629883455	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629883455	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629884458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715629884458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.295	1715629884458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629890472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629890472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629890472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629899495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.2	1715629899495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629899495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629903505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629903505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2945	1715629903505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715630014802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630016807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630016807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715630016807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629678921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629678921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2896	1715629678921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629681931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629681931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629681931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629684938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629684938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629684938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629685940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.9	1715629685940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629685940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629688976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629690981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629704993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715629704993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629704993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629705995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629705995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629705995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629706997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629706997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629706997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629723041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715629723041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2844	1715629723041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629853397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629855411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629863404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629863404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.296	1715629863404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629867434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629871450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629872445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629875435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629875435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2959	1715629875435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629878464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629879471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629883483	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629884487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629890498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629899526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629903533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630017809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630017809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2986999999999997	1715630017809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630019845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630027857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630029840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630029840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630031845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630031845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630031845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630032848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630032848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011	1715630032848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630034880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630037886	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630038893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630039895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630040899	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630043877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630043877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629678948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629679923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.7	1715629679923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2896	1715629679923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629680926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629680926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629680926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629681962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629684962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629685963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629686968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629688949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.300000000000001	1715629688949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629688949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629690955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629690955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2874	1715629690955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629696051	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629703019	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629705022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629706021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629707027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629709003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629709003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906999999999997	1715629709003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629712010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629712010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629712010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629715018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629715018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629715018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629716022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629716022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629716022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629719063	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629720064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629723060	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629724044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629724044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2844	1715629724044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629725046	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629725046	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2844	1715629725046	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629862402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629862402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.296	1715629862402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629863429	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629864438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629881450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629881450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965999999999998	1715629881450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629886463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629886463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629886463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629887465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629887465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629887465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629888467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629888467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629888467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629889470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629889470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2956999999999996	1715629889470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629891475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629682933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629682933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2908000000000004	1715629682933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629683936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629683936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906	1715629683936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629689978	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629691984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629692981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629693990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629694994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629697000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629714038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629717052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629718049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629721068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629722066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629862421	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629864408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629864408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2965	1715629864408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629878442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629878442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2949	1715629878442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629881478	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629886490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629887483	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629888497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629889495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629891507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629892508	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629896513	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629897508	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629905510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629905510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2945	1715629905510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629906542	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630020844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630022841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630029867	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630031873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630034854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630034854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011	1715630034854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630037864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630037864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630037864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630038867	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630038867	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3032	1715630038867	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630041873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630041873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026	1715630041873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630042874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630042874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026	1715630042874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026	1715630043877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630044907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630045883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630045914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630046884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630046884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630046884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630046978	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630047887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629682963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629689952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629689952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2874	1715629689952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629691957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629691957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2874	1715629691957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629692960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629692960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629692960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629693963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629693963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629693963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629694965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629694965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2872	1715629694965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629696971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.9	1715629696971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2883	1715629696971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629714015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629714015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629714015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629717026	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.799999999999999	1715629717026	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2902	1715629717026	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629718029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629718029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2902	1715629718029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629719032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629719032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2902	1715629719032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629722039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629722039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2912	1715629722039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629891475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2968	1715629891475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107	1715629892477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.899999999999999	1715629892477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2968	1715629892477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629896487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629896487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2941	1715629896487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629897490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629897490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629897490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629901532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629905540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3002	1715630022823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630032867	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630033869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630039869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630039869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3032	1715630039869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630040871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630040871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3032	1715630040871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630041904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630042899	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630043910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630044880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630044880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630044880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630045883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630045883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629683963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629687966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629698000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629699005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629700005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629701008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629702015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629703990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629703990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2889	1715629703990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629708000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629708000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906999999999997	1715629708000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629710033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629711036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629713039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629726074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629727080	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629908518	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629908518	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2943000000000002	1715629908518	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629909553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629914559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629915568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629919566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629923592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629940605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.1	1715629940605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2964	1715629940605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629941607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629941607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2964	1715629941607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629942612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629942612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629942612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629943614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629943614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2955	1715629943614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629946622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629946622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2962	1715629946622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629949629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629949629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2981	1715629949629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629950631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.4	1715629950631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2981	1715629950631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629951633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629951633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2975	1715629951633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629969708	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629970715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629972718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629973714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629976727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629977734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629983743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629985750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629990765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629999791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630013799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630013799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971999999999997	1715630013799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630017830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630018836	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629687945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.700000000000001	1715629687945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.291	1715629687945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107.9	1715629697973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629697973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2883	1715629697973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629698975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629698975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2888	1715629698975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629699980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715629699980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2888	1715629699980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629700982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629700982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2888	1715629700982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629701985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715629701985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2889	1715629701985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629702988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629702988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2889	1715629702988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629704015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715629710005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	15.600000000000001	1715629710005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2906999999999997	1715629710005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629711008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629711008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629711008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629713013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715629713013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2899000000000003	1715629713013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629726049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7	1715629726049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2882	1715629726049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715629727052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.3	1715629727052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2882	1715629727052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629908549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629914533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629914533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2983000000000002	1715629914533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629915538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715629915538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2978	1715629915538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629919548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.899999999999999	1715629919548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2989	1715629919548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629923563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629923563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2999	1715629923563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715629928577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715629928577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2979000000000003	1715629928577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629940626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629941636	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629942633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629943642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629946644	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629949656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715629950658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715629969683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.1000000000000005	1715629969683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715629969683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715629970686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630047887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971	1715630047887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630051926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630052920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630057934	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630058944	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630060954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630062946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630063957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630069948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630069948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630069948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630076965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630076965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630076965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630084984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630084984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715630084984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630086989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630086989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3016	1715630086989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630098017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630098017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051	1715630098017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630099022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630099022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051	1715630099022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630100049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630106066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630113080	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630114089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630115094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630116093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630124113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630128116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630132131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630141157	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630143167	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630146169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630148149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630148149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3061	1715630148149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630154184	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630155194	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630156195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630157193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630158201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630159195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630160211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630161212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630164215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630165222	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630167224	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630170234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630171211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630171211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630171211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630172213	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630172213	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630172213	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630173215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630173215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630173215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630174218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630174218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630047910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630052901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630052901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715630052901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630057915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715630057915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026999999999997	1715630057915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630058917	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630058917	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026999999999997	1715630058917	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630060922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630060922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630060922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630062927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630062927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715630062927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630063930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630063930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715630063930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630064935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630064935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3011999999999997	1715630064935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630069978	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630076990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630085000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630087017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630098044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630099050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630106039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630106039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630106039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630113059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630113059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630113059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630114062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630114062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630114062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630115065	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630115065	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630115065	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630116068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630116068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630116068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630124087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630124087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3036	1715630124087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630128096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630128096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051999999999997	1715630128096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630132106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630132106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3058	1715630132106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630137122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630137122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3094	1715630137122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630143136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630143136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630143136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630146143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630146143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3061	1715630146143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630148176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630157172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630157172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	110	1715630048890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630048890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971	1715630048890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630050895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630050895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715630050895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630053904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630053904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630053904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630055941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630056941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630065964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630066968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630072979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630073984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630074986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630077985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630078996	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630082003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630088994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630088994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3016	1715630088994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630094007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630094007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630094007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630102029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630102029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3059000000000003	1715630102029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630109048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630109048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630109048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630120076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630120076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3025	1715630120076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630122082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630122082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3036	1715630122082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630126091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630126091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3053000000000003	1715630126091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630130101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630130101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051999999999997	1715630130101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630131104	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630131104	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3058	1715630131104	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630133112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630133112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3058	1715630133112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630136120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630136120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630136120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630141131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630141131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630141131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630144168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630145164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630149151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630149151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3072	1715630149151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630150154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630150154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3072	1715630150154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630151156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630048916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630050929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630053931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630056912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630056912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3026999999999997	1715630056912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630065938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630065938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3033	1715630065938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630066940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630066940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3033	1715630066940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630072955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630072955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630072955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630073957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715630073957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630073957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630074960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630074960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630074960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630077967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630077967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630077967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630078970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630078970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630078970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630081977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630081977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630081977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630082979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630082979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630082979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630089020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630094037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630102054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630109078	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630120102	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630122113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630126118	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630130127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630131131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630133139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630136145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630144138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630144138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630144138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630145141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630145141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630145141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630147146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630147146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3061	1715630147146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630149181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630150182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630151183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.305	1715630157172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630159178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630159178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630159178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630160180	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630160180	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630160180	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630161183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630049892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630049892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2971	1715630049892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630059920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630059920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630059920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630061924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630061924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3014	1715630061924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630067943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630067943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3033	1715630067943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630071952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630071952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630071952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630075962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630075962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630075962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630080974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630080974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3042	1715630080974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630086015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630090025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630092029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630093030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630095033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630096041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630097043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630101055	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630103057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630108067	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630111087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630117092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630121105	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630134141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630135146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630138124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630138124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3094	1715630138124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630142133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630142133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630142133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630151156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3072	1715630151156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630154164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630154164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630154164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630161183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3065	1715630161183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630163214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630164190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630164190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3063000000000002	1715630164190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630165193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630165193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3063000000000002	1715630165193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630166220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630174218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630175220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630175220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630175220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630175248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630176223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630176223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630049919	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630059945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630061953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630067960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630071972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630075987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630080998	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630089997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630089997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2994	1715630089997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630092002	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630092002	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2994	1715630092002	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630093006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630093006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630093006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630095010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630095010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996999999999996	1715630095010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630096012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630096012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051	1715630096012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630097014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630097014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051	1715630097014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630101027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630101027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3059000000000003	1715630101027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630103032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630103032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3059000000000003	1715630103032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630108045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630108045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630108045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630111053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630111053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630111053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630117070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630117070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630117070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630121079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630121079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3025	1715630121079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630134114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630134114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630134114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630135117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630135117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630135117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630137152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630138151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630142151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630152159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630152159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630152159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630153162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630153162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630153162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630162185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630162185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3065	1715630162185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630163188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630163188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3065	1715630163188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630051898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630051898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2996	1715630051898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630054934	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630064962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630068974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630070977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630079998	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630083982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630083982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715630083982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630085987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630085987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2985	1715630085987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630088018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630091027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630104034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630104034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630104034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630105036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630105036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630105036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630107043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630107043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630107043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630110050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630110050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630110050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630112056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630112056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630112056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630118073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630118073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630118073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630119074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630119074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3025	1715630119074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630123084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630123084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3036	1715630123084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630125089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630125089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3053000000000003	1715630125089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630127094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630127094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3053000000000003	1715630127094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630129099	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630129099	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051999999999997	1715630129099	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630139127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630139127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3094	1715630139127	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630140129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630140129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3064	1715630140129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630147166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630152181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630153186	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630162204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630166195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630166195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3063000000000002	1715630166195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630168219	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630169231	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630054906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630054906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630054906	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630055909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13	1715630055909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3007	1715630055909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630068946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630068946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630068946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630070950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630070950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3034	1715630070950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630079972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630079972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630079972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630082996	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630084007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630087992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630087992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3016	1715630087992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630090999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630090999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.2994	1715630090999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630100025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630100025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3051	1715630100025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630104063	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630105061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630107072	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630110079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630112087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630118104	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630119092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630123104	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630125116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630127120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630129128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630139152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630140156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630155167	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630155167	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.305	1715630155167	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630156169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10	1715630156169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.305	1715630156169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630158175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.7	1715630158175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630158175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630167198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630167198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630167198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630168200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715630168200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630168200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630169205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.4	1715630169205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3083	1715630169205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630170208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630170208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3085	1715630170208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630171236	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630172242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630173233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630174246	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.308	1715630176223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630177248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630178254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630180258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630183263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630185272	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630187281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630189277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630193295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630194300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630196305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630204329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630205332	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630207337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630211525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630215397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630216397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630234445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630235451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630236449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630255472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630255472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630255472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630256475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630256475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630256475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630264495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630264495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3119	1715630264495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630628434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630628434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630628434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630639492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630640484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630641493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630644475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715630644475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3278000000000003	1715630644475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630657512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630657512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261	1715630657512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630658514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630658514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261	1715630658514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630659519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630659519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630659519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630660521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630660521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630660521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630662545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630670575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630673556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.600000000000001	1715630673556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630673556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630674588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630679572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630679572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.332	1715630679572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630684583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630684583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630684583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630685586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630685586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630685586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630176252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630178226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630178226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.308	1715630178226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630180232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630180232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630180232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630183242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630183242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630183242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630185248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630185248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630185248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630187253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630187253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630187253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630189258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630189258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.303	1715630189258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630193270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.100000000000001	1715630193270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630193270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630194273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630194273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630194273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630196278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630196278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630196278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630204304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.099999999999998	1715630204304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630204304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630205306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630205306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630205306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630207310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630207310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3084000000000002	1715630207310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630211357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630211357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630211357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630215369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630215369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630215369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630216371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630216371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630216371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630234416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630234416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630234416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630235419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630235419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630235419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630236423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630236423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3089	1715630236423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630254499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630255505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630256501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630628462	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630640464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630640464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630640464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630641467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630641467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630177224	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630177224	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.308	1715630177224	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630179256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630188274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630199315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630201322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630212536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630213378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630214394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630217398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630220409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630226394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630226394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3088	1715630226394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630248454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630248454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3109	1715630248454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630249457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630249457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3109	1715630249457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630250459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630250459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3109	1715630250459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630251461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630251461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630251461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630258508	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630259509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630261505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630263516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630265521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630267526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630629436	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630629436	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630629436	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630631442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630631442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630631442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630648486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630648486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3273	1715630648486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630649489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630649489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3273	1715630649489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630652522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630662526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630662526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.328	1715630662526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630664531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630664531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.328	1715630664531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630671551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630671551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630671551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630672554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630672554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630672554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630677566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630677566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.332	1715630677566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630681602	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630682601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630723684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630179229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	12.8	1715630179229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630179229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630188256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630188256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.303	1715630188256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630199287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630199287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.307	1715630199287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630201293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630201293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3091999999999997	1715630201293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104.9	1715630212360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630212360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3098	1715630212360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	114.8	1715630213362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630213362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3098	1715630213362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	129	1715630214366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630214366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3098	1715630214366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630217373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630217373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630217373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630220379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630220379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630220379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630221417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630226420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630248471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630249485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630250487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630251490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630259481	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630259481	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076	1715630259481	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630261486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630261486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630261486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630263490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630263490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3119	1715630263490	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630265497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630265497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3119	1715630265497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630267502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630267502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630267502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630629465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630631467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630648504	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630649517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630654505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630654505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630654505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630663528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630663528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.328	1715630663528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630664557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630671578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630673584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630681576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630681576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630681576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630181237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630181237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3056	1715630181237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630182240	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630182240	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630182240	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630184244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630184244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630184244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630186250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.5	1715630186250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630186250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630190287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630191292	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630195305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630197315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630202330	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630206334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630208330	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630237452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630238454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630239457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630240460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630241462	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630245471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630252489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630257496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630260484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630260484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630260484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630630439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630630439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630630439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630638461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630638461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630638461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630642469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630642469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3274	1715630642469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630643472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630643472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3274	1715630643472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630645506	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630646507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630653502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630653502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630653502	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630656509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630656509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261	1715630656509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630667538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630667538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630667538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630675562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.3	1715630675562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630675562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630676564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630676564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630676564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630678569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630678569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.332	1715630678569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630723684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3295	1715630723684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630181267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630182268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630184272	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630186277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630191263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630191263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630191263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630195276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630195276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3069	1715630195276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630197281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630197281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.307	1715630197281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630198284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630198284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.307	1715630198284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630206308	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630206308	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3084000000000002	1715630206308	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630208313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630208313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3084000000000002	1715630208313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630237425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630237425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3089	1715630237425	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630238427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630238427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3089	1715630238427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630239430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630239430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630239430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630240433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630240433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630240433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630241435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630241435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630241435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630245444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630245444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3113	1715630245444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630252464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630252464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630252464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630257477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630257477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076	1715630257477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630258479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630258479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076	1715630258479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630260512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630630460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630632472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630633475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630634478	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630636456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630636456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630636456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630637459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630637459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630637459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630639463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630639463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630639463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630647512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630190260	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.2	1715630190260	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.303	1715630190260	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630192293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630200290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630200290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3091999999999997	1715630200290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630202298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630202298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3091999999999997	1715630202298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630203323	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630209343	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630210345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630218392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630219403	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630222384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630222384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630222384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630223387	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630223387	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630223387	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630224389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630224389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3088	1715630224389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630225391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630225391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3088	1715630225391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630227396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630227396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3095	1715630227396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630228398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630228398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3095	1715630228398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630229401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630229401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3095	1715630229401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630230406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630230406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630230406	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630231409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630231409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630231409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630232411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630232411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630232411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630233414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630233414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630233414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630242438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630242438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630242438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630243440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630243440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630243440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630244442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630244442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630244442	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630246447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630246447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3113	1715630246447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630247452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630247452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3113	1715630247452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630253466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630192267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630192267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3066	1715630192267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630198307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630200319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630203301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630203301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3078000000000003	1715630203301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630209316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630209316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630209316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630210318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630210318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630210318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630218375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630218375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630218375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630219377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630219377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630219377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630221382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630221382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3093000000000004	1715630221382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630222408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630223411	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630224420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630225417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630227424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630228418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630229432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630230432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630231437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630232436	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630233432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630242464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630243455	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630244466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630246465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630247478	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630253488	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630262488	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630262488	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3104	1715630262488	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630264520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630266522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630632444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.600000000000001	1715630632444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630632444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630633447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630633447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630633447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630634451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630634451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630634451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630635454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630635454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630635454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630636489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630637485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630647484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715630647484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3273	1715630647484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630650492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630650492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630253466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630253466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630254470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630254470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630254470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630262507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630266499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630266499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630266499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630268504	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630268504	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3103000000000002	1715630268504	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630268532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630269507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630269507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3099000000000003	1715630269507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630269534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630270509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630270509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3099000000000003	1715630270509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630270536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630271512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630271512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3099000000000003	1715630271512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630271542	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630272515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630272515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3106	1715630272515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630272544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630273517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630273517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3106	1715630273517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630273538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630274522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630274522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3106	1715630274522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630274547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630275524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630275524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630275524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630275548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630276526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630276526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630276526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630276552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630277528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630277528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630277528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630277554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630278531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630278531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630278531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630278548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630279533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630279533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630279533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630279555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630280536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.099999999999998	1715630280536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3110999999999997	1715630280536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630280563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630281538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630281538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630281538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630281565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630282566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630288555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630288555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116	1715630288555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630289557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630289557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116	1715630289557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630296576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630296576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076999999999996	1715630296576	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630297578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630297578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076999999999996	1715630297578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630304622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630312642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630314646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630315649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630316648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630321637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630321637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131	1715630321637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630327650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630327650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3141	1715630327650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630328652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630328652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3141	1715630328652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630336675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630336675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3138	1715630336675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630337698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630341715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630344720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630345721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630346725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630355750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630359733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630359733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630359733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630364744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630364744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3145	1715630364744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630377799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630382813	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630635473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630638485	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630642497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630645477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630645477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3278000000000003	1715630645477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630646480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630646480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3278000000000003	1715630646480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630652497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630652497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3270999999999997	1715630652497	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630653523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630656532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630667559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630675588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630676592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630678597	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630724687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630282540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630282540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630282540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630287552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630287552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116	1715630287552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630288584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630289584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630296605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630297608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630312614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630312614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630312614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630314619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630314619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3121	1715630314619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630315621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630315621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3121	1715630315621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630316623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630316623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3121	1715630316623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630320655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630321656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630327676	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630328680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630336702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630341689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630341689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630341689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630344694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630344694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3171	1715630344694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630345697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630345697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3171	1715630345697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630346699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630346699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3171	1715630346699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630355723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630355723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3159	1715630355723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630358730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630358730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630358730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630359762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630364770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630382796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630382796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3186999999999998	1715630382796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3274	1715630641467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630643499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630644496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630657539	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630658545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630659545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630660548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630670546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630670546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630670546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630672585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630674559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630674559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630674559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630283543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630283543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630283543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630303593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630303593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3097	1715630303593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630304596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630304596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3097	1715630304596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630319631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630319631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3134	1715630319631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630325645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630325645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131999999999997	1715630325645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630329680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630335694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630342715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630343720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630349737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630360764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630369757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630369757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146999999999998	1715630369757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630370760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630370760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146999999999998	1715630370760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630371765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630371765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146	1715630371765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630372767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630372767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146	1715630372767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630373772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630373772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146	1715630373772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630376781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630376781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3150999999999997	1715630376781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630380790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630380790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3186999999999998	1715630380790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630384802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630384802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.32	1715630384802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630385837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3270999999999997	1715630650492	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630651495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630651495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3270999999999997	1715630651495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630654530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630655537	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630661547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630665533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630665533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630665533	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630666536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630666536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630666536	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630668541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630668541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630668541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630669544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630669544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630283571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630303619	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630310628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630319651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630325673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630335673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630335673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3138	1715630335673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630342691	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630342691	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630342691	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630343693	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630343693	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630343693	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630349707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630349707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3161	1715630349707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630360735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630360735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630360735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630363763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630369783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630370786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630371790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630372797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630373798	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630376809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630380820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630384829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630650520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630651522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630655507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630655507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630655507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630661523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630661523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3269	1715630661523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630663552	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630665559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630666565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630668567	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630669567	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630680599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630683605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630686588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630686588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630686588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630687590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630687590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630687590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.600000000000001	1715630724687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3295	1715630724687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630725689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630725689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630725689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630726718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630727713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630737736	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630740753	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630741756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630742750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630760779	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630760779	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.331	1715630760779	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630761781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630284545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630284545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630284545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630285547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630285547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630285547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630286550	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630286550	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3087	1715630286550	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630287570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630290583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630291591	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630292582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630300586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630300586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.31	1715630300586	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630302591	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630302591	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3097	1715630302591	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630305598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630305598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630305598	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630309607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630309607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3118000000000003	1715630309607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630310610	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630310610	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3118000000000003	1715630310610	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630311638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630313643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630317651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630326672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630333668	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630333668	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3122	1715630333668	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630337678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630337678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3138	1715630337678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630338705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630356725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630356725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630356725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630361738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630361738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3173000000000004	1715630361738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630362741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630362741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3145	1715630362741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630363743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630363743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3145	1715630363743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630368782	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630374802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630375803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630386807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630386807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630386807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630387809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630387809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630387809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3284000000000002	1715630669544	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630680574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630680574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630680574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630284571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630285578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630286577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630290559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630290559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3123	1715630290559	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630291561	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630291561	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3123	1715630291561	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630292563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630292563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3123	1715630292563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630298608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630300613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630302617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630305623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630309633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630311612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630311612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630311612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630313617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630313617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3102	1715630313617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630317626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630317626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3134	1715630317626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630326648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630326648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3141	1715630326648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630329655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.399999999999999	1715630329655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3125	1715630329655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630333689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630338680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630338680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3167	1715630338680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630354750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630358755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630361764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630362759	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630368754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630368754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3146999999999998	1715630368754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630374774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630374774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3150999999999997	1715630374774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630375777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630375777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3150999999999997	1715630375777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630377783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630377783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3155	1715630377783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630386837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630387827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630677585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630679599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630684610	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630736715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630736715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3283	1715630736715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630738750	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630739748	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630746763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630750777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630293566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630293566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630293566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630294569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630294569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630294569	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630295571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630295571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3073	1715630295571	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630298581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630298581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3076999999999996	1715630298581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630299611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630301614	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630306628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630307630	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630308634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630318648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630322639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.399999999999999	1715630322639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131	1715630322639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630323641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630323641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131999999999997	1715630323641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630324643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630324643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131999999999997	1715630324643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630330658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630330658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3125	1715630330658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630331661	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630331661	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3125	1715630331661	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630332665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630332665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3122	1715630332665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630334670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630334670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3122	1715630334670	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630339682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630339682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3167	1715630339682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630340686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630340686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3167	1715630340686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630347702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630347702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3161	1715630347702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630348704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630348704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3161	1715630348704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630350710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630350710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630350710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630351712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630351712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630351712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630352716	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630352716	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630352716	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630353718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630353718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3159	1715630353718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630354720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630293594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630294596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630295594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630299583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630299583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.31	1715630299583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630301588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630301588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.31	1715630301588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630306600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.099999999999998	1715630306600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630306600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630307603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630307603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3116999999999996	1715630307603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630308605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630308605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3118000000000003	1715630308605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630318628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630318628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3134	1715630318628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630320634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630320634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3131	1715630320634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630322667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630323658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630324671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630330686	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630331688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630332683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630334692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630339707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630340712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630347719	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630348730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630350738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630351737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630352735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630353747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630356749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630357748	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630365776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630366776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630367769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630378811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630379817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630381818	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630383827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630682578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630682578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630682578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630751780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630754761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630754761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630754761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630757768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630757768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3325	1715630757768	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630758797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630763811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630764816	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630777850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630779856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630780857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630781863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630354720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3159	1715630354720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630357728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630357728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3165999999999998	1715630357728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630365747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630365747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3135	1715630365747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630366749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630366749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3135	1715630366749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630367752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630367752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3135	1715630367752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630378785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630378785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3155	1715630378785	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630379787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630379787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3155	1715630379787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630381792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630381792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3186999999999998	1715630381792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630383800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630383800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.32	1715630383800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630385805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630385805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.32	1715630385805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630388811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630388811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630388811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630388839	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630389814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715630389814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.321	1715630389814	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630389833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630390816	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.6	1715630390816	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.321	1715630390816	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630390837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630391819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3	1715630391819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.321	1715630391819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630391843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630392821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630392821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630392821	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630392838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630393824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630393824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630393824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630393846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630394828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630394828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630394828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630394857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630395831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630395831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3198000000000003	1715630395831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630395856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630396833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630396833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3198000000000003	1715630396833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630396862	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630400871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630407861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630407861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630407861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630408866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630408866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630408866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630410871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630410871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3201	1715630410871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630411901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630412901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630415914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630416913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630421923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630430945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630431956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630434968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630438964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630453006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630461004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630461004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630461004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630464011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630464011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630464011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630468038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630469053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630470053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630471055	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630472057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630473052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630474064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630478047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630478047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630478047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630483059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630483059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3214	1715630483059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630486094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630502139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630504143	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630683581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630683581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630683581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630685613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630686620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630687610	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630758771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630758771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.331	1715630758771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630763786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630763786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3272	1715630763786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630764789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630764789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3291999999999997	1715630764789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630778827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630778827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630778827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630782856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630784868	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630785845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630785845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630397838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630397838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3198000000000003	1715630397838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630403852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630403852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.319	1715630403852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630404854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630404854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3228	1715630404854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630422900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630422900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3195	1715630422900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630426936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630428950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630435962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630440979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630443987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630444986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630447000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630449998	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630451002	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630454987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630454987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630454987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630455990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630455990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630455990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630456992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630456992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630456992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630458997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630458997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630458997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630463008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630463008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630463008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630475038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630475038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3196999999999997	1715630475038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630476073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630484062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630484062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3214	1715630484062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630489077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630489077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630489077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630490079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630490079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630490079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630494089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630494089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630494089	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630495092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630495092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630495092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630496094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630496094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3239	1715630496094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630497098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630497098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3241	1715630497098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630498100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630498100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3241	1715630498100	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630397864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630403879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630404880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630426909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630426909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630426909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630428919	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630428919	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3181	1715630428919	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630435938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630435938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630435938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630440950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630440950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3194	1715630440950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630443958	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630443958	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3205	1715630443958	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630444960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630444960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3205	1715630444960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630446968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630446968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630446968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630449974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630449974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630449974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630450977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630450977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630450977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630454010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630455014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630456014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630457017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630459025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630463035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630476041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630476041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630476041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630477069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630484087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630489095	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630490106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630494116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630495120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630496120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630497124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630498119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630500106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630500106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3236	1715630500106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630503113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630503113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630503113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630507146	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630688593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630688593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630688593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630689596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630689596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630689596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630691633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630694637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630695638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630398841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630398841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630398841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630401874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630402876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630409869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630409869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630409869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630411874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630411874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3201	1715630411874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630418889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630418889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630418889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630419892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630419892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3183000000000002	1715630419892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630422920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630423931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630429922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630429922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3181	1715630429922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630432929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630432929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630432929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630433958	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630436970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630437974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630439976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630441981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630442979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630452008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630466045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630487098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630492111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630493112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630506151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630688617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630689625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630694608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630694608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630694608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630695611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630695611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630695611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630697616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630697616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630697616	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630698618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630698618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3297	1715630698618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630701627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630701627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630701627	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630705638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630705638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306	1715630705638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630706640	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630706640	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306	1715630706640	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630707643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630707643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630707643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630711681	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630398860	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630402850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630402850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.319	1715630402850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630405856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630405856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3228	1715630405856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630409900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630417907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630418916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630419909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630423903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630423903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3195	1715630423903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630424905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630424905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3195	1715630424905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630429947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630433932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630433932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630433932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630436941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630436941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630436941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630437943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630437943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3179000000000003	1715630437943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630439947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630439947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3179000000000003	1715630439947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630441953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630441953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3194	1715630441953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630442955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630442955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3194	1715630442955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630451979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630451979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630451979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630466017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630466017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3236999999999997	1715630466017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630487072	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630487072	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3216	1715630487072	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630492084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630492084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3244000000000002	1715630492084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630493087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630493087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3244000000000002	1715630493087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630506120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630506120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630506120	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	107	1715630690599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630690599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630690599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630691601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630691601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630691601	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630699645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630702654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630713688	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630717695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630399843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630399843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630399843	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630405881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630406890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630413904	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630414908	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630420922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630424930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630425938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630427935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630445963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630445963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3205	1715630445963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630447970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630447970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630447970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630448972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630448972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3202	1715630448972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630457995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630457995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630457995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630459999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630459999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630459999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630462006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630462006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630462006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630464036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630465040	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630467048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630479050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630479050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630479050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630480052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630480052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630480052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630481054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630481054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630481054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630482057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630482057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3214	1715630482057	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630483077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630485091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630488092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630491109	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630501108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630501108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3236	1715630501108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630503129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630505144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630690625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630699621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715630699621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3297	1715630699621	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630702629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630702629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630702629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630713660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630713660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630713660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630717669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630399869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630406859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630406859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3228	1715630406859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630413878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630413878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630413878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630414881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630414881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630414881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630420894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630420894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3183000000000002	1715630420894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630421897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630421897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3183000000000002	1715630421897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630425907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630425907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630425907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630427914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630427914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630427914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630432956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630445998	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630447991	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630448999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630458014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630460018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630462034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630465013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630465013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3236999999999997	1715630465013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630467020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630467020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630467020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630475064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630479076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630480077	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630481082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630482085	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630485066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630485066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3216	1715630485066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630488074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630488074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630488074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630491082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630491082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3244000000000002	1715630491082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630499103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630499103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3241	1715630499103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630501138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630505117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630505117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630505117	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630692603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630692603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630692603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630693606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630693606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3288	1715630693606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630696613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630696613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630400846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630400846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3203	1715630400846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630401848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630401848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.319	1715630401848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630407880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630408893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630410899	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630412876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630412876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3201	1715630412876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630415883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630415883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3207	1715630415883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630416885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630416885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630416885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630417887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630417887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630417887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630430925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630430925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3181	1715630430925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630431927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630431927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630431927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630434936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630434936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630434936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630438945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630438945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3179000000000003	1715630438945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630452981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630452981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630452981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630453984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630453984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630453984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630461032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630468022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630468022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630468022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630469025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630469025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630469025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630470027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630470027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630470027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630471030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630471030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630471030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630472032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630472032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630472032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630473034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630473034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3196999999999997	1715630473034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630474036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630474036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3196999999999997	1715630474036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630477045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630477045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3185	1715630477045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630478074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630486069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630486069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3216	1715630486069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630502111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630502111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3236	1715630502111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630504115	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630504115	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630504115	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630692632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630693622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630696643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630700650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630709649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715630709649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630709649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630714662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630714662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630714662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630716667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630716667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3305	1715630716667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630722699	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630731703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630731703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3293000000000004	1715630731703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630733707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630733707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3293000000000004	1715630733707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630734710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630734710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3283	1715630734710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630735713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630735713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3283	1715630735713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630743732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630743732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3326	1715630743732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630747742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630747742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3350999999999997	1715630747742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630752756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630752756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630752756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630756794	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630761781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3272	1715630761781	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630765818	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630774815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630774815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316999999999997	1715630774815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630776819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.600000000000001	1715630776819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630776819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630777825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630777825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630777825	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630779829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630779829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3312	1715630779829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630780832	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630780832	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3312	1715630780832	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630499129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630500131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630507122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630507122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630507122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630508125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630508125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630508125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630508150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630509128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630509128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630509128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630509152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630510130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630510130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630510130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630510152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630511133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630511133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3199	1715630511133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630511159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630512137	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630512137	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630512137	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630512163	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630513139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630513139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630513139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630513161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630514142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630514142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3189	1715630514142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630514167	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630515144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630515144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630515144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630515174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630516149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630516149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630516149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630516181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630517151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630517151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630517151	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630517176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630518154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630518154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630518154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630518178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630519156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630519156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630519156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630519185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630520158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630520158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3229	1715630520158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630520191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630521161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630521161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3225	1715630521161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630521182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630522164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630522164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3225	1715630522164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630522180	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630523192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630526192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630528195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630531212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630540233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630545218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630545218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3188	1715630545218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630547223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630547223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3188	1715630547223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630559254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630559254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630559254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630560257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630560257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211999999999997	1715630560257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630563264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630563264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630563264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630568301	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630589334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630589334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3233	1715630589334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630590336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630590336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630590336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630591339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630591339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630591339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630593346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630593346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3245	1715630593346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630594349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630594349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3245	1715630594349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630595351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630595351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3245	1715630595351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630598359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630598359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3242	1715630598359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630599361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630599361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630599361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630602368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630602368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3257	1715630602368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630607407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630610414	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630613427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630614428	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630616433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630620443	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630622447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630623440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630696613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630700623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630700623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3297	1715630700623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630707660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630709677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630714689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630523166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630523166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3225	1715630523166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630526174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630526174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630526174	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630528178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630528178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3253000000000004	1715630528178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630531185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630531185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251999999999997	1715630531185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630540207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630540207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3226	1715630540207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630544244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630545243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630547250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630559280	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630560286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630563291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630573310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630589359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630590363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630591359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630593366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630594374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630595378	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630598386	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630599389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630607380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630607380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3266	1715630607380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630610388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630610388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276999999999997	1715630610388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630613397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630613397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261999999999996	1715630613397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630614400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630614400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630614400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630616405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630616405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630616405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630620415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630620415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3275	1715630620415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630622419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630622419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3275	1715630622419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630623422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630623422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630623422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630697633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630698635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630701657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630705668	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630706671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630711656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630711656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630711656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630722681	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630722681	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630524168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630524168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630524168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630525171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630525171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630525171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630533207	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630534219	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630541228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630546220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630546220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3188	1715630546220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630552236	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630552236	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630552236	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630554241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630554241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630554241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630555244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630555244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630555244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630556247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630556247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630556247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630561261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630561261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211999999999997	1715630561261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630562263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630562263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211999999999997	1715630562263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630569278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630569278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630569278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630570281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630570281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630570281	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630571283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630571283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630571283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630573288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630573288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.326	1715630573288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630579305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630579305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251	1715630579305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630583315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630583315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630583315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630584318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630584318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630584318	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630585320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630585320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630585320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630586325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630586325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3243	1715630586325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630587328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630587328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3233	1715630587328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630588331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630588331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3233	1715630588331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630592342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630524196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630525199	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630527176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630527176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3253000000000004	1715630527176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630527195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630529181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630529181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3253000000000004	1715630529181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630529204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630530183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630530183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251999999999997	1715630530183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630530210	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630533190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630533190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3235	1715630533190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630534192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630534192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3235	1715630534192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630536197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630536197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630536197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630536227	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630537200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630537200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630537200	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630538203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630538203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630538203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630538221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630539205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630539205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3226	1715630539205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630539233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630541209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630541209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3226	1715630541209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630542212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630542212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630542212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630542230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630544216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630544216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630544216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630546244	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630552264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630553239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630553239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630553239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630553265	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630554269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630555272	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630556275	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630561287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630562284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630564266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630564266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630564266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630564294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630565269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630565269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3215	1715630565269	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630565297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630532187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630532187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251999999999997	1715630532187	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630535195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630535195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3235	1715630535195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630537227	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630543232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630548248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630549258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630550259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630551264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630557271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630558278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630566299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630567295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630578303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630578303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251	1715630578303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630581310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630581310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630581310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630582312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630582312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3221999999999996	1715630582312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630597357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630597357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3242	1715630597357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630608383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630608383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276999999999997	1715630608383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630619412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630619412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.325	1715630619412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630624424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630624424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630624424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630625427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630625427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.322	1715630625427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630703632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630703632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3296	1715630703632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630704635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630704635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306	1715630704635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630708647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630708647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630708647	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630710653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630710653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630710653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630712658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630712658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630712658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630715664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715630715664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630715664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630721679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630721679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630721679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630732705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630732705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3293000000000004	1715630732705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630532215	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630535223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630543214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630543214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3230999999999997	1715630543214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630548226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630548226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630548226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630549229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630549229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630549229	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630550231	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630550231	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630550231	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630551234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630551234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3209	1715630551234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630557250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630557250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630557250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630558252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630558252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3218	1715630558252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630566271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630566271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630566271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630567273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630567273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630567273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630568275	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630568275	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3211	1715630568275	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630578319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630581339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630582338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630597376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630618429	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630619438	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630624454	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630703658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630704659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630708674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630710678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630712679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630715690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630721706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630732733	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630738721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630738721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630738721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630739723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630739723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630739723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630746740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630746740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3350999999999997	1715630746740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630750751	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630750751	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630750751	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630751753	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630751753	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630751753	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630752776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630754787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630569304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630570311	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630571310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630577328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630579336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630583342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630584347	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630585348	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630586354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630587356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630588350	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630592364	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630604373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630604373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3257	1715630604373	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630605374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630605374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3266	1715630605374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630606377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630606377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3266	1715630606377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630608412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630609415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630612412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630626430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630626430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630626430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630627433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630627433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.323	1715630627433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630716692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630725717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630731729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630733737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630734735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630735740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630743756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630747770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630756766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630756766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3325	1715630756766	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630765791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630765791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3291999999999997	1715630765791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3281	1715630768800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630769802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630769802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3281	1715630769802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630770804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630770804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630770804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630771807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630771807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630771807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630772810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630772810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630772810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630773812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630773812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316999999999997	1715630773812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630774845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630775817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630775817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316999999999997	1715630775817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630776848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630572286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630572286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.326	1715630572286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630574291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630574291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.326	1715630574291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630575294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.5	1715630575294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3254	1715630575294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630576297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630576297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3254	1715630576297	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630577300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630577300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3254	1715630577300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630580331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630600364	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.2	1715630600364	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630600364	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630601366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630601366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.324	1715630601366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630602395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630603396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630611419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630615428	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630617424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630621445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630717669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3305	1715630717669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630718672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630718672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3305	1715630718672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630719674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630719674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630719674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630720677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630720677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630720677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630728696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630728696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630728696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630729698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630729698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630729698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630730700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630730700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3289	1715630730700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630736741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630744761	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630745764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630748776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630749776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630753787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630755788	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630759802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630762813	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630766820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630767811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630768828	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630769829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630770830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630771835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630772832	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630572310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630574315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630575322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630576326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630580307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630580307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3251	1715630580307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630596385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630600391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630601389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630603371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630603371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3257	1715630603371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630611392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630611392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261999999999996	1715630611392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630615402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630615402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630615402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630617407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630617407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.325	1715630617407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630621417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630621417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3275	1715630621417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630625444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630718700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630719702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630720702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630728724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630729728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630730729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630744735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630744735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3326	1715630744735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630745738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630745738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3326	1715630745738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630748746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630748746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3350999999999997	1715630748746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630749749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630749749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630749749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630753758	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630753758	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630753758	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630755763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630755763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3325	1715630755763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630759776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630759776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.331	1715630759776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630762784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630762784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3272	1715630762784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630766793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630766793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3291999999999997	1715630766793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630767795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630767795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3281	1715630767795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630768800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715630768800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.3999999999999995	1715630592342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3248	1715630592342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630596354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.699999999999999	1715630596354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3242	1715630596354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630604399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630605401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630606395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630609385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630609385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276999999999997	1715630609385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630612395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630612395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3261999999999996	1715630612395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630618410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630618410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.325	1715630618410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630626457	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630627464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3295	1715630722681	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630723716	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630724713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630726692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630726692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630726692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630727694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630727694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3276	1715630727694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630737718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630737718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3301	1715630737718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630740725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630740725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630740725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630741728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630741728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630741728	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630742730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630742730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630742730	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630757786	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630760805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630761809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630773839	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630775845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630778853	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630781835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630781835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3312	1715630781835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630782837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630782837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630782837	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630783840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630783840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630783840	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630783865	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630784842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630784842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3313	1715630784842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3323	1715630785845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630785875	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630786850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630786850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3323	1715630786850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630786880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630792897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630794897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630808934	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630822969	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630824971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630826970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630828985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630833997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630842997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630842997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630842997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630863082	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630867090	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631229021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631229021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631229021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631231025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631231025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631231025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631234033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631234033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3701999999999996	1715631234033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631235036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631235036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3701999999999996	1715631235036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631237043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631237043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3594	1715631237043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631238072	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631239081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631249076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631249076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3699	1715631249076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631252084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631252084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3821	1715631252084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631253087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.600000000000001	1715631253087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3821	1715631253087	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631254091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631254091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3825	1715631254091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631255093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631255093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3825	1715631255093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631258101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631258101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3846	1715631258101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631259103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631259103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3846	1715631259103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631262111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631262111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.39	1715631262111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631267150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631269153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631270158	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631271164	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631273166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631274166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631275172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631276172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631278152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630787852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630787852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3323	1715630787852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630788854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630788854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3318000000000003	1715630788854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630789856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630789856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3318000000000003	1715630789856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630790859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630790859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3318000000000003	1715630790859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630791861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630791861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306999999999998	1715630791861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630796875	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630796875	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630796875	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630805897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630805897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3309	1715630805897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630806900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630806900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630806900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630807905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630807905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630807905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630811914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630811914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630811914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630818960	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630821959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630827956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630827956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630827956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630829961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630829961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630829961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630830963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630830963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630830963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630831966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630831966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630831966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630832968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630832968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630832968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630835004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630844026	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630847037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630848034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630849033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630854059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630856065	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630858059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630859069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630860074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630861070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630862073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630864078	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630865073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630866084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631229053	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631231049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630787873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630788887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630789890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630790886	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630791890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630796901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630805921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630806928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630807930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630811941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630821940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630821940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3345	1715630821940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630823945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630823945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3345	1715630823945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630827974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630829986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630830995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630831994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630834974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630834974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3333000000000004	1715630834974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630844000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630844000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630844000	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630847010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630847010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630847010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630848012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630848012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630848012	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630849014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630849014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.334	1715630849014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630854029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630854029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3356999999999997	1715630854029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630856033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630856033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3356999999999997	1715630856033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630858037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630858037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.334	1715630858037	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630859040	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630859040	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.334	1715630859040	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630860043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630860043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630860043	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630861045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630861045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630861045	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630862047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630862047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630862047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630864052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715630864052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3369	1715630864052	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630865054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630865054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3369	1715630865054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630866058	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630866058	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630792864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.4	1715630792864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306999999999998	1715630792864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630794870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630794870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630794870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630808907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630808907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630808907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630822943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630822943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3345	1715630822943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630824948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630824948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630824948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630826953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630826953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630826953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630828959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630828959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3316	1715630828959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630833971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630833971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3333000000000004	1715630833971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630840016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630843016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630867061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.5	1715630867061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630867061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631230023	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631230023	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631230023	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631232047	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631233051	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631243061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631243061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3682	1715631243061	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631244064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631244064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3682	1715631244064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631245066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631245066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3685	1715631245066	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631247070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631247070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3685	1715631247070	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631250079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631250079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3699	1715631250079	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631251102	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631261134	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631264139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631265144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631266141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631272136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631272136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3928000000000003	1715631272136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631281190	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631282188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631285198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631291212	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631293209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631300234	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631301227	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630793868	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630793868	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3306999999999998	1715630793868	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630797877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630797877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630797877	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630798879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630798879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630798879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630799882	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630799882	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630799882	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630801887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630801887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630801887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630802890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630802890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630802890	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630803892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630803892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3309	1715630803892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630804894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630804894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3309	1715630804894	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630809910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630809910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630809910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630812918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630812918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.333	1715630812918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630813920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630813920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.333	1715630813920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630814922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630814922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.333	1715630814922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630816928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630816928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630816928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630818933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630818933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3348	1715630818933	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630836979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715630836979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630836979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630837982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630837982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630837982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630838985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630838985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630838985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630840993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630840993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630840993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630850020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630850020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.334	1715630850020	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630851022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630851022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630851022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630852025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630852025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630852025	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630853027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630793895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630797897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630798911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630799909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630801912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630802916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630803919	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630804922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630809936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630812940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630813947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630814942	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630816953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630820965	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630836999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630838003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630839015	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630841021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630850048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630851062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630852049	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630853054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630857060	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631230048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631263114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631263114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3886999999999996	1715631263114	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631268126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631268126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3893	1715631268126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631277149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631277149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3918000000000004	1715631277149	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631279182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631283192	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631284193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631287176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631287176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3929	1715631287176	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631302243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631303246	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631306252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631314267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631315274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631322268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631322268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3934	1715631322268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631335302	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631335302	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631335302	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631337306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631337306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631337306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631343327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631343327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4035	1715631343327	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631344329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631344329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046	1715631344329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631345331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631345331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046	1715631345331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631346334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.4	1715631346334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046	1715631346334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630795872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630795872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630795872	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630800884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630800884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3308	1715630800884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630810912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630810912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3322	1715630810912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630815924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630815924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630815924	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630817931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.8	1715630817931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630817931	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630819936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630819936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3348	1715630819936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630820937	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.3	1715630820937	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3348	1715630820937	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630825950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715630825950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3335	1715630825950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630832989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630836005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630841995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630841995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630841995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630845003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.6	1715630845003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630845003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630846007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715630846007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3327	1715630846007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630855031	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630855031	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3356999999999997	1715630855031	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630868064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630868064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630868064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631232027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631232027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631232027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631233030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631233030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3701999999999996	1715631233030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631242059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631242059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3682	1715631242059	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631243085	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631244091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631245095	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631247096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631250101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631261108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631261108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.39	1715631261108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631264116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631264116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3886999999999996	1715631264116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631265119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631265119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3886999999999996	1715631265119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630795898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630800914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630810938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630815951	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630817950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630819955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630823966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630825978	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630835976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630835976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3333000000000004	1715630835976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630839988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.299999999999999	1715630839988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3341999999999996	1715630839988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630842021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630845033	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630846034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630855062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631234062	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631235063	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631237068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631239051	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631239051	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3647	1715631239051	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631248091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631249103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631252112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631253106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631254116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631255119	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631258132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631259132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631262131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631269129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631269129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3915	1715631269129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631270131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631270131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3915	1715631270131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631271134	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631271134	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3915	1715631271134	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631273139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631273139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3928000000000003	1715631273139	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631274141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631274141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3928000000000003	1715631274141	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631275145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631275145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3918000000000004	1715631275145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631276147	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631276147	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3918000000000004	1715631276147	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631277169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631278183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631288179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.5	1715631288179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3929	1715631288179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631289181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631289181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3929	1715631289181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631290183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631290183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3943000000000003	1715631290183	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630853027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630853027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630857035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.5	1715630857035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.334	1715630857035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630863050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630863050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3369	1715630863050	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631236039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631236039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3594	1715631236039	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631240054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631240054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3647	1715631240054	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631241056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631241056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3647	1715631241056	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631242088	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631246097	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631251081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631251081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3821	1715631251081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631256123	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631257122	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631260132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631280185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631287199	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631296226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631297226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631298223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631307254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631311263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631313266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631317278	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631319287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631320289	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631326300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631328300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631329313	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631330314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631339338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631340344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631341345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631342347	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631351370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631352376	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631353369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631357390	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631358380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631359396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631360393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631363399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631365412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631366413	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631378437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631394453	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4135	1715631394453	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631396458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631396458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4141999999999997	1715631396458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631398465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631398465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4107	1715631398465	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631398482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631403493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3314	1715630866058	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630868091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630869067	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630869067	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630869067	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630869092	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630870069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630870069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630870069	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630870097	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630871071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630871071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3328	1715630871071	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630871096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630872074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630872074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630872074	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630872099	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630873076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715630873076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630873076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630873094	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630874078	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630874078	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3343000000000003	1715630874078	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630874105	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630875081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630875081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3362	1715630875081	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630875108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630876084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630876084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3362	1715630876084	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630876112	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630877086	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630877086	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3362	1715630877086	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630877113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630878088	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630878088	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.335	1715630878088	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630878106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630879091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630879091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.335	1715630879091	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630879115	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630880093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630880093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.335	1715630880093	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630880124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630881096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630881096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346999999999998	1715630881096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630881121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630882098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630882098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346999999999998	1715630882098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630882125	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630883101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630883101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346999999999998	1715630883101	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630883129	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630884103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715630884103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346	1715630884103	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630892123	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630892123	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3359	1715630892123	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630893126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630893126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630893126	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630901145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630901145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630901145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630902148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630902148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630902148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630922201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630922201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3392	1715630922201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630927216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.399999999999999	1715630927216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.339	1715630927216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630936266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630939248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630939248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630939248	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630940251	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715630940251	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630940251	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630943259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630943259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3364000000000003	1715630943259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630949294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630952304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630963325	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630968338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630971352	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630972357	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630974354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630975359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630993377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630993377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3415	1715630993377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631008439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631012459	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631017466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631019479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631020478	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631024489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631026498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631036494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631036494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3443	1715631036494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631236064	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631240076	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631241085	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631246068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631246068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3685	1715631246068	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631248073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631248073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3699	1715631248073	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631256096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631256096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3825	1715631256096	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631257098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631257098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630884128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630892148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630893145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630901173	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630902181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630922230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630927241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630937243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715630937243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630937243	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630939273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630940277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630943287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630952282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630952282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630952282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630963307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630963307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3404000000000003	1715630963307	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630968319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630968319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3401	1715630968319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630971326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630971326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715630971326	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630972328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630972328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715630972328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630974333	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630974333	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3399	1715630974333	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630975335	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630975335	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3399	1715630975335	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630988365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715630988365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3418	1715630988365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631008420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631008420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715631008420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631012432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631012432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3421999999999996	1715631012432	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631017444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631017444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631017444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631019449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631019449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3449	1715631019449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631020452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631020452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3449	1715631020452	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631024466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715631024466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631024466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631026470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631026470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631026470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631027495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631040530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631238048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631238048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3594	1715631238048	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631263132	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630885106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630885106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346	1715630885106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630887111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630887111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3344	1715630887111	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630889116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630889116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3344	1715630889116	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630890118	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630890118	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3359	1715630890118	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630895130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630895130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630895130	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630896133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630896133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3366	1715630896133	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630898138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630898138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3366	1715630898138	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630899140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630899140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630899140	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630900142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630900142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630900142	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630912205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630914205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630919220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630928247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630932259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630948271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630948271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630948271	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630949274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630949274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630949274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630950298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630954311	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630959317	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630962334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630964335	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630967342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630976337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630976337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3399	1715630976337	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630979361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630994408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631011456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631013456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631015464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631016466	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631021482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631025468	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631025468	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631025468	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631029477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631029477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631029477	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631035491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631035491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3443	1715631035491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631040503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630885131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630887135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630889144	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630890148	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630895155	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630896161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630898165	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630899168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630900171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630914179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630914179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630914179	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630919193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630919193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3378	1715630919193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630928218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630928218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.339	1715630928218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630932230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630932230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3385	1715630932230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630937273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630948298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630950277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630950277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630950277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630954286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630954286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3394	1715630954286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630959298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630959298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3393	1715630959298	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630962305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630962305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3404000000000003	1715630962305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630964310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630964310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3404000000000003	1715630964310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630967316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630967316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396	1715630967316	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630969349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630979344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630979344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3388	1715630979344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630994381	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630994381	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3415	1715630994381	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631011429	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631011429	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3421999999999996	1715631011429	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631013434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631013434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3428	1715631013434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631015439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631015439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3428	1715631015439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631016441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.9	1715631016441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631016441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631021456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631021456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3449	1715631021456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631022458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630886108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630886108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3346	1715630886108	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630888113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630888113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3344	1715630888113	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630905181	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630915209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630917216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630918209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715630929221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630929221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715630929221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630935238	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630935238	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630935238	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630942256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630942256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3364000000000003	1715630942256	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630957293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630957293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3402	1715630957293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630958295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630958295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3402	1715630958295	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630960300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630960300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3393	1715630960300	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630961303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630961303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3393	1715630961303	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630977366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630980346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715630980346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396999999999997	1715630980346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630981349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630981349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396999999999997	1715630981349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630982351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630982351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396999999999997	1715630982351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630983354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715630983354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3439	1715630983354	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630985358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630985358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3439	1715630985358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630986361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630986361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3418	1715630986361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630987363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715630987363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3418	1715630987363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630991372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630991372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411999999999997	1715630991372	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630992375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630992375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3415	1715630992375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630993399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631005439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631009450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631028475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631028475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630886136	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630905154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715630905154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3368	1715630905154	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630915182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630915182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630915182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630917188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630917188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3378	1715630917188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630918191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630918191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3378	1715630918191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630925211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630925211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3386	1715630925211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630929247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630935267	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630942276	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630957322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630958321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630960321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630977339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630977339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3388	1715630977339	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630978359	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630980379	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630981375	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630982377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630983374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630985382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630986388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630987388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630991405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630992398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631002434	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631009422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631009422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715631009422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631027472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631027472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631027472	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631028501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631030512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631031516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631032509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631034515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631037517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631038524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631039526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631042511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631042511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3458	1715631042511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631044519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631044519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3417	1715631044519	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631045521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631045521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3417	1715631045521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3846	1715631257098	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631260106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631260106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.39	1715631260106	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631280159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631280159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630888131	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630891147	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630894156	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630897155	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630903178	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630904180	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630906188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630907195	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630908182	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630909196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630910199	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630911197	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630913177	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630913177	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630913177	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630916185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630916185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630916185	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630920196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630920196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3392	1715630920196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630921198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630921198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3392	1715630921198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630923204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630923204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3386	1715630923204	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630924209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630924209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3386	1715630924209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630925237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630926241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630930255	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630931255	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630933251	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630934262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630938246	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630938246	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630938246	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630941253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630941253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3364000000000003	1715630941253	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630944261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630944261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630944261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630945263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630945263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630945263	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630946266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630946266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3361	1715630946266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630947268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630947268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630947268	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630951279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630951279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630951279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630953284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630953284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3394	1715630953284	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630955288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630955288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3394	1715630955288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630956291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630891121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630891121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3359	1715630891121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715630894128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630894128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3377	1715630894128	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630897135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630897135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3366	1715630897135	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630903150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630903150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630903150	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630904153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630904153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3352	1715630904153	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630906157	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630906157	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3368	1715630906157	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630907160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715630907160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3368	1715630907160	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630908162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630908162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630908162	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630909166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630909166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630909166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630910169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630910169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.337	1715630910169	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630911172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630911172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630911172	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630912175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630912175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3371	1715630912175	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630913201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630916213	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630920221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630921218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630923233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630924236	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630926214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630926214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.339	1715630926214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630930225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715630930225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715630930225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630931228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630931228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715630931228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630933232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630933232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3385	1715630933232	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630934235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630934235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3385	1715630934235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630936241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630936241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3355	1715630936241	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630938264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630941282	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630944289	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630945291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630946294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630947290	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630951306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630953312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630955310	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630956314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630965312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630965312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396	1715630965312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630966314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630966314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3396	1715630966314	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630969321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630969321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3401	1715630969321	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630970350	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630973360	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630978341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630978341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3388	1715630978341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630984382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630989367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630989367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411999999999997	1715630989367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630990370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715630990370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411999999999997	1715630990370	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630995383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.9	1715630995383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715630995383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630996384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630996384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715630996384	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715630997388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630997388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715630997388	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715630998392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630998392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3424	1715630998392	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630999394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630999394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3424	1715630999394	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631000396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631000396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3424	1715631000396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631001399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631001399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715631001399	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631002402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631002402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715631002402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631003431	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631004441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631006412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715631006412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631006412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631007417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715631007417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3389	1715631007417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631010427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631010427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3421999999999996	1715631010427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715631014437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631014437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630956291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3402	1715630956291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630961331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630965341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630966341	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715630970324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715630970324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3401	1715630970324	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715630973331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715630973331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715630973331	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630976368	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715630984356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715630984356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3439	1715630984356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630988396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630989398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630990396	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630995415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630996412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630997416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630998418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715630999423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631000422	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631001424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631003404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631003404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3427	1715631003404	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631004407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.9	1715631004407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631004407	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631005409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631005409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631005409	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631006437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631007444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631010451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631014461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631018474	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631023461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631023461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631023461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631033486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631033486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3459	1715631033486	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631036521	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631266121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631266121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3893	1715631266121	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631267124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631267124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3893	1715631267124	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631272157	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631282163	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631282163	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.393	1715631282163	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631285171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631285171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3947	1715631285171	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631291186	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631291186	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3943000000000003	1715631291186	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631293191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631293191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3428	1715631014437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631018446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631018446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631018446	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631022476	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631023487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631033511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631268145	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631279155	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631279155	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.392	1715631279155	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631283166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631283166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.393	1715631283166	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631284168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631284168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3947	1715631284168	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631286205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631302216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631302216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3941	1715631302216	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631303218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631303218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3941	1715631303218	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631306226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631306226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3946	1715631306226	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631314245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631314245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.388	1715631314245	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631315247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631315247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.388	1715631315247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631321293	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631322294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631335328	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631337334	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631343345	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631344355	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631345356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631346355	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631356382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631367385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631367385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4058	1715631367385	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631369391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631369391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.409	1715631369391	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631370393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631370393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.409	1715631370393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631372417	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631380444	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631385431	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631385431	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4109000000000003	1715631385431	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631386433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.6	1715631386433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4128000000000003	1715631386433	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631395456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631395456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4141999999999997	1715631395456	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631397462	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631397462	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	5.9	1715631022458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631022458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631025493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631029504	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631035516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631041509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631041509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3458	1715631041509	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631043543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631046551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631047556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631278152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.392	1715631278152	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631281161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631281161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.393	1715631281161	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631288205	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631289201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631290209	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631292214	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631294220	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631295225	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631299233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631304247	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631308250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631310261	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631312266	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631318287	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631323288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631331319	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631338329	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631347362	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631348365	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631349371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631350374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631355356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631355356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4076999999999997	1715631355356	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631361369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631361369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4008000000000003	1715631361369	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631362371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631362371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4043	1715631362371	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631364377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631364377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4043	1715631364377	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631368389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631368389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.409	1715631368389	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631371395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631371395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4119	1715631371395	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631379415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631379415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095999999999997	1715631379415	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631381447	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631391445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631391445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126999999999996	1715631391445	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631393451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631393451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4135	1715631393451	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631394453	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631028475	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631030479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631030479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3432	1715631030479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631031482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.6000000000000005	1715631031482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3459	1715631031482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631032484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631032484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3459	1715631032484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631034489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631034489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3443	1715631034489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631037496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.7	1715631037496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3451999999999997	1715631037496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631038498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.399999999999999	1715631038498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3451999999999997	1715631038498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631039501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631039501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3451999999999997	1715631039501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631041534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631042531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631044547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631045547	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.392	1715631280159	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631286173	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631286173	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3947	1715631286173	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631296198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631296198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3921	1715631296198	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631297201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631297201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3921	1715631297201	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631298203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631298203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3921	1715631298203	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631307228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631307228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3946	1715631307228	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631311237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631311237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3774	1715631311237	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631313242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631313242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3774	1715631313242	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631317254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631317254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3923	1715631317254	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631319259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631319259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3923	1715631319259	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631320262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631320262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3934	1715631320262	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631326277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631326277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3978	1715631326277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631328283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631328283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3978	1715631328283	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631329286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631040503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3458	1715631040503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631043516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631043516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3417	1715631043516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631046525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631046525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411	1715631046525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631047527	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631047527	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411	1715631047527	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631048529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631048529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3411	1715631048529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631048560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631049532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631049532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715631049532	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631049558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631050535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631050535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715631050535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631050561	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631051540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631051540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3426	1715631051540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631051566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631052543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631052543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631052543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631052562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631053545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631053545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631053545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631053572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631054548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631054548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3461	1715631054548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631054574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631055551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631055551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631055551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631055577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631056553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631056553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631056553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631056578	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631057556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631057556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3454	1715631057556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631057573	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631058558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631058558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3455	1715631058558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631058585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631059562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631059562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3455	1715631059562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631059590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631060565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631060565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3455	1715631060565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631060593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631061579	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631061579	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3491	1715631061579	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631062581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631062581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3491	1715631062581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715631063585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631063585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3491	1715631063585	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631064587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631064587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3467	1715631064587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631066594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631066594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3467	1715631066594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631067596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631067596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631067596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631071608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631071608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3485	1715631071608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631073613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631073613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3493000000000004	1715631073613	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631074615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631074615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3493000000000004	1715631074615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631075620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631075620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3493000000000004	1715631075620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631076623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631076623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631076623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631092662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631092662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3529	1715631092662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631093664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631093664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3529	1715631093664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631095669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631095669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3508	1715631095669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631097674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631097674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3509	1715631097674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631098677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631098677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3509	1715631098677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631105694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631105694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.351	1715631105694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631112729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631113741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631120755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631124770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631125762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631126771	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631132767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631132767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3510999999999997	1715631132767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631134799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631135808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631136808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631140815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631150850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631061605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631062603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631063605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631064615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631066620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631067626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631071638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631073632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631074638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631075649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631076658	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631092690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631093682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631095702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631097698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631098697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631112711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631112711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631112711	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631113714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631113714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631113714	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631120731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631120731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631120731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631124741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631124741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631124741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631125744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631125744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631125744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631126747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631126747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631126747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631131795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631132795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631135777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631135777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631135777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631136780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631136780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3526	1715631136780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631140790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631140790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3541	1715631140790	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631150817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631150817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3539	1715631150817	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631163851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631163851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631163851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631164884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631175912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631176916	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631177914	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631183934	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631184936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631185940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631189948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631197961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631198964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631207971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631207971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631207971	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631214987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631065592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631065592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3467	1715631065592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631072611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631072611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3485	1715631072611	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631077626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631077626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631077626	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631078629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631078629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631078629	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631079654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631086675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631088669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631089675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631099705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631100706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631103718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631106696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631106696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631106696	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631115719	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631115719	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631115719	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631116721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631116721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631116721	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631121734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631121734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631121734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631127749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631127749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3513	1715631127749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631128774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631133791	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631137808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631139811	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631147809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631147809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631147809	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631160844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631160844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3562	1715631160844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631179895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631179895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3585	1715631179895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631180898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631180898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3585	1715631180898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631188921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631188921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3549	1715631188921	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631191928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631191928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631191928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631196940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631196940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631196940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631202984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631205992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631206986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631209001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631211980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631065615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631072638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631077652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631079631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631079631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3463000000000003	1715631079631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631086648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631086648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3527	1715631086648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631088652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631088652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.352	1715631088652	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631089655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631089655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.352	1715631089655	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631099679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631099679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3509	1715631099679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631100682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631100682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631100682	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631103689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631103689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.351	1715631103689	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631105720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631106722	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631115748	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631116747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631121760	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631127776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631133769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631133769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631133769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631137783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631137783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3526	1715631137783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631139787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631139787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3541	1715631139787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631145804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631145804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631145804	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631155864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631160870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631179922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631180928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631188948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631191954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631196966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631205964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631205964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631205964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631206968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631206968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631206968	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631208973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631208973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631208973	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631211009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631212002	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631213009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631214011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631219024	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631221032	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631068599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631068599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631068599	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631069603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631069603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3489	1715631069603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631070606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631070606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3485	1715631070606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631080634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631080634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3463000000000003	1715631080634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631081637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631081637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3463000000000003	1715631081637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631082639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631082639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3518000000000003	1715631082639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631083641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631083641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3518000000000003	1715631083641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631084643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631084643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3518000000000003	1715631084643	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631085645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631085645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3527	1715631085645	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631101684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631101684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631101684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631102687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631102687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631102687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631109703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631109703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.354	1715631109703	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631111709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631111709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.354	1715631111709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631114717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631114717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3534	1715631114717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631117723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631117723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631117723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631118727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631118727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631118727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631119729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631119729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631119729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631122736	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631122736	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631122736	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631134772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631134772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631134772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631142815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631152822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631152822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631152822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631153826	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631153826	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631153826	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631068618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631069630	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631070634	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631080659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631081666	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631082666	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631083660	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631084674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631085673	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631101715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631102718	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631109727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631111735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631114740	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631117743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631118754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631119757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631122756	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631142796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631142796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631142796	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631148812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631148812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3539	1715631148812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631152852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631153852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631154850	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631156833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631156833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3553	1715631156833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631157835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631157835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631157835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631158838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631158838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631158838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631159841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631159841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631159841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631161846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631161846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3562	1715631161846	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631162849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631162849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3562	1715631162849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631164854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631164854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631164854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631168866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631168866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3573000000000004	1715631168866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631173880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631173880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3556	1715631173880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631181927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631182928	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631192954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631204962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.5	1715631204962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631204962	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631209975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631209975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631209975	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631210977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631078661	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631087678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631090681	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631091685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631094695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631096697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631104724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631107724	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631108726	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631110735	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631123757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631129757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631129757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3513	1715631129757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631130762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631130762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3510999999999997	1715631130762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631131765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631131765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3510999999999997	1715631131765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631138815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631141820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631143824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631144826	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631146807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631146807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3521	1715631146807	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631147827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631149815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631149815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3539	1715631149815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631151819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631151819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631151819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631165856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631165856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3563	1715631165856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631166861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631166861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3573000000000004	1715631166861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631167887	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631169897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631170900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631171903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631172908	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631174911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631178911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631186915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631186915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3586	1715631186915	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631187918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631187918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3549	1715631187918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631190925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631190925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631190925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631193932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631193932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3567	1715631193932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631194935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631194935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3567	1715631194935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631195938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631195938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631087650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631087650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3527	1715631087650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631090657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631090657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.352	1715631090657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631091659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631091659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3529	1715631091659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631094667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631094667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3508	1715631094667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631096671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631096671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3508	1715631096671	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631104692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631104692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.351	1715631104692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631107698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631107698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631107698	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631108701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631108701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3522	1715631108701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631110706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631110706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.354	1715631110706	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631123739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631123739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3528000000000002	1715631123739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631128754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631128754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3513	1715631128754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631129775	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631130788	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631138784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631138784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3526	1715631138784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631141793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631141793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3541	1715631141793	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631143799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631143799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631143799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631144802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631144802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.353	1715631144802	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631145833	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631146834	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631148838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631149842	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631151845	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631165884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631166885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631169871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631169871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.357	1715631169871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631170873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631170873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.357	1715631170873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631171876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631171876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.357	1715631171876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631172878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631154829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631154829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3553	1715631154829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631155831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631155831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3553	1715631155831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631156857	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631157866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631158863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631159875	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631161873	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631162866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631167863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631167863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3573000000000004	1715631167863	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631168895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631173897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631182903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631182903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.358	1715631182903	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631192930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631192930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631192930	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631203981	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631204985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631210005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631217995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631217995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3579	1715631217995	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631222003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631222003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3598000000000003	1715631222003	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631224008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631224008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3571999999999997	1715631224008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631292188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631292188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3943000000000003	1715631292188	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631294193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631294193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.394	1715631294193	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631295196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631295196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.394	1715631295196	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631299206	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631299206	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3945	1715631299206	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631304221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631304221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3941	1715631304221	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631308230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631308230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3761	1715631308230	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631310235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631310235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3761	1715631310235	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631312239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631312239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3774	1715631312239	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631318257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631318257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3923	1715631318257	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631323270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631323270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631163880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631175885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631175885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3589	1715631175885	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631176888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631176888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3589	1715631176888	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631177891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631177891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3589	1715631177891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631183907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631183907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.358	1715631183907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631184910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631184910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3586	1715631184910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715631185911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631185911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3586	1715631185911	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631189923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631189923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3549	1715631189923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631197943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.5	1715631197943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631197943	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631198947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631198947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631198947	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631203959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631203959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631203959	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631207999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631215014	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631216017	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631217016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631220027	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631226044	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.394	1715631293191	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631300208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631300208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3945	1715631300208	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631301211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631301211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3945	1715631301211	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631305223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631305223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3946	1715631305223	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631309233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631309233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3761	1715631309233	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631316250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631316250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.388	1715631316250	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631321264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631321264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3934	1715631321264	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631324306	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631325302	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631327305	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631332322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631333323	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631334315	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631336330	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631373400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631172878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3556	1715631172878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631174883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631174883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3556	1715631174883	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631178893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631178893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3585	1715631178893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631181901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631181901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.358	1715631181901	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631186941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631187945	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631190953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631193958	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631194961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631195967	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631199976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631200979	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631201980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631223006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631223006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3598000000000003	1715631223006	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631227016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631227016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631227016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631228019	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631228019	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3687	1715631228019	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631305252	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631309258	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631316277	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631324273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631324273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3981999999999997	1715631324273	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631325274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631325274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3981999999999997	1715631325274	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631327279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631327279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3978	1715631327279	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631332294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631332294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4125	1715631332294	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631333296	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631333296	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4125	1715631333296	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631334299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631334299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4125	1715631334299	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631336304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631336304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631336304	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631370424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631373427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631374427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631375430	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631376439	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631377437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631383424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631383424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4109000000000003	1715631383424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631384427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631384427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3567	1715631195938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631199950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631199950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631199950	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631200952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631200952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631200952	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631201955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631201955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3564000000000003	1715631201955	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631202957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631202957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3578	1715631202957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631223029	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631227046	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631228046	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3981999999999997	1715631323270	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631331291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631331291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4114	1715631331291	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631338309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631338309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4	1715631338309	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631347336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631347336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4052	1715631347336	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631348338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631348338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4052	1715631348338	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631349342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631349342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4052	1715631349342	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631350344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631350344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4093	1715631350344	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631354353	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631354353	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4076999999999997	1715631354353	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631355382	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631361393	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631362398	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631364401	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631368416	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631371419	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631379441	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631384458	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631391471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631393481	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631394481	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631396484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4141999999999997	1715631397462	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631401473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631401473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126	1715631401473	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631402474	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631402474	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126	1715631402474	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631404479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631404479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4152	1715631404479	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631405482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631405482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4152	1715631405482	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631406484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631210977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631210977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631218013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631222038	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631224035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631329286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4114	1715631329286	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631330288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631330288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4114	1715631330288	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631339312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631339312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4	1715631339312	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631340317	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631340317	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4	1715631340317	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631341320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715631341320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4035	1715631341320	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631342322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631342322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4035	1715631342322	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631351346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631351346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4093	1715631351346	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631352349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631352349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4093	1715631352349	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631353351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631353351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4076999999999997	1715631353351	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631354381	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631358363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631358363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4094	1715631358363	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631359366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631359366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4008000000000003	1715631359366	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631360367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631360367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4008000000000003	1715631360367	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631363374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631363374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4043	1715631363374	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631365380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631365380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4058	1715631365380	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715631366383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631366383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4058	1715631366383	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631378412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631378412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095999999999997	1715631378412	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631382440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631403476	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631403476	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126	1715631403476	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631406484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4152	1715631406484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631411496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631411496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4137	1715631411496	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631412515	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631413528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631211980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631211980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631212982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631212982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631212982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631213984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.3	1715631213984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3575999999999997	1715631213984	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631218996	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.8	1715631218996	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3579	1715631218996	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631221001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631221001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3598000000000003	1715631221001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631225010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6	1715631225010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3571999999999997	1715631225010	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631356358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715631356358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4094	1715631356358	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631357361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631357361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4094	1715631357361	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631367403	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631369424	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631372397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631372397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4119	1715631372397	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631380418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631380418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4104	1715631380418	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631382423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631382423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4104	1715631382423	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631385463	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631386461	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631395484	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631397495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631401499	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631402505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631404507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631405511	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631406503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631409517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631411523	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631413501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631413501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4139	1715631413501	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631414503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631414503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4139	1715631414503	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631414530	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631417510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631417510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631417510	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631417529	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631418512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631418512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631418512	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631418537	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631420545	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631421520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631421520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631421520	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.2	1715631214987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3581999999999996	1715631214987	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631215989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.9	1715631215989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3581999999999996	1715631215989	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631216991	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631216991	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3581999999999996	1715631216991	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631219999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631219999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3579	1715631219999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631226013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.7	1715631226013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.3571999999999997	1715631226013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631373400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4119	1715631373400	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631374402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631374402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4098	1715631374402	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631375405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631375405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4098	1715631375405	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631376408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631376408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4098	1715631376408	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631377410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631377410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095999999999997	1715631377410	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631381420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631381420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4104	1715631381420	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631383450	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631387435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631387435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4128000000000003	1715631387435	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631388437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631388437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4128000000000003	1715631388437	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631389440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631389440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126999999999996	1715631389440	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631390443	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631390443	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4126999999999996	1715631390443	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631392449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631392449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4135	1715631392449	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631399467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631399467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4107	1715631399467	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631400470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715631400470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4107	1715631400470	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631407487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631407487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631407487	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631408489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.599999999999998	1715631408489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631408489	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631409491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631409491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631409491	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631410494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631410494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631225036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4109000000000003	1715631384427	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631387460	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631388464	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631389469	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631390471	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631392480	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631399495	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631400493	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631407516	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631408513	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4137	1715631410494	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631410526	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631412498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631412498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4137	1715631412498	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631415505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631415505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4139	1715631415505	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631415524	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631416507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631416507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631416507	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631416534	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631419514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631419514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631419514	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631419539	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715631420517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	14	1715631420517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631420517	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631421548	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631422522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.8	1715631422522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046999999999996	1715631422522	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631422541	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631423525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631423525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046999999999996	1715631423525	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631423554	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631424528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715631424528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4046999999999996	1715631424528	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631424556	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631425531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631425531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4069000000000003	1715631425531	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631425557	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631426535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631426535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4069000000000003	1715631426535	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631426562	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631427538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631427538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4069000000000003	1715631427538	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631427558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631428540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631428540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4083	1715631428540	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631428566	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631429543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631429543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4083	1715631429543	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631429564	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631430546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631430546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4083	1715631430546	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631432570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631445582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631445582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.416	1715631445582	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631448589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631448589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4164	1715631448589	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631449592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631449592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631449592	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631457635	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631430575	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631438591	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631445608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631448606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631457615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631457615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631457615	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631431549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631431549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095	1715631431549	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631435558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631435558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631435558	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631436560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631436560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631436560	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631437563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631437563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631437563	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631439593	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631441572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631441572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631441572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631442574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631442574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631442574	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631454606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631454606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631454606	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631455608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631455608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631455608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631456612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631456612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631456612	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631460622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631460622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631460622	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631463630	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631463630	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.419	1715631463630	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631466639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631466639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631466639	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631467641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631467641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631467641	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631431572	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631435583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631436588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631437588	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631440570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631440570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631440570	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631441600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631442607	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631454637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631455633	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631456638	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631460651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631463656	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631466666	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631467665	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631432551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631432551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095	1715631432551	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631434581	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631439568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.799999999999999	1715631439568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631439568	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631443577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631443577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.416	1715631443577	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631444580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631444580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.416	1715631444580	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631446584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631446584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4164	1715631446584	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631447587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631447587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4164	1715631447587	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631449618	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631450623	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631451628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631459648	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631461654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631464663	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631433553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631433553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4095	1715631433553	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631452600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631452600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631452600	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631453603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631453603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631453603	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631458617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631458617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631458617	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631462628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631462628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.419	1715631462628	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631465637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631465637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631465637	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631433583	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631452625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631453631	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631458642	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631462650	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631465662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631434555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.899999999999999	1715631434555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631434555	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631438565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.3	1715631438565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631438565	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631440590	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631443595	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631444605	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631446609	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631447608	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631450594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631450594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631450594	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631451596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631451596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631451596	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631459620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631459620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631459620	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631461625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631461625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.419	1715631461625	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631464632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631464632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631464632	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631468644	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631468644	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631468644	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631468672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631469646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8	1715631469646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631469646	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631469672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631470649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.1	1715631470649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4124	1715631470649	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631470675	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631471651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631471651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4124	1715631471651	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631471679	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631472653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631472653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4124	1715631472653	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631472674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631473654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631473654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631473654	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631473678	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631474657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8	1715631474657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631474657	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631474676	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631475659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.599999999999998	1715631475659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631475659	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631475694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631476662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.1	1715631476662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4133	1715631476662	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631476691	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631477664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631477664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4133	1715631477664	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631491700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631491700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631491700	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631497715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631497715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631497715	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631515759	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631515759	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4171	1715631515759	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631521776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.4	1715631521776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4153000000000002	1715631521776	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631522778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631522778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4153000000000002	1715631522778	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631523798	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631526816	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631527819	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631529823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631538822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631538822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631538822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631539824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631539824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631539824	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631540827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631540827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631540827	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631544838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631544838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631544838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631546870	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631551884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631552878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631553891	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631554892	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631563910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631567918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631572937	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631573946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631574948	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631576957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631587964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631587964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631587964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631589969	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631589969	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631589969	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631590972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631590972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631590972	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631591974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631591974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631591974	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631592977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631592977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4173	1715631592977	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631599021	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631603001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631603001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4189000000000003	1715631603001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631607011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.2	1715631607011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631477684	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631491726	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631497742	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631515787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631521805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631522808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631526789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631526789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4149000000000003	1715631526789	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631527792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631527792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631527792	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631529797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631529797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631529797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631532823	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631538849	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631539851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631540856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631546844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.7	1715631546844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631546844	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631551859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631551859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.42	1715631551859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631552861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631552861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.42	1715631552861	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631553864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631553864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.42	1715631553864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631554866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631554866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631554866	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631563889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631563889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631563889	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631567902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631567902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4178	1715631567902	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631572918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631572918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.417	1715631572918	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631573920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631573920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.417	1715631573920	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631574923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631574923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.417	1715631574923	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631576929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631576929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631576929	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631585986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631587991	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631590001	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631590999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631592005	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631595985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631595985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631595985	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631602030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631603018	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631607041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631478667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631478667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4133	1715631478667	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631479669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631479669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4147	1715631479669	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631480672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631480672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4147	1715631480672	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631481674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631481674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4147	1715631481674	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631482677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631482677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631482677	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631484710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631490722	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631492719	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631493731	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631494732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631502754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631504764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631523780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631523780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4153000000000002	1715631523780	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631530830	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631537820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631537820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631537820	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631541829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631541829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631541829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631545865	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631547871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631549854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631549854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4194	1715631549854	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631550856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.2	1715631550856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4194	1715631550856	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631558876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631558876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631558876	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631560881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631560881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631560881	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631562886	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631562886	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631562886	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631568910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631568910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4178	1715631568910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631569907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631569907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631569907	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631570910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631570910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631570910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715631577932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631577932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631577932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631593980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631593980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631593980	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631478694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631479694	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631480701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631481701	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631482705	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631483680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631483680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631483680	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631483709	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631484683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	11.299999999999999	1715631484683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631484683	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631485685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.899999999999999	1715631485685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4143000000000003	1715631485685	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631485713	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631486687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631486687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4143000000000003	1715631486687	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631486717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631490697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631490697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631490697	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631492702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631492702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631492702	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631493704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631493704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631493704	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631494707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631494707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4160999999999997	1715631494707	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631495710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631495710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4160999999999997	1715631495710	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631495738	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631496712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631496712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4160999999999997	1715631496712	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631496741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631498717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631498717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631498717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631498743	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631499720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631499720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631499720	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631499747	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631500723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631500723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4146	1715631500723	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631500752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631501725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631501725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4146	1715631501725	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631501755	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631502727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631502727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4146	1715631502727	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631504732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631504732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631504732	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631505734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631505734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631487690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.899999999999999	1715631487690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4143000000000003	1715631487690	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631488692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.899999999999999	1715631488692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631488692	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631489695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631489695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631489695	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631503729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.4	1715631503729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631503729	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631507739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.7	1715631507739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.414	1715631507739	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631508762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631509770	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631511774	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631512777	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631513782	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631514784	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631524808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631533831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631534838	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631536841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631542859	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631543862	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631555897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631556897	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631557898	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631566925	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631575957	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631578964	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631579963	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631580970	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631581976	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631582969	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631583986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631584986	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631586961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631586961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631586961	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631588966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631588966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4169	1715631588966	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631592998	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631595008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631599994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.4	1715631599994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4206999999999996	1715631599994	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631600997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631600997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4206999999999996	1715631600997	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631604004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631604004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4189000000000003	1715631604004	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631605007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631605007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4189000000000003	1715631605007	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631608013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631608013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4188	1715631608013	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631487708	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631488717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631489717	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631503758	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631507764	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631509744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631509744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631509744	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631511749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631511749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631511749	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631512752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631512752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631512752	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631513754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631513754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631513754	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631514757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631514757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.415	1715631514757	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631524783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631524783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4149000000000003	1715631524783	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631533808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631533808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631533808	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631534810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631534810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631534810	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631536818	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631536818	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631536818	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631542831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631542831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631542831	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631543835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631543835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631543835	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631555869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631555869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631555869	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631556871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631556871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631556871	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631557874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631557874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631557874	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715631566900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.899999999999999	1715631566900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4178	1715631566900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631575926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	13.7	1715631575926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4144	1715631575926	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631578936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631578936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4166	1715631578936	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631579938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631579938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4166	1715631579938	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631580941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.299999999999999	1715631580941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4166	1715631580941	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631581946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631581946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4132	1715631505734	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631506737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631506737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.414	1715631506737	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631510746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631510746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4145	1715631510746	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631516762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631516762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4171	1715631516762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631517765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631517765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4171	1715631517765	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631518767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631518767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631518767	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631519769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631519769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631519769	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631520772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631520772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631520772	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631525787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631525787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4149000000000003	1715631525787	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	105	1715631528795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9	1715631528795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4156999999999997	1715631528795	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631531803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631531803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631531803	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	100	1715631535812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631535812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4174	1715631535812	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631544864	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631548878	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631559905	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631561912	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631564922	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631565927	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631571939	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631596988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631596988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631596988	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631597990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.899999999999999	1715631597990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631597990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631606009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631606009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4188	1715631606009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631609016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631609016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4194	1715631609016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631505762	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631506763	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631510773	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631516794	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631517798	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631518799	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631519797	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631520798	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631525815	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631528822	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631531829	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631535839	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631545841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631545841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631545841	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631559879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631559879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4168000000000003	1715631559879	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631561884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631561884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631561884	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631564893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631564893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631564893	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631565895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631565895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4181	1715631565895	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631571913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631571913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631571913	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631596011	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631597016	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631598008	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631606034	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631609041	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631508741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.4	1715631508741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.414	1715631508741	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631530800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631530800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631530800	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631532805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631532805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4159	1715631532805	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631537839	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631541852	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631547848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	9.2	1715631547848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631547848	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631548851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631548851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4194	1715631548851	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631549880	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631550882	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631558900	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631560910	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631562909	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631568940	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631569932	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631570935	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631577953	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631594009	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631581946	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715631582949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631582949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631582949	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	103	1715631583951	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631583951	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4172	1715631583951	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	101	1715631584954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	6.199999999999999	1715631584954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631584954	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	106	1715631585956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631585956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4163	1715631585956	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631586990	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631588993	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631594982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	10.7	1715631594982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4179	1715631594982	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	102	1715631598992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	8.1	1715631598992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4175	1715631598992	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631600019	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631601022	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631604030	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631605036	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Swap Memory GB	0.0005	1715631608035	a03a7115d19e465daa6771e836e1db39	0	f
TOP - CPU Utilization	104	1715631601999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Utilization	7.8999999999999995	1715631601999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4206999999999996	1715631601999	a03a7115d19e465daa6771e836e1db39	0	f
TOP - Memory Usage GB	2.4188	1715631607011	a03a7115d19e465daa6771e836e1db39	0	f
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
letter	0	b9a95cb3efca4c4fb7ac5e92b9d4ab05
workload	0	b9a95cb3efca4c4fb7ac5e92b9d4ab05
listeners	smi+top+dcgmi	b9a95cb3efca4c4fb7ac5e92b9d4ab05
params	'"-"'	b9a95cb3efca4c4fb7ac5e92b9d4ab05
file	cifar10.py	b9a95cb3efca4c4fb7ac5e92b9d4ab05
workload_listener	''	b9a95cb3efca4c4fb7ac5e92b9d4ab05
letter	0	a03a7115d19e465daa6771e836e1db39
workload	0	a03a7115d19e465daa6771e836e1db39
listeners	smi+top+dcgmi	a03a7115d19e465daa6771e836e1db39
params	'"-"'	a03a7115d19e465daa6771e836e1db39
file	cifar10.py	a03a7115d19e465daa6771e836e1db39
workload_listener	''	a03a7115d19e465daa6771e836e1db39
model	cifar10.py	a03a7115d19e465daa6771e836e1db39
manual	False	a03a7115d19e465daa6771e836e1db39
max_epoch	5	a03a7115d19e465daa6771e836e1db39
max_time	172800	a03a7115d19e465daa6771e836e1db39
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
b9a95cb3efca4c4fb7ac5e92b9d4ab05	welcoming-jay-325	UNKNOWN			daga	FAILED	1715629139835	1715629268399		active	s3://mlflow-storage/0/b9a95cb3efca4c4fb7ac5e92b9d4ab05/artifacts	0	\N
a03a7115d19e465daa6771e836e1db39	(0 0) chill-gull-680	UNKNOWN			daga	FINISHED	1715629409945	1715631610233		active	s3://mlflow-storage/0/a03a7115d19e465daa6771e836e1db39/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.source.name	file:///home/daga/radt#examples/pytorch	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.source.type	PROJECT	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.project.entryPoint	main	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.runName	welcoming-jay-325	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.project.env	conda	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.project.backend	local	b9a95cb3efca4c4fb7ac5e92b9d4ab05
mlflow.user	daga	a03a7115d19e465daa6771e836e1db39
mlflow.source.name	file:///home/daga/radt#examples/pytorch	a03a7115d19e465daa6771e836e1db39
mlflow.source.type	PROJECT	a03a7115d19e465daa6771e836e1db39
mlflow.project.entryPoint	main	a03a7115d19e465daa6771e836e1db39
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	a03a7115d19e465daa6771e836e1db39
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a03a7115d19e465daa6771e836e1db39
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a03a7115d19e465daa6771e836e1db39
mlflow.project.env	conda	a03a7115d19e465daa6771e836e1db39
mlflow.project.backend	local	a03a7115d19e465daa6771e836e1db39
mlflow.runName	(0 0) chill-gull-680	a03a7115d19e465daa6771e836e1db39
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

