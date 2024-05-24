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
0	Default	s3://mlflow-storage/0	active	1716293836527	1716293836527
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
SMI - Power Draw	14.56	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
SMI - Timestamp	1716294995.778	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
SMI - GPU Util	0	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
SMI - Mem Util	0	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
SMI - Mem Used	0	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
SMI - Performance State	0	1716294995792	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
TOP - CPU Utilization	104	1716295447708	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
TOP - Memory Usage GB	1.9278	1716295447708	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
TOP - Memory Utilization	7.7	1716295447708	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
TOP - Swap Memory GB	0.0005	1716295447729	0	f	9f31f29ea98e41e5b2c7f01c28e8eb5d
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.56	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
SMI - Timestamp	1716294995.778	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
SMI - GPU Util	0	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
SMI - Mem Util	0	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
SMI - Mem Used	0	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
SMI - Performance State	0	1716294995792	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	0	1716294995848	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	0	1716294995848	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.2303	1716294995848	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716294995861	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	146.7	1716294996849	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	9	1716294996849	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.2303	1716294996849	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716294996864	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716294997852	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716294997852	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.2303	1716294997852	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716294997865	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716294998854	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716294998854	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716294998854	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716294998873	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716294999855	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716294999855	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716294999855	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716294999877	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	105	1716295000857	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295000857	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295000857	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295000872	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295001859	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295001859	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4618	1716295001859	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295001873	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	106	1716295002861	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295002861	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4618	1716295002861	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295002874	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295003863	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295003863	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4618	1716295003863	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295003884	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295004865	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295004865	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295004865	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295004887	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	105	1716295005867	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295005867	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295005867	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295005880	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295006869	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295006869	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295006869	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295006883	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295007871	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295007871	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295007871	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295007892	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	105	1716295008873	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295008873	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295008873	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295008886	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295009875	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295009875	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4619000000000002	1716295009875	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295009896	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295010890	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295011892	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295012900	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295013904	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295014905	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295015907	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295016901	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295017912	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295018907	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295019919	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295020917	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295021913	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295022924	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295023925	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295024925	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295025931	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295026925	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295027933	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295028934	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295029936	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295030936	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295031932	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295032941	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295033944	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295034948	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295035946	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295036942	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295037956	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295038952	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295039956	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295040959	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295041954	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295042954	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295043970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295044970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295045969	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295046963	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295047972	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295048975	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295049970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295050979	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295051971	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295052982	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295053983	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295054984	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295055986	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295056982	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295297422	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295297422	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9228	1716295297422	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295315456	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.924	1716295315456	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295316458	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295316458	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295316458	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295317460	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295317460	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295317460	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295318462	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295318462	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295318462	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295319464	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295319464	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267	1716295319464	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295010877	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295010877	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4621	1716295010877	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	105	1716295011879	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295011879	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4621	1716295011879	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295012880	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295012880	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4621	1716295012880	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295013882	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295013882	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4612	1716295013882	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295014884	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295014884	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4612	1716295014884	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295015887	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295015887	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.4612	1716295015887	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295016889	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295016889	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.7669000000000001	1716295016889	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295017891	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295017891	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.7669000000000001	1716295017891	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295018893	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295018893	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.7669000000000001	1716295018893	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295019894	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295019894	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.978	1716295019894	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295020896	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295020896	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.978	1716295020896	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295021898	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295021898	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.978	1716295021898	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295022900	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295022900	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9832	1716295022900	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295023902	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295023902	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9832	1716295023902	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295024904	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295024904	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9832	1716295024904	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295025906	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295025906	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9846	1716295025906	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295026908	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295026908	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9846	1716295026908	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295027910	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295027910	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9846	1716295027910	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295028912	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295028912	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9853	1716295028912	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295029914	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295029914	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9853	1716295029914	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295030915	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295030915	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9853	1716295030915	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295031919	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295031919	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9872	1716295031919	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295032921	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295032921	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9872	1716295032921	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295033922	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295033922	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9872	1716295033922	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295034924	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295034924	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9902	1716295034924	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295035926	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295035926	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9902	1716295035926	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295036928	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295036928	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9902	1716295036928	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295037930	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295037930	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9921	1716295037930	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295038932	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295038932	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9921	1716295038932	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295039933	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295039933	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9921	1716295039933	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	99	1716295040937	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295040937	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8932	1716295040937	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295041938	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295041938	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8932	1716295041938	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295042940	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295042940	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8932	1716295042940	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295043942	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295043942	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8974000000000002	1716295043942	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295044944	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295044944	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8974000000000002	1716295044944	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295045946	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295045946	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8974000000000002	1716295045946	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295046948	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295046948	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8959000000000001	1716295046948	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295047950	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295047950	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8959000000000001	1716295047950	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295048952	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295048952	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8959000000000001	1716295048952	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295049953	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295049953	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.898	1716295049953	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295050955	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295050955	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.898	1716295050955	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295051957	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295051957	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.898	1716295051957	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295052959	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295052959	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8972	1716295052959	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295053961	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295053961	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8972	1716295053961	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295054963	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295054963	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8972	1716295054963	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295055964	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295055964	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295055964	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295056966	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295056966	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295056966	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295057968	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295057968	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295057968	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295057990	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295058970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295058970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8982999999999999	1716295058970	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295058992	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295059972	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295059972	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8982999999999999	1716295059972	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295059995	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295060974	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295060974	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8982999999999999	1716295060974	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295060997	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	99	1716295061976	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295061976	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295061976	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295061989	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295062978	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295062978	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295062978	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295062999	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295063980	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295063980	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8976	1716295063980	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295064000	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295064982	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.3	1716295064982	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9012	1716295064982	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295065002	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295065983	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.6	1716295065983	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9012	1716295065983	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295065997	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295066985	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295066985	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9012	1716295066985	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295067001	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295067986	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295067986	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9005	1716295067986	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295068008	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295068988	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295068988	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9005	1716295068988	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295069010	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295069990	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295069990	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9005	1716295069990	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295070014	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295071014	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295072013	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295073020	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295074025	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295075021	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295076022	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295077017	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295078029	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295079030	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295080036	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295081034	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295082026	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295083036	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295084038	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295085033	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295086043	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295087039	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295088047	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295089052	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295090047	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295091054	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295092048	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295093059	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295094058	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295095060	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295096055	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295097057	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295098065	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295099070	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295100072	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295101072	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295102066	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295103077	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295104083	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295105080	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295106084	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295107075	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295108078	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295109088	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295110090	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295111091	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295112085	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295113089	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295114092	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295115095	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295116154	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295117096	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295297436	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295298446	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295299447	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295300453	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295301445	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295302453	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295303456	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295304456	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295305459	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295306453	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295307464	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295308458	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295309467	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295310471	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295311463	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295312472	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295313473	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295070992	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295070992	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9025	1716295070992	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295071994	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295071994	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9025	1716295071994	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295072996	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295072996	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9025	1716295072996	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295073998	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295073998	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9021	1716295073998	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295075000	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295075000	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9021	1716295075000	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295076002	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295076002	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9021	1716295076002	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295077003	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295077003	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9045	1716295077003	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295078005	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295078005	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9045	1716295078005	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295079007	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295079007	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9045	1716295079007	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295080009	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295080009	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8897	1716295080009	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295081011	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295081011	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8897	1716295081011	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295082013	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295082013	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.8897	1716295082013	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295083015	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295083015	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9024	1716295083015	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295084016	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295084016	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9024	1716295084016	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295085019	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295085019	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9013	1716295085019	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295086021	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295086021	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9013	1716295086021	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295087024	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295087024	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9013	1716295087024	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295088026	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295088026	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9016	1716295088026	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295089028	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295089028	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9016	1716295089028	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295090029	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295090029	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9016	1716295090029	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295091031	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295091031	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9034	1716295091031	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295092033	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295092033	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9034	1716295092033	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295093035	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295093035	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9034	1716295093035	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295094036	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295094036	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9039000000000001	1716295094036	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295095038	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295095038	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9039000000000001	1716295095038	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295096040	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295096040	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9039000000000001	1716295096040	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295097042	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295097042	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9052	1716295097042	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295098044	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295098044	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9052	1716295098044	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295099047	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295099047	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9052	1716295099047	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295100049	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	4.3	1716295100049	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9056	1716295100049	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295101051	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295101051	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9056	1716295101051	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295102053	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295102053	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9056	1716295102053	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295103055	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295103055	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295103055	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295104056	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295104056	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295104056	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295105058	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295105058	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295105058	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295106060	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295106060	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9054	1716295106060	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295107062	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295107062	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9054	1716295107062	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295108064	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295108064	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9054	1716295108064	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295109066	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295109066	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295109066	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295110068	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.8	1716295110068	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295110068	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295111070	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295111070	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9033	1716295111070	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295112071	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295112071	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9062999999999999	1716295112071	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295113073	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295113073	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9062999999999999	1716295113073	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295114076	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295114076	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9062999999999999	1716295114076	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295115079	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295115079	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065999999999999	1716295115079	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295116081	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295116081	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065999999999999	1716295116081	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295117083	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295117083	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065999999999999	1716295117083	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	105.9	1716295118085	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295118085	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9073	1716295118085	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295118107	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295119086	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295119086	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9073	1716295119086	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295119111	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295120088	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295120088	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9073	1716295120088	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295120106	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295121090	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295121090	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295121090	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295121103	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295122092	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295122092	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295122092	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295122106	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295123094	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295123094	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295123094	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295123117	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295124096	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295124096	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295124096	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295124109	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295125097	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295125097	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295125097	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295125119	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295126098	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295126098	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9074	1716295126098	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295126112	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295127100	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295127100	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.908	1716295127100	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295127114	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295128102	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295128102	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.908	1716295128102	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295128118	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295129104	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295129104	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.908	1716295129104	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295129120	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295130106	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295130106	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9075	1716295130106	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295130120	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295131130	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295132125	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295133134	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295134135	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295135136	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295136138	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295137133	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295138143	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295139144	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295140151	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295141148	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295142142	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295143152	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295144152	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295145146	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295146157	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295147228	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295148160	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295149162	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295150165	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295151168	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295152161	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295153171	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295154173	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295155174	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295156176	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295157171	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295158181	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295159181	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295160185	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295161186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295162180	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295163190	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295164194	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295165193	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295166195	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295167192	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295168199	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295169200	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295170203	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295171206	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295172198	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295173210	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295174209	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295175202	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295176215	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295177214	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295298424	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295298424	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295298424	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295299426	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295299426	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295299426	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295300428	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295300428	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295300428	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295301430	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295301430	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295301430	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295302432	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295302432	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295302432	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295303434	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295303434	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295131108	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295131108	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9075	1716295131108	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295132110	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295132110	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9075	1716295132110	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295133112	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295133112	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9072	1716295133112	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295134114	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295134114	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9072	1716295134114	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295135115	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295135115	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9072	1716295135115	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295136116	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295136116	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9076	1716295136116	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295137118	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295137118	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9076	1716295137118	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295138120	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295138120	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9076	1716295138120	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295139122	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295139122	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295139122	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295140124	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295140124	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295140124	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295141126	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295141126	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295141126	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295142128	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295142128	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9085999999999999	1716295142128	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295143129	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295143129	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9085999999999999	1716295143129	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295144131	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295144131	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9085999999999999	1716295144131	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295145133	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295145133	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295145133	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295146135	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295146135	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295146135	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295147137	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.4	1716295147137	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295147137	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295148139	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295148139	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065	1716295148139	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	111	1716295149140	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295149140	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065	1716295149140	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295150142	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295150142	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9065	1716295150142	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295151144	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295151144	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.906	1716295151144	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295152146	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295152146	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.906	1716295152146	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295153149	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295153149	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.906	1716295153149	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295154151	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295154151	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9064	1716295154151	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295155153	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295155153	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9064	1716295155153	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295156155	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295156155	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9064	1716295156155	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295157156	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295157156	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295157156	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295158158	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295158158	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295158158	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295159160	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295159160	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295159160	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295160162	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295160162	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9081	1716295160162	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295161164	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295161164	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9081	1716295161164	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295162166	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295162166	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9081	1716295162166	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295163168	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295163168	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295163168	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295164170	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295164170	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295164170	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295165172	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295165172	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295165172	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295166174	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295166174	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295166174	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295167176	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295167176	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295167176	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295168177	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295168177	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9082000000000001	1716295168177	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295169179	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295169179	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.911	1716295169179	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295170180	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295170180	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.911	1716295170180	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295171182	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295171182	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.911	1716295171182	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295172184	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295172184	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9061	1716295172184	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295173186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295173186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9061	1716295173186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295174186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295174186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9061	1716295174186	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295175188	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295175188	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9078	1716295175188	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295176190	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295176190	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9078	1716295176190	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295177192	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295177192	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9078	1716295177192	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295178194	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295178194	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295178194	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295178219	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295179196	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295179196	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295179196	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295179217	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295180197	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295180197	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9102000000000001	1716295180197	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295180218	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295181198	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295181198	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295181198	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295181219	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295182200	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295182200	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295182200	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295182214	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295183202	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295183202	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295183202	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295183222	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295184204	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295184204	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9092	1716295184204	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295184225	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295185206	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295185206	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9092	1716295185206	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295185220	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295186208	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295186208	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9092	1716295186208	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295186226	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295187210	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295187210	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9089	1716295187210	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295187225	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295188211	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295188211	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9089	1716295188211	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295188233	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295189213	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295189213	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9089	1716295189213	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295189234	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295190216	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295190216	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295190216	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295190231	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295191241	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295192241	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295193245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295194245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295195251	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295196249	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295197245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295198254	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295199257	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295200250	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295201260	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295202253	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295203263	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295204265	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295205267	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295206263	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295207261	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295208273	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295209273	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295210275	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295211279	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295212271	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295213281	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295214282	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295215286	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295216287	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295217287	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295218293	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295219285	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295220293	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295221297	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295222298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295223297	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295224295	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295225298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295226298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295227301	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295228310	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295229313	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295230316	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295231320	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295232313	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295233319	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295234324	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295235315	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295236324	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295237330	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295303434	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295304436	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295304436	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225	1716295304436	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295305438	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295305438	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225	1716295305438	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295306439	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295306439	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225	1716295306439	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295307441	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295307441	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295307441	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295308443	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295308443	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295308443	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295309445	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295191218	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295191218	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295191218	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295192220	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295192220	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9098	1716295192220	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295193222	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295193222	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.907	1716295193222	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295194224	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.9	1716295194224	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.907	1716295194224	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295195226	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295195226	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.907	1716295195226	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295196228	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295196228	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295196228	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295197230	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295197230	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295197230	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295198232	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295198232	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9105	1716295198232	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295199234	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295199234	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9119000000000002	1716295199234	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295200236	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295200236	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9119000000000002	1716295200236	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295201238	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.7	1716295201238	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9119000000000002	1716295201238	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295202240	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.5	1716295202240	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9125	1716295202240	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295203241	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295203241	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9125	1716295203241	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295204244	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295204244	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9125	1716295204244	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295205245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295205245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9137	1716295205245	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295206247	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295206247	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9137	1716295206247	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295207248	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295207248	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9137	1716295207248	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295208250	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295208250	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295208250	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295209252	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295209252	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295209252	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295210254	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295210254	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295210254	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295211256	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295211256	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9118	1716295211256	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295212258	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295212258	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9118	1716295212258	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295213260	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6	1716295213260	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9118	1716295213260	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295214262	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295214262	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295214262	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295215263	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295215263	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295215263	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295216265	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295216265	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.909	1716295216265	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295217267	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295217267	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9112	1716295217267	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295218268	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295218268	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9112	1716295218268	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295219270	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295219270	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9112	1716295219270	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295220272	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295220272	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9129	1716295220272	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295221274	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295221274	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9129	1716295221274	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295222276	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295222276	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9129	1716295222276	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295223278	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295223278	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295223278	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295224280	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295224280	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295224280	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295225282	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295225282	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9135	1716295225282	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295226284	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295226284	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9136	1716295226284	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295227286	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295227286	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9136	1716295227286	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295228287	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295228287	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9136	1716295228287	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295229291	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295229291	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9156	1716295229291	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295230293	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295230293	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9156	1716295230293	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295231295	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295231295	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9156	1716295231295	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295232296	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295232296	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295232296	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295233298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295233298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295233298	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295234300	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295234300	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295234300	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295235302	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295235302	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9157	1716295235302	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295236304	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295236304	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9157	1716295236304	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295237306	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295237306	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9157	1716295237306	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295238308	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295238308	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295238308	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295238337	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295239310	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295239310	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295239310	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295239333	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295240312	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295240312	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9165	1716295240312	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295240335	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295241315	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295241315	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295241315	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295241336	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295242317	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295242317	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295242317	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295242333	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295243318	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295243318	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295243318	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295243333	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295244320	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295244320	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295244320	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295244342	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295245322	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295245322	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295245322	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295245344	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295246323	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295246323	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9181	1716295246323	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295246344	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295247325	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295247325	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295247325	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295247338	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295248327	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295248327	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295248327	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295248349	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295249328	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295249328	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295249328	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295249350	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295250330	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295250330	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9203	1716295250330	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295250353	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295251349	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295252359	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295253360	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295254359	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295255362	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295256356	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295257365	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295258367	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295259370	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295260371	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295261367	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295262367	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295263378	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295264374	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295265381	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295266378	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295267387	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295268388	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295269390	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295270390	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295271387	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295272397	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295273401	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295274399	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295275404	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295276395	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295277406	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295278408	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295279411	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295280413	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295281409	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295282414	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295283415	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295284411	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295285422	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295286425	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295287418	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295288427	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295289429	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295290431	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295291432	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295292426	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295293438	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295294443	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295295439	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295296434	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295309445	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245999999999999	1716295309445	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295310447	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295310447	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295310447	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295311449	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295311449	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295311449	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295312450	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295312450	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295312450	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295313452	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295313452	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.924	1716295313452	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295314454	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295314454	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.924	1716295314454	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295315456	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295251332	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295251332	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9203	1716295251332	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295252334	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295252334	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9203	1716295252334	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295253336	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295253336	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9196	1716295253336	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295254337	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295254337	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9196	1716295254337	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295255339	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295255339	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9196	1716295255339	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295256341	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295256341	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9202000000000001	1716295256341	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295257343	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295257343	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9202000000000001	1716295257343	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	99	1716295258345	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295258345	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9202000000000001	1716295258345	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295259349	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295259349	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295259349	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295260350	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295260350	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295260350	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295261352	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295261352	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9223	1716295261352	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295262354	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295262354	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9210999999999998	1716295262354	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295263356	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295263356	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9210999999999998	1716295263356	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295264358	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295264358	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9210999999999998	1716295264358	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295265360	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295265360	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295265360	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295266362	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295266362	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295266362	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295267363	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295267363	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9213	1716295267363	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295268365	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295268365	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295268365	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295269368	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295269368	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295269368	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295270370	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295270370	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295270370	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295271372	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295271372	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9229	1716295271372	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295272373	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295272373	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9229	1716295272373	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295273375	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295273375	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9229	1716295273375	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295274377	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295274377	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295274377	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295275380	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295275380	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295275380	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295276382	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295276382	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295276382	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295277384	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295277384	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295277384	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295278386	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295278386	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295278386	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295279388	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295279388	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9225999999999999	1716295279388	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295280390	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295280390	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9207	1716295280390	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295281391	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295281391	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9207	1716295281391	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295282393	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295282393	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9207	1716295282393	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295283395	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295283395	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295283395	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295284398	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295284398	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295284398	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295285400	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295285400	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295285400	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295286402	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295286402	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9236	1716295286402	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295287404	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295287404	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9236	1716295287404	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295288406	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295288406	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9236	1716295288406	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295289408	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295289408	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245	1716295289408	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295290410	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295290410	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245	1716295290410	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295291411	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295291411	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9245	1716295291411	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295292413	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295292413	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295292413	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295293415	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295293415	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295293415	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295294417	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295294417	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9254	1716295294417	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295295418	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295295418	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9228	1716295295418	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295296420	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295296420	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9228	1716295296420	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295314474	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295315478	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295316482	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295317475	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295318483	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295319487	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295320466	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295320466	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267	1716295320466	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295320489	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295321468	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295321468	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267	1716295321468	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295321492	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295322470	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295322470	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295322470	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295322484	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295323473	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295323473	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295323473	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295323496	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295324475	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295324475	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.923	1716295324475	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295324498	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295325477	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295325477	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9243	1716295325477	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295325500	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295326479	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295326479	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9243	1716295326479	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295326496	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295327480	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295327480	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9243	1716295327480	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295327502	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295328482	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295328482	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9257	1716295328482	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295328502	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295329484	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295329484	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9257	1716295329484	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295329507	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295330486	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295330486	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9257	1716295330486	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295330509	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295331488	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295331488	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295331488	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295331503	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295332490	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295332490	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295332490	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295333492	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295333492	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9237	1716295333492	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295334493	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295334493	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295334493	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295335495	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295335495	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295335495	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295336496	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295336496	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295336496	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295337498	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295337498	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295337498	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295338500	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295338500	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295338500	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295339502	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295339502	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295339502	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295340504	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295340504	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9273	1716295340504	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295341506	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295341506	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9273	1716295341506	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295342508	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	6.2	1716295342508	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9273	1716295342508	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295343510	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295343510	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.921	1716295343510	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295344512	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295344512	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.921	1716295344512	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295345514	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295345514	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.921	1716295345514	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295346516	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295346516	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9235	1716295346516	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295347518	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295347518	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9235	1716295347518	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295348520	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295348520	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9235	1716295348520	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295349522	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295349522	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295349522	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295350523	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295350523	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295350523	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295351526	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295351526	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9242000000000001	1716295351526	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295352527	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.800000000000001	1716295352527	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9249	1716295352527	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295353528	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295332512	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295333514	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295334515	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295335516	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295336510	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295337519	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295338523	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295339524	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295340528	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295341520	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295342531	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295343532	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295344527	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295345536	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295346539	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295347533	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295348542	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295349543	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295350546	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295351548	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295352547	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295353543	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295354554	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295355553	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295356555	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.6000000000000005	1716295353528	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9249	1716295353528	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295354531	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295354531	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9249	1716295354531	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295355532	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295355532	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.928	1716295355532	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295356534	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295356534	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.928	1716295356534	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295357536	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295357536	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.928	1716295357536	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295357549	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295358538	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295358538	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295358538	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295358551	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295359539	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295359539	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295359539	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295359562	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295360541	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295360541	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295360541	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295360562	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295361543	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295361543	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295361543	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295361567	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295362545	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295362545	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295362545	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295362559	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295363547	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295363547	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295363547	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295363561	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295364549	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295364549	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295364549	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295364569	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295365550	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295365550	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295365550	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295365575	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	100	1716295366552	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295366552	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9267999999999998	1716295366552	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295366574	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295367554	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295367554	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9252	1716295367554	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295367569	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295368556	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295368556	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9252	1716295368556	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295368575	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295369558	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295369558	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9252	1716295369558	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295369578	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295370560	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295370560	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295370560	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295371563	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295371563	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295371563	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295372565	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295372565	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9272	1716295372565	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295373567	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295373567	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9275	1716295373567	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295374569	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295374569	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9275	1716295374569	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295375571	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295375571	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9275	1716295375571	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295376573	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295376573	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295376573	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295377575	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295377575	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295377575	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295378578	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295378578	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295378578	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295379580	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295379580	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295379580	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295380582	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295380582	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295380582	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295381583	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295381583	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295381583	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295382585	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295382585	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9290999999999998	1716295382585	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295383586	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295383586	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9290999999999998	1716295383586	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295384588	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295384588	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9290999999999998	1716295384588	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295385590	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295385590	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9277	1716295385590	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295386592	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295386592	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9277	1716295386592	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295387594	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295387594	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9277	1716295387594	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295388596	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295388596	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295388596	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295389597	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295389597	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295389597	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295390599	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295390599	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295390599	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295391601	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295391601	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295370585	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295371584	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295372590	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295373580	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295374593	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295375592	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295376586	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295377595	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295378591	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295379601	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295380603	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295381598	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295382606	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295383601	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295384609	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295385613	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295386614	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295387617	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295388610	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295389618	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295390621	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295391622	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295392619	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295393619	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295394629	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295395630	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295396626	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295397626	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295398628	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295399637	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295400641	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295401642	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295402638	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295403639	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295404646	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295405647	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295406650	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295407645	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295408649	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295409648	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295410657	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295411661	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295412656	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295413656	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295414665	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295415669	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295416669	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295391601	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295392603	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295392603	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295392603	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295393605	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295393605	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9256	1716295393605	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295394607	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295394607	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9265999999999999	1716295394607	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295395609	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295395609	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9265999999999999	1716295395609	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295396611	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295396611	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9265999999999999	1716295396611	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295397613	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	8.1	1716295397613	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295397613	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295398614	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295398614	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295398614	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295399616	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295399616	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295399616	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295400618	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295400618	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9269	1716295400618	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295401620	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295401620	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9269	1716295401620	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295402622	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295402622	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9269	1716295402622	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295403624	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295403624	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285999999999999	1716295403624	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295404626	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295404626	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285999999999999	1716295404626	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295405627	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295405627	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285999999999999	1716295405627	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295406629	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295406629	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295406629	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295407631	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295407631	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295407631	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295408633	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295408633	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9283	1716295408633	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295409635	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295409635	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9261	1716295409635	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295410636	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295410636	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9261	1716295410636	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295411638	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295411638	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9261	1716295411638	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295412640	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295412640	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295412640	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295413642	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295413642	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295413642	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295414644	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295414644	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9285	1716295414644	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295415646	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295415646	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.927	1716295415646	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295416648	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295416648	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.927	1716295416648	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295417649	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295417649	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.927	1716295417649	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295417663	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295418653	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295418653	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295418653	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295418666	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295419654	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295419654	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295419654	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295419679	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295420656	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295420656	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295420656	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295420678	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295421658	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295421658	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9289	1716295421658	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295421679	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295422660	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295422660	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9289	1716295422660	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295422674	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295423662	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295423662	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9289	1716295423662	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295423676	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295424664	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295424664	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9304000000000001	1716295424664	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295424685	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295425666	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295425666	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9304000000000001	1716295425666	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295425688	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295426668	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295426668	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9304000000000001	1716295426668	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295426690	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295427670	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295427670	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9314	1716295427670	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295427683	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295428671	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295428671	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9314	1716295428671	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295428685	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295429673	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295429673	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9314	1716295429673	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295429694	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	99	1716295430675	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	2.8	1716295430675	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9305999999999999	1716295430675	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295431676	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295431676	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9305999999999999	1716295431676	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295432678	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295432678	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9305999999999999	1716295432678	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295433681	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295433681	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295433681	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295434682	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295434682	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295434682	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295435684	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295435684	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295435684	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295436686	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295436686	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9287999999999998	1716295436686	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295437688	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295437688	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9287999999999998	1716295437688	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295438690	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295438690	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9287999999999998	1716295438690	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295439692	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295439692	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295439692	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295440694	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295440694	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295440694	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295441697	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295441697	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9292	1716295441697	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	102	1716295442699	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295442699	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295442699	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295443701	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295443701	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295443701	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295444703	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295444703	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9274	1716295444703	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	103	1716295445705	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295445705	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9278	1716295445705	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	101	1716295446706	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	5.9	1716295446706	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9278	1716295446706	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - CPU Utilization	104	1716295447708	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Utilization	7.7	1716295447708	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Memory Usage GB	1.9278	1716295447708	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295430696	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295431689	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295432699	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295433699	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295434706	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295435709	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295436700	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295437713	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295438707	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295439714	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295440715	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295441715	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295442723	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295443722	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295444725	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295445726	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295446720	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
TOP - Swap Memory GB	0.0005	1716295447729	9f31f29ea98e41e5b2c7f01c28e8eb5d	0	f
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
letter	0	90ecdc30935f41059cc57ab853a448f4
workload	0	90ecdc30935f41059cc57ab853a448f4
listeners	smi+top+dcgmi	90ecdc30935f41059cc57ab853a448f4
params	'"-"'	90ecdc30935f41059cc57ab853a448f4
file	cifar10.py	90ecdc30935f41059cc57ab853a448f4
workload_listener	''	90ecdc30935f41059cc57ab853a448f4
letter	0	9f31f29ea98e41e5b2c7f01c28e8eb5d
workload	0	9f31f29ea98e41e5b2c7f01c28e8eb5d
listeners	smi+top+dcgmi	9f31f29ea98e41e5b2c7f01c28e8eb5d
params	'"-"'	9f31f29ea98e41e5b2c7f01c28e8eb5d
file	cifar10.py	9f31f29ea98e41e5b2c7f01c28e8eb5d
workload_listener	''	9f31f29ea98e41e5b2c7f01c28e8eb5d
model	cifar10.py	9f31f29ea98e41e5b2c7f01c28e8eb5d
manual	False	9f31f29ea98e41e5b2c7f01c28e8eb5d
max_epoch	5	9f31f29ea98e41e5b2c7f01c28e8eb5d
max_time	172800	9f31f29ea98e41e5b2c7f01c28e8eb5d
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
90ecdc30935f41059cc57ab853a448f4	omniscient-moose-146	UNKNOWN			daga	FAILED	1716294855915	1716294959294		active	s3://mlflow-storage/0/90ecdc30935f41059cc57ab853a448f4/artifacts	0	\N
9f31f29ea98e41e5b2c7f01c28e8eb5d	(0 0) zealous-slug-351	UNKNOWN			daga	FINISHED	1716294988783	1716295449412		active	s3://mlflow-storage/0/9f31f29ea98e41e5b2c7f01c28e8eb5d/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	90ecdc30935f41059cc57ab853a448f4
mlflow.source.name	file:///home/daga/radt#examples/pytorch	90ecdc30935f41059cc57ab853a448f4
mlflow.source.type	PROJECT	90ecdc30935f41059cc57ab853a448f4
mlflow.project.entryPoint	main	90ecdc30935f41059cc57ab853a448f4
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	90ecdc30935f41059cc57ab853a448f4
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	90ecdc30935f41059cc57ab853a448f4
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	90ecdc30935f41059cc57ab853a448f4
mlflow.runName	omniscient-moose-146	90ecdc30935f41059cc57ab853a448f4
mlflow.project.env	conda	90ecdc30935f41059cc57ab853a448f4
mlflow.project.backend	local	90ecdc30935f41059cc57ab853a448f4
mlflow.user	daga	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.source.name	file:///home/daga/radt#examples/pytorch	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.source.type	PROJECT	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.project.entryPoint	main	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.project.env	conda	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.project.backend	local	9f31f29ea98e41e5b2c7f01c28e8eb5d
mlflow.runName	(0 0) zealous-slug-351	9f31f29ea98e41e5b2c7f01c28e8eb5d
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

