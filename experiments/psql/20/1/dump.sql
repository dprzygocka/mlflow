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
0	Default	s3://mlflow-storage/0	active	1716156586316	1716156586316
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
SMI - Power Draw	15.25	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
SMI - Timestamp	1716156710.153	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
SMI - GPU Util	0	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
SMI - Mem Util	0	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
SMI - Mem Used	0	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
SMI - Performance State	0	1716156710167	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
TOP - CPU Utilization	102	1716157190160	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
TOP - Memory Usage GB	2.1431999999999998	1716157190160	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
TOP - Memory Utilization	5.4	1716157190160	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
TOP - Swap Memory GB	0.0757	1716157190181	0	f	16ee1ed4a1474d78bd1ef7aedd027c33
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.25	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
SMI - Timestamp	1716156710.153	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
SMI - GPU Util	0	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
SMI - Mem Util	0	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
SMI - Mem Used	0	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
SMI - Performance State	0	1716156710167	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	0	1716156710231	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	0	1716156710231	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.4515	1716156710231	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156710245	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	153.39999999999998	1716156711233	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	8.6	1716156711233	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.4515	1716156711233	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156711248	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156712235	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156712235	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.4515	1716156712235	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156712249	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156713237	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156713237	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156713237	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156713258	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156714239	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156714239	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156714239	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156714264	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156715241	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	2.6	1716156715241	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156715241	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156715255	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156716243	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156716243	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6810999999999998	1716156716243	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156716265	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156717245	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156717245	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6810999999999998	1716156717245	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156717260	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156718247	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156718247	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6810999999999998	1716156718247	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156718269	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156719249	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156719249	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6822000000000001	1716156719249	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156719264	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156720251	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156720251	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6822000000000001	1716156720251	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156720265	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156721253	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156721253	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6822000000000001	1716156721253	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156721275	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156722255	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156722255	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156722255	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156722276	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156723257	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156723257	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156723257	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156723278	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156724259	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156724259	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.682	1716156724259	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156724280	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156725275	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156726284	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156727287	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156728281	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156729289	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156730284	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156731295	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156732295	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156733297	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156734293	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156735294	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156736302	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156737316	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156738307	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156739303	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156740312	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156741314	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156742313	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156743319	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156744320	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156745322	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156746323	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156747325	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156748320	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156749329	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156750333	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156751334	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156752334	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156753329	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156754339	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156755340	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156756345	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156757343	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157057903	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157057903	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1306	1716157057903	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157058905	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157058905	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157058905	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157059907	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157059907	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157059907	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157060909	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157060909	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157060909	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157061911	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157061911	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1309	1716157061911	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157062913	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157062913	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1309	1716157062913	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157063915	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157063915	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1309	1716157063915	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157064917	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157064917	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1336	1716157064917	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157065919	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157065919	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1336	1716157065919	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157066921	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157066921	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1336	1716157066921	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157067923	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156725261	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156725261	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6825	1716156725261	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156726262	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156726262	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6825	1716156726262	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156727264	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156727264	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6825	1716156727264	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156728266	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156728266	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6834	1716156728266	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156729268	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156729268	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6834	1716156729268	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	107	1716156730270	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156730270	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6834	1716156730270	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156731272	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156731272	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6817	1716156731272	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156732274	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156732274	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6817	1716156732274	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156733276	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156733276	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6817	1716156733276	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156734278	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156734278	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6844000000000001	1716156734278	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156735280	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156735280	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6844000000000001	1716156735280	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156736282	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156736282	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	1.6844000000000001	1716156736282	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156737284	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156737284	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1953	1716156737284	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156738286	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156738286	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1953	1716156738286	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156739288	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156739288	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1953	1716156739288	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156740290	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156740290	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2018	1716156740290	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156741292	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156741292	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2018	1716156741292	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156742294	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156742294	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2018	1716156742294	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156743295	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156743295	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2049000000000003	1716156743295	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156744297	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156744297	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2049000000000003	1716156744297	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156745299	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156745299	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2049000000000003	1716156745299	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156746301	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156746301	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2064	1716156746301	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156747303	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156747303	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2064	1716156747303	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156748305	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156748305	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2064	1716156748305	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156749307	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156749307	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2056999999999998	1716156749307	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156750309	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156750309	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2056999999999998	1716156750309	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156751311	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156751311	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2056999999999998	1716156751311	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156752313	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156752313	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2066999999999997	1716156752313	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156753314	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156753314	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2066999999999997	1716156753314	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156754316	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156754316	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2066999999999997	1716156754316	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156755318	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156755318	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2091999999999996	1716156755318	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156756319	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156756319	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2091999999999996	1716156756319	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156757321	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156757321	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.2091999999999996	1716156757321	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156758323	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156758323	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1055	1716156758323	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156758346	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	99	1716156759325	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156759325	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1055	1716156759325	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156759347	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156760327	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156760327	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1055	1716156760327	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156760349	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156761329	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156761329	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1092	1716156761329	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156761351	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156762331	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156762331	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1092	1716156762331	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156762353	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156763333	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156763333	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1092	1716156763333	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156763350	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156764336	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156764336	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1095	1716156764336	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156764360	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156765340	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156765340	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1095	1716156765340	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156766342	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156766342	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1095	1716156766342	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156767344	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156767344	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1099	1716156767344	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156768346	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156768346	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1099	1716156768346	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156769348	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156769348	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1099	1716156769348	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156770350	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156770350	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1094	1716156770350	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156771352	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156771352	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1094	1716156771352	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156772353	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156772353	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1094	1716156772353	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156773355	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156773355	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1083000000000003	1716156773355	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156774357	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156774357	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1083000000000003	1716156774357	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156775359	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156775359	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1083000000000003	1716156775359	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156776361	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156776361	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1108000000000002	1716156776361	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156777363	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156777363	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1108000000000002	1716156777363	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156778365	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156778365	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1108000000000002	1716156778365	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156779366	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156779366	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.11	1716156779366	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156780368	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156780368	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.11	1716156780368	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156781370	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156781370	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.11	1716156781370	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156782372	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156782372	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1090999999999998	1716156782372	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156783374	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156783374	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1090999999999998	1716156783374	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156784376	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156784376	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1090999999999998	1716156784376	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156785378	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156785378	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1104000000000003	1716156785378	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156786380	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156786380	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156765364	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156766364	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156767365	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156768360	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156769370	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156770374	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156771378	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156772373	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156773377	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156774379	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156775381	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156776382	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156777383	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156778380	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156779381	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156780392	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156781393	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156782394	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156783391	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156784399	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156785401	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156786404	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156787397	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156788408	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156789407	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156790410	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156791411	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156792415	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156793414	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156794416	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156795421	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156796419	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156797414	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156798425	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156799425	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156800428	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156801429	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156802426	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156803439	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156804440	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156805438	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156806441	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156807443	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156808441	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156809438	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156810439	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156811450	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156812451	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156813456	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156814454	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156815461	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156816463	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156817462	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157057920	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157058928	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157059921	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157060930	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157061932	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157062929	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157063936	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157064939	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157065943	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157066942	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157067937	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157068948	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1104000000000003	1716156786380	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156787382	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156787382	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1104000000000003	1716156787382	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156788384	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156788384	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156788384	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156789385	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156789385	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156789385	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156790387	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156790387	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156790387	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156791389	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156791389	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1139	1716156791389	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156792391	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156792391	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1139	1716156792391	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156793393	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156793393	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1139	1716156793393	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156794395	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156794395	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1146	1716156794395	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156795396	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156795396	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1146	1716156795396	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156796398	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156796398	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1146	1716156796398	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156797400	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156797400	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716156797400	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156798402	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156798402	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716156798402	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156799404	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156799404	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716156799404	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156800406	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156800406	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.0926	1716156800406	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156801408	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156801408	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.0926	1716156801408	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156802410	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156802410	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.0926	1716156802410	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156803413	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156803413	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.087	1716156803413	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156804414	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156804414	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.087	1716156804414	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156805416	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156805416	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.087	1716156805416	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156806418	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156806418	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156806418	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156807420	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156807420	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156807420	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156808422	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156808422	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156808422	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156809424	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156809424	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156809424	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156810426	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156810426	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156810426	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156811428	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156811428	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156811428	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156812429	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156812429	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1029	1716156812429	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156813431	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156813431	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1029	1716156813431	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156814433	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156814433	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1029	1716156814433	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156815435	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156815435	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1128	1716156815435	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156816438	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156816438	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1128	1716156816438	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156817440	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156817440	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1128	1716156817440	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156818442	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156818442	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1130999999999998	1716156818442	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156818464	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156819444	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.3	1716156819444	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1130999999999998	1716156819444	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156819467	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156820445	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156820445	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1130999999999998	1716156820445	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156820468	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156821447	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156821447	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156821447	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156821471	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156822449	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156822449	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156822449	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156822471	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156823451	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156823451	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1125	1716156823451	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156823466	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156824454	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156824454	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156824454	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156824470	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156825456	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156825456	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156825456	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156825478	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156826458	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156826458	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156826458	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156827460	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156827460	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151999999999997	1716156827460	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156828462	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156828462	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151999999999997	1716156828462	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156829464	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156829464	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151999999999997	1716156829464	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156830466	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.1	1716156830466	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1148000000000002	1716156830466	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156831468	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	6.8999999999999995	1716156831468	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1148000000000002	1716156831468	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	106.9	1716156832469	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156832469	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1148000000000002	1716156832469	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156833471	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156833471	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1144000000000003	1716156833471	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156834472	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156834472	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1144000000000003	1716156834472	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156835474	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156835474	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1144000000000003	1716156835474	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156836475	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156836475	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.116	1716156836475	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156837477	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156837477	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.116	1716156837477	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156838478	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156838478	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.116	1716156838478	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156839480	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156839480	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1187	1716156839480	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156840482	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156840482	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1187	1716156840482	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156841484	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156841484	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1187	1716156841484	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156842486	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156842486	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716156842486	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156843488	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156843488	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716156843488	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156844490	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156844490	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716156844490	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156845492	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156845492	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1191	1716156845492	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156846494	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156846494	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1191	1716156846494	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156847496	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156847496	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1191	1716156847496	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156826480	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156827482	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156828476	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156829485	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156830546	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156831489	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156832483	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156833493	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156834494	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156835498	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156836497	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156837491	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156838500	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156839503	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156840498	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156841511	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156842502	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156843513	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156844511	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156845513	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156846516	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156847509	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156848522	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156849523	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156850523	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156851526	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156852523	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156853535	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156854533	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156855529	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156856537	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156857531	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156858542	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156859542	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156860546	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156861547	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156862543	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156863542	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156864552	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156865546	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156866549	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156867553	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156868553	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156869562	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156870562	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156871564	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156872559	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156873570	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156874571	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156875577	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156876577	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156877576	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157067923	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157067923	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157068925	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157068925	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157068925	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157069927	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157069927	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157069927	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157070929	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157070929	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1327	1716157070929	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157071930	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157071930	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156848498	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156848498	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1199	1716156848498	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156849499	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156849499	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1199	1716156849499	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156850502	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156850502	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1199	1716156850502	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156851504	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156851504	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.12	1716156851504	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156852506	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156852506	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.12	1716156852506	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156853509	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156853509	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.12	1716156853509	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156854511	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156854511	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1203000000000003	1716156854511	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156855513	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156855513	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1203000000000003	1716156855513	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156856515	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156856515	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1203000000000003	1716156856515	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156857517	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156857517	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1214	1716156857517	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156858519	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156858519	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1214	1716156858519	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156859521	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156859521	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1214	1716156859521	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156860522	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156860522	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1208	1716156860522	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156861524	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156861524	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1208	1716156861524	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156862525	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156862525	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1208	1716156862525	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156863528	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156863528	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716156863528	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156864530	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156864530	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716156864530	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156865532	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156865532	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716156865532	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156866534	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156866534	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1223	1716156866534	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156867535	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156867535	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1223	1716156867535	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156868537	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156868537	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1223	1716156868537	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156869539	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156869539	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.121	1716156869539	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156870541	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156870541	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.121	1716156870541	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156871543	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156871543	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.121	1716156871543	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156872545	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156872545	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1005	1716156872545	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156873547	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156873547	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1005	1716156873547	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156874549	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156874549	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1005	1716156874549	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156875551	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156875551	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156875551	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156876552	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156876552	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156876552	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156877555	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156877555	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1115	1716156877555	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156878556	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156878556	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1166	1716156878556	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156878577	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156879558	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156879558	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1166	1716156879558	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156879581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156880560	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156880560	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1166	1716156880560	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156880582	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156881562	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156881562	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1181	1716156881562	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156881578	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156882564	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156882564	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1181	1716156882564	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156882581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156883566	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156883566	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1181	1716156883566	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156883581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156884568	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156884568	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156884568	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156884590	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156885570	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156885570	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156885570	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156885591	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156886572	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156886572	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1102	1716156886572	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156886598	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156887574	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156887574	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156887574	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156888576	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156888576	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156888576	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156889578	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156889578	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1138000000000003	1716156889578	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156890580	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156890580	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1157	1716156890580	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156891581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156891581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1157	1716156891581	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156892583	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156892583	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1157	1716156892583	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156893585	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156893585	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1189	1716156893585	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156894587	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156894587	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1189	1716156894587	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156895589	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156895589	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1189	1716156895589	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156896591	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156896591	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1170999999999998	1716156896591	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156897593	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156897593	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1170999999999998	1716156897593	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156898595	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156898595	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1170999999999998	1716156898595	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156899597	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156899597	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.118	1716156899597	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156900599	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156900599	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.118	1716156900599	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156901601	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156901601	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.118	1716156901601	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156902603	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.4	1716156902603	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.119	1716156902603	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156903604	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156903604	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.119	1716156903604	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156904606	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156904606	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.119	1716156904606	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156905608	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156905608	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1184000000000003	1716156905608	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156906610	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156906610	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1184000000000003	1716156906610	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156907612	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156907612	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1184000000000003	1716156907612	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156908614	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156908614	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1198	1716156908614	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156887591	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156888597	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156889602	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156890603	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156891603	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156892597	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156893606	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156894611	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156895610	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156896612	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156897607	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156898618	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156899620	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156900620	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156901623	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156902616	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156903626	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156904621	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156905631	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156906631	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156907634	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156908634	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156909636	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156910639	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156911641	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156912644	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156913637	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156914647	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156915640	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156916653	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156917654	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156918646	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156919656	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156920659	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156921659	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156922665	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156923663	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156924665	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156925667	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156926668	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156927663	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156928677	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156929677	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156930684	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156931680	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156932674	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156933684	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156934678	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156935689	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156936689	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156937692	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157069948	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157070951	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157071952	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157072950	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157073956	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157074957	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157075961	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157076962	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157077957	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157078965	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157079968	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157080970	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157081971	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157082965	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156909616	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156909616	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1198	1716156909616	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156910618	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156910618	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1198	1716156910618	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156911619	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156911619	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1216	1716156911619	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156912621	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156912621	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1216	1716156912621	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156913623	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156913623	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1216	1716156913623	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156914625	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156914625	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1222	1716156914625	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156915627	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156915627	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1222	1716156915627	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156916629	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156916629	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1222	1716156916629	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156917631	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156917631	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231	1716156917631	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156918632	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156918632	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231	1716156918632	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156919634	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156919634	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231	1716156919634	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156920637	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156920637	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1227	1716156920637	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156921638	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156921638	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1227	1716156921638	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156922640	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156922640	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1227	1716156922640	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156923642	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156923642	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.123	1716156923642	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156924644	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156924644	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.123	1716156924644	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156925646	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156925646	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.123	1716156925646	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156926648	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156926648	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716156926648	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156927649	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156927649	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716156927649	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156928651	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156928651	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716156928651	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156929655	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156929655	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1235999999999997	1716156929655	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156930657	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156930657	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1235999999999997	1716156930657	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156931659	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156931659	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1235999999999997	1716156931659	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156932660	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156932660	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716156932660	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156933662	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156933662	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716156933662	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156934664	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156934664	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716156934664	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156935666	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156935666	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716156935666	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156936668	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156936668	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716156936668	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156937670	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156937670	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716156937670	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156938672	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156938672	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1268000000000002	1716156938672	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156938687	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156939674	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156939674	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1268000000000002	1716156939674	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156939696	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156940676	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156940676	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1268000000000002	1716156940676	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156940696	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156941678	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156941678	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.125	1716156941678	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156941700	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156942680	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156942680	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.125	1716156942680	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156942695	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156943682	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156943682	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.125	1716156943682	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156943703	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156944685	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156944685	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1056999999999997	1716156944685	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156944707	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156945687	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156945687	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1056999999999997	1716156945687	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156945709	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156946689	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156946689	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1056999999999997	1716156946689	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156946710	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156947691	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156947691	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1101	1716156947691	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156947706	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156948693	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156948693	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1101	1716156948693	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156949695	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156949695	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1101	1716156949695	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156950697	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156950697	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1132	1716156950697	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156951699	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156951699	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1132	1716156951699	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156952700	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156952700	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1132	1716156952700	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156953702	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156953702	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1033000000000004	1716156953702	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156954704	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156954704	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1033000000000004	1716156954704	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156955706	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156955706	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1033000000000004	1716156955706	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156956708	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156956708	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151	1716156956708	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156957710	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156957710	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151	1716156957710	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156958712	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156958712	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1151	1716156958712	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156959714	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156959714	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1210999999999998	1716156959714	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156960716	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156960716	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1210999999999998	1716156960716	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156961717	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156961717	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1210999999999998	1716156961717	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156962719	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156962719	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1205	1716156962719	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156963721	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156963721	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1205	1716156963721	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156964723	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156964723	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1205	1716156964723	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156965725	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156965725	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231999999999998	1716156965725	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156966726	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156966726	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231999999999998	1716156966726	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156967728	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156967728	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1231999999999998	1716156967728	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156968730	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156968730	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1258000000000004	1716156968730	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156969732	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156969732	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156948710	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156949708	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156950721	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156951720	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156952714	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156953715	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156954726	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156955729	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156956731	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156957732	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156958731	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156959736	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156960738	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156961740	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156962741	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156963736	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156964737	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156965746	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156966750	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156967743	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156968745	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156969754	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156970756	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156971760	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156972753	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156973762	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156974764	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156975763	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156976767	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156977762	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156978769	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156979772	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156980774	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156981775	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156982778	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156983826	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156984784	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156985784	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156986788	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156987780	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156988789	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156989790	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156990793	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156991793	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156992790	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156993800	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156994803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156995803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156996805	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156997807	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1327	1716157071930	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157072932	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157072932	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1327	1716157072932	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157073934	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157073934	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.135	1716157073934	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157074936	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157074936	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.135	1716157074936	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157075938	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157075938	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.135	1716157075938	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157076940	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157076940	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1258000000000004	1716156969732	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156970734	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156970734	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1258000000000004	1716156970734	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156971736	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.2	1716156971736	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1265	1716156971736	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156972738	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7	1716156972738	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1265	1716156972738	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156973740	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.1	1716156973740	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1265	1716156973740	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156974742	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156974742	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1271	1716156974742	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156975744	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156975744	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1271	1716156975744	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156976746	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.1	1716156976746	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1271	1716156976746	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156977748	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156977748	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716156977748	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156978749	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156978749	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716156978749	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156979751	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.1	1716156979751	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716156979751	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156980753	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156980753	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281	1716156980753	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156981755	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.1	1716156981755	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281	1716156981755	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156982756	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156982756	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281	1716156982756	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156983758	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.1	1716156983758	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1273	1716156983758	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716156984760	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156984760	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1273	1716156984760	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	106	1716156985762	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156985762	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1273	1716156985762	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156986764	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156986764	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281999999999996	1716156986764	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156987766	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156987766	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281999999999996	1716156987766	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156988768	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156988768	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1281999999999996	1716156988768	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156989769	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156989769	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716156989769	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156990771	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156990771	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716156990771	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156991773	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156991773	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716156991773	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156992776	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156992776	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.128	1716156992776	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716156993778	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	2.8	1716156993778	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.128	1716156993778	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156994780	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156994780	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.128	1716156994780	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716156995782	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156995782	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1305	1716156995782	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716156996784	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156996784	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1305	1716156996784	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716156997786	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716156997786	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1305	1716156997786	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156998788	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156998788	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1303	1716156998788	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156998803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716156999790	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716156999790	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1303	1716156999790	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716156999812	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157000792	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157000792	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1303	1716157000792	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157000814	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157001793	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157001793	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1314	1716157001793	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157001819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157002795	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157002795	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1314	1716157002795	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157002809	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157003797	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157003797	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1314	1716157003797	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157003819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157004799	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157004799	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1307	1716157004799	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157004821	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157005802	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157005802	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1307	1716157005802	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157005824	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157006803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157006803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1307	1716157006803	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157006825	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157007805	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157007805	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157007805	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157007819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157008807	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157008807	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157008807	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157008820	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157009826	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157010832	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157011835	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157012837	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157013840	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157014841	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157015842	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157016844	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157017838	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157018851	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157019851	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157020852	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157021847	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157022852	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157023859	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157024860	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157025864	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157026865	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157027866	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157028870	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157029870	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157030873	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157031874	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157032869	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157033878	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157034874	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157035881	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157036884	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157037878	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157038886	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157039881	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157040890	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157041893	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157042896	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157043898	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157044901	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157045902	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157046902	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157047897	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157048907	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157049909	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157050911	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157051905	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157052908	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157053919	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157054912	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157055922	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157056925	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157076940	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157077942	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157077942	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157077942	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157078944	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157078944	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157078944	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157079946	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157079946	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157079946	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157080948	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157080948	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157080948	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157081950	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157081950	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157081950	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157009809	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157009809	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1324	1716157009809	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157010811	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157010811	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1311999999999998	1716157010811	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157011813	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157011813	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1311999999999998	1716157011813	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157012815	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157012815	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1311999999999998	1716157012815	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157013817	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157013817	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.131	1716157013817	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157014819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157014819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.131	1716157014819	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157015821	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157015821	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.131	1716157015821	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157016823	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157016823	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1145	1716157016823	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157017824	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157017824	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1145	1716157017824	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157018826	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157018826	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1145	1716157018826	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157019828	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157019828	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716157019828	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157020830	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157020830	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716157020830	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157021833	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157021833	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1239	1716157021833	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157022835	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157022835	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716157022835	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157023837	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.6	1716157023837	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716157023837	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157024839	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157024839	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1253	1716157024839	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157025841	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157025841	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1096	1716157025841	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157026843	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157026843	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1096	1716157026843	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157027844	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157027844	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1096	1716157027844	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157028846	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157028846	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1119	1716157028846	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157029848	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157029848	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1119	1716157029848	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157030850	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157030850	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1119	1716157030850	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157031852	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157031852	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716157031852	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157032854	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157032854	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716157032854	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157033856	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157033856	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1147	1716157033856	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157034858	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157034858	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716157034858	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	99	1716157035860	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157035860	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716157035860	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157036862	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157036862	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1213	1716157036862	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157037864	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157037864	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716157037864	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157038866	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157038866	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716157038866	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157039867	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157039867	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1261	1716157039867	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157040869	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157040869	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.129	1716157040869	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157041871	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157041871	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.129	1716157041871	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157042874	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157042874	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.129	1716157042874	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157043876	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157043876	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716157043876	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157044878	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157044878	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716157044878	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157045880	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157045880	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.127	1716157045880	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157046882	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157046882	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1287	1716157046882	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157047884	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157047884	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1287	1716157047884	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157048885	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157048885	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1287	1716157048885	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157049887	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157049887	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1296	1716157049887	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157050889	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157050889	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1296	1716157050889	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157051891	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157051891	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1296	1716157051891	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157052893	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157052893	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1315999999999997	1716157052893	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157053895	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157053895	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1315999999999997	1716157053895	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157054897	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157054897	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1315999999999997	1716157054897	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157055899	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157055899	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1306	1716157055899	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157056901	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157056901	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1306	1716157056901	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157082952	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157082952	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1321	1716157082952	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157083954	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157083954	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1321	1716157083954	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157083974	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157084956	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157084956	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1321	1716157084956	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157084978	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157085958	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157085958	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351999999999998	1716157085958	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157085980	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157086961	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157086961	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351999999999998	1716157086961	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157086974	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157087963	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157087963	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351999999999998	1716157087963	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157087988	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157088964	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157088964	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1154	1716157088964	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157088985	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157089966	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157089966	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1154	1716157089966	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157089981	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157090968	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157090968	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1154	1716157090968	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157090992	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157091970	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157091970	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1159	1716157091970	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157091992	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157092972	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157092972	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1159	1716157092972	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157092987	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157093974	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157093974	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1159	1716157093974	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157093988	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157094976	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157094976	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716157094976	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157095978	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157095978	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716157095978	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157096980	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157096980	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1274	1716157096980	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157097982	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157097982	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1167	1716157097982	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157098983	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157098983	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1167	1716157098983	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157099985	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157099985	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1167	1716157099985	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157100987	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157100987	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1289000000000002	1716157100987	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157101989	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157101989	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1289000000000002	1716157101989	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157102991	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157102991	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1289000000000002	1716157102991	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157103993	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157103993	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1318	1716157103993	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157104995	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.3	1716157104995	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1318	1716157104995	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157105997	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.199999999999999	1716157105997	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1318	1716157105997	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157106999	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157106999	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1342	1716157106999	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157108001	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157108001	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1342	1716157108001	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157109004	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157109004	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1342	1716157109004	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157110007	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157110007	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1345	1716157110007	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157111009	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157111009	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1345	1716157111009	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157112011	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157112011	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351	1716157112011	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157113012	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157113012	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351	1716157113012	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157114014	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157114014	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1351	1716157114014	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157115016	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157115016	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1370999999999998	1716157115016	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157116018	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157116018	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157094998	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157096003	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157097003	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157098003	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157099005	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157100008	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157101001	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157102010	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157103012	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157104015	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157105009	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157106018	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157107020	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157108014	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157109026	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157110021	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157111024	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157112032	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157113028	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157114039	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157115033	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157116041	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157117043	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1370999999999998	1716157116018	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157117020	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157117020	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1370999999999998	1716157117020	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157118022	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157118022	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1393	1716157118022	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157118035	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157119024	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157119024	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1393	1716157119024	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157119048	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157120026	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157120026	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1393	1716157120026	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157120048	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157121027	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157121027	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157121027	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157121049	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157122029	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157122029	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157122029	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157122051	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157123031	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157123031	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157123031	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157123045	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157124033	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157124033	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157124033	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157124055	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157125035	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157125035	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157125035	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157125058	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157126037	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157126037	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157126037	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157126060	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157127038	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157127038	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157127038	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157127063	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157128040	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157128040	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157128040	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157128057	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157129042	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157129042	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1333	1716157129042	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157129068	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157130044	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157130044	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157130044	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157130066	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157131046	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157131046	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157131046	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157131067	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157132048	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157132048	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1361	1716157132048	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157132069	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157133050	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157133050	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1359	1716157133050	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157134052	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157134052	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1359	1716157134052	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157135054	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157135054	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1359	1716157135054	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	104	1716157136056	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.700000000000001	1716157136056	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1372	1716157136056	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157137058	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157137058	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1372	1716157137058	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157138060	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157138060	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1372	1716157138060	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157139062	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157139062	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1386	1716157139062	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157140064	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157140064	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1386	1716157140064	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157141066	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157141066	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1386	1716157141066	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157142068	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157142068	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.139	1716157142068	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157143070	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157143070	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.139	1716157143070	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	105	1716157144072	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157144072	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.139	1716157144072	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157145074	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157145074	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1367	1716157145074	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157146076	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157146076	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1367	1716157146076	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157147078	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157147078	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1367	1716157147078	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157148080	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157148080	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1354	1716157148080	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157149082	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157149082	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1354	1716157149082	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157150084	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157150084	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1354	1716157150084	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157151086	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157151086	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157151086	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157152088	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157152088	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157152088	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157153089	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157153089	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.136	1716157153089	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157154092	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157133073	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157134074	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157135072	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157136078	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157137080	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157138074	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157139075	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157140089	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157141089	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157142101	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157143087	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157144093	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157145099	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157146100	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157147092	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157148101	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157149107	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157150106	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157151109	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157152110	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157153104	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157154113	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157155115	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157156116	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157157118	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157158113	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157159124	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157160125	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157161130	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157162130	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157163129	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157164131	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157165128	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157166136	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157167136	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157168132	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157169140	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157170135	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157171147	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157172146	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157173142	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157174142	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157175154	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157176156	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157177150	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157154092	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1378000000000004	1716157154092	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157155093	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157155093	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1378000000000004	1716157155093	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157156095	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157156095	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1378000000000004	1716157156095	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157157097	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157157097	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1423	1716157157097	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157158099	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157158099	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1423	1716157158099	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157159101	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157159101	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1423	1716157159101	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157160103	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157160103	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716157160103	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157161105	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157161105	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716157161105	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157162106	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157162106	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1201	1716157162106	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157163108	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157163108	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1215	1716157163108	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157164110	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157164110	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1215	1716157164110	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157165112	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157165112	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1215	1716157165112	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157166114	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157166114	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.133	1716157166114	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157167116	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157167116	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.133	1716157167116	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157168118	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.699999999999999	1716157168118	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.133	1716157168118	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	100	1716157169119	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157169119	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1349	1716157169119	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157170121	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157170121	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1349	1716157170121	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157171123	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157171123	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1349	1716157171123	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157172125	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157172125	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157172125	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157173127	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157173127	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157173127	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157174129	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157174129	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1397	1716157174129	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157175130	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157175130	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1373	1716157175130	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157176134	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157176134	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1373	1716157176134	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157177136	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157177136	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1373	1716157177136	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157178138	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157178138	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1404	1716157178138	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157178160	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157179140	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157179140	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1404	1716157179140	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157179162	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157180142	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157180142	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1404	1716157180142	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157180155	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157181144	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157181144	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1399	1716157181144	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157181163	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157182145	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157182145	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1399	1716157182145	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157182159	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157183147	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157183147	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1399	1716157183147	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157183169	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	101	1716157184149	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157184149	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1406	1716157184149	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157184172	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	103	1716157185151	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157185151	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1406	1716157185151	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157185173	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157186152	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157186152	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1406	1716157186152	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157186179	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157187154	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157187154	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1414	1716157187154	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157187168	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157188156	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157188156	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1414	1716157188156	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157188170	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157189158	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	7.300000000000001	1716157189158	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1414	1716157189158	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157189182	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - CPU Utilization	102	1716157190160	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Utilization	5.4	1716157190160	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Memory Usage GB	2.1431999999999998	1716157190160	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
TOP - Swap Memory GB	0.0757	1716157190181	16ee1ed4a1474d78bd1ef7aedd027c33	0	f
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
letter	0	88a05ce8aa2f47e89541183c6eba278b
workload	0	88a05ce8aa2f47e89541183c6eba278b
listeners	smi+top+dcgmi	88a05ce8aa2f47e89541183c6eba278b
params	'"-"'	88a05ce8aa2f47e89541183c6eba278b
file	cifar10.py	88a05ce8aa2f47e89541183c6eba278b
workload_listener	''	88a05ce8aa2f47e89541183c6eba278b
letter	0	16ee1ed4a1474d78bd1ef7aedd027c33
workload	0	16ee1ed4a1474d78bd1ef7aedd027c33
listeners	smi+top+dcgmi	16ee1ed4a1474d78bd1ef7aedd027c33
params	'"-"'	16ee1ed4a1474d78bd1ef7aedd027c33
file	cifar10.py	16ee1ed4a1474d78bd1ef7aedd027c33
workload_listener	''	16ee1ed4a1474d78bd1ef7aedd027c33
model	cifar10.py	16ee1ed4a1474d78bd1ef7aedd027c33
manual	False	16ee1ed4a1474d78bd1ef7aedd027c33
max_epoch	5	16ee1ed4a1474d78bd1ef7aedd027c33
max_time	172800	16ee1ed4a1474d78bd1ef7aedd027c33
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
88a05ce8aa2f47e89541183c6eba278b	mysterious-skunk-22	UNKNOWN			daga	FAILED	1716156537958	1716156645464		active	s3://mlflow-storage/0/88a05ce8aa2f47e89541183c6eba278b/artifacts	0	\N
16ee1ed4a1474d78bd1ef7aedd027c33	(0 0) thoughtful-zebra-220	UNKNOWN			daga	FINISHED	1716156703094	1716157191055		active	s3://mlflow-storage/0/16ee1ed4a1474d78bd1ef7aedd027c33/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	88a05ce8aa2f47e89541183c6eba278b
mlflow.source.name	file:///home/daga/radt#examples/pytorch	88a05ce8aa2f47e89541183c6eba278b
mlflow.source.type	PROJECT	88a05ce8aa2f47e89541183c6eba278b
mlflow.project.entryPoint	main	88a05ce8aa2f47e89541183c6eba278b
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	88a05ce8aa2f47e89541183c6eba278b
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	88a05ce8aa2f47e89541183c6eba278b
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	88a05ce8aa2f47e89541183c6eba278b
mlflow.runName	mysterious-skunk-22	88a05ce8aa2f47e89541183c6eba278b
mlflow.project.env	conda	88a05ce8aa2f47e89541183c6eba278b
mlflow.project.backend	local	88a05ce8aa2f47e89541183c6eba278b
mlflow.user	daga	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.source.name	file:///home/daga/radt#examples/pytorch	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.source.type	PROJECT	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.project.entryPoint	main	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.project.env	conda	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.project.backend	local	16ee1ed4a1474d78bd1ef7aedd027c33
mlflow.runName	(0 0) thoughtful-zebra-220	16ee1ed4a1474d78bd1ef7aedd027c33
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

