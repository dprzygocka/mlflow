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
0	Default	s3://mlflow-storage/0	active	1716158030658	1716158030658
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
SMI - Power Draw	14.24	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
SMI - Timestamp	1716158276.458	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
SMI - GPU Util	0	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
SMI - Mem Util	0	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
SMI - Mem Used	0	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
SMI - Performance State	0	1716158276471	0	f	ec5ffb16448a4ad7971be56022a224fc
TOP - CPU Utilization	101	1716158730403	0	f	ec5ffb16448a4ad7971be56022a224fc
TOP - Memory Usage GB	1.9467	1716158730403	0	f	ec5ffb16448a4ad7971be56022a224fc
TOP - Memory Utilization	6	1716158730403	0	f	ec5ffb16448a4ad7971be56022a224fc
TOP - Swap Memory GB	0.0003	1716158730424	0	f	ec5ffb16448a4ad7971be56022a224fc
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.24	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
SMI - Timestamp	1716158276.458	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
SMI - GPU Util	0	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
SMI - Mem Util	0	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
SMI - Mem Used	0	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
SMI - Performance State	0	1716158276471	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	0	1716158276536	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	0	1716158276536	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.2429000000000001	1716158276536	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158276550	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	153.39999999999998	1716158277538	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	9	1716158277538	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.2429000000000001	1716158277538	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158277553	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158278540	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158278540	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.2429000000000001	1716158278540	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158278554	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158279542	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158279542	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4726	1716158279542	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158279562	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158280545	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158280545	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4726	1716158280545	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158280559	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158281546	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158281546	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4726	1716158281546	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158281559	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158282548	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158282548	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158282548	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158282569	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158283550	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158283550	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158283550	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158283570	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158284552	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158284552	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158284552	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158284565	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	105	1716158285554	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158285554	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158285554	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158285575	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158286556	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158286556	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158286556	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158286569	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158287558	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158287558	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4727000000000001	1716158287558	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158287579	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158288560	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158288560	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158288560	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158288581	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	105	1716158289562	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158289562	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158289562	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158289582	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158290564	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158290564	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158290564	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158290576	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158291587	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158292589	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158293591	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158294586	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158295587	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158296590	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158297591	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158298600	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158299594	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158300596	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158301608	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158302608	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158303610	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158304612	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0	1716158305606	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158306609	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158307618	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158308612	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158309625	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158310624	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158311619	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158312628	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158313632	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158314634	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158315635	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158316628	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158317636	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158318640	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158319640	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158621194	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158621194	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158621194	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158622196	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158622196	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158622196	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158623198	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158623198	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158623198	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158624200	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158624200	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158624200	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158625202	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158625202	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158625202	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158626205	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158626205	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158626205	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158627207	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158627207	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158627207	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158628209	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158628209	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158628209	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158629211	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158629211	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158629211	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158630213	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158630213	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158630213	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158631214	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158631214	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158631214	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158632216	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158632216	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158291566	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158291566	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.473	1716158291566	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158292568	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158292568	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.473	1716158292568	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158293569	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158293569	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.473	1716158293569	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158294571	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158294571	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158294571	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158295573	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158295573	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158295573	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158296575	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158296575	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4730999999999999	1716158296575	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158297577	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158297577	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4735999999999998	1716158297577	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158298579	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158298579	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4735999999999998	1716158298579	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	105	1716158299581	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158299581	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4735999999999998	1716158299581	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158300583	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158300583	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4743	1716158300583	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158301585	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.3999999999999995	1716158301585	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4743	1716158301585	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158302587	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.6	1716158302587	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4743	1716158302587	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158303589	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158303589	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4744000000000002	1716158303589	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158304591	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158304591	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4744000000000002	1716158304591	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158305593	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158305593	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.4744000000000002	1716158305593	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158306595	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158306595	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.777	1716158306595	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158307597	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158307597	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.777	1716158307597	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158308599	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158308599	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.777	1716158308599	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158309601	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158309601	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9847000000000001	1716158309601	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158310602	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158310602	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9847000000000001	1716158310602	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158311604	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158311604	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9847000000000001	1716158311604	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158312606	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158312606	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.992	1716158312606	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158313608	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158313608	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.992	1716158313608	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158314610	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158314610	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.992	1716158314610	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158315612	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158315612	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158315612	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158316614	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158316614	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158316614	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158317616	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158317616	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158317616	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158318618	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158318618	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9967000000000001	1716158318618	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158319619	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158319619	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9967000000000001	1716158319619	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158320621	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158320621	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9967000000000001	1716158320621	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158320642	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158321623	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158321623	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9972999999999999	1716158321623	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158321649	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158322625	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8999999999999995	1716158322625	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9972999999999999	1716158322625	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158322650	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158323627	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158323627	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9972999999999999	1716158323627	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158323648	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158324629	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158324629	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158324629	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158324649	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158325630	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158325630	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158325630	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158325651	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158326632	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158326632	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9968	1716158326632	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158326648	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158327636	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158327636	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	2.0024	1716158327636	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158327659	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158328637	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158328637	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	2.0024	1716158328637	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158328658	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158329639	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158329639	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	2.0024	1716158329639	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158329654	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158330641	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158330641	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.907	1716158330641	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158331643	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158331643	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.907	1716158331643	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158332646	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158332646	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.907	1716158332646	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158333648	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158333648	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158333648	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158334650	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158334650	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158334650	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158335653	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158335653	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158335653	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158336654	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158336654	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9097	1716158336654	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158337656	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158337656	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9097	1716158337656	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158338658	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158338658	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9097	1716158338658	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158339660	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158339660	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.911	1716158339660	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158340662	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158340662	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.911	1716158340662	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158341663	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158341663	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.911	1716158341663	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158342665	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158342665	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9088	1716158342665	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158343667	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158343667	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9088	1716158343667	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158344669	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158344669	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9088	1716158344669	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158345671	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158345671	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158345671	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158346672	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158346672	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158346672	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158347674	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158347674	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.91	1716158347674	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158348676	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158348676	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9105999999999999	1716158348676	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158349678	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158349678	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9105999999999999	1716158349678	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	100	1716158350680	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158350680	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9105999999999999	1716158350680	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158351682	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158351682	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158330662	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158331657	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158332667	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158333669	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158334671	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158335674	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158336675	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158337678	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158338679	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158339680	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158340677	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158341678	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158342686	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158343689	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158344691	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158345693	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158346686	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158347697	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158348697	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158349700	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158350705	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158351703	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158352705	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158353706	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158354700	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158355702	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158356711	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158357714	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158358716	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158359710	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158360712	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158361721	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158362723	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158363726	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158364728	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158365723	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158366730	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158367726	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158368734	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158369742	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158370733	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158371747	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158372746	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158373744	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158374748	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158375742	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158376753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158377753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158378747	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158379759	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158621208	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158622217	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158623219	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158624221	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158625223	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158626221	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158627227	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158628222	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158629232	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158630240	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158631231	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158632241	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158633239	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158634242	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158635243	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9144	1716158351682	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158352683	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158352683	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9144	1716158352683	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158353685	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158353685	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9144	1716158353685	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158354687	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158354687	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9183	1716158354687	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158355689	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158355689	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9183	1716158355689	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158356691	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158356691	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9183	1716158356691	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158357692	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158357692	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9192	1716158357692	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158358694	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158358694	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9192	1716158358694	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158359696	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158359696	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9192	1716158359696	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158360698	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158360698	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9215	1716158360698	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158361700	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158361700	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9215	1716158361700	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158362702	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158362702	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9215	1716158362702	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158363704	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158363704	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158363704	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158364706	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158364706	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158364706	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158365708	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158365708	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158365708	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158366710	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158366710	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158366710	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158367711	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158367711	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158367711	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158368713	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158368713	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158368713	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158369714	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158369714	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9176	1716158369714	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158370718	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158370718	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9176	1716158370718	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158371719	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158371719	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9176	1716158371719	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158372721	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158372721	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9214	1716158372721	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158373723	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158373723	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9214	1716158373723	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158374725	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158374725	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9214	1716158374725	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158375727	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158375727	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158375727	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158376729	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158376729	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158376729	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158377732	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158377732	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158377732	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158378734	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158378734	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9244	1716158378734	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158379736	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158379736	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9244	1716158379736	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158380738	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158380738	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9244	1716158380738	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158380753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158381739	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158381739	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9225	1716158381739	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158381761	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158382742	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158382742	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9225	1716158382742	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158382763	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158383744	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158383744	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9225	1716158383744	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158383764	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158384746	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158384746	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9227	1716158384746	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158384768	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158385748	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158385748	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9227	1716158385748	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158385763	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158386750	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158386750	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9227	1716158386750	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158386762	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158387751	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158387751	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158387751	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158387775	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158388753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158388753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158388753	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158388767	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158389755	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158389755	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158389755	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158389778	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158390757	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158390757	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.917	1716158390757	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158390778	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158391776	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158392781	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158393785	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158394778	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158395781	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158396844	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158397784	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158398794	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158399797	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158400789	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158401800	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158402803	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158403805	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158404807	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158405808	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158406810	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158407807	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158408808	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158409815	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158410818	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158411821	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158412826	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158413822	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158414824	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158415820	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158416827	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158417834	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158418832	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158419832	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158420829	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158421843	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158422843	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158423846	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158424844	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158425839	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158426852	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158427853	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158428853	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158429857	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158430858	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158431851	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158432860	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158433863	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158434866	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158435865	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158436860	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158437869	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158438875	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158439875	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158632216	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158633218	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158633218	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158633218	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158634220	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158634220	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158634220	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158635222	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158635222	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158635222	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158636224	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158636224	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158636224	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158637225	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158637225	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158391759	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158391759	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.917	1716158391759	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158392761	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158392761	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.917	1716158392761	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158393763	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158393763	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9208	1716158393763	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158394765	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158394765	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9208	1716158394765	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158395766	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158395766	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9208	1716158395766	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158396768	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158396768	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158396768	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158397770	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158397770	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158397770	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	108	1716158398772	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158398772	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158398772	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158399774	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158399774	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158399774	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158400776	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158400776	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158400776	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158401779	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158401779	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9218	1716158401779	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158402780	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158402780	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158402780	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158403782	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158403782	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158403782	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158404784	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158404784	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9222000000000001	1716158404784	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158405786	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158405786	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158405786	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158406788	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158406788	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158406788	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158407790	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158407790	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9203	1716158407790	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158408792	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158408792	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9185999999999999	1716158408792	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158409794	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158409794	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9185999999999999	1716158409794	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158410796	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158410796	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9185999999999999	1716158410796	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158411797	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158411797	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158411797	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158412799	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158412799	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158412799	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158413801	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158413801	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9216	1716158413801	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158414803	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158414803	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158414803	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158415804	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158415804	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158415804	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158416806	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158416806	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9236	1716158416806	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158417809	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158417809	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9252	1716158417809	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158418810	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158418810	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9252	1716158418810	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158419812	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158419812	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9252	1716158419812	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158420814	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158420814	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158420814	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158421817	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158421817	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158421817	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158422819	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158422819	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158422819	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158423822	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6.1000000000000005	1716158423822	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9253	1716158423822	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158424823	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158424823	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9253	1716158424823	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158425825	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158425825	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9253	1716158425825	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158426828	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158426828	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9272	1716158426828	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158427830	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158427830	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9272	1716158427830	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158428832	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158428832	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9272	1716158428832	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158429834	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158429834	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9258	1716158429834	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158430836	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158430836	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9258	1716158430836	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158431838	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158431838	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9258	1716158431838	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158432839	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158432839	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9243	1716158432839	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158433841	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158433841	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9243	1716158433841	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158434843	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.5	1716158434843	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9243	1716158434843	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158435844	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.7	1716158435844	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9238	1716158435844	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158436846	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158436846	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9238	1716158436846	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158437848	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158437848	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9238	1716158437848	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158438850	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158438850	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9221	1716158438850	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158439852	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158439852	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9221	1716158439852	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158440854	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158440854	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9221	1716158440854	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158440878	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158441856	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158441856	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9241	1716158441856	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158441876	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158442858	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158442858	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9241	1716158442858	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158442879	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158443860	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158443860	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9241	1716158443860	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158443880	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158444861	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158444861	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158444861	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158444888	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158445863	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158445863	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158445863	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158445878	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158446864	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158446864	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158446864	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158446886	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158447867	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158447867	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9265999999999999	1716158447867	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158447891	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158448869	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158448869	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9265999999999999	1716158448869	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158448894	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158449871	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158449871	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9265999999999999	1716158449871	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158449893	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158450872	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158450872	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158450872	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158450887	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158451874	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158451874	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158451874	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158452876	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158452876	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9247	1716158452876	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158453878	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158453878	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9259000000000002	1716158453878	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158454880	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158454880	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9259000000000002	1716158454880	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158455882	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158455882	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9259000000000002	1716158455882	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158456884	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158456884	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9261	1716158456884	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158457886	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158457886	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9261	1716158457886	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158458887	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158458887	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9261	1716158458887	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158459890	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158459890	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158459890	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158460892	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158460892	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158460892	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158461894	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158461894	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158461894	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158462896	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158462896	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158462896	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158463897	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158463897	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158463897	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158464899	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158464899	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158464899	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158465902	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158465902	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9270999999999998	1716158465902	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158466905	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158466905	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9270999999999998	1716158466905	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158467907	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158467907	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9270999999999998	1716158467907	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158468909	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158468909	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158468909	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158469911	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158469911	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158469911	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158470913	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158470913	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158470913	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158471914	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158471914	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158471914	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158472916	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158472916	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158451899	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158452902	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158453904	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158454901	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158455904	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158456905	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158457908	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158458909	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158459913	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158460909	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158461915	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158462917	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158463918	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158464922	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158465918	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158466928	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158467928	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158468935	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158469933	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158470927	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158471935	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158472940	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158473940	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158474944	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158475936	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158476947	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158477946	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158478949	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158479950	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158480945	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158481954	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158482955	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158483959	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158484952	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158485961	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158486965	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158487969	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158488967	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158489969	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158490963	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158491972	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158492974	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158493976	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158494973	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158495972	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158496983	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158497985	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158498987	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158499989	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158636246	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158637246	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158638250	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158639254	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158640255	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158641247	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158642257	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158643259	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158644262	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158645262	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158646264	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158647259	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158648267	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158649269	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158650265	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158651273	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158472916	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158473918	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158473918	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9263	1716158473918	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158474920	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158474920	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9275	1716158474920	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158475921	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158475921	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9275	1716158475921	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158476923	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158476923	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9275	1716158476923	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158477925	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158477925	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158477925	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158478927	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158478927	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158478927	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158479929	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158479929	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9281	1716158479929	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158480931	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158480931	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9293	1716158480931	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158481933	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158481933	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9293	1716158481933	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158482934	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158482934	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9293	1716158482934	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158483936	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158483936	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158483936	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158484938	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158484938	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158484938	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158485940	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158485940	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9285999999999999	1716158485940	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158486942	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158486942	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9290999999999998	1716158486942	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158487944	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158487944	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9290999999999998	1716158487944	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158488945	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158488945	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9290999999999998	1716158488945	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158489947	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158489947	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9307999999999998	1716158489947	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158490949	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158490949	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9307999999999998	1716158490949	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158491951	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158491951	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9307999999999998	1716158491951	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158492953	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158492953	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9269	1716158492953	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158493955	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158493955	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9269	1716158493955	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158494957	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158494957	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9269	1716158494957	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158495959	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158495959	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158495959	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158496960	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158496960	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158496960	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158497964	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158497964	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158497964	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158498965	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158498965	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158498965	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158499967	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158499967	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158499967	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158500969	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158500969	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158500969	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158500984	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158501971	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158501971	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9289	1716158501971	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158501994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158502973	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158502973	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9289	1716158502973	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158502994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158503975	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158503975	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9289	1716158503975	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158503994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158504977	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158504977	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158504977	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158504998	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158505979	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158505979	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158505979	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158505996	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158506980	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158506980	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158506980	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158506995	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158507982	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158507982	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9301	1716158507982	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158507998	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158508984	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158508984	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9301	1716158508984	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158509002	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158509986	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158509986	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9301	1716158509986	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158510001	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158510988	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158510988	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158510988	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158511004	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158511990	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158511990	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158511990	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158512991	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158512991	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9313	1716158512991	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158513993	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158513993	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9314	1716158513993	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158514994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158514994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9314	1716158514994	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	100	1716158515996	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158515996	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9314	1716158515996	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158516998	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158516998	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158516998	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158518000	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158518000	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158518000	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158519002	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158519002	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158519002	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158520004	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158520004	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158520004	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158521005	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158521005	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158521005	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158522007	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158522007	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9302000000000001	1716158522007	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158523009	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158523009	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158523009	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158524011	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158524011	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158524011	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158525013	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158525013	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158525013	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158526015	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158526015	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158526015	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158527017	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158527017	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158527017	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158528019	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158528019	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158528019	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158529020	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158529020	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158529020	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158530022	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	8.000000000000002	1716158530022	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158530022	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158531024	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158531024	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9305999999999999	1716158531024	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158532026	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158532026	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9295	1716158532026	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158533028	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158533028	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9295	1716158533028	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158512003	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158513004	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158514007	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158515007	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158516009	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158517011	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158518013	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158519022	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158520027	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158521021	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158522031	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158523022	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158524033	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158525037	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158526030	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158527034	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158528035	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158529035	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158530044	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158531038	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158532047	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158533049	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158534043	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158535052	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158536047	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158537055	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158538051	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158539062	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158540064	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158541064	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158542066	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158543060	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158544071	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158545064	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158546074	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158547076	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158548080	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158549073	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158550126	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158551077	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158552085	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158553088	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158554090	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158555093	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158556086	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158557096	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158558092	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158559101	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158560104	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9427	1716158637225	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158638227	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158638227	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9427	1716158638227	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158639229	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158639229	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9427	1716158639229	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158640231	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158640231	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158640231	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158641233	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158641233	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158641233	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158642235	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158642235	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158642235	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158534030	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158534030	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9295	1716158534030	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158535032	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158535032	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9304000000000001	1716158535032	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158536034	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158536034	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9304000000000001	1716158536034	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158537036	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158537036	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9304000000000001	1716158537036	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158538037	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158538037	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9256	1716158538037	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158539039	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158539039	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9256	1716158539039	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158540041	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158540041	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9256	1716158540041	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158541043	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158541043	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158541043	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158542045	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158542045	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158542045	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158543047	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158543047	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9294	1716158543047	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158544048	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158544048	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9330999999999998	1716158544048	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158545050	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158545050	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9330999999999998	1716158545050	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158546053	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158546053	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9330999999999998	1716158546053	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158547056	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158547056	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.932	1716158547056	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158548057	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158548057	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.932	1716158548057	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158549059	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158549059	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.932	1716158549059	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158550061	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158550061	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9341	1716158550061	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158551063	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158551063	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9341	1716158551063	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	107	1716158552065	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6	1716158552065	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9341	1716158552065	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158553067	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158553067	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9332	1716158553067	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158554069	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158554069	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9332	1716158554069	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158555070	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158555070	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9332	1716158555070	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158556072	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158556072	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9335	1716158556072	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158557074	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158557074	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9335	1716158557074	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158558077	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158558077	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9335	1716158558077	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158559079	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158559079	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158559079	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158560081	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158560081	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158560081	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158561083	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158561083	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9323	1716158561083	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158561107	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158562084	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158562084	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9319000000000002	1716158562084	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158562109	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158563086	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158563086	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9319000000000002	1716158563086	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158563103	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158564088	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158564088	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9319000000000002	1716158564088	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158564110	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158565090	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158565090	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9339000000000002	1716158565090	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158565116	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158566093	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158566093	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9339000000000002	1716158566093	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158566108	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158567095	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158567095	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9339000000000002	1716158567095	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158567116	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158568098	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158568098	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9347999999999999	1716158568098	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158568111	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158569100	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158569100	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9347999999999999	1716158569100	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158569126	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158570101	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158570101	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9347999999999999	1716158570101	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158570122	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158571103	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158571103	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.934	1716158571103	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158571117	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158572105	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158572105	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.934	1716158572105	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158572127	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158573131	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158574136	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158575132	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158576135	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158577129	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158578137	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158579131	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158580142	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158581137	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158582152	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158583151	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158584150	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158585153	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158586145	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158587156	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158588156	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158589157	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158590159	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158591164	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158592165	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158593169	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158594160	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158595169	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158596165	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158597171	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158598167	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158599178	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158600177	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158601172	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158602181	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158603182	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158604185	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158605189	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158606188	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158607190	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158608191	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158609186	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158610195	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158611190	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158612201	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158613205	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158614202	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158615205	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158616199	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158617201	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158618210	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158619212	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158620215	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158643236	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	8.1	1716158643236	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158643236	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158644238	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158644238	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158644238	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158645240	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158645240	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158645240	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158646242	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158646242	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9344000000000001	1716158646242	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158647244	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158647244	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9344000000000001	1716158647244	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158648246	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158573107	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158573107	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.934	1716158573107	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158574109	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158574109	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9354	1716158574109	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158575111	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158575111	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9354	1716158575111	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158576113	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.6000000000000005	1716158576113	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9354	1716158576113	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158577115	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.800000000000001	1716158577115	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158577115	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158578116	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158578116	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158578116	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158579118	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158579118	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158579118	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158580120	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158580120	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9382000000000001	1716158580120	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158581122	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158581122	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9382000000000001	1716158581122	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158582124	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158582124	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9382000000000001	1716158582124	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158583126	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158583126	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158583126	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158584128	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158584128	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158584128	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158585129	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158585129	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9361	1716158585129	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158586131	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158586131	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9362000000000001	1716158586131	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158587133	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158587133	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9362000000000001	1716158587133	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158588134	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158588134	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9362000000000001	1716158588134	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158589136	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158589136	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9372	1716158589136	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158590138	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158590138	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9372	1716158590138	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	100	1716158591140	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	2.8	1716158591140	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9372	1716158591140	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158592142	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158592142	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9367999999999999	1716158592142	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158593143	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158593143	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9367999999999999	1716158593143	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158594144	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158594144	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9367999999999999	1716158594144	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158595146	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158595146	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9384000000000001	1716158595146	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158596148	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158596148	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9384000000000001	1716158596148	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158597150	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158597150	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9384000000000001	1716158597150	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158598152	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158598152	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.939	1716158598152	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158599154	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158599154	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.939	1716158599154	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158600156	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158600156	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.939	1716158600156	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158601157	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158601157	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9393	1716158601157	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158602159	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158602159	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9393	1716158602159	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158603161	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158603161	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9393	1716158603161	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	99	1716158604163	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158604163	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407	1716158604163	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158605166	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158605166	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407	1716158605166	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158606167	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158606167	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407	1716158606167	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158607169	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158607169	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9423	1716158607169	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158608171	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158608171	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9423	1716158608171	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158609173	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158609173	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9423	1716158609173	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158610174	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158610174	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9421	1716158610174	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158611176	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158611176	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9421	1716158611176	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158612178	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158612178	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9421	1716158612178	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158613180	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158613180	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158613180	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158614182	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158614182	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158614182	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158615183	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158615183	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9410999999999998	1716158615183	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158616185	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158616185	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158616185	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158617187	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158617187	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158617187	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158618189	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158618189	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9412	1716158618189	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158619191	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158619191	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158619191	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158620193	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158620193	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9417	1716158620193	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158648246	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9344000000000001	1716158648246	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158649248	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158649248	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407999999999999	1716158649248	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158650250	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158650250	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407999999999999	1716158650250	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158651252	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158651252	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9407999999999999	1716158651252	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158652253	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158652253	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158652253	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158652275	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158653255	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158653255	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158653255	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158653277	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158654257	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158654257	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158654257	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158654282	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158655261	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158655261	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158655261	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158655284	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158656262	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158656262	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158656262	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158656279	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158657264	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158657264	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425999999999999	1716158657264	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158657286	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158658266	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158658266	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158658266	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158658279	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158659268	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158659268	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158659268	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158659289	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158660270	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158660270	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158660270	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158660290	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158661272	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158661272	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9461	1716158661272	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158662274	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158662274	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9461	1716158662274	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158663275	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158663275	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9461	1716158663275	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158664277	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158664277	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447999999999999	1716158664277	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158665279	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158665279	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447999999999999	1716158665279	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158666281	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158666281	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447999999999999	1716158666281	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158667283	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158667283	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9390999999999998	1716158667283	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158668286	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158668286	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9390999999999998	1716158668286	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158669288	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158669288	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9390999999999998	1716158669288	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158670289	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158670289	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158670289	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158671291	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158671291	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158671291	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158672293	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158672293	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9409	1716158672293	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158673294	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158673294	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.941	1716158673294	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158674296	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158674296	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.941	1716158674296	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158675298	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158675298	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.941	1716158675298	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158676300	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158676300	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9429	1716158676300	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158677302	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158677302	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9429	1716158677302	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158678304	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158678304	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9429	1716158678304	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158679306	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158679306	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158679306	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158680308	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158680308	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158680308	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158661287	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158662295	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158663298	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158664301	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158665302	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158666304	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158667306	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158668308	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158669310	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158670312	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158671306	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158672316	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158673315	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158674318	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158675319	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158676313	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158677319	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158678328	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158679327	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158680332	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158681310	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158681310	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158681310	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158681331	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158682312	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158682312	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9450999999999998	1716158682312	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158682332	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158683314	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158683314	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9450999999999998	1716158683314	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158683336	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158684316	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158684316	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9450999999999998	1716158684316	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158684337	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158685318	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158685318	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.942	1716158685318	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158685339	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158686319	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158686319	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.942	1716158686319	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158686335	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158687321	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158687321	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.942	1716158687321	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158687342	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158688324	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158688324	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9452	1716158688324	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158688346	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158689326	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158689326	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9452	1716158689326	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158689341	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	100	1716158690327	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158690327	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9452	1716158690327	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158690348	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158691330	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158691330	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425	1716158691330	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158691344	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158692332	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158692332	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425	1716158692332	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158693333	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158693333	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9425	1716158693333	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158694335	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158694335	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9419000000000002	1716158694335	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158695337	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158695337	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9419000000000002	1716158695337	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158696339	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158696339	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9419000000000002	1716158696339	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158697341	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158697341	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158697341	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158698343	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158698343	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158698343	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158699345	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158699345	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9444000000000001	1716158699345	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158700347	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158700347	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158700347	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158701348	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158701348	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158701348	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158702350	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158702350	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158702350	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158703352	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158703352	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158703352	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158704354	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158704354	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158704354	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158705356	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158705356	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9438	1716158705356	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158706358	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158706358	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9433	1716158706358	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158707360	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158707360	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9433	1716158707360	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158708362	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158708362	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9433	1716158708362	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158709363	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158709363	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9377	1716158709363	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158710365	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158710365	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9377	1716158710365	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158711367	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158711367	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9377	1716158711367	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158712369	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158712369	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158712369	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158713371	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158713371	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158692346	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158693356	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158694358	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158695352	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158696352	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158697364	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158698364	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158699365	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158700362	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158701363	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158702366	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158703373	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158704369	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158705370	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158706379	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158707384	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158708382	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158709385	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158710379	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158711388	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158712390	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158713392	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158714387	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158715389	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158716390	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158717400	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158718403	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158719405	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158720407	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158721400	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158722409	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158723416	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158724412	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158725414	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158726418	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158727417	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158728420	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158729425	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Swap Memory GB	0.0003	1716158730424	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158713371	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158714373	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158714373	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9439000000000002	1716158714373	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158715374	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158715374	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158715374	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158716376	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158716376	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158716376	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158717379	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158717379	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158717379	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158718381	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158718381	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158718381	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158719382	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.7	1716158719382	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158719382	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158720384	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	5.9	1716158720384	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9447	1716158720384	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158721386	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8	1716158721386	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9458	1716158721386	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158722388	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6	1716158722388	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9458	1716158722388	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158723390	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8	1716158723390	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9458	1716158723390	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158724392	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6	1716158724392	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158724392	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	103	1716158725394	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8	1716158725394	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158725394	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158726395	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6	1716158726395	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9449	1716158726395	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	104	1716158727397	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8	1716158727397	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9454	1716158727397	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158728399	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	7.8	1716158728399	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9454	1716158728399	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	102	1716158729401	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6	1716158729401	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9454	1716158729401	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - CPU Utilization	101	1716158730403	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Utilization	6	1716158730403	ec5ffb16448a4ad7971be56022a224fc	0	f
TOP - Memory Usage GB	1.9467	1716158730403	ec5ffb16448a4ad7971be56022a224fc	0	f
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
letter	0	971de31bf4a24be5be51618c43af69d9
workload	0	971de31bf4a24be5be51618c43af69d9
listeners	smi+top+dcgmi	971de31bf4a24be5be51618c43af69d9
params	'"-"'	971de31bf4a24be5be51618c43af69d9
file	cifar10.py	971de31bf4a24be5be51618c43af69d9
workload_listener	''	971de31bf4a24be5be51618c43af69d9
letter	0	ec5ffb16448a4ad7971be56022a224fc
workload	0	ec5ffb16448a4ad7971be56022a224fc
listeners	smi+top+dcgmi	ec5ffb16448a4ad7971be56022a224fc
params	'"-"'	ec5ffb16448a4ad7971be56022a224fc
file	cifar10.py	ec5ffb16448a4ad7971be56022a224fc
workload_listener	''	ec5ffb16448a4ad7971be56022a224fc
model	cifar10.py	ec5ffb16448a4ad7971be56022a224fc
manual	False	ec5ffb16448a4ad7971be56022a224fc
max_epoch	5	ec5ffb16448a4ad7971be56022a224fc
max_time	172800	ec5ffb16448a4ad7971be56022a224fc
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
971de31bf4a24be5be51618c43af69d9	rambunctious-goat-48	UNKNOWN			daga	FAILED	1716158017038	1716158179464		active	s3://mlflow-storage/0/971de31bf4a24be5be51618c43af69d9/artifacts	0	\N
ec5ffb16448a4ad7971be56022a224fc	(0 0) big-deer-599	UNKNOWN			daga	FINISHED	1716158270507	1716158731256		active	s3://mlflow-storage/0/ec5ffb16448a4ad7971be56022a224fc/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	971de31bf4a24be5be51618c43af69d9
mlflow.source.name	file:///home/daga/radt#examples/pytorch	971de31bf4a24be5be51618c43af69d9
mlflow.source.type	PROJECT	971de31bf4a24be5be51618c43af69d9
mlflow.project.entryPoint	main	971de31bf4a24be5be51618c43af69d9
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	971de31bf4a24be5be51618c43af69d9
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	971de31bf4a24be5be51618c43af69d9
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	971de31bf4a24be5be51618c43af69d9
mlflow.runName	rambunctious-goat-48	971de31bf4a24be5be51618c43af69d9
mlflow.project.env	conda	971de31bf4a24be5be51618c43af69d9
mlflow.project.backend	local	971de31bf4a24be5be51618c43af69d9
mlflow.user	daga	ec5ffb16448a4ad7971be56022a224fc
mlflow.source.name	file:///home/daga/radt#examples/pytorch	ec5ffb16448a4ad7971be56022a224fc
mlflow.source.type	PROJECT	ec5ffb16448a4ad7971be56022a224fc
mlflow.project.entryPoint	main	ec5ffb16448a4ad7971be56022a224fc
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	ec5ffb16448a4ad7971be56022a224fc
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	ec5ffb16448a4ad7971be56022a224fc
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	ec5ffb16448a4ad7971be56022a224fc
mlflow.project.env	conda	ec5ffb16448a4ad7971be56022a224fc
mlflow.project.backend	local	ec5ffb16448a4ad7971be56022a224fc
mlflow.runName	(0 0) big-deer-599	ec5ffb16448a4ad7971be56022a224fc
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

