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
0	Default	s3://mlflow-storage/0	active	1716140039156	1716140039156
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
SMI - Power Draw	15.09	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
SMI - Timestamp	1716140241.48	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
SMI - GPU Util	0	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
SMI - Mem Util	0	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
SMI - Mem Used	0	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
SMI - Performance State	0	1716140241494	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
TOP - Memory Usage GB	2.1564	1716142902647	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
TOP - Memory Utilization	9.299999999999999	1716142902647	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
TOP - Swap Memory GB	0	1716142902668	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
TOP - CPU Utilization	103	1716142902647	0	f	e54de1fdd68b4cb59d8a82a35ff8d33e
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.09	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
SMI - Timestamp	1716140241.48	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
SMI - GPU Util	0	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
SMI - Mem Util	0	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
SMI - Mem Used	0	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
SMI - Performance State	0	1716140241494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	0	1716140241559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	0	1716140241559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.2438	1716140241559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140241574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	153.3	1716140242561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.8	1716140242561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.2438	1716140242561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140242575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140243563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.5	1716140243563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.2438	1716140243563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140243578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140244565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716140244565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4744000000000002	1716140244565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140244586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140245567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.5	1716140245567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4744000000000002	1716140245567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140245582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140246569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716140246569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4744000000000002	1716140246569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140246582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140247571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.5	1716140247571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140247571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140247591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140248572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.5	1716140248572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140248572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140248594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140249574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716140249574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140249574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140249588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140250575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.5	1716140250575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4755	1716140250575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140250589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140251577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140251577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4755	1716140251577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140251592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140252579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	2.6	1716140252579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4755	1716140252579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140252601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716140253581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140253581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140253581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140253602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140254583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140254583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140254583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140254603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140255585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140255585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140255585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140255606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140256601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140257611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140258612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140259614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140260616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140261618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140262620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140263621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140264623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140265625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140266627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140267629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140268631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140269634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140570186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140570186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140570186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140571188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140571188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140571188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140572190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140572190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140572190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140573191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140573191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140573191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140574193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140574193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9457	1716140574193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140575195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140575195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9457	1716140575195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140576197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140576197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9457	1716140576197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140577199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140577199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9453	1716140577199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140578201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140578201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9453	1716140578201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140579202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140579202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9453	1716140579202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140580204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140580204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9456	1716140580204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140581206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140581206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9456	1716140581206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140582208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140582208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9456	1716140582208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140583210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140583210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140583210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140584212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140584212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140584212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140585214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140585214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140585214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140586216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140256587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140256587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4746	1716140256587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140257589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140257589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4746	1716140257589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140258591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140258591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4746	1716140258591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140259593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140259593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4745	1716140259593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140260595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140260595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4745	1716140260595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140261597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140261597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4745	1716140261597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140262599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140262599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140262599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140263600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140263600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140263600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140264602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140264602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140264602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140265604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140265604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4747000000000001	1716140265604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140266606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140266606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4747000000000001	1716140266606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140267608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140267608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4747000000000001	1716140267608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140268611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140268611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4750999999999999	1716140268611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140269613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140269613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4750999999999999	1716140269613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140270614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140270614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4750999999999999	1716140270614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140270635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140271617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140271617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4742	1716140271617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140271630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140272619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140272619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4742	1716140272619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140272639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140273620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140273620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4742	1716140273620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140273634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140274622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140274622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140274622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140274644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140275624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140275624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140275624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140276626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140276626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.475	1716140276626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140277628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140277628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140277628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140278630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140278630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140278630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140279632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140279632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.4754	1716140279632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140280634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140280634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.7771	1716140280634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140281636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140281636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.7771	1716140281636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140282638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140282638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.7771	1716140282638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140283640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140283640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9925	1716140283640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140284642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140284642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9925	1716140284642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140285644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140285644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9925	1716140285644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140286646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140286646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716140286646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140287647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140287647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716140287647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140288650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140288650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716140288650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140289653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140289653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716140289653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140290654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140290654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716140290654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140291656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140291656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716140291656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140292658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140292658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0017	1716140292658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140293660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140293660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0017	1716140293660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140294661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140294661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0017	1716140294661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140295663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140295663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0033	1716140295663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140296665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140296665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0033	1716140296665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140275637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140276643	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140277649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140278650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140279654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140280656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140281651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140282662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140283662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140284664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140285667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140286660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140287674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140288672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140289670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140290675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140291678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140292682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140293683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140294674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140295684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140296680	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140297689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140298684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140299686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140300695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140301699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140302700	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140303700	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140304694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140305695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140306696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140307707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140308709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140309703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140310713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140311718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140312717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140313710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140314719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140315722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140316724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140317725	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140318722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140319724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140320733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140321734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140322737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140323737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140324732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140325743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140326746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140327747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140328746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140570200	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140571203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140572210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140573212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140574216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140575209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140576218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140577221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140578222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140579223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140580218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140297667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140297667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0033	1716140297667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140298669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140298669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716140298669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140299671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140299671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716140299671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716140300673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140300673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716140300673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140301674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140301674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716140301674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140302675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140302675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716140302675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140303678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140303678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716140303678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140304679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140304679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9208	1716140304679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140305681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140305681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9208	1716140305681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140306683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140306683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9208	1716140306683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140307685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140307685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9252	1716140307685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140308687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140308687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9252	1716140308687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140309689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140309689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9252	1716140309689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140310691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140310691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9229	1716140310691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140311693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140311693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9229	1716140311693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140312695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140312695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9229	1716140312695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140313697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140313697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9245999999999999	1716140313697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140314699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140314699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9245999999999999	1716140314699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140315701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140315701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9245999999999999	1716140315701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140316702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140316702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9227	1716140316702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140317704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140317704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9227	1716140317704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140318708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140318708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9227	1716140318708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140319709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140319709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9239000000000002	1716140319709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140320711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140320711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9239000000000002	1716140320711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140321713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140321713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9239000000000002	1716140321713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140322714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140322714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9244	1716140322714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140323716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140323716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9244	1716140323716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140324718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716140324718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9244	1716140324718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140325720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140325720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9277	1716140325720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140326722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140326722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9277	1716140326722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140327724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140327724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9277	1716140327724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140328726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140328726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9267	1716140328726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140329728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140329728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9267	1716140329728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140329744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140330729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140330729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9267	1716140330729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140330744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140331731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140331731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9287999999999998	1716140331731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140331752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140332733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140332733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9287999999999998	1716140332733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140332754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140333735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140333735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9287999999999998	1716140333735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140333756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140334737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140334737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9296	1716140334737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140334753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140335739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140335739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9296	1716140335739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140335751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140336741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140336741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9296	1716140336741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140336762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140337744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140337744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.93	1716140337744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140338746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140338746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.93	1716140338746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140339748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140339748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.93	1716140339748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140340750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140340750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9333	1716140340750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140341752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140341752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9333	1716140341752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140342754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140342754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9333	1716140342754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140343755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140343755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140343755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140344757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140344757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140344757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140345759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140345759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140345759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140346761	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140346761	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140346761	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140347763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140347763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140347763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140348765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140348765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140348765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140349767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140349767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9303	1716140349767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140350768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140350768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9303	1716140350768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140351770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140351770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9303	1716140351770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140352772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140352772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9298	1716140352772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140353774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140353774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9298	1716140353774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140354776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140354776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9298	1716140354776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140355778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140355778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307999999999998	1716140355778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140356781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140356781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307999999999998	1716140356781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140357784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140357784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307999999999998	1716140357784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140358786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140337767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140338767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140339762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140340774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140341773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140342775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140343776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140344772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140345781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140346784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140347785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140348787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140349783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140350790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140351794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140352793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140353788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140354795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140355799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140356802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140357805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140358800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140359812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140360810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140361870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140362813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140363815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140364810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140365819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140366821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140367824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140368817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140369818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140370829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140371832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140372832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140373834	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140374833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140375837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140376831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140377834	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140378844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140379840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140380849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140381851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140382851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140383851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140384847	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140385857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140386859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140387862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140388862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140581228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140582230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140583231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140584235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140585238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140586239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140587242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140588234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140589236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140590244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140591246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140592249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140593242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140358786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9294	1716140358786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140359787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140359787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9294	1716140359787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140360789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140360789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9294	1716140360789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140361790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140361790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9310999999999998	1716140361790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140362792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140362792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9310999999999998	1716140362792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	107.9	1716140363794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140363794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9310999999999998	1716140363794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140364796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140364796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140364796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140365798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140365798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140365798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140366800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140366800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140366800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140367802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140367802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9330999999999998	1716140367802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140368804	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140368804	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9330999999999998	1716140368804	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140369805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140369805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9330999999999998	1716140369805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140370807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140370807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140370807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140371809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140371809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140371809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140372810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140372810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9305	1716140372810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140373812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140373812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140373812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140374814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140374814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140374814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140375816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140375816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9323	1716140375816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140376818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140376818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140376818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140377820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140377820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140377820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140378822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140378822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9307	1716140378822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140379824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140379824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9321	1716140379824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140380825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140380825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9321	1716140380825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140381827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140381827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9321	1716140381827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140382829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140382829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140382829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140383831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140383831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140383831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140384833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140384833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140384833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140385835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140385835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9334	1716140385835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140386837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140386837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9334	1716140386837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140387839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140387839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9334	1716140387839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140388841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140388841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9324000000000001	1716140388841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140389843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140389843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9324000000000001	1716140389843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140389856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	98	1716140390845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140390845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9324000000000001	1716140390845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140390865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140391846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140391846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9309	1716140391846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140391867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140392848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140392848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9309	1716140392848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140392871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140393850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140393850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9309	1716140393850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140393872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140394852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140394852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9337	1716140394852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140394873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140395854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140395854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9337	1716140395854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140395875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140396855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140396855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9337	1716140396855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140396879	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140397857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140397857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.937	1716140397857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140397884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140398859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140398859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.937	1716140398859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140399861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140399861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.937	1716140399861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140400863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140400863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140400863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140401865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140401865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140401865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140402866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140402866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140402866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140403868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140403868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9373	1716140403868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140404870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140404870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9373	1716140404870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140405872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140405872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9373	1716140405872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140406874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716140406874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9378	1716140406874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140407876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140407876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9378	1716140407876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140408877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140408877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9378	1716140408877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140409880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.6	1716140409880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9105	1716140409880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140410883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.199999999999999	1716140410883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9105	1716140410883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140411885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140411885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9105	1716140411885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140412887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140412887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9370999999999998	1716140412887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140413889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140413889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9370999999999998	1716140413889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140414891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140414891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9370999999999998	1716140414891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140415893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140415893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9349	1716140415893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140416895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140416895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9349	1716140416895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140417897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140417897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9349	1716140417897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140418899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140418899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9357	1716140418899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140419901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140398873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140399882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140400884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140401886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140402889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140403893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140404891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140405893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140406901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140407890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140408899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140409895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140410898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140411907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140412910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140413910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140414906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140415915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140416915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140417915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140418913	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140419922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140420923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140421928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140422920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140423932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140424925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140425936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140426930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140427944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140428947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140429938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140430948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140431949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140432956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140433946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140434948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140435956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140436961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140437961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140438956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140439958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140440966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140441962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140442970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140443971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140444967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140445975	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140446977	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140447980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140448982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140586216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140586216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140587218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140587218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140587218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140588220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140588220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140588220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140589222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140589222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9442000000000002	1716140589222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140590223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140590223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9442000000000002	1716140590223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140419901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9357	1716140419901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140420903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140420903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9357	1716140420903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140421904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140421904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.935	1716140421904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140422906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140422906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.935	1716140422906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140423909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140423909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.935	1716140423909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140424911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140424911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9352	1716140424911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140425914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140425914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9352	1716140425914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140426917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140426917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9352	1716140426917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140427921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140427921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140427921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140428923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140428923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140428923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140429925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140429925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140429925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140430926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140430926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140430926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140431928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140431928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140431928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140432930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140432930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140432930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140433932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140433932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140433932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140434934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140434934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140434934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140435936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140435936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9327999999999999	1716140435936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140436938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140436938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140436938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140437940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140437940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140437940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140438942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140438942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9369	1716140438942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140439943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140439943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140439943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140440945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140440945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140440945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140441947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140441947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9372	1716140441947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140442949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140442949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9389	1716140442949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140443950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140443950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9389	1716140443950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140444952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140444952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9389	1716140444952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140445954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140445954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9367999999999999	1716140445954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140446956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140446956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9367999999999999	1716140446956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140447959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140447959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9367999999999999	1716140447959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140448960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140448960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140448960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140449962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140449962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140449962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140449985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140450964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140450964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140450964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140450983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140451966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140451966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.938	1716140451966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140451987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140452968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140452968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.938	1716140452968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140452988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140453970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140453970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.938	1716140453970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140453990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140454972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140454972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9221	1716140454972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140454989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140455974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140455974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9221	1716140455974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140455995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140456976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140456976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9221	1716140456976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140456996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140457978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140457978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9347999999999999	1716140457978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140457999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140458980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140458980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9347999999999999	1716140458980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140459002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140459999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140460998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140462002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140463001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140464005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140465013	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140466013	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140467015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140468012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140469014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140470021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140471019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140472019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140473020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140474029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140475024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140476030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140477028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140478034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140479033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140480035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140481037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140482040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140483049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140484049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140485043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140486053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140487048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140488060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140489060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140490065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140491055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140492057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140493066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140494068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140495063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140496071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140497067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140498076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140499076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140500073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140501074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140502074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140503087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140504085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140505087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140506082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140507089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140508093	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140509097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140591225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140591225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9442000000000002	1716140591225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140592227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140592227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9430999999999998	1716140592227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140593229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716140593229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9430999999999998	1716140593229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140594231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140594231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9430999999999998	1716140594231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140595233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140595233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140459981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140459981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9347999999999999	1716140459981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140460983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140460983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140460983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140461985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140461985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140461985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140462987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140462987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.936	1716140462987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140463989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140463989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9375	1716140463989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140464991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140464991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9375	1716140464991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140465993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140465993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9375	1716140465993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140466995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140466995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9382000000000001	1716140466995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140467996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140467996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9382000000000001	1716140467996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140468998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140468998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9382000000000001	1716140468998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140470000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140470000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9405	1716140470000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140471002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140471002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9405	1716140471002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140472004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140472004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9405	1716140472004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140473006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140473006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9394	1716140473006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140474008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140474008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9394	1716140474008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140475010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140475010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.939	1716140475010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140476012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140476012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.939	1716140476012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140477014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140477014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.939	1716140477014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140478016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140478016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9345	1716140478016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140479018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140479018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9345	1716140479018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140480020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140480020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9345	1716140480020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140481022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140481022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140481022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140482024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140482024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140482024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140483026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140483026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9384000000000001	1716140483026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140484028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140484028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9381	1716140484028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140485030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140485030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9381	1716140485030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140486032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140486032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9381	1716140486032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140487034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140487034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9390999999999998	1716140487034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140488035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140488035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9390999999999998	1716140488035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140489037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140489037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9390999999999998	1716140489037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140490039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140490039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9397	1716140490039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140491040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140491040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9397	1716140491040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140492042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140492042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9397	1716140492042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140493044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140493044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9401	1716140493044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140494046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140494046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9401	1716140494046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140495048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140495048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9401	1716140495048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140496050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140496050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9421	1716140496050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140497051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140497051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9421	1716140497051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140498053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.700000000000001	1716140498053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9421	1716140498053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140499055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140499055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140499055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140500057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140500057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140500057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140501059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140501059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140501059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140502061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140502061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140502061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140503062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140503062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140503062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140504064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140504064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140504064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140505066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140505066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140505066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140506068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140506068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140506068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140507070	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140507070	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140507070	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140508072	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140508072	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140508072	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140509074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140509074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140509074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140510076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140510076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140510076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140510090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140511077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140511077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140511077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140511098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140512079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140512079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140512079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140512101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140513081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140513081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9402000000000001	1716140513081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140513104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140514083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140514083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9419000000000002	1716140514083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140514108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140515084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.300000000000001	1716140515084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9419000000000002	1716140515084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140515143	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140516086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140516086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9419000000000002	1716140516086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140516109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	107	1716140517088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140517088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9396	1716140517088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140517109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140518090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140518090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9396	1716140518090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140518113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140519092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140519092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9396	1716140519092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140519115	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140520094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140520094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9403	1716140520094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140521096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140521096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9403	1716140521096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140522098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140522098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9403	1716140522098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140523100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140523100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140523100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140524101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140524101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140524101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140525103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140525103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9416	1716140525103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140526105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140526105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9427999999999999	1716140526105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140527107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140527107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9427999999999999	1716140527107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140528109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140528109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9427999999999999	1716140528109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140529110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140529110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140529110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140530112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140530112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140530112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140531114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140531114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9434	1716140531114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140532116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140532116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140532116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140533118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140533118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140533118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140534120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140534120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140534120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140535121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140535121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140535121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140536123	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140536123	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140536123	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140537125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140537125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140537125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140538127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140538127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9435	1716140538127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140539129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140539129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9435	1716140539129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140540131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140540131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9435	1716140540131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140541133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140541133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140541133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140520108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140521119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140522121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140523120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140524124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140525125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140526126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140527128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140528130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140529124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140530133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140531138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140532137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140533138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140534134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140535144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140536145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140537147	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140538149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140539144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140540145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140541154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140542156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140543152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140544154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140545163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140546164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140547164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140548167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140549161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140550170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140551173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140552176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140553176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140554171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140555181	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140556183	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140557184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140558185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140559178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140560186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140561191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140562186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140563188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140564191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140565196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140566193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140567205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140568206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140569206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140594245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140595254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140596255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140597259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140598259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140599261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140600264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140601265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140602267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140603263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140604275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140605268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140606277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140607277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140608278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140542135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140542135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140542135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140543136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140543136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9414	1716140543136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140544138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140544138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140544138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140545140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.7	1716140545140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140545140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140546142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140546142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140546142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140547144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716140547144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140547144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140548146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140548146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140548146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140549148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140549148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9412	1716140549148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140550149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140550149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140550149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140551151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140551151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140551151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140552153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140552153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9422000000000001	1716140552153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140553155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140553155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140553155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140554157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140554157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140554157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140555159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140555159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140555159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140556161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140556161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9433	1716140556161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140557162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140557162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9433	1716140557162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140558164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140558164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9433	1716140558164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140559166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140559166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9436	1716140559166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140560168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140560168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9436	1716140560168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140561170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140561170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9436	1716140561170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140562172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140562172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.945	1716140562172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140563173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140563173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.945	1716140563173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140564176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140564176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.945	1716140564176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140565177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140565177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9425	1716140565177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140566179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140566179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9425	1716140566179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140567180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140567180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9425	1716140567180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140568182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140568182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140568182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140569184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140569184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140569184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140595233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140596234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140596234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140596234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140597236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140597236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9429	1716140597236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140598238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140598238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140598238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140599240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140599240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140599240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140600242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140600242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9424000000000001	1716140600242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140601244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140601244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140601244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140602246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140602246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140602246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140603248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140603248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140603248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140604250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140604250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140604250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140605252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140605252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140605252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140606254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140606254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9449	1716140606254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140607255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140607255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9450999999999998	1716140607255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140608257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140608257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9450999999999998	1716140608257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140609259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140609259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9450999999999998	1716140609259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140609280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716140610261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140610261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9454	1716140610261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140611264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140611264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9454	1716140611264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140612266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140612266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9454	1716140612266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140613268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140613268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140613268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140614270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140614270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140614270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140615272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140615272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9459000000000002	1716140615272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140616274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140616274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9445999999999999	1716140616274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140617275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140617275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9445999999999999	1716140617275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140618277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140618277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9445999999999999	1716140618277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140619279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140619279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140619279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140620281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140620281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140620281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140621283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140621283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9458	1716140621283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140622285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140622285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140622285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140623286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140623286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140623286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140624288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140624288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140624288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140625290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140625290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140625290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140626292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140626292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140626292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140627294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140627294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140627294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140628296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140628296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9490999999999998	1716140628296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140629300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140629300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9490999999999998	1716140629300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140989984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140989984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9698	1716140989984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140990986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140610276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140611279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140612289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140613281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140614283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140615294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140616294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140617301	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140618293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140619293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140620304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140621303	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140622305	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140623302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140624302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140625313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140626315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140627316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140628318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140629314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140630301	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140630301	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9490999999999998	1716140630301	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140630324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140631304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140631304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140631304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140631328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140632305	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140632305	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140632305	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140632327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140633307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140633307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140633307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140633330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140634309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140634309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9463	1716140634309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140634323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140635310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140635310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9463	1716140635310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140635324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140636313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140636313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9463	1716140636313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140636330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140637314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140637314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140637314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140637336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140638316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140638316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140638316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140638340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140639318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140639318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9472	1716140639318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140639340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140640321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140640321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9485999999999999	1716140640321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140640335	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140641323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140641323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9485999999999999	1716140641323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140642325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140642325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9485999999999999	1716140642325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140643327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140643327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9509	1716140643327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140644329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140644329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9509	1716140644329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140645330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140645330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9509	1716140645330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140646332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140646332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.949	1716140646332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140647334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140647334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.949	1716140647334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140648336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140648336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.949	1716140648336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140649338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140649338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9495	1716140649338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140650340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140650340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9495	1716140650340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140651341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140651341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9495	1716140651341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140652343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140652343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9483	1716140652343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140653345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140653345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9483	1716140653345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140654347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140654347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9483	1716140654347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140655349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140655349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140655349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140656351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140656351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140656351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140657353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140657353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140657353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140658355	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140658355	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9497	1716140658355	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140659356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140659356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9497	1716140659356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140660358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140660358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9497	1716140660358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140661360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140661360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.948	1716140661360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140662362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140662362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140641344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140642338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140643348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140644352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140645352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140646350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140647357	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140648357	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140649353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140650361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140651365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140652364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140653370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140654368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140655372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140656374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140657374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140658377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140659377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140660380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140661383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140662385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140663386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140664389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140665384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140666389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140667391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140668391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140669388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140670390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140671399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140672401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140673404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140674404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140675409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140676404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140677413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140678413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140679406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140680415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140681417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140682420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140683421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140684415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140685424	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140686426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140687428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140688434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140689437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140989998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140991009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140992009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140993012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140994011	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140995006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140996015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140997016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140998019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140999021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141000018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141001027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141002028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141003029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141004031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141005032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.948	1716140662362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140663364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140663364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.948	1716140663364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140664366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140664366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9481	1716140664366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140665368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140665368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9481	1716140665368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140666369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140666369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9481	1716140666369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140667370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	2.8	1716140667370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.952	1716140667370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716140668372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140668372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.952	1716140668372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716140669374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	2.8	1716140669374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.952	1716140669374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140670376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140670376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9512	1716140670376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140671378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140671378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9512	1716140671378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140672380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140672380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9512	1716140672380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140673382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140673382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140673382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140674383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140674383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140674383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140675385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140675385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9470999999999998	1716140675385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140676387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140676387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9503	1716140676387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140677389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140677389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9503	1716140677389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140678390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140678390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9503	1716140678390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140679392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140679392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140679392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140680394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140680394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140680394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140681396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.199999999999999	1716140681396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9492	1716140681396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140682398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140682398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9516	1716140682398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140683400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140683400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9516	1716140683400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140684401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140684401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9516	1716140684401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140685403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140685403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9522	1716140685403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140686405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140686405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9522	1716140686405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140687407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140687407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9522	1716140687407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140688409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140688409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9515	1716140688409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140689412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140689412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9515	1716140689412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140690414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140690414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9515	1716140690414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140690437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140691416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716140691416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9521	1716140691416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140691429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140692418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716140692418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9521	1716140692418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140692439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140693420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140693420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9521	1716140693420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140693441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140694422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140694422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9507	1716140694422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140694437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140695423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140695423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9507	1716140695423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140695440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140696425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140696425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9507	1716140696425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140696448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140697427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140697427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9513	1716140697427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140697448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140698429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140698429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9513	1716140698429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140698451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140699430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140699430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9513	1716140699430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140699446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140700432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140700432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9529	1716140700432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140700453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140701435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140701435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9529	1716140701435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140702437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140702437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9529	1716140702437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140703439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140703439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140703439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140704441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140704441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140704441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140705443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140705443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140705443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140706445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140706445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9546	1716140706445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140707447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140707447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9546	1716140707447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140708448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140708448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9546	1716140708448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140709450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140709450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140709450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140710452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140710452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140710452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140711454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140711454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140711454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140712456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140712456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9544000000000001	1716140712456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140713457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	2.9	1716140713457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9544000000000001	1716140713457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140714459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140714459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9544000000000001	1716140714459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140715460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140715460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9545	1716140715460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140716462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140716462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9545	1716140716462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140717464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140717464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9545	1716140717464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140718466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140718466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140718466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140719468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140719468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140719468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140720469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140720469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140720469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140721471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140721471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140721471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140722473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140722473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140722473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140701456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140702460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140703461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140704464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140705463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140706461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140707469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140708469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140709464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140710473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140711475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140712477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140713479	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140714473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140715481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140716483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140717485	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140718487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140719490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140720491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140721492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140722488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140723496	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140724491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140725496	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140726501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140727505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140728506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140729501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140730510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140731512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140732512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140733517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140734518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140735521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140736514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140737515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140738516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140739521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140740520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140741530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140742534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140743534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140744530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140745537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140746541	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140747534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140748535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140749537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140990986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9698	1716140990986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140991988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140991988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140991988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140992989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140992989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140992989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140993990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140993990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140993990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140994992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140994992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707000000000001	1716140994992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140995994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140995994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140723475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140723475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9530999999999998	1716140723475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140724477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140724477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9527999999999999	1716140724477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140725479	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140725479	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9527999999999999	1716140725479	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140726481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140726481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9527999999999999	1716140726481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140727482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140727482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140727482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140728484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140728484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140728484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140729486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140729486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9526	1716140729486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140730488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140730488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140730488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140731490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140731490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140731490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716140732492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140732492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140732492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140733494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140733494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140733494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140734495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140734495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140734495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140735497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140735497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140735497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140736500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140736500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140736500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140737501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140737501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140737501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716140738503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140738503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140738503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140739505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140739505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9533	1716140739505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140740507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140740507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9533	1716140740507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140741508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140741508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9533	1716140741508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140742510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140742510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.953	1716140742510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140743512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140743512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.953	1716140743512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140744514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140744514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.953	1716140744514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140745516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140745516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9550999999999998	1716140745516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140746518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140746518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9550999999999998	1716140746518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140747519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140747519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9550999999999998	1716140747519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140748521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140748521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9563	1716140748521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140749523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140749523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9563	1716140749523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140750525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140750525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9563	1716140750525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140750547	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140751527	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140751527	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9557	1716140751527	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140751540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140752529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140752529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9557	1716140752529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140752551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140753531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140753531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9557	1716140753531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140753552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140754533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140754533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140754533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140754546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140755535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140755535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140755535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140755549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140756536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140756536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140756536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140756559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140757538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140757538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140757538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140757559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140758540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140758540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140758540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140758564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140759542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140759542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9561	1716140759542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140759555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140760544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140760544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140760544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140760559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140761546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140761546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140761546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140761569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140762572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140763570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140764567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140765579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140766578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140767581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140768584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140769579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140770588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140771591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140772594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140773595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140774587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140775599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140776604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140777605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140778604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140779606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140780608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140781611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140782611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140783614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140784615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140785610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140786622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140787624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140788623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140789619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140790627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140791627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140792629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140793633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140794627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140795636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140796637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140797639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140798643	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140799636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140800646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140801646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140802649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140803649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140804644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140805653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140806656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140807657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140808660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140809661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140810662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140811665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140812669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140813669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140814662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140815674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140816676	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140817676	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140818679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140819673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140820683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140821686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140822685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140823693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140824691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140825692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140762548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140762548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140762548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140763550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140763550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9535	1716140763550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140764554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140764554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9535	1716140764554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140765555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140765555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9535	1716140765555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140766557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140766557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9555	1716140766557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140767559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140767559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9555	1716140767559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140768563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140768563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9555	1716140768563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140769564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140769564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9569	1716140769564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140770566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140770566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9569	1716140770566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140771568	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140771568	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9569	1716140771568	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140772571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140772571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9565	1716140772571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140773573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140773573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9565	1716140773573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140774575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140774575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9565	1716140774575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140775577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140775577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9562	1716140775577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140776579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140776579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9562	1716140776579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140777581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140777581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9562	1716140777581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140778583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140778583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9567999999999999	1716140778583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140779584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140779584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9567999999999999	1716140779584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140780586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5	1716140780586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9567999999999999	1716140780586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140781588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140781588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140781588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140782590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140782590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140782590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140783592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140783592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9554	1716140783592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140784594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140784594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140784594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140785596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140785596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140785596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140786597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140786597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.955	1716140786597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140787599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140787599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140787599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140788601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140788601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140788601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140789603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140789603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9553	1716140789603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140790605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140790605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9584000000000001	1716140790605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140791607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140791607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9584000000000001	1716140791607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140792609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140792609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9584000000000001	1716140792609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140793610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140793610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9572	1716140793610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140794612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140794612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9572	1716140794612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140795614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140795614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9572	1716140795614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140796616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140796616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9581	1716140796616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140797618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140797618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9581	1716140797618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140798620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140798620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9581	1716140798620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140799622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140799622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9573	1716140799622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140800623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140800623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9573	1716140800623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140801625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140801625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9573	1716140801625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140802627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140802627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9539000000000002	1716140802627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140803629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140803629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9539000000000002	1716140803629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140804631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140804631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9539000000000002	1716140804631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140805633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140805633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9552	1716140805633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140806634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140806634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9552	1716140806634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140807636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140807636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9552	1716140807636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140808638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140808638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9576	1716140808638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140809640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140809640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9576	1716140809640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140810642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140810642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9576	1716140810642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140811644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140811644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9587	1716140811644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140812646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140812646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9587	1716140812646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140813647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140813647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9587	1716140813647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140814649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.9	1716140814649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9594	1716140814649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140815651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6000000000000005	1716140815651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9594	1716140815651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140816653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140816653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9594	1716140816653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140817655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140817655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9585	1716140817655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140818657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140818657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9585	1716140818657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140819659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140819659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9585	1716140819659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140820661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140820661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140820661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140821663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140821663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140821663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140822664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140822664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140822664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140823666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140823666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9604000000000001	1716140823666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140824668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140824668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9604000000000001	1716140824668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140825670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140825670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9604000000000001	1716140825670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140826672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140826672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9639000000000002	1716140826672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140827674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140827674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9639000000000002	1716140827674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140828675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140828675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9639000000000002	1716140828675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140829677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140829677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.962	1716140829677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140830679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140830679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.962	1716140830679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140831681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140831681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.962	1716140831681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140832683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140832683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140832683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140833685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140833685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140833685	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140834687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140834687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140834687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140835689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140835689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.965	1716140835689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140836691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140836691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.965	1716140836691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140837693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140837693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.965	1716140837693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140838695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140838695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9623	1716140838695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140839697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140839697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9623	1716140839697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140840699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140840699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9623	1716140840699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140841701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140841701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140841701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140842702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140842702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140842702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716140843704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140843704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140843704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140844706	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140844706	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.957	1716140844706	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140845708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140845708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.957	1716140845708	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140846710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140846710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.957	1716140846710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140847713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140826694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140827687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140828698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140829691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140830702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140831703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140832704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140833707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140834701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140835712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140836712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140837716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140838717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140839721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140840719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140841721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140842724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140843727	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140844720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140845729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140846731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140847734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140848738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140849730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140850743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140851745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140852736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140853746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140854740	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140855749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140856754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140857753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140858757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140859748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140860758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140861760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140862763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140863765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140864760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140865769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140866771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140867764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140868774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140869771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707000000000001	1716140995994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140996996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140996996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707000000000001	1716140996996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140997998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140997998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9693	1716140997998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140999000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140999000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9693	1716140999000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141000001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141000001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9693	1716141000001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141001003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141001003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9733	1716141001003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141002005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141002005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9733	1716141002005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141003006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141003006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140847713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140847713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140848715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140848715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140848715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140849717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140849717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140849717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140850719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140850719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9609	1716140850719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140851721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140851721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9609	1716140851721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140852722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140852722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9609	1716140852722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140853724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140853724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140853724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140854726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140854726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140854726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140855728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140855728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140855728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140856730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140856730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140856730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140857732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140857732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140857732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140858734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140858734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140858734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140859735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140859735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140859735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140860737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140860737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140860737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140861739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140861739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140861739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140862741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140862741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140862741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140863743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140863743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140863743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140864745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140864745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140864745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140865747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140865747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140865747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140866749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140866749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140866749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140867751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140867751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140867751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140868752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140868752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9621	1716140868752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140869754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140869754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9621	1716140869754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140870756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140870756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9621	1716140870756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140870778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140871758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140871758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627000000000001	1716140871758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140871779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140872760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140872760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627000000000001	1716140872760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140872774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140873762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140873762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627000000000001	1716140873762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140873785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140874764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140874764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140874764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140874778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140875766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140875766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140875766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140875785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140876769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140876769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9603	1716140876769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140876790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140877771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140877771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140877771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140877787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140878773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140878773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140878773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140878794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140879775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140879775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140879775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140879788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140880776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716140880776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140880776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140880798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140881778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140881778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140881778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140881799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140882780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140882780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9622	1716140882780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140882795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140883782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140883782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140883782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140883806	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140884784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140884784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140884784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140884805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140885786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140885786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140885786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140886788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140886788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9593	1716140886788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140887790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140887790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9593	1716140887790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140888792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140888792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9593	1716140888792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140889794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140889794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140889794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140890796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140890796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140890796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140891797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140891797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9624000000000001	1716140891797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140892799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140892799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140892799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140893801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140893801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140893801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140894803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140894803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9627999999999999	1716140894803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140895805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140895805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140895805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140896807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140896807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140896807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140897808	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140897808	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140897808	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140898810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140898810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140898810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140899812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140899812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140899812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140900814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140900814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.963	1716140900814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140901816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140901816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9649	1716140901816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140902818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140902818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9649	1716140902818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140903819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140903819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9649	1716140903819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140904821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140904821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140904821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140905823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140905823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140905823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140906825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140885807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140886810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140887803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140888814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140889808	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140890816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140891818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140892812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140893824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140894817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140895826	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140896828	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140897825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140898825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140899828	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140900836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140901839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140902841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140903841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140904840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140905844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140906848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140907849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140908845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140909845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140910856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140911857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140912857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140913854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140914863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140915864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140916865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140917870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140918862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140919871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140920875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140921879	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140922877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140923871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140924881	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140925886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140926878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140927889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140928882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140929883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140930892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140931896	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140932898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140933898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140934893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140935904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140936904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140937908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140938909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140939902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140940913	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140941915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140942916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140943918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140944918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140945920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140946921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140947916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140948928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140949919	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140906825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140906825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140907827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140907827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140907827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140908829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140908829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140908829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140909831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140909831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9617	1716140909831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140910833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140910833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9645	1716140910833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140911835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140911835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9645	1716140911835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140912837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140912837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9645	1716140912837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140913839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140913839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140913839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140914841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140914841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140914841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140915842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140915842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9636	1716140915842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140916844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140916844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9647999999999999	1716140916844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140917846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140917846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9647999999999999	1716140917846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140918848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140918848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9647999999999999	1716140918848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140919850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140919850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9650999999999998	1716140919850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140920852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140920852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9650999999999998	1716140920852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140921854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140921854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9650999999999998	1716140921854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140922855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140922855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9679	1716140922855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140923857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140923857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9679	1716140923857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140924859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140924859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9679	1716140924859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140925861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140925861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140925861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140926863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140926863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140926863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140927865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140927865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140927865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140928868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140928868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9630999999999998	1716140928868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140929870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140929870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9630999999999998	1716140929870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140930871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140930871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9630999999999998	1716140930871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140931873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140931873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9652	1716140931873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140932875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140932875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9652	1716140932875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140933877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140933877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9652	1716140933877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140934879	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140934879	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9667000000000001	1716140934879	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140935881	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140935881	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9667000000000001	1716140935881	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140936882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.7	1716140936882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9667000000000001	1716140936882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140937884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6	1716140937884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9656	1716140937884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140938886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140938886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9656	1716140938886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140939888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140939888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9656	1716140939888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140940890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140940890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140940890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140941892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140941892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140941892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140942894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140942894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9654	1716140942894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140943895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140943895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9657	1716140943895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140944897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140944897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9657	1716140944897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140945899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140945899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9657	1716140945899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140946900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140946900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9663	1716140946900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140947902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140947902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9663	1716140947902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140948904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140948904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9663	1716140948904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140949906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140949906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9683	1716140949906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140950908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140950908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9683	1716140950908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140951910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140951910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9683	1716140951910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140952911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140952911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9643	1716140952911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140953915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140953915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9643	1716140953915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140954917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140954917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9643	1716140954917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140955918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140955918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9662	1716140955918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140956920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140956920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9662	1716140956920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140957922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140957922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9662	1716140957922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140958924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140958924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9674	1716140958924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140959926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140959926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9674	1716140959926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140960928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140960928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9674	1716140960928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140961930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140961930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9677	1716140961930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140962931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140962931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9677	1716140962931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140963933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140963933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9677	1716140963933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140964935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140964935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9694	1716140964935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140965937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140965937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9694	1716140965937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140966939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140966939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9694	1716140966939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140967940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140967940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707999999999999	1716140967940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140968942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140968942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707999999999999	1716140968942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140969944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716140969944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9707999999999999	1716140969944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140970948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140950931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140951931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140952933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140953937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140954931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140955940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140956941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140957943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140958940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140959941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140960948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140961950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140962954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140963954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140964949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140965959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140966960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140967963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140968965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140969959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140970968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140971971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140972971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140973976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140974969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140975978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140976980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140977982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140978986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140979979	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140980986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140981992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140982993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140983995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140984988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140985997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140987000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140988004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716140989004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9733	1716141003006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141004008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141004008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9747000000000001	1716141004008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141005010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141005010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9747000000000001	1716141005010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141006012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141006012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9739	1716141006012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141007014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141007014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9739	1716141007014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141008016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141008016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9739	1716141008016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141009018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141009018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9770999999999999	1716141009018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141010019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141010019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9770999999999999	1716141010019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141011020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141011020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9770999999999999	1716141011020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141012022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140970948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.966	1716140970948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140971949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140971949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.966	1716140971949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140972950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140972950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.966	1716140972950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140973952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140973952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140973952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	98	1716140974954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140974954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140974954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140975956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140975956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9641	1716140975956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140976958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140976958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9687000000000001	1716140976958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140977960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140977960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9687000000000001	1716140977960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140978963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140978963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9687000000000001	1716140978963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716140979965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140979965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9705	1716140979965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140980967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140980967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9705	1716140980967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140981969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140981969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9705	1716140981969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140982971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140982971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140982971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140983972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140983972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140983972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140984974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140984974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9701	1716140984974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716140985976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140985976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9702	1716140985976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716140986978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140986978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9702	1716140986978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716140987980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716140987980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9702	1716140987980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716140988982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716140988982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9698	1716140988982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141006033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141007035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141008037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141009032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141010033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141011043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141012022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9764000000000002	1716141012022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141012044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141013045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141014047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141015042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141016051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141017053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141018057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141019057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141020051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141021062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141022064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141023065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141024059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141025061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141026071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141027074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141028065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141029076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141030072	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141031082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141032080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141033085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141034077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141035087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141036091	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141037091	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141038094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141039086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141040097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141041098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141042100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141043104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141044097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141045106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141046108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141047112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141048113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141049107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141050117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141051119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141052121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141053123	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141054125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141055122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141056129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141057131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141058127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141059135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141060133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141061142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141062135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141063142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141064139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141065147	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141066148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141067149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141068152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141069145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141070157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141071158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141072162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141073160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141074155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141075162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141076166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141013024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141013024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9764000000000002	1716141013024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141014026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141014026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9764000000000002	1716141014026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141015028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141015028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141015028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141016030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141016030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141016030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141017032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141017032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141017032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141018034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141018034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9734	1716141018034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141019036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141019036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9734	1716141019036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141020038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141020038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9734	1716141020038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141021040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141021040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.976	1716141021040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141022042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141022042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.976	1716141022042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141023043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141023043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.976	1716141023043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141024045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141024045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141024045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141025047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141025047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141025047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141026049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141026049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141026049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141027050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141027050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9750999999999999	1716141027050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141028052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141028052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9750999999999999	1716141028052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141029054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141029054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9750999999999999	1716141029054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141030056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141030056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9755	1716141030056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141031058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141031058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9755	1716141031058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141032060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141032060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9755	1716141032060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141033062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141033062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141033062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141034064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141034064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141034064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141035066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141035066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141035066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141036068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141036068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141036068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141037069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141037069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141037069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141038071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141038071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141038071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141039073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141039073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9714	1716141039073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141040075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141040075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9714	1716141040075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141041077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141041077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9714	1716141041077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141042079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141042079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9717	1716141042079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141043081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141043081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9717	1716141043081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141044083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141044083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9717	1716141044083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141045085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141045085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9729	1716141045085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141046087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141046087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9729	1716141046087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141047090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141047090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9729	1716141047090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141048092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141048092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9742	1716141048092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141049094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141049094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9742	1716141049094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141050096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141050096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9742	1716141050096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141051098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141051098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141051098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141052100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141052100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141052100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141053102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141053102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141053102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141054104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141054104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141054104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141055106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141055106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141055106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141056108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141056108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141056108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141057110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141057110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9761	1716141057110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141058112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141058112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9761	1716141058112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141059114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141059114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9761	1716141059114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141060116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141060116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9766	1716141060116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141061118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141061118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9766	1716141061118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141062119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141062119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9766	1716141062119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141063120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141063120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9772	1716141063120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141064122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141064122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9772	1716141064122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141065124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141065124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9772	1716141065124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141066126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141066126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9774	1716141066126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141067128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.8	1716141067128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9774	1716141067128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141068130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.1	1716141068130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9774	1716141068130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141069131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141069131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9779	1716141069131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141070133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141070133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9779	1716141070133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141071135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141071135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9779	1716141071135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141072137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141072137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9787000000000001	1716141072137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141073139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141073139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9787000000000001	1716141073139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141074140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141074140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9787000000000001	1716141074140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141075142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141075142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141075142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141076144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141076144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141076144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141077146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141077146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141077146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141078148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141078148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141078148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141079150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141079150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141079150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141080151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141080151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9778	1716141080151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141081153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141081153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141081153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141082155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141082155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141082155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141083157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141083157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9754	1716141083157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141084159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141084159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9727999999999999	1716141084159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141085161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141085161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9727999999999999	1716141085161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141086163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141086163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9727999999999999	1716141086163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141087165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141087165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141087165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141088167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141088167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141088167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141089169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141089169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9758	1716141089169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141090171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141090171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141090171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141091173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141091173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141091173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141092175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141092175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9752	1716141092175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141093177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141093177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9781	1716141093177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141094179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141094179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9781	1716141094179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141095180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141095180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9781	1716141095180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141096182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141096182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9784000000000002	1716141096182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141097184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141097184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9784000000000002	1716141097184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141098186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141077160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141078161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141079163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141080173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141081174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141082178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141083180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141084174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141085184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141086181	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141087185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141088188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141089192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141090195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141091195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141092196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141093199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141094195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141095205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141096204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141097206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141098208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141099209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141100203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141101215	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141102217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141103216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141104218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141105213	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141106221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141107225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141108226	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141109228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141470907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141470907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9952	1716141470907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141471909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141471909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9969000000000001	1716141471909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141472910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141472910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9969000000000001	1716141472910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141473912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141473912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9969000000000001	1716141473912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141474914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141474914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141474914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141475916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141475916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141475916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141476918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141476918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141476918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141477920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141477920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141477920	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141478922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716141478922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141478922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141479924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141479924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141479924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141480926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141480926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141098186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9784000000000002	1716141098186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141099188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141099188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9773	1716141099188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141100190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141100190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9773	1716141100190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141101192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141101192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9773	1716141101192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141102193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141102193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9795	1716141102193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141103195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141103195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9795	1716141103195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141104197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141104197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9795	1716141104197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141105199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141105199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9805	1716141105199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141106201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141106201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9805	1716141106201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141107203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141107203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9805	1716141107203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141108205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141108205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141108205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141109207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141109207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141109207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141110208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141110208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9757	1716141110208	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141110230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141111210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141111210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141111210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141111231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141112212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141112212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141112212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141112234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141113214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141113214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141113214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141113236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141114217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141114217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141114217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141114239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141115218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141115218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141115218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141115240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141116220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141116220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.977	1716141116220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141116240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141117222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141117222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141117222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141118224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141118224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141118224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141119227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141119227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141119227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141120229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141120229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9782	1716141120229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141121231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141121231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9782	1716141121231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141122233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141122233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9782	1716141122233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141123235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141123235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9794	1716141123235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141124237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141124237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9794	1716141124237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141125239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141125239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9794	1716141125239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141126241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141126241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9790999999999999	1716141126241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141127243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141127243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9790999999999999	1716141127243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141128244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141128244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9790999999999999	1716141128244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141129246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141129246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9769	1716141129246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141130248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141130248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9769	1716141130248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141131250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141131250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9769	1716141131250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141132252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141132252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9797	1716141132252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141133254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141133254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9797	1716141133254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141134255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141134255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9797	1716141134255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141135257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141135257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9814	1716141135257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141136259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141136259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9814	1716141136259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141137261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141137261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9814	1716141137261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141138263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141138263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141117244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141118245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141119248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141120250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141121252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141122254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141123258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141124260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141125260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141126254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141127267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141128265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141129260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141130270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141131279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141132273	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141133277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141134270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141135279	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141136278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141137282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141138283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141139285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141140287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141141291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141142291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141143294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141144289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141145292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141146299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141147303	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141148298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141149299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141150309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141151310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141152317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141153316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141154313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141155325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141156313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141157324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141158325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141159329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141160321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141161329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141162330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141163334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141164336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141165330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141166340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141167344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141168346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141169349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141170350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141171350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141172358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141173356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141174359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141175352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141176363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141177363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141178364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141179367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141180361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141181370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9815999999999998	1716141138263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141139265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141139265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9815999999999998	1716141139265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141140266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141140266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9815999999999998	1716141140266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141141268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141141268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9783	1716141141268	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141142270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141142270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9783	1716141142270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141143272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141143272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9783	1716141143272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141144274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141144274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141144274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141145276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141145276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141145276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141146278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141146278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.978	1716141146278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141147281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141147281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9799	1716141147281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141148283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141148283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9799	1716141148283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141149285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141149285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9799	1716141149285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141150287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141150287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9798	1716141150287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141151289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141151289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9798	1716141151289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141152291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141152291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9798	1716141152291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141153293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141153293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9793	1716141153293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141154295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141154295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9793	1716141154295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141155297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141155297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9793	1716141155297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141156298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141156298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9822	1716141156298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141157300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141157300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9822	1716141157300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141158302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141158302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9822	1716141158302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141159304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141159304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.982	1716141159304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141160306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141160306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.982	1716141160306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141161308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141161308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.982	1716141161308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141162310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141162310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141162310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141163311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141163311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141163311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141164313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141164313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141164313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141165316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141165316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141165316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141166319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141166319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141166319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141167322	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141167322	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141167322	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141168324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141168324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141168324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141169326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141169326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141169326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141170328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141170328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9849	1716141170328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141171330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141171330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141171330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141172332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141172332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141172332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141173333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141173333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141173333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141174335	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141174335	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141174335	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141175337	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141175337	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141175337	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141176339	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141176339	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141176339	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141177341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141177341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141177341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141178343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141178343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141178343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141179345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141179345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141179345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141180346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141180346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141180346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141181348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141181348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141181348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141182350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141182350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141182350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141183352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141183352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141183352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141184354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141184354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141184354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141185356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716141185356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141185356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141186358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.2	1716141186358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141186358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141187360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141187360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141187360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141188361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141188361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141188361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141189363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141189363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141189363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141190365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141190365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141190365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141191367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141191367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141191367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141192369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141192369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9828	1716141192369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141193370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141193370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9828	1716141193370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141194373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141194373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9828	1716141194373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141195375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141195375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9833	1716141195375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141196377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141196377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9833	1716141196377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141197379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141197379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9833	1716141197379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141198381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141198381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141198381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141199383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141199383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141199383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141200385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141200385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141200385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141201387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141201387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.983	1716141201387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141202390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141202390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141182371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141183373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141184371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141185377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141186374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141187384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141188383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141189378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141190388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141191391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141192390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141193396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141194390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141195392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141196392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141197395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141198397	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141199399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141200410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141201402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141202413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141203414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141204408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141205411	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141206420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141207421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141208422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141209418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141210426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141211428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141212428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141213432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141214428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141215437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141216438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141217440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141218441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141219438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141220447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141221450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141222448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141223449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141224444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141225453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141226454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141227460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141228459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141229461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141470930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141471930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141472931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141473933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141474928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141475937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141476940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141477941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141478945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141479939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141480947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141481949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141482951	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141483954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141484956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141485957	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141486959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.983	1716141202390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141203392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141203392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.983	1716141203392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141204394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141204394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141204394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141205396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141205396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141205396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141206398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141206398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141206398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141207400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141207400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9850999999999999	1716141207400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141208401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141208401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9850999999999999	1716141208401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141209403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141209403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9850999999999999	1716141209403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141210405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141210405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.985	1716141210405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141211407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141211407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.985	1716141211407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141212409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141212409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.985	1716141212409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141213410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141213410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141213410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141214412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141214412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141214412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141215414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141215414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9841	1716141215414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141216416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141216416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9832	1716141216416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141217418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141217418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9832	1716141217418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141218420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141218420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9832	1716141218420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141219421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141219421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9853	1716141219421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141220423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141220423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9853	1716141220423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141221425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141221425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9853	1716141221425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141222427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141222427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141222427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141223428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141223428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141223428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141224430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141224430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9864000000000002	1716141224430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141225432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141225432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141225432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141226434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141226434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141226434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141227435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141227435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141227435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141228437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141228437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141228437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141229439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141229439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141229439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141230440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141230440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9846	1716141230440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141230465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141231442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141231442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141231442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141231464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141232445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141232445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141232445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141232466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141233447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141233447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9863	1716141233447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141233469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141234449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141234449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9865	1716141234449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141234464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141235450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141235450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9865	1716141235450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141235471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141236452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141236452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9865	1716141236452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141236473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716141237454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141237454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141237454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141237476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141238456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141238456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141238456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141238477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141239458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141239458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9855	1716141239458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141239473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141240460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141240460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141240460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141240483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141241461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141241461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141241461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141242463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141242463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141242463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141243465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141243465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141243465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141244467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141244467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141244467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141245469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141245469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141245469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141246471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141246471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9872999999999998	1716141246471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141247473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141247473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9872999999999998	1716141247473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141248474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141248474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9872999999999998	1716141248474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141249476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141249476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141249476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141250478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141250478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141250478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141251480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141251480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141251480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141252482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141252482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141252482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141253484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141253484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141253484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141254486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141254486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9874	1716141254486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141255487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141255487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.989	1716141255487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141256489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141256489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.989	1716141256489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141257491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141257491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.989	1716141257491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141258493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141258493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141258493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141259495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141259495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141259495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141260497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141260497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9854	1716141260497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141261499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141261499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.984	1716141261499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141262500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141262500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.984	1716141262500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141241484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141242488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141243487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141244489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141245492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141246495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141247494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141248500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141249490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141250498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141251501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141252504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141253505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141254500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141255512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141256516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141257513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141258515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141259517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141260519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141261522	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141262522	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141263525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141264523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141265530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141266529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141267532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141268531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141269528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141270530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141271533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141272536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141273536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141274540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141275549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141276552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141277545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141278558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141279550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141280557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141281560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141282555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141283563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141284560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141285568	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141286571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141287573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141288577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141289570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141290574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141291581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141292576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141293585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141294582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141295591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141296593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141297589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141298596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141299591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141300592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141301605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141302605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141303606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141304603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141305605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141263502	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141263502	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.984	1716141263502	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141264504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141264504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9858	1716141264504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141265506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141265506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9858	1716141265506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141266508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141266508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9858	1716141266508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141267510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141267510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9857	1716141267510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141268512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141268512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9857	1716141268512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141269514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141269514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9857	1716141269514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141270516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141270516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141270516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141271517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141271517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141271517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141272521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141272521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141272521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141273523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141273523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141273523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141274525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141274525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141274525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141275526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141275526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141275526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141276528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141276528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141276528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141277531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141277531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141277531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141278532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141278532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9885	1716141278532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141279534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141279534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9842	1716141279534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141280536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141280536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9842	1716141280536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141281538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141281538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9842	1716141281538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141282540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141282540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141282540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141283542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141283542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141283542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141284544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141284544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9868	1716141284544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141285546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141285546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9859	1716141285546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141286548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141286548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9859	1716141286548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141287551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141287551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9859	1716141287551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141288554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141288554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141288554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141289556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141289556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141289556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141290558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141290558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9870999999999999	1716141290558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141291560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141291560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141291560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141292562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141292562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141292562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141293564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141293564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141293564	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141294566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141294566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141294566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141295570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141295570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141295570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141296571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141296571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141296571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141297573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141297573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141297573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141298575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141298575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141298575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141299577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141299577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141299577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141300579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141300579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9890999999999999	1716141300579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141301581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141301581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9890999999999999	1716141301581	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141302583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141302583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9890999999999999	1716141302583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141303585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141303585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9888	1716141303585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141304587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141304587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9888	1716141304587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141305588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141305588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9888	1716141305588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141306590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141306590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9895999999999998	1716141306590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141307593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141307593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9895999999999998	1716141307593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141308596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141308596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9895999999999998	1716141308596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141309598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141309598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9882	1716141309598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141310600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141310600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9882	1716141310600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141311602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141311602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9882	1716141311602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141312604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141312604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141312604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141313606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141313606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141313606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141314607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141314607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141314607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141315609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141315609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141315609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141316611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141316611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141316611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141317613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141317613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9894	1716141317613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141318616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141318616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141318616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141319618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141319618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141319618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141320620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141320620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9897	1716141320620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141321622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141321622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9902	1716141321622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141322624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141322624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9902	1716141322624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141323626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141323626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9902	1716141323626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141324627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141324627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9867000000000001	1716141324627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141325629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141325629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9867000000000001	1716141325629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141326631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141326631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9867000000000001	1716141326631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141306613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141307617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141308621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141309612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141310616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141311626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141312627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141313631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141314622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141315625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141316636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141317638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141318638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141319641	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141320637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141321649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141322640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141323651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141324645	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141325645	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141326655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141327659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141328658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141329661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141330653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141331656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141332663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141333665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141334669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141335663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141336674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141337666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141338676	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141339669	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141340675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141341677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141342677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141343684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141344679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141345682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141346689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141347693	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141348695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141349686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141480926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141481928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141481928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141481928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141482930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141482930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141482930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141483932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141483932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9939	1716141483932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141484933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141484933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9939	1716141484933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141485936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141485936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9939	1716141485936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141486938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141486938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932999999999998	1716141486938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141487940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141487940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141327633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141327633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141327633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141328635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141328635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141328635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141329637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141329637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141329637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141330639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141330639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141330639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141331640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141331640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141331640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141332642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141332642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9898	1716141332642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141333644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141333644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.991	1716141333644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141334646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141334646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.991	1716141334646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141335648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141335648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.991	1716141335648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141336650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141336650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915999999999998	1716141336650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141337651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141337651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915999999999998	1716141337651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141338653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141338653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915999999999998	1716141338653	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141339655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141339655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141339655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141340657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141340657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141340657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141341659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141341659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141341659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141342660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141342660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141342660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141343662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141343662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141343662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141344664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141344664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141344664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141345666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141345666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141345666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141346668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.3	1716141346668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141346668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141347670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8	1716141347670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141347670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141348672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141348672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141348672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141349673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141349673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141349673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141350675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141350675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9892	1716141350675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141350689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141351677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141351677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141351677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141351698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141352679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141352679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141352679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141352694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141353682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141353682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141353682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141353703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141354684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141354684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141354684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141354699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141355686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141355686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141355686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141355702	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141356687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141356687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912	1716141356687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141356709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141357689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141357689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141357689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141357703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141358691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141358691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141358691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141358713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141359694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141359694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9906	1716141359694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141359707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141360696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141360696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9928	1716141360696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141360709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141361698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141361698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9928	1716141361698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141361719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141362699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141362699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9928	1716141362699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141362721	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141363701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141363701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932	1716141363701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141363723	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141364703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141364703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932	1716141364703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141364724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141365718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141366729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141367731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141368732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141369727	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141370729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141371730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141372739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141373742	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141374738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141375739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141376747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141377750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141378753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141379748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141380752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141381759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141382762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141383763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141384764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141385759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141386760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141387762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141388774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141389775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141390768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141391782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141392779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141393776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141394785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141395777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141396785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141397790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141398791	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141399786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141400786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141401795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141402797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141403798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141404795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141405796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141406806	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141407808	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141408811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141409804	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141410809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141411817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141412820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141413819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141414814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141415820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141416826	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141417826	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141418828	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141419823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141420825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141421832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141422836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141423838	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141424840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141425843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141426844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141427848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141428841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141365705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141365705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932	1716141365705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141366707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141366707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141366707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141367709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141367709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141367709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141368711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141368711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141368711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141369713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141369713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9883	1716141369713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716141370714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141370714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9883	1716141370714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141371716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141371716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9883	1716141371716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141372718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141372718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9909000000000001	1716141372718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141373720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141373720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9909000000000001	1716141373720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141374722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141374722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9909000000000001	1716141374722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141375724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141375724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141375724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141376726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141376726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141376726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141377728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141377728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141377728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141378731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141378731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141378731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141379733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141379733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141379733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141380735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141380735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9914	1716141380735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141381737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141381737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912999999999998	1716141381737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141382739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141382739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912999999999998	1716141382739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141383741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141383741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9912999999999998	1716141383741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141384743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141384743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141384743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141385744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141385744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141385744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141386746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141386746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141386746	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141387748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141387748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141387748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141388750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141388750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141388750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141389752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141389752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141389752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141390754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141390754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141390754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141391755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141391755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141391755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141392757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141392757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9924000000000002	1716141392757	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141393759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141393759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141393759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141394760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141394760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141394760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141395762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141395762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9889000000000001	1716141395762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141396764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141396764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9905	1716141396764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141397766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141397766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9905	1716141397766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141398768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141398768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9905	1716141398768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141399770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141399770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141399770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141400772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141400772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141400772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141401774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141401774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141401774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141402776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141402776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141402776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141403777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141403777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141403777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141404779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141404779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141404779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141405781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141405781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9926	1716141405781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141406783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141406783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9926	1716141406783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141407785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141407785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9926	1716141407785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141408787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141408787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141408787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141409790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141409790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141409790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141410792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141410792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141410792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141411793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141411793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141411793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141412795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141412795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141412795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141413797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141413797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9917	1716141413797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141414799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141414799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915	1716141414799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141415801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141415801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915	1716141415801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141416803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141416803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9915	1716141416803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141417805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141417805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141417805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141418807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141418807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141418807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141419809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141419809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141419809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141420811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141420811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141420811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141421813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141421813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141421813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141422815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141422815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141422815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141423816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141423816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955	1716141423816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141424819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141424819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955	1716141424819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141425821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141425821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955	1716141425821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141426824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141426824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141426824	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141427825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141427825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141427825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141428827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141428827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141428827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141429829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141429829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141429829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141430831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141430831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141430831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141431833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141431833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141431833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141432835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141432835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141432835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141433837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141433837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141433837	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141434839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141434839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141434839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141435840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141435840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141435840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141436842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.1	1716141436842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141436842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141437844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141437844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141437844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141438846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141438846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9946	1716141438846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141439848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141439848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9946	1716141439848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141440849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141440849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9946	1716141440849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141441851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141441851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141441851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141442853	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141442853	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141442853	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141443855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141443855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141443855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141444857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141444857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9943	1716141444857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141445859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141445859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9943	1716141445859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141446861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141446861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9943	1716141446861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141447863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141447863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141447863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141448864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141448864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141448864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141449866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141449866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141449866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141450868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141429843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141430856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141431854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141432859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141433860	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141434852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141435863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141436861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141437866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141438858	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141439866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141440871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141441875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141442875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141443878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141444870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141445882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141446884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141447884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141448887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141449880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141450889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141451891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141452893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141453896	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141454901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141455899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141456901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141457902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141458901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141459899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141460908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141461910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141462916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141463914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141464908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141465917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141466921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141467924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141468927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141469918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932999999999998	1716141487940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141488942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141488942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9932999999999998	1716141488942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141489944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141489944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141489944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141490946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141490946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141490946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141491948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141491948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9962	1716141491948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141492950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141492950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9950999999999999	1716141492950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141492972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141493952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141493952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9950999999999999	1716141493952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141493973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141494954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141494954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9950999999999999	1716141494954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141450868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141450868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141451870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141451870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141451870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141452872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141452872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141452872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141453874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141453874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9986	1716141453874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141454876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.1	1716141454876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9986	1716141454876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141455878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.4	1716141455878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9986	1716141455878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141456880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141456880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141456880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141457882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141457882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141457882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141458883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141458883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141458883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141459885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141459885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141459885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141460887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141460887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141460887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141461889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141461889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9921	1716141461889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141462890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141462890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9934	1716141462890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141463892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141463892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9934	1716141463892	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141464894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141464894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9934	1716141464894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141465896	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141465896	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141465896	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141466898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141466898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141466898	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141467900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141467900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9947000000000001	1716141467900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141468902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141468902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9952	1716141468902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141469904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141469904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9952	1716141469904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141487966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141488956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141489958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141490970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141491971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141494968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141495980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141496980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141497981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141498974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141499986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141500987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141501988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141502990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141503992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141504985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141505997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141506998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141507999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141509003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141509997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141511000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141512009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141513012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141514012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141515012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141516014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141517017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141518023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141519020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141520014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141521025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141522025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141523028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141524030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141525026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141526032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141527027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141528031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141529041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142071056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142071056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142071056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142072058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142072058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142072058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142073059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142073059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142073059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142074061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142074061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142074061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142075063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142075063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142075063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142076065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142076065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142076065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142077067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142077067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1049	1716142077067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142078069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142078069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1010999999999997	1716142078069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142079071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142079071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1010999999999997	1716142079071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142080073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142080073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1010999999999997	1716142080073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141495956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141495956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141495956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141496958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141496958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141496958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141497960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141497960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141497960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141498962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141498962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141498962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141499963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141499963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141499963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141500965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141500965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141500965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141501967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141501967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141501967	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141502969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141502969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141502969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141503971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141503971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141503971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141504973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141504973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141504973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141505975	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141505975	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141505975	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141506977	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141506977	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9929000000000001	1716141506977	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141507979	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141507979	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9941	1716141507979	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141508981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141508981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9941	1716141508981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141509982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141509982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9941	1716141509982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141510984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141510984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9944000000000002	1716141510984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141511986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141511986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9944000000000002	1716141511986	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141512988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141512988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9944000000000002	1716141512988	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141513990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141513990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.995	1716141513990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141514992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141514992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.995	1716141514992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141515993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141515993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.995	1716141515993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141516995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141516995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141516995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141517997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141517997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141517997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141518999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141518999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141518999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141520000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141520000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141520000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141521002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141521002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141521002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141522004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141522004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141522004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141523006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141523006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141523006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141524008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141524008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141524008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141525010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141525010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9955999999999998	1716141525010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141526012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141526012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141526012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141527014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141527014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141527014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141528015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141528015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9923	1716141528015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141529017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141529017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141529017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141530019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141530019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141530019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141530033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141531021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141531021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141531021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141531042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141532023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141532023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.996	1716141532023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141532043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141533025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141533025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.996	1716141533025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141533039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141534027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141534027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.996	1716141534027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141534049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141535029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141535029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.997	1716141535029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141535046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141536030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141536030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.997	1716141536030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141537032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141537032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.997	1716141537032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141538034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141538034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141538034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141539036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141539036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141539036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141540038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141540038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141540038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141541040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141541040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141541040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141542042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141542042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141542042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141543044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141543044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141543044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141544045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141544045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972999999999999	1716141544045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141545047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141545047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972999999999999	1716141545047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141546049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141546049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972999999999999	1716141546049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141547050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141547050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141547050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141548052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141548052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141548052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141549054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141549054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9974	1716141549054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141550056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141550056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141550056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141551058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141551058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141551058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141552060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141552060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.992	1716141552060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141553062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141553062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716141553062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141554063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141554063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716141554063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141555065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141555065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9961	1716141555065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141556067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141556067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141556067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141557071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141557071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141557071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141536051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141537055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141538047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141539057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141540055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141541064	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141542058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141543068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141544058	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141545069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141546062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141547071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141548076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141549070	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141550076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141551081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141552087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141553084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141554077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141555087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141556088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141557092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141558095	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141559096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141560100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141561101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141562103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141563104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141564104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141565099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141566109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141567102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141568111	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141569114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141570109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141571117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141572111	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141573121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141574122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141575116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141576118	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141577122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141578130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141579131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141580133	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141581135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141582131	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141583139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141584135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141585144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141586145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141587139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141588149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141589153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141590146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141591156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141592148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141593158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141594152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141595154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141596164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141597160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141598169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141599161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141600173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141558073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141558073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9967000000000001	1716141558073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141559074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141559074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141559074	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141560075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141560075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141560075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141561077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141561077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9983	1716141561077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141562079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141562079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9988	1716141562079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141563081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141563081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9988	1716141563081	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141564082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.2	1716141564082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9988	1716141564082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141565084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141565084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141565084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141566086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141566086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141566086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141567088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141567088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9957	1716141567088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141568090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141568090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141568090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141569092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141569092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141569092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141570094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141570094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141570094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141571096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141571096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141571096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141572097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141572097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141572097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141573100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141573100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141573100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141574102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141574102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141574102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141575103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141575103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141575103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141576105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141576105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9963	1716141576105	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141577107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141577107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9985	1716141577107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141578109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141578109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9985	1716141578109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141579110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141579110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9985	1716141579110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141580112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141580112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141580112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141581114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141581114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141581114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141582116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141582116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9984000000000002	1716141582116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141583119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141583119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141583119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141584121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141584121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141584121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141585122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141585122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141585122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141586124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141586124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141586124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141587126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141587126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141587126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141588128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141588128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141588128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141589130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716141589130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141589130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141590132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141590132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141590132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141591134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141591134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9972	1716141591134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141592135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141592135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141592135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141593137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141593137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141593137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141594139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141594139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9975	1716141594139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141595140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141595140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141595140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141596142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141596142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141596142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141597144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141597144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9978	1716141597144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141598146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141598146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9945	1716141598146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141599148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141599148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9945	1716141599148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141600150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141600150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9945	1716141600150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141601151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141601151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141601151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141602153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141602153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141602153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141603155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141603155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141603155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141604157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141604157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141604157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141605159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141605159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141605159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141606160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141606160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9964000000000002	1716141606160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141607164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141607164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141607164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141608165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141608165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141608165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141609167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141609167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9958	1716141609167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141610169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141610169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141610169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141611171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141611171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141611171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141612173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141612173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9959	1716141612173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141613175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141613175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141613175	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141614177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141614177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141614177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141615178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141615178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9977	1716141615178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141616180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141616180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.999	1716141616180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141617182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141617182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.999	1716141617182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141618184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.2	1716141618184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.999	1716141618184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141619186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.5	1716141619186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141619186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141620188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141620188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141620188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141621189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141621189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9994	1716141621189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141601174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141602167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141603178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141604171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141605180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141606173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141607178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141608188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141609190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141610182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141611191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141612186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141613197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141614201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141615193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141616196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141617195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141618209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141619209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141620210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141621204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141622206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141623216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141624218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141625212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141626221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141627216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141628224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141629217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141630221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141631233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141632223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141633231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141634235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141635236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141636229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141637231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141638247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141639238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141640237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141641241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141642242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141643251	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141644246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141645255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141646257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141647251	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141648261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141649260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141650265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141651266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141652263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141653270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141654271	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141655265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141656276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141657269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141658278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141659273	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141660277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141661284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141662280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141663289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141664290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141665293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141622191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141622191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0016	1716141622191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141623193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141623193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0016	1716141623193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141624195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141624195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0016	1716141624195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141625197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141625197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0015	1716141625197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141626199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141626199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0015	1716141626199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141627201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141627201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0015	1716141627201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141628202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141628202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0025	1716141628202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141629204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141629204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0025	1716141629204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141630206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141630206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0025	1716141630206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141631207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141631207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141631207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141632209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141632209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141632209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141633210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141633210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141633210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141634212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141634212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0018	1716141634212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141635214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141635214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0018	1716141635214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141636216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141636216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0018	1716141636216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141637218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141637218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9999	1716141637218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141638220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141638220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9999	1716141638220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141639221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141639221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9999	1716141639221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141640223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141640223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0023	1716141640223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141641226	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141641226	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0023	1716141641226	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141642228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141642228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0023	1716141642228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141643230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141643230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0032	1716141643230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141644232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141644232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0032	1716141644232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141645234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141645234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0032	1716141645234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141646236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141646236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0038	1716141646236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141647238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141647238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0038	1716141647238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141648240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141648240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0038	1716141648240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141649242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141649242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0059	1716141649242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141650243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141650243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0059	1716141650243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141651245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141651245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0059	1716141651245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141652247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141652247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0051	1716141652247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141653249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141653249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0051	1716141653249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141654250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141654250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0051	1716141654250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141655252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141655252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0049	1716141655252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141656254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141656254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0049	1716141656254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141657255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141657255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0049	1716141657255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141658257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141658257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716141658257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141659259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141659259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716141659259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141660261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141660261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0069	1716141660261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141661263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141661263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0040999999999998	1716141661263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141662265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141662265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0040999999999998	1716141662265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141663267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141663267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0040999999999998	1716141663267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141664270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141664270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.004	1716141664270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141665272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141665272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.004	1716141665272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141666274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141666274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.004	1716141666274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141667276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141667276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042	1716141667276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141668278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141668278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042	1716141668278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141669280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141669280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042	1716141669280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141670281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141670281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0055	1716141670281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141671283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141671283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0055	1716141671283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141672285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141672285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0055	1716141672285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141673287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141673287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0045	1716141673287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141674289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141674289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0045	1716141674289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141675290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141675290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0045	1716141675290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141676292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141676292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141676292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141677296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141677296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141677296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141678297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141678297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0024	1716141678297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141679299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141679299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0044	1716141679299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141680300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141680300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0044	1716141680300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141681304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141681304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0044	1716141681304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141682306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141682306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042999999999997	1716141682306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141683307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141683307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042999999999997	1716141683307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141684309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716141684309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0042999999999997	1716141684309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141685311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141685311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0056	1716141685311	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141666298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141667290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141668299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141669301	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141670295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141671306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141672300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141673308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141674302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141675304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141676314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141677309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141678321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141679320	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141680322	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141681321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141682321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141683322	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141684330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141685331	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141686327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141687332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141688344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141689341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141690335	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141691344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141692338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141693348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141694341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141695352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141696353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141697347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141698357	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141699360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141700354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141701362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141702359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141703368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141704369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141705363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141706371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141707367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141708369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141709377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142071069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142072079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142073082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142074075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142075077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142076087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142077088	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142078090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142079084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142080094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142081099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142082100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142083101	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142084096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142085103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142086107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142087108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142088110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142089110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142090107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142091114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141686313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141686313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0056	1716141686313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141687315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141687315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0056	1716141687315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141688317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141688317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716141688317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141689319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141689319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716141689319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141690320	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141690320	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0076	1716141690320	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141691323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141691323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0075	1716141691323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141692324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141692324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0075	1716141692324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141693326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141693326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0075	1716141693326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141694328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141694328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0087	1716141694328	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141695330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141695330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0087	1716141695330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141696332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141696332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0087	1716141696332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141697334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141697334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0119000000000002	1716141697334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141698336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141698336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0119000000000002	1716141698336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141699338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141699338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0119000000000002	1716141699338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141700340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.3	1716141700340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0131	1716141700340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141701341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141701341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0131	1716141701341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141702343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141702343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0131	1716141702343	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141703345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141703345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0125	1716141703345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141704347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.299999999999999	1716141704347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0125	1716141704347	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141705349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141705349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0125	1716141705349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141706351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.6	1716141706351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141706351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141707353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141707353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141707353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716141708354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	3.7	1716141708354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141708354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141709356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141709356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0148	1716141709356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141710358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141710358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0148	1716141710358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141710380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141711360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141711360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0148	1716141711360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141711382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141712362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141712362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0151	1716141712362	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141712375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141713364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141713364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0151	1716141713364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141713385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141714367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141714367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0151	1716141714367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141714381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141715369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141715369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.015	1716141715369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141715390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141716371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141716371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.015	1716141716371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141716393	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141717373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141717373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.015	1716141717373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141717394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141718375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141718375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141718375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141718397	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141719377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141719377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141719377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141719393	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141720378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141720378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141720378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141720400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141721380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141721380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0194	1716141721380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141721402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141722382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141722382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0194	1716141722382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141722403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141723384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141723384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0194	1716141723384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141723398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141724386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141724386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0167	1716141724386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141725388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141725388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0167	1716141725388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141726390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141726390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0167	1716141726390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141727392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141727392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0077000000000003	1716141727392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141728394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141728394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0077000000000003	1716141728394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141729396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141729396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0077000000000003	1716141729396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141730398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141730398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0134000000000003	1716141730398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141731399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141731399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0134000000000003	1716141731399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141732401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141732401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0134000000000003	1716141732401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141733405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141733405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141733405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141734407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141734407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141734407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141735409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141735409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141735409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141736410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141736410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0141	1716141736410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141737412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141737412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0141	1716141737412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141738414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141738414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0141	1716141738414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141739416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141739416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0169	1716141739416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141740418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141740418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0169	1716141740418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141741420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141741420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0169	1716141741420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141742423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141742423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0178	1716141742423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141743425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141743425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0178	1716141743425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141744427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141744427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0178	1716141744427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141745429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141724399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141725409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141726412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141727405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141728407	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141729409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141730419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141731422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141732423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141733422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141734422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141735431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141736431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141737434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141738437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141739430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141740439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141741441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141742446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141743446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141744446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141745450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141746451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141747455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141748455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141749460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141750461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141751461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141752461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141753465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141754468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141755471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141756473	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141757465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141758475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141759471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141760478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141761481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141762483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141763489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141764480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141765489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141766490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141767493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141768501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141769500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141770502	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141771505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141772497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141773507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141774501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141775510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141776512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141777512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141778517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141779510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141780520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141781521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141782524	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141783526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141784520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141785530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141786531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141787526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141788535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141745429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0196	1716141745429	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141746431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141746431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0196	1716141746431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141747432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141747432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0196	1716141747432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141748434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141748434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9935	1716141748434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141749436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141749436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9935	1716141749436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141750438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141750438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9935	1716141750438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141751440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141751440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0019	1716141751440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141752442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141752442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0019	1716141752442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141753444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141753444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0019	1716141753444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141754445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141754445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141754445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141755447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141755447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141755447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141756449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141756449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0177	1716141756449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141757451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141757451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0159000000000002	1716141757451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141758454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141758454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0159000000000002	1716141758454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141759456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141759456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0159000000000002	1716141759456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141760458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141760458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141760458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141761460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141761460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141761460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141762461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141762461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9982	1716141762461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141763463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141763463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141763463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141764465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141764465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141764465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141765467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141765467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.998	1716141765467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141766469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141766469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9990999999999999	1716141766469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141767471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141767471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9990999999999999	1716141767471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141768474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141768474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	1.9990999999999999	1716141768474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141769476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141769476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0058	1716141769476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141770478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141770478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0058	1716141770478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141771480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141771480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0058	1716141771480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141772482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141772482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0053	1716141772482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141773484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141773484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0053	1716141773484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141774486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141774486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0053	1716141774486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141775488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141775488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141775488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141776490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141776490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141776490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141777491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141777491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0139	1716141777491	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141778495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141778495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0179	1716141778495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141779497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141779497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0179	1716141779497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141780498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141780498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0179	1716141780498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141781501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141781501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0216	1716141781501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141782503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141782503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0216	1716141782503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141783505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1000000000000005	1716141783505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0216	1716141783505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141784506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141784506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0223	1716141784506	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141785508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141785508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0223	1716141785508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141786510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141786510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0223	1716141786510	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141787512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141787512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0249	1716141787512	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141788514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141788514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0249	1716141788514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141789516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141789516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0249	1716141789516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141790518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141790518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0264	1716141790518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141791519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141791519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0264	1716141791519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141792521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141792521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0264	1716141792521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141793523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141793523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0217	1716141793523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141794525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141794525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0217	1716141794525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141795526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141795526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0217	1716141795526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141796528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141796528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0236	1716141796528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141797530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141797530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0236	1716141797530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141798532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141798532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0236	1716141798532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141799534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141799534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0253	1716141799534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141800536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141800536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0253	1716141800536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141801538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141801538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0253	1716141801538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141802540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141802540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0225	1716141802540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141803543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141803543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0225	1716141803543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141804545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141804545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0225	1716141804545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141805546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141805546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0255	1716141805546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141806548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141806548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0255	1716141806548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141807550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141807550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0255	1716141807550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141808552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141808552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0259	1716141808552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141809554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141789530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141790539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141791533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141792535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141793544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141794538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141795551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141796549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141797552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141798555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141799549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141800557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141801562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141802561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141803565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141804560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141805567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141806570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141807572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141808574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141809567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141810576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141811579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141812580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141813583	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141814578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141815589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141816588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141817589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141818592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141819594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141820589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141821591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141822599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141823601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141824604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141825599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141826608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141827610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141828614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141829609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141830610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141831622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141832624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141833625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141834619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141835627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141836630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141837632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141838632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141839630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141840638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141841641	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141842639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141843642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141844636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141845650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141846651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141847652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141848654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141849657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141850658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141851660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141852663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141853665	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141809554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0259	1716141809554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141810556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141810556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0259	1716141810556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141811558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141811558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0265	1716141811558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141812560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141812560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0265	1716141812560	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141813561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141813561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0265	1716141813561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141814563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141814563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141814563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716141815565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141815565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141815565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141816567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141816567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141816567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141817569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141817569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0282999999999998	1716141817569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141818571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141818571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0282999999999998	1716141818571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141819573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141819573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0282999999999998	1716141819573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141820575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141820575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141820575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141821576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141821576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141821576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141822578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141822578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141822578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141823580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.4	1716141823580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141823580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141824582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141824582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141824582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141825584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141825584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141825584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141826587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141826587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0268	1716141826587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141827589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141827589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0268	1716141827589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141828591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141828591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0268	1716141828591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141829595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141829595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141829595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141830597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141830597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141830597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141831599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141831599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.028	1716141831599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141832601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141832601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141832601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141833602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141833602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141833602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141834604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141834604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0281	1716141834604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141835606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141835606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0296	1716141835606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141836608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141836608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0296	1716141836608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141837610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141837610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0296	1716141837610	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141838612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141838612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141838612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141839614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141839614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141839614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141840615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141840615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.025	1716141840615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141841617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141841617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141841617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141842619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141842619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141842619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141843621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141843621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141843621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141844623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141844623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141844623	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141845626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141845626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141845626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141846628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141846628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141846628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141847630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141847630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0307	1716141847630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141848632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141848632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0307	1716141848632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141849634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141849634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0307	1716141849634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141850636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141850636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141850636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141851639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141851639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141851639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141852640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141852640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141852640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141853642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141853642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0321	1716141853642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141854644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.4	1716141854644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0321	1716141854644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141855646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.7	1716141855646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0321	1716141855646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141856648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141856648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0316	1716141856648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141857650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141857650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0316	1716141857650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141858652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141858652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0316	1716141858652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141859654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141859654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141859654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141860656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141860656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141860656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141861657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141861657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141861657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141862659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141862659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141862659	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141863660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141863660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141863660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141864662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141864662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0311	1716141864662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141865664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141865664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141865664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141866666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141866666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141866666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141867668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141867668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141867668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141868670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141868670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141868670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141869671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141869671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141869671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141870673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141870673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141870673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141871675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141871675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141871675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141872677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141872677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141872677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141873679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141854660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141855668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141856671	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141857672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141858673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141859667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141860678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141861678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141862681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141863674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141864677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141865686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141866689	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141867688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141868691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141869686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141870688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141871695	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141872698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141873694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141874704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141875704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141876707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141877707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141878703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141879705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141880713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141881715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141882717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141883718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141884717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141885723	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141886724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141887730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141888728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141889722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142081075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142081075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1035	1716142081075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142082077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142082077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1035	1716142082077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142083079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142083079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1035	1716142083079	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142084080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142084080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1045	1716142084080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142085082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142085082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1045	1716142085082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142086084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142086084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1045	1716142086084	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142087086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142087086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142087086	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142088087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142088087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142088087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142089089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142089089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142089089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142090090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142090090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141873679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141873679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141874681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141874681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.032	1716141874681	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141875683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141875683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.032	1716141875683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141876684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141876684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.032	1716141876684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141877686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141877686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0314	1716141877686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141878688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141878688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0314	1716141878688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141879690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141879690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0314	1716141879690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141880692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141880692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0284	1716141880692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716141881694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141881694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0284	1716141881694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141882696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141882696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0284	1716141882696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141883698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141883698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141883698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141884699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141884699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141884699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141885701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141885701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0292	1716141885701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141886703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141886703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141886703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141887705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141887705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141887705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141888707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141888707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0301	1716141888707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141889709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141889709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141889709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141890711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141890711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141890711	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141890735	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141891713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716141891713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0327	1716141891713	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141891734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141892715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141892715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141892715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141892737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141893717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141893717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141893717	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141894719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141894719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0324	1716141894719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141895720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141895720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141895720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141896722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141896722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141896722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141897724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141897724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0326	1716141897724	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141898726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141898726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141898726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141899728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141899728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141899728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141900730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141900730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0332	1716141900730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141901732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141901732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0319000000000003	1716141901732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141902734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141902734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0319000000000003	1716141902734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141903736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141903736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0319000000000003	1716141903736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141904738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141904738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0345	1716141904738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141905740	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141905740	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0345	1716141905740	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141906742	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141906742	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0345	1716141906742	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141907744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141907744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141907744	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141908745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141908745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141908745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141909747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141909747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141909747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141910749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141910749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0354	1716141910749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141911750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141911750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0354	1716141911750	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141912752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141912752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0354	1716141912752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141913754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141913754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0335	1716141913754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141914756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141914756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0335	1716141914756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141893731	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141894732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141895741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141896743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141897745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141898749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141899742	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141900753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141901753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141902755	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141903749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141904759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141905761	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141906763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141907766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141908758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141909761	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141910770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141911771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141912774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141913774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141914769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141915779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141916773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141917782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141918785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141919789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141920788	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141921791	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141922793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141923794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141924790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141925797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141926799	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141927794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141928803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141929797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141930807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141931810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141932810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141933811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141934813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141935818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141936818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141937821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141938822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141939817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141940825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141941826	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141942831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141943831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141944825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141945835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141946836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141947842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141948845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141949842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141950845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141951847	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141952854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141953851	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141954845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141955855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141956857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141957853	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141915758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141915758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0335	1716141915758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141916760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141916760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0359000000000003	1716141916760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141917762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141917762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0359000000000003	1716141917762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141918763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141918763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0359000000000003	1716141918763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141919765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141919765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0356	1716141919765	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141920767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141920767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0356	1716141920767	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141921769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141921769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0356	1716141921769	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141922770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141922770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0342000000000002	1716141922770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141923772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141923772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0342000000000002	1716141923772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141924774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141924774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0342000000000002	1716141924774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141925776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141925776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0384	1716141925776	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141926777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141926777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0384	1716141926777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141927780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141927780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0384	1716141927780	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141928782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141928782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141928782	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716141929784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141929784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141929784	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141930786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141930786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141930786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141931787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141931787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.038	1716141931787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141932789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141932789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.038	1716141932789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141933790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141933790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.038	1716141933790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141934792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141934792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0389	1716141934792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141935794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141935794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0389	1716141935794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141936796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141936796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0389	1716141936796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141937798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141937798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385	1716141937798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141938800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141938800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385	1716141938800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141939802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141939802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385	1716141939802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141940803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141940803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141940803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141941805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141941805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141941805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141942807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141942807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141942807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141943809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141943809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0366	1716141943809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141944811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141944811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0366	1716141944811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141945813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141945813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0366	1716141945813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141946815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141946815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141946815	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141947817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141947817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141947817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141948819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141948819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141948819	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141949821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141949821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0395	1716141949821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141950822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141950822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0395	1716141950822	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141951825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141951825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0395	1716141951825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141952827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141952827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141952827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141953829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141953829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141953829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141954831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141954831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0383	1716141954831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141955833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141955833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0378	1716141955833	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141956836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141956836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0378	1716141956836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141957838	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141957838	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0378	1716141957838	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141958839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141958839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0382000000000002	1716141958839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141959841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141959841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0382000000000002	1716141959841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141960843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141960843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0382000000000002	1716141960843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141961845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141961845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141961845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141962848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141962848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141962848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716141963850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141963850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0408	1716141963850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141964852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141964852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0409	1716141964852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141965854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141965854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0409	1716141965854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141966855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141966855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0409	1716141966855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141967859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141967859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0402	1716141967859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141968862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141968862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0402	1716141968862	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141969865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141969865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0402	1716141969865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141970867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141970867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141970867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141971869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141971869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141971869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141972870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141972870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0373	1716141972870	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141973872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141973872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141973872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141974874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141974874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141974874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141975876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141975876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141975876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141976878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141976878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0377	1716141976878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141977880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141977880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0377	1716141977880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141978882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141978882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0377	1716141978882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141958861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141959855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141960864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141961866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141962868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141963872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141964877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141965874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141966878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141967881	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141968885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141969878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141970888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141971893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141972891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141973894	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141974888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141975897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141976893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141977905	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141978897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141979906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141980910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141981912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141982911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141983911	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141984910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141985913	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141986921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141987921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141988914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141989923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141990927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141991930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141992922	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141993925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141994927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141995937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141996939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141997939	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141998935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716141999944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142000949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142001949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142002952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142003944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142004955	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142005956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142006957	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142007959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142008960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142009962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142010965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142011969	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142012971	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142013973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142014968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142015974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142016977	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142017983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142018983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142019976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142020984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142021985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142022987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141979883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141979883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141979883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141980885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141980885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141980885	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141981887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141981887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0385999999999997	1716141981887	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141982890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141982890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141982890	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141983891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141983891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141983891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141984893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141984893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141984893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141985895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141985895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0419	1716141985895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141986897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141986897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0419	1716141986897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141987899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141987899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0419	1716141987899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141988901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141988901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0415	1716141988901	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141989903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141989903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0415	1716141989903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141990905	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141990905	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0415	1716141990905	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141991907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141991907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141991907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141992908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141992908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141992908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141993910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141993910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0394	1716141993910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716141994912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141994912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.048	1716141994912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716141995914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141995914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.048	1716141995914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141996916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141996916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.048	1716141996916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141997918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716141997918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0495	1716141997918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716141998921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716141998921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0495	1716141998921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716141999923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716141999923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0495	1716141999923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142000925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716142000925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0509	1716142000925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142001927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.5	1716142001927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0509	1716142001927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142002928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.8	1716142002928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0509	1716142002928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142003930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142003930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.042	1716142003930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142004932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142004932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.042	1716142004932	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142005934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142005934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.042	1716142005934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142006936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142006936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.055	1716142006936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142007938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142007938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.055	1716142007938	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142008940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142008940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.055	1716142008940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142009941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142009941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0601	1716142009941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142010943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142010943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0601	1716142010943	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142011945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142011945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0601	1716142011945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142012947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142012947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0604	1716142012947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142013949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142013949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0604	1716142013949	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142014951	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142014951	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0604	1716142014951	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142015953	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142015953	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0627	1716142015953	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142016955	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142016955	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0627	1716142016955	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142017957	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142017957	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0627	1716142017957	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142018959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142018959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0682	1716142018959	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142019961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142019961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0682	1716142019961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142020962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142020962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0682	1716142020962	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142021964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142021964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0761	1716142021964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142022966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142022966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0761	1716142022966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142023968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142023968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0761	1716142023968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142024970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142024970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0739	1716142024970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142025972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142025972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0739	1716142025972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142026974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142026974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0739	1716142026974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142027976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142027976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0845	1716142027976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142028978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142028978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0845	1716142028978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142029980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142029980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0845	1716142029980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142030981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142030981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0916	1716142030981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142031983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142031983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0916	1716142031983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142032985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142032985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0916	1716142032985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142033987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142033987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0909	1716142033987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142034989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142034989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0909	1716142034989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142035990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142035990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0909	1716142035990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142036992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142036992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.099	1716142036992	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142037994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142037994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.099	1716142037994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142038996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142038996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.099	1716142038996	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142039998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142039998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1025	1716142039998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142041000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142041000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1025	1716142041000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142042002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142042002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1025	1716142042002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142043004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142043004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1044	1716142043004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142023991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142024991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142025993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142027001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142028001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142029000	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142029994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142031002	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142032006	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142033008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142034008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142035004	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142036013	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142037005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142038019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142039012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142040019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142041022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142042023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142043028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142044032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142045022	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142046032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142047031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142048033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142049036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142050031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142051041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142052046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142053045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142054048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142055048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142056050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142057054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142058045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142059055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142060049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142061060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142062060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142063063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142064066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142065060	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142066068	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142067071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142068071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142069065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142070076	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1058000000000003	1716142090090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142091092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142091092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1058000000000003	1716142091092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142092094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142092094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1058000000000003	1716142092094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142093097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142093097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1069	1716142093097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142094099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142094099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1069	1716142094099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142095100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142095100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1069	1716142095100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142096102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142096102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142044005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142044005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1044	1716142044005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142045007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142045007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1044	1716142045007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142046009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142046009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1001999999999996	1716142046009	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142047010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142047010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1001999999999996	1716142047010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142048012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142048012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1003000000000003	1716142048012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142049014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142049014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1003000000000003	1716142049014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142050017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142050017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1003000000000003	1716142050017	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142051019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142051019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1016999999999997	1716142051019	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142052021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142052021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1016999999999997	1716142052021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142053023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142053023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1016999999999997	1716142053023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142054024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142054024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1013	1716142054024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142055026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142055026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1013	1716142055026	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142056028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142056028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1013	1716142056028	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142057030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142057030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1019	1716142057030	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142058032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142058032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1019	1716142058032	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142059034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142059034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1019	1716142059034	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142060036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142060036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142060036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142061038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142061038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142061038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142062040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142062040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142062040	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142063041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142063041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142063041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142064043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142064043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142064043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142065045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142065045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1024000000000003	1716142065045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142066047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142066047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1018000000000003	1716142066047	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142067049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142067049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1018000000000003	1716142067049	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142068050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142068050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1018000000000003	1716142068050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142069052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142069052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142069052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142070054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142070054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1053	1716142070054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142092115	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142093120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142094121	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142095116	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1083000000000003	1716142096102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142096126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142097104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142097104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1083000000000003	1716142097104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142097125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142098106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142098106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1083000000000003	1716142098106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142098127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142099108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142099108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0936	1716142099108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142099123	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142100110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142100110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0936	1716142100110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142100132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142101112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142101112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0936	1716142101112	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142101136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142102114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142102114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1077	1716142102114	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142102135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142103117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142103117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1077	1716142103117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142103138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142104119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142104119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1077	1716142104119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142104142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142105120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142105120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1081	1716142105120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142105137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142106122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142106122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1081	1716142106122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142106145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142107124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142107124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1081	1716142107124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142108126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142108126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1089	1716142108126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142109128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142109128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1089	1716142109128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142110130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142110130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1089	1716142110130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142111132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142111132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1075999999999997	1716142111132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142112134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142112134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1075999999999997	1716142112134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142113135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142113135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1075999999999997	1716142113135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142114137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142114137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142114137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142115139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142115139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142115139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142116140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142116140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142116140	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142117142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142117142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1102	1716142117142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142118144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142118144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1102	1716142118144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142119146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142119146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1102	1716142119146	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142120148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142120148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1128	1716142120148	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142121149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142121149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1128	1716142121149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142122151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142122151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1128	1716142122151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142123153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142123153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142123153	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142124155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142124155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142124155	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142125157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142125157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142125157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142126159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142126159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142126159	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142127160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142127160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142127160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142128162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142128162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142107144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142108150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142109151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142110144	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142111152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142112156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142113156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142114158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142115160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142116161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142117165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142118158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142119167	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142120161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142121173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142122174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142123174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142124177	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142125170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142126184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142127182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142128184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142129185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142130182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142131189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142132191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142133195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142134195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142135190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142136199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142137203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142138205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142139205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142140198	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142141202	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142142204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142143213	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142144213	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142145215	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142146220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142147211	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142148221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142149215	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142150225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142151226	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142152227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142153230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142154224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142155233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142156235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142157239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142158239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142159242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142160245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142161245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142162247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142163251	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142164250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142165249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142166260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142167259	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142168260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142169261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142170258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142171266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1093	1716142128162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142129164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142129164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1078	1716142129164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142130166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142130166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1078	1716142130166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142131168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142131168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1078	1716142131168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142132169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142132169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1103	1716142132169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142133171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142133171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1103	1716142133171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142134174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142134174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1103	1716142134174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142135176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142135176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142135176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142136178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142136178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142136178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142137179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142137179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142137179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142138181	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142138181	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142138181	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142139183	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142139183	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142139183	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142140185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142140185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1107	1716142140185	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142141187	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142141187	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1147	1716142141187	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142142189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142142189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1147	1716142142189	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142143190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142143190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1147	1716142143190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142144192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142144192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1087	1716142144192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142145194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142145194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1087	1716142145194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142146196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142146196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1087	1716142146196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142147198	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142147198	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1101	1716142147198	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142148200	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142148200	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1101	1716142148200	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142149201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142149201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1101	1716142149201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142150203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	6.9	1716142150203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142150203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142151205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142151205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142151205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142152207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.6	1716142152207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142152207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142153209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142153209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1125	1716142153209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142154210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142154210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1125	1716142154210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142155212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142155212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1125	1716142155212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142156214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142156214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1111	1716142156214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142157216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142157216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1111	1716142157216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142158218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142158218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1111	1716142158218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142159220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142159220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1132	1716142159220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142160222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142160222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1132	1716142160222	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142161224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142161224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1132	1716142161224	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142162225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142162225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142162225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142163227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142163227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142163227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142164230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142164230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115999999999997	1716142164230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142165233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142165233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1109	1716142165233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142166235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142166235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1109	1716142166235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142167237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142167237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1109	1716142167237	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142168239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142168239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.114	1716142168239	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142169241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142169241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.114	1716142169241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142170243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142170243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.114	1716142170243	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142171244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142171244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151999999999997	1716142171244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142172246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142172246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151999999999997	1716142172246	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142173248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142173248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151999999999997	1716142173248	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142174250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142174250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142174250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142175252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142175252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142175252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142176254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142176254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142176254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142177256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142177256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142177256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142178258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142178258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142178258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142179260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142179260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142179260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142180262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142180262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1134	1716142180262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142181264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142181264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1134	1716142181264	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142182265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142182265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1134	1716142182265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142183267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142183267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142183267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142184269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142184269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142184269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142185270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142185270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142185270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142186272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142186272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1149	1716142186272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142187276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142187276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1149	1716142187276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142188278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142188278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1149	1716142188278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142189281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142189281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1124	1716142189281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142190283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142190283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1124	1716142190283	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142191285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142191285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1124	1716142191285	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142192287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142192287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142172269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142173275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142174271	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142175275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142176275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142177269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142178278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142179280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142180275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142181276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142182284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142183292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142184291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142185284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142186296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142187300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142188299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142189302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142190298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142191306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142192303	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142193310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142194314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142195306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142196308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142197317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142198321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142199321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142200316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142201327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142202327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142203323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142204325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142205334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142206337	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142207334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142208341	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142209336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142210345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142211345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142212349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142213350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142214344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142215354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142216357	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142217350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142218360	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142219363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142220363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142221365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142222361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142223368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142224373	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142225368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142226369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142227371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142228382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142229385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142230381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142231389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142232384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142233394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142234395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142235396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142236398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142192287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142193288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142193288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142193288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142194290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142194290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142194290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142195292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142195292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142195292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142196294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142196294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142196294	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142197296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142197296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142197296	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142198298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142198298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1130999999999998	1716142198298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142199300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142199300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1130999999999998	1716142199300	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142200302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142200302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1130999999999998	1716142200302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142201304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142201304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1121999999999996	1716142201304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142202307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142202307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1121999999999996	1716142202307	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142203309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142203309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1121999999999996	1716142203309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142204310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142204310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1146	1716142204310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142205312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142205312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1146	1716142205312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142206314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142206314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1146	1716142206314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142207318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142207318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142207318	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142208319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142208319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142208319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142209321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142209321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1135	1716142209321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142210323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142210323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115	1716142210323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142211325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142211325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115	1716142211325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142212327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142212327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1115	1716142212327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142213329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142213329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1113000000000004	1716142213329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142214331	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142214331	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1113000000000004	1716142214331	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142215333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142215333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1113000000000004	1716142215333	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142216334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142216334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.115	1716142216334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142217336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142217336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.115	1716142217336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142218338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142218338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.115	1716142218338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142219340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142219340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142219340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142220342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142220342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142220342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142221344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142221344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142221344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142222346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142222346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142222346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142223348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142223348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142223348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142224351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142224351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1141	1716142224351	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142225354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142225354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142225354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142226356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142226356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142226356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142227358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142227358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142227358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142228361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142228361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1154	1716142228361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142229363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142229363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1154	1716142229363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142230366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142230366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1154	1716142230366	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142231368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142231368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1118	1716142231368	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142232370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142232370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1118	1716142232370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142233372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142233372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1118	1716142233372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142234374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142234374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142234374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142235376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142235376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142235376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142236378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142236378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1138000000000003	1716142236378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142237379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142237379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142237379	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142238381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142238381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142238381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142239383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142239383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1139	1716142239383	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142240385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142240385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1114	1716142240385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142241387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142241387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1114	1716142241387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142242389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142242389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1114	1716142242389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142243391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142243391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142243391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142244392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142244392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142244392	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142245394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142245394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142245394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142246396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142246396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1170999999999998	1716142246396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142247398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142247398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1170999999999998	1716142247398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142248400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142248400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1170999999999998	1716142248400	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142249402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142249402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142249402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142250404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142250404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142250404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142251406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142251406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142251406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142252408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142252408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142252408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142253410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142253410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142253410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142254412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142254412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1143	1716142254412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142255413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142255413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142255413	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142256415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142256415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142237395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142238405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142239398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142240406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142241403	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142242402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142243412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142244406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142245415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142246418	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142247414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142248420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142249423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142250425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142251427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142252421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142253431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142254426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142255435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142256438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142257431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142258442	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142259435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142260437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142261446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142262445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142263454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142264443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142265455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142266455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142267450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142268461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142269467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142270455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142271466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142272459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142273470	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142274471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142275465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142276474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142277469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142278478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142279475	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142280481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142281485	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142282477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142283488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142284483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142285493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142286494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142287488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142288498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142289494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142290501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142291503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142292500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142293501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142294504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142295511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142296514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142297513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142298515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142299511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142300518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142301520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142256415	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142257417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142257417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1145	1716142257417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142258419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142258419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1157	1716142258419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142259421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142259421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1157	1716142259421	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142260423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142260423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1157	1716142260423	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142261425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142261425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.116	1716142261425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142262427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142262427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.116	1716142262427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142263428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142263428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.116	1716142263428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142264430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142264430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1164	1716142264430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142265432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142265432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1164	1716142265432	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142266434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142266434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1164	1716142266434	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142267436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142267436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1163000000000003	1716142267436	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142268438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142268438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1163000000000003	1716142268438	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142269440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142269440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1163000000000003	1716142269440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142270441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142270441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142270441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142271443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142271443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142271443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142272445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142272445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1176999999999997	1716142272445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142273447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142273447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0976999999999997	1716142273447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142274449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142274449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0976999999999997	1716142274449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142275451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142275451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.0976999999999997	1716142275451	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142276453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142276453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142276453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142277455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142277455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142277455	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142278457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142278457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142278457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142279459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142279459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1168	1716142279459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142280460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142280460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1168	1716142280460	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142281462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142281462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1168	1716142281462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142282464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142282464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151	1716142282464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142283466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142283466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151	1716142283466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142284468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142284468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1151	1716142284468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142285470	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142285470	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1178000000000003	1716142285470	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142286472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142286472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1178000000000003	1716142286472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142287474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142287474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1178000000000003	1716142287474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142288476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142288476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1155999999999997	1716142288476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142289477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142289477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1155999999999997	1716142289477	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142290480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142290480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1155999999999997	1716142290480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142291481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142291481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1188000000000002	1716142291481	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142292483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142292483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1188000000000002	1716142292483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142293485	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142293485	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1188000000000002	1716142293485	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142294487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142294487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1208	1716142294487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142295489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142295489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1208	1716142295489	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142296490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142296490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1208	1716142296490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142297492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142297492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195999999999997	1716142297492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142298494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142298494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195999999999997	1716142298494	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142299496	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142299496	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195999999999997	1716142299496	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142300498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142300498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.12	1716142300498	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142301500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7	1716142301500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.12	1716142301500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142302501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.7	1716142302501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.12	1716142302501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142303503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142303503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1198	1716142303503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142304505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142304505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1198	1716142304505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142305507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142305507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1198	1716142305507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142306509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142306509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142306509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142307511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142307511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142307511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142308513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142308513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142308513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142309515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142309515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1206	1716142309515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142790431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142790431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142790431	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142791433	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142791433	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142791433	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142792435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142792435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1468000000000003	1716142792435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142793437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142793437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1468000000000003	1716142793437	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142794439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142794439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1468000000000003	1716142794439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142795441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142795441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.147	1716142795441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142796443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142796443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.147	1716142796443	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142797444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142797444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.147	1716142797444	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142798446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142798446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142798446	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142799448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142799448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142799448	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142800450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142800450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142302523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142303525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142304526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142305530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142306530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142307532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142308534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142309528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142310516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142310516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1206	1716142310516	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142310538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142311518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142311518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1206	1716142311518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142311542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142312519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142312519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142312519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142312540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142313521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142313521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142313521	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142313537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142314523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142314523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142314523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142314537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142315525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142315525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.121	1716142315525	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142315548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142316528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142316528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.121	1716142316528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142316549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142317529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142317529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.121	1716142317529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142317551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142318531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142318531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.118	1716142318531	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142318556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142319533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142319533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.118	1716142319533	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142319547	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142320535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	5.8	1716142320535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.118	1716142320535	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142320556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142321537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142321537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142321537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142321558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142322539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142322539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142322539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142322559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142323540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142323540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1172	1716142323540	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142323561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142324542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142324542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1212	1716142324542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142325544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142325544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1212	1716142325544	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142326546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142326546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1212	1716142326546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142327548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142327548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142327548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142328549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142328549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142328549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142329551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142329551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142329551	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142330553	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142330553	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142330553	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142331555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142331555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142331555	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142332557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142332557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1215	1716142332557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142333559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142333559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142333559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142334561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142334561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142334561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142335563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142335563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142335563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142336565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142336565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142336565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142337566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142337566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142337566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142338569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142338569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142338569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142339570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142339570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195	1716142339570	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142340572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142340572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195	1716142340572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142341574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142341574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1195	1716142341574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142342576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142342576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1197	1716142342576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142343578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142343578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1197	1716142343578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142344580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142344580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1197	1716142344580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142345582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142324558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142325565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142326566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142327569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142328572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142329566	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142330578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142331578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142332579	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142333580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142334577	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142335584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142336589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142337589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142338590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142339585	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142340588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142341598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142342600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142343592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142344594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142345603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142346607	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142347606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142348604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142349603	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142350613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142351614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142352616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142353617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142354619	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142355622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142356625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142357627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142358622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142359624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142360631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142361631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142362638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142363637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142364630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142365639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142366644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142367646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142368646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142369648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142370649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142371652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142372650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142373648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142374649	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142375660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142376660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142377662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142378663	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142379660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142380667	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142381674	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142382673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142383678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142384676	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142385678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142386679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142387683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142388677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142345582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142345582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142346584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142346584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142346584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142347586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142347586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142347586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142348587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142348587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142348587	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142349589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142349589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142349589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142350591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142350591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142350591	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142351593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142351593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142351593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142352595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142352595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142352595	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142353597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142353597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142353597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142354599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142354599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142354599	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142355600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142355600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142355600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142356602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142356602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142356602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142357605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142357605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1201	1716142357605	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142358606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142358606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1201	1716142358606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142359608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142359608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1201	1716142359608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142360609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142360609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142360609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142361611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142361611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142361611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142362613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142362613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1204	1716142362613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142363615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142363615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1224000000000003	1716142363615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142364616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142364616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1224000000000003	1716142364616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142365618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142365618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1224000000000003	1716142365618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142366620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142366620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1210999999999998	1716142366620	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142367622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142367622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1210999999999998	1716142367622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142368624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142368624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1210999999999998	1716142368624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142369626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142369626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142369626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142370628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142370628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142370628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142371629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142371629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142371629	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142372631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142372631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1237	1716142372631	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142373633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142373633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1237	1716142373633	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142374635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142374635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1237	1716142374635	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142375637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142375637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231999999999998	1716142375637	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142376639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142376639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231999999999998	1716142376639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142377640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142377640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231999999999998	1716142377640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142378642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142378642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142378642	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142379644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142379644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142379644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142380646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142380646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142380646	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142381648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142381648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1194	1716142381648	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142382650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142382650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1194	1716142382650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142383652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142383652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1194	1716142383652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142384654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142384654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.123	1716142384654	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142385656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142385656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.123	1716142385656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142386658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142386658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.123	1716142386658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142387660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142387660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1258000000000004	1716142387660	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142388662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142388662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1258000000000004	1716142388662	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142389664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142389664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1258000000000004	1716142389664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142390666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142390666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142390666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142391668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142391668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142391668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142392670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142392670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142392670	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142393672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142393672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.126	1716142393672	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142394673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142394673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.126	1716142394673	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142395675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142395675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.126	1716142395675	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142396677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142396677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142396677	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142397679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142397679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142397679	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142398680	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142398680	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142398680	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142399682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142399682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142399682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142400684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142400684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142400684	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142401686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142401686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142401686	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142402688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142402688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142402688	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142403690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142403690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142403690	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142404692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142404692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142404692	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142405694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142405694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1249000000000002	1716142405694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142406696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142406696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1249000000000002	1716142406696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142407697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142407697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1249000000000002	1716142407697	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142408699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142408699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1228000000000002	1716142408699	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142409701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142389678	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142390687	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142391682	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142392683	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142393694	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142394691	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142395696	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142396698	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142397700	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142398704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142399704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142400710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142401704	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142402715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142403712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142404706	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142405715	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142406720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142407719	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142408722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142409718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142410726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142411720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142412730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142413733	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142414728	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142415734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142416737	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142417738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142418740	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142419734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142420745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142421745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142422739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142423748	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142424743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142425751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142426753	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142427754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142428759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142429759	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142430760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142431763	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142432764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142433766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142434760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142435773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142436772	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142437774	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142438778	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142439770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142440781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142441781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142442775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142443786	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142444789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142445794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142446791	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142447792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142448797	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142449795	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142450793	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142451801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142452804	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142453801	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142409701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1228000000000002	1716142409701	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142410703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142410703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1228000000000002	1716142410703	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142411705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142411705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142411705	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142412707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142412707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142412707	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142413709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142413709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142413709	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142414710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142414710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142414710	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142415712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142415712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142415712	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142416714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142416714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1213	1716142416714	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142417716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142417716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1218000000000004	1716142417716	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142418718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142418718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1218000000000004	1716142418718	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142419720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142419720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1218000000000004	1716142419720	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142420722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142420722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241	1716142420722	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142421723	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142421723	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241	1716142421723	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142422726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142422726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241	1716142422726	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142423727	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142423727	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142423727	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142424729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142424729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142424729	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142425730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142425730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1214	1716142425730	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142426732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142426732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142426732	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142427734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142427734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142427734	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142428736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142428736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142428736	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142429738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142429738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142429738	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142430739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142430739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142430739	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142431741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142431741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142431741	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142432743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142432743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142432743	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142433745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142433745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142433745	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142434747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142434747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142434747	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142435749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142435749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142435749	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142436751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142436751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142436751	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142437752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142437752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1235999999999997	1716142437752	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142438754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142438754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142438754	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142439756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142439756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142439756	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142440758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142440758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1238	1716142440758	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142441760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142441760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1250999999999998	1716142441760	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142442762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142442762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1250999999999998	1716142442762	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142443764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142443764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1250999999999998	1716142443764	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142444766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.1	1716142444766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142444766	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142445768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.799999999999999	1716142445768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142445768	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142446770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142446770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1223	1716142446770	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716142447771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142447771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142447771	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142448773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142448773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142448773	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142449775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142449775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1219	1716142449775	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142450777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142450777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.125	1716142450777	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142451779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142451779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.125	1716142451779	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142452781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142452781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.125	1716142452781	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142453783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142453783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1244	1716142453783	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142454785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142454785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1244	1716142454785	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142455787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142455787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1244	1716142455787	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142456789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142456789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142456789	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142457790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142457790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142457790	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142458792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142458792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1231	1716142458792	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142459794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142459794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142459794	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142460796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142460796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142460796	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142461798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142461798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1248	1716142461798	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142462800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142462800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1281999999999996	1716142462800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142463802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142463802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1281999999999996	1716142463802	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142464803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142464803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1281999999999996	1716142464803	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716142465805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142465805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1247	1716142465805	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142466807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142466807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1247	1716142466807	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142467809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142467809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1247	1716142467809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142468810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142468810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142468810	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142469812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142469812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142469812	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142470814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142470814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1243000000000003	1716142470814	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142471816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142471816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1265	1716142471816	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142472818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142472818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1265	1716142472818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142473820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142454800	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142455809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142456809	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142457811	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142458813	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142459817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142460818	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142461821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142462821	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142463826	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142464817	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142465827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142466828	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142467831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142468831	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142469825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142470835	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142471829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142472839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142473842	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142474840	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142475845	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142476849	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142477853	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142478855	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142479848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142480857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142481859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142482860	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142483864	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142484857	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142485866	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142486868	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142487869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142488873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142489873	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142490875	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142491878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142492883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142493883	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142494877	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142495886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142496888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142497889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142498891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142499886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142500895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142501899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142502900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142503902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142504903	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142505907	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142506909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142507909	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142508910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142509904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142510915	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142511917	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142512919	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142513926	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142514913	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142515923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142516928	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142517921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142518924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142473820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1265	1716142473820	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142474823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142474823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142474823	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142475825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142475825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142475825	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142476827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142476827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142476827	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142477829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142477829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142477829	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142478830	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142478830	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142478830	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142479832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142479832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142479832	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142480834	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142480834	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142480834	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142481836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142481836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142481836	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142482839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142482839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142482839	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142483841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142483841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142483841	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142484843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142484843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142484843	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142485844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142485844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142485844	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142486846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142486846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142486846	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142487848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142487848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142487848	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142488850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142488850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142488850	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142489852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142489852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1275	1716142489852	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142490854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142490854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1275	1716142490854	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142491856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142491856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1275	1716142491856	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142492859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142492859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1256999999999997	1716142492859	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142493861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.3	1716142493861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1256999999999997	1716142493861	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142494863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142494863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1256999999999997	1716142494863	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142495865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142495865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1269	1716142495865	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142496867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142496867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1269	1716142496867	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142497869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142497869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1269	1716142497869	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142498871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142498871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142498871	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142499872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142499872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142499872	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142500874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142500874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142500874	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142501876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142501876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241999999999996	1716142501876	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142502878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142502878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241999999999996	1716142502878	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142503880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142503880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1241999999999996	1716142503880	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142504882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142504882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142504882	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142505884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142505884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142505884	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142506886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142506886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1253	1716142506886	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142507888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142507888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142507888	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142508889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142508889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142508889	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142509891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142509891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1264000000000003	1716142509891	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142510893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142510893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1255	1716142510893	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142511895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142511895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1255	1716142511895	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142512897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142512897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1255	1716142512897	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142513899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142513899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142513899	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142514900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142514900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142514900	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142515902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142515902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142515902	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142516904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142516904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142516904	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142517906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142517906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142517906	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142518908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142518908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1289000000000002	1716142518908	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142519910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142519910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1299	1716142519910	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142520912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142520912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1299	1716142520912	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142521914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142521914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1299	1716142521914	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142522916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142522916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1304000000000003	1716142522916	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142523918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142523918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1304000000000003	1716142523918	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142524919	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142524919	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1304000000000003	1716142524919	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142525921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142525921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1301	1716142525921	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142526923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142526923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1301	1716142526923	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142527925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142527925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1301	1716142527925	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142528927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142528927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142528927	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142529929	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142529929	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142529929	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142530931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142530931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142530931	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142531933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142531933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1271	1716142531933	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142532935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142532935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1271	1716142532935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142533937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142533937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1271	1716142533937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142534941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142534941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142534941	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142535942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142535942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142535942	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142536944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142536944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1292	1716142536944	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142537946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142519924	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142520934	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142521935	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142522930	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142523937	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142524936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142525936	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142526947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142527947	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142528940	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142529945	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142530954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142531955	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142532960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142533952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142534954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142535964	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142536966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142537968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142538965	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142539963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142540973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142541976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142542981	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142543973	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142544975	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142545980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142546985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142547990	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142548983	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142549984	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142790447	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142791457	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142792456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142793450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142794454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142795462	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142796464	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142797466	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142798468	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142799463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142800472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142801474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142802478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142803478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142804472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142805483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142806483	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142807484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142808482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142809487	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142810482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142811493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142812472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142812472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142812472	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142812495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142813474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142813474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142813474	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142813495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142814476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.9	1716142814476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142814476	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142814500	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142537946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1277	1716142537946	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142538948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142538948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1277	1716142538948	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142539950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142539950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1277	1716142539950	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142540952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142540952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1287	1716142540952	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142541954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142541954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1287	1716142541954	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142542956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142542956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1287	1716142542956	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142543958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142543958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142543958	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142544960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142544960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142544960	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142545961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142545961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1293	1716142545961	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142546963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142546963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142546963	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142547966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142547966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142547966	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142548968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142548968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1294	1716142548968	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142549970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142549970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142549970	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142550972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142550972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142550972	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142550993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142551974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142551974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142551974	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142551994	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142552976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142552976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.129	1716142552976	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142552998	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142553978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142553978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.129	1716142553978	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142554001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142554980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142554980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.129	1716142554980	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142554993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142555982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142555982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142555982	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142556003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142556985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142556985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142556985	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142557987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142557987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1263	1716142557987	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142558989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142558989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142558989	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142559991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142559991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142559991	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142560993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142560993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1286	1716142560993	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142561995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142561995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.13	1716142561995	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142562997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142562997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.13	1716142562997	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142563999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142563999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.13	1716142563999	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142565001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142565001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1307	1716142565001	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142566003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142566003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1307	1716142566003	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142567005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	8.9	1716142567005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1307	1716142567005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142568007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.2	1716142568007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1361	1716142568007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142569008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142569008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1361	1716142569008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142570010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142570010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1355	1716142570010	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142571012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142571012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1355	1716142571012	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142572014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142572014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1355	1716142572014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142573016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142573016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142573016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142574018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142574018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142574018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142575020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142575020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142575020	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142576021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142576021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1353	1716142576021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142577023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142577023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1353	1716142577023	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142578025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142578025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1353	1716142578025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142557007	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142558008	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142559011	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142560005	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142561015	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142562016	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142563018	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142564021	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142565014	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142566025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142567025	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142568027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142569029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142570024	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142571035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142572036	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142573038	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142574039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142575033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142576045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142577045	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142578039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142579051	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142580043	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142581054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142582055	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142583059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142584059	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142585053	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142586062	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142587065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142588066	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142589069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142590061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142591073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142592075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142593075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142594077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142595072	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142596082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142597077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142598087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142599089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142600083	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142601092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142602097	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142603098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142604099	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142605095	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142606103	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142607107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142608108	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142609110	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142610104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142611113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142612109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142613117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142614120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142615117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142616117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142617126	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142618128	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142619129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142620125	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142621132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142579027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142579027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1361	1716142579027	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142580029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142580029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1361	1716142580029	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142581031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142581031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1361	1716142581031	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142582033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142582033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.138	1716142582033	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142583035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142583035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.138	1716142583035	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142584037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142584037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.138	1716142584037	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142585039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.4	1716142585039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1358	1716142585039	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142586041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142586041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1358	1716142586041	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142587042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142587042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1358	1716142587042	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142588044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142588044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1389	1716142588044	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142589046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142589046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1389	1716142589046	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142590048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142590048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1389	1716142590048	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142591050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142591050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142591050	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142592052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142592052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142592052	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142593054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142593054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142593054	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142594056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142594056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1397	1716142594056	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142595057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142595057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1397	1716142595057	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142596061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142596061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1397	1716142596061	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142597063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142597063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1376	1716142597063	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142598065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142598065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1376	1716142598065	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142599067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142599067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1376	1716142599067	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142600069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142600069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1365	1716142600069	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142601071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142601071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1365	1716142601071	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142602073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142602073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1365	1716142602073	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142603075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142603075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401999999999997	1716142603075	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142604077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142604077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401999999999997	1716142604077	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142605080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142605080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401999999999997	1716142605080	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142606082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142606082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1382	1716142606082	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142607085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142607085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1382	1716142607085	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142608087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142608087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1382	1716142608087	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142609089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142609089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386999999999996	1716142609089	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142610090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142610090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386999999999996	1716142610090	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142611092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142611092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386999999999996	1716142611092	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142612094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142612094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1399	1716142612094	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142613096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142613096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1399	1716142613096	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142614098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142614098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1399	1716142614098	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142615100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142615100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142615100	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	105	1716142616102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9	1716142616102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142616102	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142617104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.3	1716142617104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142617104	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142618106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142618106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142618106	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142619107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142619107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142619107	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142620109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142620109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142620109	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142621111	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142621111	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1393	1716142621111	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142622113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142622113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1393	1716142622113	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142623115	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142623115	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1393	1716142623115	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142624117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142624117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142624117	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142625119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142625119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142625119	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142626120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142626120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1395	1716142626120	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142627122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142627122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142627122	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142628124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142628124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142628124	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142629127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142629127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142629127	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142630129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142630129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1408	1716142630129	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142631130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142631130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1408	1716142631130	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142632132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142632132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1408	1716142632132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142633134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142633134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142633134	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142634136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142634136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142634136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142635137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142635137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142635137	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142636139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142636139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142636139	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142637141	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142637141	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142637141	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142638143	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142638143	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1401	1716142638143	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142639145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142639145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.14	1716142639145	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142640147	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142640147	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.14	1716142640147	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142641149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142641149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.14	1716142641149	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142642151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142642151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1378000000000004	1716142642151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142622135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142623136	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142624138	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142625132	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142626142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142627135	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142628150	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142629143	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142630142	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142631154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142632154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142633157	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142634151	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142635152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142636161	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142637166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142638165	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142639166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142640163	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142641170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142642173	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142643174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142644169	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142645171	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142646172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142647182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142648184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142649183	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142650179	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142651190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142652193	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142653186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142654188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142655191	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142656194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142657195	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142658196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142659199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142660199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142661201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142662204	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142663206	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142664209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142665209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142666211	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142667213	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142668215	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142669217	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142670219	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142671220	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142672223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142673225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142674228	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142675229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142676232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142677231	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142678233	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142679235	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142680241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142681241	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142682244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142683247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142684247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142685247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142686250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142643152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142643152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1378000000000004	1716142643152	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142644154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142644154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1378000000000004	1716142644154	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142645156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142645156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1406	1716142645156	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142646158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142646158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1406	1716142646158	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142647160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142647160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1406	1716142647160	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142648162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142648162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142648162	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142649164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142649164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142649164	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142650166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142650166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1404	1716142650166	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142651168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142651168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1439	1716142651168	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142652170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142652170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1439	1716142652170	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142653172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142653172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1439	1716142653172	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142654174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142654174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142654174	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142655176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142655176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142655176	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142656178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142656178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142656178	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142657180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142657180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142657180	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142658182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142658182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142658182	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142659184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142659184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142659184	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142660186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142660186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1423	1716142660186	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142661188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142661188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1423	1716142661188	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142662190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142662190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1423	1716142662190	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142663192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142663192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1416999999999997	1716142663192	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142664194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142664194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1416999999999997	1716142664194	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142665196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142665196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1416999999999997	1716142665196	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142666197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142666197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142666197	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142667199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142667199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142667199	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142668201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142668201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1391	1716142668201	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142669203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142669203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142669203	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142670205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142670205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142670205	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142671207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142671207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142671207	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142672209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142672209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1413	1716142672209	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142673210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142673210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1413	1716142673210	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142674212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142674212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1413	1716142674212	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142675214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142675214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142675214	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142676216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142676216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142676216	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142677218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142677218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431	1716142677218	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142678219	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142678219	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431999999999998	1716142678219	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142679221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142679221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431999999999998	1716142679221	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142680223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142680223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1431999999999998	1716142680223	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142681225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142681225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1428000000000003	1716142681225	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142682227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142682227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1428000000000003	1716142682227	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142683229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142683229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1428000000000003	1716142683229	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142684230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142684230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1446	1716142684230	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142685232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142685232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1446	1716142685232	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142686234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142686234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1446	1716142686234	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142687236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142687236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1414	1716142687236	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142688238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.800000000000001	1716142688238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1414	1716142688238	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142689240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142689240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1414	1716142689240	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142690242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142690242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142690242	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142691244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142691244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142691244	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142692245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142692245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142692245	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142693247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142693247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142693247	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142694249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142694249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142694249	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142695250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142695250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142695250	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142696252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142696252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142696252	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142697254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142697254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142697254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142698256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142698256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142698256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142699258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142699258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142699258	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142700260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142700260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142700260	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142701262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142701262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142701262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142702263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142702263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142702263	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142703265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142703265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142703265	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142704267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142704267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142704267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142705269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142705269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142705269	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142706270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142706270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142706270	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142687253	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142688254	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142689256	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142690255	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142691257	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142692262	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142693261	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142694266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142695266	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142696267	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142697275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142698275	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142699276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142700274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142701278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142702278	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142703281	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142704282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142705282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142706284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142707287	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142708288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142709292	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142710290	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142711297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142712297	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142713302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142714299	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142715303	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142716302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142717306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142718309	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142719314	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142720312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142721316	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142722319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142723321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142724324	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142725323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142726326	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142727329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142728330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142729332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142730337	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142731344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142732345	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142733349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142734349	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142735346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142736346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142737348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142738350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142739353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142740353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142741353	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142742364	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142743367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142744359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142745369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142746372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142747374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142748375	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142749377	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142750371	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142751381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142707272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142707272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142707272	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142708274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142708274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1449000000000003	1716142708274	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142709276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142709276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1449000000000003	1716142709276	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142710277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142710277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1449000000000003	1716142710277	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142711280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142711280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142711280	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142712282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142712282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142712282	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142713284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142713284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142713284	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142714286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142714286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142714286	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142715288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142715288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142715288	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142716289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142716289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142716289	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142717291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142717291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471	1716142717291	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142718293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142718293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471	1716142718293	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142719295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142719295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471	1716142719295	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142720298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142720298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142720298	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142721302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142721302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142721302	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142722304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142722304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142722304	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142723306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142723306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142723306	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142724308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142724308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142724308	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142725310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142725310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142725310	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142726312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142726312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142726312	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142727313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142727313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142727313	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142728315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142728315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441	1716142728315	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142729317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142729317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1466999999999996	1716142729317	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142730319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142730319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1466999999999996	1716142730319	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142731321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142731321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1466999999999996	1716142731321	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142732323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142732323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142732323	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142733325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142733325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142733325	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142734327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142734327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142734327	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142735329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142735329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142735329	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142736330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142736330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142736330	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142737332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142737332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1419	1716142737332	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142738334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142738334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441999999999997	1716142738334	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142739336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142739336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441999999999997	1716142739336	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142740338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142740338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1441999999999997	1716142740338	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142741340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142741340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142741340	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142742342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142742342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142742342	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142743344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142743344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1433	1716142743344	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142744346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142744346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142744346	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142745348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142745348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142745348	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142746350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142746350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142746350	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142747352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142747352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1465	1716142747352	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142748354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142748354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1465	1716142748354	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142749356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142749356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1465	1716142749356	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142750358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142750358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142750358	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142751359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142751359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142751359	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142752361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.4	1716142752361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1452	1716142752361	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142753363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.1	1716142753363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142753363	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142754365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142754365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142754365	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142755367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142755367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1437	1716142755367	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142756369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142756369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142756369	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142757370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142757370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142757370	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142758372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142758372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.143	1716142758372	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142759374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142759374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1444	1716142759374	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142760376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142760376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1444	1716142760376	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142761378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142761378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1444	1716142761378	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142762380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142762380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142762380	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142763382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142763382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142763382	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142764384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142764384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142764384	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142765386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142765386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142765386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142766387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142766387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142766387	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142767389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142767389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1434	1716142767389	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142768391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142768391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142768391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142769393	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142769393	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142769393	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142770395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142770395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1448	1716142770395	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142752386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142753385	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142754386	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142755381	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142756390	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142757391	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142758394	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142759388	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142760401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142761401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142762401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142763396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142764405	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142765399	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142766409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142767409	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142768411	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142769414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142770408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142771419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142772420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142773422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142774425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142775427	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142776428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142777428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142778433	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142779425	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142780435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142781441	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142782439	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142783440	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142784435	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142785445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142786445	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142787449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142788449	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142789453	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142800450	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142801452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142801452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1474	1716142801452	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142802454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142802454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1474	1716142802454	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142803456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142803456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1474	1716142803456	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142804458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142804458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1501	1716142804458	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142805459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142805459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1501	1716142805459	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142806461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142806461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1501	1716142806461	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142807463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142807463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142807463	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142808465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142808465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142808465	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142809467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142809467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142771396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142771396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471999999999998	1716142771396	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142772398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142772398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471999999999998	1716142772398	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142773401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142773401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1471999999999998	1716142773401	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142774402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142774402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.145	1716142774402	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	99	1716142775404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142775404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.145	1716142775404	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142776406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142776406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.145	1716142776406	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142777408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142777408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142777408	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142778410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142778410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142778410	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142779412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142779412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142779412	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142780414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142780414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142780414	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142781416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142781416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142781416	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142782417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142782417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142782417	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142783419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142783419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142783419	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142784420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142784420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142784420	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142785422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142785422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1475	1716142785422	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142786424	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142786424	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142786424	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142787426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142787426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142787426	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142788428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142788428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142788428	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142789430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142789430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1445	1716142789430	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142809467	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142810469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142810469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142810469	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142811471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142811471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1464000000000003	1716142811471	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142815478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142815478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1453	1716142815478	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142816480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142816480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142816480	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142817482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142817482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142817482	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142818484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142818484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1462	1716142818484	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142819486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142819486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142819486	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142820488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142820488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142820488	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142821490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142821490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142821490	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142822492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142822492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1481	1716142822492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142823493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142823493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1481	1716142823493	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142824495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142824495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1481	1716142824495	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142825497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142825497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142825497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142826499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142826499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142826499	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142827501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142827501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1478	1716142827501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142828504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142828504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142828504	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142829505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142829505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142829505	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142830507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142830507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142830507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142831509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142831509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142831509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142832511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142832511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142832511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142833513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142833513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142833513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142834515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142834515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142834515	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142835517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142835517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142835517	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142836519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142815492	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142816501	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142817503	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142818497	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142819507	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142820508	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142821511	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142822513	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142823514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142824509	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142825518	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142826514	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142827523	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142828527	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142829519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142830527	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142831529	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142832532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142833534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142834536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142835538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142836536	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142837542	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142838543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142839538	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142840547	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142841549	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142842543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142843553	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142844548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142845557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142846562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142847556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142848558	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142849563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142836519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1492	1716142836519	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142837520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142837520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142837520	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142838522	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142838522	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142838522	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142839524	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142839524	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1435	1716142839524	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142840526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142840526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142840526	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142841528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142841528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142841528	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142842530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142842530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1469	1716142842530	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142843532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142843532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142843532	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142844534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142844534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142844534	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142845537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142845537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1485	1716142845537	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142846539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142846539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1487	1716142846539	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142847541	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142847541	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1487	1716142847541	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142848543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142848543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1487	1716142848543	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142849545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142849545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.15	1716142849545	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142850546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142850546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.15	1716142850546	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142850562	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142851548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142851548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.15	1716142851548	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142851563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142852550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142852550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1509	1716142852550	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142852571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142853552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142853552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1509	1716142853552	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142853574	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142854554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142854554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1509	1716142854554	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142854567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142855556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142855556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1514	1716142855556	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142855578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142856584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142857572	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142858575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142859578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142860589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142861589	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142862590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142863593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142864586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142865594	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142866597	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142867600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142868602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142869604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142870598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142871608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142872601	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142873612	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142874614	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142875609	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142876618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142877621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142878621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142879616	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142880625	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142881628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142882632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142883632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142884627	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142885636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142886638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142887639	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142888644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142889636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142890644	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142891647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142892650	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142893651	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142894652	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142895656	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142896657	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142897658	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142898661	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142899655	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142900664	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142901666	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Swap Memory GB	0	1716142902668	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142856557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142856557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1514	1716142856557	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142857559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142857559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1514	1716142857559	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142858561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142858561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386	1716142858561	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142859563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142859563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386	1716142859563	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142860565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142860565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1386	1716142860565	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142861567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142861567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1515	1716142861567	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142862569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142862569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1515	1716142862569	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142863571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142863571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1515	1716142863571	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142864573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142864573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521999999999997	1716142864573	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142865575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142865575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521999999999997	1716142865575	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142866576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142866576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521999999999997	1716142866576	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142867578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142867578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1503	1716142867578	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142868580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142868580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1503	1716142868580	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142869582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142869582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1503	1716142869582	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142870584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142870584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142870584	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142871586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142871586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142871586	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142872588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142872588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142872588	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142873590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142873590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1525	1716142873590	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142874592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142874592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1525	1716142874592	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142875593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142875593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1525	1716142875593	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142876596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142876596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521	1716142876596	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142877598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142877598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521	1716142877598	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142878600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142878600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1521	1716142878600	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142879602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.2	1716142879602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1517	1716142879602	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142880604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.5	1716142880604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1517	1716142880604	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142881606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142881606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1517	1716142881606	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142882608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142882608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1508000000000003	1716142882608	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142883611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142883611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1508000000000003	1716142883611	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142884613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142884613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1508000000000003	1716142884613	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142885615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142885615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142885615	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142886617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142886617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142886617	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142887618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142887618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142887618	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142888621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142888621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142888621	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	104	1716142889622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142889622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142889622	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	100	1716142890624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142890624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1505	1716142890624	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142891626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142891626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142891626	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142892628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142892628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142892628	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142893630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142893630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1524	1716142893630	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142894632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142894632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1519	1716142894632	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142895634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142895634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1519	1716142895634	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142896636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142896636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1519	1716142896636	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	102	1716142897638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142897638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1535	1716142897638	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142898640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142898640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1535	1716142898640	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142899641	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142899641	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1535	1716142899641	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142900643	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142900643	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1564	1716142900643	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	101	1716142901645	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	7.6	1716142901645	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1564	1716142901645	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - CPU Utilization	103	1716142902647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Utilization	9.299999999999999	1716142902647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
TOP - Memory Usage GB	2.1564	1716142902647	e54de1fdd68b4cb59d8a82a35ff8d33e	0	f
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
letter	0	1f8ed1a5c79346c0a2a70849cb00af1f
workload	0	1f8ed1a5c79346c0a2a70849cb00af1f
listeners	smi+top+dcgmi	1f8ed1a5c79346c0a2a70849cb00af1f
params	'"-"'	1f8ed1a5c79346c0a2a70849cb00af1f
file	cifar10.py	1f8ed1a5c79346c0a2a70849cb00af1f
workload_listener	''	1f8ed1a5c79346c0a2a70849cb00af1f
letter	0	e54de1fdd68b4cb59d8a82a35ff8d33e
workload	0	e54de1fdd68b4cb59d8a82a35ff8d33e
listeners	smi+top+dcgmi	e54de1fdd68b4cb59d8a82a35ff8d33e
params	'"-"'	e54de1fdd68b4cb59d8a82a35ff8d33e
file	cifar10.py	e54de1fdd68b4cb59d8a82a35ff8d33e
workload_listener	''	e54de1fdd68b4cb59d8a82a35ff8d33e
model	cifar10.py	e54de1fdd68b4cb59d8a82a35ff8d33e
manual	False	e54de1fdd68b4cb59d8a82a35ff8d33e
max_epoch	5	e54de1fdd68b4cb59d8a82a35ff8d33e
max_time	172800	e54de1fdd68b4cb59d8a82a35ff8d33e
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
1f8ed1a5c79346c0a2a70849cb00af1f	awesome-slug-386	UNKNOWN			daga	FAILED	1716140023950	1716140098396		active	s3://mlflow-storage/0/1f8ed1a5c79346c0a2a70849cb00af1f/artifacts	0	\N
e54de1fdd68b4cb59d8a82a35ff8d33e	(0 0) unequaled-lamb-221	UNKNOWN			daga	FINISHED	1716140235409	1716142903611		active	s3://mlflow-storage/0/e54de1fdd68b4cb59d8a82a35ff8d33e/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.source.name	file:///home/daga/radt#examples/pytorch	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.source.type	PROJECT	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.project.entryPoint	main	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.runName	awesome-slug-386	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.project.env	conda	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.project.backend	local	1f8ed1a5c79346c0a2a70849cb00af1f
mlflow.user	daga	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.source.name	file:///home/daga/radt#examples/pytorch	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.source.type	PROJECT	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.project.entryPoint	main	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.project.env	conda	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.project.backend	local	e54de1fdd68b4cb59d8a82a35ff8d33e
mlflow.runName	(0 0) unequaled-lamb-221	e54de1fdd68b4cb59d8a82a35ff8d33e
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

