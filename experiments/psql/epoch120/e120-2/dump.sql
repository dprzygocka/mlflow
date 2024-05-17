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
0	Default	s3://mlflow-storage/0	active	1715668822893	1715668822893
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
SMI - Power Draw	14.5	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
SMI - Timestamp	1715669017.756	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
SMI - GPU Util	0	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
SMI - Mem Util	0	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
SMI - Mem Used	0	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
SMI - Performance State	0	1715669017771	0	f	9345de45de6644e2a68ff9b757d61f1b
TOP - CPU Utilization	102	1715672024294	0	f	9345de45de6644e2a68ff9b757d61f1b
TOP - Memory Usage GB	2.5831999999999997	1715672024294	0	f	9345de45de6644e2a68ff9b757d61f1b
TOP - Memory Utilization	7.8	1715672024294	0	f	9345de45de6644e2a68ff9b757d61f1b
TOP - Swap Memory GB	0.0224	1715672024310	0	f	9345de45de6644e2a68ff9b757d61f1b
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.5	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
SMI - Timestamp	1715669017.756	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
SMI - GPU Util	0	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
SMI - Mem Util	0	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
SMI - Mem Used	0	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
SMI - Performance State	0	1715669017771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	0	1715669017827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	0	1715669017827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.6833	1715669017827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669017846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	213.3	1715669018830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669018830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.6833	1715669018830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669019339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669019832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669019832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.6833	1715669019832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669019847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	151	1715669020835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669020835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.946	1715669020835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669020861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669021837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669021837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.946	1715669021837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669021855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669022840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669022840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.946	1715669022840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669022854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669023842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669023842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.949	1715669023842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669023856	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669024844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669024844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.949	1715669024844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669024860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669025846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669025846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.949	1715669025846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669025860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669026848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669026848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9477	1715669026848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669026863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669027851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669027851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9477	1715669027851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669027870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669028853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669028853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9477	1715669028853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669028869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669029855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669029855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9473	1715669029855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669029871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669030858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669030858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9473	1715669030858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669030872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669031860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669031860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9473	1715669031860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669031875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669041894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669047894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.2	1715669047894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3533000000000004	1715669047894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669061923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669061923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3581999999999996	1715669061923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669064930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669064930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636	1715669064930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669065931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669065931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3630999999999998	1715669065931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669067935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669067935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3630999999999998	1715669067935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669069940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669069940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3498	1715669069940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669071943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669071943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3541	1715669071943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669073947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669073947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3541	1715669073947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669319470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669319470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3759	1715669319470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669320472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715669320472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3749000000000002	1715669320472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669323478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669323478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669323478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669325483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669325483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669325483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669326501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669330508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669332513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669338526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669339532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669342521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715669342521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3764000000000003	1715669342521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669344525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669344525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3771999999999998	1715669344525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669350538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669350538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3723	1715669350538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669353546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669353546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3777	1715669353546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669356553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669356553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3792	1715669356553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669361563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669361563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3796999999999997	1715669361563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669362566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669362566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3758000000000004	1715669362566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715669032862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669032862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9485999999999999	1715669032862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669037872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669037872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9482000000000002	1715669037872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669038873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669038873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.948	1715669038873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669039876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669039876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.948	1715669039876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669055928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669062926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669062926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636	1715669062926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669063928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669063928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636	1715669063928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669070941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669070941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3498	1715669070941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669074967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669077972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669319485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669320489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669323494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669326485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669326485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3783000000000003	1715669326485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669330493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.400000000000002	1715669330493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3787	1715669330493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669332498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669332498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3794	1715669332498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669338511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669338511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669338511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669339513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669339513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669339513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669340516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669340516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669340516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669342543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669344541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669350552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669353565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669356568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669361580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669362581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669364585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669366593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669373604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669503883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669508893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669515891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715669515891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669515891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669517896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669517896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669517896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669532931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669032876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669037886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669038886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669047910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669056913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669056913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3562	1715669056913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669062941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669063946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669070958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669077956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669077956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3571	1715669077956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669321474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669321474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3749000000000002	1715669321474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669324480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669324480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669324480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669331496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669331496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3787	1715669331496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669334502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669334502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3794	1715669334502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669335521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669351540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669351540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3723	1715669351540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669360561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669360561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3796999999999997	1715669360561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715669363568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669363568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3758000000000004	1715669363568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669365572	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669365572	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3795	1715669365572	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669370583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669370583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669370583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669377615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669504870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6000000000000005	1715669504870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3854	1715669504870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669506873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669506873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669506873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669509880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715669509880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3857	1715669509880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669511900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669512902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669518898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669518898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669518898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669520903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715669520903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669520903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669521922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669524930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669525932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669530941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669535954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669033864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669033864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9485999999999999	1715669033864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715669036870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669036870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9482000000000002	1715669036870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669039890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669040892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669042899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669048896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669048896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3533000000000004	1715669048896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669049898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669049898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3533000000000004	1715669049898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669050900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669050900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3528000000000002	1715669050900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669051918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669052920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669057915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669057915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3562	1715669057915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669058917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669058917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3562	1715669058917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669059919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669059919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3581999999999996	1715669059919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669060921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669060921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3581999999999996	1715669060921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669066933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669066933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3630999999999998	1715669066933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669068938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669068938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3498	1715669068938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669076970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669321489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669324496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669331511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669335505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669335505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669335505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669337524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669351555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669360576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669363583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669365588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669370598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669504888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669508878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669508878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669508878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669511883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669511883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3857	1715669511883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669512885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669512885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3823000000000003	1715669512885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669513904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669518913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669520920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669033878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669036885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669040878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669040878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.948	1715669040878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669042882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669042882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9499000000000002	1715669042882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0174	1715669045905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669048911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669049913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669050915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669052904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669052904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3528000000000002	1715669052904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669053921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669057930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669058932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669059935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669060937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669066949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669074950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669074950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3556999999999997	1715669074950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669322476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669322476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3749000000000002	1715669322476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669325499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669327504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669329508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669336507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715669336507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669336507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669340534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669341535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669345527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.400000000000002	1715669345527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3771999999999998	1715669345527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669348534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669348534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3734	1715669348534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669349536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715669349536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3734	1715669349536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669352544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669352544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3723	1715669352544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669354548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669354548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3777	1715669354548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669357555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669357555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3792	1715669357555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669359560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669359560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3796999999999997	1715669359560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669367577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669367577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3795	1715669367577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669368594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669369597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669374591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669374591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669374591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669034866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669034866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9485999999999999	1715669034866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669035868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669035868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9482000000000002	1715669035868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669043885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669043885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9499000000000002	1715669043885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669044887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669044887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.1333	1715669044887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669046891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669046891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.1333	1715669046891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669051902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669051902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3528000000000002	1715669051902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669054908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669054908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3526	1715669054908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669055911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669055911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3526	1715669055911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669072945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669072945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3541	1715669072945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669075952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669075952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3556999999999997	1715669075952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669076954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669076954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3556999999999997	1715669076954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669322491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669327487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715669327487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3783000000000003	1715669327487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669329491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669329491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3787	1715669329491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669334519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669336522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669341518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669341518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3764000000000003	1715669341518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669343523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669343523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3764000000000003	1715669343523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669345544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669348551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669349551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669352559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669354563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669357570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669359574	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669368579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669368579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669368579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669369581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669369581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669369581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669372587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715669372587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3825	1715669372587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669034884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669035890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.016399999999999998	1715669043897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0174	1715669044901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0174	1715669046905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669053906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669053906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3526	1715669053906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669054925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669067952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669072961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669075966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669328489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669328489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3783000000000003	1715669328489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669333500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669333500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3794	1715669333500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669337509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669337509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3756	1715669337509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669346530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669346530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3771999999999998	1715669346530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669347532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669347532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3734	1715669347532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669355550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669355550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3777	1715669355550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669358557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669358557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3792	1715669358557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669367592	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669371604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669375593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669375593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669375593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669376595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669376595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669376595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669378615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669524913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669524913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669524913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669525915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669525915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669525915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669530926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669530926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669530926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669535938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669535938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669535938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669538944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669538944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669538944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669543956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669543956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.389	1715669543956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669544958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669544958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.389	1715669544958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669549968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669041880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715669041880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	1.9499000000000002	1715669041880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669045889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669045889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.1333	1715669045889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669056931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.018600000000000002	1715669061943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669064946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669065950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669068958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669069956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669071959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669073965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669078958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669078958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3571	1715669078958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669078972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669079960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669079960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3571	1715669079960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669079978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669080961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669080961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669080961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669080983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669081963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669081963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669081963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669081978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669082966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669082966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669082966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669082980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669083968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669083968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669083968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669083982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669084970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669084970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669084970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669084985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669085972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669085972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3575999999999997	1715669085972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669085986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669086974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669086974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3574	1715669086974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669086990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669087976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669087976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3574	1715669087976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669087992	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669088978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669088978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3574	1715669088978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669088995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669089980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669089980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3579	1715669089980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669089995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669090982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669090982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3579	1715669090982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669094005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669095006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669096009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669101005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669101005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.359	1715669101005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669105013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669105013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3618	1715669105013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669106016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669106016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3618	1715669106016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669111026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669111026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3666	1715669111026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669113030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669113030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3684000000000003	1715669113030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669114031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669114031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3684000000000003	1715669114031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669117054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669118055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669126072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669127074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669131083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669133086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669134087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669135093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669328507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669333514	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669343538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669346546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669347549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669355566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669358572	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669371585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669371585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3825	1715669371585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669372602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669375608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669378600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669378600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669378600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669532931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669532931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669533933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669533933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669533933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669534936	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669534936	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669534936	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669536955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669539963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669542968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669545975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	109	1715669554980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669554980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669554980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669555982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669555982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669555982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669557986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669090997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669094990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669094990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3577	1715669094990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669095993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669095993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3596999999999997	1715669095993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669099001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669099001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.359	1715669099001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669101021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669105028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669108034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669111042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669113046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669114047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669118040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669118040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669118040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669120059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669127059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669127059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3644000000000003	1715669127059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669131067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669131067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3657	1715669131067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669133071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669133071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3657	1715669133071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669134074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669134074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669134074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669135076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669135076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669135076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669364570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669364570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3758000000000004	1715669364570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669366575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669366575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3795	1715669366575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669373589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669373589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3825	1715669373589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669377598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669377598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669377598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669538959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669543971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669544974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669549984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669551988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669552990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669559004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669564015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669573018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669573018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916	1715669573018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669583040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669583040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669583040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	111	1715669584042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669584042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669584042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669091984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669091984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3579	1715669091984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669097009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669100003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669100003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.359	1715669100003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669102023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669107037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669110024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669110024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3666	1715669110024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669112028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669112028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3666	1715669112028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669119042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669119042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3613000000000004	1715669119042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669123066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669126057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669126057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3644000000000003	1715669126057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669129079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669130079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669132085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669374607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715669549968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669549968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669551973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669551973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669551973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669552975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715669552975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669552975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669558988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669558988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669558988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669563999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669563999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669563999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669570027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669573033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669583058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669584056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669598087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669599092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669608109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669611114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669612118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669618131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669631160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669633163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669634168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669635168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669644172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.200000000000001	1715669644172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3912	1715669644172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669646177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669646177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669646177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669650203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669653193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669653193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3924000000000003	1715669653193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669091998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669107018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669107018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3643	1715669107018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669116036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669116036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669116036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669122048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669122048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3651	1715669122048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669125055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669125055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3644000000000003	1715669125055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669136092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669137096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669376609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669553977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669553977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669559990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669559990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669559990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669560992	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669560992	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669560992	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669562009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669565016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669572016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669572016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669572016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669582038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669582038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669582038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669586047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669586047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935999999999997	1715669586047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669590055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669590055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3845	1715669590055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669591057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669591057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669591057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669594063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669594063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669594063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669595065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669595065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669595065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669601079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669601079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3933	1715669601079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669605088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669605088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3928000000000003	1715669605088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669607091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669607091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669607091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669609096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669609096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669609096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669610098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669610098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669610098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669615109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669615109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669092986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669092986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3577	1715669092986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669093989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669093989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3577	1715669093989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669099017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669103009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669103009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3628	1715669103009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669106032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669115033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669115033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3684000000000003	1715669115033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669117038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669117038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669117038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669120044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669120044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3613000000000004	1715669120044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669121060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669124068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669128078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669138095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669379602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669379602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836	1715669379602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669385616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669385616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669385616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669386632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669390625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669390625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3813	1715669390625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669391627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669391627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3813	1715669391627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669392629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715669392629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.382	1715669392629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669397641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715669397641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3842	1715669397641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669399646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669399646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669399646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669412674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669412674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.381	1715669412674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669414678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669414678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3819	1715669414678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669416682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669416682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669416682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669419707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669423698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715669423698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3867	1715669423698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669429711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669429711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669429711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669430713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669430713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669093004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669097997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669097997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3596999999999997	1715669097997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669102007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669102007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3628	1715669102007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669103025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669109037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669115048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669119058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669121046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669121046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3613000000000004	1715669121046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669124052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669124052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3651	1715669124052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669128061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669128061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636999999999997	1715669128061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669138081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669138081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3691	1715669138081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669379617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669385630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669388621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715669388621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3811	1715669388621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669390639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669391642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669392644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669397655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669408680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669412689	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669414693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669419689	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669419689	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669419689	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669421693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669421693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669421693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669423712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669429727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669430729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669431731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669436740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669556984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669566003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669566003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669566003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669569010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669569010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669569010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669571014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669571014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669571014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669574021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669574021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916	1715669574021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669577027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715669577027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3903000000000003	1715669577027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669579047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669581035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669096995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669096995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3596999999999997	1715669096995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669098013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669100019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669104011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669104011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3618	1715669104011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669109021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669109021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3643	1715669109021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669110039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669112044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669123050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669123050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3651	1715669123050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669125072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669129063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669129063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636999999999997	1715669129063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669130065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669130065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3636999999999997	1715669130065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669132069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669132069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3657	1715669132069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669380604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669380604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3815999999999997	1715669380604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669387620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669387620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3811	1715669387620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669388635	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669395637	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669395637	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3842	1715669395637	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669402652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669402652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669402652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669404656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669404656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669404656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669406661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669406661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669406661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669407664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669407664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669407664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669410670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.2	1715669410670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.381	1715669410670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669413691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669416698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669424715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669435723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669435723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.388	1715669435723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669438730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.2	1715669438730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669438730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669557986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669557986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669561006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669563014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669104026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669108020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669108020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3643	1715669108020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669116049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669122063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669136078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669136078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669136078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669137080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715669137080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3691	1715669137080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669139083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669139083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3691	1715669139083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669139098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669140086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669140086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669140086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669140100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669141088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669141088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669141088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669141104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669142090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669142090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669142090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669142105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669143091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669143091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3675	1715669143091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669143108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669144093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669144093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3675	1715669144093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669144109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669145095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669145095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3675	1715669145095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669145113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669146097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669146097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669146097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669146112	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669147099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669147099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669147099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669147114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669148101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669148101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669148101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669148119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669149104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669149104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3698	1715669149104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669149120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669150106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669150106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3698	1715669150106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669150121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669151108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669151108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3698	1715669151108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669151123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669152111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669152111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3688000000000002	1715669152111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669153128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669164136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669164136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669164136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669171151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669171151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669171151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669177178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669181189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669184194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669196205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.799999999999999	1715669196205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669196205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669380621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669387636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669389623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669389623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3813	1715669389623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669399661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669402666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669404670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669406677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669407679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669410685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669415680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669415680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3819	1715669415680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669424700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669424700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3867	1715669424700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669425719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669435741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669567022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669568025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669575037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669576041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669578045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669580033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669580033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669580033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669589069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669593076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669597085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669600093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669606090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669606090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669606090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669613104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669613104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3870999999999998	1715669613104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669614106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669614106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3870999999999998	1715669614106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669632146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669632146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669632146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669637157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669637157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669637157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669640163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669640163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669152128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669155117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669155117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3699	1715669155117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669157121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669157121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3699	1715669157121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669161130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669161130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701	1715669161130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669167142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669167142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669167142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669169147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669169147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669169147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669173155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715669173155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669173155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669174157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669174157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669174157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669176161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669176161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669176161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669183177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669183177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3725	1715669183177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669188188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669188188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669188188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669189205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669191213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669192212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669193213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669194214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669195217	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669198224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669381607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669381607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3815999999999997	1715669381607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669393633	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669393633	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.382	1715669393633	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669395652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669403669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669405673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669411685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669417700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669420706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669426705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669426705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669426705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669432718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669432718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669432718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669433735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669437743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669581035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669581035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669585045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669585045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935999999999997	1715669585045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669587049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669153113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669153113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3688000000000002	1715669153113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669154115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.399999999999999	1715669154115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3688000000000002	1715669154115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669156134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669159140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669160143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669162147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669165138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715669165138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669165138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669166140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669166140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3641	1715669166140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669170149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.2	1715669170149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669170149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669171165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669172168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669177163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669177163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669177163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669181172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669181172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669181172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669184179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669184179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3725	1715669184179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669185198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669187201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669196219	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669197207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669197207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3731	1715669197207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669381622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669393649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669403654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669403654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669403654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669405659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669405659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669405659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669411672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669411672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.381	1715669411672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669417685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715669417685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669417685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669420691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669420691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669420691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669422696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669422696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3867	1715669422696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669426721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669433720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669433720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669433720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669437728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669437728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669437728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669587049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669154129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669155133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669157136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669162132	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669162132	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701	1715669162132	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669167158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669169162	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669173171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669174175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669176177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669183196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669189190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669189190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669189190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669191193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669191193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669191193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669192196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669192196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669192196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669193198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669193198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669193198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669194201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669194201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669194201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669195203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669195203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669195203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669198209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669198209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3731	1715669198209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669382609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669382609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3815999999999997	1715669382609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669383611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669383611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669383611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669384613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669384613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3817	1715669384613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669386618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669386618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3811	1715669386618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669394635	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.2	1715669394635	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.382	1715669394635	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669396639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669396639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3842	1715669396639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669398644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669398644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669398644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669400648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669400648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669400648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669401650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669401650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669401650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669408666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669408666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669408666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669409683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669156119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669156119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3699	1715669156119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669159126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669159126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.369	1715669159126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669160128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669160128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.369	1715669160128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669161148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669165154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669166154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669172153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669172153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701999999999996	1715669172153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669187186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669187186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669187186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669190191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669190191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669190191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669197223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669382625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669383626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669384628	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669389638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669394651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669396653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669398658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669400662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669401664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669409668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669409668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669409668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669413676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669413676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3819	1715669413676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669418687	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669418687	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3844000000000003	1715669418687	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669421708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669425702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669425702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669425702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669427724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669428724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669434735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669438745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935999999999997	1715669587049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669588051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669588051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3845	1715669588051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669592059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669592059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669592059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669596068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669596068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669596068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669602082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669602082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3933	1715669602082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669603100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669604101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669616126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669158123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669158123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.369	1715669158123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669163134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669163134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3701	1715669163134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669164150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669168160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669175159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669175159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669175159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669178166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669178166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669178166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669179168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669179168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669179168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669180171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669180171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3724000000000003	1715669180171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669182175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669182175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3725	1715669182175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669185181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669185181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669185181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669186198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669190206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669415696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669418703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669422711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669427706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669427706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669427706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669428709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669428709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669428709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669434721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669434721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.388	1715669434721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669436725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669436725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.388	1715669436725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669598073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669598073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669598073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669599075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669599075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669599075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669608094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669608094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669608094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669611100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669611100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669611100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669612102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669612102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3870999999999998	1715669612102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669618116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669618116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669618116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669638159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669638159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669638159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669158144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669163149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669168144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669168144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.366	1715669168144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669170170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669175173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669178179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669179186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669180188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669182192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669186183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669186183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669186183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669188205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669199212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669199212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3731	1715669199212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669199227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669200214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669200214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3738	1715669200214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669200230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669201216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669201216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3738	1715669201216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669201232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669202218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669202218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3738	1715669202218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0201	1715669202234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669203220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669203220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669203220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669203238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669204222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669204222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669204222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669204237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669205224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669205224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669205224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669205242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669206226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669206226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3733	1715669206226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669206243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669207228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4.5	1715669207228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3733	1715669207228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669207244	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669208230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669208230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3733	1715669208230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669208248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669209233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669209233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735	1715669209233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669209247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669210235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669210235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735	1715669210235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669210251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669211237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669211237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735	1715669211237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669219253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669219253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676	1715669219253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669220256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715669220256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676	1715669220256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669221258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669221258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676999999999997	1715669221258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669225267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13	1715669225267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3687	1715669225267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669230296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669231295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669234302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669236305	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669248317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669248317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669248317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669252342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669430713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669431715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669431715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669431715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669432732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669606106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669613119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669614124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669639161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669639161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669639161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669643170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669643170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3912	1715669643170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669647179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669647179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669647179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669648182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669648182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669648182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669649184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669649184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669649184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669651205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669652207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669654195	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669654195	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669654195	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669654211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669655197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669655197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669655197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669655212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669656199	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669656199	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3914	1715669656199	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669656215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669657201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669657201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669657201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669657217	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669658203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669211253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669219275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669220276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669221273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669225282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669231280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669231280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3726	1715669231280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669234286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669234286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669234286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669236290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669236290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.371	1715669236290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669247329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669252326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669252326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669252326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669253346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669439732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669439732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669439732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669442754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669443757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669445764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669446762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669447764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669452760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715669452760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3843	1715669452760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669455766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669455766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669455766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669457771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669457771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669457771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669459775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669459775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3866	1715669459775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669461779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669461779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3868	1715669461779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669466790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.2	1715669466790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3835	1715669466790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669467791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669467791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669467791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669469812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669479817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669479817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669479817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669483825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669483825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669483825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669485830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669485830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3878000000000004	1715669485830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669486847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669493862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669495865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669496868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3893	1715669615109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669639177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669212239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669212239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669212239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669217249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669217249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3664	1715669217249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669233284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669233284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669233284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669235288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669235288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3727	1715669235288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669238295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669238295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.371	1715669238295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669244308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.799999999999999	1715669244308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3745	1715669244308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669246312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669246312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3744	1715669246312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669248335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669254344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669255350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669256348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669439747	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669443740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669443740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669443740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669445745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669445745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669445745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669446747	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669446747	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669446747	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669447749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.2	1715669447749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669447749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669450771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669452773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669455781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669457785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669459792	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669464786	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669464786	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3835	1715669464786	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669466805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669467807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669475824	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669480834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669483839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669485844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669493846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669493846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669493846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669495850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669495850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3848000000000003	1715669495850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669496852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669496852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3848000000000003	1715669496852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669617128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669640163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669641165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669212255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669229293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669233300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669235304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669238314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669244323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669246328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669254330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669254330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669254330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669255331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13	1715669255331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669255331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669256333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669256333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669256333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669440734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715669440734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836999999999997	1715669440734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669441736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669441736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836999999999997	1715669441736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669442738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715669442738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3836999999999997	1715669442738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669448766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669449769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669456769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669456769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669456769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669468811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669474806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669474806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669474806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669476811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669476811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876	1715669476811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669477828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669481821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715669481821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669481821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669491842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669491842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669491842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669492862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669619118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669619118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669619118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669621123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669621123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3925	1715669621123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669622141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669623144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669624145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669626150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669628138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669628138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669628138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669630142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669630142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669630142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669636155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669636155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669636155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669213241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669213241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669213241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669214243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669214243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669214243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669215245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669215245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3664	1715669215245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669216247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669216247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3664	1715669216247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669217264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669223277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669226284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669227285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669232282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669232282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3726	1715669232282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715669239298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669239298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669239298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669241316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669250322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669250322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669250322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669253328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669253328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669253328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669440750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669441752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669448751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669448751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3834	1715669448751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669449753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669449753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669449753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669451757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669451757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669451757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669468793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669468793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669468793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669469796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.699999999999999	1715669469796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3869000000000002	1715669469796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669474820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669477813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669477813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876	1715669477813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669478834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669481838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669492844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715669492844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669492844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669619135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669622125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669622125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3925	1715669622125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669623127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715669623127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3925	1715669623127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669624129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669624129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669213256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669214260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669215263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669216265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669222276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669226269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669226269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3687	1715669226269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669227271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669227271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3719	1715669227271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669229275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669229275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3719	1715669229275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669232298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669241302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669241302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669241302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669242304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669242304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3745	1715669242304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669250338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669444743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4.7	1715669444743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3824	1715669444743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669450755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669450755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.384	1715669450755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669458773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669458773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3866	1715669458773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669460777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669460777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3866	1715669460777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669462797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669465788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669465788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3835	1715669465788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669470798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669470798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3881	1715669470798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669472818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669476826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715669489838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669489838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3801	1715669489838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669490840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669490840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3801	1715669490840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669491857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669494866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669498872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669620121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669620121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669620121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669629140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669629140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669629140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669641165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669641165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669642184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669645175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669645175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3907	1715669645175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669218251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669218251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676	1715669218251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669222260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669222260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676999999999997	1715669222260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669224265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669224265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3687	1715669224265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669228273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669228273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3719	1715669228273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669230278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669230278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3726	1715669230278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669237309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669240300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669240300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3707	1715669240300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669242319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669243320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669245324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669249319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669249319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3755	1715669249319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669251324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669251324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3750999999999998	1715669251324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669257335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669257335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669257335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669258338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669258338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669258338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669444758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669454764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.499999999999999	1715669454764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3843	1715669454764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669458787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669462781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715669462781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3868	1715669462781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669464802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669465805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669470816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669475808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669475808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669475808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669480819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715669480819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3865	1715669480819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669489854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669490857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669494848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669494848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3848000000000003	1715669494848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669498857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669498857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3853	1715669498857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669620138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669629154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669643186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669647195	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669648196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669218266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669223262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669223262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3676999999999997	1715669223262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669224279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669228287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669237293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669237293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.371	1715669237293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669239311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669240315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669243306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669243306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3745	1715669243306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669245310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669245310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3744	1715669245310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669247314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669247314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3744	1715669247314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669249334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669251338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669257351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669258352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669259340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669259340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669259340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669259357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669260342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669260342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3747	1715669260342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669260357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669261344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669261344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3747	1715669261344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669261359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669262346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669262346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3747	1715669262346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669262361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715669263349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669263349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3722	1715669263349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669263364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669264351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669264351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3722	1715669264351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669264365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669265353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669265353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3722	1715669265353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669265369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669266355	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669266355	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669266355	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669266370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669267358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669267358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669267358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669267375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669268360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.799999999999999	1715669268360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669268360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669268375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669269362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669269362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3761	1715669269362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669270364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669270364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3761	1715669270364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669271366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669271366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3761	1715669271366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669276377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669276377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3768000000000002	1715669276377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669278381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669278381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669278381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669279383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669279383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669279383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669281388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669281388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.377	1715669281388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669282391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669282391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.377	1715669282391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669286399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669286399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669286399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669289421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669291425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669292427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669293428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669297438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669314458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669314458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669314458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669317465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669317465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3759	1715669317465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669451773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669453777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669456785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669461796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669463797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669471819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669473804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669473804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669473804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669478815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715669478815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876	1715669478815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669482823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14	1715669482823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669482823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669484828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669484828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669484828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669486831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669486831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3878000000000004	1715669486831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669487850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669488851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669497870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669621140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669625147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669269377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669270380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669271381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669276391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669278399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669280408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669281405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669284395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715669284395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669284395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669289405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669289405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3721	1715669289405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669291410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669291410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669291410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669292412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.899999999999999	1715669292412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669292412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669293413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669293413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669293413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669297422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.899999999999999	1715669297422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669297422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669299439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669316477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669317481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669453762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669453762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3843	1715669453762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669454783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669460794	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669463784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715669463784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3868	1715669463784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669471800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.899999999999999	1715669471800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3881	1715669471800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669472802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669472802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3881	1715669472802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669473821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669479832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669482839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669484846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669487833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669487833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3878000000000004	1715669487833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669488836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.3	1715669488836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3801	1715669488836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669497854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669497854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3853	1715669497854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669624129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669626133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669626133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669626133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669627154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669628156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669630157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669636173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669638176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669272369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669272369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.375	1715669272369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669275390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669283393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669283393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.377	1715669283393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669285397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669285397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669285397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669296420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669296420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669296420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669298439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715669304437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	2.8	1715669304437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3767	1715669304437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669306441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669306441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3789000000000002	1715669306441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669312454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669312454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3746	1715669312454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669313456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669313456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3746	1715669313456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669318483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669499859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669499859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3853	1715669499859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669502865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669502865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669502865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669505871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669505871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3854	1715669505871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669507876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669507876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669507876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669514890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669514890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3823000000000003	1715669514890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669516893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669516893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.387	1715669516893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669519901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669519901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3875	1715669519901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669523910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715669523910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669523910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669526917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669526917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669526917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669527919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715669527919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3886999999999996	1715669527919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669531930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669531930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669531930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669537942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669537942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669537942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669553977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669272387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669279399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669284410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669285413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	107	1715669298424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669298424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3743000000000003	1715669298424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669302448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669304453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669307444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669307444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3789000000000002	1715669307444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669312469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669313470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669499879	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669502884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669505888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669510898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669514906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669516909	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669519917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669523925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669526932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669527937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669531951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669547980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669553991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669560005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669561994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669561994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669561994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669565001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669565001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3828	1715669565001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669570012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669570012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3899	1715669570012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669572033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669582139	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669586062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669590072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669591074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669594078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669595081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669601096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669605105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669607106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669609111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669610113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669615124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669625131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669625131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669625131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669627135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669627135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669627135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669632166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669637172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669640179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669641182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669645190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669649200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669651189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715669651189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3924000000000003	1715669651189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669273371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.3	1715669273371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.375	1715669273371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669274373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669274373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.375	1715669274373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669275375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669275375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3768000000000002	1715669275375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669288419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669294416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669294416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669294416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669295418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715669295418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669295418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669303435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669303435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3767	1715669303435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669307459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669309462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669310466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669316463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715669316463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669316463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669500861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669500861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669500861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669501863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669501863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3851999999999998	1715669501863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669506890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669510881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669510881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3857	1715669510881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669522907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669522907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669522907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669528921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669528921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3886999999999996	1715669528921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669529923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669529923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3886999999999996	1715669529923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669536940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669536940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3926999999999996	1715669536940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669540950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669540950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3898	1715669540950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669541952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669541952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3898	1715669541952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669546962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669546962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669546962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669548966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669548966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669548966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669550970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669550970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3876999999999997	1715669550970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	110	1715669556984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669556984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669273387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669274389	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669277379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669277379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3768000000000002	1715669277379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669277394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669280386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.799999999999999	1715669280386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3775	1715669280386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669282416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669283407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669286416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669287401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669287401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3721	1715669287401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669287416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669288403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715669288403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3721	1715669288403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669290408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669290408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3735999999999997	1715669290408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669290425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669294431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669295436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669296434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669299426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715669299426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669299426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669300428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669300428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669300428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669300444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669301430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669301430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3784	1715669301430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669301444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669302433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669302433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3767	1715669302433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669303450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669305439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.8	1715669305439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3789000000000002	1715669305439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669305455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669306456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669308446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669308446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669308446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669308459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669309448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669309448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669309448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669310450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669310450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3781999999999996	1715669310450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669311452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669311452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3746	1715669311452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669311469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669314474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669315460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669315460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3763	1715669315460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669315477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669500876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669501879	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669509896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669521905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669521905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669521905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669522923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669528938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669529939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669537959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669540967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669541967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669546978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669548981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669550986	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669557001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669566018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669569026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669571029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669574037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669577042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669580051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669581052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669585061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669587063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669588066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669592074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669596085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669603084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669603084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3928000000000003	1715669603084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669604086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715669604086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3928000000000003	1715669604086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669616111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669616111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3893	1715669616111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669617113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669617113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3893	1715669617113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669631144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669631144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669631144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669633148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669633148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669633148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669634150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669634150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669634150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669635152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669635152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669635152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669642168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669642168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3912	1715669642168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669644187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669646191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669650186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.900000000000002	1715669650186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.391	1715669650186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669652191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669652191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3924000000000003	1715669652191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669653209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669318467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.4	1715669318467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3759	1715669318467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669503868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669503868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3854	1715669503868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669507892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669513888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669513888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3823000000000003	1715669513888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669515906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669517911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0209	1715669532948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669533953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669534953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669539948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669539948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3898	1715669539948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669542954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669542954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.389	1715669542954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669545960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669545960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669545960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669547964	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669547964	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3874	1715669547964	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669554994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669555997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669558003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669562996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715669562996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669562996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669567006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715669567006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669567006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669568008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669568008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3882	1715669568008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669575023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669575023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916	1715669575023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669576025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669576025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3903000000000003	1715669576025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669578029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669578029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3903000000000003	1715669578029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669579031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.5	1715669579031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3921	1715669579031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669589053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715669589053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3845	1715669589053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669593061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715669593061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669593061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669597070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715669597070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669597070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669600077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669600077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3933	1715669600077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669602099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715669658203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669658203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669663214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669663214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669663214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669664216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669664216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669664216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669667237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669670245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669672249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669673254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669685261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669685261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669685261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669687265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669687265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669687265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669690287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669697302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669703313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669704316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669705317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669707323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669709327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669711332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715669713319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.100000000000001	1715669713319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669713319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669721335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715669721335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3971	1715669721335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669728350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669728350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669728350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669730354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669730354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3977	1715669730354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669731357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669731357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3977	1715669731357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669732359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669732359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669732359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669734363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669734363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669734363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669736368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669736368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.394	1715669736368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669739374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669739374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3954	1715669739374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669742395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669744385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669744385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3962	1715669744385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669747391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669747391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3964000000000003	1715669747391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669749396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669749396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3964000000000003	1715669749396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669750397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669658221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669661210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715669661210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669661210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669666221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669666221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669666221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669675240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669675240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669675240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669683257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669683257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3949000000000003	1715669683257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669693278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669693278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669693278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669694280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669694280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669694280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669700291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669700291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669700291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669701293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669701293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669701293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669706304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669706304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3965	1715669706304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669712317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669712317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669712317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669714336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669715343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669719346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669722353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669723356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669725359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669738372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669738372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3954	1715669738372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669739390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669750397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3979	1715669750397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669752401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669752401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3979	1715669752401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669753421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669757412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.200000000000001	1715669757412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669757412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669758414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669758414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669758414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669760418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669760418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3983000000000003	1715669760418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715669761421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	16.6	1715669761421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3983000000000003	1715669761421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669762423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669762423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4011	1715669762423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669765430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669765430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669659205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.200000000000001	1715669659205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669659205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669661229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669666238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669675257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669683274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669693292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669694295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669700306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669701308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669706321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669714321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669714321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966999999999996	1715669714321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669715323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669715323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966999999999996	1715669715323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669719331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669719331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3981	1715669719331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669722338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669722338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3971	1715669722338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669723340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715669723340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.397	1715669723340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669725343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669725343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.397	1715669725343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669733361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669733361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669733361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669740376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715669740376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3954	1715669740376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669743383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669743383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966	1715669743383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669745405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669746405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669748410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669759416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669759416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3983000000000003	1715669759416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669761435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669762439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669764427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669764427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4011	1715669764427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669765444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669766445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669768435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669768435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.402	1715669768435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669770456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669774447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669774447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669774447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669776452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669776452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669776452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669778456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669778456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669659222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669663231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669667223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669667223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669667223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	110	1715669670229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715669670229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3931999999999998	1715669670229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669672233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669672233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669672233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669673236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669673236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669673236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669674252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669685277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669690271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669690271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669690271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669697286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669697286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669697286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669703298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669703298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669703298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669704300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669704300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669704300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669705302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669705302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3965	1715669705302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669707306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669707306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3965	1715669707306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669709311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669709311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.395	1715669709311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669711315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669711315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669711315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669712334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669713335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669721350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669728364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669730371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669731375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669732374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669734380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669736384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669740393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669745387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669745387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3962	1715669745387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669746389	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.100000000000001	1715669746389	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3962	1715669746389	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669748393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669748393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3964000000000003	1715669748393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669752417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669760438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669764443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4015999999999997	1715669765430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669766431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669660208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715669660208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669660208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669662212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669662212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669662212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669664232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669668306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669676258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669678261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669680250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669680250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3953	1715669680250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669684259	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669684259	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669684259	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669687281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669688284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669695299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669696299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669698304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669718346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669720348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669726364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669735366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715669735366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.394	1715669735366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669741378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669741378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966	1715669741378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669744399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669751415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669754422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669756410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669756410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669756410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669759431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669763440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669766431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4015999999999997	1715669766431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669767448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669770439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669770439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.402	1715669770439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669771457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669773463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669775450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669775450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669775450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669776467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4004000000000003	1715669778456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669779473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669780477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669781478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669782464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669782464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4024	1715669782464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669782479	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669784469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669784469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4003	1715669784469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669785489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669786474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669786474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4017	1715669786474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669660222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669662228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669668225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669668225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3922	1715669668225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669676242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.900000000000002	1715669676242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669676242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669678246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715669678246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3953	1715669678246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669679263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669680268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669684273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669688267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669688267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669688267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669695282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669695282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3918000000000004	1715669695282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669696284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669696284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669696284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669698288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669698288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3934	1715669698288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669718330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669718330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3981	1715669718330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669720333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669720333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3971	1715669720333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669726345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669726345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669726345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669733379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669735382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669741397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669751399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669751399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3979	1715669751399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669754406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715669754406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3985	1715669754406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669755408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669755408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3985	1715669755408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669756428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669763425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669763425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4011	1715669763425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669767433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669767433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4015999999999997	1715669767433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669768452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669771441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669771441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4021999999999997	1715669771441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669773445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669773445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4021999999999997	1715669773445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669774462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669775465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669779458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669665219	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715669665219	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669665219	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669669227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669669227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3931999999999998	1715669669227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669671231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669671231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3931999999999998	1715669671231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669674238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669674238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669674238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669677260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669681253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669681253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3949000000000003	1715669681253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669682254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715669682254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3949000000000003	1715669682254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669686263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715669686263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3956999999999997	1715669686263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669689270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715669689270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3916999999999997	1715669689270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669691273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669691273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669691273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669692275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669692275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.392	1715669692275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669699290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669699290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.393	1715669699290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669702296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669702296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3938	1715669702296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669708309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669708309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.395	1715669708309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669710313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715669710313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.395	1715669710313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669716325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669716325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966999999999996	1715669716325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669717328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715669717328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3981	1715669717328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669724341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669724341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.397	1715669724341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669727348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669727348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3995	1715669727348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669729352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669729352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3977	1715669729352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669737370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715669737370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.394	1715669737370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669738390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669742381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.300000000000001	1715669742381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669665233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669669241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669671246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669677244	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.100000000000001	1715669677244	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3935	1715669677244	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669679248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.200000000000001	1715669679248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3953	1715669679248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669681269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669682269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669686278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669689286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669691291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669692294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669699308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669702309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669708324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669710330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669716340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669717343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669724359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669727365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669729368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669737388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3966	1715669742381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669743398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669747408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669749412	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669750413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669753403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715669753403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.3985	1715669753403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669755425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669757426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669758430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669769437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669769437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.402	1715669769437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669769451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669772443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669772443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4021999999999997	1715669772443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669772458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669777454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669777454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4004000000000003	1715669777454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669777470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669778472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669779458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4004000000000003	1715669779458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669780460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669780460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4024	1715669780460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669781462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715669781462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4024	1715669781462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669783467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669783467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4003	1715669783467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669783481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669784483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669785471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715669785471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4003	1715669785471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669786490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669790499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669791501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669793507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669797514	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669800504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669800504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669800504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669802509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669802509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669802509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669804513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669804513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4044	1715669804513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669805530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669806533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669807533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669808538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669809543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669811528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669811528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669811528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669816539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669816539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669816539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669817558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669821550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669821550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.405	1715669821550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669822551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669822551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669822551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669824570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669833573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669833573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669833573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669844600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669844600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4036	1715669844600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669853619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669853619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4053	1715669853619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669858630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669858630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669858630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670219400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670219400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670219400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670222422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670223423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670228419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670228419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4187	1715670228419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670235434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670235434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4214	1715670235434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670242449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670242449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670242449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670248461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670248461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4223000000000003	1715670248461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670249464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670249464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669787476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669787476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4017	1715669787476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669789480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669789480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669789480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669792487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669792487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669792487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669795493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669795493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669795493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669801507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669801507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669801507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669810542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669813547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669814550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669827579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669837599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669839603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669841609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669843615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669848609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669848609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4032	1715669848609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669849611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669849611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4043	1715669849611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669854636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669855637	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670219416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670226415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670226415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4178	1715670226415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670227431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670229435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670233445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670237456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670241464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670247476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670254473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670254473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.421	1715670254473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670257479	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670257479	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670257479	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670258482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670258482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4192	1715670258482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670259484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670259484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4192	1715670259484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670266517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670267516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670268519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670275517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670275517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4212	1715670275517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670277522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670277522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670277522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670311596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670311596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669787490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669789495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669792504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669795510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669801526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669813533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669813533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669813533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669814535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669814535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669814535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669818543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669818543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669818543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669837584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715669837584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4059	1715669837584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669839588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669839588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4059	1715669839588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669841593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669841593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669841593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669843598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669843598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4036	1715669843598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669844615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669848622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669854621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669854621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4053	1715669854621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669855623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669855623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4055999999999997	1715669855623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670220402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670220402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670220402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670221404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670221404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670221404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670224426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670230439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670231439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670232443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670243451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670243451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670243451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670252470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670252470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.421	1715670252470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670255475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670255475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670255475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670256477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670256477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670256477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670260486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670260486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4192	1715670260486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670262490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670262490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670262490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670271509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670271509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669788478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669788478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4017	1715669788478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669794491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669794491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669794491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669799517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669812530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715669812530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669812530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669817541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669817541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669817541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669824555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669824555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669824555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669835592	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669836598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669838601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669842611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669849626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669851633	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669852632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669856640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669857643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670220419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670224411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670224411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4240999999999997	1715670224411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670230423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670230423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4187	1715670230423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670231425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670231425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4203	1715670231425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670232428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670232428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4203	1715670232428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670240462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670243468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670252485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670255492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670256492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670260502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670269519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670271525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670272525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670274515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670274515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4212	1715670274515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670276533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670311596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670315604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670315604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670315604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670316606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670316606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670316606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670319612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670319612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4259	1715670319612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670320630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670329634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670329634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669788494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669794506	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669804528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669812546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669818558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669830585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669836582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715669836582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669836582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669838586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669838586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4059	1715669838586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669842596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669842596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669842596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669846619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669851615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669851615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4043	1715669851615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669852617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669852617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4053	1715669852617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669856625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669856625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4055999999999997	1715669856625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669857627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715669857627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4055999999999997	1715669857627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670221420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670223409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670223409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4240999999999997	1715670223409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670226430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670228436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670235449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670242464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670248475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670249480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670251468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670251468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670251468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670253489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670264493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670264493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4202	1715670264493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670265496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670265496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4202	1715670265496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670266498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670266498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4202	1715670266498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670273513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670273513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4212	1715670273513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670317608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670317608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670317608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670323636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670324638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670326644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670334645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670334645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670334645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670335664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669790482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669790482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669790482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669791484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669791484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669791484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669793489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669793489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669793489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669797497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669797497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669797497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669799502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669799502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669799502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669800521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669802527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669805515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669805515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4044	1715669805515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669806517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669806517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4044	1715669806517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669807519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669807519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4008000000000003	1715669807519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669808521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669808521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4008000000000003	1715669808521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669809524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669809524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4008000000000003	1715669809524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669810526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669810526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669810526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669811543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669816557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669819561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669821564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669822569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669826559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669826559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669826559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669833588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669846605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715669846605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4032	1715669846605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669853633	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669858646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670222406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670222406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4240999999999997	1715670222406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670227417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670227417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4178	1715670227417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670229421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670229421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4187	1715670229421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670233430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670233430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4203	1715670233430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670237438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670237438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670237438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669796495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669796495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669796495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669798500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669798500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669798500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669803511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669803511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4034	1715669803511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669815537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669815537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4051	1715669815537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669819545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669819545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.405	1715669819545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669820565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669823568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669825574	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669827562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669827562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669827562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669828581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669829585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669831570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669831570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669831570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669832571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669832571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669832571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669834576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669834576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669834576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669835578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669835578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046999999999996	1715669835578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669840607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669845619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669847622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669850631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670225413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670225413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4178	1715670225413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670234432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670234432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4214	1715670234432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670236436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670236436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4214	1715670236436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670238440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670238440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670238440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670239442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670239442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670239442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670240445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670240445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670240445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670244469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670245473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670246474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670259500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670263491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670263491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670263491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669796510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669798515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669803526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669815552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669820548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669820548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.405	1715669820548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669823553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669823553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669823553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669825557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669825557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669825557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0211	1715669826576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669828564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.5	1715669828564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669828564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669829566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669829566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669829566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669830568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669830568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669830568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669831587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669832588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669834591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669840591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669840591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669840591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669845602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669845602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4036	1715669845602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669847607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669847607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4032	1715669847607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669850613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669850613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4043	1715669850613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669859632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669859632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669859632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669859647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669860634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669860634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669860634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669860651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669861636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669861636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.403	1715669861636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669861654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669862638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669862638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.403	1715669862638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669862653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669863641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669863641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.403	1715669863641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669863655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669864643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669864643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669864643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669864660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669865645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669865645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669865645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669866647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669866647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669866647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669867650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669867650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4052	1715669867650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669873662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715669873662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669873662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669889712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669897713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669897713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4057	1715669897713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669898715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669898715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4057	1715669898715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669899733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669905730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669905730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715669905730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669908751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669909754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669913760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669914764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669918773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669932787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669932787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4035	1715669932787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669934806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669944831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669949823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669949823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669949823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669950841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669952849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669962851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669962851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669962851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669971884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669973887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669974890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669975892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670225431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670234447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670236453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670238454	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670239458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670244453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670244453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670244453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670245456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670245456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670245456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670246458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1000000000000005	1715670246458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4223000000000003	1715670246458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670251484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670262504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670263507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670276520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670276520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670276520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670326628	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669865661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669866663	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669871657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669871657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669871657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669877671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669877671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.404	1715669877671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669892717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669897729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669898730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669901736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669905749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669909737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669909737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4028	1715669909737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669913745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669913745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715669913745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669914749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669914749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715669914749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669918758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669918758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669918758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669923769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669923769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4082	1715669923769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669934791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669934791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669934791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669944813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669944813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669944813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669945815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669945815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669945815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669949838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669952830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669952830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669952830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669960846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669960846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669960846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669962866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669973873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669973873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4063000000000003	1715669973873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669974875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669974875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4063000000000003	1715669974875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669975878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669975878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669975878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669977882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669977882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669977882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670241448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670241448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670241448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670247460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670247460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4223000000000003	1715670247460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670250466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669867665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669869670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669876669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669876669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.404	1715669876669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669877685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669882681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715669882681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669882681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669883683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669883683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669883683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669888693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669888693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669888693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669889696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669889696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669889696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669890715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669891715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669893704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669893704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669893704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669896728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669908735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669908735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669908735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669912758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669917772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669920779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669930797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669931800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669933809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669941807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669941807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061999999999997	1715669941807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669942810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669942810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669942810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669943826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669948821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669948821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669948821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669953850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669956838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669956838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046	1715669956838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669958842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669958842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669958842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669963853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669963853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669963853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669964855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669964855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669964855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669965857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669965857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669965857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669966873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669968878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669976880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669976880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669976880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669868651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669868651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4052	1715669868651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669870655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669870655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669870655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669873679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669875684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669884685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669884685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669884685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669886690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715669886690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669886690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669887691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669887691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669887691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669893719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669894722	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669899717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669899717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4057	1715669899717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669900738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669906748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669907749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669916769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669921779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669922781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669924785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669925788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669926790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669937798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715669937798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4072	1715669937798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669938801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669938801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4072	1715669938801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669940805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669940805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061999999999997	1715669940805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669943811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669943811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4067	1715669943811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669946833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669953832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715669953832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669953832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669970868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715669970868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669970868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669972871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669972871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4063000000000003	1715669972871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669978884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669978884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669978884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670249464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670250480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670253472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670253472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.421	1715670253472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670261502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670264507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670265512	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669868668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669870670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669875667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669875667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669875667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669880677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669880677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669880677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669884701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669886705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669887707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669894706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715669894706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4031	1715669894706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669895709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715669895709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4031	1715669895709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669900720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669900720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4076999999999997	1715669900720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669904745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669907733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669907733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669907733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669916754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669916754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669916754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669921765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669921765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4082	1715669921765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669922767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669922767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4082	1715669922767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669924771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669924771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4101	1715669924771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669925773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669925773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4101	1715669925773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669926776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669926776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4101	1715669926776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669932802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669937816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669938815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669940819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669946818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669946818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669946818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669951828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669951828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669951828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669955851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669970882	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669972887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669978899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670250466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4224	1715670250466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670254490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670257494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670258495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670261488	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670261488	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670261488	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669869653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669869653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4052	1715669869653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669871673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669876685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669881694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669882695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669883697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669888710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669890698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669890698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.401	1715669890698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669891700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669891700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669891700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669892702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669892702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669892702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669896711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669896711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4031	1715669896711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669904728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669904728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715669904728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669912743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715669912743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715669912743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669917756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669917756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669917756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669920763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715669920763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669920763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669930783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669930783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4035	1715669930783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669931785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669931785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4035	1715669931785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669933790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669933790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669933790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669939819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669941822	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669942825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669947835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669951843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669955836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669955836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046	1715669955836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669956854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669958858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669963868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669964870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669965873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669968864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715669968864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669968864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669971870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669971870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669971870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669976894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670267500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670267500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669872660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669872660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4029000000000003	1715669872660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669874664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715669874664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4014	1715669874664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669878673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669878673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.404	1715669878673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669879675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.700000000000001	1715669879675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669879675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669880692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669885688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715669885688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4	1715669885688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669895727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669902723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.400000000000002	1715669902723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4076999999999997	1715669902723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669903726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5	1715669903726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715669903726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669906731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715669906731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4042	1715669906731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669910755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669911757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669915769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669919776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669927778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669927778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4083	1715669927778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669928780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715669928780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4083	1715669928780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669929781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669929781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4083	1715669929781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669935793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669935793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669935793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669936796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669936796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4072	1715669936796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669939803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715669939803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061999999999997	1715669939803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669947819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669947819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669947819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669950826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715669950826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669950826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669954851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669957857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669959860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669961848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669961848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4058	1715669961848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669966859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669966859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669966859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669967876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669872675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669874682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669878690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669879691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669881679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715669881679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4049	1715669881679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669885703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669901721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715669901721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4076999999999997	1715669901721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669902738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669903740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715669910740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	17.1	1715669910740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4028	1715669910740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669911741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669911741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4028	1715669911741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669915751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.7	1715669915751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4065	1715669915751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669919760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715669919760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4086999999999996	1715669919760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669923786	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669927794	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669928796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669929797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669935809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669936818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669945831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669948836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669954834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669954834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4046	1715669954834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669957840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715669957840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669957840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669959844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669959844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4061	1715669959844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669960864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669961863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669967861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669967861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669967861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669969866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715669969866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.406	1715669969866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669977898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4206999999999996	1715670267500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670268502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670268502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4206999999999996	1715670268502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670270507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670270507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4193000000000002	1715670270507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670275533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670277538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670326628	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4226	1715670326628	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670330652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670334661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669969881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669979886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669979886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669979886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669979901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715669980888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669980888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715669980888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669980903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669981890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669981890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669981890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669981904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669982892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715669982892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669982892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669982907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669983894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669983894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4045	1715669983894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669983910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669984896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669984896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669984896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669984911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669985898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669985898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669985898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669985913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669986900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669986900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4048000000000003	1715669986900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669986914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669987902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669987902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4069000000000003	1715669987902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669987916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715669988906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669988906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4069000000000003	1715669988906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669988921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669989908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669989908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4069000000000003	1715669989908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669989925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669990910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715669990910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669990910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669990926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669991912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669991912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669991912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669991928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715669992915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715669992915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4091	1715669992915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669992928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669993917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715669993917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715669993917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669993933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669994919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715669994919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715669994919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669994935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669996939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669998941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670001948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670008965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670013973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670022993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670035005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670035005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4111	1715670035005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670037023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670041032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670047045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670048046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670050055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670060057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670060057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670060057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670069075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670069075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4092	1715670069075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670070102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670071096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670078094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670078094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715670078094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670082119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670084127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670085126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670090136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670091142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670095151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670269505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670269505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4206999999999996	1715670269505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670278538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4254000000000002	1715670329634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670331638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670331638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.427	1715670331638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670333643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670333643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670333643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670337651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670337651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670337651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670339656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670339656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670339656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670341660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670341660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670341660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670347673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670347673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670347673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670351681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670351681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670351681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670361702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670361702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670361702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670366713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670366713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670366713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669995921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669995921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715669995921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670002935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670002935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4137	1715670002935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670003937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670003937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4137	1715670003937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670006944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670006944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4095	1715670006944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670007960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670016982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670017983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670018984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670025999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670027989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670027989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4125	1715670027989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670031998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670031998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670031998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670034022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670036007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670036007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4097	1715670036007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670038011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670038011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4097	1715670038011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670039013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670039013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670039013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670040015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670040015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670040015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670042035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670043037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670046027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670046027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4122	1715670046027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670051038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670051038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670051038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670053058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670061074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670067072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670067072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670067072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670068090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670079096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670079096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715670079096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670080100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670080100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4068	1715670080100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670081102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670081102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670081102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670082104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670082104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670082104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670094131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670094131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669995935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669997940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670000946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670005956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670010968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670019972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670019972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4112	1715670019972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670020974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670020974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.41	1715670020974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670023980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715670023980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4104	1715670023980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670029994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670029994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670029994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670030996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670030996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670030996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670032013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670049048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670052054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670054060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670055063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670058067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670059071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670062078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670063079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670064080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670074100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670076105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670077106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670083123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670086129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670093128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670093128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670093128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670098140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715670098140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670098140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670270520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670330636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.427	1715670330636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670337667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670349678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670349678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4179	1715670349678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670350698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670356692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670356692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4242	1715670356692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670358696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670358696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.424	1715670358696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670359698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670359698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.424	1715670359698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670360700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670360700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670360700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670363706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670363706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670363706	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715669996923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669996923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715669996923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669998927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715669998927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715669998927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670001933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715670001933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116999999999997	1715670001933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670008949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670008949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4114	1715670008949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670013959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670013959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670013959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670014977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670028991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670028991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4125	1715670028991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670037009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670037009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4097	1715670037009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670041017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670041017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670041017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670047029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670047029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4122	1715670047029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670048032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.3	1715670048032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4132	1715670048032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670050036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670050036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4132	1715670050036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670056065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670060072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670069092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670071079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670071079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4092	1715670071079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670073099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670078109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670084109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670084109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670084109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670085111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670085111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670085111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670090121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670090121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4133	1715670090121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670091124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670091124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4133	1715670091124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670092141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4193000000000002	1715670271509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670272511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670272511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4193000000000002	1715670272511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670273528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670274530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670278524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.4	1715670278524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4221	1715670278524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715669997925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715669997925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715669997925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670000931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670000931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116999999999997	1715670000931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670005942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.2	1715670005942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4095	1715670005942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670010953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670010953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4114	1715670010953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670014961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670014961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4119	1715670014961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670019988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670020988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670029007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670030008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670031010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670049034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670049034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4132	1715670049034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670052040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670052040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670052040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670054044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670054044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670054044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670055046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670055046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670055046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670058053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670058053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4093	1715670058053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670059055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670059055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4093	1715670059055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670062061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670062061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670062061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670063063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670063063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4115	1715670063063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670064065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670064065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4115	1715670064065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670065083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670076090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715670076090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670076090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670077092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670077092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670077092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670083106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670083106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670083106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670086113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670086113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670086113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670092126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670092126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4133	1715670092126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670096135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715669999929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715669999929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116999999999997	1715669999929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670002951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670003955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670007946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670007946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4095	1715670007946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670016965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670016965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4119	1715670016965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670017968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670017968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4112	1715670017968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670018970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670018970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4112	1715670018970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670025985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670025985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4104	1715670025985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670027003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670028003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670034002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670034002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4111	1715670034002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670035022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670036022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670038026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670039031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670042019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670042019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670042019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670043021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670043021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670043021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670045043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670046044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670051055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670061059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670061059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670061059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670065067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670065067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4115	1715670065067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670067088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670072096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670079111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670080116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670081118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670093145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670094145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670279526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670279526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670279526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670284552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670285557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670289547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670289547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4268	1715670289547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670292553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670292553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670292553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670298567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670298567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715669999945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670004956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670009951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670009951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4114	1715670009951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670011955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670011955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670011955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670012957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670012957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4105	1715670012957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670015963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670015963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4119	1715670015963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670021976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670021976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.41	1715670021976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670022978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8	1715670022978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.41	1715670022978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670024982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670024982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4104	1715670024982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670026987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670026987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4125	1715670026987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670033019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670044023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670044023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670044023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670045025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670045025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4122	1715670045025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670056048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670056048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.409	1715670056048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670057065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670066089	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670070077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670070077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4092	1715670070077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670073084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670073084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670073084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670075088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670075088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670075088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670087115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670087115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4120999999999997	1715670087115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670088117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715670088117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4120999999999997	1715670088117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670089119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670089119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4120999999999997	1715670089119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670096153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670097153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670279542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670285539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670285539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670285539	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670286556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670289562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670004940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670004940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4137	1715670004940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670006961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670009967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670011972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670012973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670015978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670021992	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670023996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670024998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670033000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670033000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4111	1715670033000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670040033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670044038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670053042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670053042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670053042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670057051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670057051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4093	1715670057051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670066070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6	1715670066070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670066070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670068073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670068073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4094	1715670068073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670072081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670072081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670072081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670074086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670074086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4116	1715670074086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670075103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670087130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670088132	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670089134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670097137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670097137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670097137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670099141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670099141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670099141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715670280528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	3.5	1715670280528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670280528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670281530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670281530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670281530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670291551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670291551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670291551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670295561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670295561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670295561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670296563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670296563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670296563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670297565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670297565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670297565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670298586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670302590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670094131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670095133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715670095133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670095133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670280543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670281547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670291566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670295579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670296577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670297581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670300587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670308608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670311611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670315619	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670316623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670320615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670320615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4259	1715670320615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670325641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670329651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670331653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670335647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670335647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670335647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670338654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670338654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670338654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670338677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670339671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670341675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670342680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670345683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670347688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670350680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670350680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4179	1715670350680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670351696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670355690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670355690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4242	1715670355690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670357694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670357694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.424	1715670357694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670361717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670362704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670362704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670362704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670365710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670365710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670365710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670367715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670367715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670367715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670369719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	3.5	1715670369719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255999999999998	1715670369719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670369733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670370737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670371739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670373742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670374729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670374729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670374729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670375731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670375731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670096135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4131	1715670096135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670098156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670099158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670100143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670100143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670100143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670100161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670101145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670101145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670101145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670101164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670102148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670102148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670102148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670102162	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670103150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670103150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670103150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670103165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670104153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670104153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670104153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670104166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670105155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.2	1715670105155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670105155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670105171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670106157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670106157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670106157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670106178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670107159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670107159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4129	1715670107159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670107173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670108161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670108161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4124	1715670108161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670108177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670109163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670109163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4124	1715670109163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670109177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670110165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715670110165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4124	1715670110165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670110181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670111167	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670111167	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670111167	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670111184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670112170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715670112170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670112170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670112184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670113172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670113172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4118000000000004	1715670113172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670113186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670114174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670114174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4152	1715670114174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670114189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670115176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670115176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4152	1715670115176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670119184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670119184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4163	1715670119184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670121190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670121190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4159	1715670121190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670127219	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670129224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670139244	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670145258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670151254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670151254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670151254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670152256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670152256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670152256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670153274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670154277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670160286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670168307	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670170308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670176305	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715670176305	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4185	1715670176305	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670179328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670190337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670190337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670190337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670191356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670204367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670204367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.423	1715670204367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670207374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670207374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670207374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670210380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670210380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4228	1715670210380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670211382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670211382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4228	1715670211382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670213401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670215406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670282532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670282532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670282532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670283534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670283534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670283534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670288545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670288545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4268	1715670288545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670290549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670290549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4268	1715670290549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670299569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670299569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670299569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670300571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715670300571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4227	1715670300571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670115193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670119198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670121204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715670129207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715670129207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4135999999999997	1715670129207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670139228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670139228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4162	1715670139228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670145241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670145241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670145241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670147266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670151272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670152271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670154260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670154260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670154260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670160272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670160272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4141	1715670160272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670168290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670168290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670168290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670170293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670170293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670170293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670175303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670175303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4185	1715670175303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670176321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670187346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670191339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670191339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670191339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670193343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670193343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4225	1715670193343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670204384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670207390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670210397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670211399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670215391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670215391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4232	1715670215391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670282547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670283549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670288561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670290568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670299587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670306585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670306585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4249	1715670306585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670307587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670307587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4249	1715670307587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670310594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670310594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670310594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670313600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670313600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670313600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670322634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670330636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670116178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670116178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4152	1715670116178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670117180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670117180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4163	1715670117180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670118182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670118182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4163	1715670118182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670120200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670126216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670130226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670135220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670135220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4151	1715670135220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670136222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670136222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4151	1715670136222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670137224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670137224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4151	1715670137224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670141233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715670141233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4166	1715670141233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670143237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670143237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4166	1715670143237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670146243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670146243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670146243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670155277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670156279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670157280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670158282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670161290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670164296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670167303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670169309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670171312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670177322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670180314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670180314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670180314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670181331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670182334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670183337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670189335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670189335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670189335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670194345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670194345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4225	1715670194345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670196350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670196350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670196350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670199356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670199356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670199356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670201377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670202378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670203380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670205384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670209394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670214404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670116194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670117197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670118198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670126201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670126201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670126201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670130209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670130209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4135999999999997	1715670130209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670132213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670132213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4153000000000002	1715670132213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670135236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670136238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670137241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670141250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670143252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670155261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670155261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670155261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670156263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670156263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4138	1715670156263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670157265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670157265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4138	1715670157265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670158268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670158268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4138	1715670158268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670161274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670161274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4141	1715670161274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670164280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670164280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4181	1715670164280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670167288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670167288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4199	1715670167288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670169291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670169291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670169291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670171296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670171296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670171296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670177308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670177308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670177308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670179312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670179312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670179312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670180330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670182318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670182318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670182318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670183321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715670183321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670183321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670185344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670189350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670194362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670196365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670199370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670202363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670202363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670120186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670120186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4159	1715670120186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670122206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670123210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670124210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670125212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670132231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670147245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670147245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670147245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670163293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670165298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670166301	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670173316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670188333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670188333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4169	1715670188333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670190353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670192357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670197352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670197352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670197352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670200358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670200358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670200358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670206388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670216393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670216393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4236	1715670216393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670217396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670217396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4236	1715670217396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670218398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670218398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4236	1715670218398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670284537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670284537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670284537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670287543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670287543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670287543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670293556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670293556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670293556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670294558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670294558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255	1715670294558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670303578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670303578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4243	1715670303578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670304580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.5	1715670304580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4243	1715670304580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670305583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670305583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4243	1715670305583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670308589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670308589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4249	1715670308589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670309605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670314601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670314601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670314601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670122192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715670122192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4159	1715670122192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670123194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670123194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4164	1715670123194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670124196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.199999999999999	1715670124196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4164	1715670124196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670125198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670125198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4164	1715670125198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670127203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670127203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670127203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670146260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670163278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.900000000000002	1715670163278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4181	1715670163278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670165282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.999999999999999	1715670165282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4199	1715670165282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670166285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.100000000000001	1715670166285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4199	1715670166285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670173300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670173300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670173300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670181316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670181316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670181316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670188349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670192341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.2	1715670192341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4225	1715670192341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670193357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670197366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670200373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670213386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670213386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4232	1715670213386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670216413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670217414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670218424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670286541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.5	1715670286541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670286541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670287558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670293574	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670294573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670303593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670304594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670305599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670309592	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670309592	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670309592	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670313615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670314617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670323622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670323622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4271	1715670323622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670324624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670324624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4226	1715670324624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670128205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670128205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670128205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670131211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670131211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4135999999999997	1715670131211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670133215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670133215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4153000000000002	1715670133215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670134217	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715670134217	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4153000000000002	1715670134217	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670138226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670138226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4162	1715670138226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670140231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670140231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4162	1715670140231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670142235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670142235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4166	1715670142235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670144239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670144239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4173	1715670144239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670148247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715670148247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670148247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670149249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.2	1715670149249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670149249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670150252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670150252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4165	1715670150252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670153258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670153258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670153258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670159283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670162290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670172317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670174316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670178310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670178310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4146	1715670178310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670184323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670184323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670184323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670185326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670185326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670185326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670186344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670195348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715670195348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670195348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670198354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670198354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4218	1715670198354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670201360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670201360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4231	1715670201360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670208376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670208376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670208376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670212384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670212384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670128221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670131232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670133233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670134232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670138241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670140250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670142251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670144255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670148262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670149265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670150268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670159270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715670159270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4141	1715670159270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670162276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670162276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4181	1715670162276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670172298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670172298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.419	1715670172298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670174302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670174302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4185	1715670174302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670175318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670178325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670184338	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670186329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670186329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4169	1715670186329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670187331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670187331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4169	1715670187331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670195362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670198370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670206371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670206371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.423	1715670206371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670208391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670212398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670292569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670301573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670301573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4227	1715670301573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670302576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670302576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4227	1715670302576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670312613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670318610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715670318610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4259	1715670318610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670319628	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670321636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670327646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670328647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670332655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670336665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670340675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670342662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670342662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670342662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670343681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670344682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670345669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670345669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670345669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4231	1715670202363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670203365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670203365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4231	1715670203365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670205369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.9	1715670205369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.423	1715670205369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670209378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670209378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4233000000000002	1715670209378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670214388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670214388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4232	1715670214388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670298567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670301589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670312598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670312598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670312598	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670317623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670318626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670321617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670321617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4271	1715670321617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670327630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670327630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4254000000000002	1715670327630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670328632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670328632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4254000000000002	1715670328632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670332640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670332640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.427	1715670332640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670336649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715670336649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670336649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670340658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670340658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670340658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670343665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670343665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670343665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670344667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670344667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670344667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670346671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670346671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4266	1715670346671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670346687	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670352684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670352684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670352684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670352699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670354688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670354688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4242	1715670354688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670354702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670364708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670364708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4269000000000003	1715670364708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670364723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670365726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670368717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670368717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670368717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4228	1715670212384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670306599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670307603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670310609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670322620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670322620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4271	1715670322620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670325626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670325626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4226	1715670325626	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670333657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670348676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.7	1715670348676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4179	1715670348676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670348693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670349694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670353686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670353686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4219	1715670353686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670353707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670355709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670356708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670357709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670358712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670359713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670360714	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670362720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670363720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670366729	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670367730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670368734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670370721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670370721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255999999999998	1715670370721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670371723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670371723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4255999999999998	1715670371723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670372725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670372725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670372725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670372740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670373727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715670373727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670373727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670374745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670375731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670375746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670376733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715670376733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670376733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670376750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670377735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670377735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4248000000000003	1715670377735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670377750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670378737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670378737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670378737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670378752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670379739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670379739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670379739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670379755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670380741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670380741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.428	1715670380741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670384750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670384750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4273000000000002	1715670384750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670385751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6	1715670385751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4273000000000002	1715670385751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670390761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670390761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670390761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670392766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670392766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670392766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670400801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670413812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670413812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670413812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670414814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670414814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670414814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670423850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670428860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670429862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670431865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670434858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670434858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670434858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670437877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670444894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670445897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670449907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670453898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670453898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4301999999999997	1715670453898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670455901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670455901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4301999999999997	1715670455901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670456903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670456903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4322	1715670456903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670457906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670457906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4322	1715670457906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670819697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670819697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4537	1715670819697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670821716	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670828730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670832739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670836748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670845753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715670845753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670845753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670848760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670848760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670848760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670850764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670850764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670850764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670851782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670852782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670857795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670858796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670865811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670380756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670384764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670385767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670390777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670400785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670400785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246999999999996	1715670400785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670402789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670402789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670402789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670413828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670414829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670428845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715670428845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670428845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670429847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670429847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670429847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670431851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670431851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670431851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670432853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670432853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670432853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670437863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670437863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670437863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670439883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670445880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670445880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4299	1715670445880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670449889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670449889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4312	1715670449889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670451893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670451893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4311	1715670451893	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670453912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670455916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670456920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670457923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670819712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670820717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670826711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670826711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4563	1715670826711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670829718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670829718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670829718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670837751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670842746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670842746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670842746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670854772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670854772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670854772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670855774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670855774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715670855774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670856776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670856776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715670856776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670859783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670859783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670381744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670381744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4264	1715670381744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670387771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670389759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670389759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4284	1715670389759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670391763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670391763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670391763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670393768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670393768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670393768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670398795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670399802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670403807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670405795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670405795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670405795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670409803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715670409803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670409803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670410806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670410806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670410806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670411808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670411808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670411808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670419825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670419825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670419825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670433855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670433855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670433855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670435879	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670436877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670440889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670450891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670450891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4311	1715670450891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670451908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670820699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670820699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4537	1715670820699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670825710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670825710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4563	1715670825710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670826728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670837734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670837734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670837734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670840758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670842761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670854790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670855789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670856796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670859802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670860799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670861802	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670862804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670868801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670868801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.453	1715670868801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670872810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670381759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670388776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670389774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670391779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670393783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670399782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670399782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246999999999996	1715670399782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670403791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670403791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670403791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670404793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670404793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670404793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670407799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715670407799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670407799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670409819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670410825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670411823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670419841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670435860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715670435860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670435860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670436861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670436861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670436861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670440870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670440870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4292	1715670440870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670444878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670444878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4299	1715670444878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670450908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670821701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670821701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4537	1715670821701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670828716	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670828716	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670828716	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670832724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670832724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4313000000000002	1715670832724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670836732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670836732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670836732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670843765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670845767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670848778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670851766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670851766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670851766	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670852768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670852768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670852768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670857778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670857778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715670857778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670858781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670858781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4506	1715670858781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670865796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670865796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670865796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670382746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670382746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4264	1715670382746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670388757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670388757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4284	1715670388757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670395772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715670395772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670395772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670396774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670396774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670396774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670397777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670397777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670397777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670405811	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670415816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670415816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670415816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670416819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670416819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670416819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670417821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670417821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670417821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670418823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670418823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670418823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670421830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670421830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4291	1715670421830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670422846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670426840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670426840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670426840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670430849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670430849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276999999999997	1715670430849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670432870	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670434873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670439868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670439868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4292	1715670439868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670441887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670443876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670443876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670443876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670446881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670446881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4299	1715670446881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670447884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670447884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4312	1715670447884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670448887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670448887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4312	1715670448887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670454915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670458923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670822703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670822703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4560999999999997	1715670822703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670824708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670824708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4560999999999997	1715670824708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670382764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670392787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670395788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670396791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670397794	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670407814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670415831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670416835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670417837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670418837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670421847	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670423834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715670423834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4234	1715670423834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670426855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670430864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670433869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670438865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670438865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4292	1715670438865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670441871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670441871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670441871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670442874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670442874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4283	1715670442874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670443891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670446897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670447899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670448904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670458908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670458908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4322	1715670458908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670822718	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670824722	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670831722	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670831722	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4313000000000002	1715670831722	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670833726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670833726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4313000000000002	1715670833726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670838736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670838736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670838736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670839739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670839739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670839739	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670843749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670843749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670843749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670844768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670847775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670849778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670853786	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670864808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670867800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670867800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.453	1715670867800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670869804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670869804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.453	1715670869804	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670874815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670874815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670874815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670875817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670383748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715670383748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4264	1715670383748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670386753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670386753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4273000000000002	1715670386753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670387755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670387755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4284	1715670387755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670394784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670401787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670401787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246999999999996	1715670401787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670402803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670406797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670406797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4279	1715670406797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670408801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670408801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4275	1715670408801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670412810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670412810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4265	1715670412810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670420827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670420827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4291	1715670420827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670422832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670422832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4291	1715670422832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670424850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670425854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670427858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670442889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670452915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670823705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670823705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4560999999999997	1715670823705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670825726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670827732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670830720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670830720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670830720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670834744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670835744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670841743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670841743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670841743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670846755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670846755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670846755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670850781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670863807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670870820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670871822	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670873827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670885838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670885838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4575	1715670885838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670891864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715670894857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670894857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4556999999999998	1715670894857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670903877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670903877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670383762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670386769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670394770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670394770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4276	1715670394770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670398779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670398779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4261999999999997	1715670398779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670401801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670404807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670406813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670408817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670412826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670420842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670424836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670424836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4234	1715670424836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670425838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670425838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4234	1715670425838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670427843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670427843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4274	1715670427843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670438880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670452895	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670452895	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4311	1715670452895	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670454900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670454900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4301999999999997	1715670454900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670459910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670459910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670459910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670459926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670460912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670460912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670460912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670460927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670461914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670461914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670461914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670461929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670462916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670462916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670462916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670462932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670463918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670463918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670463918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670463934	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670464920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670464920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4331	1715670464920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670464936	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670465924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670465924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4316	1715670465924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670465938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670466926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670466926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4316	1715670466926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670466942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670467929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715670467929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4316	1715670467929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670478969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670479972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670480974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670481975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670485969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.1	1715670485969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670485969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670487973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670487973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.436	1715670487973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670493003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670494989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670494989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4375999999999998	1715670494989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670496994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670496994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670496994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670498998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670498998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670498998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670506028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670510036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670512044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670523051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670523051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4379	1715670523051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670527077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670530080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670535076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670535076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670535076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670536094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670540087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670540087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4175	1715670540087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670541106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670550126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670552113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670552113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670552113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670553116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.700000000000003	1715670553116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670553116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670554118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670554118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670554118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670557125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670557125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4186	1715670557125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670559129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670559129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670559129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670561148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670563156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670566144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670566144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4384	1715670566144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670567163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670574176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670578171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670578171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.441	1715670578171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670580193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670467945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670468931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670468931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.435	1715670468931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670468949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670470935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670470935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.435	1715670470935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670470951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670471939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670471939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4355	1715670471939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670478954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670478954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4366999999999996	1715670478954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670479957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670479957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4366999999999996	1715670479957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670480959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670480959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670480959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670481961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670481961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670481961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670482977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670484967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670484967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670484967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670485985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670486971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715670486971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.436	1715670486971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670486989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670487990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670488976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670488976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.436	1715670488976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670488990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670491997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670492985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670492985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4375999999999998	1715670492985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670493987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670493987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4375999999999998	1715670493987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670494006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670495007	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670495991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670495991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670495991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670496006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670497009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670499014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670502004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670502004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4341	1715670502004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670502023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670504008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670504008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4341	1715670504008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670504025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670505011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670505011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4373	1715670505011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670469933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670469933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.435	1715670469933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670471954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670472956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670475962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670477969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670490000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670498011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670513028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670513028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.44	1715670513028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670514046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670516051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670517053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670521046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715670521046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4436999999999998	1715670521046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670522049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670522049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4379	1715670522049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670524053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670524053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4379	1715670524053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670526057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670526057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4383000000000004	1715670526057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670528062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670528062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4418	1715670528062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670532085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670536079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670536079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670536079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670537095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670542108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670543108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670549121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670562152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670568174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670572174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670582196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670583198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670588211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670592218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670593220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670594221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670604228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670604228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670604228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670613246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670613246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4468	1715670613246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670618258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670618258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670618258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670620280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670629296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670636299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670636299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670636299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670638303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670638303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670638303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670469949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670472941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670472941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4355	1715670472941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670475948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8999999999999995	1715670475948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4349000000000003	1715670475948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670477952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670477952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4366999999999996	1715670477952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670489979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670489979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670489979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670497996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670497996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670497996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670507015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670507015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4374000000000002	1715670507015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670514030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670514030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.44	1715670514030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670516035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670516035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670516035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670517037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670517037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670517037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670519042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670519042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4436999999999998	1715670519042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670521067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670522068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670524069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670526072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670528077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670534074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715670534074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4144	1715670534074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670537081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670537081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4158000000000004	1715670537081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670542091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670542091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4175	1715670542091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670543093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14	1715670543093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4215	1715670543093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670549106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670549106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4307	1715670549106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670562135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670562135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.426	1715670562135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670568149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670568149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396999999999998	1715670568149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670570169	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670582181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670582181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4405	1715670582181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670583183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670583183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4405	1715670583183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670473944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.400000000000002	1715670473944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4355	1715670473944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670474946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670474946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4349000000000003	1715670474946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670476950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.1	1715670476950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4349000000000003	1715670476950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670482963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.800000000000001	1715670482963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670482963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670483982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670490981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670490981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670490981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670491983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670491983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670491983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670500014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670501019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670503023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670506013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670506013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4373	1715670506013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670509033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	106	1715670525055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.400000000000002	1715670525055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4383000000000004	1715670525055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670529064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670529064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4418	1715670529064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670531068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670531068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670531068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670534088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670541090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670541090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4175	1715670541090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670544110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670555134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670556141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670560149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670565142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670565142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4384	1715670565142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670567146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670567146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396999999999998	1715670567146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670569166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670574161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670574161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4389000000000003	1715670574161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670579191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670581194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670584200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670585203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670587208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670605230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670605230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670605230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670606231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670606231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670606231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670473962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670474963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670476966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670483965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.600000000000001	1715670483965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4353000000000002	1715670483965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670484982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670490997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670500000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670500000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670500000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670501002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670501002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670501002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670503006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670503006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4341	1715670503006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670505029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670509019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670509019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4374000000000002	1715670509019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670520044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670520044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4436999999999998	1715670520044	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670525073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670529079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670531084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670539105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670544095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670544095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4215	1715670544095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670555120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670555120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4186	1715670555120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670556121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670556121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4186	1715670556121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670560131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670560131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670560131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670561133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670561133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.426	1715670561133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670565160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670569151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715670569151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396999999999998	1715670569151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670573160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670573160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4389000000000003	1715670573160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670579173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670579173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670579173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670580176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670580176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670580176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670584185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670584185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4405	1715670584185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670585187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670585187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670585187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670587192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670587192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670507029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670508034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670511039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670515033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670515033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.44	1715670515033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670518039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670518039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670518039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670520064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670533072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670533072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670533072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670538083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670538083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4158000000000004	1715670538083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670545098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670545098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4215	1715670545098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670546100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670546100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4245	1715670546100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670547102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670547102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4245	1715670547102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670548104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670548104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4245	1715670548104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670551111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670551111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4307	1715670551111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670558145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670570154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670570154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670570154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670571170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670575164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670575164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4389000000000003	1715670575164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670576166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715670576166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.441	1715670576166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670577186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670589196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670589196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670589196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670595209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670595209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670595209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670597213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670597213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4463000000000004	1715670597213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670598231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670599233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670600236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670601237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670602241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670603240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670609253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670624271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715670624271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4412	1715670624271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670626275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670626275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670508017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715670508017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4374000000000002	1715670508017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670511024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670511024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4424	1715670511024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670513045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670515048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670518057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670523071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670533086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670538098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670545113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670546116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670547118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670548118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670558127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670558127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4246	1715670558127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670564156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670571155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670571155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670571155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670572157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670572157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670572157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670575180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670576182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670581179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670581179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670581179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670589212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670595223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670598216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670598216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4463000000000004	1715670598216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670599218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670599218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4463000000000004	1715670599218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670600220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670600220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670600220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670601221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670601221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670601221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670602223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670602223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670602223	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670603226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670603226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670603226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670609238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670609238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4439	1715670609238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670621282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670624287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670626290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670632289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670632289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670632289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670633306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670635296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670635296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670635296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670510021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670510021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4424	1715670510021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670512026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670512026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4424	1715670512026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670519057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670527060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670527060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4383000000000004	1715670527060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670530066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670530066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4418	1715670530066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670532070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670532070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4415999999999998	1715670532070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670535092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670539085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670539085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4158000000000004	1715670539085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670540103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670550108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670550108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4307	1715670550108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670551125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670552130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670553130	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670554135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670557140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670559144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670563138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715670563138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.426	1715670563138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670564140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670564140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4384	1715670564140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670566162	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670573175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670577170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670577170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.441	1715670577170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670578186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670586189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670586189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670586189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670590216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670591216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670596228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670608252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670610257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670611258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670612259	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670614262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670615269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670616270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670622267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670622267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670622267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670623283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670628295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670630299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670631302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670638323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670823720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670827713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670586206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670591200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670591200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670591200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670596211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670596211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670596211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670608235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670608235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670608235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670610240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670610240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4439	1715670610240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670611241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670611241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4439	1715670611241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670612243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670612243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4468	1715670612243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670614248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670614248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4468	1715670614248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670615251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715670615251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670615251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670616253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670616253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670616253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670618274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670623269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670623269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670623269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670628280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670628280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4238000000000004	1715670628280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670630283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670630283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670630283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670631287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670631287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4362	1715670631287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670632308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670827713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4563	1715670827713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670829732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670834728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670834728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670834728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670835730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670835730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4363	1715670835730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670840741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670840741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670840741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670841760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670846772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670863791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670863791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670863791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670870806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670870806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670870806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670871808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670871808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670587192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670592203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715670592203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670592203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670605245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670606245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670607250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670617272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670619275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670625273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670625273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4412	1715670625273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670627278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670627278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4238000000000004	1715670627278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670637301	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670637301	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.442	1715670637301	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670830737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670831737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670833742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670838752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670839755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670844751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670844751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4145	1715670844751	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670847757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670847757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670847757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670849762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670849762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670849762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670853770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670853770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670853770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670864793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670864793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670864793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670866813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670867814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670869823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670874830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670875833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670881829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670881829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4539	1715670881829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670885854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670887841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670887841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4575	1715670887841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670892852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670892852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715670892852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670897863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670897863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4574000000000003	1715670897863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670900871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670900871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670900871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670906885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715670906885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670906885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670909892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670909892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670588194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670588194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670588194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670590198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.200000000000001	1715670590198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670590198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670593205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670593205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670593205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670594207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670594207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4458	1715670594207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670597229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670604243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670613263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670620262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715670620262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670620262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670622282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670634294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715670634294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670634294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670636314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4506	1715670859783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670860785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670860785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4506	1715670860785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670861787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670861787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670861787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670862789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670862789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670862789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670866798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670866798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4528000000000003	1715670866798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670868817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670872829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670877821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670877821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670877821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670879825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670879825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4539	1715670879825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670880827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670880827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4539	1715670880827	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670884835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670884835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670884835	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670889845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670889845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715670889845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670892866	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670896875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670899885	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670901887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670902890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670904896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670905901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670909892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670911911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670912898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670912898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670607233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670607233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670607233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670617255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715670617255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670617255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670619260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670619260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4257	1715670619260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670621264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670621264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4386	1715670621264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670625290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670627294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670637316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670871808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670873812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670873812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670873812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670876834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670891850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670891850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715670891850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670893855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670893855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715670893855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670895874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670903894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670907904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670908906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670910911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670912898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670913900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670913900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670913900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670914902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670914902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670914902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670915904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670915904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4476	1715670915904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670916906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670916906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4476	1715670916906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670917908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670917908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4476	1715670917908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670918924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670919912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715670919912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670919912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670922918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670922918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670922918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670923920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670923920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670923920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670925924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670925924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670925924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670926943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670927945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670928945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670930952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4412	1715670626275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670629281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670629281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4238000000000004	1715670629281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670633291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670633291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4396	1715670633291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670634311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670635313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670639306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670639306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4483	1715670639306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670639320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670640308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715670640308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4483	1715670640308	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670640323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670641310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670641310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4483	1715670641310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670641325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670642312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715670642312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4453	1715670642312	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670642328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670643314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715670643314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4453	1715670643314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670643328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670644316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670644316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4453	1715670644316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670644331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670645318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715670645318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4440999999999997	1715670645318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670645334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670646320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715670646320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4440999999999997	1715670646320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670646335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670647322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670647322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4440999999999997	1715670647322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670647337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670648325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670648325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4433000000000002	1715670648325	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670648339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670649327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670649327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4433000000000002	1715670649327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670649341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670650329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670650329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4433000000000002	1715670650329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670650343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670651332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	3.7	1715670651332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670651332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670651346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670652334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670652334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670652334	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670652347	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670654354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670665361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670665361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670665361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670678390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670678390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670678390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670681396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670681396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670681396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670683400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670683400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670683400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670686407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670686407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670686407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670691418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670691418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670691418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670693422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670693422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.431	1715670693422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670698447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670700453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670705466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670707455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670707455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4429000000000003	1715670707455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670710461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670710461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4426	1715670710461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670719481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670719481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4475	1715670719481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670725494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670725494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670725494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670733511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670733511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4495999999999998	1715670733511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670737520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670737520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670737520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670739524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670739524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670739524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670744551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670749561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670754557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670754557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4513000000000003	1715670754557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670755559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715670755559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4513000000000003	1715670755559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670757564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670757564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670757564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670760569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670760569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4297	1715670760569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670771595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670771595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4409	1715670771595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670653336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715670653336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670653336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670655359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670662356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670662356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670662356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670663358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670663358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670663358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670668368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670668368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670668368	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670669370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670669370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4446999999999997	1715670669370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670670390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670672392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670673393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670674397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670675399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670685404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.6	1715670685404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670685404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670692420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715670692420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670692420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670711463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670711463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4469000000000003	1715670711463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670713468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670713468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4469000000000003	1715670713468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670720483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670720483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4338	1715670720483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670721485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670721485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4338	1715670721485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670723490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670723490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670723490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670735516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670735516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670735516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670740527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670740527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670740527	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670741529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670741529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670741529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670742532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670742532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670742532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670745554	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670759568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670759568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4297	1715670759568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670768604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670775604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670775604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670775604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670776606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670776606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670653351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670656357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670662372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670663374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670668382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670669385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670672377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670672377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670672377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670673379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670673379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670673379	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670674381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670674381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670674381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670675383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670675383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4461999999999997	1715670675383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670683414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670688426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670692436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670711478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670713482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670720500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670721502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670730519	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670735531	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670740543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670741545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670742547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670758566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670758566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670758566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670759583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670771610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670775620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670776625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670781616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670781616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4455999999999998	1715670781616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670790636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670790636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670790636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670794645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670794645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670794645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670806670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670806670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670806670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670814686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670814686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670814686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670872810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670872810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670876819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670876819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670876819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670877836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670879843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670882831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715670882831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670882831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670884851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670889860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670894872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670654339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670654339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670654339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670656343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8	1715670656343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670656343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670665377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670678404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670681411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670685420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670686425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670691433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670693436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670700439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670700439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4285	1715670700439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670705450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670705450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4429000000000003	1715670705450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670706453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670706453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4429000000000003	1715670706453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670707471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670716474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670716474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4451	1715670716474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670722503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670725511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670733526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670737534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670744536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670744536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670744536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670745538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670745538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670745538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670750548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670750548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4505	1715670750548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670754570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670755577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670757577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670760587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670777624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670778625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670781632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670784638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670785640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670788632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670788632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4471999999999996	1715670788632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670796649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670796649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4467	1715670796649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670799656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670799656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4523	1715670799656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670802679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670804679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670805683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670808688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670875817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670875817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670880844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670881844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670655341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715670655341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670655341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670658347	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715670658347	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670658347	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670659349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670659349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670659349	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670660351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670660351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670660351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670664360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670664360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670664360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670667366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670667366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670667366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670671375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670671375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4446999999999997	1715670671375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670676386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670676386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4461999999999997	1715670676386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670677388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670677388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4461999999999997	1715670677388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670679392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670679392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670679392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670680394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670680394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670680394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670684402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670684402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4503000000000004	1715670684402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670687409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670687409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670687409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670689413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670689413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670689413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670696428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670696428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4365	1715670696428	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670698432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670698432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4365	1715670698432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670702443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670702443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4395	1715670702443	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670703445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670703445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4395	1715670703445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670704448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670704448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4395	1715670704448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670708457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670708457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4426	1715670708457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670714470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670714470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4451	1715670714470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670715472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670657345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715670657345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4444	1715670657345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670661371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670666380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670682398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670682398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670682398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670688411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670688411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670688411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670690433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670694438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670695442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670697448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670699449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670706476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670709475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670712465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670712465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4469000000000003	1715670712465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670716490	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670717492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670726496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715670726496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670726496	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670727498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670727498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670727498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670729503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670729503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670729503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670731507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670731507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670731507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670739543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670747559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670750565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670751566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670758581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670761587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670762588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670763590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670764597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670765602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670769607	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670773599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715670773599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4409	1715670773599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670774601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715670774601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670774601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670777609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670777609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670777609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670782634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670789634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670789634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670789634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670791653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670792655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670793659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670795662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670799670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670800673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670657360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670658364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670659366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670660367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670664374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670667381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670671393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670676401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670677404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670679406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670680408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670684417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670687424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670689427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670696442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670701458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670702459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670703465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670704468	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670708471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670714488	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670715487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670718494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670723506	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670724509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670728516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670732509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715670732509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4495999999999998	1715670732509	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670734513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670734513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4495999999999998	1715670734513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670736518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670736518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4499	1715670736518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670738522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670738522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670738522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670743534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670743534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670743534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715670746540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670746540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670746540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670748544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670748544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4493	1715670748544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670752552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715670752552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4505	1715670752552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670753568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670756576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670766599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670767602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670770593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670770593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670770593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670772597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670772597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4409	1715670772597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670780631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670783636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670791638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670791638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715670791638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670661354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670661354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4449	1715670661354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670666363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670666363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4466	1715670666363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670670372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670670372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4446999999999997	1715670670372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670682416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670690415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670690415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4288000000000003	1715670690415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670694424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670694424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.431	1715670694424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670695426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670695426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.431	1715670695426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670697431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670697431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4365	1715670697431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670699435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670699435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4285	1715670699435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670701441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670701441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4285	1715670701441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670709460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670709460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4426	1715670709460	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670710478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670712480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670717476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.7	1715670717476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4475	1715670717476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670719497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670726513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670727515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670729518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670731526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670747542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715670747542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4493	1715670747542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670749546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670749546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4493	1715670749546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670751550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670751550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4505	1715670751550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670753554	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670753554	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4513000000000003	1715670753554	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670761571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715670761571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4297	1715670761571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670762573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670762573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670762573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670763576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670763576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670763576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670764578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670764578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670715472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4451	1715670715472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670718478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670718478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4475	1715670718478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715670722487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715670722487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4338	1715670722487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670724492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670724492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4479	1715670724492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670728501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670728501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4485	1715670728501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670730505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670730505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4491	1715670730505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670732524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670734529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670736533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670738540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670743549	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670746556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670748560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670752568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670756562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670756562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670756562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670766583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670766583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4343000000000004	1715670766583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670767586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670767586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4343000000000004	1715670767586	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670768589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670768589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670768589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670770608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670779627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670783620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715670783620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670783620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670786627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670786627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4471999999999996	1715670786627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670797668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670798669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670807687	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670812698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670813699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670816707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670817708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670878823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715670878823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670878823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670882848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670883850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670888843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715670888843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715670888843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670890848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670890848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715670890848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670893869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4345	1715670764578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670765581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670765581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4343000000000004	1715670765581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670769591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670769591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4352	1715670769591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670772612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670773614	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670774618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670782618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670782618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4455999999999998	1715670782618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670787645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670789649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670792640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670792640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670792640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670793642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670793642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4486	1715670793642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670795647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670795647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4467	1715670795647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670797652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670797652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4467	1715670797652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670800657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715670800657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4523	1715670800657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670801659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670801659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670801659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670803663	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670803663	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670803663	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670809676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670809676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670809676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670810678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670810678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526999999999997	1715670810678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670811680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670811680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526999999999997	1715670811680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670814703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670815704	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670878843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670883834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670883834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670883834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670886855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670888859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670890862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670895859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.2	1715670895859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4556999999999998	1715670895859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670898881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670920928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670921932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670924939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670929933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670929933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670929933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4427	1715670776606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670780615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670780615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4455999999999998	1715670780615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670786644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670790650	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670794660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670806686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670886840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670886840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4575	1715670886840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670887858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670896861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670896861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4556999999999998	1715670896861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670897877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670900884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670906900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670911896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715670911896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670911896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670921916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670921916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4514	1715670921916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670931953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670934944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670934944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670934944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670938952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670938952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4553000000000003	1715670938952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670939954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670939954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670939954	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670940956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670940956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670940956	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670942961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670942961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670942961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670943978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670944966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670944966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670944966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670945968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670945968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670945968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670946970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670948974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670948974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670948974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670949976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670949976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670949976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670950979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670950979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4562	1715670950979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670950994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670952983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715670952983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4581	1715670952983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670952999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670954001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670954989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670778611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670778611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670778611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670779613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715670779613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.444	1715670779613	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670784622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670784622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670784622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670785624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670785624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4464	1715670785624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670787629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670787629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4471999999999996	1715670787629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670788646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670796666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670802661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670802661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670802661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670804665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670804665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670804665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670805667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670805667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670805667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670808674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715670808674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670808674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670818695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715670818695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4529	1715670818695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670898865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715670898865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4574000000000003	1715670898865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670920914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670920914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670920914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670924922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670924922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670924922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670927929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670927929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670927929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670929948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670932940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670932940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670932940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670932955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670933942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670933942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670933942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670933957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670935962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670936948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670936948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4553000000000003	1715670936948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670936964	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670937950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670937950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4553000000000003	1715670937950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670937968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670946970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670946970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670798654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.1	1715670798654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4523	1715670798654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670807671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.3	1715670807671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670807671	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670812682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670812682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526999999999997	1715670812682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670813684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670813684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670813684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670816691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715670816691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4529	1715670816691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670817693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670817693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4529	1715670817693	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670818712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670899868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670899868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4574000000000003	1715670899868	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670901873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670901873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670901873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670902875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670902875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4572	1715670902875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670904881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670904881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4385	1715670904881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670905883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670905883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4385	1715670905883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670909910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670912913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670918910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670918910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.448	1715670918910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670926926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670926926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511999999999996	1715670926926	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670931937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670931937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670931937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670934958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670935946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670935946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670935946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670938967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670939971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670940971	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670942975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670944981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670945983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670946985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670947988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670948990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670949994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670951981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670951981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4581	1715670951981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670953987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670953987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670801674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670803680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670809691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670810694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670811695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670815688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715670815688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670815688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4385	1715670903877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670907888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670907888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670907888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670908890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670908890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4391	1715670908890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670910894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670910894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.443	1715670910894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670913914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670914918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670915920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670916923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670917922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670919931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670922932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670923936	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670925941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670928931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670928931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670928931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670930935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670930935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.454	1715670930935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670941959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670941959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541	1715670941959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670941974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670943963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670943963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4545	1715670943963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670947972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670947972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4541999999999997	1715670947972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670951995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4581	1715670953987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670954989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715670954989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670955004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670955991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715670955991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715670955991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670956006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670956993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670956993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715670956993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670957010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670957995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670957995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4591	1715670957995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670958011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670958997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670958997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4591	1715670958997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670959014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670959999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670959999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4591	1715670959999	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670961018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670963005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670963005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715670963005	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670964008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670964008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4602	1715670964008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670965010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.2	1715670965010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4602	1715670965010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670966027	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670971039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670972038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670973040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670983049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715670983049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670983049	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670985053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670985053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4554	1715670985053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670989078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670994089	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670996093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670999084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715670999084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715670999084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671002091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671002091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4599	1715671002091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671003107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671009106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671009106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4602	1715671009106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671013114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671013114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.459	1715671013114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671018125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671018125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715671018125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671020129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671020129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4559	1715671020129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671023151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671024153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671034159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671034159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.46	1715671034159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671038168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671038168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4661	1715671038168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671044198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671049207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671059213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671059213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4448000000000003	1715671059213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671540246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671540246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5391999999999997	1715671540246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671541248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671541248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5391999999999997	1715671541248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670960015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670968016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670968016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715670968016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670969018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.7	1715670969018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715670969018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670979041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670979041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670979041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670984051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670984051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4554	1715670984051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715670987059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670987059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4411	1715670987059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670991067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670991067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670991067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670993071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670993071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670993071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670998099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671000103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671001107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671004109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671007117	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671025156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671026155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671033157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671033157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.46	1715671033157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671036164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671036164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4664	1715671036164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671045199	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671048206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671054216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671540261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671541263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671545270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671550281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671552285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671555276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715671555276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5456999999999996	1715671555276	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671556293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671561289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671561289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5396	1715671561289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671562291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671562291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5396	1715671562291	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671563294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671563294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5418000000000003	1715671563294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671568304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671568304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671568304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671573329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671575336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671588363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671590369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671594375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670961001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670961001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715670961001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670962019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670963020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670964022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670966012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670966012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715670966012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670970020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670970020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715670970020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670972024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715670972024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4555	1715670972024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670973026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670973026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4555	1715670973026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670978039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670978039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670978039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670983066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670985067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670994073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670994073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670994073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670996078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670996078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4566	1715670996078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670998082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715670998082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4566	1715670998082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670999102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671003093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671003093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4599	1715671003093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671008103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671008103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4602	1715671008103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671009120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671013129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671018140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671020145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671024138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	15	1715671024138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.458	1715671024138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671027158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671034177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671038184	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671049192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671049192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4404	1715671049192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671051212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671542250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671542250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5462	1715671542250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671544253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671544253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5462	1715671544253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671546258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671546258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5514	1715671546258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671548261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671548261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715670962003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670962003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715670962003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670967014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715670967014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715670967014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670970035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670974043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670977051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670980057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670988061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715670988061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4411	1715670988061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670990065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670990065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670990065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670992069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670992069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4494000000000002	1715670992069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670995076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670995076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4524	1715670995076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671002106	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671005114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671010108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671010108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4602	1715671010108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671011110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671011110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.459	1715671011110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671014116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671014116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4585	1715671014116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671016120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671016120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4585	1715671016120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671017123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671017123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715671017123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671021147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671028146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671028146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715671028146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671029148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671029148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4595	1715671029148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671030151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671030151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4595	1715671030151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671031153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671031153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4595	1715671031153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671040172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715671040172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4661	1715671040172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671041174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671041174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.464	1715671041174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671042177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671042177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.464	1715671042177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671043179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671043179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.464	1715671043179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670965026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670969035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715670974028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.4	1715670974028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4555	1715670974028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670977036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.699999999999999	1715670977036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4399	1715670977036	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670980043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11	1715670980043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4526	1715670980043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670981045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670981045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670981045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715670989063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715670989063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4411	1715670989063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670990081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670992085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670995092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671005097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671005097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671005097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671008118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671010124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671011126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671014133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671016138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671017138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671023136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671023136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.458	1715671023136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671028160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671029164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671030167	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671031169	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671040190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671041191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671042193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671043193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671045183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671045183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4637	1715671045183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671046202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671050210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671542266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671544268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671546273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671548275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671551286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671554274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671554274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5456999999999996	1715671554274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671557281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671557281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671557281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671559299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671571328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671578340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671579344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671580344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671586343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671586343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671586343	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671591354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670967029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670968031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670971022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715670971022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715670971022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670979055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670984065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670988076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670991082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670993087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671000086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671000086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715671000086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671001088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671001088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4589000000000003	1715671001088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671004095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671004095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4599	1715671004095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671007101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671007101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671007101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671021131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671021131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4559	1715671021131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671026141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671026141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715671026141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671027144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671027144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4584	1715671027144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671033174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671036179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671048190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671048190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4404	1715671048190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671052213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671056221	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671543251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671543251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5462	1715671543251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671547260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671547260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5514	1715671547260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671549278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671558283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671558283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671558283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671560303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671565316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671566315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671569320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671582335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671582335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5628	1715671582335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671584339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671584339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671584339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671597367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671597367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671597367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671602377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671602377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5634	1715671602377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670975030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.200000000000001	1715670975030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4399	1715670975030	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670976034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715670976034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4399	1715670976034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670978054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670982047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670982047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4546	1715670982047	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715670986056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715670986056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4554	1715670986056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670987074	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670997096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671006116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671012128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671015136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671019143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671022149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671032155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671032155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.46	1715671032155	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671035161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671035161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4664	1715671035161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671037166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671037166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4664	1715671037166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671039170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671039170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4661	1715671039170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671047188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671047188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4404	1715671047188	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671051196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671051196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4478	1715671051196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671053200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715671053200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671053200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671054202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671054202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671054202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671055220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671057230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671058225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671543267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671549263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671549263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5385	1715671549263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671555292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671560287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671560287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5396	1715671560287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671564295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671564295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5418000000000003	1715671564295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671566300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671566300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671566300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671569306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671569306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.549	1715671569306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670975046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670976051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670981062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670982063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715670986072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715670997080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715670997080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4566	1715670997080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671006099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671006099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671006099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671012112	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671012112	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.459	1715671012112	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671015118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671015118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4585	1715671015118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671019127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671019127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4609	1715671019127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671022133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671022133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4559	1715671022133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671025140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671025140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.458	1715671025140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671032171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671035178	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671037182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671039185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671047203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671052198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671052198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4478	1715671052198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671053216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671055204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671055204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671055204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671057209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671057209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4381999999999997	1715671057209	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671058211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671058211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4381999999999997	1715671058211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671059230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671545255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671545255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5514	1715671545255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671550265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671550265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5385	1715671550265	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671552270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671552270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5449	1715671552270	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671553288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671556279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671556279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5456999999999996	1715671556279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671558299	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671561306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671562305	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671563309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671573315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715671573315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671044181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671044181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4637	1715671044181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671046185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671046185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4637	1715671046185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671050194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671050194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4478	1715671050194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671056207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671056207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4381999999999997	1715671056207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671060215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671060215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4448000000000003	1715671060215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671060232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671061218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715671061218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4448000000000003	1715671061218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671061236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671062220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671062220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715671062220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671062236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671063222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671063222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715671063222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671063238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671064224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671064224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4480999999999997	1715671064224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671064238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671065226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671065226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4501	1715671065226	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671065242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671066228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671066228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4501	1715671066228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671066245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671067230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671067230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4501	1715671067230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671067246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671068232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671068232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715671068232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671068254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671069234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671069234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715671069234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671069249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671070237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671070237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4511	1715671070237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671070255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715671071239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4	1715671071239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671071239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671071256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671072241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671072241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671072241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671072257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671073243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671073243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4489	1715671073243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671074245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671074245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4596	1715671074245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671075248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671075248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4596	1715671075248	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671078254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671078254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671078254	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671080258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671080258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4635	1715671080258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671081275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671082279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671088275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671088275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671088275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671091281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671091281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4671	1715671091281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671092298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671095290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671095290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4668	1715671095290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671096292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671096292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4668	1715671096292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671100315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671101319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671102321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671103327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671111340	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671115348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671116351	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671120344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671120344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4538	1715671120344	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671122348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671122348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715671122348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671128360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671128360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4646	1715671128360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671129378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671130383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671136378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671136378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4667	1715671136378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671140387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671140387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4696	1715671140387	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671141390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671141390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4696	1715671141390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671145397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671145397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.47	1715671145397	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671149406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671149406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4683	1715671149406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671150408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671073258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671074262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671075261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671078269	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671080274	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671082262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671082262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4635	1715671082262	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671085283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671088292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671092283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671092283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671092283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671094302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671095304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671100300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671100300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4631999999999996	1715671100300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671101302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671101302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671101302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671102304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671102304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671102304	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671103307	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671103307	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671103307	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671111324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671111324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4666	1715671111324	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671115333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671115333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4654000000000003	1715671115333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671116335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671116335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4673000000000003	1715671116335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671118355	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671120358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671122363	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671128376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671130365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671130365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4646	1715671130365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671134391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671136395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671140406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671141409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671145414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671149420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671150422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671162448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671166462	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671170466	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671172471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671175478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671181489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671194501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671194501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4704	1715671194501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671198510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671198510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4760999999999997	1715671198510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671199511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13	1715671199511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4760999999999997	1715671199511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671076250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671076250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4596	1715671076250	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671081260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671081260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4635	1715671081260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671086285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671087288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671090295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671098296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671098296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4631999999999996	1715671098296	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671099298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671099298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4631999999999996	1715671099298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671104309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671104309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671104309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671107332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671118339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671118339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4673000000000003	1715671118339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671125354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671125354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4639	1715671125354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671127358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671127358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4639	1715671127358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671129362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671129362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4646	1715671129362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671143409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671146416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671157423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671157423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4711999999999996	1715671157423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671158441	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671161431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671161431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4726	1715671161431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671165440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671165440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4739	1715671165440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671171453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671171453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4768000000000003	1715671171453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671173473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671178482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671179484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671185481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671185481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4616	1715671185481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671190493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671190493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4678	1715671190493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671200513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671200513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4769	1715671200513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671202518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671202518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4769	1715671202518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671208531	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671208531	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671208531	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671076264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671086271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671086271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671086271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671087273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671087273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671087273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671090279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671090279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4671	1715671090279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671094288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671094288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671094288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671098313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671099314	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671104323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671113345	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671123350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671123350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715671123350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671125370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671127377	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671143393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671143393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.47	1715671143393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671146400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671146400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4692	1715671146400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671152427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671157439	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671159427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671159427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4708	1715671159427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671161452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671165456	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671173457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671173457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4745	1715671173457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671178467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671178467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766	1715671178467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671179470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671179470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4568000000000003	1715671179470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671180488	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671185498	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671197525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671200533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671202534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671208546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671209548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671211556	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671213559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671218570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671228578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671228578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4828	1715671228578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671232587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671232587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671232587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671237597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671237597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671237597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671240603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671077252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671077252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671077252	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671079256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671079256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606999999999997	1715671079256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671084266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671084266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4655	1715671084266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671089277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671089277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4671	1715671089277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671091298	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671093300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671097310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671105328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671106328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671112327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671112327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4666	1715671112327	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671123365	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671126372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671132384	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671133392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671138383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671138383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4686	1715671138383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671139385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671139385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4686	1715671139385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671151410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671151410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4683	1715671151410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671152413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671152413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.472	1715671152413	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671153431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671154431	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671160430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671160430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4708	1715671160430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671163435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671163435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4726	1715671163435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671164438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671164438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4739	1715671164438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671167444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.3	1715671167444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4744	1715671167444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671169448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671169448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4744	1715671169448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671176463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671176463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766	1715671176463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671177465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671177465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766	1715671177465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671183477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671183477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715671183477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671186484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671186484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671077267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671079271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671084283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671089295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671093286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715671093286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671093286	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671097294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671097294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4668	1715671097294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671105311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671105311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671105311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671106313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.100000000000001	1715671106313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4652	1715671106313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671107316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671107316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4674	1715671107316	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671112341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671126356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671126356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4639	1715671126356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671132369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671132369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671132369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671133371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671133371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671133371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671134374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671134374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4667	1715671134374	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671138398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671139399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671151426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671153415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671153415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.472	1715671153415	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671154417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671154417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.472	1715671154417	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671158425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671158425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4708	1715671158425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671160445	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671163449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671164452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671167461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671169464	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671176477	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671177480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671183492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671186499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671187500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671189505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671191515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671197507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671197507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4760999999999997	1715671197507	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671204537	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671210550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671216569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671218555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671218555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671083264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671083264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4655	1715671083264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671085268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671085268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4655	1715671085268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671108318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671108318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4674	1715671108318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671109320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671109320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4674	1715671109320	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671110322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671110322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4666	1715671110322	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671113329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671113329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4654000000000003	1715671113329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671114347	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671117354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671119356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671121364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671124366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671131382	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671135392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671137398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671142407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671144409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671147418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671148418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671155435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671156436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671168446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671168446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4744	1715671168446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671171469	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671174475	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671182476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.6	1715671182476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715671182476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671184480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671184480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4578	1715671184480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671188489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671188489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4678	1715671188489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671192497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671192497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4720999999999997	1715671192497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671193517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671195517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671196521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671201532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671203534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671205542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671206541	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671215548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671215548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671215548	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671217553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671217553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671217553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671220578	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671230581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671083282	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671096307	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671108333	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671109336	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671110339	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671114331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671114331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4654000000000003	1715671114331	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671117337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671117337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4673000000000003	1715671117337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671119342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671119342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4538	1715671119342	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671121346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671121346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4538	1715671121346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671124352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671124352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4606	1715671124352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671131367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671131367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4642	1715671131367	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671135376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671135376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4667	1715671135376	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671137380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671137380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4686	1715671137380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671142391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671142391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4696	1715671142391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671144395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671144395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.47	1715671144395	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671147402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671147402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4692	1715671147402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671148404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.5	1715671148404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4692	1715671148404	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671155419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671155419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4711999999999996	1715671155419	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671156421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671156421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4711999999999996	1715671156421	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671159448	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671168463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671174459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671174459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4745	1715671174459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671180472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671180472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4568000000000003	1715671180472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671182492	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671184494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671188503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671192511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671195503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671195503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4704	1715671195503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671196505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671196505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671150408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4683	1715671150408	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671162433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671162433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4726	1715671162433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671166442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671166442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4739	1715671166442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671170451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671170451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4768000000000003	1715671170451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671172455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671172455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4768000000000003	1715671172455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671175461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671175461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4745	1715671175461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671181473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671181473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4568000000000003	1715671181473	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671190508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671194517	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671198524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671199526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671212542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671212542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4774000000000003	1715671212542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671214561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671221579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671223581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671226573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671226573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4784	1715671226573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671227593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671234608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671239602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671239602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671239602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671243609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671243609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4795	1715671243609	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671247620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	5.8999999999999995	1715671247620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4829	1715671247620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671248637	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671249639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671250644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671252649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671259649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671259649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671259649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671260667	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671262672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671263673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671273694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671274695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671279708	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671280710	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671281712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671286723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671287725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671289728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671290732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671292736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671294738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4616	1715671186484	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671187486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671187486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4616	1715671187486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671189491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671189491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4678	1715671189491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671191495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671191495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4720999999999997	1715671191495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671193499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671193499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4720999999999997	1715671193499	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671204522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671204522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4789	1715671204522	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671207529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671207529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671207529	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671213544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671213544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4774000000000003	1715671213544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671217568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671219557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671219557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671219557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671222565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671222565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4758	1715671222565	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671225571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671225571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4784	1715671225571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671229580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671229580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4828	1715671229580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671233589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671233589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4845	1715671233589	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671235593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671235593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4845	1715671235593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671251629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671251629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671251629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671253634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671253634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671253634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671257661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671267681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671268683	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671270689	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671271690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671272692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671288711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671288711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671288711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671295742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671547278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671564310	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671567318	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671570309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715671570309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.549	1715671570309	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671571311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4704	1715671196505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671201515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671201515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4769	1715671201515	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671203520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671203520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4789	1715671203520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671205524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671205524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4789	1715671205524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671206526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671206526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671206526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671211538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671211538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4799	1715671211538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671216550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671216550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671216550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671220561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671220561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671220561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671224587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671230600	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671231603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671236610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671244612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671244612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4795	1715671244612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671247635	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671254654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671257645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671257645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671257645	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671266680	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671269685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671277702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671278707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671283716	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671285705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671285705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4858000000000002	1715671285705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671296728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671296728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.488	1715671296728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671297746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5385	1715671548261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671551267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671551267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5449	1715671551267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671553272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671553272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5449	1715671553272	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671554289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671559285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671559285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671559285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671565297	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671565297	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5418000000000003	1715671565297	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671578326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671578326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5625999999999998	1715671578326	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671579328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671207543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671214546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671214546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4774000000000003	1715671214546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671221563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671221563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4758	1715671221563	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671223567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671223567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4758	1715671223567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671224570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671224570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4784	1715671224570	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671227576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671227576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4828	1715671227576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671234591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671234591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4845	1715671234591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671238599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671238599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671238599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671239618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671244629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671248623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671248623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.476	1715671248623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671249625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671249625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.476	1715671249625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671250627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671250627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.476	1715671250627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671252631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671252631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4781	1715671252631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671256641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671256641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4808000000000003	1715671256641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671259665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671262656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671262656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671262656	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671263658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671263658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.483	1715671263658	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671273679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671273679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4838	1715671273679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671274681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671274681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4838	1715671274681	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671279692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.2	1715671279692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4851	1715671279692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671280694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671280694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4851	1715671280694	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671281696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671281696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671281696	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671286707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671286707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4858000000000002	1715671286707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671209533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671209533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4799	1715671209533	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671210535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671210535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4799	1715671210535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671212558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671215567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671226588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671228593	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671232602	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671237615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671240620	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671241621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671242624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671245615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671245615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4829	1715671245615	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671246631	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671256657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671258663	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671261653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671261653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671261653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671264660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671264660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.483	1715671264660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671265662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671265662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.483	1715671265662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671275684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671275684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4844	1715671275684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671276701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671282698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671282698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671282698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671289713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671289713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671289713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671291732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671293737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671298746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671557303	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671567302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671567302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671567302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671568319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671570329	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671572313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671572313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5558	1715671572313	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671574317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671574317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5558	1715671574317	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671576321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671576321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5589	1715671576321	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671577323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671577323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5589	1715671577323	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671581332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671581332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5628	1715671581332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4797	1715671218555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671219577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671222580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671225588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671229596	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671233603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671236595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671236595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671236595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671251646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671253653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671267666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671267666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4846	1715671267666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671268668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671268668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4846	1715671268668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671270672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671270672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671270672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671271674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671271674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671271674	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671272677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671272677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4838	1715671272677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671284703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671284703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4858000000000002	1715671284703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671295725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671295725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4879000000000002	1715671295725	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671297730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671297730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.488	1715671297730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671571311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.549	1715671571311	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671572330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671574332	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671576335	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671577337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671583353	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671585357	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671587361	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671589366	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671598385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671602393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671610393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671610393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5639000000000003	1715671610393	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671618411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671618411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5650999999999997	1715671618411	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671622437	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671625442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671627447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671633444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671633444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5435	1715671633444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671633459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671634465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671636451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715671636451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.553	1715671636451	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671230581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671230581	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671231585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671231585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671231585	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671235610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671238616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671245630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671254636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671254636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4808000000000003	1715671254636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671255639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671255639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4808000000000003	1715671255639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671266664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671266664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4846	1715671266664	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671269670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671269670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671269670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671276685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671276685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4844	1715671276685	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671278690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671278690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4851	1715671278690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671283701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671283701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671283701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671284721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671285723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671296743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5558	1715671573315	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671575319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671575319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5589	1715671575319	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671588348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671588348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5638	1715671588348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671590352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671590352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.565	1715671590352	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671594360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671594360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5648	1715671594360	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671595362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671595362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5648	1715671595362	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671596364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671596364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671596364	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671599371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671599371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5636	1715671599371	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671603380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671603380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5634	1715671603380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671606385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671606385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5642	1715671606385	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671609391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671609391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5639000000000003	1715671609391	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671611396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671240603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671240603	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671241605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671241605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671241605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671242608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671242608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4795	1715671242608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671243627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671246616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671246616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4829	1715671246616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671255654	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671258647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671258647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4819	1715671258647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671260651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671260651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4817	1715671260651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671261669	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671264676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671265679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671275700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671277688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671277688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4844	1715671277688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671282714	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671291717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671291717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671291717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671293721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671293721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4879000000000002	1715671293721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671298731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671298731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.488	1715671298731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671579328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5625999999999998	1715671579328	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671580330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671580330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5625999999999998	1715671580330	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671583337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671583337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5628	1715671583337	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671586359	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671591370	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671592372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671593372	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671604381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715671604381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5634	1715671604381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671605383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671605383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5642	1715671605383	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671616407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671616407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.566	1715671616407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671617409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671617409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5650999999999997	1715671617409	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671618426	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671620416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715671620416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5443000000000002	1715671620416	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671287709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671287709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.484	1715671287709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671288727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671290715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671290715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671290715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671292720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671292720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.486	1715671292720	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671294723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671294723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4879000000000002	1715671294723	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671299733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671299733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4897	1715671299733	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671299749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671300735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671300735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4897	1715671300735	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671300752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671301738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671301738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4897	1715671301738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671301753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671302740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671302740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671302740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671302757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671303742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671303742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671303742	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671303757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671304744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671304744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671304744	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671304758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671305746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671305746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4907	1715671305746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671305761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671306748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671306748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4907	1715671306748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671306764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671307750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671307750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4907	1715671307750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671307764	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671308752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671308752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911	1715671308752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671308768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671309754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671309754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911	1715671309754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671309770	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671310756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671310756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911	1715671310756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671310773	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671311758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671311758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4895	1715671311758	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671311775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671318790	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671322798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671323800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671327809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671331817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671339819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671339819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4949	1715671339819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671340821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671340821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4949	1715671340821	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671342825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671342825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4915	1715671342825	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671347837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671347837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4928000000000003	1715671347837	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671351862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671357874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671362884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671374894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671374894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4821999999999997	1715671374894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671375897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671375897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4821999999999997	1715671375897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671379920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671385919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671385919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671385919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671386921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671386921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5038	1715671386921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671387923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.400000000000002	1715671387923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5038	1715671387923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671388940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671389941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671395939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671395939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671395939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671399947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671399947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5059	1715671399947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671402970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671407978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671417985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671417985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671417985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671418987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671418987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671418987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671423997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671423997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5068	1715671423997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671427003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671427003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671427003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671431014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671431014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086999999999997	1715671431014	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671433018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671433018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671312760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671312760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4895	1715671312760	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671313762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671313762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4895	1715671313762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671315767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671315767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671315767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671316769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671316769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671316769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671319776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671319776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4898000000000002	1715671319776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671320778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671320778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671320778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671321780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.9	1715671321780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671321780	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671324787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671324787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4891	1715671324787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671326806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671334808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671334808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4938000000000002	1715671334808	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671336813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671336813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4917	1715671336813	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671341823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671341823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4915	1715671341823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671348839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671348839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4928000000000003	1715671348839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671349841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671349841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4928000000000003	1715671349841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671354852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671354852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671354852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671355854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671355854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671355854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671356856	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671356856	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.493	1715671356856	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671358860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671358860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.493	1715671358860	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671360865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671360865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4926	1715671360865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671366878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715671366878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766999999999997	1715671366878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671368881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671368881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4836	1715671368881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671369899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671370901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671372904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671312776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671313778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671315782	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671316785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671319793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671320793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671321796	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671324803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671330799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.6	1715671330799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4929	1715671330799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671334823	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671336829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671341838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671348854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671349855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671354869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671355869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671356872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671358875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671360881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671366895	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671369884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671369884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4836	1715671369884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671370886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715671370886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4836	1715671370886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671372890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671372890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4892	1715671372890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671373892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671373892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4892	1715671373892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671376913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671380923	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671390929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671390929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671390929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671394937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671394937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.505	1715671394937	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671397943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671397943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671397943	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671401951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671401951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5076	1715671401951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671404958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671404958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5079000000000002	1715671404958	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671407963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671407963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671407963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671409982	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671410985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671411987	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671414994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671415996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671420991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671420991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.509	1715671420991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671422995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671422995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5068	1715671422995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671314765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671314765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4899	1715671314765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671317772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4.1	1715671317772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4898000000000002	1715671317772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671327793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671327793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671327793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671328810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671332803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.399999999999999	1715671332803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4938000000000002	1715671332803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671338831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671343842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671344844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671345851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671346851	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671350858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671353850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715671353850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671353850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671359862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671359862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4926	1715671359862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671361867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671361867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4926	1715671361867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671363872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671363872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4933	1715671363872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671365876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671365876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766999999999997	1715671365876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671371888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671371888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4892	1715671371888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671375912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671377901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671377901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4965	1715671377901	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671378903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671378903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4965	1715671378903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671381910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671381910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4985	1715671381910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671384917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671384917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671384917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671393935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715671393935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.505	1715671393935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671396941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671396941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671396941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671400950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671400950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5059	1715671400950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671406961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671406961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5079000000000002	1715671406961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671412993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671420004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671314779	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671317787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671328795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.1	1715671328795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671328795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671330816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671338817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671338817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4949	1715671338817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671343828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671343828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4915	1715671343828	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671344830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671344830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4920999999999998	1715671344830	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671345832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.3	1715671345832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4920999999999998	1715671345832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671346834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671346834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4920999999999998	1715671346834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671350844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671350844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671350844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671352848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671352848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671352848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671353864	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671359878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671361883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671363886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671368897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671371903	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671376899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671376899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4821999999999997	1715671376899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671377916	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671378918	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671381928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671384932	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671393950	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671396959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671400966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671412974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671412974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086	1715671412974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671419989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671419989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.509	1715671419989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671430012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671430012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5105999999999997	1715671430012	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671434020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671434020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671434020	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671435021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671435021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671435021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671437026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671437026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4993000000000003	1715671437026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671445043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671445043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5083	1715671445043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671318774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671318774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4898000000000002	1715671318774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671322783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8999999999999995	1715671322783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4919000000000002	1715671322783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671323785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671323785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4891	1715671323785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671326791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671326791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671326791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671331801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671331801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4929	1715671331801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671333820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671339836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671340836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671342841	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671347857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671357858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671357858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.493	1715671357858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671362869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671362869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4933	1715671362869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671365891	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671374909	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671379905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671379905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4965	1715671379905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671382912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671382912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4985	1715671382912	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671385934	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671386935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671388925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671388925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5038	1715671388925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671389927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671389927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671389927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671391947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671395955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671399963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671406976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671416983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671416983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671416983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671418000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671421993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671421993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.509	1715671421993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671424011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671427018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671431029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671433034	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671438045	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671441052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671442052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671446046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671446046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671446046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671447064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671325789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671325789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4891	1715671325789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671329797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.4	1715671329797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4929	1715671329797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671332819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671335810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671335810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4917	1715671335810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671337815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671337815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4917	1715671337815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671351846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671351846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4911999999999996	1715671351846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671364874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671364874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4933	1715671364874	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671367880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715671367880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4766999999999997	1715671367880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671382928	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671383930	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671392933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671392933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.505	1715671392933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671398945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671398945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5059	1715671398945	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671402953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671402953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5076	1715671402953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671403970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671405975	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671408981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671413991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671421006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671429024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671439046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671440048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671443055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671448050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671448050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671448050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671455064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671455064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5284	1715671455064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671458071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671458071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5322	1715671458071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671459073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.400000000000002	1715671459073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5322	1715671459073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671462079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671462079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5348	1715671462079	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671463098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671464098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671469095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671469095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5253	1715671469095	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671476110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671476110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671325805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671329812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671333806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671333806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4938000000000002	1715671333806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671335826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671337833	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671352867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671364889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671367900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671383914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671383914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671383914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671391931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671391931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.504	1715671391931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671392948	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671398962	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671403955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671403955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5076	1715671403955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671405960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671405960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5079000000000002	1715671405960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671408965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671408965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671408965	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671413976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671413976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5095	1715671413976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671419001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671429009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671429009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5105999999999997	1715671429009	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671439031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671439031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4993000000000003	1715671439031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671440033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.400000000000002	1715671440033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5046	1715671440033	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671443040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671443040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5083	1715671443040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671444058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671448067	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671455081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671458086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671459088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671463081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671463081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5348	1715671463081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671464083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671464083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5398	1715671464083	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671467090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671467090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5253	1715671467090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671469109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671476124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671481136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671486150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671489154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671506189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671510183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671373909	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671380908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671380908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4985	1715671380908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671387939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671390947	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671394952	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671397959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671401967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671404972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671409967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671409967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5096	1715671409967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671410969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671410969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086	1715671410969	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671411972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671411972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086	1715671411972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671414978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671414978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5095	1715671414978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671415980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671415980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5095	1715671415980	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671416997	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671422010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671423010	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671425015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671426017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671428021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671432032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671436046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671449052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715671449052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5221999999999998	1715671449052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671456066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671456066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5284	1715671456066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671461077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671461077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5348	1715671461077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671466088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671466088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5398	1715671466088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671467107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671471114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671477126	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671479132	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671483144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671484145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671488138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671488138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5441	1715671488138	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671490141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671490141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5441	1715671490141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671498158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671498158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671498158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671499160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671499160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671499160	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671503168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671425000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671425000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5068	1715671425000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671426001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671426001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671426001	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671428006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671428006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5073000000000003	1715671428006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671432016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671432016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086999999999997	1715671432016	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671436024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671436024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671436024	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671446060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671454062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671454062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5234	1715671454062	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671456085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671461091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671466104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671471099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671471099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5331	1715671471099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671477111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671477111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5393000000000003	1715671477111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671479116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671479116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5423	1715671479116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671483127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671483127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5450999999999997	1715671483127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671484129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671484129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5450999999999997	1715671484129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671486134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671486134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671486134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671488153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671490157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671498172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671499176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671503182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671505172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671505172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5484	1715671505172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671511200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671514205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671519218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671521222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671529237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671535235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671535235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671535235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671536237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671536237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5459	1715671536237	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671581348	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671582350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671584355	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671597381	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671604396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671430026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671434039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671435042	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671437039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671445058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671454078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671460090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671468092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671468092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5253	1715671468092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671470097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671470097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5331	1715671470097	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671472101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671472101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5331	1715671472101	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671473103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671473103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5394	1715671473103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671474119	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671475123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671478131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671480134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671487150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671494165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671495167	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671496168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671501181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671512187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671512187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671512187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671513189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671513189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671513189	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671516196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671516196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5490999999999997	1715671516196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671518200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671518200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5511	1715671518200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671520204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671520204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5511	1715671520204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671534233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671534233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671534233	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671585341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671585341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671585341	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671587346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671587346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5638	1715671587346	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671589350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671589350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5638	1715671589350	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671598369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715671598369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5629	1715671598369	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671605399	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671616422	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671617425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671619414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671619414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5650999999999997	1715671619414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5086999999999997	1715671433018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671438029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671438029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.4993000000000003	1715671438029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671441035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671441035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5046	1715671441035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671442037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671442037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5046	1715671442037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671444041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671444041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5083	1715671444041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671447048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671447048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5091	1715671447048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671450054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671450054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5221999999999998	1715671450054	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671451056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671451056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5221999999999998	1715671451056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671452058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.900000000000002	1715671452058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5234	1715671452058	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671453060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671453060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5234	1715671453060	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671457068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.600000000000001	1715671457068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5284	1715671457068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671462094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671473118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671482140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671491143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671491143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5453	1715671491143	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671492145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671492145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5453	1715671492145	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671493147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671493147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5453	1715671493147	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671497156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.7	1715671497156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671497156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671500161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671500161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671500161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671502186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671505187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671507194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671508193	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671517198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671517198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5490999999999997	1715671517198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671522224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671523227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671525229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671526232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671528235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671530239	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671532245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671537258	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671449068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671460075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671460075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5322	1715671460075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671465100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671468108	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671470111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671472116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671474105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671474105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5394	1715671474105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671475107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715671475107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5394	1715671475107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671478114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671478114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5393000000000003	1715671478114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671480120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671480120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5423	1715671480120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671487136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.600000000000001	1715671487136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671487136	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671494149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671494149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.545	1715671494149	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671495151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671495151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.545	1715671495151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671496154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671496154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.545	1715671496154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671501164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671501164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671501164	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671502166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671502166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5469	1715671502166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671512203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671513205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671516211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671518214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671520220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671534247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671591354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.565	1715671591354	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671592356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671592356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.565	1715671592356	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671593358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671593358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5648	1715671593358	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671608407	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671610410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671619433	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671624425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.399999999999999	1715671624425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5551	1715671624425	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671627432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671627432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5554	1715671627432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671628434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671628434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5554	1715671628434	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671450070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671451075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671452073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671453077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671457084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671465085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671465085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5398	1715671465085	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671482124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.5	1715671482124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5450999999999997	1715671482124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671485148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671491158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671492161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671493161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671497172	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671500179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671504170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715671504170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5484	1715671504170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671507176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671507176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.548	1715671507176	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671508179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.4	1715671508179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.548	1715671508179	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671515210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671522208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671522208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.546	1715671522208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671523210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671523210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.546	1715671523210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671525214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671525214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5475	1715671525214	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671526216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671526216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5475	1715671526216	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671528220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671528220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5504000000000002	1715671528220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671530225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671530225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5324	1715671530225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671532229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671532229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5324	1715671532229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671537240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671537240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5459	1715671537240	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671595378	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671596380	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671599386	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671611396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5652	1715671611396	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671612398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671612398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5652	1715671612398	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671621435	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671625427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671625427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5551	1715671625427	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671629436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5393000000000003	1715671476110	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671481121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671481121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5423	1715671481121	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671485131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671485131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5463	1715671485131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671489140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.9	1715671489140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5441	1715671489140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671506174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671506174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.548	1715671506174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671509181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671509181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671509181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671510197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671515194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671515194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5490999999999997	1715671515194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671524212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671524212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5475	1715671524212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671527218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671527218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5504000000000002	1715671527218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671531242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671533245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671538241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671538241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5459	1715671538241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671539243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671539243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5391999999999997	1715671539243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671600373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671600373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5636	1715671600373	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671601390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671607402	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671613400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671613400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5652	1715671613400	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671614403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671614403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.566	1715671614403	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671615405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671615405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.566	1715671615405	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671620432	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671621418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671621418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5443000000000002	1715671621418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671623438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671626430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671626430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5554	1715671626430	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671631457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671634447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671634447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5435	1715671634447	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671635465	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671637453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.4	1715671637453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.553	1715671637453	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.700000000000001	1715671503168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5484	1715671503168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671504186	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671509195	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671514191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671514191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671514191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671519202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.7	1715671519202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5511	1715671519202	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671521206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671521206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.546	1715671521206	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671529222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671529222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5504000000000002	1715671529222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671531227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671531227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5324	1715671531227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671535251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671600392	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671603394	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671606401	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671609406	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671611410	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671612414	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671622420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671622420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5443000000000002	1715671622420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671624444	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671626446	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671628450	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671629452	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671630455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671632458	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671636481	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671637471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671639457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.5	1715671639457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5570999999999997	1715671639457	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671639472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671640476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671641486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671644486	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671645472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715671645472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5621	1715671645472	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671645494	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671646474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671646474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5621	1715671646474	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671646489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671647476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671647476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5596	1715671647476	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671647491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671648478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671648478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5596	1715671648478	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671648495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671649480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671649480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5596	1715671649480	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671649495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671650483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671510183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671510183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671511185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671511185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5495	1715671511185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671517213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671524228	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671527235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671533231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671533231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5421	1715671533231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671536251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671538257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671539260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671601375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671601375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5636	1715671601375	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671607388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671607388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5642	1715671607388	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671608390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671608390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5639000000000003	1715671608390	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671613418	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671614424	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671615420	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671623423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671623423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5551	1715671623423	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671629436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5583	1715671629436	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671630438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715671630438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5583	1715671630438	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671631440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671631440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5583	1715671631440	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671632442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671632442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5435	1715671632442	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671635449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671635449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.553	1715671635449	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671638455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671638455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5570999999999997	1715671638455	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671638471	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671640459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671640459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5570999999999997	1715671640459	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671641461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671641461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5602	1715671641461	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671642463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671642463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5602	1715671642463	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671642479	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671643467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671643467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5602	1715671643467	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671643482	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671644470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671644470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5621	1715671644470	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671650483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.56	1715671650483	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671651485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671651485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.56	1715671651485	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671652487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671652487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.56	1715671652487	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671655493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671655493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5616999999999996	1715671655493	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671658500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671658500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5633000000000004	1715671658500	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671659518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671665530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671669523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671669523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5649	1715671669523	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671673532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671673532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671673532	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671674534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671674534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671674534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671676538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671676538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671676538	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671679545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671679545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.568	1715671679545	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671687562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715671687562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5659	1715671687562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671688564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671688564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5659	1715671688564	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671692573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671692573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.544	1715671692573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671701595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671701595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671701595	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671702597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671702597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671702597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671706606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671706606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671706606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671708610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671708610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5694	1715671708610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671709612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671709612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5694	1715671709612	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671710614	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671710614	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5696999999999997	1715671710614	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671711616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671711616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5696999999999997	1715671711616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671713621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671713621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671713621	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671650501	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671651503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671653489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671653489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5616999999999996	1715671653489	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671655511	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671658516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671665516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671665516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5656	1715671665516	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671667536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671669540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671673546	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671674552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671676552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671684555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671684555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5688	1715671684555	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671687576	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671688580	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671692588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671701610	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671702611	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671707608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671707608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5694	1715671707608	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671708627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671709627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671710629	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671711632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671718632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671718632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671718632	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671721638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671721638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665	1715671721638	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671722657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671725661	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671728668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671730676	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671739679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671739679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5695	1715671739679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671744690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671744690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671744690	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671752709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671752709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5678	1715671752709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671753727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671757719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671757719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671757719	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671764734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671764734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671764734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671766738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671766738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671766738	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671770745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671770745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5717	1715671770745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671781784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671785778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671652503	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671654505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671659502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671659502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5646999999999998	1715671659502	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671661521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671664530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671670525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671670525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5649	1715671670525	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671671528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.300000000000001	1715671671528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671671528	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671672530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671672530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671672530	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671675552	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671677559	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671680562	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671681566	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671682567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671691571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715671691571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671691571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671694577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.7	1715671694577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.544	1715671694577	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671695594	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671696597	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671697599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671698605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671699605	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671700606	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671705623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671715641	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671716643	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671724644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671724644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671724644	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671726666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671727666	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671731677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671740682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.7	1715671740682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5726	1715671740682	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671741699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671742700	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671745709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671746709	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671749701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671749701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5677	1715671749701	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671760726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671760726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5693	1715671760726	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671762730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671762730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.57	1715671762730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671764748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671767755	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671769759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671771767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671774772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671780784	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671788799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671653505	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671660504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.6	1715671660504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5646999999999998	1715671660504	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671662508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671662508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5637	1715671662508	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671683553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671683553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5688	1715671683553	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671693575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671693575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.544	1715671693575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671703599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671703599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671703599	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671706622	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671719634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671719634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665	1715671719634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671720636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671720636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665	1715671720636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671733665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671733665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5702	1715671733665	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671734668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715671734668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671734668	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671736691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671738677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671738677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5695	1715671738677	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671739698	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671747712	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671750717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671756717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671756717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671756717	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671759724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671759724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5693	1715671759724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671762749	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671771748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671771748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5717	1715671771748	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671774754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.600000000000001	1715671774754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5684	1715671774754	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671777775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671778777	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671782787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671784792	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671790789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.2	1715671790789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711	1715671790789	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671792793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671792793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5713000000000004	1715671792793	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671793795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671793795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5713000000000004	1715671793795	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671795800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671795800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671654491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.8	1715671654491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5616999999999996	1715671654491	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671656495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671656495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5633000000000004	1715671656495	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671661506	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10	1715671661506	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5646999999999998	1715671661506	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671664513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671664513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5637	1715671664513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671667520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671667520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5656	1715671667520	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671670540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671671543	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671675536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671675536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671675536	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671677540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671677540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.568	1715671677540	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671679561	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671681550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671681550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5676	1715671681550	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671682551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.600000000000001	1715671682551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5676	1715671682551	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671686575	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671691587	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671695579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671695579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5464	1715671695579	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671696582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.600000000000001	1715671696582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5464	1715671696582	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671697584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671697584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5464	1715671697584	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671698588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671698588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5606999999999998	1715671698588	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671699590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671699590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5606999999999998	1715671699590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671700591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671700591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5606999999999998	1715671700591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671705604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671705604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671705604	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671715625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671715625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671715625	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671716627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671716627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671716627	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671721653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671726648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671726648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5681	1715671726648	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671727651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671656513	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671660521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671662526	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671683568	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671693590	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671703617	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671707624	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671719649	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671724660	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671733678	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671734684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671737691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671738691	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671747697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671747697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671747697	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671750703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671750703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5677	1715671750703	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671751707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671751707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5677	1715671751707	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671756732	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671759740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671765736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.600000000000001	1715671765736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671765736	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671773768	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671777761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671777761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671777761	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671778763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671778763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671778763	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671782772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671782772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671782772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671784776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671784776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671784776	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671786781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671786781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671786781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671790805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671792809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671793810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671795817	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671799824	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671803832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671806838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671807840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671810845	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671818848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671818848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671818848	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671827867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671827867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671827867	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671829871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671829871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671829871	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671830873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671830873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5747	1715671830873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671833897	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671657497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.8	1715671657497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5633000000000004	1715671657497	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671663510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.5	1715671663510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5637	1715671663510	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671666518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671666518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5656	1715671666518	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671668521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.3	1715671668521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5649	1715671668521	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671672544	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671678557	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671684571	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671685573	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671689567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671689567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671689567	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671690569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671690569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671690569	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671694591	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671704616	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671712634	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671714623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671714623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671714623	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671717630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671717630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.567	1715671717630	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671720652	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671723657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671729672	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671735670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671735670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671735670	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671736673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671736673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671736673	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671743702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671751730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671754727	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671755730	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671758737	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671761746	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671768741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671768741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5704000000000002	1715671768741	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671772750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	15.100000000000001	1715671772750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5717	1715671772750	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671775757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671775757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5684	1715671775757	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671776759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671776759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671776759	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671779765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671779765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705	1715671779765	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671783788	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671794797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671794797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671657512	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671663524	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671666534	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671668535	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671678542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671678542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.568	1715671678542	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671680547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671680547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5676	1715671680547	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671685558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671685558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5688	1715671685558	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671686560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.700000000000001	1715671686560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5659	1715671686560	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671689583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671690583	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671704601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671704601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5674	1715671704601	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671712618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671712618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5696999999999997	1715671712618	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671713636	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671714639	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671717646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671723642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671723642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671723642	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671729655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671729655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665999999999998	1715671729655	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671732679	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671735686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671743688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671743688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671743688	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671748714	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671752724	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671755715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671755715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5686	1715671755715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671757734	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671761728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671761728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.57	1715671761728	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671763745	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671768756	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671772771	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671775772	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671776775	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671779781	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671786799	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671794810	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671802814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671802814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671802814	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671805839	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671808843	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671816858	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671819869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671822873	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671828884	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671832878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671718647	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671722640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.9	1715671722640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5641	1715671722640	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671725646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671725646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5681	1715671725646	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671728653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671728653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665999999999998	1715671728653	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671730657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671730657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5665999999999998	1715671730657	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671737675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671737675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5695	1715671737675	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671740702	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671744705	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671753711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671753711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5678	1715671753711	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671754713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671754713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5678	1715671754713	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671758721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671758721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5693	1715671758721	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671765753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671766753	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671781769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671781769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705	1715671781769	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671783774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671783774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671783774	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671785797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671788785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671788785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711	1715671788785	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671789803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671799807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671799807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5743	1715671799807	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671804832	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671809844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671812836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9	1715671812836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5729	1715671812836	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671813838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671813838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5729	1715671813838	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671817846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671817846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5733	1715671817846	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671823859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671823859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671823859	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671825863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671825863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671825863	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671826865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671826865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671826865	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671839906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671727651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5681	1715671727651	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671731659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671731659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5702	1715671731659	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671732662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671732662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5702	1715671732662	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671741684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671741684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5726	1715671741684	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671742686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671742686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5726	1715671742686	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671745692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671745692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.569	1715671745692	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671746695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671746695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671746695	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671748699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671748699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5667	1715671748699	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671749715	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671760743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671763731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671763731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.57	1715671763731	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671767740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671767740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5704000000000002	1715671767740	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671769743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671769743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5704000000000002	1715671769743	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671770762	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671773752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671773752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5684	1715671773752	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671780767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.4	1715671780767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705	1715671780767	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671787798	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671791791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671791791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5713000000000004	1715671791791	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671796815	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671798819	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671800826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671801826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671814840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671814840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5729	1715671814840	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671815842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671815842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5733	1715671815842	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671817861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671821855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671821855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671821855	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671824861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671824861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671824861	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671831875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671831875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671785778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671785778	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671787783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.700000000000001	1715671787783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671787783	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671789787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.100000000000001	1715671789787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711	1715671789787	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671796801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671796801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671796801	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671804818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671804818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671804818	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671809829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.200000000000001	1715671809829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671809829	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671811849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671812849	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671813852	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671820869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671823876	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671825877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671826883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671847924	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671848929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671849929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671860938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671860938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745999999999998	1715671860938	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671870961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671870961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5754	1715671870961	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671871963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671871963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5754	1715671871963	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671874985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671880983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671880983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671880983	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671881985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671881985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.578	1715671881985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671883003	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671891022	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671893028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671791806	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671798805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.900000000000002	1715671798805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5743	1715671798805	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671800809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671800809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671800809	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671801812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.5	1715671801812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671801812	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671805820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671805820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671805820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671814854	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671815856	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715671820853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.700000000000001	1715671820853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671820853	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671821872	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671824877	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671831889	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671834896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671843914	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671844917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671850915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671850915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5734	1715671850915	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671851931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671852934	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671855927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671855927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671855927	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671862959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671878979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671878979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671878979	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671883990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671883990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.578	1715671883990	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671886011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671887015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671895015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671895015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671895015	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671794797	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671797820	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671802834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671808826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671808826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711999999999997	1715671808826	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671816844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671816844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5733	1715671816844	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671819850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.6000000000000005	1715671819850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671819850	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	99	1715671822857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4.4	1715671822857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671822857	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671828869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671828869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671828869	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671830887	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671832894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671835898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671838890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671838890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671838890	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671840894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671840894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751	1715671840894	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671841896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671841896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751	1715671841896	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671845920	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671846921	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671864949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671864949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671864949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671865951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671865951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671865951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671866953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671866953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5759000000000003	1715671866953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671872966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671872966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671872966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671876989	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671879981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671879981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671879981	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671885994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671885994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5772	1715671885994	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671888013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671889018	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671890021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671892025	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671896031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671897035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671898038	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5719000000000003	1715671795800	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671797803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.2	1715671797803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5743	1715671797803	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671803816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.8	1715671803816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5705999999999998	1715671803816	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671806822	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671806822	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711999999999997	1715671806822	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671807824	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.600000000000001	1715671807824	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5711999999999997	1715671807824	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671810831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.4	1715671810831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671810831	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671811834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	6.9	1715671811834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5709	1715671811834	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671818862	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671827883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671829888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671833880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671833880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671833880	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671836886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671836886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671836886	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671837888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671837888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671837888	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671842898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671842898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671842898	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671850934	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671853941	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671855944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671856944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671857946	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671858949	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671861940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	4.5	1715671861940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745999999999998	1715671861940	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671863944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671863944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5758	1715671863944	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671867955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671867955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5759000000000003	1715671867955	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671868957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671868957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5759000000000003	1715671868957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671869959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671869959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5754	1715671869959	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671871978	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671873984	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671876974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671876974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671876974	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671884991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671884991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5772	1715671884991	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671894013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5747	1715671831875	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671834881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671834881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671834881	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671843900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671843900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671843900	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671844902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671844902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5763000000000003	1715671844902	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671845905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671845905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671845905	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671851917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671851917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671851917	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671852919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671852919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671852919	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671854939	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671862942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671862942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745999999999998	1715671862942	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671875972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671875972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671875972	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671878995	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671884008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671886996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671886996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5772	1715671886996	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671894029	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671895031	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671832878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5747	1715671832878	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671835883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671835883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671835883	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671837907	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671838904	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671840909	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671841911	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671846906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671846906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671846906	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671847908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671847908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5732	1715671847908	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671864966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671865966	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671866967	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671872985	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671877993	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671879998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671887998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671887998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791	1715671887998	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671889002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671889002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791	1715671889002	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671890004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671890004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791	1715671890004	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671892008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671892008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671892008	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671896017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671896017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671896017	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671897019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671897019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671897019	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671898021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671898021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671898021	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671836899	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671839892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671839892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751	1715671839892	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671842913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671853922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671853922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671853922	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671854925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671854925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671854925	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671856929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.8	1715671856929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671856929	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671857931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671857931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766999999999998	1715671857931	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671858933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671858933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766999999999998	1715671858933	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671859951	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671861957	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671863960	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671867970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671868973	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671869976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671873968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671873968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671873968	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671875988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671882000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671885006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671899040	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671848910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671848910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5734	1715671848910	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671849913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.8	1715671849913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5734	1715671849913	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671859935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671859935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766999999999998	1715671859935	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671860953	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671870977	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671874970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671874970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671874970	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671877976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671877976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.574	1715671877976	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671881000	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671882988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.200000000000001	1715671882988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.578	1715671882988	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671891006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671891006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671891006	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671893011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671893011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671893011	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671899023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671899023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671899023	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671894013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671894013	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671900026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671900026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745	1715671900026	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671900041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671901028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671901028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745	1715671901028	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671901046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671902032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671902032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5745	1715671902032	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671902048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671903035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671903035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671903035	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671903052	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671904037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671904037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671904037	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671904051	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671905039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671905039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5751999999999997	1715671905039	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671905056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671906041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671906041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5756	1715671906041	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671906056	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671907043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.9	1715671907043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5756	1715671907043	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671907057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671908046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671908046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5756	1715671908046	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671908064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671909048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671909048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671909048	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671909064	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671910050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671910050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671910050	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671910066	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671911053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671911053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5785	1715671911053	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671911071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671912055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671912055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671912055	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671912069	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671913057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671913057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671913057	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671913072	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671914059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671914059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671914059	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671914075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671915061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671915061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5782	1715671915061	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671916063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671916063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5782	1715671916063	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671917065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671917065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5782	1715671917065	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671918068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671918068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671918068	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671919070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671919070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671919070	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671923077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671923077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5779	1715671923077	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671929104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671935120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671936122	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671942133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671948131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671948131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671948131	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671949148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671954144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671954144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671954144	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671957150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671957150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5773	1715671957150	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671959170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671961174	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671967173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671967173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671967173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671969191	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671976208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671980215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671982220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671985227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671993227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.899999999999999	1715671993227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5812	1715671993227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671994229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671994229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5812	1715671994229	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671997236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.6	1715671997236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671997236	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671999241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671999241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5735	1715671999241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672004251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715672004251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715672004251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672005253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715672005253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5784000000000002	1715672005253	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672009275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672015289	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672020300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671915076	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671916078	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671917081	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671918084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671919087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671923093	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671935103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671935103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671935103	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671936105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671936105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5770999999999997	1715671936105	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671942118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671942118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5803000000000003	1715671942118	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671946141	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671948151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671953142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671953142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5753000000000004	1715671953142	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671954158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671957166	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671961159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.5	1715671961159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671961159	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671965185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671967190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671976192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671976192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5795	1715671976192	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671980200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671980200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5806999999999998	1715671980200	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671982203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671982203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5789	1715671982203	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671985210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671985210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671985210	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671990235	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671993242	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671994245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671997251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671999257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672004268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672005267	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672015275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715672015275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5831999999999997	1715672015275	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672020285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.3	1715672020285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5829	1715672020285	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671920071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671920071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5765	1715671920071	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671924080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671924080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5757	1715671924080	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671927086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671927086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5778000000000003	1715671927086	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671928104	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671932111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671933115	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671934114	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671943134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671950135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671950135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671950135	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671956148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671956148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671956148	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671969177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671969177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671969177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671987213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671987213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671987213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671988215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.2	1715671988215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671988215	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671990220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671990220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5804	1715671990220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671992241	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671996251	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672007257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.4	1715672007257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5784000000000002	1715672007257	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715672011266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	14.9	1715672011266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5835	1715672011266	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715672012268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715672012268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5835	1715672012268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	105	1715672014273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	13.100000000000001	1715672014273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5831999999999997	1715672014273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672017279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715672017279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5826	1715672017279	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672018281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672018281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5826	1715672018281	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672019300	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671920087	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671924094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671928088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671928088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5778000000000003	1715671928088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671932096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671932096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766	1715671932096	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671933098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671933098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671933098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671934100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671934100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671934100	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671940113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671940113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671940113	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671946127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671946127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671946127	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671953158	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671956162	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671972183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671972183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5801999999999996	1715671972183	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671987230	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671988231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671991222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671991222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5804	1715671991222	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671996234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671996234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671996234	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672003268	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672007273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672011280	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672012283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672014287	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672017295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672019283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715672019283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5826	1715672019283	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671921073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671921073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5779	1715671921073	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671925082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671925082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5757	1715671925082	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671926084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671926084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5757	1715671926084	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671929090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	11.600000000000001	1715671929090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5778000000000003	1715671929090	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671930111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671941116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671941116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671941116	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671943120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671943120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5803000000000003	1715671943120	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671955163	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671960173	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671962177	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671964182	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671970197	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671971196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671975204	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671977207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671978212	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671981201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.4	1715671981201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5789	1715671981201	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671983220	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671984224	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671989231	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671995232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715671995232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5812	1715671995232	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671998238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715671998238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671998238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672000260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672001259	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672002264	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672013284	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672016293	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672021288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715672021288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5829	1715672021288	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672022290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672022290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5829	1715672022290	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672024294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672024294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5831999999999997	1715672024294	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671921088	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671925098	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671926099	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671930092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671930092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766	1715671930092	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671940128	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671941134	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671951137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671951137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5753000000000004	1715671951137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671960157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671960157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671960157	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671962161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671962161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.579	1715671962161	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671964168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671964168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791999999999997	1715671964168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671970180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671970180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671970180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671971181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671971181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5799000000000003	1715671971181	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671975190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671975190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5795	1715671975190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671977194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671977194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5795	1715671977194	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671978196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671978196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5806999999999998	1715671978196	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671979198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671979198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5806999999999998	1715671979198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671983205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.4	1715671983205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5789	1715671983205	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671984207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671984207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671984207	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671989218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715671989218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671989218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671992225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715671992225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5804	1715671992225	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671995246	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672000243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.100000000000001	1715672000243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5735	1715672000243	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672001245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672001245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5735	1715672001245	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672002247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.4	1715672002247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715672002247	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672013271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715672013271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5835	1715672013271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715672016277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671922075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.8	1715671922075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5779	1715671922075	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671927102	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671931111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671937124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671938123	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671939125	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671944137	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671945139	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671947146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671950151	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671952140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.8	1715671952140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5753000000000004	1715671952140	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671955146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671955146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5764	1715671955146	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671958168	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671963165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671963165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791999999999997	1715671963165	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671965170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671965170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5791999999999997	1715671965170	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671966187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671968190	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671973185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671973185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5801999999999996	1715671973185	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671974187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12	1715671974187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5801999999999996	1715671974187	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671979213	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671986211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715671986211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715671986211	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671991238	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715672003249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672003249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5788	1715672003249	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672006271	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672008273	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672010263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715672010263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5816999999999997	1715672010263	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715672023292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.6	1715672023292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5831999999999997	1715672023292	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671922091	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671931094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.700000000000001	1715671931094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5766	1715671931094	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671937107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671937107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5770999999999997	1715671937107	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715671938109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.7	1715671938109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5770999999999997	1715671938109	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671939111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.1	1715671939111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5783	1715671939111	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671944122	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671944122	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5803000000000003	1715671944122	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671945124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	10.2	1715671945124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671945124	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	100	1715671947129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671947129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5787	1715671947129	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671949133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3	1715671949133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5786	1715671949133	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671951153	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671952156	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715671958152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7	1715671958152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5773	1715671958152	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671959154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671959154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5773	1715671959154	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671963180	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	103	1715671966171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	9.5	1715671966171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671966171	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	104	1715671968175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	12.3	1715671968175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5798	1715671968175	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671972198	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671973199	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671974208	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671981218	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671986227	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715671998256	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672006255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.8	1715672006255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5784000000000002	1715672006255	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	101	1715672008260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.3999999999999995	1715672008260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5816999999999997	1715672008260	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - CPU Utilization	102	1715672009261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	8.9	1715672009261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5816999999999997	1715672009261	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672010278	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672023306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Utilization	7.1	1715672016277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Memory Usage GB	2.5831999999999997	1715672016277	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672018295	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672021302	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672022306	9345de45de6644e2a68ff9b757d61f1b	0	f
TOP - Swap Memory GB	0.0224	1715672024310	9345de45de6644e2a68ff9b757d61f1b	0	f
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
letter	0	c4f94dfb12074b7dafd1679d35fa7c50
workload	0	c4f94dfb12074b7dafd1679d35fa7c50
listeners	smi+top+dcgmi	c4f94dfb12074b7dafd1679d35fa7c50
params	'"-"'	c4f94dfb12074b7dafd1679d35fa7c50
file	cifar10.py	c4f94dfb12074b7dafd1679d35fa7c50
workload_listener	''	c4f94dfb12074b7dafd1679d35fa7c50
letter	0	9345de45de6644e2a68ff9b757d61f1b
workload	0	9345de45de6644e2a68ff9b757d61f1b
listeners	smi+top+dcgmi	9345de45de6644e2a68ff9b757d61f1b
params	'"-"'	9345de45de6644e2a68ff9b757d61f1b
file	cifar10.py	9345de45de6644e2a68ff9b757d61f1b
workload_listener	''	9345de45de6644e2a68ff9b757d61f1b
model	cifar10.py	9345de45de6644e2a68ff9b757d61f1b
manual	False	9345de45de6644e2a68ff9b757d61f1b
max_epoch	5	9345de45de6644e2a68ff9b757d61f1b
max_time	172800	9345de45de6644e2a68ff9b757d61f1b
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
c4f94dfb12074b7dafd1679d35fa7c50	hilarious-fawn-580	UNKNOWN			daga	RUNNING	1715668762998	\N		active	s3://mlflow-storage/0/c4f94dfb12074b7dafd1679d35fa7c50/artifacts	0	\N
9345de45de6644e2a68ff9b757d61f1b	(0 0) indecisive-wasp-555	UNKNOWN			daga	FINISHED	1715669012139	1715672025236		active	s3://mlflow-storage/0/9345de45de6644e2a68ff9b757d61f1b/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.source.name	file:///home/daga/radt#examples/pytorch	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.source.type	PROJECT	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.project.entryPoint	main	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.runName	hilarious-fawn-580	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.project.env	conda	c4f94dfb12074b7dafd1679d35fa7c50
mlflow.user	daga	9345de45de6644e2a68ff9b757d61f1b
mlflow.source.name	file:///home/daga/radt#examples/pytorch	9345de45de6644e2a68ff9b757d61f1b
mlflow.source.type	PROJECT	9345de45de6644e2a68ff9b757d61f1b
mlflow.project.entryPoint	main	9345de45de6644e2a68ff9b757d61f1b
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	9345de45de6644e2a68ff9b757d61f1b
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	9345de45de6644e2a68ff9b757d61f1b
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	9345de45de6644e2a68ff9b757d61f1b
mlflow.project.env	conda	9345de45de6644e2a68ff9b757d61f1b
mlflow.project.backend	local	9345de45de6644e2a68ff9b757d61f1b
mlflow.runName	(0 0) indecisive-wasp-555	9345de45de6644e2a68ff9b757d61f1b
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

