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
    experiment_id integer NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[])))
);


ALTER TABLE public.experiments OWNER TO mlflow_user;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE; Schema: public; Owner: mlflow_user
--

CREATE SEQUENCE public.experiments_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.experiments_experiment_id_seq OWNER TO mlflow_user;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mlflow_user
--

ALTER SEQUENCE public.experiments_experiment_id_seq OWNED BY public.experiments.experiment_id;


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
-- Name: experiments experiment_id; Type: DEFAULT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiments ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiments_experiment_id_seq'::regclass);


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
0	Default	s3://mlflow-storage/0	active	1716279670136	1716279670136
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
SMI - Power Draw	14.77	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
SMI - Timestamp	1716280584.683	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
SMI - GPU Util	0	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
SMI - Mem Util	0	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
SMI - Mem Used	0	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
SMI - Performance State	3	1716280584702	0	f	3a51dbc69b564b259fb6b4b726f619f5
TOP - CPU Utilization	102	1716282784613	0	f	3a51dbc69b564b259fb6b4b726f619f5
TOP - Memory Usage GB	2.0402	1716282784613	0	f	3a51dbc69b564b259fb6b4b726f619f5
TOP - Memory Utilization	6.7	1716282784613	0	f	3a51dbc69b564b259fb6b4b726f619f5
TOP - Swap Memory GB	0.0003	1716282784639	0	f	3a51dbc69b564b259fb6b4b726f619f5
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1716280584432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	0	1716280584432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.2152	1716280584432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280584460	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - Power Draw	14.77	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - Timestamp	1716280584.683	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - GPU Util	0	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - Mem Util	0	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - Mem Used	0	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
SMI - Performance State	3	1716280584702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	160	1716280585434	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280585434	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.2152	1716280585434	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280585453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280586436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	9.1	1716280586436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.2152	1716280586436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280586451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280587439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280587439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4424000000000001	1716280587439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280587463	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280588441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280588441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4424000000000001	1716280588441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280588462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280589443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280589443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4424000000000001	1716280589443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280589468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280590446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280590446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4547999999999999	1716280590446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280590474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280591448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280591448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4547999999999999	1716280591448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280591481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	108	1716280592451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280592451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4547999999999999	1716280592451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280592483	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280593454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280593454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4524000000000001	1716280593454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280593483	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	107	1716280594456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280594456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4524000000000001	1716280594456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280594475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	107	1716280595458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280595458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4524000000000001	1716280595458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280595484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280596460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280596460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4509	1716280596460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280596487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	107	1716280597462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280597462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4509	1716280597462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280597489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280598465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280598465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4509	1716280598465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280598493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280599496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280600495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280601500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280602500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280603504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280604507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280605508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280606509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280607514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280608520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280609515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280610524	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280611533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280612529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280613534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280614526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280615537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280616539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280617545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280618541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280619536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280620547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280621548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280622551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280623555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280624547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280625558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280626562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280627552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280628566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280629559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280630571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280631573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280632573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280633580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280634574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280635579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280636587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280637586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280638587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280639589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280940273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280940273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280940273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280941276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280941276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9181	1716280941276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280942277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280942277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9181	1716280942277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280943280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280943280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9181	1716280943280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280944283	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280944283	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9174	1716280944283	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280945285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280945285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9174	1716280945285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280946287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280946287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9174	1716280946287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280947290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280947290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	107	1716280599467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280599467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4502000000000002	1716280599467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	109	1716280600469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280600469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4502000000000002	1716280600469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280601472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280601472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4502000000000002	1716280601472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	108	1716280602474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280602474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4518	1716280602474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280603477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280603477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4518	1716280603477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280604480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280604480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4518	1716280604480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	108	1716280605482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280605482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4521	1716280605482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280606485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280606485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4521	1716280606485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280607487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280607487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.4521	1716280607487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280608490	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280608490	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.7555	1716280608490	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280609497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280609497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.7555	1716280609497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280610498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280610498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.7555	1716280610498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280611500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280611500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9737	1716280611500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280612502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280612502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9737	1716280612502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280613505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280613505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9737	1716280613505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280614506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280614506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9785	1716280614506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280615508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.800000000000001	1716280615508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9785	1716280615508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280616510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280616510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9785	1716280616510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280617513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280617513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716280617513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280618514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280618514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716280618514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280619517	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280619517	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716280619517	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280620519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280620519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9833	1716280620519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280621521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280621521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9833	1716280621521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280622525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280622525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9833	1716280622525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280623527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280623527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280623527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280624529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280624529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280624529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280625532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280625532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280625532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280626534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280626534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9824000000000002	1716280626534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280627535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280627535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9824000000000002	1716280627535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280628538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280628538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9824000000000002	1716280628538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280629540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280629540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9812	1716280629540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280630543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280630543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9812	1716280630543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280631546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280631546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9812	1716280631546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280632548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280632548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716280632548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280633550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280633550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716280633550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280634552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280634552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716280634552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280635554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280635554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280635554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280636557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280636557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280636557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280637559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280637559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9821	1716280637559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280638561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280638561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9823	1716280638561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280639564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280639564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9823	1716280639564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280640566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280640566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9823	1716280640566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280640590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280641568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280641568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9830999999999999	1716280641568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280642570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280642570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9830999999999999	1716280642570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280643572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280643572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9830999999999999	1716280643572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280644574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280644574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.8977	1716280644574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280645577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280645577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.8977	1716280645577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280646579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280646579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.8977	1716280646579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280647582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280647582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9004	1716280647582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280648585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280648585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9004	1716280648585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280649587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280649587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9004	1716280649587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280650589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280650589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9001	1716280650589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280651591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280651591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9001	1716280651591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280652593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280652593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9001	1716280652593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280653596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280653596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280653596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280654599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280654599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280654599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280655603	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280655603	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280655603	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280656605	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280656605	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280656605	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280657608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280657608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280657608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280658610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280658610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716280658610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280659613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280659613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042000000000001	1716280659613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280660615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280660615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042000000000001	1716280660615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280661617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280661617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042000000000001	1716280661617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280662620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280662620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280641595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280642596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280643599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280644595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280645603	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280646600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280647611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280648612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280649607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280650619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280651619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280652620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280653628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280654622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280655628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280656632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280657638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280658636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280659631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280660640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280661643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280662645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280663647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280664646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280665645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280666644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280667650	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280668662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280669664	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280670665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280671667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280672670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280673673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280674668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280675678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280676669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280677674	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280678690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280679676	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280680682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280681690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280682698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280683697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280684692	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280685703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280686705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280687702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280688706	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280689709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280690704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280691714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280692718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280693718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280694721	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280695714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280696727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280697730	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280698731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280699732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280940293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280941300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280942302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280943308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280944308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280945304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9047	1716280662620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280663622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280663622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9047	1716280663622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280664623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280664623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9047	1716280664623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280665626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.4	1716280665626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.906	1716280665626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280666628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.7	1716280666628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.906	1716280666628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280667630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280667630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.906	1716280667630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280668633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280668633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280668633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280669635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280669635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280669635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280670637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280670637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280670637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280671640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280671640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280671640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280672643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280672643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280672643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280673645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280673645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9048	1716280673645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280674647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280674647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042999999999999	1716280674647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280675649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280675649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042999999999999	1716280675649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280676652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280676652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9042999999999999	1716280676652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280677654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280677654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9035	1716280677654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280678657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280678657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9035	1716280678657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280679659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280679659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9035	1716280679659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280680661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280680661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716280680661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280681666	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280681666	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716280681666	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280682668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280682668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716280682668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280683671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280683671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280683671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280684673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280684673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280684673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280685675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280685675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280685675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280686677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280686677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9077	1716280686677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280687678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280687678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9077	1716280687678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280688681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280688681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9077	1716280688681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280689683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280689683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280689683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280690685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280690685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280690685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280691687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280691687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9078	1716280691687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280692688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280692688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280692688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280693690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280693690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280693690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280694695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280694695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280694695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280695697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280695697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9101	1716280695697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280696700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280696700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9101	1716280696700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280697702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280697702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9101	1716280697702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280698705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280698705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.909	1716280698705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280699709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280699709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.909	1716280699709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280700711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280700711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.909	1716280700711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280700738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280701713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280701713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9105999999999999	1716280701713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280701740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280702718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280702718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9105999999999999	1716280702718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280702744	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280703719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280703719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9105999999999999	1716280703719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280703748	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280704721	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280704721	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280704721	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280705724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.900000000000001	1716280705724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280705724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	109.9	1716280706726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280706726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280706726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280707729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280707729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280707729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280708731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280708731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280708731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280709734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280709734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280709734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716280710736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280710736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280710736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280711739	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280711739	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280711739	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280712741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280712741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280712741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280713743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280713743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9110999999999998	1716280713743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280714745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280714745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9110999999999998	1716280714745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280715747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280715747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9110999999999998	1716280715747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280716750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280716750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9057	1716280716750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280717752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280717752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9057	1716280717752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280718755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280718755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9057	1716280718755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280719757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280719757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9079000000000002	1716280719757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280720759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280720759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9079000000000002	1716280720759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280721761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280721761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9079000000000002	1716280721761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280722763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280722763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280722763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280723765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280723765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280723765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280724767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280724767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280724767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280725769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280704817	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280705749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280706751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280707755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280708749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280709763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280710759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280711764	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280712767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280713769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280714763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280715773	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280716774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280717780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280718784	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280719779	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280720786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280721787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280722793	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280723793	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280724787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280725801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280726798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280727799	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280728801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280729806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280730806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280731807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280732812	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280733817	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280734815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280735875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280736833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280737827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280738818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280739828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280740824	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280741837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280742842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280743836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280744839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280745842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280746845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280747845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280748849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280749845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280750856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280751858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280752857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280753868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280754854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280755860	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280756869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280757873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280758874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280759877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280946317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280947318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280948321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280949324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280950320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280951328	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280952329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280953332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280954335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280725769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9098	1716280725769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280726771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280726771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9098	1716280726771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280727774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280727774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9098	1716280727774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280728776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280728776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9104	1716280728776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280729778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280729778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9104	1716280729778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280730780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280730780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9104	1716280730780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280731782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280731782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9092	1716280731782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280732785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280732785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9092	1716280732785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280733788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280733788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9092	1716280733788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280734790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280734790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280734790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280735794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280735794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280735794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280736796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280736796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9096	1716280736796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	110	1716280737798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.5	1716280737798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280737798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280738800	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280738800	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280738800	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280739802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280739802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280739802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280740804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280740804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280740804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280741807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280741807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280741807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280742810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280742810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280742810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280743811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280743811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280743811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280744813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280744813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280744813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280745815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280745815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9091	1716280745815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280746818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280746818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9095	1716280746818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280747820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280747820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9095	1716280747820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280748822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280748822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9095	1716280748822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716280749825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280749825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716280749825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280750827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280750827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716280750827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280751829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280751829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716280751829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280752831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280752831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280752831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280753834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280753834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280753834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280754836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280754836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280754836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280755838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280755838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280755838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280756843	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280756843	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280756843	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280757845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280757845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280757845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280758848	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280758848	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280758848	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280759850	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280759850	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280759850	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280760852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280760852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9089	1716280760852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280760881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280761854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280761854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102000000000001	1716280761854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280761883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280762856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280762856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102000000000001	1716280762856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280762886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280763858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280763858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102000000000001	1716280763858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280763878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280764861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280764861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280764861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280764880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280765864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280765864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280765864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280765891	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280766866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280766866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.91	1716280766866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280767868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280767868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280767868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280768871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280768871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280768871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280769873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280769873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9108	1716280769873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280770875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280770875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102999999999999	1716280770875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280771878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280771878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102999999999999	1716280771878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280772880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280772880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9102999999999999	1716280772880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280773882	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280773882	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9085999999999999	1716280773882	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280774885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280774885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9085999999999999	1716280774885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280775888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280775888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9085999999999999	1716280775888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280776890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280776890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280776890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280777893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280777893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280777893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280778895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280778895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280778895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280779898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280779898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280779898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280780900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280780900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280780900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280781903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280781903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280781903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280782905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280782905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280782905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280783907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280783907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280783907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280784909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280784909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280784909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280785911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.900000000000001	1716280785911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9138	1716280785911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280786914	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280786914	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9138	1716280786914	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280787916	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280766892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280767894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280768897	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280769892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280770903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280771903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280772907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280773909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280774912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280775914	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280776917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280777919	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280778926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280779919	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280780931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280781928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280782936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280783937	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280784929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280785939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280786944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280787942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280788947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280789947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280790952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280791954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280792953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280793955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280794961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280795963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280796965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280797965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280798969	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280799965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280800980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280801978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280802977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280803981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280804985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280805986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280806988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280807990	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280808993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280809986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280810997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280812001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280813002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280814003	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280814998	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280816010	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280817003	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280818014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280819016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280820015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9198	1716280947290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280948292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280948292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9198	1716280948292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280949295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280949295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9198	1716280949295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280950298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280950298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716280950298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280951300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280787916	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9138	1716280787916	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280788919	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280788919	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.914	1716280788919	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280789921	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280789921	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.914	1716280789921	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280790924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280790924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.914	1716280790924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280791926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280791926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9097	1716280791926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280792928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280792928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9097	1716280792928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280793931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280793931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9097	1716280793931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280794933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280794933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280794933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716280795935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280795935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280795935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280796938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280796938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280796938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280797940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280797940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280797940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280798942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280798942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280798942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280799944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280799944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9135	1716280799944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280800947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280800947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9127	1716280800947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280801949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280801949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9127	1716280801949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280802952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280802952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9127	1716280802952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280803954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280803954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9118	1716280803954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280804956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280804956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9118	1716280804956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280805959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280805959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9118	1716280805959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280806961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280806961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280806961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280807963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280807963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280807963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280808965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280808965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280808965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280809967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280809967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280809967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280810971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280810971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280810971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280811973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280811973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280811973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280812975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280812975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280812975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280813977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280813977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280813977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280814979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280814979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9147	1716280814979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280815981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280815981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280815981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280816983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280816983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280816983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280817985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280817985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280817985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280818988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280818988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9137	1716280818988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280819991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280819991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9137	1716280819991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280820993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280820993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9137	1716280820993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280821020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280821995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280821995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280821995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280822022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280822997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280822997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280822997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280823024	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280824000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280824000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9144	1716280824000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280824026	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280825002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280825002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280825002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280825022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280826004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280826004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280826004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280826029	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280827007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280827007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280827007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280827034	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280828009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280828009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9119000000000002	1716280828009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280829011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280829011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9119000000000002	1716280829011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280830013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280830013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9119000000000002	1716280830013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280831015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280831015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9118	1716280831015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280832017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280832017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9118	1716280832017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280833019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280833019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280833019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280834021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280834021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280834021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280835023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280835023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280835023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280836025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280836025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280836025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280837028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280837028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280837028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280838030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280838030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9117	1716280838030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280839033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280839033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9125999999999999	1716280839033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280840036	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280840036	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9125999999999999	1716280840036	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280841038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280841038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9125999999999999	1716280841038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280842041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280842041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280842041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280843043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280843043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280843043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280844045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280844045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280844045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280845047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280845047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280845047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280846050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280846050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280846050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280847052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280847052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9116	1716280847052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280848055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280848055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.915	1716280848055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280849057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280849057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.915	1716280849057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280828034	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280829038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280830040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280831043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280832035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280833049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280834049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280835049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280836048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280837055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280838054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280839060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280840054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280841060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280842067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280843074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280844075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280845067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280846080	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280847079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280848084	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280849081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280850086	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280851091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280852082	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280853091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280854097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280855090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280856103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280857103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280858105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280859109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280860103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280861116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280862117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280863119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280864122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280865125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280866117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280867123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280868132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280869135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280870128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280871137	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280872141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280873142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280874147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280875138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280876151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280877151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280878160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280879157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280951300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716280951300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280952302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280952302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716280952302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280953305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280953305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280953305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280954307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280954307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280954307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280955309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280955309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280850059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280850059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.915	1716280850059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280851061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280851061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9159000000000002	1716280851061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280852064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280852064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9159000000000002	1716280852064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280853067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280853067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9159000000000002	1716280853067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280854069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280854069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9145999999999999	1716280854069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280855071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280855071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9145999999999999	1716280855071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280856074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280856074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9145999999999999	1716280856074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280857076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280857076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9132	1716280857076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280858078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280858078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9132	1716280858078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280859081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280859081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9132	1716280859081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280860085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280860085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280860085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280861088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280861088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280861088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280862090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280862090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280862090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280863093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.900000000000001	1716280863093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9107	1716280863093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280864095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280864095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9107	1716280864095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280865098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280865098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9107	1716280865098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280866100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280866100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280866100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280867103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280867103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280867103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280868105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280868105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9130999999999998	1716280868105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280869108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280869108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9163	1716280869108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280870110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280870110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9163	1716280870110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280871112	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280871112	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9163	1716280871112	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280872115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.500000000000001	1716280872115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9139000000000002	1716280872115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280873117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.800000000000001	1716280873117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9139000000000002	1716280873117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280874118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280874118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9139000000000002	1716280874118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280875120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280875120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280875120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280876123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280876123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280876123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280877125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280877125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9128	1716280877125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280878128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280878128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280878128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280879130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280879130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280879130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280880132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280880132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9136	1716280880132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280880160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280881135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280881135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9164	1716280881135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280881163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280882138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280882138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9164	1716280882138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280882164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280883141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280883141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9164	1716280883141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280883170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280884143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280884143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280884143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280884170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280885145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280885145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280885145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280885163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280886147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280886147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280886147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280886178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280887149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280887149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280887149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280887176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280888151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280888151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280888151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280888178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280889155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280889155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280889155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280890157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280890157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280890157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280891159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280891159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280891159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280892162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280892162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280892162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280893164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280893164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9172	1716280893164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280894166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280894166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9172	1716280894166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280895168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280895168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9172	1716280895168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280896170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280896170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280896170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280897173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280897173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280897173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280898176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280898176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280898176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280899179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280899179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716280899179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280900181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280900181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716280900181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280901184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280901184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716280901184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280902186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280902186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280902186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280903189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280903189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280903189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280904191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280904191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9141	1716280904191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280905194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280905194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280905194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280906197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280906197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280906197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280907199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280907199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9153	1716280907199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280908201	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280908201	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280908201	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280909204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280909204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280909204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280910206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280910206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280910206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280889180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280890178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280891184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280892188	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280893191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280894190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280895199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280896197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280897200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280898202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280899205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280900197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280901215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280902210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280903218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280904217	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280905211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280906223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280907229	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280908229	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280909231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280910233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280911235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280912235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280913238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280914241	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280915234	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280916246	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280917249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280918256	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280919254	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280920247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280921260	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280922261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280923263	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280924258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280925265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280926267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280927273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280928272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280929265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280930278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280931278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280932285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280933285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280934281	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280935288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280936292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280937293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280938286	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280939293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9197	1716280955309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280956311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280956311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9208	1716280956311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280957313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280957313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9208	1716280957313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280958315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280958315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9208	1716280958315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280959317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280959317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9216	1716280959317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280960320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280911208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280911208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280911208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280912210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280912210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280912210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280913212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280913212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9167	1716280913212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280914214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280914214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280914214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280915216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280915216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280915216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280916219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280916219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9158	1716280916219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280917221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280917221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9173	1716280917221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280918223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716280918223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9173	1716280918223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280919226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280919226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9173	1716280919226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280920228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280920228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280920228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280921231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280921231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280921231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280922233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280922233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280922233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280923236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280923236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280923236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280924238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280924238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280924238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280925240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280925240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9201	1716280925240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280926242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280926242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9184	1716280926242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280927245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280927245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9184	1716280927245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280928247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280928247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9184	1716280928247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280929249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280929249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280929249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280930251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280930251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280930251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280931253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280931253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280931253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280932255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280932255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.919	1716280932255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280933257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280933257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.919	1716280933257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280934259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280934259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.919	1716280934259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280935262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280935262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716280935262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280936264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280936264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716280936264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280937267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280937267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716280937267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280938268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280938268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280938268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280939271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280939271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9149	1716280939271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280955337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280956335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280957339	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280958344	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280959343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280960320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9216	1716280960320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280960338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280961321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280961321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9216	1716280961321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280961347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280962324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280962324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9221	1716280962324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280962350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280963326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280963326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9221	1716280963326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280963354	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280964329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280964329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9221	1716280964329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280964355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280965332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280965332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9223	1716280965332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280965350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280966335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280966335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9223	1716280966335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280966363	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280967337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280967337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9223	1716280967337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280967366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280968341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280968341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280968341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280968364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280969343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280969343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280969343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280970345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280970345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716280970345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280971349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280971349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9232	1716280971349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716280972351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280972351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9232	1716280972351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280973353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280973353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9232	1716280973353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280974355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280974355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9237	1716280974355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280975357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280975357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9237	1716280975357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280976359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280976359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9237	1716280976359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280977362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280977362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716280977362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280978364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280978364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716280978364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280979368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280979368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716280979368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280980370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280980370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280980370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280981372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280981372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280981372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716280982374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280982374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280982374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280983377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280983377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280983377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280984378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280984378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280984378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716280985380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716280985380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9238	1716280985380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280986382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280986382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716280986382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280987385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280987385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716280987385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280988388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280988388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716280988388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280989390	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280989390	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9233	1716280989390	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280990392	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280990392	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280969371	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280970376	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280971369	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280972377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280973376	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280974379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280975376	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280976388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280977389	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280978391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280979393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280980388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280981401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280982401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280983407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280984395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280985409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280986406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280987403	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280988414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280989407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280990416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280991424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280992422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280993424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280994420	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280995433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280996433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280997436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280998438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716280999442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281360290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281361290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281362282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281363294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281364297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281365294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281366305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281367304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281368306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281369310	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281370303	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281371313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281372317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281373312	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281374321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281375324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281376324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281377327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281378330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281379333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281380326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281381335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281382338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281383342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281384346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281385339	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281386341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281387356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281388353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281389355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281390358	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281391359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281392362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281393364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9233	1716280990392	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280991394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280991394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9233	1716280991394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280992396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280992396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9247	1716280992396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280993399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280993399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9247	1716280993399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280994402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280994402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9247	1716280994402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280995405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280995405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.923	1716280995405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280996407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280996407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.923	1716280996407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716280997409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716280997409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.923	1716280997409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716280998411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280998411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9229	1716280998411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716280999414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716280999414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9229	1716280999414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281000416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281000416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9229	1716281000416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281000443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281001418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281001418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281001418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281001442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281002420	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281002420	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281002420	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281002452	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281003422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281003422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281003422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281003451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281004424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281004424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281004424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281004442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281005426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281005426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281005426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281005456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281006428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281006428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281006428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281006456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281007431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281007431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716281007431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281007456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281008433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281008433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716281008433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281008459	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281009436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281009436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9224	1716281009436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281010438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281010438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9253	1716281010438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281011440	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281011440	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9253	1716281011440	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281012443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281012443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9253	1716281012443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281013445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281013445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.925	1716281013445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281014448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281014448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.925	1716281014448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281015450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281015450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.925	1716281015450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281016453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281016453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9258	1716281016453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281017454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281017454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9258	1716281017454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281018456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281018456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9258	1716281018456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281019458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281019458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9255	1716281019458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281020460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281020460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9255	1716281020460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281021462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281021462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9255	1716281021462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281022465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281022465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716281022465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281023468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281023468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716281023468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281024471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281024471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716281024471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281025473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281025473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245	1716281025473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281026475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281026475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245	1716281026475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281027477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281027477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245	1716281027477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281028479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281028479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281028479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281029481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281029481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281029481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281030484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281009455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281010465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281011467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281012470	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281013472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281014467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281015477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281016481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281017483	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281018483	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281019477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281020488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281021488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281022496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281023499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281024492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281025499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281026500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281027504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281028505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281029508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281030509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281031514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281032514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281033522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281034521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281035526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281036526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281037530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281038533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281039530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281040525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281041535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281042542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281043541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281044543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281045548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281046542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281047553	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281048554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281049548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281050559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281051563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281052562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281053565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281054561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281055560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281056564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281057574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281058576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281059571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281361263	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281361263	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9352	1716281361263	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281362265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281362265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9352	1716281362265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281363268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281363268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9352	1716281363268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281364270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281364270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716281364270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281365273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281365273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281030484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281030484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281031486	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281031486	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716281031486	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281032489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281032489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716281032489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281033492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281033492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716281033492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281034494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281034494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281034494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281035497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281035497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281035497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281036499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281036499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281036499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281037501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281037501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281037501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281038504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281038504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281038504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281039506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281039506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281039506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281040508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281040508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9236	1716281040508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281041511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281041511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9236	1716281041511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281042513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281042513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9236	1716281042513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281043516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281043516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9239000000000002	1716281043516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281044518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281044518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9239000000000002	1716281044518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281045520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281045520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9239000000000002	1716281045520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281046522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281046522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281046522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281047525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281047525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281047525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281048528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281048528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281048528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281049530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281049530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281049530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281050533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281050533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281050533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281051535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281051535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716281051535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281052537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281052537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281052537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281053540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281053540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281053540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281054542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281054542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281054542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281055544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281055544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9301	1716281055544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281056546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281056546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9301	1716281056546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281057548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281057548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9301	1716281057548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281058550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281058550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9276	1716281058550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281059552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281059552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9276	1716281059552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281060554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281060554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9276	1716281060554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281060581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281061557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281061557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9289	1716281061557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281061583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281062559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281062559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9289	1716281062559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281062583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281063561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281063561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9289	1716281063561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281063591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281064563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281064563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9283	1716281064563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281064581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281065565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281065565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9283	1716281065565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281065590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281066568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281066568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9283	1716281066568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281066593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281067570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281067570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9256	1716281067570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281067597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281068573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281068573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9256	1716281068573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281068598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281069576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281069576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9256	1716281069576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281069594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281070598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281071609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281072611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281073613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281074606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281075619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281076617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281077624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281078626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281079627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281080624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281081634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281082634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281083635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281084640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281085642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281086644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281087644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281088648	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281089653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281090651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281091660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281092659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281093664	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281094665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281095657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281096671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281097673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281098672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281099677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281100669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281101682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281102681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281103689	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281104682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281105698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281106695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281107698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281108693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281109695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281110704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281111703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281112708	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281113710	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281114702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281115716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281116716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281117719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281118722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281119727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281120725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281121728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281122732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281123734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281124725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281125736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281126739	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281127743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281128742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281129736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281130747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281131751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281132757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281133755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281070580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281070580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281070580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281071582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281071582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281071582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281072584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281072584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281072584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281073587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281073587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281073587	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281074589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281074589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281074589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281075591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281075591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281075591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716281076593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281076593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281076593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281077595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281077595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281077595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281078597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281078597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9254	1716281078597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281079600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281079600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9267	1716281079600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281080602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281080602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9267	1716281080602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281081604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281081604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9267	1716281081604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281082607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281082607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9262000000000001	1716281082607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281083609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281083609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9262000000000001	1716281083609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281084611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281084611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9262000000000001	1716281084611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281085613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281085613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281085613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281086616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281086616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281086616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281087618	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281087618	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9257	1716281087618	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281088622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281088622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9270999999999998	1716281088622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281089625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281089625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9270999999999998	1716281089625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281090627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281090627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9270999999999998	1716281090627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281091630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281091630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281091630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281092632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281092632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281092632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281093634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281093634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281093634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281094636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281094636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9294	1716281094636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281095639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281095639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9294	1716281095639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281096641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281096641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9294	1716281096641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281097643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281097643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281097643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281098646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281098646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281098646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281099649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281099649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281099649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281100652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281100652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281100652	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281101654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281101654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281101654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281102656	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281102656	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281102656	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281103659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281103659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9296	1716281103659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281104661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281104661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9296	1716281104661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281105663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281105663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9296	1716281105663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281106665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281106665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281106665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281107667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281107667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281107667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281108670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281108670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9299000000000002	1716281108670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281109672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281109672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.929	1716281109672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281110675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281110675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.929	1716281110675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281111678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281111678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.929	1716281111678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281112680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281112680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716281112680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281113682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281113682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716281113682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281114685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281114685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716281114685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281115687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281115687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281115687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281116691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281116691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281116691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281117693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281117693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716281117693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281118696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281118696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281118696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281119698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281119698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281119698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281120700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281120700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.927	1716281120700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281121703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281121703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716281121703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281122705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281122705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716281122705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281123707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281123707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716281123707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281124709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	5.9	1716281124709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9272	1716281124709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281125711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.6000000000000005	1716281125711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9272	1716281125711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281126713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281126713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9272	1716281126713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281127716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281127716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281127716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281128718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281128718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281128718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281129719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281129719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9281	1716281129719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281130722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281130722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281130722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281131725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281131725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281131725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281132726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281132726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716281132726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281133729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281133729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281133729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281134731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281134731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281134731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281135735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281135735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281135735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281136738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281136738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281136738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281137740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281137740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281137740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281138742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281138742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281138742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281139745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281139745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9312	1716281139745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281140747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281140747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9312	1716281140747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281141750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281141750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9312	1716281141750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281142752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281142752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281142752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281143755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281143755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281143755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281144757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281144757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281144757	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281145759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281145759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281145759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281146761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281146761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281146761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281147764	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281147764	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281147764	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281148766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281148766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281148766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281149769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281149769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281149769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281150771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281150771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281150771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281151775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281151775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9274	1716281151775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281152776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281152776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9274	1716281152776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281153779	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281153779	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9274	1716281153779	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281154781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281154781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9293	1716281154781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281155783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281134749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281135761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281136762	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281137767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281138769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281139770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281140767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281141776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281142778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281143782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281144787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281145777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281146781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281147782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281148786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281149786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281150794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281151797	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281152796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281153795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281154801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281155811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281156814	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281157809	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281158818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281159807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281160818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281161823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281162826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281163828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281164828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281165831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281166836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281167837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281168838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281169834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281170841	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281171845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281172846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281173851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281174848	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281175853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281176856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281177858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281178866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281179855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716281365273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281366276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281366276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716281366276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281367278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281367278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.932	1716281367278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281368279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281368279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.932	1716281368279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281369282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281369282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.932	1716281369282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281370285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281370285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716281370285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281371287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281371287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716281371287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281155783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9293	1716281155783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281156785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281156785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9293	1716281156785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281157788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281157788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281157788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281158790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281158790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281158790	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281159792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281159792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9292	1716281159792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281160794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716281160794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281160794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281161796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281161796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281161796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281162798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281162798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9303	1716281162798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281163801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281163801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716281163801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281164803	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281164803	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716281164803	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281165805	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281165805	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716281165805	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281166807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281166807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9313	1716281166807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281167810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281167810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9313	1716281167810	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281168812	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281168812	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9313	1716281168812	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281169815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281169815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281169815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281170816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281170816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281170816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281171819	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281171819	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.931	1716281171819	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281172821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281172821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281172821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281173823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281173823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281173823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281174825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281174825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281174825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281175828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281175828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9335	1716281175828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281176830	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281176830	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9335	1716281176830	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281177832	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281177832	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9335	1716281177832	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281178835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281178835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281178835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281179837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281179837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281179837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281180840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281180840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281180840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281180870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281181842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281181842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281181842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281181869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281182845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281182845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281182845	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281182871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281183847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281183847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281183847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281183871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281184849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281184849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716281184849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281184870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281185851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281185851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716281185851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281185881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281186854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281186854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716281186854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281186879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281187856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281187856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716281187856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281187882	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281188858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281188858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716281188858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281188883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281189861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281189861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716281189861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281189880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281190864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281190864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281190864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281190890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281191866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281191866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281191866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281191883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281192869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281192869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281192869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281192897	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281193872	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281193872	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281193872	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281194874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281194874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281194874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281195876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281195876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281195876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281196878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281196878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281196878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281197880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281197880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281197880	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281198883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281198883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327999999999999	1716281198883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281199885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281199885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281199885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281200889	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281200889	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281200889	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281201891	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281201891	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281201891	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281202893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281202893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281202893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281203896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281203896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281203896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281204898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281204898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281204898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281205900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281205900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9342000000000001	1716281205900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281206902	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281206902	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9342000000000001	1716281206902	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281207904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281207904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9342000000000001	1716281207904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281208907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281208907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281208907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281209908	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281209908	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281209908	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281210910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281210910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281210910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281211913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281211913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281211913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281212915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281212915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281212915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281213917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281213917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281213917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281214920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281214920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281214920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281193900	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281194898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281195901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281196903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281197907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281198911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281199904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281200917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281201916	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281202922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281203923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281204915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281205925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281206931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281207927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281208930	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281209927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281210938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281211938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281212940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281213946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281214939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281215948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281216953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281217954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281218955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281219949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281220962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281221959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281222964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281223968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281224971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281225971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281226976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281227980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281228981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281229973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281230982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281231986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281232990	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281233989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281234985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281235994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281236998	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281238000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281239001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281240005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281240999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281242007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281243001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281244010	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281245008	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281246022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281247021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281248022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281249025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281250023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281251032	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281252036	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281253037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281254037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281255039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281256043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281257041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281258050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281215922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281215922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281215922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281216925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281216925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281216925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281217927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281217927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281217927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281218929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281218929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281218929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281219931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281219931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281219931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281220934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281220934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281220934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281221936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281221936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281221936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281222939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281222939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281222939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281223941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281223941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.93	1716281223941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281224944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281224944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.93	1716281224944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281225946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281225946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.93	1716281225946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281226948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716281226948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9298	1716281226948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281227950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281227950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9298	1716281227950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281228952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281228952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9298	1716281228952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281229954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281229954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281229954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281230956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281230956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281230956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281231959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281231959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9305	1716281231959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281232962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281232962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9309	1716281232962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281233963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281233963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9309	1716281233963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281234966	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281234966	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9309	1716281234966	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281235968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281235968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9319000000000002	1716281235968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281236970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281236970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9319000000000002	1716281236970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281237972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281237972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9319000000000002	1716281237972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281238975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281238975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281238975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281239977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281239977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281239977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281240979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281240979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281240979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281241981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281241981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281241981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281242984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281242984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281242984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281243986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281243986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281243986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281244988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281244988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281244988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281245992	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281245992	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281245992	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281246994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281246994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281246994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281247997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281247997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281247997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281249000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281249000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281249000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281250002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281250002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281250002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281251005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716281251005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281251005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281252007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281252007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281252007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281253009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281253009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281253009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281254011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281254011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281254011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281255013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281255013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281255013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281256016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281256016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9333	1716281256016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281257018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281257018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9285	1716281257018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281258020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281258020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9285	1716281258020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281259022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281259022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281259022	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281260025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281260025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281260025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281261027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281261027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9304000000000001	1716281261027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281262028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281262028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281262028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281263031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281263031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281263031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281264033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281264033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281264033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281265035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281265035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9323	1716281265035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281266037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281266037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9323	1716281266037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281267039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281267039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9323	1716281267039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281268041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281268041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281268041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281269043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281269043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281269043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281270046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281270046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281270046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281271048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281271048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281271048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281272051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281272051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281272051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281273054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281273054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716281273054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281274055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281274055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281274055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281275058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281275058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281275058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281276061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281276061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281276061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281277063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281277063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281277063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281278065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281278065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281278065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281279073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281279073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9354	1716281279073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281259048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281260045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281261054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281262055	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281263056	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281264062	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281265057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281266065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281267064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281268065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281269064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281270074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281271074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281272076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281273081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281274080	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281275077	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281276089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281277089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281278092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281279092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281280094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281281105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281282108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281283112	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281284110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281285116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281286116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281287118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281288122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281289121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281290120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281291127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281292130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281293132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281294136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281295130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281296138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281297138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281298143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281299148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281300150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281372289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281372289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716281372289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281373291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281373291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281373291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281374294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281374294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281374294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281375296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281375296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281375296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281376298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281376298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281376298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281377300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281377300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281377300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281378304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281378304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9358	1716281378304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281379306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281379306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281280075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281280075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281280075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281281078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281281078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281281078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281282081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281282081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281282081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281283083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281283083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.933	1716281283083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281284085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281284085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.933	1716281284085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281285088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281285088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.933	1716281285088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281286090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281286090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281286090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281287092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281287092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281287092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281288094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281288094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347	1716281288094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281289097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281289097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281289097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281290099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281290099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281290099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281291101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281291101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281291101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281292103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281292103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281292103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281293106	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281293106	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281293106	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281294108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281294108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281294108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281295110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281295110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9297	1716281295110	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281296113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281296113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9297	1716281296113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281297115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281297115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9297	1716281297115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281298117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281298117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281298117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281299119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281299119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281299119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281300122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281300122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9307	1716281300122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281301124	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281301124	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281301124	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281301151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281302126	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281302126	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281302126	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281302154	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281303128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281303128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281303128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281303157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281304130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281304130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281304130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281304156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281305133	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281305133	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281305133	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281305153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281306135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281306135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281306135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281306162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281307137	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281307137	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281307137	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281307166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281308141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281308141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281308141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281308170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281309143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281309143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9336	1716281309143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281309170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281310146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281310146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281310146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281310162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281311148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281311148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281311148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281311174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281312150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281312150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9322000000000001	1716281312150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281312179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281313153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281313153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281313153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281313181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281314155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281314155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281314155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281314188	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281315158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281315158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9327	1716281315158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281315185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281316160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281316160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281316160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281316187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281317163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281317163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281317163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281318165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281318165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9343	1716281318165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281319167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281319167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281319167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281320170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281320170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281320170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281321172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281321172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281321172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281322174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281322174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281322174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281323176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281323176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281323176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281324178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281324178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281324178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281325180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281325180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281325180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281326185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281326185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281326185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281327187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281327187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345	1716281327187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281328189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281328189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.937	1716281328189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281329191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281329191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.937	1716281329191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281330194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281330194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.937	1716281330194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281331196	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281331196	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281331196	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281332198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281332198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281332198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281333200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281333200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9321	1716281333200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281334202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281334202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281334202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281335205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281335205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281335205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281336207	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281336207	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281336207	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281337210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281337210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281337210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281338212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281338212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281317188	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281318193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281319194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281320188	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281321199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281322198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281323206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281324202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281325198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281326212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281327214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281328211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281329209	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281330220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281331222	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281332227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281333218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281334228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281335231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281336236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281337238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281338239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281339242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281340243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281341245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281342248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281343240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281344251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281345253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281346255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281347253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281348264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281349262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281350258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281351270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281352270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281353272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281354274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281355268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281356282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281357283	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281358289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281359285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281379306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281380308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281380308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281380308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281381310	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281381310	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281381310	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281382313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281382313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281382313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281383316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281383316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281383316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281384318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281384318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281384318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281385320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281385320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9377	1716281385320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281386322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281386322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9377	1716281386322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281338212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281339214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716281339214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9345999999999999	1716281339214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281340216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281340216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281340216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281341219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281341219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281341219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281342221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281342221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281342221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281343223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281343223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281343223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281344225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281344225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281344225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281345227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281345227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281345227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281346230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281346230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281346230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281347232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281347232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281347232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281348235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281348235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716281348235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281349237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281349237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281349237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281350239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281350239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281350239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281351242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281351242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.934	1716281351242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281352244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281352244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281352244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281353246	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281353246	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281353246	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281354248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281354248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9347999999999999	1716281354248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281355251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281355251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716281355251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281356253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281356253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716281356253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281357255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6	1716281357255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716281357255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281358257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281358257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281358257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281359259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281359259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281359259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281360261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.7	1716281360261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281360261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281387324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281387324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9377	1716281387324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281388327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281388327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281388327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281389329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281389329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281389329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281390332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281390332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9369	1716281390332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281391334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281391334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281391334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281392336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281392336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281392336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281393338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281393338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281393338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281394340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281394340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716281394340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281394359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281395342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281395342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716281395342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281395369	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281396346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281396346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716281396346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281396372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281397348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281397348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9375	1716281397348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281397373	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281398350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281398350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9375	1716281398350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281398375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281399353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281399353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9375	1716281399353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281399371	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281400356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281400356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367	1716281400356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281400373	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281401360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281401360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367	1716281401360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281401386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281402362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281402362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367	1716281402362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281402387	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281403366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281403366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281403366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281403395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281404368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281404368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281404368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281405370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281405370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9330999999999998	1716281405370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281406372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281406372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9383	1716281406372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281407375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281407375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9383	1716281407375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281408377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281408377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9383	1716281408377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281409380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281409380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281409380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281410382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281410382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281410382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281411384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281411384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281411384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281412386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281412386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281412386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281413391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281413391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281413391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281414395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281414395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385999999999999	1716281414395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281415398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281415398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281415398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281416399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281416399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281416399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281417402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281417402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281417402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281418404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281418404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9392	1716281418404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281419406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281419406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9392	1716281419406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281841379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281841379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9692	1716281841379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281842383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281842383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9692	1716281842383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281843385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281843385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9692	1716281843385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281844388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281844388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9714	1716281844388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281845391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281845391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9714	1716281845391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281846393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281404387	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281405395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281406400	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281407401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281408402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281409398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281410409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281411410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281412412	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281413415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281414416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281415426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281416424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281417429	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281418431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281419427	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281420408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281420408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9392	1716281420408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281420430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	106	1716281421411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716281421411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281421411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281421437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281422414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281422414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281422414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281422438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281423416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281423416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.939	1716281423416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281423442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281424418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281424418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385	1716281424418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281424445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281425421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281425421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385	1716281425421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281425442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281426424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281426424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9385	1716281426424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281426452	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281427426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281427426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281427426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281427453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281428428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281428428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281428428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281428458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281429431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281429431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281429431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281429459	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281430433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281430433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281430433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281430456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281431435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281431435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281431435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281431462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281432437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281432437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281432437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281433439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281433439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716281433439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281434441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281434441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716281434441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281435443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281435443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716281435443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281436445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281436445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9394	1716281436445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281437447	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281437447	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9394	1716281437447	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281438450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281438450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9394	1716281438450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281439453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281439453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281439453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281440456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281440456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281440456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281441458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281441458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9367999999999999	1716281441458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281442460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281442460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281442460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281443462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281443462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281443462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281444464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281444464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9389	1716281444464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281445466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281445466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9398	1716281445466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281446468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281446468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9398	1716281446468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281447471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281447471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9398	1716281447471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281448473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281448473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9399000000000002	1716281448473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281449476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281449476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9399000000000002	1716281449476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281450478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281450478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9399000000000002	1716281450478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281451480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281451480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405	1716281451480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281452482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281452482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405	1716281452482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281453485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281453485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281432464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281433466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281434468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281435467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281436476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281437474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281438480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281439472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281440479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281441485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281442486	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281443488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281444481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281445492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281446495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281447497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281448501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281449500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281450501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281451505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281452511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281453508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281454505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281455517	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281456520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281457520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281458521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281459521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281460527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281461529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281462531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281463535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281464530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281465538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281466541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281467548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281468545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281469543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281470555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281471554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281472557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281473558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281474549	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281475561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281476568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281477569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281478569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281479566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281480576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281481578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281482580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281483583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281484584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281485578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281486590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281487590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281488592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281489598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281490589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281491597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281492602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281493602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281494604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281495607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281496610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405	1716281453485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281454487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281454487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.941	1716281454487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281455489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281455489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.941	1716281455489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281456492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281456492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.941	1716281456492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281457494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281457494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716281457494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281458496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281458496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716281458496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281459499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281459499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716281459499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281460501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281460501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9409	1716281460501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281461503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281461503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9409	1716281461503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281462505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281462505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9409	1716281462505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281463508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281463508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.942	1716281463508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281464510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281464510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.942	1716281464510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281465513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281465513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.942	1716281465513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281466515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281466515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9418	1716281466515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281467518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281467518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9418	1716281467518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281468519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281468519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9418	1716281468519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281469522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281469522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716281469522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281470528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281470528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716281470528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281471527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281471527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716281471527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281472529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281472529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9403	1716281472529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281473532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281473532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9403	1716281473532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281474534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281474534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9403	1716281474534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281475536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281475536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281475536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281476538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281476538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281476538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281477540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281477540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281477540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281478542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281478542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281478542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281479545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281479545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281479545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281480547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281480547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9374	1716281480547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281481550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281481550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281481550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281482552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281482552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281482552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281483555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281483555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716281483555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281484558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281484558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281484558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281485560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281485560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281485560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281486562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281486562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9363	1716281486562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281487564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281487564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9373	1716281487564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281488567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281488567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9373	1716281488567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281489568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281489568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9373	1716281489568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281490570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281490570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9401	1716281490570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281491572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281491572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9401	1716281491572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281492574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281492574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9401	1716281492574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281493577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281493577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281493577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281494578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281494578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281494578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281495581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281495581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281495581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281496583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281496583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281496583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281497586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281497586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281497586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281498589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281498589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716281498589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281499591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281499591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9416	1716281499591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281500593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281500593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9416	1716281500593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281501596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281501596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9416	1716281501596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281502598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281502598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281502598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281503600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281503600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281503600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281504602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281504602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281504602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281505604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281505604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716281505604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281506607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281506607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716281506607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281507609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281507609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716281507609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281508611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281508611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9449	1716281508611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281509613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716281509613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9449	1716281509613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281510615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281510615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9449	1716281510615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281511617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281511617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281511617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281512619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281512619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281512619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281513621	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281513621	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.943	1716281513621	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281514623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281514623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9443	1716281514623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281515627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281515627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9443	1716281515627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281516630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281516630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9443	1716281516630	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281517632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281517632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281497611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281498619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281499610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281500628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281501628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281502624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281503624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281504620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281505633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281506631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281507635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281508641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281509639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281510642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281511641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281512643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281513645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281514641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281515655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281516656	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281517659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281518662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281519655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281520666	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281521670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281522673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281523670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281524673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281525679	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281526682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281527682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281528682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281529678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281530689	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281531685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281532685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281533694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281534692	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281535699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281536702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281537705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281538709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281539705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281841406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281842407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281843411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281844406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281845409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281846419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281847419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281848425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281849424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281850418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281851429	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281852431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281853435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281854438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281855438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281856444	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281857442	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281858443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281859447	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281860445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281861452	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281862455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9447	1716281517632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281518634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281518634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9447	1716281518634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281519637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281519637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9447	1716281519637	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281520639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281520639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9461	1716281520639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281521642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281521642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9461	1716281521642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281522644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281522644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9461	1716281522644	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281523646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281523646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9485	1716281523646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281524648	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281524648	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9485	1716281524648	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281525650	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281525650	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9485	1716281525650	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281526653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281526653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281526653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281527655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281527655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281527655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281528658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281528658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281528658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281529660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.1	1716281529660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9501	1716281529660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281530662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.8	1716281530662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9501	1716281530662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281531665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281531665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9501	1716281531665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281532667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281532667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9498	1716281532667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281533668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281533668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9498	1716281533668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281534671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281534671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9498	1716281534671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281535673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281535673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.95	1716281535673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281536675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281536675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.95	1716281536675	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281537678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281537678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.95	1716281537678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281538680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281538680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9514	1716281538680	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281539683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281539683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9514	1716281539683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281540686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281540686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9514	1716281540686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281540715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281541688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281541688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9513	1716281541688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281541715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281542691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281542691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9513	1716281542691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281542716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281543693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281543693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9513	1716281543693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281543720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281544695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281544695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716281544695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281544712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281545697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281545697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716281545697	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281545726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281546699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281546699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716281546699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281546725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281547701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281547701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716281547701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281547731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281548702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281548702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716281548702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281548728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281549704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281549704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716281549704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281549730	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281550706	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281550706	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.945	1716281550706	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281550731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281551709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281551709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.945	1716281551709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281551728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281552711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281552711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.945	1716281552711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281552738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281553712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281553712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9467	1716281553712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281553738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281554715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281554715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9467	1716281554715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281554736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281555718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281555718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9467	1716281555718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281556720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281556720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281556720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281557722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281557722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281557722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281558725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281558725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281558725	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281559728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281559728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281559728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281560732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281560732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281560732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281561735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281561735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281561735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281562737	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281562737	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281562737	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281563741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281563741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281563741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281564743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281564743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9493	1716281564743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281565745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281565745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281565745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281566747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281566747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281566747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281567750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281567750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9481	1716281567750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281568752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281568752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9489	1716281568752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281569754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281569754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9489	1716281569754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281570756	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281570756	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9489	1716281570756	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281571759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281571759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281571759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281572761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281572761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281572761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281573763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281573763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716281573763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281574765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281574765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9506	1716281574765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281575767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281575767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9506	1716281575767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281576769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281576769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281555746	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281556745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281557748	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281558751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281559754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281560752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281561762	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281562764	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281563767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281564769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281565767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281566763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281567777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281568776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281569777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281570784	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281571783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281572788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281573789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281574782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281575793	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281576796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281577797	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281578800	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281579795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281580808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281581811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281582808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281583813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281584817	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281585813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281586823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281587820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281588825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281589832	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281590828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281591834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281592839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281593843	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281594831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281595844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281596847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281597851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281598852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281599853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281600847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281601855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281602855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281603861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281604853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281605863	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281606864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281607868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281608869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281609862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281610876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281611878	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281612881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281613883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281614890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281615888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281616892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281617894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281618893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281619892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9506	1716281576769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281577772	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281577772	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9496	1716281577772	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281578774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281578774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9496	1716281578774	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281579777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281579777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9496	1716281579777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281580780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281580780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9526	1716281580780	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281581782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281581782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9526	1716281581782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281582784	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281582784	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9526	1716281582784	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281583786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281583786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.951	1716281583786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281584789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281584789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.951	1716281584789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281585792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281585792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.951	1716281585792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281586794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281586794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9532	1716281586794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281587796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281587796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9532	1716281587796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281588799	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281588799	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9532	1716281588799	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281589802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281589802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281589802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281590804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6000000000000005	1716281590804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281590804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281591807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281591807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281591807	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281592809	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281592809	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281592809	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281593811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281593811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281593811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281594813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281594813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281594813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281595816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281595816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9555	1716281595816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281596818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281596818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9555	1716281596818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281597820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281597820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9555	1716281597820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281598822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281598822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9561	1716281598822	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281599824	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281599824	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9561	1716281599824	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281600826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281600826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9561	1716281600826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281601829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281601829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716281601829	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281602831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281602831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716281602831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281603833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281603833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716281603833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281604835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281604835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9575	1716281604835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281605838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281605838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9575	1716281605838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281606840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281606840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9575	1716281606840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281607842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281607842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9554	1716281607842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281608844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281608844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9554	1716281608844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281609846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281609846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9554	1716281609846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281610849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281610849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716281610849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281611853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281611853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716281611853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281612855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281612855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716281612855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281613857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281613857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9537	1716281613857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281614860	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281614860	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9537	1716281614860	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281615862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281615862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9537	1716281615862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281616864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281616864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281616864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281617866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281617866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281617866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281618869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281618869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9557	1716281618869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281619871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281619871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9549	1716281619871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281620873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281620873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9549	1716281620873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281621875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281621875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9549	1716281621875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281622877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281622877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716281622877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281623881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281623881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716281623881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281624884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281624884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716281624884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281625886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281625886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9525	1716281625886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281626888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281626888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9525	1716281626888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281627890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281627890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9525	1716281627890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281628892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281628892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9546	1716281628892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281629894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281629894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9546	1716281629894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281630896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281630896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9546	1716281630896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281631899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281631899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9567	1716281631899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281632901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281632901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9567	1716281632901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281633903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281633903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9567	1716281633903	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281634905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281634905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281634905	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281635907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281635907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281635907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281636910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281636910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281636910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281637912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281637912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9563	1716281637912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281638915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281638915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9563	1716281638915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281639917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281639917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9563	1716281639917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281640920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281640920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281620898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281621904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281622907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281623907	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281624901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281625910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281626920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281627918	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281628918	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281629920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281630923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281631926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281632928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281633933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281634932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281635932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281636939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281637940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281638942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281639944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281640949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281641947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281642949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281643953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281644954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281645955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281646958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281647962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281648965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281649965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281650973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281651977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281652975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281653976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281654972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281655982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281656986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281657987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281658988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281659990	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281846393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9714	1716281846393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281847395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281847395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281847395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281848397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281848397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281848397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281849399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281849399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281849399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281850401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281850401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9722	1716281850401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281851404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281851404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9722	1716281851404	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281852406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281852406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9722	1716281852406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281853408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281853408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281853408	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281854410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281854410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281640920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281641922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281641922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281641922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281642925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281642925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9574	1716281642925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281643927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281643927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281643927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281644928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281644928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281644928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281645931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281645931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281645931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281646933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281646933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281646933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281647936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281647936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281647936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281648938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281648938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281648938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281649940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281649940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281649940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281650942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281650942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281650942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281651945	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281651945	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281651945	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281652947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281652947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9585	1716281652947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281653949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281653949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9585	1716281653949	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281654952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281654952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9585	1716281654952	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281655954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281655954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9576	1716281655954	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281656956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281656956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9576	1716281656956	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281657959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281657959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9576	1716281657959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281658961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281658961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281658961	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281659963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281659963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281659963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281660965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281660965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9553	1716281660965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281660992	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281661967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281661967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9565	1716281661967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281662970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281662970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9565	1716281662970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281663972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281663972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9565	1716281663972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281664975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281664975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281664975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281665978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281665978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281665978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281666980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281666980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281666980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281667982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281667982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9572	1716281667982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281668984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281668984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9572	1716281668984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281669986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281669986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9572	1716281669986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281670988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281670988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281670988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281671991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281671991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281671991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281672993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281672993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.958	1716281672993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281673995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281673995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281673995	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281674997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281674997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281674997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281675999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.3	1716281675999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281675999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281677001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281677001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281677001	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281678004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281678004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281678004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281679006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281679006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281679006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281680009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281680009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9601	1716281680009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281681011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281681011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9601	1716281681011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281682013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281682013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9601	1716281682013	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281683015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281683015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.959	1716281683015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281661996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281662998	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281664000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281664994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281666005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281667006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281668009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281669010	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281670003	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281671014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281672016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281673015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281674023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281675015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281676025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281677027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281678029	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281679034	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281680028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281681037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281682038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281683043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281684042	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281685035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281686046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281687048	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281688051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281689051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281690058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281691063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281692061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281693063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281694066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281695060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281696070	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281697074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281698078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281699080	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281700073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281701083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281702087	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281703085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281704089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281705096	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281706095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281707095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281708099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281709103	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281710102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281711105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281712106	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281713101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281714113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281715119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281716115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281717120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281718125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281719118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281720124	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281721130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281722123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281723132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281724134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281725130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281726138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281684017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281684017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.959	1716281684017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281685018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281685018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281685018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281686020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281686020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281686020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281687023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281687023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9587	1716281687023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281688025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281688025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9578	1716281688025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281689028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281689028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9578	1716281689028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281690031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281690031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9578	1716281690031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281691033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281691033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9589	1716281691033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281692035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281692035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9589	1716281692035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281693038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281693038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9589	1716281693038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281694040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281694040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281694040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281695043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281695043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281695043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281696045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281696045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9569	1716281696045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281697047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281697047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9573	1716281697047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281698050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281698050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9573	1716281698050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281699052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281699052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9573	1716281699052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281700054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281700054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281700054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281701057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281701057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281701057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281702058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281702058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281702058	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281703060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281703060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281703060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281704063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281704063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281704063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281705065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281705065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9586	1716281705065	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281706067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281706067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.959	1716281706067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281707069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281707069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.959	1716281707069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281708071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281708071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.959	1716281708071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281709074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281709074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281709074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281710076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281710076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281710076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281711078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281711078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281711078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281712081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281712081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9590999999999998	1716281712081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281713083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281713083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9590999999999998	1716281713083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281714085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281714085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9590999999999998	1716281714085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281715088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281715088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9597	1716281715088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281716090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281716090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9597	1716281716090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281717092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281717092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9597	1716281717092	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281718094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281718094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9593	1716281718094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281719097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281719097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9593	1716281719097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281720099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281720099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9593	1716281720099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281721102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281721102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9613	1716281721102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281722104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281722104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9613	1716281722104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281723107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281723107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9613	1716281723107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281724109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281724109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9616	1716281724109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281725111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281725111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9616	1716281725111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281726113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281726113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9616	1716281726113	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281727115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281727115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281727115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281728120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281728120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281728120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281729122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281729122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281729122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281730125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281730125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281730125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281731127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281731127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281731127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281732129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281732129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281732129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281733131	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281733131	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281733131	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281734134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281734134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281734134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281735136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281735136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281735136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281736138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281736138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9662	1716281736138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281737140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281737140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9662	1716281737140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281738142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281738142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9662	1716281738142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281739145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281739145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281739145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281740147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281740147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281740147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281741148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281741148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281741148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281742151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281742151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281742151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281743152	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281743152	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281743152	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281744155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281744155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716281744155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281745157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281745157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9621	1716281745157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281746158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281746158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9621	1716281746158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281747161	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281747161	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9621	1716281747161	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281727143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281728148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281729150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281730143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281731152	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281732155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281733158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281734160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281735162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281736163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281737158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281738168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281739169	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281740166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281741178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281742174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281743177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281744179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281745177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281746185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281747187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281748191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281749190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281750200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281751203	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281752201	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281753203	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281754206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281755202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281756209	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281757214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281758210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281759216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281760220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281761223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281762225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281763226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281764233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281765232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281766231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281767236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281768239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281769244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281770237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281771244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281772247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281773247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281774249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281775245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281776256	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281777257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281778260	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281779261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281780266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281781269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281782274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281783270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281784275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281785269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281786276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281787282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281788282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281789287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281790280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281791290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281748163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281748163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9633	1716281748163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281749165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281749165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9633	1716281749165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281750170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281750170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9633	1716281750170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281751172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281751172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9606	1716281751172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281752174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281752174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9606	1716281752174	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281753177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281753177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9606	1716281753177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281754179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	7.9	1716281754179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281754179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281755181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.2	1716281755181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281755181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281756183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281756183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9622	1716281756183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281757185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281757185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281757185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281758187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281758187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281758187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281759190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281759190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281759190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281760193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281760193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716281760193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281761195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281761195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716281761195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281762197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281762197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716281762197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281763199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281763199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281763199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281764202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281764202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281764202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281765204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281765204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9670999999999998	1716281765204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281766206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281766206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9637	1716281766206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281767209	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281767209	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9637	1716281767209	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281768211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281768211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9637	1716281768211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281769213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281769213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.966	1716281769213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281770215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281770215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.966	1716281770215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281771217	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716281771217	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.966	1716281771217	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281772220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281772220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281772220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281773222	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281773222	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281773222	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281774224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281774224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281774224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281775227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281775227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281775227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281776229	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281776229	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281776229	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281777231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281777231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281777231	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281778234	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281778234	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.968	1716281778234	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281779236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281779236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.968	1716281779236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281780238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281780238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.968	1716281780238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281781240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281781240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667000000000001	1716281781240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281782243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281782243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667000000000001	1716281782243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281783245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281783245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667000000000001	1716281783245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281784247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281784247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716281784247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281785249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281785249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716281785249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281786251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281786251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716281786251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281787254	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281787254	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281787254	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281788255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281788255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281788255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281789257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281789257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9661	1716281789257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281790260	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281790260	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281790260	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281791262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281791262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281791262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281792264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281792264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.967	1716281792264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281793266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281793266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281793266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281794268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281794268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281794268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281795271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281795271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281795271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281796273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281796273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281796273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281797275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281797275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281797275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281798277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716281798277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9666	1716281798277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281799280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281799280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281799280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281800282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281800282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281800282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281801285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281801285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281801285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281802287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281802287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9676	1716281802287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281803289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281803289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9676	1716281803289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281804291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281804291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9676	1716281804291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281805294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281805294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9679	1716281805294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281806296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281806296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9679	1716281806296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281807298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281807298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9679	1716281807298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281808300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281808300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281808300	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281809302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281809302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281809302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281810304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281810304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281810304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281811307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281811307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281811307	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281792289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281793294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281794296	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281795301	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281796299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281797302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281798305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281799306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281800301	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281801311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281802311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281803315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281804318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281805313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281806326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281807323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281808330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281809332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281810330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281811332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281812334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281813336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281814338	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281815335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281816344	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281817347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281818349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281819351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281820347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281821355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281822353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281823361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281824364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281825364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281826371	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281827372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281828374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281829368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281830376	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281831383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281832382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281833384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281834380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281835390	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281836393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281837395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281838398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281839394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281840401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281854410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281855413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281855413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281855413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281856415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281856415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9739	1716281856415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281857417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281857417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9739	1716281857417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281858419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281858419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9739	1716281858419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281859422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281859422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9743	1716281859422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281812309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281812309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281812309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281813311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281813311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9582	1716281813311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281814313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281814313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716281814313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281815315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281815315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716281815315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281816317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281816317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716281816317	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281817320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281817320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9663	1716281817320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281818323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281818323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9663	1716281818323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281819325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281819325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9663	1716281819325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281820327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281820327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281820327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281821329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281821329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281821329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281822331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281822331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9659	1716281822331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281823333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281823333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.964	1716281823333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281824336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281824336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.964	1716281824336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281825340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281825340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.964	1716281825340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281826343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281826343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9650999999999998	1716281826343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281827345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281827345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9650999999999998	1716281827345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281828347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281828347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9650999999999998	1716281828347	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281829349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281829349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9678	1716281829349	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281830351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281830351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9678	1716281830351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281831353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281831353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9678	1716281831353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281832355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281832355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9702	1716281832355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281833360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281833360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9702	1716281833360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281834362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281834362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9702	1716281834362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281835364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281835364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281835364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281836367	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281836367	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281836367	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281837369	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281837369	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281837369	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281838372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281838372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9717	1716281838372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281839374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281839374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9717	1716281839374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281840377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281840377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9717	1716281840377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281860425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281860425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9743	1716281860425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281861427	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281861427	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9743	1716281861427	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281862429	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281862429	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.98	1716281862429	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281863431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281863431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.98	1716281863431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281863458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281864433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281864433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.98	1716281864433	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281864457	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281865435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281865435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9817	1716281865435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281865454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281866437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281866437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9817	1716281866437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281866463	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281867439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281867439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9817	1716281867439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281867465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281868441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281868441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9829	1716281868441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281868474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281869443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281869443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9829	1716281869443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281869461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281870446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281870446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9829	1716281870446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281870471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281871448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281871448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281871448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281872450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281872450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281872450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281873455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281873455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281873455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281874457	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281874457	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9602	1716281874457	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281875460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281875460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9602	1716281875460	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281876462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716281876462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9602	1716281876462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281877466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281877466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9819	1716281877466	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281878469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281878469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9819	1716281878469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281879471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281879471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9819	1716281879471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281880474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281880474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9843	1716281880474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281881476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281881476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9843	1716281881476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281882478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281882478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9843	1716281882478	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281883480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281883480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9655	1716281883480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281884482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281884482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9655	1716281884482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281885484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281885484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9655	1716281885484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281886487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281886487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9704000000000002	1716281886487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281887489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281887489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9704000000000002	1716281887489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281888491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281888491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9704000000000002	1716281888491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281889494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281889494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9694	1716281889494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281890496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281890496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9694	1716281890496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281891498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281891498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9694	1716281891498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281892500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281871473	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281872475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281873480	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281874479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281875488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281876488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281877491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281878494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281879492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281880501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281881502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281882503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281883508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281884499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281885509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281886516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281887520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281888516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281889525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281890519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281891523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281892525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281893532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281894531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281895525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281896536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281897537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281898538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281899543	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281900538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281901548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281902550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281903560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281904559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281905548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281906557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281907556	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281908566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281909565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281910561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281911567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281912574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281913576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281914579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281915579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281916584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281917588	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281918590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281919592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281920589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281921601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281922597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281923601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281924601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281925600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281926606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281927610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281928613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281929613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281930615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281931617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281932620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281933625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281934623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281935628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281892500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281892500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281893503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281893503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281893503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281894505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281894505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9713	1716281894505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281895507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281895507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9690999999999999	1716281895507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281896510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281896510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9690999999999999	1716281896510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281897512	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281897512	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9690999999999999	1716281897512	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281898514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281898514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9683	1716281898514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281899516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281899516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9683	1716281899516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281900519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281900519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9683	1716281900519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281901521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281901521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281901521	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281902523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281902523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281902523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281903526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281903526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281903526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281904528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281904528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281904528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281905530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281905530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281905530	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281906532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281906532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9721	1716281906532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281907535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281907535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281907535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281908538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281908538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281908538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281909541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281909541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9724000000000002	1716281909541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281910542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281910542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9727000000000001	1716281910542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281911545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281911545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9727000000000001	1716281911545	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281912548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281912548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9727000000000001	1716281912548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281913550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281913550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9792	1716281913550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281914552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281914552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9792	1716281914552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281915555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281915555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9792	1716281915555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281916557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281916557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.978	1716281916557	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281917559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281917559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.978	1716281917559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281918561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281918561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.978	1716281918561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281919565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281919565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9782	1716281919565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281920568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281920568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9782	1716281920568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281921570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281921570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9782	1716281921570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281922572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281922572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281922572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281923574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281923574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281923574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281924576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281924576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281924576	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281925578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281925578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281925578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281926581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281926581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281926581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281927583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281927583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9835	1716281927583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281928586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281928586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716281928586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281929588	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281929588	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716281929588	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281930590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281930590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716281930590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281931593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281931593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875999999999998	1716281931593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281932595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281932595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875999999999998	1716281932595	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281933597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281933597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875999999999998	1716281933597	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281934599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281934599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716281934599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281935601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281935601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716281935601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281936604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281936604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716281936604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281937606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281937606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281937606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281938608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281938608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281938608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281939612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281939612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281939612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281940614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281940614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9905	1716281940614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281941616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281941616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9905	1716281941616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281942619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281942619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9905	1716281942619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281943620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281943620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716281943620	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281944623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281944623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716281944623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281945625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281945625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716281945625	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281946627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281946627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.991	1716281946627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281947629	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281947629	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.991	1716281947629	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716281948634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281948634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.991	1716281948634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281949636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281949636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281949636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281950638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281950638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281950638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281951640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.700000000000001	1716281951640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716281951640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281952643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281952643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.992	1716281952643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281953645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281953645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.992	1716281953645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281954647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281954647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.992	1716281954647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281955649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281955649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9669	1716281955649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281956651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281936633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281937633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281938634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281939640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281940639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281941633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281942647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281943645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281944648	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281945647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281946653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281947658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281948659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281949654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281950665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281951668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281952668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281953671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281954668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281955682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281956677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281957684	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281958686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281959677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281960679	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281961695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281962693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281963694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281964696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281965690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281966699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281967704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281968705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281969709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281970701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281971711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281972713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281973718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281974715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281975713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281976726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281977727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281978727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281979723	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281980734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281981732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281982735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281983737	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281984738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281985741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281986745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281987744	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281988753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281989752	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281990755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281991756	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281992758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281993759	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281994754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281995763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281996766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281997770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281998770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716281999765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282000778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281956651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9669	1716281956651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281957654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281957654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9669	1716281957654	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281958657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281958657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9719	1716281958657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281959659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281959659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9719	1716281959659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281960661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281960661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9719	1716281960661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281961663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281961663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9759	1716281961663	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281962665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281962665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9759	1716281962665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281963668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281963668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9759	1716281963668	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281964670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281964670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281964670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281965672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281965672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281965672	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281966674	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281966674	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716281966674	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281967677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281967677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281967677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281968679	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281968679	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281968679	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716281969682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281969682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9701	1716281969682	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281970684	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281970684	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9752	1716281970684	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281971686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281971686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9752	1716281971686	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281972688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281972688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9752	1716281972688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281973691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281973691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716281973691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281974693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281974693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716281974693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716281975694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281975694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716281975694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281976696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281976696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281976696	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281977699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281977699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281977699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281978701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281978701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281978701	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281979703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281979703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281979703	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281980705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281980705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281980705	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281981707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281981707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9787000000000001	1716281981707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281982709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281982709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716281982709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281983712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281983712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716281983712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281984714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281984714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9808	1716281984714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281985716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281985716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716281985716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281986718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281986718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716281986718	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281987720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281987720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716281987720	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281988722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281988722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9813	1716281988722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281989724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281989724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9813	1716281989724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281990727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281990727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9813	1716281990727	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281991729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281991729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281991729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281992731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281992731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281992731	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716281993734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281993734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9825	1716281993734	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281994735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281994735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9864000000000002	1716281994735	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281995738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281995738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9864000000000002	1716281995738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281996740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281996740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9864000000000002	1716281996740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281997742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281997742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9883	1716281997742	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716281998745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716281998745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9883	1716281998745	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716281999747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716281999747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9883	1716281999747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282000749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716282000749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282000749	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282001751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716282001751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282001751	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282002753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.300000000000001	1716282002753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282002753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282003755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8	1716282003755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716282003755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282004758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282004758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716282004758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282005760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282005760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895	1716282005760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282006763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282006763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9917	1716282006763	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282007765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282007765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9917	1716282007765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282008767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282008767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9917	1716282008767	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282009769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282009769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282009769	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282010773	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282010773	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282010773	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282011776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282011776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282011776	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282012777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282012777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9926	1716282012777	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282013782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282013782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9926	1716282013782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282014783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282014783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9926	1716282014783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282015787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282015787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716282015787	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282016789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282016789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716282016789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282017792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282017792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716282017792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282018794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282018794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9927000000000001	1716282018794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282019796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282019796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9927000000000001	1716282019796	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282500942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282001778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282002779	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282003781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282004785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282005785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282006788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282007794	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282008795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282009788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282010801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282011803	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282012804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282013806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282014802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282015813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282016817	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282017817	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282018823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282019823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282020798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282020798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9927000000000001	1716282020798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282020823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282021801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282021801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9945	1716282021801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282021835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282022804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282022804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9945	1716282022804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282022831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282023806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282023806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9945	1716282023806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282023834	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282024808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282024808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9966	1716282024808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282024827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282025811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282025811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9966	1716282025811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282025840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282026814	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282026814	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9966	1716282026814	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282026839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282027816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282027816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716282027816	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282027842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282028818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282028818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716282028818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282028846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282029821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282029821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716282029821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282029844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282030823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282030823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9777	1716282030823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282030850	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282031826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282031826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9777	1716282031826	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282032828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282032828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9777	1716282032828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282033831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282033831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9768	1716282033831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282034833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282034833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9768	1716282034833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282035836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282035836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9768	1716282035836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282036838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282036838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9715	1716282036838	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282037840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282037840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9715	1716282037840	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282038842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282038842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9715	1716282038842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282039844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282039844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716282039844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282040847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282040847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716282040847	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282041849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282041849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9772	1716282041849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282042852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282042852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9802	1716282042852	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282043854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282043854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9802	1716282043854	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282044857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282044857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9802	1716282044857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282045859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282045859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9815	1716282045859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282046862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282046862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9815	1716282046862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282047866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282047866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9815	1716282047866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282048868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282048868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9838	1716282048868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282049871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282049871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9838	1716282049871	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282050873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282050873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9838	1716282050873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282051875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.5	1716282051875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9850999999999999	1716282051875	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282052877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282052877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9850999999999999	1716282052877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282031853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282032855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282033858	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282034859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282035862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282036869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282037867	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282038870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282039865	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282040864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282041868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282042879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282043876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282044873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282045887	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282046887	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282047893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282048897	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282049896	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282050899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282051898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282052894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282053909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282054897	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282055909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282056912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282057913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282058915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282059910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282060923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282061925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282062925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282063926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282064929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282065932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282066937	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282067939	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282068940	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282069936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282070944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282071947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282072953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282073953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282074955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282075962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282076960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282077963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282078964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282079969	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282080973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282081973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282082974	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282083976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282084972	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282085981	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282086985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282087984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282088987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282089991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282090990	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282091996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282092993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282093997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282094998	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282095999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282053879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282053879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9850999999999999	1716282053879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282054881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282054881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282054881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282055883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282055883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282055883	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282056886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282056886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282056886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282057888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282057888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9869	1716282057888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282058890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282058890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9869	1716282058890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282059892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282059892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9869	1716282059892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282060895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282060895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.995	1716282060895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282061898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282061898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.995	1716282061898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282062899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282062899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.995	1716282062899	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282063901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282063901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9978	1716282063901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282064904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282064904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9978	1716282064904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282065906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282065906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9978	1716282065906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282066909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282066909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282066909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282067911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282067911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282067911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282068915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282068915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282068915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282069918	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282069918	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282069918	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282070920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282070920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282070920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282071923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282071923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.997	1716282071923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282072925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282072925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9989000000000001	1716282072925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282073928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282073928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9989000000000001	1716282073928	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282074930	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282074930	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9989000000000001	1716282074930	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282075932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282075932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9988	1716282075932	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282076934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282076934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9988	1716282076934	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282077936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282077936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9988	1716282077936	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282078938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282078938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0024	1716282078938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282079941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282079941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0024	1716282079941	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282080944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282080944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0024	1716282080944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282081946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282081946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0048	1716282081946	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282082948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282082948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0048	1716282082948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282083951	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282083951	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0048	1716282083951	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282084953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282084953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0036	1716282084953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282085955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282085955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0036	1716282085955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282086957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282086957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0036	1716282086957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282087958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282087958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0027	1716282087958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282088960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282088960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0027	1716282088960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282089962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282089962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0027	1716282089962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282090964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282090964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282090964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282091967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282091967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282091967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282092969	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282092969	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282092969	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282093971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282093971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9972	1716282093971	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282094974	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282094974	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9972	1716282094974	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282095976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282095976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9972	1716282095976	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282096978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282096978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9986	1716282096978	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282097980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282097980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9986	1716282097980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282098983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282098983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9986	1716282098983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282099985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282099985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9855999999999998	1716282099985	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282100987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282100987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9855999999999998	1716282100987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282101989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282101989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9855999999999998	1716282101989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282102994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282102994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282102994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282103997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282103997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282103997	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282105000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282105000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282105000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282106002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282106002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9888	1716282106002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282107005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282107005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9888	1716282107005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282108007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282108007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9888	1716282108007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282109009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282109009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282109009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282110012	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282110012	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282110012	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282111014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282111014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9865	1716282111014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282112016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282112016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895999999999998	1716282112016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282113018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282113018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9895999999999998	1716282113018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282114021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282114021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9907000000000001	1716282114021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282115023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282115023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9907000000000001	1716282115023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282116025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282116025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9907000000000001	1716282116025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282117027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282117027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9904000000000002	1716282117027	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282096999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282098006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282099009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282100003	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282101012	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282102018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282103021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282104025	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282105017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282106030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282107035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282108034	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282109037	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282110041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282111041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282112043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282113043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282114047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282115045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282116050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282117052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282118060	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282119056	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282120059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282121063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282122066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282123066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282124070	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282125071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282126076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282127079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282128081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282129082	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282130079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282131085	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282132090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282133094	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282134097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282135088	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282136101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282137101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282138105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282139097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282140108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282141109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282142114	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282143114	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282144109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282145121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282146121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282147127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282148127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282149124	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282150126	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282151134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282152139	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282153136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282154140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282155141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282156146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282157146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282158151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282159154	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282160150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282161157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282118029	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282118029	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9904000000000002	1716282118029	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282119031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282119031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9904000000000002	1716282119031	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282120033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282120033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282120033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282121035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282121035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282121035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282122038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282122038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9924000000000002	1716282122038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282123040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282123040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.996	1716282123040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282124042	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282124042	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.996	1716282124042	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282125046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282125046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.996	1716282125046	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282126049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282126049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282126049	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282127051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.800000000000001	1716282127051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282127051	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282128053	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282128053	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282128053	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282129056	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282129056	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282129056	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282130059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282130059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282130059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282131061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282131061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0025	1716282131061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282132063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282132063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282132063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282133066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282133066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282133066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282134069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282134069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0042	1716282134069	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282135070	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282135070	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282135070	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282136072	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282136072	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282136072	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282137074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282137074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282137074	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282138076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282138076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282138076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282139079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282139079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282139079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282140081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282140081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282140081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282141083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282141083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282141083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282142086	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282142086	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282142086	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282143089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282143089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0091	1716282143089	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282144091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282144091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.009	1716282144091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282145093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282145093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.009	1716282145093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282146095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282146095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.009	1716282146095	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282147098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282147098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282147098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282148100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282148100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282148100	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282149102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282149102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282149102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282150105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282150105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282150105	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282151107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282151107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282151107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282152109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282152109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282152109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282153111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282153111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282153111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282154114	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282154114	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282154114	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282155116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282155116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282155116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282156119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282156119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105999999999997	1716282156119	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282157121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282157121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105999999999997	1716282157121	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282158123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282158123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105999999999997	1716282158123	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282159125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282159125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282159125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282160127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282160127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282160127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282161130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282161130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0095	1716282161130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282162132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282162132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0098	1716282162132	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282163134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282163134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0098	1716282163134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282164136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282164136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0098	1716282164136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282165139	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282165139	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0087	1716282165139	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282166141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282166141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0087	1716282166141	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282167143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282167143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0087	1716282167143	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282168146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282168146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0102	1716282168146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282169148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282169148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0102	1716282169148	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282170151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282170151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0102	1716282170151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282171153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282171153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875	1716282171153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282172156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282172156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875	1716282172156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282173159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282173159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9875	1716282173159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282174162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282174162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9897	1716282174162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282175164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282175164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9897	1716282175164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282176166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282176166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9897	1716282176166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282177168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282177168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9910999999999999	1716282177168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282178171	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282178171	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9910999999999999	1716282178171	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282179173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282179173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9910999999999999	1716282179173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282180175	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282180175	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716282180175	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282181178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282181178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716282181178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282162165	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282163159	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282164163	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282165156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282166169	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282167173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282168170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282169167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282170179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282171178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282172183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282173183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282174187	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282175181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282176191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282177194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282178199	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282179200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282180197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282181204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282182207	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282183210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282184210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282185213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282186215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282187218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282188216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282189219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282190215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282191227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282192232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282193233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282194232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282195225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282196236	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282197238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282198244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282199234	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282200244	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282500942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0317	1716282500942	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282501944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282501944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282501944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282502947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282502947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282502947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282503948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282503948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282503948	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282504950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282504950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0332	1716282504950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282505953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282505953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0332	1716282505953	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282506957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282506957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0332	1716282506957	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282507958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282507958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282507958	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282508960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282508960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282508960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282182180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282182180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9858	1716282182180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282183182	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282183182	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9914	1716282183182	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282184184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282184184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9914	1716282184184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282185186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282185186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9914	1716282185186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282186189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282186189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9932	1716282186189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282187191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282187191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9932	1716282187191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282188193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282188193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9932	1716282188193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282189195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282189195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9944000000000002	1716282189195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282190198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282190198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9944000000000002	1716282190198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282191200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282191200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9944000000000002	1716282191200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282192202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282192202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282192202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282193204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282193204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282193204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282194206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282194206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282194206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282195208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.1	1716282195208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0038	1716282195208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282196210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282196210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0038	1716282196210	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282197212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.4	1716282197212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0038	1716282197212	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282198214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282198214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282198214	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282199216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282199216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282199216	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282200218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282200218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282200218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282201221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282201221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0034	1716282201221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282201252	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282202224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282202224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0034	1716282202224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282202249	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282203253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282204246	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282205258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282206258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282207262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282208262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282209257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282210268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282211273	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282212270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282213277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282214276	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282215282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282216282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282217284	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282218283	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282219279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282220289	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282221292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282222294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282223298	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282224291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282225301	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282226303	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282227302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282228308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282229314	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282230315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282231315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282232323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282233324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282234327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282235327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282236329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282237333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282238329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282239337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282240340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282241345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282242344	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282243340	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282244342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282245353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282246354	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282247358	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282248358	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282249356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282250361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282251371	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282252370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282253377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282254367	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282255379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282256379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282257384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282258385	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282259388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282260391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282261396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282262395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282263399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282264392	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282265400	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282266402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282203226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282203226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0034	1716282203226	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282204228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282204228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0107	1716282204228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282205230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282205230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0107	1716282205230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282206233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282206233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0107	1716282206233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282207235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282207235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282207235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282208237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282208237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282208237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282209239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282209239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282209239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282210241	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282210241	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282210241	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282211243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282211243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282211243	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282212245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.6	1716282212245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282212245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282213248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282213248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0116	1716282213248	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282214250	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282214250	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0116	1716282214250	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282215253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282215253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0116	1716282215253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282216255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282216255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0104	1716282216255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282217257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282217257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0104	1716282217257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282218259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282218259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0104	1716282218259	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282219262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282219262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0119000000000002	1716282219262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282220264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282220264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0119000000000002	1716282220264	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282221266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282221266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0119000000000002	1716282221266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282222268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282222268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282222268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282223270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282223270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282223270	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282224272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282224272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282224272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282225275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282225275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282225275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282226277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282226277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282226277	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282227279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282227279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282227279	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282228284	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282228284	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282228284	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282229286	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282229286	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282229286	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282230288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282230288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282230288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282231291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282231291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0162999999999998	1716282231291	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282232294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282232294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0162999999999998	1716282232294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282233297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282233297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0162999999999998	1716282233297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282234299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282234299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282234299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282235302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282235302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282235302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282236304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282236304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.015	1716282236304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282237306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282237306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0012	1716282237306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282238309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282238309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0012	1716282238309	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282239311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282239311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0012	1716282239311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282240315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282240315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0136	1716282240315	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282241318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282241318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0136	1716282241318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282242320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282242320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0136	1716282242320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282243322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282243322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282243322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282244324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282244324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282244324	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282245327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282245327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9899	1716282245327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282246329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282246329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716282246329	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282247331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282247331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716282247331	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282248333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282248333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9909000000000001	1716282248333	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282249335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282249335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9938	1716282249335	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282250337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282250337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9938	1716282250337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282251341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282251341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9938	1716282251341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282252343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282252343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282252343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282253346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282253346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282253346	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282254348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282254348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9885	1716282254348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282255351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282255351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9925	1716282255351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282256354	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282256354	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9925	1716282256354	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282257356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282257356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9925	1716282257356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282258359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282258359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9952999999999999	1716282258359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282259361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282259361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9952999999999999	1716282259361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282260364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282260364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9952999999999999	1716282260364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282261366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282261366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282261366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282262368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282262368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282262368	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282263370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282263370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716282263370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282264372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282264372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716282264372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282265375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282265375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716282265375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282266378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282266378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716282266378	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282267380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282267380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0033	1716282267380	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282268382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282268382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0033	1716282268382	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282269384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282269384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0033	1716282269384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282270386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282270386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0082	1716282270386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282271388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282271388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0082	1716282271388	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282272391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282272391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0082	1716282272391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282273393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282273393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282273393	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282274395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282274395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282274395	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282275397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282275397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0078	1716282275397	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282276399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282276399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282276399	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282277402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282277402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282277402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282278406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.9	1716282278406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0077000000000003	1716282278406	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282279409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282279409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282279409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282280411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282280411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282280411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282281413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282281413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282281413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282282415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282282415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282282415	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282283417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282283417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282283417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282284418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282284418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282284418	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282285421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282285421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282285421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282286423	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282286423	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282286423	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282287425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282287425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0118	1716282287425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282288430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282267405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282268411	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282269409	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282270413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282271417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282272417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282273419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282274416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282275424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282276425	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282277428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282278432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282279436	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282280430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282281438	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282282440	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282283444	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282284445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282285443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282286450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282287450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282288456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282289459	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282290461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282291462	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282292465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282293465	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282294464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282295472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282296477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282297479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282298479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282299472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282300486	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282301479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282302488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282303495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282304498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282305495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282306509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282307506	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282308507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282309502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282310511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282311515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282312515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282313518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282314516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282315522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282316526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282317529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282318529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282319524	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282320528	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282321537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282322539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282323538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282324542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282325539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282326549	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282327551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282328552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282329552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282330546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282331556	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282288430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0117000000000003	1716282288430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282289432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282289432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0117000000000003	1716282289432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282290435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282290435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0117000000000003	1716282290435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282291437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282291437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0138	1716282291437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282292439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282292439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0138	1716282292439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282293441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282293441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0138	1716282293441	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282294444	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282294444	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0120999999999998	1716282294444	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282295446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282295446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0120999999999998	1716282295446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282296448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282296448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0120999999999998	1716282296448	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282297451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282297451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282297451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282298453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282298453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282298453	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282299455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282299455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.013	1716282299455	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282300458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282300458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0127	1716282300458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282301461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282301461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0127	1716282301461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282302464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282302464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0127	1716282302464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282303467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282303467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282303467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282304469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282304469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282304469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282305472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282305472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0158	1716282305472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282306476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282306476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0159000000000002	1716282306476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282307477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282307477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0159000000000002	1716282307477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282308479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282308479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0159000000000002	1716282308479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282309482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282309482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0155	1716282309482	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282310484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282310484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0155	1716282310484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282311487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282311487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0155	1716282311487	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282312489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282312489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0148	1716282312489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282313491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282313491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0148	1716282313491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282314493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282314493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0148	1716282314493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282315496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282315496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282315496	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282316498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282316498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282316498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282317500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282317500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0067	1716282317500	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282318502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282318502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282318502	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282319504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282319504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282319504	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282320507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282320507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0105	1716282320507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282321509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282321509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0132	1716282321509	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282322511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282322511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0132	1716282322511	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282323513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282323513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0132	1716282323513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282324515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282324515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0145	1716282324515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282325518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282325518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0145	1716282325518	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282326520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282326520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0145	1716282326520	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282327523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282327523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0156	1716282327523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282328525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.9	1716282328525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0156	1716282328525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282329527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282329527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0156	1716282329527	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282330529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282330529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0184	1716282330529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282331531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282331531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0184	1716282331531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282332533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282332533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0184	1716282332533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282333535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282333535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282333535	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282334537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282334537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282334537	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282335540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282335540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282335540	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282336542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282336542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282336542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282337544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282337544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282337544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282338547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282338547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282338547	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282339551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282339551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0328	1716282339551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282340554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282340554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0328	1716282340554	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282341556	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282341556	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0328	1716282341556	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282342558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282342558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282342558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282343560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282343560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282343560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282344562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282344562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282344562	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282345565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282345565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0379	1716282345565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282346567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282346567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0379	1716282346567	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282347568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282347568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0379	1716282347568	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282348570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282348570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0352	1716282348570	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282349572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282349572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0352	1716282349572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282350575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282350575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0352	1716282350575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282351578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282351578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282351578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282352580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282332561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282333561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282334561	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282335558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282336572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282337575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282338572	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282339579	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282340571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282341585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282342584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282343585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282344589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282345582	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282346598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282347596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282348596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282349601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282350604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282351601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282352608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282353608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282354605	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282355612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282356617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282357615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282358622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282359616	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282360627	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282361628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282362628	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282363632	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282364624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282365635	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282366640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282367641	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282368646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282369639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282370642	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282371646	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282372650	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282373661	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282374659	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282375657	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282376667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282377671	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282378670	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282379669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282500967	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282501973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282502975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282503980	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282504968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282505987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282506983	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282507986	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282508988	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282509982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282510993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282511993	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282512996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282514000	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282515002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282516002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282517005	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282352580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282352580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282353583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282353583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282353583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282354585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282354585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282354585	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282355586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282355586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282355586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282356590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282356590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282356590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282357592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282357592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282357592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282358594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282358594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282358594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282359596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282359596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282359596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282360599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282360599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282360599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282361600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282361600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282361600	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282362602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282362602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282362602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282363604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282363604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282363604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282364607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282364607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282364607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282365610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282365610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282365610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282366612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282366612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282366612	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282367614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282367614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282367614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282368617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282368617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282368617	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282369619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282369619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0375	1716282369619	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282370622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282370622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0375	1716282370622	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282371624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282371624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0375	1716282371624	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282372626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282372626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282372626	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282373631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282373631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282373631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282374633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282374633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282374633	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282375636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282375636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0382000000000002	1716282375636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282376638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282376638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0382000000000002	1716282376638	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282377640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282377640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0382000000000002	1716282377640	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282378643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282378643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282378643	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282379645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282379645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282379645	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282380647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282380647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282380647	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282380665	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282381649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282381649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282381649	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282381678	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282382651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282382651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282382651	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282382681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282383653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282383653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282383653	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282383681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282384655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282384655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0154	1716282384655	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282384673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282385658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282385658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0154	1716282385658	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282385685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282386660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282386660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0154	1716282386660	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282386688	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282387662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282387662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282387662	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282387691	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282388664	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282388664	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282388664	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282388689	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282389667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282389667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282389667	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282389687	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282390669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282390669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282390669	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282390694	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282391673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282391673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282391673	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282392677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282392677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.021	1716282392677	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282393681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282393681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0234	1716282393681	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282394683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282394683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0234	1716282394683	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282395685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282395685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0234	1716282395685	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282396690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282396690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0215	1716282396690	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282397693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282397693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0215	1716282397693	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282398695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282398695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0215	1716282398695	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282399698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282399698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0255	1716282399698	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282400700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282400700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0255	1716282400700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282401702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282401702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0255	1716282401702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282402704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282402704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0254000000000003	1716282402704	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282403709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282403709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0254000000000003	1716282403709	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282404711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282404711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0254000000000003	1716282404711	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282405713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282405713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0272	1716282405713	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282406715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282406715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0272	1716282406715	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282407717	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282407717	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0272	1716282407717	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282408719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282408719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0258	1716282408719	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282409724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282409724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0258	1716282409724	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282410726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282410726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0258	1716282410726	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282411728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282411728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0262000000000002	1716282411728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282412730	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282412730	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282391699	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282392700	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282393707	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282394702	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282395712	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282396716	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282397721	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282398722	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282399714	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282400733	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282401728	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282402732	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282403739	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282404729	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282405740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282406741	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282407743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282408747	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282409744	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282410753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282411753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282412758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282413761	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282414754	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282415768	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282416766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282417771	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282418765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282419765	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282420778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282421778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282422785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282423786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282424782	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282425786	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282426793	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282427793	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282428795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282429804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282430801	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282431805	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282432808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282433812	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282434813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282435811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282436818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282437821	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282438825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282439827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282440828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282441832	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282442837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282443836	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282444831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282445843	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282446846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282447848	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282448851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282449844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282450851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282451853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282452856	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282453860	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282454862	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282455864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0262000000000002	1716282412730	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282413733	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282413733	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0262000000000002	1716282413733	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282414736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282414736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0276	1716282414736	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282415738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282415738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0276	1716282415738	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282416740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282416740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0276	1716282416740	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282417743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282417743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0271	1716282417743	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282418746	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282418746	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0271	1716282418746	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282419748	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282419748	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0271	1716282419748	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282420750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282420750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0282999999999998	1716282420750	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282421753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282421753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0282999999999998	1716282421753	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282422755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282422755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0282999999999998	1716282422755	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282423758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282423758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282423758	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282424760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282424760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282424760	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282425762	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282425762	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282425762	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282426766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282426766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282426766	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282427768	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282427768	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282427768	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282428770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282428770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282428770	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282429775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.6	1716282429775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282429775	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282430778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282430778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282430778	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282431781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282431781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282431781	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282432783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282432783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.032	1716282432783	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282433785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282433785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.032	1716282433785	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282434788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282434788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.032	1716282434788	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282435789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282435789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282435789	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282436792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282436792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282436792	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282437795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282437795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282437795	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282438798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282438798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0312	1716282438798	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282439802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282439802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0312	1716282439802	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282440804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282440804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0312	1716282440804	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282441806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282441806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282441806	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282442808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282442808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282442808	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282443811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282443811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282443811	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282444813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282444813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282444813	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282445815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282445815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282445815	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282446818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282446818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282446818	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282447820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282447820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282447820	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282448823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282448823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282448823	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282449825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282449825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0321	1716282449825	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282450827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282450827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282450827	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282451828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282451828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282451828	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282452831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282452831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282452831	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282453833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282453833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282453833	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282454835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282454835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282454835	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282455837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282455837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0327	1716282455837	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282456839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282456839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0175	1716282456839	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282457842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282457842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0175	1716282457842	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282458844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282458844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0175	1716282458844	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282459846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282459846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0244	1716282459846	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282460849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.5	1716282460849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0244	1716282460849	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282461851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.2	1716282461851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0244	1716282461851	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282462853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282462853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282462853	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282463855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282463855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282463855	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282464857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282464857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282464857	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282465859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282465859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0309	1716282465859	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282466861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282466861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0309	1716282466861	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282467864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282467864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0309	1716282467864	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282468866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282468866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0221	1716282468866	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282469868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282469868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0221	1716282469868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282470870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282470870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0221	1716282470870	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282471873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282471873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0261	1716282471873	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282472874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282472874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0261	1716282472874	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282473877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282473877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0261	1716282473877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282474879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282474879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0274	1716282474879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282475881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282475881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0274	1716282475881	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282476884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282476884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282456865	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282457868	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282458869	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282459865	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282460877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282461879	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282462877	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282463882	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282464876	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282465887	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282466885	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282467891	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282468892	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282469893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282470894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282471901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282472901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282473894	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282474897	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282475906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282476910	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282477912	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282478915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282479913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282480920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282481923	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282482925	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282483927	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282484931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282485933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282486926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282487933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282488933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282489933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282490947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282491947	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282492950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282493950	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282494944	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282495955	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282496959	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282497960	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282498962	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282499964	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282509963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282509963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282509963	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282510965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282510965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282510965	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282511968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282511968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282511968	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282512970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282512970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282512970	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282513973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282513973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282513973	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282514975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282514975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282514975	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282515977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282515977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282515977	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0274	1716282476884	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282477886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282477886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282477886	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282478888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282478888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282478888	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282479890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282479890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0291	1716282479890	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282480893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282480893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282480893	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282481895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282481895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282481895	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282482898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282482898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282482898	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282483901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282483901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0296	1716282483901	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282484904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282484904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0296	1716282484904	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282485906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282485906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0296	1716282485906	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282486909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282486909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0297	1716282486909	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282487911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282487911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0297	1716282487911	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282488913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282488913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0297	1716282488913	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282489915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.7	1716282489915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282489915	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282490917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282490917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282490917	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282491920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282491920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.031	1716282491920	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282492922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282492922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282492922	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282493924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282493924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282493924	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282494926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282494926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282494926	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282495929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282495929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0315	1716282495929	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282496931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282496931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0315	1716282496931	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282497933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282497933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0315	1716282497933	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282498935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282498935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0317	1716282498935	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282499938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282499938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0317	1716282499938	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282516979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282516979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282516979	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282517982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282517982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282517982	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282518011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282518984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282518984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282518984	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282519003	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282519987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282519987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0349	1716282519987	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282520006	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282520989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282520989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0349	1716282520989	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282521017	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282521991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282521991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0349	1716282521991	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282522018	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282522994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282522994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282522994	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282523020	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282523996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282523996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282523996	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282524024	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282524999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282524999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.037	1716282524999	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282525015	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282526002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282526002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.035	1716282526002	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282526023	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282527004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282527004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.035	1716282527004	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282527033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282528007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282528007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.035	1716282528007	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282528032	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282529009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282529009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282529009	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282529039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282530011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282530011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282530011	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282530039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282531014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282531014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0223	1716282531014	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282531039	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282532042	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282533047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282534041	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282535053	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282536052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282537054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282538054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282539063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282540063	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282541064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282542067	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282543066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282544072	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282545075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282546076	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282547078	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282548082	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282549083	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282550080	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282551093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282552090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282553091	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282554097	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282555093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282556099	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282557102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282558102	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282559104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282560108	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282561111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282562112	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282563117	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282564122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282565115	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282566128	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282567127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282568130	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282569135	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282570127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282571147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282572146	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282573147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282574137	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282575150	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282576152	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282577158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282578157	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282579149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282580155	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282581166	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282582168	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282583170	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282584164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282585176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282586177	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282587181	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282588179	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282589173	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282590184	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282591186	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282592190	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282593194	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282594193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282595189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282532016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282532016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0261	1716282532016	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282533019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282533019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0261	1716282533019	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282534021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282534021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282534021	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282535024	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282535024	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282535024	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282536026	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282536026	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282536026	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282537028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282537028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282537028	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282538030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282538030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282538030	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282539033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282539033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282539033	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282540035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282540035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0242	1716282540035	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282541038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282541038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0242	1716282541038	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282542040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282542040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0242	1716282542040	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282543043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282543043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0308	1716282543043	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282544045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282544045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0308	1716282544045	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282545047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282545047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0308	1716282545047	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282546050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282546050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282546050	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282547052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282547052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282547052	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282548054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282548054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0292	1716282548054	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282549057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282549057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.03	1716282549057	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282550059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282550059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.03	1716282550059	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282551061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282551061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.03	1716282551061	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282552064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282552064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282552064	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282553066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282553066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282553066	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282554068	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282554068	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0299	1716282554068	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282555071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282555071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0304	1716282555071	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282556073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282556073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0304	1716282556073	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282557075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282557075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0304	1716282557075	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282558077	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282558077	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282558077	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282559079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282559079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282559079	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282560081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282560081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0303	1716282560081	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282561084	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282561084	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0316	1716282561084	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282562087	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282562087	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0316	1716282562087	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282563090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282563090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0316	1716282563090	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282564093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282564093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0284	1716282564093	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282565096	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282565096	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0284	1716282565096	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282566098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282566098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0284	1716282566098	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282567101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282567101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282567101	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282568104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282568104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282568104	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282569107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282569107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0319000000000003	1716282569107	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282570109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282570109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282570109	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282571111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282571111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282571111	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282572116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282572116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0318	1716282572116	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282573118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282573118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0342000000000002	1716282573118	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282574120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282574120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0342000000000002	1716282574120	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282575122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282575122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0342000000000002	1716282575122	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282576125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282576125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282576125	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282577127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282577127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282577127	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282578129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282578129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282578129	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282579134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282579134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0326	1716282579134	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282580136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282580136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0326	1716282580136	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282581138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282581138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0326	1716282581138	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282582140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282582140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282582140	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282583142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282583142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282583142	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282584145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282584145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282584145	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282585147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282585147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282585147	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282586149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282586149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282586149	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282587151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282587151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282587151	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282588153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282588153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282588153	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282589156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282589156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282589156	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282590158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282590158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282590158	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282591160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282591160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0339	1716282591160	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282592162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282592162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0339	1716282592162	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282593164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282593164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0339	1716282593164	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282594167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282594167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282594167	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282595169	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282595169	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282595169	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282596172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282596172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0335	1716282596172	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282597176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282597176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282597176	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282598178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282598178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282598178	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282599180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282599180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345999999999997	1716282599180	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282600183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282600183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.024	1716282600183	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282601185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282601185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.024	1716282601185	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282602189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.7	1716282602189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.024	1716282602189	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282603191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282603191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0314	1716282603191	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282604193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282604193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0314	1716282604193	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282605195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282605195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0314	1716282605195	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282606197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282606197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0324	1716282606197	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282607198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282607198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0324	1716282607198	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282608200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282608200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0324	1716282608200	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282609202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282609202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0334	1716282609202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282610205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282610205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0334	1716282610205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282611206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282611206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0334	1716282611206	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282612208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282612208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0311	1716282612208	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282613211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282613211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0311	1716282613211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282614213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282614213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0311	1716282614213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282615215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282615215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282615215	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282616218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282616218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282616218	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282617220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282596196	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282597203	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282598204	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282599205	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282600202	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282601213	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282602217	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282603219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282604211	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282605219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282606225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282607223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282608221	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282609219	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282610224	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282611233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282612230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282613239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282614232	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282615233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282616238	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282617240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282618240	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282619247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282620247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282617220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282617220	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282618223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282618223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282618223	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282619225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282619225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282619225	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282620227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282620227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282620227	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282621228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282621228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.029	1716282621228	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282621257	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282622230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282622230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.029	1716282622230	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282622256	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282623233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282623233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.029	1716282623233	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282623261	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282624235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282624235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.033	1716282624235	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282624262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282625237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282625237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.033	1716282625237	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282625255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282626239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282626239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.033	1716282626239	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282626266	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282627242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282627242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282627242	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282627269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282628245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282628245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282628245	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282628272	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282629247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282629247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282629247	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282629274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282630251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282630251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282630251	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282630268	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282631253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282631253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282631253	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282631278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282632255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282632255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282632255	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282632281	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282633258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282633258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282633258	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282633285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282634262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282634262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282634262	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282635265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282635265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0343	1716282635265	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282636267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282636267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282636267	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282637269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282637269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282637269	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282638271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282638271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282638271	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282639274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282639274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282639274	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	100	1716282640275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282640275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282640275	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282641278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282641278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0329	1716282641278	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282642280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282642280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282642280	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282643282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282643282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282643282	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282644285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.6	1716282644285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0337	1716282644285	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282645287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282645287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282645287	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282646288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282646288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282646288	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282647290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.299999999999999	1716282647290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0338	1716282647290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282648293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282648293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0353	1716282648293	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282649295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282649295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0353	1716282649295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282650297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282650297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0353	1716282650297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282651299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282651299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282651299	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282652302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282652302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282652302	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282653304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282653304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282653304	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282654306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282654306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0367	1716282654306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282655308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282655308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282634290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282635290	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282636294	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282637292	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282638297	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282639301	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282640295	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282641308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282642306	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282643310	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282644312	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282645305	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282646314	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282647320	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282648321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282649313	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282650322	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282651326	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282652327	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282653330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282654323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282655334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282656341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282657344	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282658344	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282659337	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282660348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282661342	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282662350	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282663355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282664356	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282665359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282666360	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282667361	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282668363	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282669359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282670370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282671374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282672374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282673375	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282674371	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282675377	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282676383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282677389	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282678391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282679383	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282680390	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282681396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282682401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282683402	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282684405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282685400	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282686413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282687410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282688416	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282689421	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282690413	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282691422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282692419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282693431	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282694432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282695424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282696437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282697440	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282698439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0367	1716282655308	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282656311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282656311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0367	1716282656311	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282657314	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282657314	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0357	1716282657314	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282658316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282658316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0357	1716282658316	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282659318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282659318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0357	1716282659318	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282660321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282660321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0361	1716282660321	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282661323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282661323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0361	1716282661323	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282662325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282662325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0361	1716282662325	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282663328	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282663328	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282663328	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282664330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282664330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282664330	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282665332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282665332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282665332	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282666334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282666334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282666334	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282667336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282667336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282667336	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282668339	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282668339	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282668339	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282669341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282669341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282669341	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282670343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282670343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282670343	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282671345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282671345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0376	1716282671345	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282672348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282672348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0392	1716282672348	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282673351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282673351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0392	1716282673351	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282674353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282674353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0392	1716282674353	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282675355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282675355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282675355	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282676357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282676357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282676357	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282677359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282677359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0347	1716282677359	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282678362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282678362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282678362	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282679364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282679364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282679364	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282680366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282680366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0362	1716282680366	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282681370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282681370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282681370	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282682372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282682372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282682372	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282683374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282683374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282683374	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282684379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282684379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282684379	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282685381	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282685381	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282685381	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282686384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282686384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282686384	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282687386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282687386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282687386	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282688389	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282688389	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282688389	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282689391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282689391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0344	1716282689391	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282690394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282690394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282690394	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282691396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282691396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282691396	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282692398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282692398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0345	1716282692398	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282693401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282693401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0351	1716282693401	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282694403	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282694403	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0351	1716282694403	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282695405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282695405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0351	1716282695405	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282696407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282696407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0370999999999997	1716282696407	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282697410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282697410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0370999999999997	1716282697410	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282698412	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.8	1716282698412	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0370999999999997	1716282698412	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282699414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282699414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0348	1716282699414	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282700417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282700417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0348	1716282700417	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282701419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282701419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0348	1716282701419	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282702422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282702422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282702422	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282703424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282703424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282703424	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282704426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282704426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0365	1716282704426	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282705428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282705428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282705428	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282706430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282706430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282706430	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282707432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282707432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0373	1716282707432	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282708435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282708435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0368	1716282708435	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282709437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282709437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0368	1716282709437	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282710439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282710439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0368	1716282710439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282711443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282711443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282711443	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282712445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282712445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282712445	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282713446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282713446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282713446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282714449	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282714449	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282714449	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282715451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282715451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282715451	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282716454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282716454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282716454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282717456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282717456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0372	1716282717456	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282718458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282718458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0372	1716282718458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282719461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282719461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282699446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282700439	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282701446	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282702450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282703450	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282704454	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282705447	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282706459	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282707458	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282708461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282709464	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282710459	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282711471	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282712475	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282713477	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282714467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282715469	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282716479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282717483	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282718489	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282719479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282720490	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282721494	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282722492	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282723498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282724497	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282725499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282726503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282727503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282728508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282729501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282730507	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282731516	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282732514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282733522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282734514	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282735523	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282736525	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282737526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282738532	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282739533	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282740534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282741536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282742542	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282743541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282744538	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282745550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282746550	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282747553	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282748552	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282749551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282750559	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282751564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282752569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282753566	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282754564	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282755565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282756574	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282757581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282758578	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282759583	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282760575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282761591	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282762592	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282763596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0372	1716282719461	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282720463	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282720463	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0359000000000003	1716282720463	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282721467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282721467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0359000000000003	1716282721467	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282722468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282722468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0359000000000003	1716282722468	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282723470	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282723470	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282723470	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282724472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282724472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282724472	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282725474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282725474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282725474	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282726476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282726476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282726476	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282727479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282727479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282727479	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282728481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282728481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282728481	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282729484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282729484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282729484	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282730485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282730485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282730485	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282731488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282731488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0377	1716282731488	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282732491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282732491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0374	1716282732491	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282733493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282733493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0374	1716282733493	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282734495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282734495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0374	1716282734495	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282735498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282735498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282735498	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282736499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282736499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282736499	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282737501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282737501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0387	1716282737501	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282738503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282738503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282738503	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282739505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282739505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282739505	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282740508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282740508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0399000000000003	1716282740508	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282741510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282741510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0393	1716282741510	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282742513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282742513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0393	1716282742513	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282743515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282743515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0393	1716282743515	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282744519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282744519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.039	1716282744519	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282745522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282745522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.039	1716282745522	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282746524	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282746524	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.039	1716282746524	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282747526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282747526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0407	1716282747526	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282748529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282748529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0407	1716282748529	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282749531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282749531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0407	1716282749531	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282750534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282750534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282750534	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282751536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282751536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282751536	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282752539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282752539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.038	1716282752539	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282753541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282753541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0384	1716282753541	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282754544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282754544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0384	1716282754544	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282755546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282755546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0384	1716282755546	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282756548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282756548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0404	1716282756548	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282757551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282757551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0404	1716282757551	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282758553	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282758553	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0404	1716282758553	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	101	1716282759555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282759555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282759555	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282760558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282760558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282760558	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282761560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282761560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0395	1716282761560	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282762563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282762563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282762563	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282763565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282763565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282763565	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282764569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282764569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282764569	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	105	1716282765571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282765571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282765571	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282766573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282766573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282766573	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282767575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282767575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0410999999999997	1716282767575	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282768577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282768577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0417	1716282768577	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282769580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282769580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0417	1716282769580	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282770581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282770581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0417	1716282770581	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282771584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282771584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0405	1716282771584	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282772586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282772586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0405	1716282772586	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282773589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282773589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0405	1716282773589	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282774590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282774590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282774590	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282775593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282775593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282775593	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282776594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282776594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0385	1716282776594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282777596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282777596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0389	1716282777596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282778598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282778598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0389	1716282778598	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282779601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282779601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0389	1716282779601	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282780604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282780604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0402	1716282780604	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282781606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282781606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0402	1716282781606	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	103	1716282782608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282782608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0402	1716282782608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	104	1716282783610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	8.4	1716282783610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282764596	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282765594	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282766599	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282767602	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282768608	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282769607	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282770609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282771611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282772614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282773618	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282774609	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282775611	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282776614	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282777615	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282778618	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282779623	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282780634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282781631	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282782634	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282783636	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Swap Memory GB	0.0003	1716282784639	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0402	1716282783610	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - CPU Utilization	102	1716282784613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Utilization	6.7	1716282784613	3a51dbc69b564b259fb6b4b726f619f5	0	f
TOP - Memory Usage GB	2.0402	1716282784613	3a51dbc69b564b259fb6b4b726f619f5	0	f
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
letter	0	dc13c8a040d9484989039a358177abe1
workload	0	dc13c8a040d9484989039a358177abe1
listeners	smi+top+dcgmi	dc13c8a040d9484989039a358177abe1
params	'"-"'	dc13c8a040d9484989039a358177abe1
file	cifar10.py	dc13c8a040d9484989039a358177abe1
workload_listener	''	dc13c8a040d9484989039a358177abe1
letter	0	3a51dbc69b564b259fb6b4b726f619f5
workload	0	3a51dbc69b564b259fb6b4b726f619f5
listeners	smi+top+dcgmi	3a51dbc69b564b259fb6b4b726f619f5
params	'"-"'	3a51dbc69b564b259fb6b4b726f619f5
file	cifar10.py	3a51dbc69b564b259fb6b4b726f619f5
workload_listener	''	3a51dbc69b564b259fb6b4b726f619f5
model	cifar10.py	3a51dbc69b564b259fb6b4b726f619f5
manual	False	3a51dbc69b564b259fb6b4b726f619f5
max_epoch	5	3a51dbc69b564b259fb6b4b726f619f5
max_time	172800	3a51dbc69b564b259fb6b4b726f619f5
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
dc13c8a040d9484989039a358177abe1	adorable-panda-185	UNKNOWN			daga	FAILED	1716280336668	1716280401536		active	s3://mlflow-storage/0/dc13c8a040d9484989039a358177abe1/artifacts	0	\N
3a51dbc69b564b259fb6b4b726f619f5	(0 0) delightful-hen-960	UNKNOWN			daga	FINISHED	1716280572555	1716282785911		active	s3://mlflow-storage/0/3a51dbc69b564b259fb6b4b726f619f5/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	dc13c8a040d9484989039a358177abe1
mlflow.source.name	file:///home/daga/radt#examples/pytorch	dc13c8a040d9484989039a358177abe1
mlflow.source.type	PROJECT	dc13c8a040d9484989039a358177abe1
mlflow.project.entryPoint	main	dc13c8a040d9484989039a358177abe1
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	dc13c8a040d9484989039a358177abe1
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	dc13c8a040d9484989039a358177abe1
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	dc13c8a040d9484989039a358177abe1
mlflow.runName	adorable-panda-185	dc13c8a040d9484989039a358177abe1
mlflow.project.env	conda	dc13c8a040d9484989039a358177abe1
mlflow.project.backend	local	dc13c8a040d9484989039a358177abe1
mlflow.user	daga	3a51dbc69b564b259fb6b4b726f619f5
mlflow.source.name	file:///home/daga/radt#examples/pytorch	3a51dbc69b564b259fb6b4b726f619f5
mlflow.source.type	PROJECT	3a51dbc69b564b259fb6b4b726f619f5
mlflow.project.entryPoint	main	3a51dbc69b564b259fb6b4b726f619f5
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	3a51dbc69b564b259fb6b4b726f619f5
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3a51dbc69b564b259fb6b4b726f619f5
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3a51dbc69b564b259fb6b4b726f619f5
mlflow.project.env	conda	3a51dbc69b564b259fb6b4b726f619f5
mlflow.project.backend	local	3a51dbc69b564b259fb6b4b726f619f5
mlflow.runName	(0 0) delightful-hen-960	3a51dbc69b564b259fb6b4b726f619f5
\.


--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mlflow_user
--

SELECT pg_catalog.setval('public.experiments_experiment_id_seq', 1, false);


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
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE CASCADE;


--
-- Name: model_versions model_versions_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: params params_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: registered_model_tags registered_model_tags_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


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

