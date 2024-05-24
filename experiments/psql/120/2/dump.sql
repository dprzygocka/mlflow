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
0	Default	s3://mlflow-storage/0	active	1716214731818	1716214731818
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
SMI - Power Draw	15.54	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
SMI - Timestamp	1716215063.807	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
SMI - GPU Util	0	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
SMI - Mem Util	0	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
SMI - Mem Used	0	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
SMI - Performance State	0	1716215063821	0	f	97fe05eab4e0416292aaa559f52e3856
TOP - CPU Utilization	2	1716217724970	0	f	97fe05eab4e0416292aaa559f52e3856
TOP - Memory Usage GB	2.1207	1716217724970	0	f	97fe05eab4e0416292aaa559f52e3856
TOP - Memory Utilization	3	1716217724970	0	f	97fe05eab4e0416292aaa559f52e3856
TOP - Swap Memory GB	0.0005	1716217724991	0	f	97fe05eab4e0416292aaa559f52e3856
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.54	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
SMI - Timestamp	1716215063.807	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
SMI - GPU Util	0	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
SMI - Mem Util	0	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
SMI - Mem Used	0	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
SMI - Performance State	0	1716215063821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	0	1716215063882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	0	1716215063882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.2292	1716215063882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215063896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	153.39999999999998	1716215064884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716215064884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.2292	1716215064884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215064899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215065886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215065886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.2292	1716215065886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215065898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215066888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215066888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4609	1716215066888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215066908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215067890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215067890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4609	1716215067890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215067913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215068891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.4	1716215068891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4609	1716215068891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215068904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215069893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215069893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215069893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215069914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	106	1716215070894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.800000000000001	1716215070894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215070894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215070915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215071896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215071896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215071896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215071918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215072898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215072898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215072898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215072920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215073900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215073900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215073900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215073914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215074902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215074902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215074902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215074924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215075904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215075904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215075904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215075925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215076906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215076906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215076906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215076927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215077908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215077908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215077908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215077930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215078930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215079934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215080936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215081938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215082931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215083942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215084943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215085938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215086949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215087949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215088951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215089953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215090949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215091957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215092959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215093955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215094955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215095968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215096966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215097968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215098972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215099965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215100974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215101983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215102979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215103976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215104982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215105979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215106988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215107992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215108984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215109995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215110995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215111996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215112998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215413547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215413547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215413547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215414549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215414549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215414549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215415551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215415551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215415551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215416553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215416553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215416553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215417555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215417555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9179000000000002	1716215417555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215418556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215418556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9179000000000002	1716215418556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215419558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215419558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9179000000000002	1716215419558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215420560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215420560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215420560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215421562	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215421562	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215421562	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215422564	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215422564	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215078910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215078910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215078910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215079912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215079912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215079912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215080914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215080914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215080914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215081916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215081916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215081916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215082918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215082918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215082918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215083920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215083920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.4607999999999999	1716215083920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215084922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215084922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.764	1716215084922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215085924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215085924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.764	1716215085924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215086926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215086926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.764	1716215086926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215087928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215087928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9785	1716215087928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215088930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.4	1716215088930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9785	1716215088930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215089932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215089932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9785	1716215089932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215090934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215090934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716215090934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215091936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215091936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716215091936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215092938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215092938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716215092938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215093940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215093940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9846	1716215093940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215094942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215094942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9846	1716215094942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215095944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215095944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9846	1716215095944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215096946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215096946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9885	1716215096946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215097948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215097948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9885	1716215097948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215098950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215098950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9885	1716215098950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215099951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215099951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9903	1716215099951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215100953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215100953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9903	1716215100953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215101955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215101955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9903	1716215101955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215102957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215102957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932999999999998	1716215102957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215103959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215103959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932999999999998	1716215103959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215104961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215104961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932999999999998	1716215104961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215105963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215105963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716215105963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215106965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215106965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716215106965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215107967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215107967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716215107967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215108968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215108968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8992	1716215108968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215109970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215109970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8992	1716215109970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215110972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215110972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8992	1716215110972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215111974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215111974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215111974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215112976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215112976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215112976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215113978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215113978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215113978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215114001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215114980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215114980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8996	1716215114980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215115002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215115981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215115981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8996	1716215115981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215116002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215116982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215116982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8996	1716215116982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215117006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215117984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215117984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9005999999999998	1716215117984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215118003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215118986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215118986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9005999999999998	1716215118986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215119007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215120002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215121012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215122013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215123015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215124018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215125018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215126022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215127025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215128016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215129027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215130028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215131031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215132032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215133028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215134036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215135037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215136041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215137044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215138039	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215139045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215140049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215141050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215142052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215143045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215144058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215145058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215146058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215147060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215148065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215149059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215150068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215151071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215152071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215153075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215154070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215155082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215156084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215157081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215158082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215159076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215160080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215161081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215162083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215163093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215164088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215165097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215166099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215167099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215168093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215169098	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215170110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215171110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215172113	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215173110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215413572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215414570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215415565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215416571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215417577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215418571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215419581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215420583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215421584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215422586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716215119988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215119988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9005999999999998	1716215119988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215120990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215120990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9022000000000001	1716215120990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215121992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215121992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9022000000000001	1716215121992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215122994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215122994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9022000000000001	1716215122994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215123996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215123996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215123996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215124998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215124998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215124998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215126000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215126000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215126000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215127002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215127002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215127002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215128004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215128004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215128004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215129005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215129005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215129005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215130007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215130007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8995	1716215130007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215131009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215131009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8995	1716215131009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215132011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215132011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8977	1716215132011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215133013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215133013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8977	1716215133013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215134015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215134015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8977	1716215134015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215135016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215135016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8994000000000002	1716215135016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215136018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215136018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8994000000000002	1716215136018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215137020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215137020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8994000000000002	1716215137020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215138022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215138022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.902	1716215138022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215139024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215139024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.902	1716215139024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215140026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215140026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.902	1716215140026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215141028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215141028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9031	1716215141028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215142030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215142030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9031	1716215142030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215143032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215143032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9031	1716215143032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215144033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215144033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9024	1716215144033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215145036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215145036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9024	1716215145036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215146038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215146038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9024	1716215146038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215147040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215147040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9021	1716215147040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215148042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215148042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9021	1716215148042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215149044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215149044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9021	1716215149044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215150047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215150047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8969	1716215150047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215151048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215151048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8969	1716215151048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215152050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215152050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.8969	1716215152050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215153052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215153052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215153052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215154054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215154054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215154054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215155056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215155056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9009	1716215155056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215156058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215156058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9042000000000001	1716215156058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215157060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215157060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9042000000000001	1716215157060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215158062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215158062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9042000000000001	1716215158062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215159064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215159064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9036	1716215159064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215160065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215160065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9036	1716215160065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215161067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215161067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9036	1716215161067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215162069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215162069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9041	1716215162069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215163071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215163071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9041	1716215163071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215164073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215164073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9041	1716215164073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215165075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215165075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9032	1716215165075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215166077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215166077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9032	1716215166077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215167079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215167079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9032	1716215167079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215168081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215168081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9025	1716215168081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215169083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215169083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9025	1716215169083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215170084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215170084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9025	1716215170084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215171086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215171086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215171086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215172088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215172088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215172088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215173090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215173090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9004	1716215173090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215174091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215174091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9053	1716215174091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215174114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215175092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215175092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9053	1716215175092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215175117	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215176094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215176094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9053	1716215176094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215176117	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215177096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215177096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9071	1716215177096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215177117	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215178098	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215178098	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9071	1716215178098	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215178121	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215179100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215179100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9071	1716215179100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215179114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215180102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215180102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9069	1716215180102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215180115	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215181104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215181104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9069	1716215181104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215182106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215182106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9069	1716215182106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215183108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215183108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9067	1716215183108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215184109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215184109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9067	1716215184109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215185111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716215185111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9067	1716215185111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	109	1716215186112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.7	1716215186112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9075	1716215186112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215187114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215187114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9075	1716215187114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215188116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215188116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9075	1716215188116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215189118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215189118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9059000000000001	1716215189118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215190120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215190120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9059000000000001	1716215190120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215191122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215191122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9059000000000001	1716215191122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215192124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215192124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9027	1716215192124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215193125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215193125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9027	1716215193125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215194127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215194127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9027	1716215194127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215195129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215195129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9065999999999999	1716215195129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215196132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215196132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9065999999999999	1716215196132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215197134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215197134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9065999999999999	1716215197134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215198136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215198136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215198136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215199139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215199139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215199139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215200141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215200141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215200141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215201143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215201143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215201143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215202145	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215202145	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215202145	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215181126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215182120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215183128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215184183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215185133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215186133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215187135	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215188137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215189140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215190141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215191142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215192139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215193148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215194140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215195150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215196156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215197149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215198159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215199154	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215200162	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215201163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215202166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215203170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215204172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215205172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215206173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215207175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215208177	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215209173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215210184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215211183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215212178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215213180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215214184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215215239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215216194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215217196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215218194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215219199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215220197	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215221197	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215222199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215223200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215224207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215225206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215226209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215227209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215228210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215229211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215230214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215231215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215232217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215422564	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215423566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215423566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9199000000000002	1716215423566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215424568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215424568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9199000000000002	1716215424568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215425570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215425570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9199000000000002	1716215425570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215426571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215426571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9204	1716215426571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215203146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215203146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215203146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215204148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215204148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215204148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215205150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215205150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215205150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215206152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215206152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9081	1716215206152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215207155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215207155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9091	1716215207155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215208157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215208157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9091	1716215208157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215209159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215209159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9091	1716215209159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215210161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215210161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9098	1716215210161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215211163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215211163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9098	1716215211163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215212164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215212164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9098	1716215212164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215213166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215213166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9088	1716215213166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215214168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215214168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9088	1716215214168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215215171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215215171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9088	1716215215171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215216173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215216173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9079000000000002	1716215216173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	107	1716215217175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215217175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9079000000000002	1716215217175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215218176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215218176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9079000000000002	1716215218176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215219178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215219178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215219178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215220181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215220181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215220181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215221183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215221183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215221183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215222185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215222185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9074	1716215222185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215223186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215223186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9074	1716215223186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215224189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215224189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9074	1716215224189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215225191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215225191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9095	1716215225191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215226193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215226193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9095	1716215226193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215227194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215227194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9095	1716215227194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215228196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215228196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.908	1716215228196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215229198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215229198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.908	1716215229198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215230200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215230200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.908	1716215230200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215231202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215231202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.91	1716215231202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215232204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215232204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.91	1716215232204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215233205	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215233205	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.91	1716215233205	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215233220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215234207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.199999999999999	1716215234207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9109	1716215234207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215234228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215235209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215235209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9109	1716215235209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215235223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215236211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215236211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9109	1716215236211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215236223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215237212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215237212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.903	1716215237212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215237229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215238214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215238214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.903	1716215238214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215238230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215239216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215239216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.903	1716215239216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215239231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215240218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215240218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9078	1716215240218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215240233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215241220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215241220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9078	1716215241220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215241241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215242222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215242222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9078	1716215242222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215243224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215243224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215243224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215244225	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215244225	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215244225	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215245227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215245227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9085	1716215245227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215246229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215246229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9068	1716215246229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215247231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215247231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9068	1716215247231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215248233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215248233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9068	1716215248233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215249235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215249235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9096	1716215249235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215250237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215250237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9096	1716215250237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215251238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215251238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9096	1716215251238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215252240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215252240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9087	1716215252240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215253242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215253242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9087	1716215253242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215254244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215254244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9087	1716215254244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215255246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215255246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215255246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215256248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215256248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215256248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215257250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215257250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9077	1716215257250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215258251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215258251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9115	1716215258251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215259253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215259253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9115	1716215259253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215260255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215260255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9115	1716215260255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215261257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215261257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9082000000000001	1716215261257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215262259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215262259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9082000000000001	1716215262259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215263261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215263261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9082000000000001	1716215263261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215242236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215243236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215244246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215245248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215246250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215247251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215248247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215249255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215250260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215251259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215252264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215253263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215254258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215255267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215256274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215257263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215258273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215259267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215260277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215261274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215262282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215263277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215264284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215265279	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215266281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215267285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215268285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215269295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215270295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215271299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215272300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215273296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215274306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215275306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215276306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215277313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215278306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215279313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215280314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215281316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215282317	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215283320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215284317	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215285324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215286325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215287331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215288329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215289324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215290333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215291337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215292338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215423580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215424582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215425587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215426586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215427589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215428596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215429589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215430594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215431602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215432606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215433601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215434610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215435610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215436615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215264263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215264263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215264263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215265265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215265265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215265265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215266267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215266267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215266267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215267269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215267269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9097	1716215267269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215268271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215268271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9097	1716215268271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215269273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215269273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9097	1716215269273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215270275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215270275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9113	1716215270275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215271276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215271276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9113	1716215271276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215272278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215272278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9113	1716215272278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215273280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215273280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.914	1716215273280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215274282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215274282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.914	1716215274282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215275284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215275284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.914	1716215275284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215276286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215276286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9119000000000002	1716215276286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215277288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215277288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9119000000000002	1716215277288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215278289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215278289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9119000000000002	1716215278289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215279291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215279291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9145	1716215279291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215280293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215280293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9145	1716215280293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215281295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215281295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9145	1716215281295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215282297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215282297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9142000000000001	1716215282297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215283299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215283299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9142000000000001	1716215283299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215284300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215284300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9142000000000001	1716215284300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215285302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215285302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9167	1716215285302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215286304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215286304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9167	1716215286304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215287306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215287306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9167	1716215287306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215288308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215288308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215288308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215289310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215289310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215289310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215290312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215290312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215290312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215291314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215291314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215291314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215292316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215292316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215292316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215293318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215293318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215293318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215293331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215294320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215294320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.917	1716215294320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215294334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215295322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215295322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.917	1716215295322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215295337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215296324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215296324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.917	1716215296324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215296338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215297326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215297326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9178	1716215297326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215297340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215298328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215298328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9178	1716215298328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215298343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215299329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215299329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9178	1716215299329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215299343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215300331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215300331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9150999999999998	1716215300331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215300345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215301333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215301333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9150999999999998	1716215301333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215301346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215302335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215302335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9150999999999998	1716215302335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215302350	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215303337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215303337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215303337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215304339	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215304339	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215304339	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215305340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215305340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9124	1716215305340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215306342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215306342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215306342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215307344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215307344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215307344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215308346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215308346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215308346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215309348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215309348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215309348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215310350	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215310350	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215310350	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215311352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215311352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9153	1716215311352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215312353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215312353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215312353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215313355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215313355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215313355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215314357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215314357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215314357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215315359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215315359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215315359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215316361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215316361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215316361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215317363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215317363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215317363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215318364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215318364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9158	1716215318364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215319366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215319366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9158	1716215319366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215320368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.199999999999999	1716215320368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9158	1716215320368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215321370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215321370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215321370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215322372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215322372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215322372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215323374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215323374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215323374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215324375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.8	1716215324375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215303349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215304363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215305357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215306356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215307359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215308359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215309363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215310364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215311368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215312368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215313370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215314370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215315373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215316384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215317384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215318385	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215319380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215320389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215321393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215322393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215323395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215324397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215325399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215326401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215327403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215328404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215329406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215330406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215331411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215332411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215333412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215334415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215335417	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215336415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215337425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215338427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215339428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215340428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215341429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215342431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215343434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215344427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215345438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215346440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215347443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215348434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215349440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215350446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215351448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215352450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215427573	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215427573	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9204	1716215427573	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215428575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215428575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9204	1716215428575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215429577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215429577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9209	1716215429577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215430579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215430579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9209	1716215430579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215431581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215431581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9209	1716215431581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215324375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215325378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716215325378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215325378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215326379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215326379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215326379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215327381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215327381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9141	1716215327381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215328382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215328382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9141	1716215328382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215329384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215329384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9141	1716215329384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215330386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215330386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215330386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215331388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215331388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215331388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215332390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215332390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9149	1716215332390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215333392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215333392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.919	1716215333392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215334394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215334394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.919	1716215334394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215335396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215335396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.919	1716215335396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215336399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215336399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.918	1716215336399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215337401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215337401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.918	1716215337401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215338403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215338403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.918	1716215338403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215339405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215339405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215339405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215340406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215340406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215340406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215341408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215341408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9170999999999998	1716215341408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215342410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215342410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215342410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215343412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215343412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215343412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215344414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215344414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215344414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215345416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215345416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9195	1716215345416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215346418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215346418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9195	1716215346418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215347420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215347420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9195	1716215347420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215348421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215348421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9138	1716215348421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215349423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215349423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9138	1716215349423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215350425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215350425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9138	1716215350425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215351426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215351426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215351426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215352428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215352428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215352428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215353430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215353430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9152	1716215353430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215353446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215354432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215354432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215354432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215354445	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215355434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215355434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215355434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215355455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215356436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215356436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9143	1716215356436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215356456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215357438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215357438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215357438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215357458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215358439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215358439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215358439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215358453	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215359441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215359441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9155	1716215359441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215359462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215360443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215360443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215360443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215360464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215361444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215361444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215361444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215361466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215362446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215362446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215362446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215362472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215363448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215363448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9185999999999999	1716215363448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215363462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215364471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215365478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215366475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215367478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215368473	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215369482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215370484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215371485	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215372490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215373484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215374491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215375492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215376494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215377496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215378494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215379494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215380504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215381503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215382505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215383512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215384509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215385513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215386516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215387515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215388519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215389515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215390519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215391522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215392525	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215393519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215394526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215395530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215396535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215397541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215398532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215399542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215400543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215401546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215402549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215403550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215404546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215405555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215406555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215407557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215408556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215409553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215410562	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215411564	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215412568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215432583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215432583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215432583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215433585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215433585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215433585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215434587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215434587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215434587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215435589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215435589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9157	1716215435589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215436591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215436591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9157	1716215436591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215364450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215364450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9185999999999999	1716215364450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215365452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215365452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9185999999999999	1716215365452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215366454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215366454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215366454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215367456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215367456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215367456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215368458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215368458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9184	1716215368458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215369461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215369461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9125	1716215369461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215370463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215370463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9125	1716215370463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215371465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215371465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9125	1716215371465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215372466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215372466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9162000000000001	1716215372466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215373468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215373468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9162000000000001	1716215373468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215374470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215374470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9162000000000001	1716215374470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215375472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215375472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215375472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215376474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215376474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215376474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215377476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215377476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9168	1716215377476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215378478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215378478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215378478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215379479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215379479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215379479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215380481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215380481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9176	1716215380481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215381483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215381483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9175	1716215381483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215382484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215382484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9175	1716215382484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215383486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215383486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9175	1716215383486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215384488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215384488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9210999999999998	1716215384488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215385490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215385490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9210999999999998	1716215385490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215386492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215386492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9210999999999998	1716215386492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215387494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215387494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9193	1716215387494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215388496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215388496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9193	1716215388496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215389498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215389498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9193	1716215389498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215390500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215390500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9129	1716215390500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215391501	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215391501	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9129	1716215391501	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215392503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215392503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9129	1716215392503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215393505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215393505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215393505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215394507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215394507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215394507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215395508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215395508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9172	1716215395508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215396512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215396512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215396512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215397515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215397515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215397515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215398517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215398517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215398517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215399520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215399520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215399520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215400522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215400522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215400522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215401524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215401524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9194	1716215401524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215402526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215402526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.921	1716215402526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215403529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215403529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.921	1716215403529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215404531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215404531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.921	1716215404531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215405533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215405533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9187	1716215405533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215406534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215406534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9187	1716215406534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215407536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215407536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9187	1716215407536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215408538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215408538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215408538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215409540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215409540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215409540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215410542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215410542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215410542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215411543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215411543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215411543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215412545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215412545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215412545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215437592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215437592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9157	1716215437592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215437613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215438594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215438594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.92	1716215438594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215438608	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215439596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215439596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.92	1716215439596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215439617	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215440598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215440598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.92	1716215440598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215440619	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215441600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215441600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215441600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215441622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215442602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215442602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215442602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215442622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215443603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215443603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9177	1716215443603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215443620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215444605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215444605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9207	1716215444605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215444627	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215445607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215445607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9207	1716215445607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215445630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215446609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215446609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9207	1716215446609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215446625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215447611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215447611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9221	1716215447611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215447632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215448613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215448613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9221	1716215448613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215449615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215449615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9221	1716215449615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215450616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215450616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9233	1716215450616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215451618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215451618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9233	1716215451618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215452620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215452620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9233	1716215452620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215453622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215453622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.923	1716215453622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215454624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215454624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.923	1716215454624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215455626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215455626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.923	1716215455626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215456628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215456628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215456628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215457630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215457630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215457630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215458631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215458631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9198	1716215458631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215459633	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215459633	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9238	1716215459633	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215460635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215460635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9238	1716215460635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215461636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215461636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9238	1716215461636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215462638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215462638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215462638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215463640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215463640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215463640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215464642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215464642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215464642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215465644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215465644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215465644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215466645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215466645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215466645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215467647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215467647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9235	1716215467647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215468649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.9	1716215468649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215468649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215469651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6000000000000005	1716215469651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215448629	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215449636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215450637	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215451640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215452641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215453636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215454645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215455649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215456648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215457651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215458653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215459657	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215460658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215461659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215462661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215463655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215464665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215465671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215466666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215467670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215468664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215469671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215470674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215471677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215472678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215833356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215833356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215833356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215834360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215834360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215834360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215835362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215835362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215835362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215836364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215836364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215836364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215837366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215837366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215837366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215838368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215838368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215838368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215839370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215839370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215839370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215840371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215840371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.943	1716215840371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215841373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215841373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.943	1716215841373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215842375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215842375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.943	1716215842375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215843377	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215843377	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215843377	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215844379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215844379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215844379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215845381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215845381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215845381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215846383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215469651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215470652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215470652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215470652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215471654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215471654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247	1716215471654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215472656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215472656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247	1716215472656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215473658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215473658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247	1716215473658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215473672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215474660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215474660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247999999999998	1716215474660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215474682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215475661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215475661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247999999999998	1716215475661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215475682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215476663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215476663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9247999999999998	1716215476663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215476683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215477665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215477665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9208	1716215477665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215477689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716215478667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215478667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9208	1716215478667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215478685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215479668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215479668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9208	1716215479668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215479689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215480670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215480670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215480670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215480687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215481672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215481672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215481672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215481696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215482674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215482674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9241	1716215482674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215482700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215483676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215483676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9234	1716215483676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215483699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215484677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215484677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9234	1716215484677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215484700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215485679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215485679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9234	1716215485679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215485699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215486681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215486681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9237	1716215486681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215487683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215487683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9237	1716215487683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215488685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215488685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9237	1716215488685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215489686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215489686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9244	1716215489686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215490688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215490688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9244	1716215490688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215491689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215491689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9244	1716215491689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215492692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215492692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9242000000000001	1716215492692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215493693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215493693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9242000000000001	1716215493693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215494695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215494695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9242000000000001	1716215494695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215495697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215495697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9263	1716215495697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215496699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215496699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9263	1716215496699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215497701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215497701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9263	1716215497701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215498703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215498703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215498703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215499705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215499705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215499705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215500707	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215500707	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9197	1716215500707	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215501708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215501708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9245999999999999	1716215501708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215502710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215502710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9245999999999999	1716215502710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215503712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215503712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9245999999999999	1716215503712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215504714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215504714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9256	1716215504714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215505718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215505718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9256	1716215505718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215506719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215506719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9256	1716215506719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215507721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215507721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9278	1716215507721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215486702	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215487704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215488706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215489707	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215490711	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215491713	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215492718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215493708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215494716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215495718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215496720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215497721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215498717	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215499718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215500721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215501731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215502732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215503733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215504735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215505739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215506741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215507746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215508737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215509747	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215510745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215511751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215512754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215513749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215514760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215515757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215516757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215517759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215518765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215519771	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215520764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215521774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215522776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215523772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215524778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215525773	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215526778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215527784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215528779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215529788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215530782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215531793	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215532787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215833369	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215834380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215835383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215836386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215837381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215838381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215839391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215840393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215841395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215842398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215843390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215844406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215845403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215846404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215847398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215848404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215849411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215850415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215508723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215508723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9278	1716215508723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215509725	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215509725	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9278	1716215509725	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215510727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215510727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9265999999999999	1716215510727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215511731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215511731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9265999999999999	1716215511731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215512733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215512733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9265999999999999	1716215512733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215513736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215513736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215513736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215514737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215514737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215514737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215515741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215515741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215515741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215516743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215516743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215516743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215517745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215517745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215517745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215518746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215518746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215518746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215519748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215519748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215519748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215520750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215520750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215520750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215521752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215521752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215521752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215522754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215522754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.922	1716215522754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215523756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215523756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.922	1716215523756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215524758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215524758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.922	1716215524758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215525760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215525760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9243	1716215525760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215526761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215526761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9243	1716215526761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215527763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215527763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9243	1716215527763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215528764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215528764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215528764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215529766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215529766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215529766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215530768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215530768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215530768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215531770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215531770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9284000000000001	1716215531770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215532772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215532772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9284000000000001	1716215532772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215533774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215533774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9284000000000001	1716215533774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215533795	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215534776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215534776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215534776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215534793	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215535779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215535779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215535779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215535791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215536781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215536781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215536781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215536802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215537782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215537782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215537782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215537806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215538784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215538784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215538784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215538800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215539786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215539786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.928	1716215539786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215539805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215540788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215540788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9254	1716215540788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215540802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215541790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215541790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9254	1716215541790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215541806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215542792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215542792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9254	1716215542792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215542807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215543794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215543794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9229	1716215543794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215543808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215544796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215544796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9229	1716215544796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215544817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215545798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215545798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9229	1716215545798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215545818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215546800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215546800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215546800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215547801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215547801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215547801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215548803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215548803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9282000000000001	1716215548803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215549805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215549805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9279000000000002	1716215549805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215550807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215550807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9279000000000002	1716215550807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215551809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215551809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9279000000000002	1716215551809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215552811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215552811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9269	1716215552811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215553813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215553813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9269	1716215553813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215554815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215554815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9269	1716215554815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215555817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215555817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215555817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215556819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215556819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215556819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215557820	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215557820	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215557820	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215558822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215558822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215558822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215559824	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215559824	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215559824	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215560826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215560826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215560826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215561828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215561828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215561828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215562830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215562830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215562830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215563832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215563832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215563832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215564834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215564834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9287999999999998	1716215564834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215565835	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215565835	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9287999999999998	1716215565835	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215566837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215566837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9287999999999998	1716215566837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215567839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215567839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215546821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215547825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215548818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215549827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215550832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215551824	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215552826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215553828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215554835	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215555830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215556841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215557843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215558836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215559847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215560850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215561848	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215562844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215563854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215564856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215565857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215566860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215567861	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215568855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215569869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215570869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215571869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215572871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215573865	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215574874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215575875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215576878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215577878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215578881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215579884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215580886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215581886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215582888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215583885	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215584894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215585898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215586899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215587900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215588897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215589903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215590907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215591907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215592909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215846383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215846383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215847384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215847384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215847384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215848386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215848386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215848386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215849389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215849389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215849389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215850391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215850391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215850391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215851393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215851393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215851393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215852395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215567839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215568841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215568841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215568841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215569844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215569844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9267999999999998	1716215569844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215570845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215570845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9302000000000001	1716215570845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215571847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215571847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9302000000000001	1716215571847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215572849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215572849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9302000000000001	1716215572849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215573851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215573851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215573851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215574853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215574853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215574853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215575854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215575854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215575854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215576856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215576856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215576856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215577858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215577858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215577858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215578860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215578860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215578860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215579862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215579862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215579862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215580864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215580864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215580864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215581866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215581866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215581866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215582868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215582868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215582868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215583869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215583869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215583869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215584871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215584871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215584871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215585875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215585875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.93	1716215585875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215586877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215586877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.93	1716215586877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215587879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215587879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.93	1716215587879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215588880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215588880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215588880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215589882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215589882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215589882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215590884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215590884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9249	1716215590884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215591886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215591886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9262000000000001	1716215591886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215592888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215592888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9262000000000001	1716215592888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215593890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215593890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9262000000000001	1716215593890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215593914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215594892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215594892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9309	1716215594892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215594912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215595893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215595893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9309	1716215595893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215595915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215596895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215596895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9309	1716215596895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215596916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215597897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215597897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215597897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215597910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215598899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6	1716215598899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215598899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215598913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215599901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716215599901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9313	1716215599901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215599915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215600903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215600903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215600903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215600925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215601905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215601905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215601905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215601921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215602907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215602907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9317	1716215602907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215602931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215603909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215603909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9329	1716215603909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215603922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215604910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215604910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9329	1716215604910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215604933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215605912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215605912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9329	1716215605912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215605934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215606914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215606914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9325	1716215606914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215607916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215607916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9325	1716215607916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215608918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215608918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9325	1716215608918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215609920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215609920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215609920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215610921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215610921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215610921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215611922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215611922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215611922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215612924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215612924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215612924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215613926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215613926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215613926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215614928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215614928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9293	1716215614928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215615930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215615930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215615930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215616931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215616931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215616931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215617932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215617932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9296	1716215617932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215618934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215618934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215618934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215619936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215619936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215619936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215620938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215620938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215620938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215621940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215621940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215621940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215622942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215622942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215622942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215623943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215623943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9298	1716215623943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215624946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215624946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307999999999998	1716215624946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215625949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215625949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307999999999998	1716215625949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215626951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215626951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307999999999998	1716215626951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215627953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215606934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215607939	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215608938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215609940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215610947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215611945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215612948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215613944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215614950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215615955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215616953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215617947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215618958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215619957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215620960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215621962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215622956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215623958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215624970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215625971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215626966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215627978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215628983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215629979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215630981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215631978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215632984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215633979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215634988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215635990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215636992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215637993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215638991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215639996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215641000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215642002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215643003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215643996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215645005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215646007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215647001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215648010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215649007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215650014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215651016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215652019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215653022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215654024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215655025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215656030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215657029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215658034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215659035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215660035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215661042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215662033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215663043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215664042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215665047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215666045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215667047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215668045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215669053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215670058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215671055	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215627953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215627953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215628955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215628955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215628955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215629957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215629957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215629957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215630959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215630959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215630959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215631961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215631961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215631961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215632963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215632963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9315	1716215632963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215633965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215633965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215633965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215634966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215634966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215634966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215635968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215635968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9307	1716215635968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215636970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215636970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215636970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215637972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215637972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215637972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215638974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215638974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215638974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215639976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215639976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9343	1716215639976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215640977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215640977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9343	1716215640977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215641979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215641979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9343	1716215641979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215642981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215642981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9350999999999998	1716215642981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215643983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215643983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9350999999999998	1716215643983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215644984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215644984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9350999999999998	1716215644984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215645986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215645986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9338	1716215645986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215646988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215646988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9338	1716215646988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215647990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215647990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9338	1716215647990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215648992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215648992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9356	1716215648992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215649994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215649994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9356	1716215649994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215650996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215650996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9356	1716215650996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215651998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215651998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9355	1716215651998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215653000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215653000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9355	1716215653000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215654003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215654003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9355	1716215654003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215655005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215655005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215655005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215656006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215656006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215656006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215657008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215657008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9316	1716215657008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215658010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215658010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9332	1716215658010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215659012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215659012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9332	1716215659012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215660014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215660014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215660014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215661016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215661016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215661016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215662017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215662017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215662017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215663019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215663019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215663019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215664021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215664021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215664021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215665023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215665023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215665023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215666025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215666025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9322000000000001	1716215666025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215667026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215667026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9322000000000001	1716215667026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215668028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215668028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9322000000000001	1716215668028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215669030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215669030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215669030	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215670032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215670032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215670032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215671034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215671034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215671034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215672036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215672036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215672036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215673038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215673038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215673038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215674040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215674040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9335	1716215674040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215675041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215675041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215675041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215676043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215676043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215676043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215677045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215677045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9341	1716215677045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215678046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215678046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9337	1716215678046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215679048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215679048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9337	1716215679048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215680050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215680050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9337	1716215680050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215681052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215681052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9353	1716215681052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215682054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215682054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9353	1716215682054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215683056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716215683056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9353	1716215683056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215684058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215684058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9397	1716215684058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215685059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215685059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9397	1716215685059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215686061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215686061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9397	1716215686061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215687063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215687063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9385	1716215687063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215688065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215688065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9385	1716215688065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215689066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215689066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9385	1716215689066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215690068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215690068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215690068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215691070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215691070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215691070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215692072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215672057	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215673058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215674053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215675062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215676065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215677062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215678068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215679062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215680073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215681074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215682076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215683078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215684079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215685082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215686082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215687084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215688087	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215689081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215690090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215691095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215692086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215693095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215694089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215695099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215696094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215697102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215698104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215699106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215700110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215701112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215702111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215703113	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215704108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215705119	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215706122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215707123	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215708125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215709118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215710130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215711128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215712134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215713127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215851415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215852417	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215853413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215854424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215855421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215856425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215857427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215858422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215859431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215860433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215861434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215862431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215863435	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215864418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215864440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215865420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215865420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215865420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215865440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215866422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.399999999999999	1716215866422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215866422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215866442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215692072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215692072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215693074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215693074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215693074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215694076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215694076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215694076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215695077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215695077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215695077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215696079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215696079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9382000000000001	1716215696079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215697081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215697081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9382000000000001	1716215697081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215698083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215698083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9382000000000001	1716215698083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215699085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215699085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9358	1716215699085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215700086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215700086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9358	1716215700086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215701088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215701088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9358	1716215701088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215702090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215702090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215702090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215703092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215703092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215703092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215704094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215704094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215704094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215705097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215705097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215705097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215706099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215706099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215706099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215707100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215707100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215707100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215708102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215708102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215708102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215709104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215709104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215709104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215710106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215710106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215710106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215711108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215711108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215711108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215712110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215712110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215712110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215713112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215713112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215713112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215714114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215714114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9407999999999999	1716215714114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215714137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215715116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215715116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9407999999999999	1716215715116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215715130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215716118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215716118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9407999999999999	1716215716118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215716139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215717120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215717120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215717120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215717142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215718122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.8	1716215718122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215718122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215718137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215719125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.1	1716215719125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215719125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215719149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215720126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215720126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9361	1716215720126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215720148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215721128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215721128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9361	1716215721128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215721151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215722130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215722130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9361	1716215722130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215722152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215723132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215723132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9376	1716215723132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215723146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215724134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215724134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9376	1716215724134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215724155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215725136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215725136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9376	1716215725136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215725157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215726138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215726138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215726138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215726158	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215727141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215727141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215727141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215727165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215728144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215728144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9422000000000001	1716215728144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215728161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215729146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215729146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.941	1716215729146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215729166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215730168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215731172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215732173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215733170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215734178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215735181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215736180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215737182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215738178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215739191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215740191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215741191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215742195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215743195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215744197	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215745192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215746201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215747202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215748205	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215749199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215750211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215751212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215752214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215753215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215754209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215755220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215756225	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215757225	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215758227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215759228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215760231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215761234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215762233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215763236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215764230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215765239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215766242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215767244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215768245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215769240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215770252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215771252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215772254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215773258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215774259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215775260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215776263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215777265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215778269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215779264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215780271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215781275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215782275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215783270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215784273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215785281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215786283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215787284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215788287	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215789289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215790290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215791292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215792294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215793299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215730147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215730147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.941	1716215730147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215731149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215731149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.941	1716215731149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215732151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215732151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427	1716215732151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215733153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215733153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427	1716215733153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215734155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215734155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427	1716215734155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215735157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215735157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215735157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215736159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215736159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215736159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215737161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215737161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215737161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215738164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215738164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215738164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215739166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215739166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215739166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215740169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215740169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215740169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215741171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215741171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9333	1716215741171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215742173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215742173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9333	1716215742173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215743174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215743174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9333	1716215743174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215744176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215744176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9349	1716215744176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215745178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215745178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9349	1716215745178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215746180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215746180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9349	1716215746180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215747182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215747182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9345	1716215747182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215748184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215748184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9345	1716215748184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215749186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215749186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9345	1716215749186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215750188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215750188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215750188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215751190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215751190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215751190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215752192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215752192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215752192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215753194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215753194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9389	1716215753194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215754195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215754195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9389	1716215754195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215755199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215755199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9389	1716215755199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215756202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215756202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9404000000000001	1716215756202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215757204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215757204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9404000000000001	1716215757204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215758206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215758206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9404000000000001	1716215758206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215759207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215759207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215759207	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215760209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215760209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215760209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215761211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215761211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215761211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215762213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215762213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215762213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215763215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215763215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215763215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215764217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215764217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215764217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215765219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215765219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215765219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215766221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215766221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215766221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215767223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215767223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215767223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215768224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215768224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215768224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215769226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215769226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215769226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215770229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215770229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9395	1716215770229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215771231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215771231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9405	1716215771231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215772233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215772233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9405	1716215772233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215773236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215773236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9405	1716215773236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215774238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716215774238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215774238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215775240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215775240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215775240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215776242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215776242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9402000000000001	1716215776242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215777244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215777244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.942	1716215777244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215778247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215778247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.942	1716215778247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215779249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215779249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.942	1716215779249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215780251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215780251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215780251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215781252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215781252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215781252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215782254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215782254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215782254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215783256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215783256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9365	1716215783256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215784258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215784258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9365	1716215784258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215785260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215785260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9365	1716215785260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215786262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215786262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9357	1716215786262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215787263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215787263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9357	1716215787263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215788265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215788265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9357	1716215788265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215789267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215789267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367999999999999	1716215789267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215790269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215790269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367999999999999	1716215790269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215791271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215791271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367999999999999	1716215791271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215792273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215792273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215792273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215793276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215793276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215793276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215794278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215794278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9398	1716215794278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215795281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215795281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215795281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215796283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215796283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215796283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215797285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215797285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9396	1716215797285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215798287	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215798287	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215798287	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215799289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215799289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215799289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215800292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215800292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9401	1716215800292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215801294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215801294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215801294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215802296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215802296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215802296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215803298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215803298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9387999999999999	1716215803298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215804299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215804299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215804299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215805301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215805301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215805301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215806303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215806303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215806303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215807305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215807305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367	1716215807305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215808309	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215808309	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367	1716215808309	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215809311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215809311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9367	1716215809311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215810313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215810313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215810313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215811314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215811314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215811314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215812316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215812316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9421	1716215812316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215813318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215813318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215813318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215814320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215814320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215814320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215815322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215794295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215795302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215796304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215797306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215798300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215799312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215800315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215801314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215802316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215803319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215804321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215805326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215806325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215807330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215808323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215809331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215810333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215811335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215812337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215813332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215814341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215815343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215816345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215817346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215818341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215819344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215820353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215821357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215822358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215823353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215824361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215825363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215826365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215827358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215828362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215829371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215830373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215831374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215832374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215852395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9393	1716215852395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215853397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215853397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9393	1716215853397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215854399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215854399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9393	1716215854399	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215855401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215855401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215855401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215856403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215856403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215856403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215857405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215857405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9409	1716215857405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215858407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215858407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9412	1716215858407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215859409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215859409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9412	1716215859409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215860411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215860411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9412	1716215860411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215815322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9418	1716215815322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215816323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215816323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9433	1716215816323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215817325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215817325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9433	1716215817325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215818327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215818327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9433	1716215818327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215819329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215819329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9439000000000002	1716215819329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215820331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215820331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9439000000000002	1716215820331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215821333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215821333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9439000000000002	1716215821333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215822334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215822334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215822334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215823338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215823338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215823338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215824340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215824340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215824340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215825341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215825341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.944	1716215825341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215826343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215826343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.944	1716215826343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215827345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215827345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.944	1716215827345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215828347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215828347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9377	1716215828347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215829349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215829349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9377	1716215829349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215830351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.2	1716215830351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9377	1716215830351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215831353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215831353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215831353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215832354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716215832354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215832354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215861412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215861412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215861412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215862414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215862414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215862414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215863416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215863416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9417	1716215863416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215864418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215864418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215867424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215867424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215867424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215868425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215868425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215868425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215869427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215869427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215869427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215870429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215870429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9452	1716215870429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215871431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215871431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9452	1716215871431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215872433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215872433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9452	1716215872433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215873436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215873436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215873436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215874438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215874438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215874438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215875441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215875441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9427999999999999	1716215875441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215876442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215876442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9373	1716215876442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215877444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215877444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9373	1716215877444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215878446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215878446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9373	1716215878446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716215879448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3.3	1716215879448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9372	1716215879448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215880450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215880450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9372	1716215880450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215881452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215881452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9372	1716215881452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215882454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215882454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215882454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215883456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215883456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215883456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215884457	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215884457	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9410999999999998	1716215884457	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215885459	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215885459	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215885459	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215886461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215886461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215886461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716215887463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215887463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9394	1716215887463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215888465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215867445	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215868441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215869449	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215870450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215871452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215872458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215873452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215874462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215875462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215876464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215877465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215878460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215879462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215880473	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215881475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215882475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215883480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215884472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215885481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215886482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215887486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215888478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215889480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215890492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215891494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215892487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215893488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215894498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215895492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215896503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215897505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215898497	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215899507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215900502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215901514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215902514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215903510	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215904517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215905521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215906521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215907523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215908523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215909527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215910528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215911528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215912530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215913527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215914534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215915538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215916540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215917542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215918535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215919544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215920545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215921547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215922549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215923551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215924554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215925557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215926559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215927557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215928563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215929562	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215930557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215931566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215888465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215888465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215889467	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215889467	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215889467	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215890469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215890469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9436	1716215890469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215891471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215891471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215891471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215892472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215892472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215892472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215893474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215893474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9445999999999999	1716215893474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215894476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215894476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215894476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215895478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215895478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215895478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215896480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215896480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215896480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215897482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215897482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9435	1716215897482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215898484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215898484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9435	1716215898484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215899486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215899486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9435	1716215899486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215900488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215900488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9437	1716215900488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215901489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215901489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9437	1716215901489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215902491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215902491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9437	1716215902491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215903493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215903493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.945	1716215903493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215904495	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215904495	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.945	1716215904495	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215905497	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215905497	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.945	1716215905497	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215906499	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215906499	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9485	1716215906499	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215907500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215907500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9485	1716215907500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215908502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215908502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9485	1716215908502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215909504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215909504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215909504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215910506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215910506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215910506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215911508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215911508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215911508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215912510	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215912510	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9489	1716215912510	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215913511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215913511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9489	1716215913511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215914513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215914513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9489	1716215914513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215915516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215915516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215915516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215916518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215916518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215916518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215917520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215917520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215917520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215918521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215918521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9509	1716215918521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215919523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215919523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9509	1716215919523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215920524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215920524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9509	1716215920524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215921526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215921526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9482000000000002	1716215921526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215922528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215922528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9482000000000002	1716215922528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215923530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215923530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9482000000000002	1716215923530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215924532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215924532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9484000000000001	1716215924532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215925534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215925534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9484000000000001	1716215925534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215926536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215926536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9484000000000001	1716215926536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215927537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215927537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9472	1716215927537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215928539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215928539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9472	1716215928539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215929541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215929541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9472	1716215929541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215930543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215930543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9499000000000002	1716215930543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215931545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215931545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9499000000000002	1716215931545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215932547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215932547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9499000000000002	1716215932547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215933549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215933549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9474	1716215933549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215934551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215934551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9474	1716215934551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215935552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215935552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9474	1716215935552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215936554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215936554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9501	1716215936554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215937556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215937556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9501	1716215937556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215938558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215938558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9501	1716215938558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215939560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215939560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215939560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215940561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215940561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215940561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215941563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215941563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215941563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215942565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215942565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215942565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215943566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215943566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215943566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215944568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215944568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9442000000000002	1716215944568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215945570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215945570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215945570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215946572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215946572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215946572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215947574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215947574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215947574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215948576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215948576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215948576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215949578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215949578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215949578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215950580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215950580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9487999999999999	1716215950580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215951581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215951581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215951581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215952583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215932569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215933569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215934571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215935574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215936575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215937579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215938574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215939580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215940576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215941577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215942587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215943589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215944583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215945593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215946588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215947588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215948590	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215949594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215950606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215951602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215952603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216314275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216314275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216314275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216315278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216315278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216315278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216316280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216316280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216316280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216317282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216317282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216317282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216318284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216318284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216318284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216319286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216319286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216319286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216320288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216320288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216320288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216321290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216321290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216321290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216322291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216322291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216322291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216323293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216323293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216323293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216324294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216324294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216324294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216325296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216325296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216325296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216326298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216326298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9704000000000002	1716216326298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216327300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216327300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9704000000000002	1716216327300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216328302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716215952583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215952583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215953585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215953585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215953585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215953599	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215954587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215954587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9475	1716215954587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215954611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215955589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215955589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9475	1716215955589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215955609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215956592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215956592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9475	1716215956592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215956614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215957594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215957594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215957594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215957617	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215958596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215958596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215958596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215958618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215959598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215959598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.949	1716215959598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215959612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215960601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215960601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215960601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215960615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215961603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215961603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215961603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215961626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215962605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215962605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9496	1716215962605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215962627	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215963606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215963606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215963606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215963627	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215964608	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215964608	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215964608	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215964624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215965610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215965610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9476	1716215965610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215965631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215966613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215966613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9507999999999999	1716215966613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215966636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215967614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215967614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9507999999999999	1716215967614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215967631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215968616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215968616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9507999999999999	1716215968616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215969618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215969618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716215969618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215970620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215970620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716215970620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215971622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215971622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716215971622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215972624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215972624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9538	1716215972624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215973626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.3	1716215973626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9538	1716215973626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215974628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716215974628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9538	1716215974628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716215975630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215975630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9552	1716215975630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215976631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215976631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9552	1716215976631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215977632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215977632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9552	1716215977632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215978634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215978634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9527999999999999	1716215978634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215979636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215979636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9527999999999999	1716215979636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215980638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215980638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9527999999999999	1716215980638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215981640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215981640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215981640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215982641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215982641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215982641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215983643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215983643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215983643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215984645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215984645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215984645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215985646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215985646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215985646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215986648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215986648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9458	1716215986648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215987651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215987651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9536	1716215987651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215988653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215988653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9536	1716215988653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215989655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215989655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9536	1716215989655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215968632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215969641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215970643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215971649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215972645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215973639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215974650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215975649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215976651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215977653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215978652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215979651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215980659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215981661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215982662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215983667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215984666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215985669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215986673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215987677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215988669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215989675	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215990677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215991680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215992683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215993676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215994687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215995687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215996691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215997693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215998696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716215999695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216000696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216001697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216002699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216003694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216004704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216005704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216006706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216007710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216008707	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216009706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216010715	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216011715	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216012718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216013712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216014723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216015726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216016725	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216017723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216018722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216019735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216020737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216021735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216022738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216023732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216024742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216025745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216026748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216027748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216028750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216029753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216030758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216031758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216032763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215990656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215990656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215990656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215991658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215991658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215991658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215992660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215992660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9545	1716215992660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215993662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215993662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716215993662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215994664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215994664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716215994664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215995666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215995666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716215995666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716215996668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215996668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9530999999999998	1716215996668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716215997669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215997669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9530999999999998	1716215997669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716215998671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716215998671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9530999999999998	1716215998671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716215999672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716215999672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9533	1716215999672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216000674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216000674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9533	1716216000674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216001676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216001676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9533	1716216001676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216002678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216002678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9547999999999999	1716216002678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216003680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216003680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9547999999999999	1716216003680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216004682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216004682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9547999999999999	1716216004682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216005684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216005684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216005684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216006686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216006686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216006686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216007688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216007688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216007688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216008689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216008689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9505	1716216008689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216009691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216009691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9505	1716216009691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216010693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216010693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9505	1716216010693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216011695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216011695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9498	1716216011695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216012697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216012697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9498	1716216012697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216013699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216013699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9498	1716216013699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216014701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216014701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.953	1716216014701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216015703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216015703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.953	1716216015703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216016704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216016704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.953	1716216016704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216017706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216017706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9554	1716216017706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216018708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216018708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9554	1716216018708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216019710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216019710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9554	1716216019710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216020712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216020712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216020712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216021714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216021714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216021714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216022716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216022716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216022716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216023718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216023718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.957	1716216023718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216024719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216024719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.957	1716216024719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216025724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216025724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.957	1716216025724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216026726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216026726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216026726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216027727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.1	1716216027727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216027727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216028729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216028729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216028729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216029732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216029732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9512	1716216029732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216030734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216030734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9512	1716216030734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216031736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216031736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9512	1716216031736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216032738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216032738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216032738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216033740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216033740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216033740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216034742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216034742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216034742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216035744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216035744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216035744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216036746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216036746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216036746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216037750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216037750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9542	1716216037750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216038752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216038752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216038752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216039753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216039753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216039753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216040755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216040755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216040755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216041757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216041757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9558	1716216041757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216042759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216042759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9558	1716216042759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216043761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216043761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9558	1716216043761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216044763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216044763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216044763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216045764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216045764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216045764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216046766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216046766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216046766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216047768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216047768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216047768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216048770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216048770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216048770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216049772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216049772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216049772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216050774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216050774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216050774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216051776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216051776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216051776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216052778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216052778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216052778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216053780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216053780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216053780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216033757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216034764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216035765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216036768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216037770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216038766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216039774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216040778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216041779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216042780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216043782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216044783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216045780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216046788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216047790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216048784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216049793	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216050795	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216051801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216052800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216053793	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216054802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216055805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216056809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216057810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216058812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216059813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216060814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216061821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216062817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216063812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216064821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216065823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216066828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216067829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216068822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216069830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216070833	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216071834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216072838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216314299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216315300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216316302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216317304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216318305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216319302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216320313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216321312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216322315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216323320	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216324308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216325319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216326318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216327321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216328315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216329327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216330329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216331332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216332330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216333325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216334335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216335336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216336339	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216337340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216338335	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216054781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216054781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216054781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216055783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216055783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216055783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216056786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216056786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216056786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216057788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216057788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216057788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216058790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216058790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9546	1716216058790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216059791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216059791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216059791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216060792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216060792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216060792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216061794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216061794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216061794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216062796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216062796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9573	1716216062796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216063798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216063798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9573	1716216063798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216064800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216064800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9573	1716216064800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216065802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216065802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9576	1716216065802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216066804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.1	1716216066804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9576	1716216066804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216067806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216067806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9576	1716216067806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216068807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216068807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9563	1716216068807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216069809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216069809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9563	1716216069809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216070811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216070811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9563	1716216070811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216071813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216071813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216071813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216072815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216072815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216072815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216073817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216073817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216073817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216073838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216074819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216074819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716216074819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216074842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216075842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216076844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216077847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216078841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216079849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216080852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216081854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216082855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216083852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216084860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216085865	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216086863	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216087873	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216088866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216089868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216090873	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216091873	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216092875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216093869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216094881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216095880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216096884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216097883	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216098882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216099889	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216100883	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216101894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216102891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216103898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216104898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216105901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216106894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216107895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216108898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216109909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216110910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216111905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216112909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216113910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216114919	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216115914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216116916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216117917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216118929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216119921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216120932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216121924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216122928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216123938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216124937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216125941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216126933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216127936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216128945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216129948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216130941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216131943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216132944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216133948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216134958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216135958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216136960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216137954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216138964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216075821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216075821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716216075821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216076823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216076823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9535	1716216076823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216077825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216077825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9525	1716216077825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216078827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216078827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9525	1716216078827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216079828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216079828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9525	1716216079828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216080830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216080830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9523	1716216080830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216081832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216081832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9523	1716216081832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216082834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216082834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9523	1716216082834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216083836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216083836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216083836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216084838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216084838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216084838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216085840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216085840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9550999999999998	1716216085840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216086841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216086841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216086841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716216087843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216087843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216087843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216088845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216088845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216088845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216089847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216089847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216089847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216090849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216090849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216090849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216091851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216091851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9566	1716216091851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216092853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216092853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9583	1716216092853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216093855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216093855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9583	1716216093855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216094857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216094857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9583	1716216094857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216095858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216095858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9567999999999999	1716216095858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216096860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216096860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9567999999999999	1716216096860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216097862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216097862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9567999999999999	1716216097862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216098864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216098864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216098864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216099866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216099866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216099866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216100869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216100869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9562	1716216100869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216101870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216101870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216101870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216102872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216102872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216102872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216103875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216103875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9556	1716216103875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216104877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216104877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9561	1716216104877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216105879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216105879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9561	1716216105879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216106880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216106880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9561	1716216106880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216107882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216107882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9572	1716216107882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216108884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216108884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9572	1716216108884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216109887	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216109887	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9572	1716216109887	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216110889	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216110889	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216110889	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216111892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216111892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216111892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216112894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216112894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216112894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216113896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216113896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587	1716216113896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216114898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216114898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587	1716216114898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216115900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216115900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587	1716216115900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216116902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216116902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216116902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216117904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216117904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216117904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216118906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216118906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216118906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216119908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216119908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216119908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216120910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216120910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216120910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216121911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216121911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.955	1716216121911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216122913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216122913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216122913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216123915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216123915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216123915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216124916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216124916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9575	1716216124916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216125918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216125918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216125918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216126920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216126920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216126920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216127922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216127922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216127922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216128924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216128924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9577	1716216128924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216129926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216129926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9577	1716216129926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216130928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216130928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9577	1716216130928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216131929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216131929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9569	1716216131929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216132931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216132931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9569	1716216132931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216133933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.1	1716216133933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9569	1716216133933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216134935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.4	1716216134935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216134935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216135937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216135937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216135937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216136939	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216136939	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9599000000000002	1716216136939	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216137941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216137941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216137941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216138943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216138943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216138943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216139945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216139945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9584000000000001	1716216139945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216140946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216140946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216140946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216141948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216141948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216141948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216142950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216142950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216142950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216143954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216143954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9541	1716216143954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216144955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216144955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9541	1716216144955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216145957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216145957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9541	1716216145957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216146959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216146959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216146959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216147961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216147961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216147961	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216148963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216148963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216148963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216149965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216149965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216149965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216150967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216150967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216150967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216151969	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216151969	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216151969	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216152971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216152971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216152971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216153972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216153972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216153972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216154974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216154974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216154974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216155976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216155976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216155976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216156978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216156978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216156978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216157980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216157980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216157980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216158982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216158982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216158982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216159984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216159984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216159984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216160985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216139968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216140969	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216141964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216142964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216143975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216144978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216145973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216146975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216147975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216148977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216149980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216150988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216151983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216152993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216153990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216154999	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216155989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216156995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216158001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216158997	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216160005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216161006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216162001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216163003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216164013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216165013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216166016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216167010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216168019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216169014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216170024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216171026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216172020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216173028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216174025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216175032	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216176035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216177027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216178037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216179040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216180041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216181044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216182038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216183046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216184042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216185047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216186045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216187048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216188060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216189054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216190059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216191066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216192057	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216193068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216328302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9704000000000002	1716216328302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216329304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216329304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9707000000000001	1716216329304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216330306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216330306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9707000000000001	1716216330306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216331308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216331308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9707000000000001	1716216331308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216160985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9592	1716216160985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216161987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216161987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216161987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216162989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216162989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216162989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216163991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216163991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9587999999999999	1716216163991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216164993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216164993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216164993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216165995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216165995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216165995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216166997	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216166997	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216166997	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216167999	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216167999	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216167999	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216169001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216169001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216169001	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216170002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216170002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9585	1716216170002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216171004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216171004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216171004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216172006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216172006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216172006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216173008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216173008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216173008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216174010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216174010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9595	1716216174010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216175011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216175011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9595	1716216175011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216176013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216176013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9589	1716216176013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216177014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216177014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9589	1716216177014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216178016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216178016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9589	1716216178016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216179018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216179018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9596	1716216179018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216180020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216180020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9596	1716216180020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216181022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216181022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9596	1716216181022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216182024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216182024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216182024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216183026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216183026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216183026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216184027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216184027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216184027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216185029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216185029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216185029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216186031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216186031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216186031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216187033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216187033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.961	1716216187033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216188035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216188035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9598	1716216188035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216189037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216189037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9598	1716216189037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216190039	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216190039	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9598	1716216190039	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216191041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216191041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216191041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216192043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216192043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216192043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216193046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216193046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9579000000000002	1716216193046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216194047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216194047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216194047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216194069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216195049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216195049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216195049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216195072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216196051	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216196051	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9593	1716216196051	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216196072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216197053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216197053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9602	1716216197053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216197068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216198054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216198054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9602	1716216198054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216198076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216199056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216199056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9602	1716216199056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216199070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216200058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216200058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216200058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216200079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216201060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216201060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216201060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216202062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216202062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607	1716216202062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216203064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216203064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9616	1716216203064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216204066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216204066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9616	1716216204066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216205067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216205067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9616	1716216205067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216206069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216206069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607999999999999	1716216206069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216207071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216207071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607999999999999	1716216207071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216208072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216208072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9607999999999999	1716216208072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216209074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216209074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9619000000000002	1716216209074	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216210076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216210076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9619000000000002	1716216210076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216211078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216211078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9619000000000002	1716216211078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216212080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216212080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216212080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216213082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216213082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216213082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216214084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216214084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9578	1716216214084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216215086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216215086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9610999999999998	1716216215086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216216089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216216089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9610999999999998	1716216216089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216217091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216217091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9610999999999998	1716216217091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216218093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216218093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9634	1716216218093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216219095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216219095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9634	1716216219095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216220097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216220097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9634	1716216220097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216221099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216221099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9622	1716216221099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216222101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216222101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9622	1716216222101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216201081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216202076	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216203087	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216204079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216205088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216206093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216207085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216208093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216209088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216210102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216211099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216212093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216213103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216214099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216215108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216216110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216217103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216218106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216219109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216220120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216221121	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216222118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216223117	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216224125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216225132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216226130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216227126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216228133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216229129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216230139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216231140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216232133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216233135	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216234145	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216235148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216236149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216237143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216238146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216239156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216240157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216241159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216242157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216243165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216244161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216245168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216246168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216247163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216248164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216249166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216250175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216251181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216252175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216253183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216254187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216255189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216256193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216257184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216258191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216259186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216260197	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216261199	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216262200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216263196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216264201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216265211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216223102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216223102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9622	1716216223102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216224104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216224104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9617	1716216224104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216225106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216225106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9617	1716216225106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216226108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216226108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9617	1716216226108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216227110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216227110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216227110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216228112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216228112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216228112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216229114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216229114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216229114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216230116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216230116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9658	1716216230116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216231118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216231118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9658	1716216231118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216232120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216232120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9658	1716216232120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216233122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216233122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216233122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216234124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216234124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216234124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216235126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216235126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9597	1716216235126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216236128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216236128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9627000000000001	1716216236128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216237129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216237129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9627000000000001	1716216237129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216238131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216238131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9627000000000001	1716216238131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216239134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216239134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9638	1716216239134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216240136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216240136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9638	1716216240136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216241138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216241138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9638	1716216241138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216242140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216242140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9642	1716216242140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216243142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216243142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9642	1716216243142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216244144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216244144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9642	1716216244144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216245146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.2	1716216245146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9635	1716216245146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216246147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.5	1716216246147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9635	1716216246147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216247149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216247149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9635	1716216247149	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216248151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216248151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9613	1716216248151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216249153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216249153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9613	1716216249153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216250154	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216250154	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9613	1716216250154	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216251156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216251156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.963	1716216251156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216252158	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216252158	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.963	1716216252158	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216253160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216253160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.963	1716216253160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216254163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216254163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216254163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216255165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216255165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216255165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216256167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216256167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.965	1716216256167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216257169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216257169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9614	1716216257169	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216258171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216258171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9614	1716216258171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216259173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216259173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9614	1716216259173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216260175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216260175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9644000000000001	1716216260175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216261176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216261176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9644000000000001	1716216261176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216262178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216262178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9644000000000001	1716216262178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216263180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216263180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9665	1716216263180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216264183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216264183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9665	1716216264183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216265185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216265185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9665	1716216265185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216266187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216266187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216266187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216267189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216267189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216267189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216268190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216268190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216268190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	106	1716216269192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216269192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216269192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216270194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216270194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216270194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216271196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216271196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9662	1716216271196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216272198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216272198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9682	1716216272198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216273200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216273200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9682	1716216273200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216274201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216274201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9682	1716216274201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216275203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216275203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9696	1716216275203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216276204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216276204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9696	1716216276204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216277206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216277206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9696	1716216277206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216278208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216278208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9672	1716216278208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216279210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216279210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9672	1716216279210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216280212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216280212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9672	1716216280212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216281214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216281214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216281214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216282216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216282216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216282216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216283218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216283218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216283218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216284220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216284220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9694	1716216284220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216285222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216285222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9694	1716216285222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216286224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216286224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9694	1716216286224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216266213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216267213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216268217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216269213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216270219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216271218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216272216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216273221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216274214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216275223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216276226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216277220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216278222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216279224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216280233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216281238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216282230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216283232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216284233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216285243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216286244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216287244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216288242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216289252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216290254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216291254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216292256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216293251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216294257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216295261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216296264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216297268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216298260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216299269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216300270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216301274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216302278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216303276	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216304272	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216305280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216306281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216307284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216308285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216309281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216310292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216311292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216312294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216313295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216332310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216332310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9702	1716216332310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216333311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216333311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9702	1716216333311	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716216334313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216334313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9702	1716216334313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216335315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216335315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216335315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216336317	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216336317	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216336317	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216337319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216337319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216287226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216287226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216287226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216288227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216288227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216288227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216289229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216289229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9666	1716216289229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216290231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216290231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9683	1716216290231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216291233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216291233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9683	1716216291233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216292235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216292235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9683	1716216292235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216293237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216293237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216293237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216294239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216294239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216294239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216295240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216295240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216295240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216296242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216296242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9693	1716216296242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216297244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216297244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9693	1716216297244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216298246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216298246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9693	1716216298246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216299248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216299248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9657	1716216299248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216300250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216300250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9657	1716216300250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216301251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216301251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9657	1716216301251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216302253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216302253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667999999999999	1716216302253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216303255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216303255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667999999999999	1716216303255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216304257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216304257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667999999999999	1716216304257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216305259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216305259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216305259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216306261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216306261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216306261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216307263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216307263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216307263	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216308264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216308264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216308264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216309266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216309266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216309266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216310268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216310268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216310268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216311270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216311270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216311270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216312272	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216312272	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216312272	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216313274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216313274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9698	1716216313274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216337319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216338321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216338321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9679	1716216338321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216339323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216339323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9679	1716216339323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216339342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216340325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216340325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9679	1716216340325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216340346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216341327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216341327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216341327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216341348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216342328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216342328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216342328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216342343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216343330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216343330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216343330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216343352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216344332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216344332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216344332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216344356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216345334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216345334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216345334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216345360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216346336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216346336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9692	1716216346336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216346362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216347338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216347338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.971	1716216347338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216347361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216348340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216348340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.971	1716216348340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216348356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216349342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216349342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.971	1716216349342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216349363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216350360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216351367	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216352368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216353364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216354374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216355374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216356376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216357378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216358374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216359382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216360384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216361386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216362387	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216363382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216364394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216365393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216366396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216367397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216368391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216369400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216370405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216371405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216372408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216373402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216914411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216914411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216914411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216915413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216915413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216915413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216916415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216916415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216916415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216917417	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216917417	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0766999999999998	1716216917417	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216918419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216918419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0766999999999998	1716216918419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216919421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216919421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0766999999999998	1716216919421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216920423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216920423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216920423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216921424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216921424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216921424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216922426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216922426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216922426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216923428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216923428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776	1716216923428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216924430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216924430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776	1716216924430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216925432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216925432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776	1716216925432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216926434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216926434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716216926434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216927436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216350344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216350344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9729	1716216350344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216351346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216351346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9729	1716216351346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216352347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216352347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9729	1716216352347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216353349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216353349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216353349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216354351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216354351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216354351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216355353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216355353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216355353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216356355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216356355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9739	1716216356355	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216357357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216357357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9739	1716216357357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216358359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216358359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9739	1716216358359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216359361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216359361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216359361	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216360363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216360363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216360363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216361365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216361365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216361365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216362366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216362366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9719	1716216362366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216363368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216363368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9719	1716216363368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216364370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216364370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9719	1716216364370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216365372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216365372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216365372	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216366374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216366374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216366374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216367376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216367376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9676	1716216367376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216368378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216368378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216368378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216369380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216369380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216369380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216370382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216370382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216370382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216371384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216371384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216371384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216372386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216372386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216372386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216373388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216373388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9687999999999999	1716216373388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216374390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216374390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216374390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216374413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216375391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216375391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216375391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216375412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216376394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216376394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.97	1716216376394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216376415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216377396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216377396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9727000000000001	1716216377396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216377419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216378398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216378398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9727000000000001	1716216378398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216378419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216379400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216379400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9727000000000001	1716216379400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216379423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216380402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216380402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9718	1716216380402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216380419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216381405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216381405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9718	1716216381405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216381429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216382407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216382407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9718	1716216382407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216382429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216383409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216383409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216383409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216383430	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216384411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216384411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216384411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216384432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216385412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216385412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9730999999999999	1716216385412	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216385434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216386414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216386414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216386414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216386436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216387416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216387416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216387416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216387439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216388418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216388418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9699	1716216388418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216389420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216389420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9715	1716216389420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216390422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216390422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9715	1716216390422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216391424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216391424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9715	1716216391424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216392426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216392426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9721	1716216392426	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216393427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216393427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9721	1716216393427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216394429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216394429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9721	1716216394429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216395431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216395431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9747999999999999	1716216395431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216396432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216396432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9747999999999999	1716216396432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216397434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216397434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9747999999999999	1716216397434	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216398436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216398436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9742	1716216398436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216399438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.6	1716216399438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9742	1716216399438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216400440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216400440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9742	1716216400440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216401441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.299999999999999	1716216401441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.976	1716216401441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216402443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216402443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.976	1716216402443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216403446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216403446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.976	1716216403446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216404448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216404448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9757	1716216404448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216405450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216405450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9757	1716216405450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216406452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216406452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9757	1716216406452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216407454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216407454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216407454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216408456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216408456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216408456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216409458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216388441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216389442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216390447	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216391439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216392446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216393446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216394453	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216395452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216396455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216397455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216398450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216399452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216400461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216401463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216402465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216403460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216404468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216405470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216406477	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216407476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216408471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216409477	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216410473	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216411484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216412488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216413479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216414490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216415496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216416498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216417499	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216418492	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216419494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216420493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216421504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216422505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216423507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216424501	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216425512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216426513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216427513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216428516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216429511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216430511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216431518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216432517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216433518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216434519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216435528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216436530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216437534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216438528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216439536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216440537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216441539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216442542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216443536	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216444539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216445546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216446549	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216447550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216448544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216449548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216450556	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216451560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216452560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216409458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216409458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216410460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216410460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735999999999998	1716216410460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216411462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216411462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735999999999998	1716216411462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216412464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216412464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735999999999998	1716216412464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216413466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216413466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216413466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216414469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216414469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216414469	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216415471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216415471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9758	1716216415471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216416472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216416472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216416472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216417474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216417474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216417474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216418476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216418476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216418476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216419478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216419478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216419478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216420480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216420480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216420480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216421482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216421482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216421482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216422484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216422484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216422484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216423486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216423486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216423486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216424488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216424488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9737	1716216424488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216425490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216425490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216425490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216426491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216426491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216426491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216427493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216427493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216427493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216428494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216428494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216428494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216429496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216429496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216429496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216430498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216430498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216430498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216431500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216431500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9724000000000002	1716216431500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216432502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216432502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9724000000000002	1716216432502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216433504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216433504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9724000000000002	1716216433504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216434506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216434506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216434506	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216435507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216435507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216435507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216436509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216436509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9753	1716216436509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216437511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216437511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216437511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216438513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216438513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216438513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216439514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216439514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9767000000000001	1716216439514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216440516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216440516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216440516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216441518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216441518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216441518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216442520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216442520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216442520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216443522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216443522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9775999999999998	1716216443522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216444524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216444524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9775999999999998	1716216444524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216445526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216445526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9775999999999998	1716216445526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216446528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216446528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216446528	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216447530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216447530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216447530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216448531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216448531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216448531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216449533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216449533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216449533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216450535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1000000000000005	1716216450535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216450535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216451537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216451537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9789	1716216451537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216452538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216452538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9806	1716216452538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216453540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216453540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9806	1716216453540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216454542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216454542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9806	1716216454542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216455544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216455544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9749	1716216455544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716216456546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216456546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9749	1716216456546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216457548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216457548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9749	1716216457548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216458550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216458550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9755999999999998	1716216458550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216459552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216459552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9755999999999998	1716216459552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216460553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216460553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9755999999999998	1716216460553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216461555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216461555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216461555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216462557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216462557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216462557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216463559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216463559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9772	1716216463559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216464561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216464561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9786	1716216464561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216465563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216465563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9786	1716216465563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216466565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216466565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9786	1716216466565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216467567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216467567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9794	1716216467567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216468568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216468568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9794	1716216468568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216469570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216469570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9794	1716216469570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216470572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216470572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216470572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216471574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216471574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216471574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216472576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216472576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216472576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216473578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216453554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216454563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216455566	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216456567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216457568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216458563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216459565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216460575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216461577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216462578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216463579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216464582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216465584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216466586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216467592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216468582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216469589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216470593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216471595	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216472597	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216473594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216474602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216475603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216476607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216477608	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216478609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216479607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216480614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216481616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216482618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216483612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216484620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216485623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216486624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216487627	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216488620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216489624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216490627	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216491628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216492635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216493632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216494640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216495641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216496646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216497647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216498641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216499649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216500650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216501644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216502656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216503649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216504664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216505661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216506663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216507665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216508665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216509667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216510672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216511674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216512675	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216513669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216514677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216515679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216516681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216517684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216473578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9810999999999999	1716216473578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216474580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216474580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9810999999999999	1716216474580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216475582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216475582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9810999999999999	1716216475582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216476584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216476584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9798	1716216476584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216477586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216477586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9798	1716216477586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216478588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216478588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9798	1716216478588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216479589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216479589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9807000000000001	1716216479589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216480592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216480592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9807000000000001	1716216480592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716216481594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216481594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9807000000000001	1716216481594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216482596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216482596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716216482596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216483598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216483598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716216483598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216484600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216484600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9814	1716216484600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216485601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216485601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9827000000000001	1716216485601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216486603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216486603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9827000000000001	1716216486603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216487605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216487605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9827000000000001	1716216487605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216488607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216488607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9828	1716216488607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216489609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216489609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9828	1716216489609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216490611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216490611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9828	1716216490611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216491613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216491613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9826	1716216491613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216492614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216492614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9826	1716216492614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216493616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216493616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9826	1716216493616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216494618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216494618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9834	1716216494618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216495620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216495620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9834	1716216495620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216496622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216496622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9834	1716216496622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216497624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216497624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216497624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216498626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216498626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216498626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216499628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216499628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216499628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216500630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216500630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667000000000001	1716216500630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216501632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216501632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667000000000001	1716216501632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216502634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216502634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9667000000000001	1716216502634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216503635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216503635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216503635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216504637	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216504637	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216504637	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216505639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216505639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9818	1716216505639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216506641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216506641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9835	1716216506641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216507643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216507643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9835	1716216507643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216508645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216508645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9835	1716216508645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216509647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216509647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.986	1716216509647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216510649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216510649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.986	1716216510649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216511651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216511651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.986	1716216511651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216512653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216512653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216512653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216513655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216513655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216513655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216514657	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216514657	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216514657	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216515658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216515658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9858	1716216515658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216516660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216516660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9858	1716216516660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216517662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216517662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9858	1716216517662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216518664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216518664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216518664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216519666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216519666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216519666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216520668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216520668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9847000000000001	1716216520668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216521670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.7	1716216521670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9872999999999998	1716216521670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216522671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.4	1716216522671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9872999999999998	1716216522671	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216523673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216523673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9872999999999998	1716216523673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216524674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216524674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9867000000000001	1716216524674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216525676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216525676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9867000000000001	1716216525676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216526680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216526680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9867000000000001	1716216526680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216527681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216527681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9869	1716216527681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216528683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216528683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9869	1716216528683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216529684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216529684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9869	1716216529684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216530686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216530686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.989	1716216530686	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216531688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216531688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.989	1716216531688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216532690	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216532690	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.989	1716216532690	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216533692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216533692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9908	1716216533692	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216534694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216534694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9908	1716216534694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216535697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216535697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9908	1716216535697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216536699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216536699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9886	1716216536699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216537701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216518678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216519688	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216520690	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216521691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216522691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216523695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216524696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216525697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216526701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216527695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216528703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216529705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216530702	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216531710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216532712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216533714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216534714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216535723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216536721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216537722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216538724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216539718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216540724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216541726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216542732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216543727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216544737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216545738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216546740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216547741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216548734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216549743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216550745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216551749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216552749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216914432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216915436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216916432	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216917440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216918440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216919442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216920443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216921438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216922447	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216923449	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216924443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216925454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216926447	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216927459	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216928460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216929465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216930466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216931459	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216932467	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216933463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216934473	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216935474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216936476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216937476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216938471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216939482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216940484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216941484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216942487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216943487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216537701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9886	1716216537701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216538703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216538703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9886	1716216538703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216539704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216539704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9904000000000002	1716216539704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216540706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216540706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9904000000000002	1716216540706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216541708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216541708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9904000000000002	1716216541708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216542710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216542710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912999999999998	1716216542710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216543712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216543712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912999999999998	1716216543712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216544714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216544714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912999999999998	1716216544714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216545716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216545716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9837	1716216545716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216546718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216546718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9837	1716216546718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216547720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216547720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9837	1716216547720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216548721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216548721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9862	1716216548721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216549722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216549722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9862	1716216549722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216550724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216550724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9862	1716216550724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216551726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216551726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912	1716216551726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216552728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216552728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912	1716216552728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216553730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216553730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9912	1716216553730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216553743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216554732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216554732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216554732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216554755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216555733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216555733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216555733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216555754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216556735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216556735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216556735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216556755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216557736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216557736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216557736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216558738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216558738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216558738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216559740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216559740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9925	1716216559740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716216560742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716216560742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9923	1716216560742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216561744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216561744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9923	1716216561744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216562746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216562746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9923	1716216562746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216563748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216563748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9681	1716216563748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216564749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216564749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9681	1716216564749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216565751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216565751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9681	1716216565751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216566753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216566753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9705	1716216566753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216567755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216567755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9705	1716216567755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216568757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216568757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9705	1716216568757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216569759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216569759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9838	1716216569759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216570761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216570761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9838	1716216570761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216571763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216571763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9838	1716216571763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216572765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216572765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9861	1716216572765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216573767	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216573767	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9861	1716216573767	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216574768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216574768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9861	1716216574768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216575770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216575770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9865	1716216575770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216576772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216576772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9865	1716216576772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216577774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216577774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9865	1716216577774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216578776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216578776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216557759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216558753	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216559763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216560766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216561759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216562768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216563762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216564773	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216565773	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216566775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216567777	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216568781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216569774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216570783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216571786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216572787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216573784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216574795	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216575794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216576797	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216577795	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216578791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216579801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216580801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216581805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216582805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216583800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216584800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216585811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216586814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216587814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216588813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216589810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216590819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216591822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216592821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216593818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216594820	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216595834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216596838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216597837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216598829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216599831	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216600840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216601841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216602843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216603837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216604838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216605848	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216606850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216607852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216608846	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216609855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216610859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216611861	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216612862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216613863	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216614868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216615869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216616869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216617872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216618869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216619877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216620878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216621884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9906	1716216578776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216579778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216579778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9906	1716216579778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216580779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216580779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9906	1716216580779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216581781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216581781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9654	1716216581781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216582783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216582783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9654	1716216582783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216583785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216583785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9654	1716216583785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216584787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216584787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216584787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216585789	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216585789	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216585789	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216586790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216586790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9735	1716216586790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216587792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216587792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9743	1716216587792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216588794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216588794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9743	1716216588794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216589797	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216589797	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9743	1716216589797	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216590799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216590799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9845	1716216590799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216591800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216591800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9845	1716216591800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216592802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216592802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9845	1716216592802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216593804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216593804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9915999999999998	1716216593804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216594806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216594806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9915999999999998	1716216594806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216595808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216595808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9915999999999998	1716216595808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216596810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216596810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935999999999998	1716216596810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216597812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216597812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935999999999998	1716216597812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216598814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216598814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935999999999998	1716216598814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216599815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216599815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935	1716216599815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216600817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216600817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935	1716216600817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216601819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216601819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9935	1716216601819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216602821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216602821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9921	1716216602821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216603823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216603823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9921	1716216603823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216604825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216604825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9921	1716216604825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216605827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216605827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9962	1716216605827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216606828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216606828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9962	1716216606828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216607830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216607830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9962	1716216607830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216608832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216608832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9964000000000002	1716216608832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216609834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216609834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9964000000000002	1716216609834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216610836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216610836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9964000000000002	1716216610836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216611838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216611838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9938	1716216611838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216612841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216612841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9938	1716216612841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216613842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216613842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9938	1716216613842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216614844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216614844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9949000000000001	1716216614844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216615846	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216615846	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9949000000000001	1716216615846	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216616848	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216616848	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9949000000000001	1716216616848	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216617850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216617850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216617850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216618852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216618852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216618852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216619854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216619854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216619854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216620856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216620856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216620856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216621859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216621859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216621859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216622861	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216622861	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.992	1716216622861	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216623862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216623862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9939	1716216623862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216624865	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216624865	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9939	1716216624865	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216625867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216625867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9939	1716216625867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216626869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216626869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716216626869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216627871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216627871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716216627871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216628872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216628872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9950999999999999	1716216628872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216629874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216629874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216629874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216630876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216630876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216630876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216631878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216631878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216631878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216632880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216632880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9944000000000002	1716216632880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216633882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216633882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9944000000000002	1716216633882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216634884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216634884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9944000000000002	1716216634884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216635886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216635886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9788	1716216635886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216636888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216636888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9788	1716216636888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216637890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216637890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9788	1716216637890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216638891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216638891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9875999999999998	1716216638891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216639893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216639893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9875999999999998	1716216639893	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216640895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216640895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9875999999999998	1716216640895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216641898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.8	1716216641898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216641898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216642902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.5	1716216642902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216622882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216623877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216624887	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216625888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216626890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216627892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216628896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216629895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216630897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216631900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216632901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216633896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216634907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216635912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216636909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216637912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216638905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216639915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216640918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216641920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216642916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216643925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216644920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216645930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216646932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216647926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216648933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216649936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216650937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216651939	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216652935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216653944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216654944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216655948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216656950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216657944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216658954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216659955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216660959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216661958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216662966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216663955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216664966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216665968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216666968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216667974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216668965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216669973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216670975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216671977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216672981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216673973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216674984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216675986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216676987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216677990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216678983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216679994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216680995	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216681997	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216682992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216683994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216685003	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216686005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216687008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216642902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216643903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216643903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9942	1716216643903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216644905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216644905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932	1716216644905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216645907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216645907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932	1716216645907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216646909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216646909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9932	1716216646909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216647911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216647911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.995	1716216647911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216648913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216648913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.995	1716216648913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216649915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216649915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.995	1716216649915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216650917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216650917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9957	1716216650917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216651919	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216651919	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9957	1716216651919	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216652920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216652920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9957	1716216652920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216653922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216653922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9984000000000002	1716216653922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216654924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216654924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9984000000000002	1716216654924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216655926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216655926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9984000000000002	1716216655926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216656929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216656929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216656929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216657930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216657930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216657930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216658932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216658932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216658932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216659934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216659934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9992	1716216659934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216660936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216660936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9992	1716216660936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216661938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216661938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9992	1716216661938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216662940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216662940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216662940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216663942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216663942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216663942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216664944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216664944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.999	1716216664944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216665946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.300000000000001	1716216665946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9969000000000001	1716216665946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216666947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216666947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9969000000000001	1716216666947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216667949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216667949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9969000000000001	1716216667949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216668951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216668951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216668951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216669953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3.9	1716216669953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216669953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216670954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216670954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216670954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216671956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216671956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0000999999999998	1716216671956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216672958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216672958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0000999999999998	1716216672958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216673960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216673960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0000999999999998	1716216673960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216674962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216674962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9994	1716216674962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216675964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216675964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9994	1716216675964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216676966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216676966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9994	1716216676966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216677968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216677968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0033	1716216677968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216678970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216678970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0033	1716216678970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216679971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216679971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0033	1716216679971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216680973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	5.6	1716216680973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0028	1716216680973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216681976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216681976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0028	1716216681976	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216682978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216682978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0028	1716216682978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216683980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216683980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216683980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216684982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216684982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216684982	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216685984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216685984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0019	1716216685984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216686986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216686986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0051	1716216686986	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216687988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216687988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0051	1716216687988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216688989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216688989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0051	1716216688989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216689991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216689991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0055	1716216689991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216690992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216690992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0055	1716216690992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216691994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216691994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0055	1716216691994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216692996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216692996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0052	1716216692996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216693998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216693998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0052	1716216693998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216695000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216695000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0052	1716216695000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216696002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216696002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0049	1716216696002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216697004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216697004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0049	1716216697004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216698005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216698005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0049	1716216698005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216699007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216699007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0033	1716216699007	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216700009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216700009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0033	1716216700009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216701011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216701011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216701011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216702013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216702013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216702013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216703015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216703015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216703015	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216704017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216704017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0029	1716216704017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216705018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216705018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0029	1716216705018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216706021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216706021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0029	1716216706021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216707023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216707023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216688010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216689010	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216690013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216691014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216692016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216693017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216694012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216695020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216696023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216697025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216698019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216699022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216700028	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216701031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216702026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216703029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216704037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216705041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216706035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216707036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216708040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216709041	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216710049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216711053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216712055	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216713049	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216714052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216715060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216716062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216717064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216718064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216719065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216720068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216721065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216722077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216723069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216724070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216725081	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216726084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216727084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216728087	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216729080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216730088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216731083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216732085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216733087	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216927436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716216927436	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216928439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216928439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716216928439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216929441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216929441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216929441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216930442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216930442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216930442	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216931444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216931444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216931444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216932446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216932446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216932446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216933448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216933448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.004	1716216707023	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216708025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216708025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.004	1716216708025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216709027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216709027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.004	1716216709027	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216710029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216710029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0061	1716216710029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216711031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216711031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0061	1716216711031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216712033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216712033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0061	1716216712033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216713034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216713034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0056	1716216713034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216714036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216714036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0056	1716216714036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216715038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216715038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0056	1716216715038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216716040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216716040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0014000000000003	1716216716040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216717042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216717042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0014000000000003	1716216717042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216718043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216718043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0014000000000003	1716216718043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216719045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216719045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0021	1716216719045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216720047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216720047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0021	1716216720047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216721050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216721050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0021	1716216721050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216722052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216722052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0059	1716216722052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216723054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216723054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0059	1716216723054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216724056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216724056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0059	1716216724056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216725058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216725058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0057	1716216725058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216726060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216726060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0057	1716216726060	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216727062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216727062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0057	1716216727062	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216728064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216728064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0085	1716216728064	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216729066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216729066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0085	1716216729066	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216730067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216730067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0085	1716216730067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216731069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216731069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0094000000000003	1716216731069	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216732071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216732071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0094000000000003	1716216732071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216733073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216733073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0094000000000003	1716216733073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216734075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216734075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0071	1716216734075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216734089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216735077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216735077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0071	1716216735077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216735093	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216736078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216736078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0071	1716216736078	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216736099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216737080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216737080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9999	1716216737080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216737101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216738082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216738082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9999	1716216738082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216738105	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216739084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216739084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	1.9999	1716216739084	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216739098	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216740086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216740086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216740086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216740106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216741088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216741088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216741088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216741109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216742090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216742090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0047	1716216742090	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216742111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216743092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216743092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0155	1716216743092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216743105	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216744094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216744094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0155	1716216744094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216744108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216745096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216745096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0155	1716216745096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216745118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216746097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216746097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0122999999999998	1716216746097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216747099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216747099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0122999999999998	1716216747099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216748101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216748101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0122999999999998	1716216748101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216749103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216749103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0225	1716216749103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216750104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216750104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0225	1716216750104	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216751106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216751106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0225	1716216751106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216752108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216752108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0279000000000003	1716216752108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216753110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216753110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0279000000000003	1716216753110	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216754111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216754111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0279000000000003	1716216754111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216755113	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216755113	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0275	1716216755113	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216756114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216756114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0275	1716216756114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216757116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216757116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0275	1716216757116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216758118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216758118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.046	1716216758118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216759120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216759120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.046	1716216759120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216760122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216760122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.046	1716216760122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216761124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216761124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0478	1716216761124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216762126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216762126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0478	1716216762126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216763128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216763128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0478	1716216763128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216764130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716216764130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0501	1716216764130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216765131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216765131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0501	1716216765131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216766132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216766132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0501	1716216766132	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216767134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216767134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216746122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216747120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216748126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216749126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216750128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216751123	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216752131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216753129	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216754125	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216755134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216756136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216757131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216758141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216759134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216760148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216761151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216762150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216763151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216764153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216765151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216766148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216767155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216768158	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216769153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216770162	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216771163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216772167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216773170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216774162	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216775172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216776164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216777174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216778176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216779178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216780181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216781176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216782183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216783181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216784187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216785189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216786183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216787194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216788188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216789198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216790201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216791197	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216792198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216793198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216794208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216795209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216796203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216797212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216798216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216799209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216800211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216801215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216802222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216803223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216804217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216805227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216806223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216807231	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216808233	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216809236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216810236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0477	1716216767134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216768136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216768136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0477	1716216768136	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216769138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216769138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0477	1716216769138	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216770140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216770140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0533	1716216770140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216771142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216771142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0533	1716216771142	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216772144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216772144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0533	1716216772144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216773146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216773146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0568	1716216773146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216774148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216774148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0568	1716216774148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216775150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216775150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0568	1716216775150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216776151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216776151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716216776151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216777153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216777153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716216777153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216778155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216778155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716216778155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216779157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216779157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0530999999999997	1716216779157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216780159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216780159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0530999999999997	1716216780159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216781161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216781161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0530999999999997	1716216781161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216782163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216782163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0631	1716216782163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216783165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216783165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0631	1716216783165	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216784166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216784166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0631	1716216784166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216785168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216785168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216785168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216786170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216786170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216786170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216787172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216787172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216787172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216788174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	6.9	1716216788174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0485	1716216788174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216789176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.6	1716216789176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0485	1716216789176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216790178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216790178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0485	1716216790178	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216791180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216791180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0507	1716216791180	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216792182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216792182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0507	1716216792182	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216793184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216793184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0507	1716216793184	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216794186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216794186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0566	1716216794186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216795188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216795188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0566	1716216795188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216796189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216796189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0566	1716216796189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216797191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216797191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0558	1716216797191	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216798193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216798193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0558	1716216798193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216799194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216799194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0558	1716216799194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216800196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216800196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0573	1716216800196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216801198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216801198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0573	1716216801198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216802200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216802200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0573	1716216802200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216803202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216803202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0575	1716216803202	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216804204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216804204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0575	1716216804204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216805206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216805206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0575	1716216805206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216806208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216806208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0683000000000002	1716216806208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216807209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216807209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0683000000000002	1716216807209	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216808211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216808211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0683000000000002	1716216808211	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216809213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216809213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0694	1716216809213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216810215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216810215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0694	1716216810215	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216811217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216811217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0694	1716216811217	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216812219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216812219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216812219	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216813221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216813221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216813221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216814224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216814224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216814224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216815226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216815226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216815226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216816228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216816228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216816228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216817230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216817230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216817230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216818232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216818232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216818232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216819234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216819234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216819234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216820235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216820235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216820235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216821237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216821237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0704000000000002	1716216821237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216822239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216822239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0704000000000002	1716216822239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216823241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216823241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0704000000000002	1716216823241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216824243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216824243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216824243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216825245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216825245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216825245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216826247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216826247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0656	1716216826247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216827248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216827248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0678	1716216827248	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216828252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216828252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0678	1716216828252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216829254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216829254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0678	1716216829254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216830256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216830256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665	1716216830256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216831257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216831257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216811230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216812240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216813241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216814238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216815246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216816242	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216817254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216818253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216819247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216820256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216821250	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216822261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216823262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216824265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216825267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216826260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216827269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216828275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216829275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216830271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216831272	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216832281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216833285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216834283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216835285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216836280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216837293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216838284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216839293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216840295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216841288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216842299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216843299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216844294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216845295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216846298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216847306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216848308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216849303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216850313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216851308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216852314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216853322	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216854326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216855325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216856318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216857328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216858330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216859330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216860331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216861326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216862339	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216863337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216864342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216865340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216866336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216867343	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216868347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216869348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216870350	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216871348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216872353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216873349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216874357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216875359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665	1716216831257	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216832259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216832259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665	1716216832259	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216833261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216833261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665999999999998	1716216833261	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216834262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216834262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665999999999998	1716216834262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216835264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216835264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0665999999999998	1716216835264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216836266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216836266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696	1716216836266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216837268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216837268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696	1716216837268	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216838270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216838270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696	1716216838270	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216839271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216839271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696999999999997	1716216839271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216840273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216840273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696999999999997	1716216840273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216841274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216841274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0696999999999997	1716216841274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216842277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216842277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216842277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216843278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216843278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216843278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216844280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216844280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705	1716216844280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216845282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216845282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0673000000000004	1716216845282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216846284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216846284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0673000000000004	1716216846284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216847286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216847286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0673000000000004	1716216847286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216848288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216848288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0701	1716216848288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216849290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216849290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0701	1716216849290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216850291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216850291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0701	1716216850291	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216851293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216851293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0699	1716216851293	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216852295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216852295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0699	1716216852295	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216853297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216853297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0699	1716216853297	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216854299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216854299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.072	1716216854299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216855301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216855301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.072	1716216855301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216856302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216856302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.072	1716216856302	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216857305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216857305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0713000000000004	1716216857305	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216858306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216858306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0713000000000004	1716216858306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216859308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716216859308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0713000000000004	1716216859308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216860310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216860310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216860310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216861312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216861312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216861312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216862314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216862314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216862314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216863316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216863316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.071	1716216863316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216864318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216864318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.071	1716216864318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216865319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216865319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.071	1716216865319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216866321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216866321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216866321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216867323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216867323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216867323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216868324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216868324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0725	1716216868324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216869326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216869326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0714	1716216869326	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216870330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216870330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0714	1716216870330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216871331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216871331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0714	1716216871331	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216872333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216872333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216872333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216873334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216873334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216873334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216874336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216874336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0716	1716216874336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216875338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216875338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216875338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216876340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216876340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216876340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216877342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216877342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216877342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216878345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216878345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0736	1716216878345	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216879347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216879347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0736	1716216879347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216880349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216880349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0736	1716216880349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216881351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216881351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216881351	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216882352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216882352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216882352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216883354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216883354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216883354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216884356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216884356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216884356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216885358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216885358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216885358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216886360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216886360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0721	1716216886360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216887362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216887362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216887362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216888364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216888364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216888364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216889366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216889366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0723000000000003	1716216889366	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216890368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216890368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0730999999999997	1716216890368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216891370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216891370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0730999999999997	1716216891370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216892371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216892371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0730999999999997	1716216892371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216893373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216893373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0726	1716216893373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216894374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216894374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0726	1716216894374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216895376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216895376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216876356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216877363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216878359	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216879360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216880370	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216881367	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216882375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216883375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216884377	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216885383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216886377	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216887383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216888385	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216889381	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216890390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216891385	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216892392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216893393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216894387	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216895397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216896395	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216897404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216898400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216899405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216900407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216901402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216902403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216903404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216904406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216905419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216906411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216907419	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216908414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216909415	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216910427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216911422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216912428	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216913423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216933448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216934450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216934450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216934450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216935452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216935452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0763000000000003	1716216935452	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216936454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216936454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0763000000000003	1716216936454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216937456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216937456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0763000000000003	1716216937456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216938458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216938458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216938458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216939460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216939460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216939460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216940461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216940461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216940461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216941463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216941463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0785	1716216941463	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216942464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216942464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0726	1716216895376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216896378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216896378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216896378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216897380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216897380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216897380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216898382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216898382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.074	1716216898382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216899384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216899384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0754	1716216899384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216900386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216900386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0754	1716216900386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216901388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216901388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0754	1716216901388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216902389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216902389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0756	1716216902389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216903391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216903391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0756	1716216903391	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216904393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216904393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0756	1716216904393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216905394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216905394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0765	1716216905394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216906396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216906396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0765	1716216906396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216907398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216907398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0765	1716216907398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216908400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216908400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216908400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216909402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216909402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216909402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216910404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216910404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216910404	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216911406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216911406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0768	1716216911406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216912408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.7	1716216912408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0768	1716216912408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216913410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7	1716216913410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0768	1716216913410	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0785	1716216942464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216943466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216943466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0785	1716216943466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216944468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216944468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0753000000000004	1716216944468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216944490	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216945471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216945471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0753000000000004	1716216945471	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216946474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216946474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0753000000000004	1716216946474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216947476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216947476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776999999999997	1716216947476	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216948478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216948478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776999999999997	1716216948478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216949480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216949480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0776999999999997	1716216949480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216950482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216950482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0788	1716216950482	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216951484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216951484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0788	1716216951484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216952486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216952486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0788	1716216952486	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216953488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216953488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216953488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216954489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216954489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216954489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216955491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216955491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0787	1716216955491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216956493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216956493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216956493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216957494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216957494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216957494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216958496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216958496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0783	1716216958496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216959498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216959498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216959498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216960500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716216960500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216960500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216961502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216961502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0773	1716216961502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216962504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216962504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0774	1716216962504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216963505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216963505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0774	1716216963505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216964507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216964507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0774	1716216964507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216965509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216965509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216965509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216966512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216966512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216945494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216946496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216947489	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216948493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216949500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216950503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216951497	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216952508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216953503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216954512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216955512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216956515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216957515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216958517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216959519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216960526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216961527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216962526	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216963518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216964529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216965530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216966534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216967534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216968529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216969542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216970540	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216971544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216972544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216973539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216974548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216975552	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216976554	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216977547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216978550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216979559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216980560	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216981558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216982564	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216983559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216984569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216985563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216986575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216987576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216988578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216989581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216990584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216991585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216992585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216993581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216994595	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216995593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216996585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216997597	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216998592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716216999600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217000602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217001604	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217002606	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217003607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217004609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217005611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217006614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217007615	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217008610	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217009618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216966512	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216967514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216967514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216967514	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216968515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216968515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216968515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216969517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216969517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216969517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216970519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216970519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0784000000000002	1716216970519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216971521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216971521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0789	1716216971521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216972523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216972523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0789	1716216972523	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216973525	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216973525	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0789	1716216973525	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216974527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216974527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0778000000000003	1716216974527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216975530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216975530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0778000000000003	1716216975530	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216976532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216976532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0778000000000003	1716216976532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216977534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216977534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716216977534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216978535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216978535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716216978535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216979537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216979537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716216979537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216980539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216980539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216980539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216981541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216981541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216981541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216982543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216982543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0769	1716216982543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216983545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216983545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0799000000000003	1716216983545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216984547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216984547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0799000000000003	1716216984547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216985550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216985550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0799000000000003	1716216985550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216986553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216986553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.08	1716216986553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216987555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216987555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.08	1716216987555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216988557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216988557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.08	1716216988557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716216989559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216989559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0806	1716216989559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216990561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216990561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0806	1716216990561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216991563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216991563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0806	1716216991563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716216992565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216992565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216992565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216993567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216993567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216993567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216994568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216994568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216994568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216995570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216995570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216995570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716216996572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216996572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216996572	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216997574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216997574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716216997574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716216998576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716216998576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716216998576	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716216999578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716216999578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716216999578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217000580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.8	1716217000580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0615	1716217000580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217001582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217001582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716217001582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217002584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217002584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716217002584	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217003586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217003586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.078	1716217003586	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217004588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217004588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0793000000000004	1716217004588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217005590	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217005590	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0793000000000004	1716217005590	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217006592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217006592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0793000000000004	1716217006592	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217007593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217007593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716217007593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217008596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217008596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716217008596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217009597	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217009597	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0808	1716217009597	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217010599	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217010599	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217010599	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217011601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217011601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217011601	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217012603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217012603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217012603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217013605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217013605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217013605	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217014607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217014607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217014607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217015609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217015609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217015609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217016612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217016612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217016612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217017614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217017614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217017614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217018616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217018616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217018616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217019619	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217019619	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0815	1716217019619	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217020621	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217020621	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0815	1716217020621	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217021623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217021623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0815	1716217021623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217022625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217022625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0795	1716217022625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217023626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217023626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0795	1716217023626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217024628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217024628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0795	1716217024628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217025630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217025630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217025630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217026632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217026632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217026632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217027634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217027634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0803000000000003	1716217027634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217028636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217028636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217028636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217029639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217029639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217029639	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217030641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217030641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217010623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217011616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217012625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217013620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217014628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217015629	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217016634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217017635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217018637	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217019644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217020643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217021641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217022647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217023640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217024651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217025652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217026655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217027655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217028651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217029663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217030665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217031657	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217032660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217033667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217034673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217035665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217036674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217037679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217038677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217039684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217040673	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217041684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217042685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217043685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217044689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217045685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217046695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217047695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217048700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217049691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217050694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217051703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217052704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217053698	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217054710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217055710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217056712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217057714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217058710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217059718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217060719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217061721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217062725	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217063716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217064729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217065731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217066736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217067736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217068727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217069735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217070739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217071739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217072744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217073737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217074749	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217030641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217031643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217031643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0819	1716217031643	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217032645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217032645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0819	1716217032645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217033647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217033647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0819	1716217033647	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217034649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217034649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0833000000000004	1716217034649	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217035651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217035651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0833000000000004	1716217035651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217036652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217036652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0833000000000004	1716217036652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217037654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217037654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0816	1716217037654	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217038656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217038656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0816	1716217038656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217039658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217039658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0816	1716217039658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217040660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217040660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0810999999999997	1716217040660	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217041662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217041662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0810999999999997	1716217041662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217042664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217042664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0810999999999997	1716217042664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217043666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217043666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705999999999998	1716217043666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217044668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217044668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705999999999998	1716217044668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217045670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217045670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0705999999999998	1716217045670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217046672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217046672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0828	1716217046672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217047674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217047674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0828	1716217047674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217048676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217048676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0828	1716217048676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217049678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217049678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217049678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217050680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217050680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217050680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217051681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217051681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217051681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217052683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217052683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217052683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217053685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217053685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217053685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217054687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217054687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217054687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217055689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217055689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217055689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217056691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217056691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217056691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217057693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217057693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217057693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217058695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217058695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217058695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217059696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217059696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217059696	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217060698	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217060698	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217060698	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217061700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217061700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217061700	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217062702	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217062702	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217062702	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217063704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217063704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217063704	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217064706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217064706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856	1716217064706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217065708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217065708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856	1716217065708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217066709	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217066709	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856	1716217066709	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217067711	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217067711	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0814	1716217067711	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217068713	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217068713	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0814	1716217068713	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217069715	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217069715	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0814	1716217069715	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217070716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217070716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841999999999996	1716217070716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217071718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217071718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841999999999996	1716217071718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217072720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217072720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841999999999996	1716217072720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217073722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217073722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856999999999997	1716217073722	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217074724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217074724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856999999999997	1716217074724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217075726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217075726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0856999999999997	1716217075726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217076728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217076728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0844	1716217076728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217077730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217077730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0844	1716217077730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217078731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217078731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0844	1716217078731	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217079733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217079733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217079733	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217080735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217080735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217080735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217081737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217081737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217081737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217082739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217082739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0821	1716217082739	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217083740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217083740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0821	1716217083740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217084742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217084742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0821	1716217084742	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217085744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217085744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217085744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217086746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217086746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217086746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217087748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217087748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.083	1716217087748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217088750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217088750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0798	1716217088750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217089752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.1	1716217089752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0798	1716217089752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217090754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.799999999999999	1716217090754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0798	1716217090754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217091755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217091755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217091755	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217092757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217092757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217092757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217093760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217093760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0822	1716217093760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217094761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217094761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217075746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217076748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217077751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217078745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217079756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217080754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217081758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217082759	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217083763	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217084767	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217085768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217086775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217087765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217088765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217089774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217090775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217091776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217092779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217093779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217094775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217095788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217096787	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217097782	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217098784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217099793	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217100794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217101797	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217102791	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217103794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217104803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217105803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217106805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217107801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217108808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217109804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217110813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217111815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217112809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217113813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217114821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217115823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217116826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217117822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217118823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217119832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217120833	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217121838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217122829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217123840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217124842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217125842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217126846	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217127837	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217128847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217129850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217130850	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217131855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217132847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217133859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217134859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217135862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217136862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217137857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217138866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217139868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0823	1716217094761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217095764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217095764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0823	1716217095764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217096766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217096766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0823	1716217096766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217097768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217097768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.081	1716217097768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217098770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217098770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.081	1716217098770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217099772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217099772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.081	1716217099772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217100774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217100774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0837	1716217100774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217101776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217101776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0837	1716217101776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217102778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217102778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0837	1716217102778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217103780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217103780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0831	1716217103780	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217104781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217104781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0831	1716217104781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716217105783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217105783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0831	1716217105783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217106785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217106785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217106785	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217107786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217107786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217107786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217108788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217108788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0838	1716217108788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217109790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217109790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217109790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217110792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217110792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217110792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217111794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217111794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217111794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217112796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217112796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217112796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217113799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217113799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217113799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217114801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217114801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0813	1716217114801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217115802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217115802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0818000000000003	1716217115802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217116804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217116804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0818000000000003	1716217116804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217117806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217117806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0818000000000003	1716217117806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217118808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217118808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0826	1716217118808	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217119810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217119810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0826	1716217119810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217120812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217120812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0826	1716217120812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217121814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217121814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0835	1716217121814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217122815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217122815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0835	1716217122815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217123817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217123817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0835	1716217123817	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217124819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217124819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217124819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217125821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217125821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217125821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217126823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217126823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0848	1716217126823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217127825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217127825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841	1716217127825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217128826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217128826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841	1716217128826	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217129828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217129828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0841	1716217129828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217130830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217130830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0829	1716217130830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217131832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217131832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0829	1716217131832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217132834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217132834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0829	1716217132834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217133836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217133836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217133836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217134838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217134838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217134838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217135839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217135839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0836	1716217135839	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217136841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.3	1716217136841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0862	1716217136841	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217137843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217137843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0862	1716217137843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217138845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217138845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0862	1716217138845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217139847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217139847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217139847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217140849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217140849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217140849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217141851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217141851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217141851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217142853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217142853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217142853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217143854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217143854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217143854	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217144856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217144856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217144856	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217145858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217145858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217145858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217146860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217146860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217146860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217147862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217147862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217147862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217148864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217148864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.084	1716217148864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217149867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217149867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.084	1716217149867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217150869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217150869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.084	1716217150869	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217151871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217151871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0854	1716217151871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217152872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217152872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0854	1716217152872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217634800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217634800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217634800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217635802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217635802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217635802	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	4	1716217636804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217636804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217636804	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217637806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217637806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1206	1716217637806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217638807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217638807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1206	1716217638807	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217639809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217639809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217140870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217141871	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217142868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217143876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217144876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217145878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217146881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217147875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217148887	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217149888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217150892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217151886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217152886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217153874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217153874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0854	1716217153874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217153888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217154877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217154877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217154877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217154901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217155878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217155878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217155878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217155899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217156880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217156880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0839000000000003	1716217156880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217156901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217157882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217157882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0873000000000004	1716217157882	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217157895	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217158884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217158884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0873000000000004	1716217158884	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217158897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217159886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217159886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0873000000000004	1716217159886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217159907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217160888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217160888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0886	1716217160888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217160912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217161890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217161890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0886	1716217161890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217161914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217162891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217162891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0886	1716217162891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217162907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217163892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217163892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871	1716217163892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217163906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217164894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217164894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871	1716217164894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217164916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217165896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217165896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871	1716217165896	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217165918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716217166898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.2	1716217166898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217166898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217167900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217167900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217167900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217168902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217168902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0881	1716217168902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217169904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217169904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0894	1716217169904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217170906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217170906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0894	1716217170906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217171908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217171908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0894	1716217171908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217172909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217172909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217172909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217173911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217173911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217173911	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217174913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217174913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217174913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217175914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217175914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0888	1716217175914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217176916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217176916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0888	1716217176916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716217177918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217177918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0888	1716217177918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217178920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217178920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0850999999999997	1716217178920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217179922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217179922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0850999999999997	1716217179922	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217180924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217180924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0850999999999997	1716217180924	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217181926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217181926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217181926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217182928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217182928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217182928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217183930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217183930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0877	1716217183930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217184932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217184932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0874	1716217184932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217185934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217185934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0874	1716217185934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217186936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217186936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0874	1716217186936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217187938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217166913	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217167915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217168925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217169928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217170931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217171930	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217172926	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217173927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217174933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217175934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217176937	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217177933	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217178934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217179943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217180945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217181949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217182944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217183951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217184955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217185949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217186959	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217187951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217188953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217189962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217190965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217191967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217192960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217193963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217194977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217195974	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217196968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217197971	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217198979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217199981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217200985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217201985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217202980	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217203985	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217204990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217205992	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217206994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217207988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217208990	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217210000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217211005	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217212008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217213002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217214011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217215014	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217216018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217217017	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217218009	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217219012	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217220021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217221022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217222025	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217223019	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217224021	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217225038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217226037	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217227034	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217228035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217229043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217230043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217231047	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217187938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.088	1716217187938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217188940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217188940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.088	1716217188940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217189941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217189941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.088	1716217189941	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217190943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217190943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0884	1716217190943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217191945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217191945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0884	1716217191945	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217192947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217192947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0884	1716217192947	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217193949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217193949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217193949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217194951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217194951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217194951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217195953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217195953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217195953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217196955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217196955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716217196955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217197957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217197957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716217197957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	98	1716217198958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217198958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0744000000000002	1716217198958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217199960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217199960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0867	1716217199960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217200962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217200962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0867	1716217200962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217201964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217201964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0867	1716217201964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217202966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217202966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871999999999997	1716217202966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217203968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217203968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871999999999997	1716217203968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217204970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217204970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0871999999999997	1716217204970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217205972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217205972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.087	1716217205972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217206973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217206973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.087	1716217206973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217207975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217207975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.087	1716217207975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217208977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217208977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217208977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217209979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217209979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217209979	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217210983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217210983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217210983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217211984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217211984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0909	1716217211984	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217212987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217212987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0909	1716217212987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217213989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217213989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0909	1716217213989	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217214991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217214991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.089	1716217214991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217215993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217215993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.089	1716217215993	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217216994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217216994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.089	1716217216994	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217217996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217217996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217217996	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217218998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217218998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217218998	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217220000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217220000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896	1716217220000	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217221002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217221002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217221002	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217222004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217222004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217222004	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217223006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217223006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217223006	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217224008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217224008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0913000000000004	1716217224008	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217225011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217225011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0913000000000004	1716217225011	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217226013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217226013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0935	1716217226013	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217227016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217227016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0935	1716217227016	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217228018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217228018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0935	1716217228018	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217229020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217229020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0924	1716217229020	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217230022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217230022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0924	1716217230022	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	105	1716217231024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217231024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0924	1716217231024	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217232026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217232026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0925	1716217232026	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217233029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217233029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0925	1716217233029	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217234031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217234031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0925	1716217234031	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217235033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217235033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0927	1716217235033	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217236035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217236035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0927	1716217236035	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217237036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.2	1716217237036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0927	1716217237036	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217238038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8.9	1716217238038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0918	1716217238038	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217239040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217239040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0918	1716217239040	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217240042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217240042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0918	1716217240042	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217241044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217241044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0919	1716217241044	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217242046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217242046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0919	1716217242046	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217243048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217243048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0919	1716217243048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217244050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217244050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0883000000000003	1716217244050	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217245052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217245052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0883000000000003	1716217245052	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217246054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217246054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0883000000000003	1716217246054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217247056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217247056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217247056	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217248058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217248058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217248058	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217249059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217249059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0892	1716217249059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217250061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217250061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217250061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217251063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217251063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217251063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217252065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217232048	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217233043	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217234045	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217235053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217236051	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217237057	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217238053	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217239054	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217240063	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217241059	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217242067	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217243061	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217244075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217245073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217246071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217247077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217248072	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217249073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217250082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217251085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217252089	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217253083	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217254087	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217255094	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217256096	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217257097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217258091	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217259101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217260102	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217261106	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217262108	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217263100	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217264111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217265116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217266116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217267119	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217268116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217269115	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217270126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217271128	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217272127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217273122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217274131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217275134	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217276139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217277137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217278140	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217279133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217280145	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217281147	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217282150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217283150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217284151	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217285155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217286154	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217287156	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217288153	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217289161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217290162	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217291167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217292167	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217293161	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217294175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217295164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217296174	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217252065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0899	1716217252065	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217253068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217253068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0907	1716217253068	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217254070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217254070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0907	1716217254070	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217255071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217255071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0907	1716217255071	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217256073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217256073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217256073	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217257075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217257075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217257075	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217258077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217258077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217258077	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217259079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217259079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.093	1716217259079	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217260080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217260080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.093	1716217260080	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217261082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217261082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.093	1716217261082	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217262085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217262085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896999999999997	1716217262085	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217263086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217263086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896999999999997	1716217263086	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217264088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217264088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0896999999999997	1716217264088	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217265092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217265092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217265092	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217266095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217266095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217266095	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217267097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217267097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217267097	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217268099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217268099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217268099	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217269101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217269101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217269101	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217270103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.7	1716217270103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217270103	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217271105	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217271105	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217271105	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217272107	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217272107	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217272107	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217273109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217273109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0916	1716217273109	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217274111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217274111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921999999999996	1716217274111	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217275112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217275112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921999999999996	1716217275112	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217276114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217276114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921999999999996	1716217276114	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217277116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217277116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0914	1716217277116	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217278118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217278118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0914	1716217278118	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217279120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217279120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0914	1716217279120	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217280122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217280122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217280122	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217281124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217281124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217281124	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217282126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217282126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217282126	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217283127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217283127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0944000000000003	1716217283127	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217284130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217284130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0944000000000003	1716217284130	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217285131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217285131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0944000000000003	1716217285131	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217286133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217286133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217286133	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217287135	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217287135	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217287135	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217288137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217288137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911	1716217288137	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217289139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217289139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217289139	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217290141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217290141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217290141	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217291143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217291143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0902	1716217291143	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217292144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217292144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217292144	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217293146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217293146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217293146	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217294148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217294148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217294148	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217295150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217295150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217295150	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217296152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217296152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217296152	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217297155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217297155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217297155	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217298157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217298157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217298157	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217299159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217299159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217299159	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217300160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217300160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0928	1716217300160	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217301163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217301163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217301163	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217302164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217302164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217302164	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217303166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217303166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0921	1716217303166	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217304168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217304168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217304168	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217305170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217305170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217305170	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217306171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217306171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217306171	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217307173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217307173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0893	1716217307173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217308175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217308175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0893	1716217308175	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217309177	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217309177	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0893	1716217309177	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217310179	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217310179	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217310179	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217311181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217311181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217311181	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217312183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217312183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0911999999999997	1716217312183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217313185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217313185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0942	1716217313185	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217314186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217314186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0942	1716217314186	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217315188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217315188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0942	1716217315188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217316190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217297176	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217298172	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217299173	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217300183	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217301190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217302187	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217303188	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217304189	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217305190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217306193	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217307195	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217308190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217309201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217310201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217311203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217312205	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217313198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217314208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217315210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217316212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217317213	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217318208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217319216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217320212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217321222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217322222	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217323224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217324218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217325227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217326229	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217327232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217328238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217329227	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217330238	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217331241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217332240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217333235	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217334246	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217335240	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217336244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217337244	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217338243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217339253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217340255	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217341256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217342262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217343253	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217344254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217345266	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217346264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217347269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217348265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217349271	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217350273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217351275	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217352279	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217353281	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217354274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217355286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217356285	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217357287	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217358289	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217359283	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217360299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217361299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217316190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.095	1716217316190	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217317192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217317192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.095	1716217317192	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217318194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217318194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.095	1716217318194	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217319196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217319196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217319196	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217320198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217320198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217320198	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217321200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217321200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217321200	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217322201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217322201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217322201	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217323203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217323203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217323203	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217324204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217324204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0951	1716217324204	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217325206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217325206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0975	1716217325206	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217326208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217326208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0975	1716217326208	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217327210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217327210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0975	1716217327210	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217328212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217328212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0957	1716217328212	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217329214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217329214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0957	1716217329214	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217330216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217330216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0957	1716217330216	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217331218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217331218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0945	1716217331218	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217332220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217332220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0945	1716217332220	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217333221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217333221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0945	1716217333221	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217334223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217334223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0943	1716217334223	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217335224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217335224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0943	1716217335224	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217336226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217336226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0943	1716217336226	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217337228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217337228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0947	1716217337228	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217338230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217338230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0947	1716217338230	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217339232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217339232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0947	1716217339232	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217340234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217340234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217340234	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217341236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217341236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217341236	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217342237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217342237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0949	1716217342237	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217343239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217343239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.096	1716217343239	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217344241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217344241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.096	1716217344241	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217345243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217345243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.096	1716217345243	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217346245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217346245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217346245	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217347247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217347247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217347247	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217348249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217348249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217348249	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217349251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217349251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217349251	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217350252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217350252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217350252	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217351254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217351254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.097	1716217351254	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217352256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217352256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0936	1716217352256	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217353258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217353258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0936	1716217353258	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217354260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217354260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0936	1716217354260	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217355262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217355262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0961	1716217355262	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217356264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217356264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0961	1716217356264	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217357265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217357265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0961	1716217357265	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217358267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217358267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0955	1716217358267	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217359269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217359269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0955	1716217359269	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217360273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217360273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0955	1716217360273	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217361274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217361274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0985	1716217361274	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217362277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217362277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0985	1716217362277	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217363278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217363278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0985	1716217363278	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217364280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217364280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0963000000000003	1716217364280	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217365282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.4	1716217365282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0963000000000003	1716217365282	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217366284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217366284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0963000000000003	1716217366284	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217367286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217367286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217367286	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217368288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217368288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217368288	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217369290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217369290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217369290	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217370292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217370292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217370292	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217371294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217371294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217371294	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217372296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217372296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0973	1716217372296	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217373298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217373298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0981	1716217373298	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217374299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217374299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0981	1716217374299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217375301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217375301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0981	1716217375301	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217376303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217376303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0982	1716217376303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217377304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217377304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0982	1716217377304	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217378306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217378306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0982	1716217378306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217379308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217379308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1003000000000003	1716217379308	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217380310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217362300	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217363299	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217364303	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217365307	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217366306	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217367307	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217368310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217369307	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217370313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217371315	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217372316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217373318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217374313	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217375324	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217376323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217377325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217378328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217379329	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217380332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217381333	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217382337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217383337	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217384332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217385344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217386341	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217387344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217388347	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217389340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217390352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217391354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217392353	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217393357	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217634814	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217635824	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217636829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217637821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217638822	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217639833	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217640828	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217641838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217642829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217643835	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217644840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217645845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217646844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217647840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217648827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217648849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217649829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217649829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1194	1716217649829	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217649849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217650830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217650830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1194	1716217650830	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217650843	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217651832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217651832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1194	1716217651832	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217651852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217652834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217652834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217652834	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217652847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217653836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.3	1716217380310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1003000000000003	1716217380310	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217381312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9	1716217381312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1003000000000003	1716217381312	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217382314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217382314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1007	1716217382314	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217383316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217383316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1007	1716217383316	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217384318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217384318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1007	1716217384318	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217385319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217385319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0978000000000003	1716217385319	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217386321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217386321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0978000000000003	1716217386321	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217387323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217387323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0978000000000003	1716217387323	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217388325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217388325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.098	1716217388325	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217389327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217389327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.098	1716217389327	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217390328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217390328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.098	1716217390328	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217391330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217391330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1063	1716217391330	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217392332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217392332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1063	1716217392332	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217393334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217393334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1063	1716217393334	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217394336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217394336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217394336	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217394358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217395338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217395338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217395338	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217395358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217396340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217396340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217396340	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217396362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217397342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217397342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0939	1716217397342	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217397364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217398344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217398344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0939	1716217398344	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217398358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217399346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217399346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.0939	1716217399346	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217399368	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217400369	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217401363	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217402374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217403371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217404379	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217405380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217406380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217407375	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217408378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217409387	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217410389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217411390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217412383	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217413393	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217414389	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217415397	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217416402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217417402	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217418403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217419400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217420408	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217421409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217422413	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217423406	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217424416	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217425420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217426418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217427423	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217428424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217429427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217430420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217431421	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217432433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217433424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217434437	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217435440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217436440	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217437443	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217438446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217439446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217440449	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217441450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217442454	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217443450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217444458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217445458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217446461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217447465	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217448458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217449470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217450461	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217451466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217452473	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217453475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217454478	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217455480	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217456481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217457484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217458484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217459488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217460493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217461484	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217462494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217463494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217400348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217400348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1038	1716217400348	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217401349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217401349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1038	1716217401349	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217402352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217402352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1038	1716217402352	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217403354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217403354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217403354	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217404356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217404356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217404356	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217405358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217405358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217405358	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217406360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217406360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1059	1716217406360	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217407362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217407362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1059	1716217407362	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217408364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217408364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1059	1716217408364	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217409365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217409365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041999999999996	1716217409365	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217410367	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217410367	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041999999999996	1716217410367	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217411369	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217411369	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041999999999996	1716217411369	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217412371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217412371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1064000000000003	1716217412371	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217413373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217413373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1064000000000003	1716217413373	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217414374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217414374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1064000000000003	1716217414374	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217415376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.1	1716217415376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217415376	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217416378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.4	1716217416378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217416378	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217417380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217417380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217417380	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217418382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217418382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217418382	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217419384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217419384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217419384	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217420386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217420386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1061	1716217420386	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217421388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217421388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217421388	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217422390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217422390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217422390	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217423392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217423392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1041	1716217423392	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217424394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217424394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1044	1716217424394	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217425396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217425396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1044	1716217425396	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217426398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217426398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1044	1716217426398	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217427400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217427400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1053	1716217427400	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217428401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217428401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1053	1716217428401	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217429403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217429403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1053	1716217429403	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217430405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217430405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1055	1716217430405	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217431407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217431407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1055	1716217431407	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217432409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217432409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1055	1716217432409	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217433411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217433411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1071	1716217433411	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217434414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217434414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1071	1716217434414	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217435418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217435418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1071	1716217435418	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217436420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217436420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1077	1716217436420	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217437422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217437422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1077	1716217437422	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217438424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217438424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1077	1716217438424	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217439425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217439425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1066	1716217439425	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217440427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217440427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1066	1716217440427	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217441429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217441429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1066	1716217441429	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217442431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217442431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1043000000000003	1716217442431	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217443433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217443433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1043000000000003	1716217443433	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217444435	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217444435	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1043000000000003	1716217444435	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217445438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217445438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1052	1716217445438	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217446439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217446439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1052	1716217446439	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217447441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217447441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1052	1716217447441	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217448444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217448444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1078	1716217448444	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217449446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217449446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1078	1716217449446	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217450448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217450448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1078	1716217450448	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217451450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217451450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.108	1716217451450	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217452451	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217452451	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.108	1716217452451	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217453455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217453455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.108	1716217453455	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217454456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217454456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217454456	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217455458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217455458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217455458	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217456460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217456460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1088	1716217456460	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217457462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217457462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1073000000000004	1716217457462	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217458464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217458464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1073000000000004	1716217458464	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217459466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217459466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1073000000000004	1716217459466	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217460468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217460468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1086	1716217460468	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217461470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217461470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1086	1716217461470	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217462472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217462472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1086	1716217462472	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217463474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217463474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1094	1716217463474	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217464475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217464475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1094	1716217464475	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217465477	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217465477	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1094	1716217465477	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217466479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217466479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096	1716217466479	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217467481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217467481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096	1716217467481	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217468483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217468483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096	1716217468483	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217469485	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217469485	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1111999999999997	1716217469485	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217470487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.9	1716217470487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1111999999999997	1716217470487	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217471488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217471488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1111999999999997	1716217471488	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217472491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217472491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121999999999996	1716217472491	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217473493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217473493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121999999999996	1716217473493	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217474494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217474494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121999999999996	1716217474494	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217475496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217475496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115999999999997	1716217475496	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217476498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217476498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115999999999997	1716217476498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217477500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217477500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115999999999997	1716217477500	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217478502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217478502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217478502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217479503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217479503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217479503	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217480505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217480505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217480505	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217481507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217481507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217481507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217482509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217482509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217482509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217483511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217483511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1121	1716217483511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217484513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217484513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217484513	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217485515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217464495	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217465498	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217466499	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217467502	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217468504	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217469508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217470507	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217471509	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217472511	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217473508	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217474516	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217475518	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217476520	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217477521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217478515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217479524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217480527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217481532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217482532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217483534	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217484533	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217485537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217486538	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217487542	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217488544	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217489537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217490545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217491547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217492550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217493550	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217494547	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217495557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217496558	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217497555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217498563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217499565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217500567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217501569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217502569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217503574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217504569	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217505579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217506579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217507580	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217508582	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217509578	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217510581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217511588	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217512590	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217513583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217514591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217515596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217516598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217517598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217518594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217519602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217520607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217521607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217522607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217523603	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217524611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217525618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217526614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217527617	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217528612	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217485515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217485515	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217486517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217486517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217486517	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217487519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217487519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115	1716217487519	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217488521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217488521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115	1716217488521	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217489522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217489522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1115	1716217489522	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217490524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217490524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096999999999997	1716217490524	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217491527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217491527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096999999999997	1716217491527	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217492529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217492529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1096999999999997	1716217492529	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217493531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217493531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1107	1716217493531	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217494532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217494532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1107	1716217494532	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217495535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217495535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1107	1716217495535	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217496537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217496537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217496537	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217497539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217497539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217497539	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217498541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217498541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217498541	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217499543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217499543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217499543	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217500545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217500545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217500545	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217501546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217501546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.11	1716217501546	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217502548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217502548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1109	1716217502548	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217503551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217503551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1109	1716217503551	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217504553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217504553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1109	1716217504553	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217505555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217505555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.113	1716217505555	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217506557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217506557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.113	1716217506557	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217507559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217507559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.113	1716217507559	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217508561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217508561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1105	1716217508561	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217509563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217509563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1105	1716217509563	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217510565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217510565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1105	1716217510565	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217511567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217511567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217511567	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217512568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217512568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217512568	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217513570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217513570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217513570	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217514571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217514571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217514571	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217515574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217515574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217515574	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217516575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217516575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217516575	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217517577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217517577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217517577	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217518579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217518579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217518579	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217519581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217519581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217519581	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217520583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217520583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217520583	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217521585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217521585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217521585	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217522587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217522587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217522587	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217523589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217523589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217523589	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217524591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217524591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217524591	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217525593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217525593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1128	1716217525593	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217526594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217526594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217526594	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217527596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217527596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217527596	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217528598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217528598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217528598	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217529600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217529600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1143	1716217529600	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217530602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217530602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1143	1716217530602	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217531604	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217531604	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1143	1716217531604	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217532607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217532607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1139	1716217532607	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217533609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217533609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1139	1716217533609	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217534611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217534611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1139	1716217534611	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217535613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217535613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217535613	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217536614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217536614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217536614	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217537616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217537616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217537616	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217538618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217538618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217538618	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217539620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217539620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217539620	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217540622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217540622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217540622	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217541624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217541624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217541624	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217542626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217542626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217542626	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217543628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217543628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217543628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217544630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217544630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217544630	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217545631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217545631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217545631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217546634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217546634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217546634	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217547636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217547636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217547636	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217548638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217548638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217548638	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217549640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217529621	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217530623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217531625	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217532628	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217533623	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217534632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217535635	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217536640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217537631	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217538632	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217539641	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217540645	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217541650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217542648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217543650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217544652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217545651	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217546656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217547659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217548663	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217549656	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217550665	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217551667	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217552659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217553669	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217554664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217555674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217556675	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217557677	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217558682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217559682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217560681	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217561684	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217562685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217563679	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217564683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217565694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217566694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217567694	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217568697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217569691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217570703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217571703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217572705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217573706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217574708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217575709	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217576712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217577709	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217578710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217579719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217580720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217581721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217582719	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217583718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217584729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217585729	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217586732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217587727	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217588736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217589737	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217590741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217591741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217592735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217593735	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.5	1716217549640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1142	1716217549640	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217550642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.2	1716217550642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217550642	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217551644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217551644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217551644	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217552646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217552646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1146	1716217552646	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217553648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217553648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217553648	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217554650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217554650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217554650	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217555652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217555652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136	1716217555652	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217556653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217556653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217556653	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217557655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217557655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217557655	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217558658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	8	1716217558658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1158	1716217558658	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217559659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217559659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217559659	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217560661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217560661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217560661	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217561662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217561662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217561662	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217562664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217562664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217562664	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217563666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217563666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217563666	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217564668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217564668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.114	1716217564668	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217565670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217565670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217565670	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217566672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217566672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217566672	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217567674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217567674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1145	1716217567674	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217568676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217568676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1166	1716217568676	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217569678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217569678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1166	1716217569678	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217570680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217570680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1166	1716217570680	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217571682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217571682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217571682	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217572683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217572683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217572683	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217573685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217573685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217573685	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217574687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217574687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217574687	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217575689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217575689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217575689	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217576691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217576691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217576691	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217577693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217577693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1170999999999998	1716217577693	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217578695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217578695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1170999999999998	1716217578695	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217579697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217579697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1170999999999998	1716217579697	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217580699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217580699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1154	1716217580699	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217581701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217581701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1154	1716217581701	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217582703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217582703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1154	1716217582703	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217583705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217583705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217583705	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217584706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217584706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217584706	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217585708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217585708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217585708	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217586710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217586710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217586710	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217587712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217587712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217587712	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217588714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217588714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1167	1716217588714	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217589716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217589716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1176	1716217589716	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217590718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217590718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1176	1716217590718	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217591720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217591720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1176	1716217591720	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217592721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217592721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217592721	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217593723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217593723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217593723	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217594724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217594724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217594724	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217595726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217595726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217595726	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217596728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217596728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217596728	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217597730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217597730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1178000000000003	1716217597730	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217598732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217598732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1148000000000002	1716217598732	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	99	1716217599734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217599734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1148000000000002	1716217599734	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217600736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217600736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1148000000000002	1716217600736	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217601738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217601738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1165	1716217601738	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217602740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217602740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1165	1716217602740	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217603741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217603741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1165	1716217603741	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217604743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217604743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217604743	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217605745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217605745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217605745	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217606746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217606746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.116	1716217606746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217607748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217607748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217607748	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217608750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217608750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217608750	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217609752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217609752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217609752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217610754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217610754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217610754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217611756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217611756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217611756	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217612758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217612758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217612758	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217613760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217594746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217595747	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217596751	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217597744	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217598746	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217599754	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217600757	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217601760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217602752	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217603762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217604765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217605771	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217606771	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217607762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217608764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217609765	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217610775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217611777	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217612773	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217613774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217614775	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217615788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217616788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217617779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217618781	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217619790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217620786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217621799	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217622789	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217623792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217624801	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217625805	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217626806	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217627800	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217628803	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217629811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217630812	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217631815	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217632810	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217633813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1206	1716217639809	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217640811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217640811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217640811	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217641813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217641813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217641813	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217642816	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217642816	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217642816	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217643818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217643818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1187	1716217643818	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217644819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217644819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1187	1716217644819	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	4	1716217645821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217645821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1187	1716217645821	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217646823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217646823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217646823	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217647825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3.4	1716217647825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217647825	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217613760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217613760	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217614761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217614761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217614761	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217615762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217615762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217615762	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217616764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217616764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217616764	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217617766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217617766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217617766	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217618768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217618768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217618768	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217619770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217619770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201999999999996	1716217619770	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	104	1716217620772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217620772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201999999999996	1716217620772	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	100	1716217621774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217621774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201999999999996	1716217621774	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	103	1716217622776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217622776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217622776	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217623778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217623778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217623778	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	102	1716217624779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217624779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1182	1716217624779	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	101	1716217625783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217625783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1208	1716217625783	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	59	1716217626784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217626784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1208	1716217626784	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217627786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217627786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1208	1716217627786	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217628788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217628788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1209000000000002	1716217628788	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217629790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217629790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1209000000000002	1716217629790	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217630792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217630792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1209000000000002	1716217630792	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217631794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217631794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217631794	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217632796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217632796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217632796	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217633798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217633798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.12	1716217633798	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217648827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217648827	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217653836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217653836	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217654838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217654838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217654838	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217655840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217655840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1205	1716217655840	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217656842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217656842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1205	1716217656842	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217657844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217657844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1205	1716217657844	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217658845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	1.7	1716217658845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1204	1716217658845	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217659847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217659847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1204	1716217659847	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217660849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217660849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1204	1716217660849	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217661851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217661851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217661851	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217662853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217662853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217662853	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217663855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217663855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217663855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217664857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217664857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217664857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217665858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217665858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217665858	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217666860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217666860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1172	1716217666860	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217667862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217667862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1193	1716217667862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217668864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217668864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1193	1716217668864	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217669866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217669866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1193	1716217669866	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217670868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217670868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217670868	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217671870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	7.6	1716217671870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217671870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217672872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217672872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195	1716217672872	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217673874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217673874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217673874	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217674875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217674875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217653852	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217654855	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217655863	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217656862	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217657857	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217658859	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217659867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217660870	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217661875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217662867	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217663877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217664876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217665880	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217666881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217667876	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217668878	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217669888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217670892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217671891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217672886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217673892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217674898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217675891	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217676901	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217677898	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217678905	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217679906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217680909	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217681910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217682903	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217683907	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217684910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217685918	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217686920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217687915	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217688919	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217689921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217690928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217691929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217692927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217674875	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217675877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217675877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1195999999999997	1716217675877	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	4	1716217676879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217676879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217676879	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217677881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217677881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217677881	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217678883	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217678883	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1212	1716217678883	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217679885	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217679885	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217679885	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217680886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217680886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217680886	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217681888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217681888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1189	1716217681888	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217682890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217682890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136999999999997	1716217682890	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217683892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217683892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136999999999997	1716217683892	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217684894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217684894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1136999999999997	1716217684894	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217685897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217685897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1164	1716217685897	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217686899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217686899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1164	1716217686899	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217687900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217687900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1164	1716217687900	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217688902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217688902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217688902	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217689904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217689904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217689904	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217690906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217690906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217690906	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217691908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217691908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217691908	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217692910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217692910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217692910	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217693912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217693912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1175	1716217693912	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217693925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217694914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217694914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217694914	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217694929	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217695916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217695916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217695916	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217696917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217696917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1191	1716217696917	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217697920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217697920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217697920	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217698921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217698921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217698921	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217699923	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	9.299999999999999	1716217699923	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217699923	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217700925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217700925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217700925	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217701927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217701927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217701927	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217702928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217702928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217702928	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217703931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217703931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1062	1716217703931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217704932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217704932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1062	1716217704932	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217705934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217705934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1062	1716217705934	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217706936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217706936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217706936	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217707938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217707938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217707938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217708940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217708940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1215	1716217708940	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217709942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217709942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1221	1716217709942	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217710944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217710944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1221	1716217710944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217711946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217711946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1221	1716217711946	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217712948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217712948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217712948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217713949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217713949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217713949	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217714951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217714951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1201	1716217714951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217715953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217715953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.121	1716217715953	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217716955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217716955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217695931	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217696938	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217697935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217698935	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217699948	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217700950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217701950	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217702943	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217703944	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217704954	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217705955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217706957	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217707951	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217708962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217709963	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217710965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217711967	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217712960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217713965	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217714972	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217715975	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217716977	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217717970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217718973	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217719981	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217720983	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217721987	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217722978	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217723988	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Swap Memory GB	0.0005	1716217724991	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.121	1716217716955	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217717956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217717956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.121	1716217717956	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	3	1716217718958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217718958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1224000000000003	1716217718958	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	1	1716217719960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217719960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1224000000000003	1716217719960	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217720962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217720962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1224000000000003	1716217720962	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217721964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217721964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217721964	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217722966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217722966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217722966	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217723968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	4.7	1716217723968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1203000000000003	1716217723968	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - CPU Utilization	2	1716217724970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Utilization	3	1716217724970	97fe05eab4e0416292aaa559f52e3856	0	f
TOP - Memory Usage GB	2.1207	1716217724970	97fe05eab4e0416292aaa559f52e3856	0	f
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
letter	0	3f0b5c131552429d98450a9bb08ee4aa
workload	0	3f0b5c131552429d98450a9bb08ee4aa
listeners	smi+top+dcgmi	3f0b5c131552429d98450a9bb08ee4aa
params	'"-"'	3f0b5c131552429d98450a9bb08ee4aa
file	cifar10.py	3f0b5c131552429d98450a9bb08ee4aa
workload_listener	''	3f0b5c131552429d98450a9bb08ee4aa
letter	0	97fe05eab4e0416292aaa559f52e3856
workload	0	97fe05eab4e0416292aaa559f52e3856
listeners	smi+top+dcgmi	97fe05eab4e0416292aaa559f52e3856
params	'"-"'	97fe05eab4e0416292aaa559f52e3856
file	cifar10.py	97fe05eab4e0416292aaa559f52e3856
workload_listener	''	97fe05eab4e0416292aaa559f52e3856
model	cifar10.py	97fe05eab4e0416292aaa559f52e3856
manual	False	97fe05eab4e0416292aaa559f52e3856
max_epoch	5	97fe05eab4e0416292aaa559f52e3856
max_time	172800	97fe05eab4e0416292aaa559f52e3856
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
3f0b5c131552429d98450a9bb08ee4aa	adventurous-roo-745	UNKNOWN			daga	FAILED	1716214961092	1716215004512		active	s3://mlflow-storage/0/3f0b5c131552429d98450a9bb08ee4aa/artifacts	0	\N
97fe05eab4e0416292aaa559f52e3856	(0 0) agreeable-jay-464	UNKNOWN			daga	FINISHED	1716215057765	1716217726032		active	s3://mlflow-storage/0/97fe05eab4e0416292aaa559f52e3856/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	3f0b5c131552429d98450a9bb08ee4aa
mlflow.source.name	file:///home/daga/radt#examples/pytorch	3f0b5c131552429d98450a9bb08ee4aa
mlflow.source.type	PROJECT	3f0b5c131552429d98450a9bb08ee4aa
mlflow.project.entryPoint	main	3f0b5c131552429d98450a9bb08ee4aa
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	3f0b5c131552429d98450a9bb08ee4aa
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3f0b5c131552429d98450a9bb08ee4aa
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3f0b5c131552429d98450a9bb08ee4aa
mlflow.runName	adventurous-roo-745	3f0b5c131552429d98450a9bb08ee4aa
mlflow.project.env	conda	3f0b5c131552429d98450a9bb08ee4aa
mlflow.project.backend	local	3f0b5c131552429d98450a9bb08ee4aa
mlflow.user	daga	97fe05eab4e0416292aaa559f52e3856
mlflow.source.name	file:///home/daga/radt#examples/pytorch	97fe05eab4e0416292aaa559f52e3856
mlflow.source.type	PROJECT	97fe05eab4e0416292aaa559f52e3856
mlflow.project.entryPoint	main	97fe05eab4e0416292aaa559f52e3856
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	97fe05eab4e0416292aaa559f52e3856
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	97fe05eab4e0416292aaa559f52e3856
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	97fe05eab4e0416292aaa559f52e3856
mlflow.project.env	conda	97fe05eab4e0416292aaa559f52e3856
mlflow.project.backend	local	97fe05eab4e0416292aaa559f52e3856
mlflow.runName	(0 0) agreeable-jay-464	97fe05eab4e0416292aaa559f52e3856
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

