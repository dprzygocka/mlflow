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
0	Default	s3://mlflow-storage/0	active	1716043741936	1716043741936
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
SMI - Power Draw	14.84	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
SMI - Timestamp	1716043914.011	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
SMI - GPU Util	0	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
SMI - Mem Util	0	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
SMI - Mem Used	0	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
SMI - Performance State	0	1716043914027	0	f	0da2f51a98f44b57ba144e00fb8bad29
TOP - CPU Utilization	101	1716044401055	0	f	0da2f51a98f44b57ba144e00fb8bad29
TOP - Memory Usage GB	1.9563	1716044401055	0	f	0da2f51a98f44b57ba144e00fb8bad29
TOP - Memory Utilization	7.699999999999999	1716044401055	0	f	0da2f51a98f44b57ba144e00fb8bad29
TOP - Swap Memory GB	0.021	1716044401077	0	f	0da2f51a98f44b57ba144e00fb8bad29
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.84	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
SMI - Timestamp	1716043914.011	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
SMI - GPU Util	0	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
SMI - Mem Util	0	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
SMI - Mem Used	0	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
SMI - Performance State	0	1716043914027	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	0	1716043914083	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	0	1716043914083	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.2403	1716043914083	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043914097	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	150.1	1716043915085	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	8.7	1716043915085	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.2403	1716043915085	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043915099	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043916087	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043916087	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.2403	1716043916087	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043916099	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043917089	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043917089	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4693	1716043917089	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043917101	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043918090	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043918090	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4693	1716043918090	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043918112	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043919092	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043919092	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4693	1716043919092	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043919105	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043920095	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043920095	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4689	1716043920095	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043920113	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043921097	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043921097	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4689	1716043921097	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043921110	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043922099	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043922099	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4689	1716043922099	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043922121	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043923101	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043923101	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4690999999999999	1716043923101	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043923125	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043924103	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043924103	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4690999999999999	1716043924103	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043924116	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043925105	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043925105	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4690999999999999	1716043925105	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043925118	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043926107	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043926107	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043926107	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043926121	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043927109	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043927109	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043927109	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043927131	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043928112	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043928112	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043928112	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043928125	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043929127	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043930128	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043931139	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043932141	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043933135	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043934137	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043935139	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043936141	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.0213	1716043937151	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043938147	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043939149	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043940150	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043941152	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043942154	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043943155	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044243744	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044243744	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044243744	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044244745	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044244745	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044244745	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044245747	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044245747	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044245747	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044246749	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044246749	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044246749	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044247751	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044247751	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9452	1716044247751	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044248753	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044248753	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9452	1716044248753	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044249755	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044249755	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9452	1716044249755	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044250757	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044250757	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044250757	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044251759	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044251759	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044251759	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044252761	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044252761	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044252761	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044253763	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044253763	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9479000000000002	1716044253763	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044254764	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044254764	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9479000000000002	1716044254764	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044255766	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044255766	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9479000000000002	1716044255766	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044256769	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044256769	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9475	1716044256769	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044257771	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044257771	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9475	1716044257771	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044258772	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044258772	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9475	1716044258772	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043929114	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043929114	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4701	1716043929114	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043930116	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043930116	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4701	1716043930116	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	106	1716043931118	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043931118	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4701	1716043931118	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043932120	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043932120	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043932120	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716043933122	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043933122	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043933122	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043934124	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	2.5	1716043934124	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4702	1716043934124	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716043935126	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043935126	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4713	1716043935126	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043936128	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043936128	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4713	1716043936128	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043937130	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043937130	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.4713	1716043937130	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043938132	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043938132	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.8559	1716043938132	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043939135	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.199999999999999	1716043939135	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.8559	1716043939135	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043940136	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043940136	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.8559	1716043940136	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043941139	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043941139	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9841	1716043941139	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043942141	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043942141	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9841	1716043942141	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043943143	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043943143	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9841	1716043943143	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043944145	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.2	1716043944145	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9886	1716043944145	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043944160	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043945147	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.4	1716043945147	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9886	1716043945147	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043945163	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043946149	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043946149	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9886	1716043946149	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043946171	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043947151	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043947151	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9894	1716043947151	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043947173	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043948153	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043948153	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9894	1716043948153	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043948167	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043949178	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043950179	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043951172	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043952181	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043953176	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043954178	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043955180	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043956189	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043957191	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043958186	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043959188	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043960189	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043961199	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043962205	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043963197	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043964205	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043965202	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043966203	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043967214	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043968206	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043969208	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043970212	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043971223	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043972222	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043973224	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043974220	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043975226	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043976230	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043977230	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043978225	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043979232	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043980238	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043981240	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043982242	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043983243	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043984236	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043985238	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043986251	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043987250	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043988244	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043989254	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043990256	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043991257	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043992259	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043993258	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043994270	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043995259	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043996271	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043997269	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043998266	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716043999275	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044000276	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044001270	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044002273	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044003275	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044243757	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044244768	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044245770	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044246763	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044247772	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044248767	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044249770	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044250780	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044251782	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043949155	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043949155	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9894	1716043949155	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043950157	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043950157	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9895	1716043950157	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043951159	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043951159	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9895	1716043951159	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043952161	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043952161	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9895	1716043952161	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716043953162	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043953162	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9915999999999998	1716043953162	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043954164	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043954164	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9915999999999998	1716043954164	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043955166	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043955166	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9915999999999998	1716043955166	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043956168	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043956168	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9942	1716043956168	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043957170	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043957170	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9942	1716043957170	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043958172	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043958172	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9942	1716043958172	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043959174	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043959174	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9946	1716043959174	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043960176	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043960176	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9946	1716043960176	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043961178	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043961178	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9946	1716043961178	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043962181	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043962181	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9170999999999998	1716043962181	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043963183	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043963183	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9170999999999998	1716043963183	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043964184	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043964184	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9170999999999998	1716043964184	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043965186	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043965186	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9192	1716043965186	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043966188	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043966188	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9192	1716043966188	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043967190	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043967190	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9192	1716043967190	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043968192	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043968192	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9175	1716043968192	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716043969194	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043969194	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9175	1716043969194	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043970196	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043970196	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9175	1716043970196	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043971198	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043971198	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9176	1716043971198	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716043972200	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043972200	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9176	1716043972200	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043973202	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043973202	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9176	1716043973202	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043974204	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043974204	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9189	1716043974204	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043975206	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.9	1716043975206	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9189	1716043975206	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716043976208	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043976208	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9189	1716043976208	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043977209	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043977209	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9202000000000001	1716043977209	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043978211	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043978211	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9202000000000001	1716043978211	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043979213	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043979213	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9202000000000001	1716043979213	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043980215	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043980215	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043980215	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043981217	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043981217	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043981217	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043982219	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043982219	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043982219	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043983221	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043983221	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9222000000000001	1716043983221	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043984223	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043984223	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9222000000000001	1716043984223	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716043985225	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043985225	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9222000000000001	1716043985225	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043986227	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043986227	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9214	1716043986227	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043987229	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043987229	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9214	1716043987229	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043988231	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043988231	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9214	1716043988231	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043989233	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043989233	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043989233	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043990235	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043990235	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043990235	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043991237	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043991237	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9219000000000002	1716043991237	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043992239	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043992239	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9225	1716043992239	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043993241	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043993241	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9225	1716043993241	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716043994244	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043994244	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9225	1716043994244	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043995246	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043995246	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.922	1716043995246	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716043996248	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043996248	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.922	1716043996248	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043997250	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043997250	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.922	1716043997250	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716043998252	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716043998252	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.921	1716043998252	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716043999253	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716043999253	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.921	1716043999253	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044000255	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044000255	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.921	1716044000255	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044001257	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044001257	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9216	1716044001257	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044002259	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044002259	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9216	1716044002259	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044003261	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044003261	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9216	1716044003261	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044004263	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	4.4	1716044004263	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9233	1716044004263	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044004278	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044005265	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044005265	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9233	1716044005265	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044005286	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044006267	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044006267	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9233	1716044006267	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044006281	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044007269	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044007269	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9242000000000001	1716044007269	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044007292	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044008271	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044008271	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9242000000000001	1716044008271	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044008285	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044009273	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044009273	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9242000000000001	1716044009273	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044009297	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044010275	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044010275	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9269	1716044010275	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044010290	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044011298	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044012294	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044013295	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044014296	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044015302	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044016302	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044017311	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044018305	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044019309	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044020324	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044021321	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044022321	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044023314	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044024318	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044025319	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044026322	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044027323	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044028332	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044029327	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044030329	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044031342	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044032341	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044033345	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044034451	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044035342	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044036345	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044037344	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044038348	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044039358	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044040353	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044041360	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044042354	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044043356	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044044367	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044045361	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044046363	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044047371	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044048375	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044049375	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044050377	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044051379	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044052381	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044053376	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044054377	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044055386	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044056393	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044057385	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044058392	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044059394	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044060388	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044061391	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044062400	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044063402	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044252785	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044253780	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044254786	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044255789	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044256793	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044257784	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044258795	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044259799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044260799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044261794	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044262802	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044011277	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044011277	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9269	1716044011277	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044012279	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044012279	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9269	1716044012279	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044013281	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044013281	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9265999999999999	1716044013281	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044014282	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044014282	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9265999999999999	1716044014282	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044015284	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044015284	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9265999999999999	1716044015284	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716044016286	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044016286	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9292	1716044016286	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044017289	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044017289	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9292	1716044017289	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044018290	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044018290	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9292	1716044018290	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044019292	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044019292	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044019292	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044020294	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044020294	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044020294	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044021296	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044021296	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044021296	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044022298	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044022298	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9312	1716044022298	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044023300	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044023300	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9312	1716044023300	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044024302	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044024302	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9312	1716044024302	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044025304	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044025304	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044025304	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044026306	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044026306	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044026306	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044027308	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044027308	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044027308	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044028310	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044028310	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9274	1716044028310	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044029312	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044029312	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9274	1716044029312	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	98	1716044030314	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044030314	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9274	1716044030314	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044031318	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044031318	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9249	1716044031318	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044032320	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044032320	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9249	1716044032320	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044033322	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044033322	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9249	1716044033322	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044034324	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044034324	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9243	1716044034324	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044035326	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044035326	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9243	1716044035326	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	114	1716044036328	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044036328	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9243	1716044036328	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044037330	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044037330	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9258	1716044037330	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044038332	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044038332	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9258	1716044038332	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044039334	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044039334	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9258	1716044039334	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044040336	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044040336	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044040336	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044041338	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044041338	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044041338	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044042340	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044042340	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044042340	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044043342	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044043342	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9293	1716044043342	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044044344	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044044344	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9293	1716044044344	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044045346	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044045346	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9293	1716044045346	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044046348	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044046348	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9289	1716044046348	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044047350	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044047350	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9289	1716044047350	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044048352	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044048352	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9289	1716044048352	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044049354	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044049354	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9309	1716044049354	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044050355	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044050355	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9309	1716044050355	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044051357	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044051357	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9309	1716044051357	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044052359	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044052359	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.926	1716044052359	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044053361	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044053361	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.926	1716044053361	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044054363	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044054363	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.926	1716044054363	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044055365	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044055365	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9290999999999998	1716044055365	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044056367	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044056367	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9290999999999998	1716044056367	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044057369	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044057369	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9290999999999998	1716044057369	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044058371	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044058371	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9298	1716044058371	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044059373	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044059373	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9298	1716044059373	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044060375	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044060375	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9298	1716044060375	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044061377	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044061377	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044061377	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044062379	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044062379	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044062379	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044063381	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044063381	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9299000000000002	1716044063381	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044064383	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044064383	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044064383	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044064404	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044065385	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044065385	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044065385	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044065408	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044066387	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044066387	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044066387	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044066409	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044067389	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044067389	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9335	1716044067389	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044067410	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044068390	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044068390	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9335	1716044068390	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044068411	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044069392	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044069392	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9335	1716044069392	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044069407	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044070394	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044070394	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044070394	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044070409	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044071397	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044071397	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044071397	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044071413	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044072399	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044072399	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044072399	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044073401	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044073401	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9305999999999999	1716044073401	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044074403	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044074403	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9305999999999999	1716044074403	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044075405	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044075405	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9305999999999999	1716044075405	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044076407	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.7	1716044076407	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044076407	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044077408	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044077408	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044077408	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044078410	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044078410	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9294	1716044078410	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044079412	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044079412	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9316	1716044079412	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044080414	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.5	1716044080414	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9316	1716044080414	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044081417	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3	1716044081417	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9316	1716044081417	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044082419	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044082419	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044082419	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044083421	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044083421	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044083421	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044084422	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044084422	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044084422	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044085425	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044085425	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044085425	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044086426	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044086426	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044086426	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044087428	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044087428	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.934	1716044087428	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044088430	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044088430	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9329	1716044088430	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044089432	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044089432	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9329	1716044089432	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044090434	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044090434	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9329	1716044090434	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044091436	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044091436	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9339000000000002	1716044091436	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044092438	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044092438	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9339000000000002	1716044092438	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044093440	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044093440	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044072412	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044073422	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044074416	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044075419	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044076422	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044077426	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044078423	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044079430	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044080435	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044081439	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044082442	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044083435	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044084446	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044085442	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044086441	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044087441	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044088447	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044089449	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044090448	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044091450	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044092452	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044093456	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044094458	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044095458	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044096460	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044097463	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044098463	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044099470	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044100468	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044101470	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044102472	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044103473	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044104477	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044105480	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044106480	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044107482	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044108483	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044109494	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044110492	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044111498	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044112499	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044113495	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044114504	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044115499	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044116501	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044117500	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044118502	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044119508	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044120509	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044121509	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044122513	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044123515	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044259774	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044259774	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9413	1716044259774	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044260776	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044260776	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9413	1716044260776	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044261778	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044261778	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9413	1716044261778	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044262781	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044262781	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9421	1716044262781	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044263783	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9339000000000002	1716044093440	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044094442	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044094442	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9354	1716044094442	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044095444	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044095444	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9354	1716044095444	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044096446	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044096446	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9354	1716044096446	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044097448	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044097448	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9353	1716044097448	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044098450	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044098450	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9353	1716044098450	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044099452	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044099452	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9353	1716044099452	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	99	1716044100454	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	2.7	1716044100454	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044100454	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044101455	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044101455	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044101455	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044102457	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044102457	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9314	1716044102457	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044103459	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044103459	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.933	1716044103459	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044104462	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044104462	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.933	1716044104462	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044105464	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044105464	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.933	1716044105464	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044106466	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044106466	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9323	1716044106466	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044107468	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044107468	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9323	1716044107468	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044108470	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044108470	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9323	1716044108470	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044109472	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044109472	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9342000000000001	1716044109472	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044110474	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044110474	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9342000000000001	1716044110474	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044111476	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044111476	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9342000000000001	1716044111476	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044112478	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044112478	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044112478	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044113480	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044113480	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044113480	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044114482	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044114482	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044114482	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044115484	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044115484	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044115484	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044116485	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044116485	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044116485	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044117487	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044117487	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9367999999999999	1716044117487	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044118489	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044118489	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9383	1716044118489	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044119491	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044119491	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9383	1716044119491	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044120493	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044120493	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9383	1716044120493	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044121495	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044121495	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9355	1716044121495	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044122496	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044122496	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9355	1716044122496	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044123498	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044123498	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9355	1716044123498	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044124500	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044124500	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9375	1716044124500	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044124514	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044125502	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044125502	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9375	1716044125502	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044125515	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044126504	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044126504	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9375	1716044126504	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044126523	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044127506	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044127506	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9357	1716044127506	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044127523	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044128508	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044128508	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9357	1716044128508	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044128522	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044129510	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044129510	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9357	1716044129510	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044129524	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044130512	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044130512	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385	1716044130512	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044130531	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044131514	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044131514	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385	1716044131514	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044131529	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044132516	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044132516	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385	1716044132516	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044132531	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044133518	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044133518	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9378	1716044133518	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044134520	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044134520	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9378	1716044134520	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044135522	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044135522	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9378	1716044135522	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044136523	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044136523	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044136523	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044137525	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044137525	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044137525	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044138528	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044138528	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044138528	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044139529	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044139529	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044139529	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044140531	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044140531	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044140531	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044141534	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044141534	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044141534	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044142535	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044142535	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9402000000000001	1716044142535	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044143538	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044143538	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9402000000000001	1716044143538	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044144539	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044144539	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9402000000000001	1716044144539	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044145541	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044145541	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9362000000000001	1716044145541	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044146543	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044146543	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9362000000000001	1716044146543	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044147545	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044147545	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9362000000000001	1716044147545	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044148547	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044148547	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044148547	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044149549	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044149549	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044149549	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044150551	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044150551	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9398	1716044150551	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044151553	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044151553	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9397	1716044151553	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044152555	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044152555	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9397	1716044152555	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044153557	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044153557	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9397	1716044153557	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044154559	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044154559	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044133534	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044134536	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044135537	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044136542	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044137543	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044138543	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044139545	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044140545	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044141554	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044142557	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044143552	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044144560	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044145561	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044146558	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044147561	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044148562	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044149564	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044150572	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044151568	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044152576	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044153573	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044154583	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044155582	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044156581	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044157587	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044158584	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044159583	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044160593	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044161593	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044162595	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044163592	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044164602	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044165603	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044166607	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044167608	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044168605	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044169611	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044170615	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044171614	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044172617	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044173619	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044174616	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044175627	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044176628	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044177634	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044178633	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044179630	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044180637	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044181639	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044182641	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044183644	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044263783	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9421	1716044263783	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044264785	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044264785	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9421	1716044264785	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044265787	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	6.1	1716044265787	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044265787	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044266789	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044266789	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044266789	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044267791	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044267791	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044267791	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044154559	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044155561	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044155561	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044155561	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044156563	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044156563	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044156563	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044157565	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044157565	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044157565	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044158567	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044158567	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044158567	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044159569	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044159569	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9395	1716044159569	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044160571	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044160571	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9409	1716044160571	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044161573	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044161573	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9409	1716044161573	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044162574	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044162574	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9409	1716044162574	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044163578	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044163578	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385999999999999	1716044163578	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044164580	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044164580	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385999999999999	1716044164580	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044165582	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044165582	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9385999999999999	1716044165582	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044166584	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044166584	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9377	1716044166584	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044167585	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044167585	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9377	1716044167585	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716044168587	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.8	1716044168587	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9377	1716044168587	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044169589	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044169589	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9372	1716044169589	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044170591	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044170591	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9372	1716044170591	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044171593	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044171593	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9372	1716044171593	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044172595	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044172595	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044172595	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044173598	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044173598	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044173598	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044174600	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044174600	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9389	1716044174600	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044175602	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044175602	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425	1716044175602	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044176605	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044176605	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425	1716044176605	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044177609	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044177609	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425	1716044177609	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044178611	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044178611	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9427	1716044178611	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044179614	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044179614	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9427	1716044179614	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044180616	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044180616	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9427	1716044180616	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044181618	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044181618	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447	1716044181618	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044182620	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044182620	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447	1716044182620	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044183622	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044183622	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447	1716044183622	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044184624	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044184624	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9430999999999998	1716044184624	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044184646	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044185626	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044185626	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9430999999999998	1716044185626	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044185648	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044186628	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.3999999999999995	1716044186628	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9430999999999998	1716044186628	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044186642	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044187630	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044187630	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044187630	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044187696	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044188632	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044188632	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044188632	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044188649	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716044189635	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044189635	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9438	1716044189635	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044189651	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044190637	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044190637	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9422000000000001	1716044190637	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044190660	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044191639	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044191639	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9422000000000001	1716044191639	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044191660	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044192641	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044192641	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9422000000000001	1716044192641	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044192664	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044193643	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044193643	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044193643	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044193659	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044194645	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044194645	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044194645	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044195647	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044195647	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044195647	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044196649	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044196649	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044196649	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044197651	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044197651	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044197651	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044198653	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044198653	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9435	1716044198653	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044199655	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044199655	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425999999999999	1716044199655	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044200656	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044200656	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425999999999999	1716044200656	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044201658	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044201658	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9425999999999999	1716044201658	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044202660	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044202660	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9434	1716044202660	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044203662	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044203662	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9434	1716044203662	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044204664	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044204664	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9434	1716044204664	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044205666	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044205666	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9459000000000002	1716044205666	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044206668	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044206668	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9459000000000002	1716044206668	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044207670	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044207670	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9459000000000002	1716044207670	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044208672	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044208672	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044208672	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044209674	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044209674	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044209674	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044210676	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044210676	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044210676	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044211678	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044211678	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9456	1716044211678	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044212680	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044212680	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9456	1716044212680	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044213682	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044213682	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9456	1716044213682	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044214684	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044214684	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9417	1716044214684	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044215685	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044194663	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044195668	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044196664	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044197666	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044198672	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044199670	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044200680	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044201679	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044202681	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044203677	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044204686	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044205689	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044206682	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044207686	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044208687	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044209695	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044210703	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044211701	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044212695	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044213703	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044214706	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044215706	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044216707	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044217711	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044218705	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044219716	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044220718	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044221716	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044222725	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044223715	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044224728	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044225730	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044226732	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044227734	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044228727	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044229735	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044230737	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044231739	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044232744	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044233736	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044234748	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044235750	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044236743	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044237755	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044238749	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044239751	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044240760	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044241761	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044242756	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044263799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044264807	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044265808	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044266812	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044267813	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044268806	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044269816	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044270819	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044271821	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044272816	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044273824	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044274828	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044275829	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044276831	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044277834	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044278827	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044215685	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9417	1716044215685	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044216687	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044216687	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9417	1716044216687	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044217689	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044217689	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044217689	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044218691	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044218691	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044218691	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044219695	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044219695	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044219695	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044220697	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044220697	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044220697	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044221698	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044221698	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044221698	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044222700	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044222700	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044222700	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044223702	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044223702	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044223702	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044224704	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044224704	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044224704	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044225706	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044225706	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044225706	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044226708	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044226708	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044226708	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044227710	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044227710	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044227710	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044228712	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.6	1716044228712	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044228712	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044229713	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.5	1716044229713	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044229713	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044230715	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044230715	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044230715	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044231718	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044231718	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9447999999999999	1716044231718	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044232720	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044232720	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9449	1716044232720	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044233722	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044233722	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9449	1716044233722	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044234724	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044234724	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9449	1716044234724	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044235728	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044235728	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044235728	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044236730	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044236730	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044236730	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044237732	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044237732	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9432	1716044237732	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044238734	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044238734	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044238734	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044239736	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044239736	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044239736	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044240738	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044240738	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044240738	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044241740	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044241740	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044241740	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044242742	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044242742	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9433	1716044242742	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044268793	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044268793	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9445999999999999	1716044268793	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044269795	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044269795	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9445999999999999	1716044269795	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044270797	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044270797	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9445999999999999	1716044270797	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044271799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044271799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044271799	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044272801	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044272801	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044272801	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044273803	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044273803	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044273803	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044274805	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044274805	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044274805	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044275807	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044275807	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044275807	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044276809	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044276809	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044276809	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044277811	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044277811	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044277811	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044278813	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044278813	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044278813	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044279815	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044279815	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9453	1716044279815	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044279829	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044280817	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044280817	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044280817	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044280831	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044281819	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044281819	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044281819	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044281843	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044282820	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044282820	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9454	1716044282820	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044283822	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044283822	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044283822	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044284824	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044284824	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044284824	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044285826	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044285826	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9457	1716044285826	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044286828	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044286828	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465999999999999	1716044286828	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044287830	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044287830	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465999999999999	1716044287830	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044288832	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044288832	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465999999999999	1716044288832	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044289834	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044289834	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044289834	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044290836	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044290836	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044290836	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044291839	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044291839	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044291839	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044292841	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044292841	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044292841	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044293843	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044293843	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044293843	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044294845	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044294845	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044294845	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044295847	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044295847	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044295847	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044296849	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044296849	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044296849	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044297851	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044297851	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9484000000000001	1716044297851	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044298853	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044298853	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9467	1716044298853	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044299855	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044299855	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9467	1716044299855	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044300857	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044300857	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9467	1716044300857	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044301860	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044301860	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9485999999999999	1716044301860	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044302862	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044302862	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9485999999999999	1716044302862	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044282836	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044283835	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044284845	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044285849	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044286852	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044287844	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044288856	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044289863	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044290859	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044291864	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044292860	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044293858	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044294866	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044295860	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044296871	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044297871	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044298868	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044299880	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044300872	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044301885	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044302881	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044303864	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044303864	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9485999999999999	1716044303864	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044303877	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044304865	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044304865	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044304865	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044304881	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716044305867	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044305867	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044305867	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044305891	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044306869	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044306869	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9482000000000002	1716044306869	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044306883	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044307871	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044307871	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044307871	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044307885	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044308873	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044308873	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044308873	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044308889	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044309875	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044309875	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9437	1716044309875	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044309887	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044310877	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044310877	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044310877	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044310891	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044311878	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044311878	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044311878	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044311902	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044312880	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044312880	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9465	1716044312880	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044312903	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044313882	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044313882	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9458	1716044313882	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044313899	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044314884	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044314884	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9458	1716044314884	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044315886	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044315886	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9458	1716044315886	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044316888	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044316888	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044316888	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044317890	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044317890	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044317890	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044318892	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044318892	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044318892	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044319894	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044319894	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044319894	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044320896	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044320896	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044320896	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044321897	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044321897	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9477	1716044321897	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044322901	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044322901	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044322901	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044323903	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044323903	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044323903	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044324905	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044324905	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9481	1716044324905	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044325907	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044325907	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9478	1716044325907	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044326908	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044326908	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9478	1716044326908	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044327910	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044327910	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9478	1716044327910	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044328912	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044328912	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9487	1716044328912	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044329915	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044329915	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9487	1716044329915	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044330917	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044330917	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9487	1716044330917	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044331918	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044331918	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9473	1716044331918	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044332920	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044332920	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9473	1716044332920	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044333923	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044333923	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9473	1716044333923	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044334925	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044334925	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9513	1716044334925	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044335926	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044314900	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044315907	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044316902	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044317906	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044318906	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044319909	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044320908	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044321913	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044322917	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044323917	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044324918	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044325924	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044326925	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044327934	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044328928	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044329930	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044330939	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044331940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044332934	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044333940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044334940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044335947	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044336952	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044337952	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044338953	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044339951	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044340951	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044341960	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044342957	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044343964	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044344958	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044345963	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044346962	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044347971	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044348975	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044349977	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044350977	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044351982	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044352984	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044353977	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044354978	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044355980	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044356985	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044357991	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044358986	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044359986	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044360999	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044362002	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044362996	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044335926	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9513	1716044335926	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044336928	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044336928	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9513	1716044336928	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044337930	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044337930	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044337930	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044338932	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044338932	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044338932	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044339934	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044339934	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044339934	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044340936	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044340936	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.951	1716044340936	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044341938	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044341938	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.951	1716044341938	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044342940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044342940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.951	1716044342940	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044343942	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044343942	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9507999999999999	1716044343942	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044344944	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044344944	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9507999999999999	1716044344944	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044345946	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044345946	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9507999999999999	1716044345946	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044346948	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044346948	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044346948	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044347950	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044347950	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044347950	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044348952	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044348952	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9504000000000001	1716044348952	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044349954	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044349954	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9530999999999998	1716044349954	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044350956	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044350956	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9530999999999998	1716044350956	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044351958	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044351958	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9530999999999998	1716044351958	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044352960	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044352960	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9533	1716044352960	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044353962	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044353962	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9533	1716044353962	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044354964	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044354964	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9533	1716044354964	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	100	1716044355965	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044355965	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9521	1716044355965	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	105	1716044356967	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	8	1716044356967	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9521	1716044356967	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044357969	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044357969	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9521	1716044357969	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044358971	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044358971	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9544000000000001	1716044358971	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044359973	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044359973	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9544000000000001	1716044359973	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044360975	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044360975	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9544000000000001	1716044360975	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044361978	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044361978	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9538	1716044361978	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044362980	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044362980	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9538	1716044362980	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044363982	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044363982	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9538	1716044363982	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044363995	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044364984	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044364984	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9552	1716044364984	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044365007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044365986	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044365986	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9552	1716044365986	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044366007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044366988	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044366988	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9552	1716044366988	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044367001	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044367990	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044367990	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9549	1716044367990	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044368007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044368992	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044368992	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9549	1716044368992	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044369014	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044369994	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044369994	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9549	1716044369994	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044370015	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044370995	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044370995	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9553	1716044370995	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044371016	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044371998	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044371998	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9553	1716044371998	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044372029	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044373000	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044373000	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9553	1716044373000	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044373019	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044374001	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044374001	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547999999999999	1716044374001	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044374023	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044375003	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044375003	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547999999999999	1716044375003	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044376005	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044376005	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547999999999999	1716044376005	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044377007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044377007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9474	1716044377007	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044378009	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044378009	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9474	1716044378009	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044379011	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044379011	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9474	1716044379011	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044380013	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044380013	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.952	1716044380013	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044381015	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044381015	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.952	1716044381015	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044382017	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044382017	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9522	1716044382017	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044383019	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044383019	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9522	1716044383019	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044384021	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044384021	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9522	1716044384021	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044385023	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044385023	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9539000000000002	1716044385023	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044386025	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044386025	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9539000000000002	1716044386025	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044387027	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044387027	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9539000000000002	1716044387027	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044388029	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044388029	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547	1716044388029	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044389031	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044389031	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547	1716044389031	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044390033	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044390033	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9547	1716044390033	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044391035	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.699999999999999	1716044391035	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.954	1716044391035	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	104	1716044392038	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.6	1716044392038	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.954	1716044392038	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044393040	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.8	1716044393040	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.954	1716044393040	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044394042	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.699999999999999	1716044394042	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9564000000000001	1716044394042	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044395044	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.8	1716044395044	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9564000000000001	1716044395044	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044396045	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.699999999999999	1716044396045	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044375023	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044376025	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044377028	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044378024	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044379025	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044380034	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044381035	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044382039	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044383034	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044384042	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044385044	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044386048	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044387050	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044388044	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044389052	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044390050	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044391057	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044392054	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044393063	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044394057	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044395065	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044396069	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044397071	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044398065	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044399065	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044400074	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Swap Memory GB	0.021	1716044401077	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9564000000000001	1716044396045	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044397047	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.699999999999999	1716044397047	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9557	1716044397047	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044398049	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.8	1716044398049	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9557	1716044398049	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	103	1716044399051	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.699999999999999	1716044399051	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9557	1716044399051	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	102	1716044400053	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	5.8	1716044400053	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9563	1716044400053	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - CPU Utilization	101	1716044401055	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Utilization	7.699999999999999	1716044401055	0da2f51a98f44b57ba144e00fb8bad29	0	f
TOP - Memory Usage GB	1.9563	1716044401055	0da2f51a98f44b57ba144e00fb8bad29	0	f
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
letter	0	a22f7aa001ce4be3a445cc7302ab222f
workload	0	a22f7aa001ce4be3a445cc7302ab222f
listeners	smi+top+dcgmi	a22f7aa001ce4be3a445cc7302ab222f
params	'"-"'	a22f7aa001ce4be3a445cc7302ab222f
file	cifar10.py	a22f7aa001ce4be3a445cc7302ab222f
workload_listener	''	a22f7aa001ce4be3a445cc7302ab222f
letter	0	0da2f51a98f44b57ba144e00fb8bad29
workload	0	0da2f51a98f44b57ba144e00fb8bad29
listeners	smi+top+dcgmi	0da2f51a98f44b57ba144e00fb8bad29
params	'"-"'	0da2f51a98f44b57ba144e00fb8bad29
file	cifar10.py	0da2f51a98f44b57ba144e00fb8bad29
workload_listener	''	0da2f51a98f44b57ba144e00fb8bad29
model	cifar10.py	0da2f51a98f44b57ba144e00fb8bad29
manual	False	0da2f51a98f44b57ba144e00fb8bad29
max_epoch	5	0da2f51a98f44b57ba144e00fb8bad29
max_time	172800	0da2f51a98f44b57ba144e00fb8bad29
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
a22f7aa001ce4be3a445cc7302ab222f	glamorous-skink-611	UNKNOWN			daga	FAILED	1716043759850	1716043803188		active	s3://mlflow-storage/0/a22f7aa001ce4be3a445cc7302ab222f/artifacts	0	\N
0da2f51a98f44b57ba144e00fb8bad29	(0 0) enthused-ox-427	UNKNOWN			daga	FINISHED	1716043906843	1716044402099		active	s3://mlflow-storage/0/0da2f51a98f44b57ba144e00fb8bad29/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	a22f7aa001ce4be3a445cc7302ab222f
mlflow.source.name	file:///home/daga/radt#examples/pytorch	a22f7aa001ce4be3a445cc7302ab222f
mlflow.source.type	PROJECT	a22f7aa001ce4be3a445cc7302ab222f
mlflow.project.entryPoint	main	a22f7aa001ce4be3a445cc7302ab222f
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	a22f7aa001ce4be3a445cc7302ab222f
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a22f7aa001ce4be3a445cc7302ab222f
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a22f7aa001ce4be3a445cc7302ab222f
mlflow.runName	glamorous-skink-611	a22f7aa001ce4be3a445cc7302ab222f
mlflow.project.env	conda	a22f7aa001ce4be3a445cc7302ab222f
mlflow.project.backend	local	a22f7aa001ce4be3a445cc7302ab222f
mlflow.user	daga	0da2f51a98f44b57ba144e00fb8bad29
mlflow.source.name	file:///home/daga/radt#examples/pytorch	0da2f51a98f44b57ba144e00fb8bad29
mlflow.source.type	PROJECT	0da2f51a98f44b57ba144e00fb8bad29
mlflow.project.entryPoint	main	0da2f51a98f44b57ba144e00fb8bad29
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	0da2f51a98f44b57ba144e00fb8bad29
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	0da2f51a98f44b57ba144e00fb8bad29
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	0da2f51a98f44b57ba144e00fb8bad29
mlflow.project.env	conda	0da2f51a98f44b57ba144e00fb8bad29
mlflow.project.backend	local	0da2f51a98f44b57ba144e00fb8bad29
mlflow.runName	(0 0) enthused-ox-427	0da2f51a98f44b57ba144e00fb8bad29
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

