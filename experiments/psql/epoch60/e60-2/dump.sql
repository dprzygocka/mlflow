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
0	Default	s3://mlflow-storage/0	active	1715620336632	1715620336632
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
SMI - Power Draw	14.65	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
SMI - Timestamp	1715620537.562	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
SMI - GPU Util	0	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
SMI - Mem Util	0	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
SMI - Mem Used	0	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
SMI - Performance State	0	1715620537576	0	f	03d70a076ab147e49dbeed88cf991f29
TOP - CPU Utilization	102	1715621843396	0	f	03d70a076ab147e49dbeed88cf991f29
TOP - Memory Usage GB	2.5838	1715621843396	0	f	03d70a076ab147e49dbeed88cf991f29
TOP - Memory Utilization	6.1	1715621843396	0	f	03d70a076ab147e49dbeed88cf991f29
TOP - Swap Memory GB	0.086	1715621843409	0	f	03d70a076ab147e49dbeed88cf991f29
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.65	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
SMI - Timestamp	1715620537.562	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
SMI - GPU Util	0	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
SMI - Mem Util	0	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
SMI - Mem Used	0	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
SMI - Performance State	0	1715620537576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	0	1715620537642	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	0	1715620537642	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	1.8727	1715620537642	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620537663	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	186.7	1715620538644	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.8	1715620538644	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	1.8727	1715620538644	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620538659	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620539646	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620539646	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	1.8727	1715620539646	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620539678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620540648	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620540648	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.062	1715620540648	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620540661	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620541651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620541651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.062	1715620541651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620541676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620542653	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620542653	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.062	1715620542653	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620542667	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620543655	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620543655	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0621	1715620543655	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620543668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620544657	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620544657	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0621	1715620544657	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620544675	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620545659	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620545659	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0621	1715620545659	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620545673	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	106	1715620546661	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620546661	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0625	1715620546661	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620546675	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620547662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620547662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0625	1715620547662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620547676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620548665	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620548665	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0625	1715620548665	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620548687	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620549667	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620549667	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.063	1715620549667	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620549689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620550670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620550670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.063	1715620550670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620550683	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620551672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620551672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.063	1715620551672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620551692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620552695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620560692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620560692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715620560692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620561695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620561695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5815	1715620561695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620562697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620562697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5815	1715620562697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620564702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620564702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5824000000000003	1715620564702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620573720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620573720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5861	1715620573720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620574723	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620574723	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5861	1715620574723	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620579735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620579735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.497	1715620579735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620580737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620580737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.497	1715620580737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620584747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620584747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.4985999999999997	1715620584747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620585770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620593780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620594789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620897408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620897408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.524	1715620897408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620898410	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620898410	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.524	1715620898410	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620906426	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620906426	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5229	1715620906426	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620910435	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715620910435	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5251	1715620910435	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620915446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620915446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5244	1715620915446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620917466	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620928472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620928472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.527	1715620928472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620940497	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620940497	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5295	1715620940497	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620941500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620941500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5295	1715620941500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620942502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620942502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5321	1715620942502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620947513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620947513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5234	1715620947513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620951523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620552674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620552674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0635	1715620552674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620554703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620560715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620561718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620562719	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620564723	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620573741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620574738	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620579752	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620580750	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620584761	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620593766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620593766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5054000000000003	1715620593766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620594768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620594768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620594768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620897421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620898433	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620906440	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620910449	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620915461	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620926468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620926468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620926468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620928493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620940510	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620941522	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620942522	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620947527	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620951544	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621208060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5395	1715621208060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621210064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621210064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5438	1715621210064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621211066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621211066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5438	1715621211066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621213070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621213070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425	1715621213070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621214072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621214072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425	1715621214072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621216076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621216076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621216076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621218080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621218080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621218080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621223092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621223092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.546	1715621223092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621225096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621225096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5412	1715621225096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621231109	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621231109	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5435	1715621231109	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621234114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621234114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	106	1715620553676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620553676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0635	1715620553676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620554678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620554678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.0635	1715620554678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.0664	1715620555704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.0664	1715620556705	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.0664	1715620557703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620563715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620566720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620575741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620591762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620591762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5054000000000003	1715620591762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620899412	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620899412	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.524	1715620899412	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620905424	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620905424	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5227	1715620905424	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620907429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620907429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5229	1715620907429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620908431	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620908431	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5229	1715620908431	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620909433	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620909433	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5251	1715620909433	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620913441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620913441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620913441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620914444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620914444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620914444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620921458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715620921458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620921458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620922460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620922460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620922460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620930476	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620930476	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620930476	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620931501	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620935487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620935487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715620935487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620937491	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620937491	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5293	1715620937491	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620938493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620938493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5293	1715620938493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620945509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620945509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5234	1715620945509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620956554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621224094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5412	1715621224094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621228102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621228102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621228102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.06559999999999999	1715620553689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620555681	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620555681	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.3725	1715620555681	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620556683	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.2	1715620556683	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.3725	1715620556683	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620557686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620557686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.3725	1715620557686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620563699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620563699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5815	1715620563699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620566706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620566706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5824000000000003	1715620566706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620575725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620575725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5861	1715620575725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620585749	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620585749	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5023	1715620585749	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620591784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620899434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620905439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620907449	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620908453	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620909453	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620913462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620914464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620921479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620922474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620930490	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620932495	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620935500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620937505	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620938516	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620956533	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620956533	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5254000000000003	1715620956533	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621232110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621232110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5435	1715621232110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621233112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621233112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5467	1715621233112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621238123	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621238123	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621238123	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621239125	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621239125	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621239125	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621244134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621244134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.547	1715621244134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621249144	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621249144	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621249144	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621250146	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621250146	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621250146	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621251148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621251148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621251148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620558688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.8	1715620558688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715620558688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620567708	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620567708	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5828	1715620567708	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620569728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620577745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620582767	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620590783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620592784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620596795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620900414	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620900414	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620900414	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620901416	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620901416	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620901416	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620902434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620903442	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620912454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620918472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620919469	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620920469	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620924485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620927470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620927470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.527	1715620927470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620933483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620933483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715620933483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620934485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620934485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715620934485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620944506	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.7	1715620944506	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5321	1715620944506	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620945524	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620946532	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620948538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620949539	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620952539	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620955545	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5467	1715621234114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621235116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621235116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5467	1715621235116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621236119	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621236119	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621236119	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621242130	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621242130	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.547	1715621242130	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621247140	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621247140	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5431999999999997	1715621247140	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621248142	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621248142	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621248142	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621252150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621252150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621252150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621256159	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621256159	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620558703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620567727	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620577731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620577731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5843000000000003	1715620577731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620582743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620582743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.4985999999999997	1715620582743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620590760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620590760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620590760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620592764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620592764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5054000000000003	1715620592764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620596772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620596772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620596772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620900427	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620901437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620903420	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620903420	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5227	1715620903420	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620912439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620912439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620912439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620918452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620918452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5255	1715620918452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620919454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620919454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5255	1715620919454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620920456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715620920456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5255	1715620920456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620924464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620924464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620924464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620926481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620927493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620933505	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620934508	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620944528	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620946511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620946511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5234	1715620946511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620948515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620948515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5228	1715620948515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620949517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620949517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5228	1715620949517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620952525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620952525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5245	1715620952525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620955531	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620955531	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5254000000000003	1715620955531	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621241150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621243145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621245157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621246161	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621255177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621317286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621317286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620559690	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.8	1715620559690	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715620559690	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620565704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.8	1715620565704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5824000000000003	1715620565704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620568710	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.8	1715620568710	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5828	1715620568710	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620569712	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620569712	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5828	1715620569712	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620570728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620571740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620572741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620576741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620578748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620581762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620583765	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620586774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620587776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620588776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620589772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620595784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620902418	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620902418	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620902418	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620904441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620911458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620916475	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620923462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620923462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620923462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620925466	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715620925466	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620925466	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620929474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620929474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.527	1715620929474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620931479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620931479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620931479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620936489	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620936489	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5293	1715620936489	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620939495	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620939495	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5295	1715620939495	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620943504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620943504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5321	1715620943504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620950519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620950519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5228	1715620950519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620953527	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620953527	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5245	1715620953527	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620954529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620954529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5254000000000003	1715620954529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621256159	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5476	1715621317286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621322296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621322296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620559716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620565720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.08120000000000001	1715620568725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620570714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620570714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5825	1715620570714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620571716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715620571716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5825	1715620571716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620572718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620572718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5825	1715620572718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620576727	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.3	1715620576727	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5843000000000003	1715620576727	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620578733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620578733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5843000000000003	1715620578733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620581741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620581741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.497	1715620581741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620583745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620583745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.4985999999999997	1715620583745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620586751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620586751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5023	1715620586751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620587754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620587754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5023	1715620587754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620588756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620588756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620588756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620589758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620589758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620589758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620595770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620595770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620595770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620597774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.6	1715620597774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620597774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620597790	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620598776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620598776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620598776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620598797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620599778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.8	1715620599778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620599778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620599799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620600780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620600780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620600780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620600805	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620601782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620601782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620601782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620601803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620602784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620602784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5036	1715620602784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620602799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620603787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620603787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620603787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620606793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620606793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.508	1715620606793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620608797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620608797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.508	1715620608797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620609799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.8	1715620609799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5094000000000003	1715620609799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620610801	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620610801	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5094000000000003	1715620610801	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620612826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620614830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620618831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620622840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620630863	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620634867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620640886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620647878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.3	1715620647878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.506	1715620647878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620652890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620652890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5126	1715620652890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620654895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620654895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620654895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620655897	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620655897	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620655897	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620904422	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715620904422	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5227	1715620904422	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620911437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620911437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5251	1715620911437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620916448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715620916448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5244	1715620916448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620917450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620917450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5244	1715620917450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620923485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620925481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620929498	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620932481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620932481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620932481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620936504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620939508	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620943520	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620950534	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620953551	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620954546	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621257162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621257162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5453	1715621257162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621263174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621263174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5483000000000002	1715621263174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621264176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620603800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620606814	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620608818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620609820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620612805	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.2	1715620612805	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5089	1715620612805	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620614809	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620614809	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5089	1715620614809	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620618818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620618818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5078	1715620618818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620622826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620622826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5067	1715620622826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620630843	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620630843	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5085	1715620630843	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620634851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.5	1715620634851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5082	1715620634851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620640863	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620640863	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620640863	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620645895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620647899	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620652904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620654918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620655920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620951523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5245	1715620951523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621257177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621263189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621264198	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621266200	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621274217	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621278221	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621280227	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621284241	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621285244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621290253	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621295263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621296256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621299273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621307289	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621317307	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621322309	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621331314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621331314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5489	1715621331314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621336324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621336324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621336324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621337326	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621338349	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621339344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621340332	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621340332	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5526	1715621340332	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621342337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621342337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5529	1715621342337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621344342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621344342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620604789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620604789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620604789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620605791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620605791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5065	1715620605791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620607814	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620611803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620611803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5094000000000003	1715620611803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620616813	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620616813	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620616813	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620621845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620631865	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620632860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620633870	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620638880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620639883	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620642889	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620644893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620648896	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620650885	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620650885	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620650885	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620651887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.9	1715620651887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5126	1715620651887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620957536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620957536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620957536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620960542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715620960542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620960542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620963550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620963550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5299	1715620963550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620964552	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620964552	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5299	1715620964552	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620974573	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620974573	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620974573	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620978580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715620978580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5308	1715620978580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620989625	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620990627	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620992631	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620994636	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621008656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621009668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621011671	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621013675	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621016681	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621258164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621258164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5453	1715621258164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621259167	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621259167	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5453	1715621259167	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621271191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621271191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621271191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620604802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620605811	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620610826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620611825	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620616841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620631845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620631845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5085	1715620631845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620632847	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620632847	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5085	1715620632847	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620633849	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620633849	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5082	1715620633849	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620638859	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620638859	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5135	1715620638859	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620639861	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620639861	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620639861	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620642867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620642867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5034	1715620642867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620644871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620644871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5034	1715620644871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620648881	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620648881	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620648881	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620649907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620650906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620957558	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620960563	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620963573	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620964565	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620974587	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620989604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715620989604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620989604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620990606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715620990606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5311999999999997	1715620990606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620992610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620992610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5311999999999997	1715620992610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620994614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620994614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5307	1715620994614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621008643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621008643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286	1715621008643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621009645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621009645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286	1715621009645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621011649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715621011649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5284	1715621011649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621013654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621013654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5284	1715621013654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621016660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621016660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5291	1715621016660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621258179	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620607795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620607795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.508	1715620607795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620613832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620615834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620617830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620623851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620624851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620625853	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620627859	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620628860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620643891	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620958538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620958538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620958538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620965554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620965554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5299	1715620965554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620968581	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620971581	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620973586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620975591	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620984592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715620984592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5316	1715620984592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620987599	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620987599	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620987599	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715620988601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715620988601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5292	1715620988601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620995637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620999646	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621003653	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621259189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621271211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621272207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621273208	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621275220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621281235	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621282229	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621283230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621287239	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621288242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621298269	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621300273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621301277	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621318288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621318288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5476	1715621318288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621319290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621319290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5476	1715621319290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621321294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621321294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621321294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621323298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621323298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621323298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621325302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621325302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621325302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621326303	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621326303	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5498000000000003	1715621326303	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620613807	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620613807	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5089	1715620613807	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620615811	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620615811	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620615811	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620617816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620617816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620617816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620619820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620619820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5078	1715620619820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620619841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620620822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.3	1715620620822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5078	1715620620822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620620842	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620621824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620621824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5067	1715620621824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620623828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620623828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5067	1715620623828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620624830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620624830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620624830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620625832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620625832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620625832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620626834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620626834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620626834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620626856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620627836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620627836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620627836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620628838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620628838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620628838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620629840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620629840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5083	1715620629840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620629864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620635853	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620635853	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5082	1715620635853	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620635877	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620636855	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620636855	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5135	1715620636855	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620636875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620637857	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.9	1715620637857	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5135	1715620637857	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620637871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620641865	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620641865	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620641865	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620641886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620643869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620643869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5034	1715620643869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620645874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620645874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.506	1715620645874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620646897	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620651908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620958560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620968560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620968560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620968560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620971566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620971566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5276	1715620971566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620973571	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620973571	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620973571	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620975574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.6	1715620975574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5302	1715620975574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620979582	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715620979582	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5308	1715620979582	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620984616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620987619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620995616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620995616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5307	1715620995616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620999624	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620999624	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715620999624	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621003632	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621003632	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5281	1715621003632	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621012666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621260169	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621260169	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5471999999999997	1715621260169	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621265177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621265177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5483000000000002	1715621265177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621268183	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621268183	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621268183	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621270189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621270189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621270189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621291234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621291234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621291234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621292236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621292236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621292236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621302272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621303280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621304282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621305283	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621308290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621309290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621313299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621314302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621318310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621319305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621321316	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621323311	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621325323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621327305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621327305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620646876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620646876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.506	1715620646876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620649883	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620649883	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5061999999999998	1715620649883	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620653893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620653893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5126	1715620653893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620959540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620959540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5261	1715620959540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620961545	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715620961545	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620961545	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620965568	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620967572	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620970578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620977600	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620983590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620983590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.531	1715620983590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620985594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620985594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5316	1715620985594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620991608	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620991608	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5311999999999997	1715620991608	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620993612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620993612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5307	1715620993612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620996618	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620996618	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5326	1715620996618	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621000626	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621000626	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715621000626	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621001628	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621001628	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715621001628	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621002630	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621002630	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5281	1715621002630	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621006639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621006639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5283	1715621006639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621010647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621010647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286	1715621010647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621012652	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621012652	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5284	1715621012652	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621260188	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621265198	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621268205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621270211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621291256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621302256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.6	1715621302256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621302256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621303258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621303258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621303258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621304260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620653914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620656899	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620656899	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620656899	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620656914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620657901	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620657901	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5119000000000002	1715620657901	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620657925	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620658904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.5	1715620658904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5119000000000002	1715620658904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620658931	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620659906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620659906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5119000000000002	1715620659906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620659928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620660908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620660908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5117	1715620660908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620660930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620661910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620661910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5117	1715620661910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620661931	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620662912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620662912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5117	1715620662912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620662925	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620663914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620663914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5049	1715620663914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620663926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620664916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.8	1715620664916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5049	1715620664916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620664930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620665918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620665918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5049	1715620665918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620665934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620666920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620666920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5056	1715620666920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620666934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620667922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620667922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5056	1715620667922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620667936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620668924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620668924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5056	1715620668924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620668940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620669926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620669926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5046	1715620669926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620669942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620670928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620670928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5046	1715620670928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620670950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620671930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620671930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5046	1715620671930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620671943	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620673957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620676940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620676940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5096999999999996	1715620676940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620682952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620682952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.511	1715620682952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620683979	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620685973	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620688978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620698984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620698984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620698984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620699986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620699986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620699986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620703994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620703994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620703994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620705017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620713026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620716042	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620959555	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620961560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620967558	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620967558	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620967558	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620970564	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620970564	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5276	1715620970564	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620977578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715620977578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5302	1715620977578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620979604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620983611	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620985609	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620991622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620993626	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620996631	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621000639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621001643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621002657	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621006660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621010669	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621261170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621261170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5471999999999997	1715621261170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621262172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621262172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5471999999999997	1715621262172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621267181	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621267181	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621267181	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621269186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621269186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621269186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621276202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621276202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621276202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621277205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621277205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621277205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621279209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620672932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620672932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620672932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620675962	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620691991	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620695978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620695978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620695978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620696980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620696980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620696980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620701010	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620706019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620710028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620711030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620715032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620962547	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620962547	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620962547	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620966556	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620966556	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5252	1715620966556	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620969562	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620969562	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5276	1715620969562	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620972569	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620972569	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5286999999999997	1715620972569	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620976576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620976576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5302	1715620976576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620978602	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620980605	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620981600	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620982610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620986610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620997620	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715620997620	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5326	1715620997620	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620998622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715620998622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5326	1715620998622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621004634	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621004634	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5281	1715621004634	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621005637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621005637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5283	1715621005637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621007641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621007641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5283	1715621007641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621014656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621014656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5291	1715621014656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621015658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621015658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5291	1715621015658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621261183	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621262184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621267195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621269206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621276224	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621277219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621279233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620672956	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620691970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620691970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.51	1715620691970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620694990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620695999	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620697002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620705998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620705998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5069	1715620705998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620710007	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620710007	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.507	1715620710007	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620711009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620711009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.507	1715620711009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620715017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620715017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.509	1715620715017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620962564	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620966571	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620969583	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620972581	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620976592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620980584	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620980584	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5308	1715620980584	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620981586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.9	1715620981586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.531	1715620981586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620982588	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715620982588	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.531	1715620982588	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620986596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715620986596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5316	1715620986596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620988621	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620997640	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620998643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621004655	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621005658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621007655	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621014678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621015671	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621264176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5483000000000002	1715621264176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621266179	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621266179	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621266179	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621274197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621274197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621274197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621278207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621278207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465	1715621278207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621280211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621280211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465	1715621280211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621284220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621284220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621284220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621285222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621285222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621285222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620673934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715620673934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620673934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620675939	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620675939	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5096999999999996	1715620675939	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620676953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620683954	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620683954	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.511	1715620683954	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620684971	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620688964	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620688964	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5074	1715620688964	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620694976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620694976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620694976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620699005	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620700007	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620704016	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620713013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620713013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5077	1715620713013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620716020	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620716020	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.509	1715620716020	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621017662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621017662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621017662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621018664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621018664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621018664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621019666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621019666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621019666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621020692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621023688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621024699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621026704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621029709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621035701	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621035701	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5313000000000003	1715621035701	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621038707	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621038707	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621038707	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621052736	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621052736	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5275	1715621052736	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621055742	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621055742	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5329	1715621055742	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621068768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621068768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5368000000000004	1715621068768	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621069792	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621070793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621071788	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621075803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621080816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621084825	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621087821	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621099855	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621102840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620674937	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620674937	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5064	1715620674937	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620677942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620677942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5096999999999996	1715620677942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620679946	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620679946	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620679946	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620681950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620681950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.511	1715620681950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620682968	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620686960	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715620686960	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5051	1715620686960	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620689966	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620689966	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5074	1715620689966	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620693974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.9	1715620693974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620693974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620701990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620701990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620701990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620708002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620708002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5069	1715620708002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620709005	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715620709005	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.507	1715620709005	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621017684	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621018685	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621019688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621023674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621023674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715621023674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621024678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621024678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715621024678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621026682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621026682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5303	1715621026682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621029688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621029688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715621029688	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621034713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621035716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621038720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621052753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621055756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621068783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621070772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621070772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5368000000000004	1715621070772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621071774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621071774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5341	1715621071774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621075783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621075783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621075783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	110	1715621080793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621080793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.539	1715621080793	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620674962	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620677967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620679969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620681964	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620685959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620685959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5051	1715620685959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620686974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620689987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620693995	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620702010	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620708018	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620709025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621020668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621020668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5319000000000003	1715621020668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621025703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621027700	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621028707	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621031714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621032709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621033711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621036725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621040732	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621044740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621047747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621061754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621061754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621061754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621063758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621063758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5354	1715621063758	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621064760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621064760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5354	1715621064760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621065762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621065762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621065762	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621069770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621069770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5368000000000004	1715621069770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621074801	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621076797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621077808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621078873	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621079813	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621086819	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621091832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621092841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621094844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621095848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621096851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621105846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621105846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5357	1715621105846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621110869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621111872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621113883	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621126888	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621126888	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621126888	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621128892	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621128892	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5413	1715621128892	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621131898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620678944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715620678944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620678944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620680948	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620680948	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620680948	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620684957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715620684957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5051	1715620684957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620687976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620690988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620692986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620697997	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620702992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620702992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620702992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620704996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620704996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620704996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620707024	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620712026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620714036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621021670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621021670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5319000000000003	1715621021670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715621030691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621030691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715621030691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621034699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621034699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5305999999999997	1715621034699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621042730	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621045735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621046747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621048750	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621056744	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621056744	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5336	1715621056744	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621057746	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621057746	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5336	1715621057746	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621059750	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621059750	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621059750	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621062756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621062756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5354	1715621062756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621067766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621067766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621067766	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621083800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.9	1715621083800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621083800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621089812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621089812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621089812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621093822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621093822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621093822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621100860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621108852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621108852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406	1715621108852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621112860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620678965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620680969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620687962	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.8	1715620687962	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5074	1715620687962	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620690968	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715620690968	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.51	1715620690968	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620692972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620692972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.51	1715620692972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620697982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.3	1715620697982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5111999999999997	1715620697982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620700988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620700988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620700988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620703016	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715620707000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620707000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5069	1715620707000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620712011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620712011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5077	1715620712011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620714015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620714015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.509	1715620714015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620717022	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620717022	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620717022	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620717039	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620718024	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620718024	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620718024	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620718044	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620719026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620719026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5105	1715620719026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620719048	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620720028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620720028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5128000000000004	1715620720028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620720049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620721030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620721030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5128000000000004	1715620721030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620721052	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620722032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620722032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5128000000000004	1715620722032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620722054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620723034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620723034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5118	1715620723034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620723049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620724036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.7	1715620724036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5118	1715620724036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620724059	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620725038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620725038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5118	1715620725038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620725060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620726040	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620726040	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5113000000000003	1715620726040	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620727064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620743076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620743076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620743076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620744079	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620744079	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620744079	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620745081	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620745081	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620745081	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620750091	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620750091	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620750091	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620755101	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620755101	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5153000000000003	1715620755101	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620760132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620769131	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620769131	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5159000000000002	1715620769131	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620774141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620774141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5144	1715620774141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621021693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621030713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621042716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621042716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621042716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621045722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621045722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621045722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621046724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621046724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621046724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621048728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	12.5	1715621048728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5347	1715621048728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621053753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621056765	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621057760	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621059770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621062781	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621067780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621083821	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621089826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621093843	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621101861	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621108875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621112875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715621117871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621117871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5361	1715621117871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621119875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621119875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5378000000000003	1715621119875	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621123882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621123882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621123882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621127890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621127890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621127890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621130896	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620726060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620728061	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620730070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620733077	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620734079	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620737085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620738088	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620741086	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620747098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620752111	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620756104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620756104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620756104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620757106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.399999999999999	1715620757106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620757106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620758108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620758108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620758108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620764120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620764120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5151999999999997	1715620764120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620765122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620765122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5155	1715620765122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620767127	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620767127	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5155	1715620767127	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620768150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620770146	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620771156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620772151	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620775156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621022672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715621022672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5319000000000003	1715621022672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621037705	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621037705	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5313000000000003	1715621037705	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621039709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621039709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621039709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621041714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621041714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621041714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621043718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621043718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621043718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621049730	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621049730	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5347	1715621049730	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621050732	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621050732	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5275	1715621050732	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	107	1715621051734	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621051734	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5275	1715621051734	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621053739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621053739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5329	1715621053739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621054763	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621060752	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621060752	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621060752	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620727042	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620727042	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5113000000000003	1715620727042	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620732054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620732054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145	1715620732054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620743097	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620744101	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620745102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620750112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620760112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620760112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5175	1715620760112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620768129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620768129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5159000000000002	1715620768129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620769154	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620774156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621022686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621037722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621039732	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621041730	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621043740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621049752	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621050753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621051756	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621054740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621054740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5329	1715621054740	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621058770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621060774	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621066783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621072789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621073799	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621081810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621082816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621085828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621088823	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621090830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621097843	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621100836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621100836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5314	1715621100836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621106864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621107864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621109867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621122880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621122880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621122880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621124884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621124884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621124884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621125886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621125886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621125886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621132900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621132900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406999999999997	1715621132900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621136910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621136910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621136910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621272193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621272193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621272193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621273195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620728044	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620728044	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5113000000000003	1715620728044	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620729046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620729046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5131	1715620729046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620730049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620730049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5131	1715620730049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620733056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620733056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145	1715620733056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620734058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.7	1715620734058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145	1715620734058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620736062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620736062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620736062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620737064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620737064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620737064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620738066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620738066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5125	1715620738066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620740070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620740070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5125	1715620740070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620741072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620741072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620741072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620742074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620742074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620742074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620747085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620747085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620747085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620749089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620749089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620749089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620752095	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620752095	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620752095	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620753097	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.600000000000001	1715620753097	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5153000000000003	1715620753097	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620754099	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620754099	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5153000000000003	1715620754099	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620755118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620756124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620757122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620758132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620759110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620759110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5175	1715620759110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620762116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620762116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5151999999999997	1715620762116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620764141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620765137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620767149	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620770133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.399999999999999	1715620770133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5159000000000002	1715620770133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620729068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620736075	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620740092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620742089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620749111	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620753118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620754120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620759130	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620762130	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620773161	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621025680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621025680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5323	1715621025680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621027684	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621027684	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5303	1715621027684	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621028686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621028686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5303	1715621028686	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621031693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621031693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5282	1715621031693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621032695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621032695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5305999999999997	1715621032695	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621033697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621033697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5305999999999997	1715621033697	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621036703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.2	1715621036703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5313000000000003	1715621036703	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621040711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715621040711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621040711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621044720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621044720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621044720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621047726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621047726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5347	1715621047726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621058748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621058748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5336	1715621058748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621061775	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621063784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621064782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621065783	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621074781	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621074781	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621074781	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621076785	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621076785	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621076785	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621077787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621077787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621077787	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621078789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621078789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621078789	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621079791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621079791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621079791	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621086806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621086806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620731051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620731051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5131	1715620731051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620732074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620735082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620739090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620746096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620748111	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620751107	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620761134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620763139	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620766147	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620776166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621066764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621066764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621066764	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621072776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621072776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5341	1715621072776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621073778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715621073778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5341	1715621073778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621081795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621081795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.539	1715621081795	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621082797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715621082797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.539	1715621082797	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621085804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621085804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621085804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621088810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621088810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5353000000000003	1715621088810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621090815	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621090815	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621090815	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621097830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621097830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621097830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621098831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621098831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5314	1715621098831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621105867	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621107850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621107850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406	1715621107850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621109854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621109854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406	1715621109854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621115866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621115866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5403000000000002	1715621115866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621122902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621124907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621125907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621132914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621136924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621273195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621273195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621275199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621275199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621275199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621281213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620731072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620735060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620735060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620735060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620739068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620739068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5125	1715620739068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620746083	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620746083	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620746083	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620748087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620748087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620748087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620751093	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620751093	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5134000000000003	1715620751093	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620761114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620761114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5175	1715620761114	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620763118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620763118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5151999999999997	1715620763118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620766124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620766124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5155	1715620766124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620776145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620776145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5144	1715620776145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621084802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621084802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5366	1715621084802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621087808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621087808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5353000000000003	1715621087808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621099833	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621099833	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5314	1715621099833	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621101838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621101838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621101838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621102853	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621103857	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621104865	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621115888	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621116885	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621118895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621120898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621121893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621129915	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621134927	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621279209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465	1715621279209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621286224	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621286224	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621286224	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621289230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.3	1715621289230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5424	1715621289230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621292250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621293262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621294263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621297260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621306285	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621310294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620771135	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620771135	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620771135	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620772137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620772137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620772137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620775143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620775143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5144	1715620775143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5353000000000003	1715621086806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621091817	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621091817	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5349	1715621091817	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621092819	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621092819	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621092819	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621094824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621094824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5359000000000003	1715621094824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621095826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621095826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621095826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621096828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621096828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5304	1715621096828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621098845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621110856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621110856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621110856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621111858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621111858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621111858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621113862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621113862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5403000000000002	1715621113862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621114886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621126912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621128906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621131911	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621281213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621281213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621282215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621282215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621282215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621283218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621283218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621283218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621287226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621287226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5424	1715621287226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621288228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621288228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5424	1715621288228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621298248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621298248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621298248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621300252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621300252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621300252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621301254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621301254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621301254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621320292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621320292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620773139	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620773139	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5138000000000003	1715620773139	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620777148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620777148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145999999999997	1715620777148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620777170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620778150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620778150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145999999999997	1715620778150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620778163	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620779152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620779152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5145999999999997	1715620779152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620779178	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620780155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620780155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166	1715620780155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620780177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620781157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620781157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166	1715620781157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620781180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620782160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620782160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166	1715620782160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620782174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715620783162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620783162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620783162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620783184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620784164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620784164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620784164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620784184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620785166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3999999999999995	1715620785166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620785166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620785180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620786168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620786168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5162	1715620786168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620786190	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620787171	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620787171	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5162	1715620787171	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620787184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620788173	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620788173	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5162	1715620788173	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620788194	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620789175	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620789175	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620789175	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620789197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620790177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620790177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620790177	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620790198	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620791180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620791180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620791180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620791202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620792182	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620792182	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620792182	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620793185	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620793185	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620793185	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620799199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620799199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620799199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620800201	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620800201	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620800201	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620803226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620808238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620816255	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620819254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620820263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620824273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620830262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620830262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.518	1715620830262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620834272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620834272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5132	1715620834272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621102840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621102840	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621103842	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621103842	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.535	1715621103842	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621104844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.9	1715621104844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5357	1715621104844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621106848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621106848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5357	1715621106848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621116869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.2	1715621116869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5361	1715621116869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621118873	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621118873	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5361	1715621118873	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	110	1715621120877	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621120877	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5378000000000003	1715621120877	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621121879	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621121879	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5378000000000003	1715621121879	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621129894	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621129894	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5413	1715621129894	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621134905	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621134905	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621134905	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621286246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621289251	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621293238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621293238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621293238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621294240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621294240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621294240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621297246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621297246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621297246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621306264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620792205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620793205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620799219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620803207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620803207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5169	1715620803207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620808218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620808218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620808218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620816234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620816234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620816234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620819240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620819240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5148	1715620819240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620820242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620820242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5148	1715620820242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620824250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620824250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5165	1715620824250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620827256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620827256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166999999999997	1715620827256	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620830286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620834286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621112860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621112860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621114864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621114864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5403000000000002	1715621114864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621117892	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621119897	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621123904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621127904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621130910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621133926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621290232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621290232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621290232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621295242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621295242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621295242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621296244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621296244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621296244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621299250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621299250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621299250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621307266	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621307266	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621307266	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621320292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715621329310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621329310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5489	1715621329310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621334320	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621334320	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5495	1715621334320	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621338328	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621338328	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5526	1715621338328	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621343360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5522	1715621344342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620794187	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620794187	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5124	1715620794187	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620795189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.7	1715620795189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5133	1715620795189	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620797193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620797193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5133	1715620797193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620801203	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620801203	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5169	1715620801203	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620810222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620810222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5154	1715620810222	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	106	1715620813228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620813228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620813228	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620818238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620818238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620818238	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620829260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715620829260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.518	1715620829260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620833270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620833270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5179	1715620833270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621130896	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5413	1715621130896	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621133902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621133902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406999999999997	1715621133902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621135929	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621304260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5473000000000003	1715621304260	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621305262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621305262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621305262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621308268	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621308268	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621308268	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621309270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621309270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621309270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621313278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621313278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5455	1715621313278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621314280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621314280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5464	1715621314280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621320306	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621329324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621334342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621343340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621343340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5529	1715621343340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621345359	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621348365	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621349352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621349352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5536	1715621349352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621350374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621351356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621351356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620794208	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620795207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620797207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620801224	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620810243	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620813249	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620818259	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620829281	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620833295	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621131898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5406999999999997	1715621131898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621135907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621135907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621135907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621306264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5468	1715621306264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621310272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621310272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621310272	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621311274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621311274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5455	1715621311274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621312276	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621312276	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5455	1715621312276	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621315282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621315282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5464	1715621315282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621316284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621316284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5464	1715621316284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5478	1715621322296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621326318	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621331328	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621336344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621339330	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621339330	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5526	1715621339330	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621345344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621345344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5522	1715621345344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621346346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621346346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5522	1715621346346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621348350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621348350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5536	1715621348350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621350354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621350354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465999999999998	1715621350354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465999999999998	1715621351356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621352360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621352360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5465999999999998	1715621352360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621352374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621353362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621353362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5511	1715621353362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621353389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621354364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621354364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5511	1715621354364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621354389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621355367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620796191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715620796191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5133	1715620796191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620798195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620798195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5136999999999996	1715620798195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620800226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620802219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620806235	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620809241	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620811290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620812245	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620815246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620821262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620822267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620823268	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620825273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620828258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620828258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.518	1715620828258	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620831264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620831264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5179	1715620831264	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620832267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620832267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5179	1715620832267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620836278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620836278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5132	1715620836278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621137912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621137912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621137912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621141920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621141920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621141920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621144928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.899999999999999	1715621144928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621144928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621146932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621146932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5409	1715621146932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621150940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621150940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621150940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621151942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621151942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621151942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621154949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621154949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5433000000000003	1715621154949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621159959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621159959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621159959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621160961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621160961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621160961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621162965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621162965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5389	1715621162965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621168978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621168978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5387	1715621168978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621175992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621175992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620796207	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620798218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620802205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.7	1715620802205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5169	1715620802205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620806213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715620806213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620806213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620809220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620809220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620809220	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620811223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620811223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5154	1715620811223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620812226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620812226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5154	1715620812226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620815232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620815232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620815232	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620821244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620821244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5148	1715620821244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620822246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620822246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5165	1715620822246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620823248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620823248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5165	1715620823248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620825252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620825252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166999999999997	1715620825252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620827270	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620828279	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620831286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620832283	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620836299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621137927	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621141940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621144941	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621146946	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621150953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621151957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621154970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621159973	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621160984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621162986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621169000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621176014	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621182004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621182004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621182004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621187015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621187015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5436	1715621187015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621189019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621189019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.545	1715621189019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621191023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621191023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621191023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621194045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621197050	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621198059	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620804209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620804209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620804209	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620805211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620805211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5168000000000004	1715620805211	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620807216	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620807216	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5157	1715620807216	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715620814230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620814230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.512	1715620814230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620817236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620817236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5139	1715620817236	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620826254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620826254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5166999999999997	1715620826254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620835274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7	1715620835274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5132	1715620835274	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621138914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621138914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621138914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621139916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621139916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5381	1715621139916	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621140918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621140918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621140918	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621142924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621142924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5402	1715621142924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621145950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621152944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621152944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5433000000000003	1715621152944	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621158977	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621166987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621167989	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621170001	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621170995	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621185011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621185011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5436	1715621185011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621186028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621190035	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621206077	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621217078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621217078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621217078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621220085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621220085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621220085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621222090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621222090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.546	1715621222090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621226098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.3	1715621226098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5412	1715621226098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621229104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621229104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621229104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621237136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620804230	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620805226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620807237	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620814252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620817251	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620826278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620835295	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620837280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.300000000000001	1715620837280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620837280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620837301	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620838282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.300000000000001	1715620838282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620838282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620838295	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620839284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620839284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.517	1715620839284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620839306	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620840286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620840286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5181	1715620840286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620840301	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620841288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715620841288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5181	1715620841288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620841310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620842290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715620842290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5181	1715620842290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620842305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620843292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620843292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5194	1715620843292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620843314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620844294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620844294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5194	1715620844294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620844316	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620845297	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620845297	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5194	1715620845297	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620845311	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620846299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620846299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5209	1715620846299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620846320	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620847300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620847300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5209	1715620847300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620847314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620848302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620848302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5209	1715620848302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620848326	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620849304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620849304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.52	1715620849304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620849324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620850306	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620850306	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.52	1715620850306	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620850321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620851308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620851308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.52	1715620851308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620852310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620852310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5215	1715620852310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620854314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.7	1715620854314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5215	1715620854314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620855317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620855317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5216	1715620855317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620857321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620857321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5216	1715620857321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620858323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620858323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5189	1715620858323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620863333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620863333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620863333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620869346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620869346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5221999999999998	1715620869346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620870348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715620870348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5243	1715620870348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620875358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620875358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5253	1715620875358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620876360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620876360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620876360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620877362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620877362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620877362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620882373	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620882373	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.521	1715620882373	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620884377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620884377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.521	1715620884377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620886405	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620887399	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620891395	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620891395	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5236	1715620891395	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621138928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621139930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621140936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621145930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621145930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621145930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621149938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621149938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621149938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621152967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621166973	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621166973	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.538	1715621166973	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621167976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621167976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5387	1715621167976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621169980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621169980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620851323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620852323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620854329	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620855329	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620857334	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620858343	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620863355	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620869362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620870363	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620875373	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620876381	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620877383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620882386	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620884398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620887385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620887385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620887385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620888387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	12.1	1715620888387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620888387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620891418	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621142945	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621143947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621155950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.9	1715621155950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621155950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621156952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621156952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621156952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621157955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621157955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621157955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621158957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621158957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5345	1715621158957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621165990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621172001	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621172999	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621174009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621178017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621180022	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621181084	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621192046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621196058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621204070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621212091	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621215096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621221109	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621224113	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621228115	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621232123	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621233133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621238144	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621239138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621244155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621249166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621250167	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621251170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621311287	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621312295	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621315305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621316297	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621324300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621324300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621324300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620853312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620853312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5215	1715620853312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620859346	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620864359	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620868344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.799999999999999	1715620868344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5221999999999998	1715620868344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620892397	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620892397	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5236	1715620892397	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620893399	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620893399	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5236	1715620893399	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620894401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620894401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620894401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621143926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621143926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5416	1715621143926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621149960	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621155965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621156967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621157977	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621165971	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621165971	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.538	1715621165971	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621171984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621171984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621171984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621172986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621172986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621172986	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621173988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621173988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621173988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621177996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621177996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621177996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621180000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621180000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621180000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621181002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621181002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621181002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621192025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621192025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621192025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621196034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621196034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621196034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621204051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621204051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5397	1715621204051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621212068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.6	1715621212068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425	1715621212068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621215074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621215074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5425999999999997	1715621215074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621221087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621221087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.546	1715621221087	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621224094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620853327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620862331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620862331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620862331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620865338	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620865338	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620865338	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620866340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620866340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620866340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620867355	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620871374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620881371	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.8	1715620881371	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620881371	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620886383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620886383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620886383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620889410	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621147934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621147934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5409	1715621147934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621148936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621148936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5409	1715621148936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621153947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621153947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5433000000000003	1715621153947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621161963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621161963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5389	1715621161963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621163967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621163967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5389	1715621163967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621164969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621164969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.538	1715621164969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621174990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621174990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621174990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621178998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621178998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621178998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	109	1715621183006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621183006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5431	1715621183006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621184008	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621184008	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5431	1715621184008	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621185032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621188035	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621193028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621193028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5459	1715621193028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621195032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621195032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621195032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621201045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621201045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621201045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621202047	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621202047	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621202047	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621208060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620856319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620856319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5216	1715620856319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620860341	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620861350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620872352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620872352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5243	1715620872352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620873354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620873354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5253	1715620873354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620874356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620874356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5253	1715620874356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620878364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620878364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5248000000000004	1715620878364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620879387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620880382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620883397	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620885391	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620890405	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620895421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620896427	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621147956	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621148957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621153968	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621161977	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621163990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621164991	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621175011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621179019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621183028	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621184031	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621188017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621188017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.545	1715621188017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621191043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621193041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621195052	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621201069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621202070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621208073	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621210085	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621211088	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621213093	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621214095	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621216098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621218094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621223108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621225117	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621231132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621234137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621235139	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621236142	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621242144	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621247155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621248164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621252166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621256182	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621324323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621330327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621333339	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621337326	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621337326	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620856341	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620862345	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620865350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620867342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715620867342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5221999999999998	1715620867342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620871350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620871350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5243	1715620871350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620879367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.5	1715620879367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620879367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620881394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620889389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620889389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620889389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620894422	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5387	1715621169980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621170982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621170982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5427	1715621170982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621177008	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621186013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621186013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5436	1715621186013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621190021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621190021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.545	1715621190021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621206056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621206056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5395	1715621206056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621207079	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621217099	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621220099	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621222103	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621226119	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621229131	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621241128	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621241128	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621241128	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621243132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621243132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.547	1715621243132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621245136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621245136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5431999999999997	1715621245136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621246138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621246138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5431999999999997	1715621246138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621255157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621255157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621255157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5498000000000003	1715621327305	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621328307	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621328307	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5498000000000003	1715621328307	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621332316	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621332316	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5495	1715621332316	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621335345	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621341349	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621346368	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621347369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621351377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620859325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.1	1715620859325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5189	1715620859325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620864336	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.799999999999999	1715620864336	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620864336	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620866353	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620888409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620892410	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620893421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5398	1715621175992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621176994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621176994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5401	1715621176994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621182026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621187039	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621189040	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621194030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621194030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621194030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621197036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621197036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621197036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621198038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.899999999999999	1715621198038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621198038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621199041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621199041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5449	1715621199041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621200043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715621200043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.542	1715621200043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621203049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621203049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5397	1715621203049	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621205053	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715621205053	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5397	1715621205053	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621207058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621207058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5395	1715621207058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621209083	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621219106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621227121	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621230127	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621240126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621240126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5479000000000003	1715621240126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621253152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621253152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621253152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621254155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.7	1715621254155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5452	1715621254155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621327320	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621328324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621332337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621341335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621341335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5529	1715621341335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621347348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621347348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5536	1715621347348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621349366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620860327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620860327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5189	1715620860327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620861329	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620861329	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620861329	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620868358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620872365	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620873375	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620874377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715620878389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715620880369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.4	1715620880369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5206999999999997	1715620880369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620883375	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.199999999999999	1715620883375	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.521	1715620883375	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715620885379	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620885379	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620885379	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715620890392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.1	1715620890392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.522	1715620890392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715620895404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.4	1715620895404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620895404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715620896406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.199999999999999	1715620896406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5256	1715620896406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621199061	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621200064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621203064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621205067	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621209062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.3	1715621209062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5438	1715621209062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621219082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.3	1715621219082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621219082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621227100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621227100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5444	1715621227100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621230106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621230106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5435	1715621230106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621237121	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621237121	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5474	1715621237121	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621240150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621253173	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621254167	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621330312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621330312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5489	1715621330312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621333318	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621333318	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5495	1715621333318	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621335322	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.7	1715621335322	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621335322	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621337340	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621340354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621342352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621344364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621355367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5511	1715621355367	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621356369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621356369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5530999999999997	1715621356369	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621357370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621357370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5530999999999997	1715621357370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621358372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621358372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5530999999999997	1715621358372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621366387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.5	1715621366387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.558	1715621366387	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621370409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621372414	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621373416	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621797296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621797296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5783	1715621797296	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621799300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621799300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5783	1715621799300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621806317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621806317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621806317	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621811327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621811327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621811327	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621814335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621814335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621814335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621816339	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621816339	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621816339	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621817341	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621817341	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621817341	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621823376	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621830381	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621840390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621840390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5833000000000004	1715621840390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621355388	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621356383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621357386	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621358399	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621370396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.100000000000001	1715621370396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5582	1715621370396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621372400	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621372400	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5562	1715621372400	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621373402	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621373402	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5562	1715621373402	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621797312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621799313	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621806339	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621811343	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621814348	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621816360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621823354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621823354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5775	1715621823354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621830368	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621830368	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5826	1715621830368	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621837401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621840412	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621359374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621359374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5538000000000003	1715621359374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621361378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621361378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5538000000000003	1715621361378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621365385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621365385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.558	1715621365385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621368392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621368392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5582	1715621368392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621371398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621371398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5562	1715621371398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621374418	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621375420	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621798298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621798298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5783	1715621798298	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621800302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621800302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621800302	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621802308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621802308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621802308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621803324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621808321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621808321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621808321	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621817356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621818356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621821370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621831370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621831370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5826	1715621831370	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621838386	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621838386	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5813	1715621838386	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621359396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621361400	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621365408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621368406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621374404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621374404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5505999999999998	1715621374404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621375406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621375406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5505999999999998	1715621375406	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621798319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621800324	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621803310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621803310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761999999999996	1715621803310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621805314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621805314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761999999999996	1715621805314	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621808342	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621818343	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621818343	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5798	1715621818343	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621821350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621821350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5775	1715621821350	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621829366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.7	1715621829366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621829366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621831391	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621838408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621360376	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621360376	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5538000000000003	1715621360376	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621364383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621364383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621364383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621367404	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621369408	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621376434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621801304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621801304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621801304	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621802326	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621807319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.799999999999999	1715621807319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621807319	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621809323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621809323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621809323	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621810325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621810325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621810325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621820347	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621820347	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5798	1715621820347	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621822352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621822352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5775	1715621822352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621824377	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621826382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621829379	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621836396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621839388	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621839388	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5833000000000004	1715621839388	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621842394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621842394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5838	1715621842394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621360389	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621367390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621367390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.558	1715621367390	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621369394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621369394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5582	1715621369394	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621371414	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621801325	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621804335	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621807333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621809344	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621810338	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621820363	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621824356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621824356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5789	1715621824356	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621826360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621826360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5789	1715621826360	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621827383	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621836382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.7	1715621836382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5813	1715621836382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621837384	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621837384	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5813	1715621837384	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621839401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621842407	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621362380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621362380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621362380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621363382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621363382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621363382	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621364403	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621376409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621376409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5505999999999998	1715621376409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621804312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	13.1	1715621804312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761999999999996	1715621804312	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621812331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621812331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621812331	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621813333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621813333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.58	1715621813333	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621815337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621815337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621815337	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621819345	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.8	1715621819345	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5798	1715621819345	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621822366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621825379	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621828364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621828364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621828364	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621832372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621832372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5826	1715621832372	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621833374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621833374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5801999999999996	1715621833374	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621834378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621834378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5801999999999996	1715621834378	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621835380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621835380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5801999999999996	1715621835380	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621841392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621841392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5833000000000004	1715621841392	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621843396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621843396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5838	1715621843396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621362398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621363396	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621366401	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621377411	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621377411	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.554	1715621377411	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621377437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621378413	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.2	1715621378413	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.554	1715621378413	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621378428	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621379415	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621379415	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.554	1715621379415	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621379429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621380417	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621380417	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5555	1715621380417	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621380432	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621381419	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621381419	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5555	1715621381419	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621381433	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621382421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621382421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5555	1715621382421	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621382436	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621383423	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621383423	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5543	1715621383423	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621383439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621384425	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621384425	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5543	1715621384425	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621384441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621385427	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621385427	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5543	1715621385427	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621385443	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621386429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621386429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621386429	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621386442	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621387432	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621387432	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621387432	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621387445	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621388434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621388434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621388434	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621388449	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621389437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621389437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621389437	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621389459	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621390439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621390439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621390439	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621390456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621391441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621391441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621391441	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621391462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621392444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621392444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5542	1715621392444	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621394448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621394448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5542	1715621394448	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621395450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621395450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5513000000000003	1715621395450	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621399458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621399458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5549	1715621399458	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621402464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621402464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5558	1715621402464	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621403468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621403468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5558	1715621403468	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621408479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621408479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5561	1715621408479	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621418500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621418500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621418500	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621421507	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621421507	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5574	1715621421507	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621423511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621423511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5551999999999997	1715621423511	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621424529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621426539	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621429539	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621431551	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621433532	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621433532	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5578000000000003	1715621433532	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621437540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621437540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576	1715621437540	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621442550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621442550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5488000000000004	1715621442550	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621443553	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621443553	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5493	1715621443553	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621446559	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621446559	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5509	1715621446559	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621450568	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621450568	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621450568	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621456580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621456580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.556	1715621456580	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621460589	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621460589	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5570999999999997	1715621460589	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621464596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621464596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5566	1715621464596	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621465598	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621465598	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5566	1715621465598	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621474616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621392463	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621394463	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621395470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621399480	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621402478	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621405493	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621408501	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621419502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621419502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5574	1715621419502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621421529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621423526	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621425536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621429523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621429523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621429523	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621431528	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621431528	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5578000000000003	1715621431528	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621432543	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621433552	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621437560	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621442571	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621443569	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621446576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621450584	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621456601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621460611	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621464617	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621465619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621475619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621475619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5593000000000004	1715621475619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621476621	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621476621	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621476621	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621477623	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621477623	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621477623	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621479629	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621479629	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5596	1715621479629	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621480631	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621480631	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5596	1715621480631	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621481633	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621481633	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5596	1715621481633	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621482635	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621482635	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621482635	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621486643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621486643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621486643	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621487645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621487645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621487645	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621493678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621805336	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621812352	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621813354	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621815357	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621819366	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621825358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621825358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621393446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621393446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5542	1715621393446	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621396452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621396452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5513000000000003	1715621396452	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621398456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621398456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5549	1715621398456	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621404485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621406474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621406474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621406474	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621407477	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.100000000000001	1715621407477	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5561	1715621407477	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621409481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621409481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5561	1715621409481	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621411485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715621411485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5572	1715621411485	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621412487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	9.899999999999999	1715621412487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5572	1715621412487	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621414492	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621414492	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585999999999998	1715621414492	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621424513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621424513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5551999999999997	1715621424513	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621430546	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621434534	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621434534	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5583	1715621434534	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621436538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621436538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5583	1715621436538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621439561	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621440570	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621444576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621445579	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621452572	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.700000000000001	1715621452572	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621452572	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621457583	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621457583	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.556	1715621457583	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621461608	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621462605	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621468626	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621469619	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621470622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621473628	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621478648	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621493658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621493658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5548	1715621493658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5789	1715621825358	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621827362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621827362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5795	1715621827362	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621828385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621832385	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621393460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621396466	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621404470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621404470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621404470	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621405472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621405472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621405472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621406488	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621407496	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621409494	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621411506	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621412502	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621414506	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621430525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621430525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621430525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621432530	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621432530	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5578000000000003	1715621432530	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621434554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621439544	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621439544	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576	1715621439544	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621440546	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621440546	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5488000000000004	1715621440546	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621444554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621444554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5493	1715621444554	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621445557	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621445557	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5493	1715621445557	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621447582	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621452587	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621461590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621461590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621461590	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621462592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621462592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621462592	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621468604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621468604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621468604	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621469606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621469606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621469606	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621470609	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621470609	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5575	1715621470609	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621473614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621473614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5593000000000004	1715621473614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621478625	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621478625	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621478625	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621488668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621496681	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621833395	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621834398	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621835402	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621841413	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621843409	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621397454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621397454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5513000000000003	1715621397454	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621398476	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621400473	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621401483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621410483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621410483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5572	1715621410483	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621415494	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621415494	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585999999999998	1715621415494	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621416496	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621416496	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621416496	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621418521	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621420525	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621422529	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621427519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621427519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5573	1715621427519	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621436558	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621441563	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621448563	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.100000000000001	1715621448563	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5509	1715621448563	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621451570	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621451570	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621451570	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621453574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621453574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621453574	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621454576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621454576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5554	1715621454576	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621458585	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621458585	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5570999999999997	1715621458585	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621459587	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621459587	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5570999999999997	1715621459587	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621463594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621463594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5557	1715621463594	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621466600	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621466600	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5566	1715621466600	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621471610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621471610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5575	1715621471610	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621472612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621472612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5575	1715621472612	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621483637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621483637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621483637	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621484639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621484639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621484639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621488647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.1	1715621488647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5535	1715621488647	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621489670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621490677	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621397472	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621400460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621400460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5549	1715621400460	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621401462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621401462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5558	1715621401462	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621403482	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621410508	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621415515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621416516	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621420504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621420504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5574	1715621420504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621422509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621422509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5551999999999997	1715621422509	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621426517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621426517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5573	1715621426517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621427533	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621441548	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621441548	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5488000000000004	1715621441548	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621447561	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.5	1715621447561	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5509	1715621447561	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621448578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621451586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621453597	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621454597	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621458599	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621459601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621463614	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621466613	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621471623	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621472636	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621483658	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621484660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621489649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.800000000000001	1715621489649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5535	1715621489649	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621490651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621490651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5535	1715621490651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621491654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621491654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5548	1715621491654	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621492656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621492656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5548	1715621492656	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621494660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621494660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5599000000000003	1715621494660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621495662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.100000000000001	1715621495662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5599000000000003	1715621495662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621496664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621496664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5599000000000003	1715621496664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621413490	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.5	1715621413490	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585999999999998	1715621413490	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621417498	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621417498	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621417498	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621419524	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621428521	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621428521	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5579	1715621428521	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621435536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.200000000000001	1715621435536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5583	1715621435536	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621438542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621438542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576	1715621438542	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621449566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621449566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5545999999999998	1715621449566	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621455578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621455578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.556	1715621455578	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621457597	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621467622	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621485641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621485641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5525	1715621485641	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621413504	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621417517	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621425515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621425515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5573	1715621425515	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621428538	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621435557	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621438555	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621449586	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621455601	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621467602	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.100000000000001	1715621467602	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5576999999999996	1715621467602	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621474630	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621485662	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621474616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5593000000000004	1715621474616	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621475639	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621476634	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621477636	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621479650	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621480651	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621481646	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621482648	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621486664	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621487660	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621491678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621492670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621494680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621495683	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621497666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621497666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606999999999998	1715621497666	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621497687	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621498668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621498668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606999999999998	1715621498668	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621498689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621499670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.800000000000001	1715621499670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606999999999998	1715621499670	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621499693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621500672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621500672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585	1715621500672	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621500693	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621501674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621501674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585	1715621501674	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621501696	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621502676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.299999999999999	1715621502676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5585	1715621502676	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621502690	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621503678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621503678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621503678	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621503702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621504680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621504680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621504680	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621504699	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621505682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621505682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621505682	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621505704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621506685	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621506685	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621506685	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621506706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621507687	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621507687	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621507687	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621507700	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621508689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621508689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5547	1715621508689	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621508709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621509691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621509691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5581	1715621509691	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621509712	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621510692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621510692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5581	1715621510692	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621510713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621511694	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621511694	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5581	1715621511694	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621511708	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621512696	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621512696	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5588	1715621512696	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621516704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621516704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621516704	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621518709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621518709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5622	1715621518709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621520734	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621524741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621527748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621528749	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621567810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621567810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5686	1715621567810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621573845	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621580861	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621582859	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621587878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621595896	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621597898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621603887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621603887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621603887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621604889	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621604889	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621604889	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621611904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.3	1715621611904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5656999999999996	1715621611904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621612906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621612906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5656999999999996	1715621612906	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621613908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621613908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5656999999999996	1715621613908	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621616914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.3	1715621616914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621616914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621512709	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621516728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621520713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621520713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5622	1715621520713	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621524720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621524720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5603000000000002	1715621524720	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621527726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621527726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5604	1715621527726	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621528728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621528728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5604	1715621528728	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621557813	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621573822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621573822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621573822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621580839	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.2	1715621580839	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621580839	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621582844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.4	1715621582844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5694	1715621582844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621587854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621587854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621587854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621595870	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621595870	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.566	1715621595870	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621597874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621597874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5653	1715621597874	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621602905	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621603907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621604904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621611920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621612927	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621613922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621616928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621513698	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621513698	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5588	1715621513698	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621519725	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621525743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621531748	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621534754	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621543784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621546788	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621547784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621548792	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621549794	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621554798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621561798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.3	1715621561798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621561798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621562800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.3	1715621562800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621562800	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621563802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621563802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5693	1715621563802	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621568833	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621569830	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621570837	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621572842	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621574838	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621578854	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621579849	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621581862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	9	1715621584848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10	1715621584848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5707	1715621584848	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621586852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621586852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5707	1715621586852	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621590860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621590860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621590860	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621592864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621592864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621592864	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621593866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621593866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.566	1715621593866	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621594868	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621594868	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.566	1715621594868	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621596872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621596872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5653	1715621596872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621599878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621599878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5638	1715621599878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621600880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.3	1715621600880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5638	1715621600880	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621601882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621601882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5638	1715621601882	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621609900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621609900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5616999999999996	1715621609900	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621614910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621513712	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621525722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.2	1715621525722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5603000000000002	1715621525722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621531735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621531735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5615	1715621531735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621534741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621534741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5609	1715621534741	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621543761	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621543761	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5654	1715621543761	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621546767	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621546767	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621546767	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621547769	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621547769	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621547769	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621548772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621548772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5634	1715621548772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621549773	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621549773	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5634	1715621549773	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621554784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621554784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671	1715621554784	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621557790	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621557790	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5675	1715621557790	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621561812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621562822	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621568812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.3	1715621568812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5686	1715621568812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621569814	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.299999999999999	1715621569814	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621569814	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621570816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621570816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621570816	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621572820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621572820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621572820	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621574824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621574824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621574824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621578834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621578834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621578834	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621579836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621579836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621579836	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621581841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621581841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5694	1715621581841	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621583872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621584869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621586869	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621590873	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621592884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621593886	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621594881	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621514700	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621514700	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5588	1715621514700	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621515702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621515702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621515702	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621518722	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621521715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.5	1715621521715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5608	1715621521715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621522716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621522716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5608	1715621522716	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621523718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.299999999999999	1715621523718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5608	1715621523718	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621530733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621530733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5615	1715621530733	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621532737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621532737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5615	1715621532737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621535743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621535743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5609	1715621535743	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621536745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621536745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621536745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621537747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621537747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621537747	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621541757	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.6	1715621541757	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5674	1715621541757	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621542759	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621542759	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5654	1715621542759	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621544763	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621544763	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5654	1715621544763	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621545778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621551798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621552794	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621553803	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621555806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621565827	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621571832	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621575839	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621576851	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621577844	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621585871	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621589872	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621591877	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621598890	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621605891	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621605891	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621605891	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621607895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621607895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621607895	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621608898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621608898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5616999999999996	1715621608898	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621514714	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621515715	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621519711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8999999999999995	1715621519711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5622	1715621519711	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621521735	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621522729	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621523739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621530745	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621532757	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621535763	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621536759	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621537770	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621541771	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621542779	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	52	1715621545765	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621545765	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621545765	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621551778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621551778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5659	1715621551778	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621552780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.3	1715621552780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5659	1715621552780	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621553782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621553782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5659	1715621553782	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621555786	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621555786	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671	1715621555786	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621565806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621565806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5693	1715621565806	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621571818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621571818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621571818	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621575826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.4	1715621575826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621575826	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621576828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621576828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621576828	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621577831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621577831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621577831	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621585850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.2	1715621585850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5707	1715621585850	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621589858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621589858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621589858	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621591862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621591862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5642	1715621591862	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621598876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621598876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5653	1715621598876	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621602884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621602884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5661	1715621602884	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621605914	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621607915	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621608920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621517706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621517706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.561	1715621517706	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621526724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.299999999999999	1715621526724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5603000000000002	1715621526724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621529731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621529731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5604	1715621529731	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621533739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621533739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5609	1715621533739	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621538751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621538751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621538751	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621539753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621539753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5674	1715621539753	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621540755	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.6	1715621540755	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5674	1715621540755	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621544779	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621550798	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621556801	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621558812	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621559815	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621560810	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621564804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.6	1715621564804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5693	1715621564804	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621566808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.3	1715621566808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5686	1715621566808	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621567823	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621588856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.5	1715621588856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5606	1715621588856	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621606893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621606893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621606893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621610902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621610902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5616999999999996	1715621610902	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621517724	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621526737	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621529744	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621533761	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621538772	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621539773	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621540775	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	1	1715621550776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621550776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5634	1715621550776	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621556788	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715621556788	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671	1715621556788	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	4	1715621558792	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	4.3	1715621558792	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5675	1715621558792	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621559794	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	2.6	1715621559794	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5675	1715621559794	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	3	1715621560796	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.699999999999999	1715621560796	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621560796	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621563824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621564817	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621566824	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	2	1715621583846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5	1715621583846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5694	1715621583846	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621588878	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621606907	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621610923	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621596887	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621599893	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621600901	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621601904	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621609921	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621614931	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621615933	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621614910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621614910	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621615912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621615912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621615912	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621617917	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621617917	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621617917	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621617941	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621618919	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621618919	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621618919	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621618942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621619920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621619920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5648	1715621619920	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621619943	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621620922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621620922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5665	1715621620922	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621620942	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621621924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621621924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5665	1715621621924	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621621938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621622926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621622926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5665	1715621622926	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621622946	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621623928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621623928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621623928	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621623948	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621624930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621624930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621624930	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621624952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621625932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621625932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621625932	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621625953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621626934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621626934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621626934	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621626948	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621627936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621627936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621627936	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621627950	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621628938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621628938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5677	1715621628938	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621628952	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621629940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621629940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621629940	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621629961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621630943	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621630943	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621630943	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621630964	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621631945	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.299999999999999	1715621631945	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621631945	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621631958	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621636972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621639961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621639961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5703	1715621639961	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621641965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621641965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5684	1715621641965	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621643990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621649002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621653990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621653990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.565	1715621653990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621655994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621655994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.565	1715621655994	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621659000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621659000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671999999999997	1715621659000	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621661004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621661004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.568	1715621661004	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621662006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621662006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.568	1715621662006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621665013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621665013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621665013	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621666015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621666015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621666015	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621671025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621671025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621671025	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621672027	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621672027	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621672027	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621673051	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621674053	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621676060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621690088	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621692083	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621697080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621697080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5708	1715621697080	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621700086	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621700086	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5721	1715621700086	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621704094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621704094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5759000000000003	1715621704094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621705096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621705096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5759000000000003	1715621705096	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621706098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621706098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5759000000000003	1715621706098	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621707100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621707100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621707100	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621724138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621724138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621724138	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621726143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621632947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621632947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5678	1715621632947	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621637957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621637957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621637957	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621641979	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621644996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621645987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621647991	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621672045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621678055	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621679067	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621681069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621685070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621688078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621689078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621694095	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621695091	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621698105	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621701102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621717141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621718147	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621719148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621722155	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621723157	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621733186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621734183	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621739172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621739172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.579	1715621739172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621741176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621741176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5730999999999997	1715621741176	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621752218	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621753225	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621757233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621759237	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621765243	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621766252	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621767255	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621774269	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621779280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621784269	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621784269	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5724	1715621784269	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621632967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621637979	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621644972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621644972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5690999999999997	1715621644972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621645974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621645974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5690999999999997	1715621645974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621647978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621647978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5699	1715621647978	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621650008	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621678041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621678041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621678041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621679043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621679043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621679043	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621681048	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621681048	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5743	1715621681048	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621685056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621685056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5755	1715621685056	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621688062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621688062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621688062	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621689064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621689064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621689064	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621694074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621694074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5765	1715621694074	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621695076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621695076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5708	1715621695076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621698082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621698082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5721	1715621698082	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621701089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621701089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5739	1715621701089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621717122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621717122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621717122	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621718124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621718124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621718124	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621719126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621719126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5733	1715621719126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621722134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621722134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621722134	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621723136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621723136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621723136	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621733160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621733160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621733160	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621734162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621734162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621734162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621737184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621633949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621633949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5678	1715621633949	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621634951	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621634951	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5678	1715621634951	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621635953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621635953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621635953	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621646976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621646976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5690999999999997	1715621646976	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621651987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.299999999999999	1715621651987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.57	1715621651987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621657998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621657998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671999999999997	1715621657998	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621660002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621660002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.568	1715621660002	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621663009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621663009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5681	1715621663009	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621664011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621664011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5681	1715621664011	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621668019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621668019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5669	1715621668019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621670023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621670023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5669	1715621670023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621675034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621675034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621675034	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621683052	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621683052	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5755	1715621683052	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621686058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621686058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621686058	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621693072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621693072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5765	1715621693072	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621699084	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621699084	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5721	1715621699084	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621702090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621702090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5739	1715621702090	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621703092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621703092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5739	1715621703092	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621708102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.3	1715621708102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621708102	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621715118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621715118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621715118	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621721132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621721132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5733	1715621721132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621727145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621633969	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621634972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621635974	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621646990	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621651999	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621658022	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621660023	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621663029	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621664032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621668040	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621670046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621675047	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621683068	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621686071	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621693093	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621699105	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621702103	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621703113	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621708116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621715133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621721152	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621727161	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621728171	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621729172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621735179	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621740188	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621745199	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621750213	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621751226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621761234	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621768255	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621781278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621782286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621785297	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621791308	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621636955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621636955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621636955	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621638972	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621639987	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621643970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.299999999999999	1715621643970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5684	1715621643970	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621648980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621648980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5699	1715621648980	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621649982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621649982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5699	1715621649982	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621654017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621656006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621659017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621661026	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621662019	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621665027	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621666038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621671046	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621673029	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621673029	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5682	1715621673029	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621674032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.299999999999999	1715621674032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621674032	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621676036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621676036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5663	1715621676036	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621690066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621690066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621690066	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621692070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621692070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5765	1715621692070	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621696078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621696078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5708	1715621696078	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621697094	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621700107	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621704116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621705109	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621706121	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621707113	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621724162	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621726158	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621732172	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621736191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621742178	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621742178	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5730999999999997	1715621742178	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621743180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621743180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621743180	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621744184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621744184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621744184	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621747190	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621747190	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5754	1715621747190	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621752202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621752202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621638959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.6	1715621638959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5703	1715621638959	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621640985	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621642988	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621651006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621653010	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621655006	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621657010	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621667030	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621669041	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621677050	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621680069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621682063	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621684076	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621687073	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621691089	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621709104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621709104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621709104	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621710106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621710106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715621710106	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621711108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621711108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715621711108	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621712110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621712110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.573	1715621712110	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	105	1715621713112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621713112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621713112	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621714116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621714116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621714116	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621716120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621716120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5742	1715621716120	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621720129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621720129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5733	1715621720129	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621725141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621725141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5751999999999997	1715621725141	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621730153	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621730153	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621730153	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621731156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621731156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621731156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621738170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621738170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.579	1715621738170	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621746188	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621746188	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5754	1715621746188	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621748193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621748193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5754	1715621748193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621749195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621749195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621749195	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621754206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621754206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621640963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621640963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5703	1715621640963	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621642967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621642967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5684	1715621642967	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621650984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621650984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.57	1715621650984	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621652989	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621652989	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.57	1715621652989	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621654992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621654992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.565	1715621654992	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621656996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621656996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5671999999999997	1715621656996	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621667017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621667017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5676	1715621667017	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621669021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621669021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5669	1715621669021	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621677038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621677038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5714	1715621677038	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621680045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621680045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5743	1715621680045	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621682050	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621682050	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5743	1715621682050	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621684054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.4	1715621684054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5755	1715621684054	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621687060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621687060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621687060	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621691069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621691069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621691069	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621696103	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621709126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621710119	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621711132	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621712126	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621713133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621714137	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621716133	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621720151	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621725156	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621730174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621731169	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621738193	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621746205	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621748206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621749216	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621754226	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621756210	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621756210	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621756210	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621762223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621762223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621726143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5751999999999997	1715621726143	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621732158	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621732158	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621732158	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621736166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621736166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621736166	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621737168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621737168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.579	1715621737168	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621742191	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621743202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621744206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621747204	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621755231	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621758229	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621760233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621763240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621770253	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621771262	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621773266	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621775271	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621777277	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621783267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621783267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5724	1715621783267	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621788279	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621788279	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621788279	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621789280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621789280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621789280	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621793288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621793288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621793288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621794290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621794290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5772	1715621794290	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621796294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621796294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5772	1715621796294	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621727145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5751999999999997	1715621727145	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621728148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621728148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621728148	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621729150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621729150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5761	1715621729150	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621735164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.699999999999999	1715621735164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621735164	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621740174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621740174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5730999999999997	1715621740174	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621745186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6	1715621745186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5748	1715621745186	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621750197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621750197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621750197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621751200	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621751200	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5741	1715621751200	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	99	1715621761221	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621761221	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5715	1715621761221	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621768235	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621768235	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5749	1715621768235	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621776253	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621776253	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5774	1715621776253	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621782265	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621782265	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5724	1715621782265	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621785273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621785273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621785273	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621791284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621791284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621791284	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621739194	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621741197	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621753204	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8	1715621753204	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621753204	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621757212	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.4	1715621757212	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621757212	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621759217	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621759217	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621759217	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621765229	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621765229	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5734	1715621765229	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621766231	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621766231	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5734	1715621766231	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621767233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621767233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5749	1715621767233	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621774248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621774248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621774248	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621779259	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.399999999999999	1715621779259	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.577	1715621779259	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621781263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.8	1715621781263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.577	1715621781263	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621784289	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621752202	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621758215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621758215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621758215	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	101	1715621760219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621760219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5769	1715621760219	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621763225	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621763225	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5715	1715621763225	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621770240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621770240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621770240	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621771242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621771242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621771242	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621773246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621773246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621773246	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	100	1715621775250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621775250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5791999999999997	1715621775250	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621777254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	6.1	1715621777254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5774	1715621777254	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621780283	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621783288	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621788299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621789300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621793310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621794310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621796307	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621754206	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621755208	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.699999999999999	1715621755208	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621755208	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621756225	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621762241	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621764249	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621769259	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621772257	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621778257	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.5	1715621778257	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5774	1715621778257	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621780261	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.9	1715621780261	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.577	1715621780261	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621786299	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621787291	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621790303	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621792300	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621795310	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5715	1715621762223	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621764227	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621764227	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5734	1715621764227	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621769237	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621769237	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5749	1715621769237	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621772244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621772244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621772244	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621776266	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Swap Memory GB	0.086	1715621778278	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621786275	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	7.8	1715621786275	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621786275	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	103	1715621787277	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.5	1715621787277	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5758	1715621787277	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	106	1715621790282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	10.399999999999999	1715621790282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.576	1715621790282	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	102	1715621792286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	5.9	1715621792286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5766999999999998	1715621792286	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - CPU Utilization	104	1715621795292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Utilization	8.1	1715621795292	03d70a076ab147e49dbeed88cf991f29	0	f
TOP - Memory Usage GB	2.5772	1715621795292	03d70a076ab147e49dbeed88cf991f29	0	f
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
letter	0	03d70a076ab147e49dbeed88cf991f29
workload	0	03d70a076ab147e49dbeed88cf991f29
listeners	smi+top+dcgmi	03d70a076ab147e49dbeed88cf991f29
params	'"-"'	03d70a076ab147e49dbeed88cf991f29
file	cifar10.py	03d70a076ab147e49dbeed88cf991f29
workload_listener	''	03d70a076ab147e49dbeed88cf991f29
model	cifar10.py	03d70a076ab147e49dbeed88cf991f29
manual	False	03d70a076ab147e49dbeed88cf991f29
max_epoch	5	03d70a076ab147e49dbeed88cf991f29
max_time	172800	03d70a076ab147e49dbeed88cf991f29
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
03d70a076ab147e49dbeed88cf991f29	(0 0) capable-hound-471	UNKNOWN			daga	FINISHED	1715620530307	1715621845264		active	s3://mlflow-storage/0/03d70a076ab147e49dbeed88cf991f29/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	03d70a076ab147e49dbeed88cf991f29
mlflow.source.name	file:///home/daga/radt#examples/pytorch	03d70a076ab147e49dbeed88cf991f29
mlflow.source.type	PROJECT	03d70a076ab147e49dbeed88cf991f29
mlflow.project.entryPoint	main	03d70a076ab147e49dbeed88cf991f29
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	03d70a076ab147e49dbeed88cf991f29
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	03d70a076ab147e49dbeed88cf991f29
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	03d70a076ab147e49dbeed88cf991f29
mlflow.project.env	conda	03d70a076ab147e49dbeed88cf991f29
mlflow.project.backend	local	03d70a076ab147e49dbeed88cf991f29
mlflow.runName	(0 0) capable-hound-471	03d70a076ab147e49dbeed88cf991f29
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

