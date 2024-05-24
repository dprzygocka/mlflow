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
0	Default	s3://mlflow-storage/0	active	1716187854076	1716187854076
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
SMI - Power Draw	14.87	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
SMI - Timestamp	1716188113.562	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
SMI - GPU Util	0	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
SMI - Mem Util	0	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
SMI - Mem Used	0	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
SMI - Performance State	3	1716188113581	0	f	f53cd78db9f44607baede536bdbcdee4
TOP - CPU Utilization	104	1716188880454	0	f	f53cd78db9f44607baede536bdbcdee4
TOP - Memory Usage GB	1.8251	1716188880454	0	f	f53cd78db9f44607baede536bdbcdee4
TOP - Memory Utilization	7.1000000000000005	1716188880454	0	f	f53cd78db9f44607baede536bdbcdee4
TOP - Swap Memory GB	0.002	1716188880484	0	f	f53cd78db9f44607baede536bdbcdee4
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.87	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
SMI - Timestamp	1716188113.562	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
SMI - GPU Util	0	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
SMI - Mem Util	0	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
SMI - Mem Used	0	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
SMI - Performance State	3	1716188113581	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	0	1716188113617	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	0	1716188113617	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.1558	1716188113617	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188113633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	160	1716188114619	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	8.3	1716188114619	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.1558	1716188114619	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188114643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188115622	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188115622	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.1558	1716188115622	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188115639	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188116624	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188116624	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3817000000000002	1716188116624	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188116641	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188117626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188117626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3817000000000002	1716188117626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188117653	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188118628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188118628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3817000000000002	1716188118628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188118649	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188119631	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188119631	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.386	1716188119631	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188119658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188120633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188120633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.386	1716188120633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188120659	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188121635	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188121635	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.386	1716188121635	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188121662	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188122638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188122638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188122638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188122665	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188123640	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188123640	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188123640	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188123661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188124643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188124643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188124643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188124669	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188125645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188125645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3864	1716188125645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188125673	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188126647	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188126647	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3864	1716188126647	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188126676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188127650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188127650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3864	1716188127650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188127679	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188128683	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188129681	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188130689	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188131694	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188132690	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188133694	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188134694	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188135699	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188136705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188137705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188138699	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188139703	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188140714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188141715	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188142716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188143724	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188144728	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188145729	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188146725	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188147726	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188148731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188149732	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188150736	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188151737	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188152740	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188153744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188154744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188155743	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188156756	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.0013	1716188157749	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188158753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188159753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188160763	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188161768	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188162757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188163772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188164770	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188165777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188166780	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188167775	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188168786	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188169786	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188170791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188171795	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188413349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188413349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8035999999999999	1716188413349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188414351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188414351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8035999999999999	1716188414351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188415353	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188415353	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8035999999999999	1716188415353	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188416355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188416355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188416355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188417357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188417357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188417357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188418360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188418360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188418360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188419363	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188419363	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188128653	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188128653	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862	1716188128653	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188129656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188129656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862	1716188129656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188130658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188130658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862	1716188130658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188131661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188131661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862999999999999	1716188131661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188132663	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188132663	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862999999999999	1716188132663	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188133666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188133666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3862999999999999	1716188133666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188134668	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188134668	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3851	1716188134668	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188135671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188135671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3851	1716188135671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188136674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188136674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3851	1716188136674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188137676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188137676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.385	1716188137676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188138679	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.2	1716188138679	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.385	1716188138679	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188139682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188139682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.385	1716188139682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188140684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188140684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.384	1716188140684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188141686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188141686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.384	1716188141686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188142689	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188142689	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.384	1716188142689	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188143692	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188143692	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3845	1716188143692	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188144695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188144695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3845	1716188144695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188145697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188145697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3845	1716188145697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188146700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188146700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3839000000000001	1716188146700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	108	1716188147702	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188147702	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3839000000000001	1716188147702	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188148705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188148705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3839000000000001	1716188148705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	107	1716188149707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188149707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3836	1716188149707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188150709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188150709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3836	1716188150709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188151711	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188151711	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3836	1716188151711	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188152714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188152714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3848	1716188152714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	108	1716188153716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188153716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3848	1716188153716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188154719	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188154719	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3848	1716188154719	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188155721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188155721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188155721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188156724	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188156724	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188156724	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188157731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188157731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.3859000000000001	1716188157731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188158733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188158733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.5723	1716188158733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188159735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188159735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.5723	1716188159735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188160738	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188160738	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.5723	1716188160738	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188161740	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188161740	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7880999999999998	1716188161740	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188162741	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188162741	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7880999999999998	1716188162741	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188163746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188163746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7880999999999998	1716188163746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188164748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188164748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.793	1716188164748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188165751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188165751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.793	1716188165751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188166753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188166753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.793	1716188166753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188167755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188167755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7926	1716188167755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188168758	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188168758	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7926	1716188168758	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188169760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188169760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7926	1716188169760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188170762	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188170762	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7942	1716188170762	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188171765	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188171765	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7942	1716188171765	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188172768	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188172768	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7942	1716188172768	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188172787	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188173770	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188173770	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7882	1716188173770	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188173789	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188174772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188174772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7882	1716188174772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188174794	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188175774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188175774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7882	1716188175774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188175791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188176777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188176777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7888	1716188176777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188176795	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188177779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188177779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7888	1716188177779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188177799	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188178782	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188178782	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7888	1716188178782	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188178810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188179784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188179784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7883	1716188179784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188179811	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188180787	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188180787	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7883	1716188180787	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188180806	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188181789	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188181789	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7883	1716188181789	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188181815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188182791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188182791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7898	1716188182791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188182811	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188183794	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188183794	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7898	1716188183794	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188183823	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188184796	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188184796	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7898	1716188184796	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188184822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188185798	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188185798	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188185798	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188185824	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188186801	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188186801	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188186801	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188186831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188187803	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188187803	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188187803	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188188805	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188188805	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7949000000000002	1716188188805	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188189807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188189807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7949000000000002	1716188189807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188190810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188190810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7949000000000002	1716188190810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188191811	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188191811	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.795	1716188191811	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188192815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188192815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.795	1716188192815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188193818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188193818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.795	1716188193818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188194820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188194820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7899	1716188194820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188195822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188195822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7899	1716188195822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188196826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188196826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7899	1716188196826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188197829	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188197829	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188197829	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188198831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188198831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188198831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188199834	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188199834	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7914	1716188199834	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188200836	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188200836	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7905	1716188200836	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188201839	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188201839	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7905	1716188201839	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188202841	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188202841	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7905	1716188202841	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188203844	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188203844	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7937	1716188203844	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188204846	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188204846	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7937	1716188204846	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188205848	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188205848	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7937	1716188205848	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188206850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188206850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7943	1716188206850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188207853	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188207853	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7943	1716188207853	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188208855	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188187831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188188825	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188189827	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188190831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188191831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188192834	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188193846	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188194844	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188195847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188196855	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188197845	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188198858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188199861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188200863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188201867	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188202867	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188203866	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188204874	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188205876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188206873	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188207880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188208881	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188209886	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188210893	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188211882	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188212894	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188213897	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188214899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188215898	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188216891	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188217904	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188218908	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188219911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188220915	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188221916	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188222914	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188223923	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188224924	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188225922	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188226927	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188227930	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188228934	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188229933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188230935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188231935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188413377	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188414376	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188415380	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188416382	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188417380	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188418379	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188419390	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188420392	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188421393	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188422389	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188423396	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188424400	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188425402	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188426408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188427411	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188428408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188429417	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188430416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188431420	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188432412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188208855	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7943	1716188208855	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188209858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188209858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7967	1716188209858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188210861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188210861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7967	1716188210861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188211863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188211863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7967	1716188211863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188212866	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188212866	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7865	1716188212866	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188213868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188213868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7865	1716188213868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188214870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188214870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7865	1716188214870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188215872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188215872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7897	1716188215872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188216873	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188216873	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7897	1716188216873	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188217876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188217876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7897	1716188217876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188218880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188218880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7923	1716188218880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188219884	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188219884	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7923	1716188219884	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188220886	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188220886	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7923	1716188220886	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188221889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188221889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7939	1716188221889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188222892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188222892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7939	1716188222892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188223895	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188223895	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7939	1716188223895	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188224896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188224896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7957	1716188224896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188225905	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.2	1716188225905	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7957	1716188225905	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188226907	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188226907	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7957	1716188226907	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188227909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188227909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7986	1716188227909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188228911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188228911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7986	1716188228911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188229913	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188229913	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7986	1716188229913	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188230916	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188230916	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7965	1716188230916	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188231917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188231917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7965	1716188231917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188232920	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188232920	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7965	1716188232920	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188232946	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188233922	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188233922	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7964	1716188233922	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188234020	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188234924	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188234924	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7964	1716188234924	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188234954	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	110	1716188235927	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188235927	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7964	1716188235927	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188235956	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188236929	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188236929	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7959	1716188236929	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188236959	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188237931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188237931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7959	1716188237931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188237950	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188238933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188238933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7959	1716188238933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188238961	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188239935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188239935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188239935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188239962	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188240937	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188240937	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188240937	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188240967	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188241940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188241940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188241940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188241970	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188242942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188242942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7987	1716188242942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188242961	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188243945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188243945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7987	1716188243945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188243977	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188244947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188244947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7987	1716188244947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188244978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188245949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188245949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188245949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188245975	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188246951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188246951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188246951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188247953	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188247953	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188247953	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188248955	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188248955	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7995	1716188248955	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188249957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188249957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7995	1716188249957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188250960	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188250960	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7995	1716188250960	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188251962	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188251962	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7984	1716188251962	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188252964	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188252964	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7984	1716188252964	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188253966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188253966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7984	1716188253966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188254968	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188254968	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188254968	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188255970	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188255970	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188255970	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188256973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188256973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8004	1716188256973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188257975	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188257975	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7989000000000002	1716188257975	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188258978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188258978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7989000000000002	1716188258978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188259981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188259981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7989000000000002	1716188259981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188260983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188260983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188260983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188261986	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188261986	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188261986	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188262989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188262989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188262989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188263991	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188263991	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8011	1716188263991	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188264994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188264994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8011	1716188264994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188265995	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188265995	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8011	1716188265995	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	109.9	1716188266998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188266998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7955999999999999	1716188266998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188268000	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188268000	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188246983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188247971	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188248982	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188249977	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188250980	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188251987	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188252982	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188253992	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188254994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188255994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188257001	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188257995	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188259005	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188259999	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188261010	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188262011	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188263018	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188264008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188265110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188266024	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188267019	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188268027	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188269030	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188270034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188271036	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188272026	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188273028	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188274039	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188275034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188276045	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188277037	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188278048	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188279051	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188280053	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188281056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188282059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188283054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188284065	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188285069	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188286069	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188287073	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188288073	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188289077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188290081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188291083	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188292086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8052000000000001	1716188419363	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188420365	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188420365	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8052000000000001	1716188420365	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188421366	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188421366	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8052000000000001	1716188421366	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188422369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188422369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188422369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188423371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188423371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188423371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188424374	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188424374	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188424374	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188425377	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188425377	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8059	1716188425377	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7955999999999999	1716188268000	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188269002	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188269002	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7955999999999999	1716188269002	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188270004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188270004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.799	1716188270004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188271006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188271006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.799	1716188271006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188272008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188272008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.799	1716188272008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188273010	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188273010	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8002	1716188273010	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188274012	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.1	1716188274012	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8002	1716188274012	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188275014	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188275014	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188275014	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188276017	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.8	1716188276017	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188276017	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188277019	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188277019	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188277019	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188278022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188278022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188278022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188279024	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188279024	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188279024	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188280026	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188280026	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188280026	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188281029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188281029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.803	1716188281029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188282032	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188282032	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.803	1716188282032	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188283034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188283034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.803	1716188283034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188284037	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188284037	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8015	1716188284037	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188285040	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188285040	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8015	1716188285040	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188286042	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188286042	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8015	1716188286042	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188287047	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188287047	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188287047	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188288049	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188288049	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188288049	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188289052	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188289052	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188289052	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188290054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188290054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188290054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188291057	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188291057	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188291057	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188292059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188292059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188292059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188293061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188293061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188293061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188293090	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188294064	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188294064	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188294064	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188294092	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188295066	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188295066	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188295066	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188295099	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188296068	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188296068	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188296068	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188296091	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188297071	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188297071	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188297071	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188297089	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188298072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188298072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188298072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188298100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188299074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.300000000000001	1716188299074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188299074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188299103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188300077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188300077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188300077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188300106	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188301079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188301079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188301079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188301107	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188302081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188302081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188302081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188302100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188303083	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188303083	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188303083	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188303112	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188304086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188304086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.7980999999999998	1716188304086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188304112	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188305089	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188305089	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188305089	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188305115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188306092	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188306092	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188306092	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188306118	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188307121	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188308123	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188309125	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188310129	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188311130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188312125	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188313134	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188314139	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188315137	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188316142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188317138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188318145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188319149	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188320142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188321157	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188322160	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188323162	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188324164	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188325168	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188326172	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188327161	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188328170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188329173	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188330178	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188331177	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188332173	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188333188	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188334185	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188335188	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188336193	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188337192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188338199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188339196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188340201	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188341199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188342196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188343209	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188344210	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188345214	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188346216	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188347210	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188348224	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188349222	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188350225	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188351230	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188352230	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188426379	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188426379	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8059	1716188426379	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188427382	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188427382	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8059	1716188427382	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188428384	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188428384	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188428384	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188429386	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188429386	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188429386	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188430388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188430388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188430388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188431391	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188431391	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188431391	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188307094	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188307094	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8003	1716188307094	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188308097	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188308097	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188308097	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188309099	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188309099	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188309099	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188310101	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188310101	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8008	1716188310101	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188311103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188311103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8013	1716188311103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188312105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188312105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8013	1716188312105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188313108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188313108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8013	1716188313108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188314110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188314110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188314110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188315113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188315113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188315113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188316115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188316115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8027	1716188316115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188317117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188317117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188317117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188318120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188318120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188318120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188319122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188319122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188319122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188320125	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188320125	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188320125	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188321130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188321130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188321130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188322132	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188322132	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188322132	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188323134	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188323134	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188323134	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188324136	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188324136	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188324136	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188325138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188325138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188325138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188326140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188326140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188326140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188327141	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188327141	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188327141	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188328143	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188328143	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188328143	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188329145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188329145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188329145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188330148	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188330148	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188330148	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188331151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188331151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8022	1716188331151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188332154	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188332154	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188332154	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188333157	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188333157	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188333157	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188334159	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188334159	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188334159	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188335162	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188335162	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8014000000000001	1716188335162	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188336164	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188336164	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8014000000000001	1716188336164	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188337167	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188337167	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8014000000000001	1716188337167	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188338170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188338170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8020999999999998	1716188338170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188339171	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188339171	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8020999999999998	1716188339171	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188340174	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188340174	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8020999999999998	1716188340174	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188341176	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188341176	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.801	1716188341176	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188342178	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188342178	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.801	1716188342178	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188343182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188343182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.801	1716188343182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188344184	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188344184	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188344184	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188345187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188345187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188345187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188346189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188346189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188346189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188347192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188347192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188347192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188348194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188348194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188348194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188349196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188349196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8023	1716188349196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188350199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188350199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188350199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188351201	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188351201	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188351201	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188352203	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188352203	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188352203	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188353205	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188353205	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188353205	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188353233	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188354208	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188354208	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188354208	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188354237	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188355210	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188355210	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8034000000000001	1716188355210	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188355234	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188356213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188356213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188356213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188356238	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188357216	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188357216	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188357216	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188357236	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188358219	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188358219	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188358219	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188358246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188359221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188359221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188359221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188359249	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188360223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188360223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188360223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188360248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188361225	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188361225	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188361225	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188361249	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188362227	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188362227	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188362227	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188362243	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188363229	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188363229	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188363229	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188363256	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188364231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188364231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188364231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188364259	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188365234	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188365234	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8066	1716188365234	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188365262	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188366238	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188366238	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8066	1716188366238	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188367241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188367241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8066	1716188367241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188368244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188368244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188368244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188369246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188369246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188369246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188370248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188370248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188370248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188371251	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188371251	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8037	1716188371251	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188372253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188372253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8037	1716188372253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188373255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188373255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8037	1716188373255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188374257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188374257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188374257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188375261	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188375261	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188375261	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188376263	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188376263	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188376263	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188377265	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188377265	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188377265	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188378267	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188378267	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188378267	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188379269	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188379269	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8019	1716188379269	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188380272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188380272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188380272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188381274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188381274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188381274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188382277	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188382277	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8029000000000002	1716188382277	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188383280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188383280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8009000000000002	1716188383280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188384282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188384282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8009000000000002	1716188384282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188385284	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188385284	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8009000000000002	1716188385284	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188386287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188386287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8031	1716188386287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188387289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188387289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8031	1716188387289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188366262	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188367265	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188368269	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188369273	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188370276	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188371279	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188372273	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188373286	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188374286	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188375286	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188376289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188377282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188378295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188379295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188380299	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188381298	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188382302	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188383305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188384314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188385311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188386311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188387315	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188388318	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188389322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188390321	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188391327	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188392330	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188393329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188394331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188395322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188396336	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188397333	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188398342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188399345	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188400345	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188401351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188402341	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188403353	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188404356	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188405354	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188406359	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188407356	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188408366	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188409364	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188410368	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188411372	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188412375	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188432393	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188432393	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188432393	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188433395	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188433395	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188433395	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188434397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188434397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8071	1716188434397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188435399	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188435399	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8071	1716188435399	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188436401	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188436401	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8071	1716188436401	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188437403	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188437403	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8074000000000001	1716188437403	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188388291	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188388291	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8031	1716188388291	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188389293	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.300000000000001	1716188389293	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188389293	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188390295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188390295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188390295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188391297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188391297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8047	1716188391297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188392300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188392300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8054000000000001	1716188392300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188393303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188393303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8054000000000001	1716188393303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188394305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188394305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8054000000000001	1716188394305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188395307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188395307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188395307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188396309	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188396309	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188396309	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188397311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188397311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188397311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188398314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188398314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188398314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188399317	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188399317	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188399317	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188400319	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188400319	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8042	1716188400319	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188401322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188401322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188401322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188402324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188402324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188402324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188403326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188403326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188403326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188404329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188404329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188404329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188405331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188405331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188405331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188406333	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188406333	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188406333	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188407336	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188407336	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188407336	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188408338	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188408338	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188408338	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188409340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188409340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188409340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188410342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188410342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.807	1716188410342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188411345	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188411345	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.807	1716188411345	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188412347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188412347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.807	1716188412347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188433425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188434422	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188435424	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188436435	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188437426	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188438406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188438406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8074000000000001	1716188438406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188438434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188439408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188439408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8074000000000001	1716188439408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188439435	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188440410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188440410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8079	1716188440410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188440436	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188441412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188441412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8079	1716188441412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188441443	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188442414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188442414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8079	1716188442414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188442441	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188443416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188443416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188443416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188443442	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188444418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188444418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188444418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188444446	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188445421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188445421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188445421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188445452	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188446423	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188446423	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188446423	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188446451	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188447425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188447425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188447425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188447445	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188448427	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188448427	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188448427	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188448451	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188449430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188449430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188449430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188449456	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188450431	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188450431	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188450431	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188451434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188451434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.805	1716188451434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188452437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188452437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188452437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188453439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188453439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188453439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188454441	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188454441	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8062	1716188454441	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188455443	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188455443	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188455443	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188456448	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188456448	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188456448	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188457450	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188457450	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075	1716188457450	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188458452	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188458452	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188458452	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188459454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188459454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188459454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188460456	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188460456	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.808	1716188460456	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188461459	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188461459	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188461459	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188462461	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188462461	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188462461	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188463463	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188463463	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8087	1716188463463	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188464466	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188464466	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188464466	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188465468	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188465468	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188465468	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188466469	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188466469	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188466469	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188467472	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188467472	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188467472	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188468473	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188468473	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188468473	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188469476	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188469476	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188469476	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188470478	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188470478	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188470478	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188471481	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188450459	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188451465	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188452464	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188453470	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188454467	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188455469	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188456473	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188457468	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188458478	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188459481	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188460484	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188461486	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188462478	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188463479	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188464483	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188465498	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188466497	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188467493	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188468499	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188469501	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188470506	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188471509	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188833344	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188833344	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188833344	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188834347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188834347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188834347	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188835349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188835349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188835349	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188836352	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188836352	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8203	1716188836352	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188837355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188837355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8203	1716188837355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188838357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188838357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8203	1716188838357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188839360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188839360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188839360	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188840362	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188840362	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188840362	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188841364	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188841364	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188841364	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188842367	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188842367	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8224	1716188842367	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188843369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188843369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8224	1716188843369	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188844371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188844371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8224	1716188844371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188845373	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188845373	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188845373	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188846376	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188846376	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188846376	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188471481	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188471481	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188472482	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188472482	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188472482	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188472504	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188473484	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188473484	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188473484	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188473503	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188474488	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188474488	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188474488	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188474512	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188475490	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188475490	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8082	1716188475490	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188475511	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188476492	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188476492	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188476492	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188476514	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188477495	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188477495	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188477495	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188477514	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188478497	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.300000000000001	1716188478497	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8069000000000002	1716188478497	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188478525	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188479500	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188479500	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188479500	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188479526	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188480503	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188480503	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188480503	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188480529	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188481505	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188481505	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188481505	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188481534	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188482507	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188482507	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188482507	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188482525	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188483510	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188483510	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188483510	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188483528	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188484512	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188484512	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188484512	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188484538	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188485514	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188485514	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188485514	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188485531	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188486516	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188486516	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188486516	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188486540	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188487518	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188487518	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188487518	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188488521	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188488521	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188488521	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188489525	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188489525	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188489525	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188490527	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188490527	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8048	1716188490527	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188491530	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188491530	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188491530	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188492532	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188492532	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188492532	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188493534	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188493534	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188493534	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188494536	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188494536	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188494536	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188495538	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188495538	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188495538	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188496541	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.2	1716188496541	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8065	1716188496541	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188497543	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	6.9	1716188497543	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188497543	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188498544	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188498544	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188498544	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188499546	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188499546	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8080999999999998	1716188499546	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188500549	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188500549	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188500549	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188501552	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188501552	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188501552	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188502555	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188502555	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8089000000000002	1716188502555	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188503557	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188503557	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188503557	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188504561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188504561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188504561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188505563	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188505563	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188505563	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188506566	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188506566	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188506566	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188507568	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188507568	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188507568	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188508570	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188508570	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188508570	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188487544	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188488548	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188489553	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188490551	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188491550	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188492553	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188493561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188494561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188495566	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188496569	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188497561	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188498564	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188499570	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188500582	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188501571	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188502585	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188503582	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188504585	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188505588	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188506592	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188507587	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188508595	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188509596	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188510600	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188511603	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188512596	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188513607	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188514609	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188515611	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188516614	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188517618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188518619	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188519621	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188520617	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188521618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188522618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188523630	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188524632	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188525637	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188526636	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188527631	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188528647	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188529643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188530646	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188531652	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188833366	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188834365	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188835367	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188836371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188837371	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188838377	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188839379	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188840382	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188841385	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188842386	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188843389	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188844397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188845401	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188846401	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188847396	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188848400	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188849405	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188850402	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188851412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188852405	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188509572	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188509572	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188509572	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188510574	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188510574	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188510574	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188511576	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188511576	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188511576	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188512578	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188512578	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8126	1716188512578	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188513580	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188513580	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8126	1716188513580	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188514582	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188514582	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8126	1716188514582	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188515585	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188515585	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188515585	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188516587	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188516587	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188516587	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188517590	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188517590	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188517590	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188518592	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188518592	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8123	1716188518592	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188519595	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188519595	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8123	1716188519595	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188520597	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188520597	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8123	1716188520597	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188521599	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188521599	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188521599	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188522601	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188522601	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188522601	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188523604	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188523604	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188523604	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188524606	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188524606	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188524606	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188525609	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188525609	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188525609	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188526611	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188526611	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8083	1716188526611	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188527614	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188527614	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188527614	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188528616	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188528616	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188528616	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188529618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188529618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8097	1716188529618	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188530621	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188530621	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8103	1716188530621	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188531623	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188531623	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8103	1716188531623	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188532626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188532626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8103	1716188532626	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188532655	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188533628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188533628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188533628	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188533654	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188534630	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188534630	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188534630	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188534657	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188535633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188535633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188535633	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188535663	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188536636	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188536636	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8114000000000001	1716188536636	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188536653	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188537638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188537638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8114000000000001	1716188537638	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188537659	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188538641	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188538641	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8114000000000001	1716188538641	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188538670	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188539643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188539643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8108	1716188539643	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188539668	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188540645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188540645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8108	1716188540645	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188540675	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188541648	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188541648	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8108	1716188541648	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188541672	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188542650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188542650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8109000000000002	1716188542650	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188542669	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188543651	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188543651	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8109000000000002	1716188543651	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188543668	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188544654	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188544654	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8109000000000002	1716188544654	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188544680	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188545656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188545656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8111	1716188545656	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188545683	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188546658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188546658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8111	1716188546658	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188546682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188547685	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188548686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188549695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188550693	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188551694	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188552692	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188553704	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188554708	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188555713	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188556702	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188557700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188558713	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188559714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188560718	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188561719	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188562721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188563725	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188564732	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188565729	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188566724	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188567733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188568742	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188569739	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188570733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188571734	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188572744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188573749	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188574749	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188575752	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188576749	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188577757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188578757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188579762	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188580760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188581762	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188582760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188583771	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188584771	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188585764	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188586775	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188587770	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188588782	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188589775	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188590784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188591780	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188847378	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188847378	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188847378	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188848381	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188848381	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188848381	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188849383	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188849383	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188849383	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188850385	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188850385	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188850385	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188851388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188851388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8189000000000002	1716188851388	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188852389	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188852389	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8189000000000002	1716188852389	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188853390	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188547660	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188547660	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8111	1716188547660	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188548661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188548661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188548661	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188549664	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188549664	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188549664	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188550666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188550666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8085	1716188550666	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188551669	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188551669	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188551669	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188552671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188552671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188552671	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188553674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188553674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8084	1716188553674	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188554676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188554676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188554676	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188555680	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188555680	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188555680	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188556682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.400000000000001	1716188556682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188556682	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188557684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188557684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075999999999999	1716188557684	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188558686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188558686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075999999999999	1716188558686	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188559688	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188559688	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8075999999999999	1716188559688	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188560691	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188560691	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188560691	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188561693	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188561693	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188561693	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188562695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188562695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188562695	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188563697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188563697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.81	1716188563697	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188564700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188564700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.81	1716188564700	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188565703	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188565703	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.81	1716188565703	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	106	1716188566705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188566705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8125	1716188566705	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188567707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188567707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8125	1716188567707	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188568709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188568709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8125	1716188568709	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188569712	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188569712	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188569712	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188570714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188570714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188570714	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188571716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188571716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8112000000000001	1716188571716	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188572718	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188572718	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188572718	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188573721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188573721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188573721	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188574723	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188574723	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188574723	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188575726	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188575726	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8122	1716188575726	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188576728	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188576728	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8122	1716188576728	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188577730	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188577730	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8122	1716188577730	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188578731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188578731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117999999999999	1716188578731	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188579733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188579733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117999999999999	1716188579733	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188580735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188580735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117999999999999	1716188580735	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188581737	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188581737	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8143	1716188581737	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188582739	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188582739	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8143	1716188582739	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188583742	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188583742	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8143	1716188583742	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188584744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188584744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8135	1716188584744	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188585746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188585746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8135	1716188585746	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188586748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188586748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8135	1716188586748	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188587751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188587751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188587751	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188588753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188588753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188588753	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188589755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188589755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188589755	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188590757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188590757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188590757	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188591760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188591760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188591760	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188592761	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188592761	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8124	1716188592761	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188592790	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188593763	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188593763	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188593763	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188593788	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188594767	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188594767	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188594767	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188594796	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188595769	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188595769	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8102	1716188595769	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188595796	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188596772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188596772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188596772	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188596791	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188597774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188597774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188597774	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188597802	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188598777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188598777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8104	1716188598777	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188598803	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188599779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188599779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.813	1716188599779	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188599805	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188600784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188600784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.813	1716188600784	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188600812	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188601786	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188601786	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.813	1716188601786	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188601807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188602788	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188602788	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8137999999999999	1716188602788	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188602813	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188603790	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188603790	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8137999999999999	1716188603790	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188603817	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188604792	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188604792	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8137999999999999	1716188604792	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188604819	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188605795	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188605795	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188605795	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188605823	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188606797	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188606797	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188606797	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188607799	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188607799	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188607799	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188608802	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188608802	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117	1716188608802	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188609804	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188609804	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117	1716188609804	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188610807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188610807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8117	1716188610807	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188611810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188611810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8105	1716188611810	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188612813	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188612813	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8105	1716188612813	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188613815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188613815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8105	1716188613815	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188614818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188614818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8106	1716188614818	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188615820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188615820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8106	1716188615820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188616822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188616822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8106	1716188616822	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188617824	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188617824	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188617824	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188618826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188618826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188618826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188619828	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188619828	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188619828	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188620831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188620831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188620831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188621833	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188621833	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188621833	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188622835	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188622835	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188622835	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188623838	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188623838	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188623838	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188624840	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188624840	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188624840	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188625843	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188625843	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188625843	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188626845	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188626845	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188626845	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188627847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188627847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188606820	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188607826	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188608827	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188609831	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188610834	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188611838	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188612833	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188613840	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188614843	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188615847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188616847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188617844	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188618853	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188619848	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188620855	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188621858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188622861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188623865	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188624871	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188625868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188626872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188627867	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188628879	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188629875	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188630883	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188631888	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188632877	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188633890	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188634883	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188635886	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188636897	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188637896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188638899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188639903	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188640905	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188641903	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188642899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188643908	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188644911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188645916	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188646917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188647910	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188648919	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188649923	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188650926	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188651926	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188652930	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188653935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188654936	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188655940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188656941	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188657935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188658939	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188659949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188660951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188661946	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188662950	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188663960	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188664963	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188665962	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188666967	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188667968	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188668970	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188669972	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188670975	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188627847	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188628850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188628850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8093	1716188628850	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188629852	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188629852	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188629852	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188630854	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188630854	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188630854	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188631856	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188631856	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188631856	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188632858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.400000000000001	1716188632858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188632858	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188633861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188633861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188633861	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188634863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188634863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8120999999999998	1716188634863	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188635865	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188635865	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.812	1716188635865	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188636868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188636868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.812	1716188636868	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188637870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188637870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.812	1716188637870	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188638872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188638872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8134000000000001	1716188638872	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188639874	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188639874	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8134000000000001	1716188639874	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188640876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188640876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8134000000000001	1716188640876	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188641878	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188641878	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188641878	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188642880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188642880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188642880	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188643882	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188643882	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188643882	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188644885	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188644885	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8151	1716188644885	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188645887	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188645887	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8151	1716188645887	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188646889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188646889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8151	1716188646889	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188647892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188647892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188647892	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188648894	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188648894	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188648894	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188649896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188649896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188649896	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188650899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188650899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188650899	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188651901	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188651901	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188651901	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188652904	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188652904	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8142	1716188652904	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188653906	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188653906	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188653906	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188654909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188654909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188654909	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188655911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188655911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188655911	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188656914	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188656914	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188656914	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188657917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188657917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188657917	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188658919	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188658919	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188658919	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188659921	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188659921	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188659921	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188660923	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188660923	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188660923	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188661925	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188661925	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188661925	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188662928	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188662928	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188662928	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188663931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188663931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188663931	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188664933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188664933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8115999999999999	1716188664933	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188665935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188665935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8145	1716188665935	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188666940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188666940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8145	1716188666940	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188667942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188667942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8145	1716188667942	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188668945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188668945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188668945	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188669947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188669947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188669947	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188670949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188670949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188670949	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188671951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188671951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188671951	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188672954	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188672954	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188672954	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188673957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188673957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188673957	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188674959	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188674959	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188674959	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188675961	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188675961	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188675961	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188676963	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188676963	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188676963	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188677966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188677966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188677966	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188678969	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188678969	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188678969	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188679971	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188679971	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177	1716188679971	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188680973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188680973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188680973	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188681976	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188681976	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188681976	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188682978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188682978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188682978	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188683981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188683981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188683981	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188684983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188684983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188684983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188685985	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188685985	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8165	1716188685985	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188686987	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188686987	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188686987	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188687989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188687989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188687989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188688992	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188688992	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8153	1716188688992	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188689994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188689994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188689994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188690996	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188690996	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188690996	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188691998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188691998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188671980	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188672974	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188673983	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188674986	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188675985	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188676989	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188677987	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188678994	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188679997	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188681001	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188681996	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188683008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188684008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188685013	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188686010	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188687013	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188688008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188689021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188690021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188691021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188692025	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188693030	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188694032	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188695033	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188696038	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188697038	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188698038	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188699042	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188700043	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188701047	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188702048	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188703043	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188704054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188705054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188706056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188707059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188708056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188709065	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188710059	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188711070	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188712073	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188853390	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8189000000000002	1716188853390	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188854394	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188854394	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188854394	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188855397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188855397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188855397	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188856400	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188856400	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188856400	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188857402	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188857402	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8212000000000002	1716188857402	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188858405	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188858405	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8212000000000002	1716188858405	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188859406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188859406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8212000000000002	1716188859406	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188860408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188860408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188860408	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188861410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8140999999999998	1716188691998	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188693001	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188693001	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188693001	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188694004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188694004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188694004	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188695006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188695006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.815	1716188695006	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188696008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188696008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188696008	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188697011	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188697011	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188697011	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188698013	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188698013	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188698013	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188699016	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188699016	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188699016	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188700018	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188700018	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8177999999999999	1716188700018	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188701021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188701021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188701021	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188702022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188702022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188702022	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188703025	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188703025	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8129000000000002	1716188703025	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188704027	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188704027	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8132000000000001	1716188704027	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188705029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188705029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8132000000000001	1716188705029	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188706031	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188706031	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8132000000000001	1716188706031	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188707034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188707034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188707034	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188708036	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188708036	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188708036	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188709039	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.400000000000001	1716188709039	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8133	1716188709039	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188710041	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188710041	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8152000000000001	1716188710041	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188711044	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188711044	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8152000000000001	1716188711044	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188712046	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188712046	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8152000000000001	1716188712046	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188713048	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188713048	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8155	1716188713048	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188713077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188714078	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188715080	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188716085	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188717078	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188718085	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188719090	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188720091	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188721096	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188722088	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188723096	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188724097	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188725098	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188726100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188727107	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188728112	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188729116	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188730118	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188731116	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188732118	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188733127	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188734130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188735131	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188736136	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188737130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188738139	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188739142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188740145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188741149	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188742140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188743151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188744156	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188745155	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188746164	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188747157	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188748167	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188749172	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188750174	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188751175	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188752169	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188753182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188754188	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188755186	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188756182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188757191	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188758189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188759197	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188760196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188761205	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188762197	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188763205	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188764207	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188765214	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188766213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188767206	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188768219	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188769221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188770224	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188771235	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188772226	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188773223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188774225	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188775227	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188776235	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188777237	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188714051	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188714051	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8155	1716188714051	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188715054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188715054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8155	1716188715054	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188716056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188716056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.816	1716188716056	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188717058	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188717058	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.816	1716188717058	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188718061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188718061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.816	1716188718061	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188719063	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188719063	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188719063	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188720065	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188720065	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188720065	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188721069	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188721069	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8171	1716188721069	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188722072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188722072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188722072	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188723074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188723074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188723074	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188724077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188724077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175999999999999	1716188724077	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188725079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188725079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8185	1716188725079	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188726081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188726081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8185	1716188726081	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188727084	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188727084	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8185	1716188727084	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188728086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188728086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8208	1716188728086	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188729090	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188729090	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8208	1716188729090	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188730093	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188730093	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8208	1716188730093	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188731095	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188731095	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188731095	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188732098	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188732098	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188732098	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188733100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188733100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188733100	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188734103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188734103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8204	1716188734103	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188735105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188735105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8204	1716188735105	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188736108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188736108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8204	1716188736108	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188737110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188737110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8154000000000001	1716188737110	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188738113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188738113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8154000000000001	1716188738113	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188739115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188739115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8154000000000001	1716188739115	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188740117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188740117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188740117	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188741120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188741120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188741120	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188742122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188742122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.817	1716188742122	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188743124	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188743124	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8182	1716188743124	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188744128	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188744128	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8182	1716188744128	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188745130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.300000000000001	1716188745130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8182	1716188745130	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188746138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188746138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8187	1716188746138	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188747140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188747140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8187	1716188747140	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188748142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.000000000000001	1716188748142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8187	1716188748142	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188749145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188749145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8184	1716188749145	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188750147	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188750147	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8184	1716188750147	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188751151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188751151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8184	1716188751151	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188752153	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188752153	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188752153	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188753156	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188753156	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188753156	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188754158	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188754158	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188754158	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188755161	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188755161	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188755161	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188756163	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188756163	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188756163	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188757166	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188757166	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188757166	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188758168	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188758168	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188758168	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188759170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188759170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188759170	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188760172	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188760172	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188760172	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188761175	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188761175	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188761175	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188762177	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188762177	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188762177	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188763179	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188763179	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188763179	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188764182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188764182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.823	1716188764182	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188765185	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188765185	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.823	1716188765185	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188766187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188766187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.823	1716188766187	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188767189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188767189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188767189	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188768192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188768192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188768192	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188769194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188769194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188769194	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188770196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188770196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188770196	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188771199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188771199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188771199	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188772202	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188772202	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8192000000000002	1716188772202	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188773204	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188773204	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8166	1716188773204	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188774207	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188774207	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8166	1716188774207	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188775209	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188775209	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8166	1716188775209	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188776211	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188776211	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188776211	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188777213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188777213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188777213	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188778215	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188778215	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188778215	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188779217	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188779217	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188779217	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188780221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188780221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188780221	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188781223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.500000000000001	1716188781223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188781223	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188782226	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188782226	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8193	1716188782226	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188783228	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188783228	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8193	1716188783228	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188784231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188784231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8193	1716188784231	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188785232	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188785232	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8211	1716188785232	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188786235	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188786235	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8211	1716188786235	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188787237	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188787237	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8211	1716188787237	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188788239	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188788239	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188788239	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188789241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188789241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188789241	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188790244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188790244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188790244	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188791246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188791246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188791246	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188792248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188792248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188792248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188793250	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188793250	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8215	1716188793250	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188794253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188794253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188794253	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188795255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188795255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188795255	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188796257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188796257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8191	1716188796257	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188797259	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188797259	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.82	1716188797259	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188798262	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188798262	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.82	1716188798262	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188799264	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188778236	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188779245	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188780245	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188781254	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188782250	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188783248	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188784251	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188785252	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188786263	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188787268	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188788266	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188789266	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188790273	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188791273	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188792275	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188793268	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188794279	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188795287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188796286	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188797285	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188798279	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188799291	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188800295	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188801293	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188802290	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188803291	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188804298	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188805302	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188806304	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188807301	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188808300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188809323	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188810308	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188811309	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188812311	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188813322	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188814329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188815329	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188816331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188817323	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188818330	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188819351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188820331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188821338	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188822339	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188823364	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188824351	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188825353	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188826348	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188827348	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188828350	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188829355	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188830357	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188831362	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188832362	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188853407	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188854412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188855417	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188856419	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188857416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188858420	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188859425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188860426	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188861434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188862433	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188799264	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.82	1716188799264	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188800266	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188800266	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188800266	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188801268	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188801268	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188801268	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188802270	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188802270	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8188	1716188802270	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188803272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188803272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188803272	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188804274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188804274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188804274	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188805276	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188805276	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8207	1716188805276	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	100	1716188806278	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188806278	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8169000000000002	1716188806278	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188807280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188807280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8169000000000002	1716188807280	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188808282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188808282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8169000000000002	1716188808282	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188809285	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188809285	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175	1716188809285	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188810287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188810287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175	1716188810287	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188811289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188811289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8175	1716188811289	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188812292	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188812292	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8179	1716188812292	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188813294	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188813294	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8179	1716188813294	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188814297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188814297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8179	1716188814297	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188815300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188815300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188815300	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188816303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188816303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188816303	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188817305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188817305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197999999999999	1716188817305	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188818307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188818307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188818307	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188819310	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188819310	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188819310	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188820312	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188820312	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8183	1716188820312	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	108	1716188821314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188821314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.819	1716188821314	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188822316	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188822316	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.819	1716188822316	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188823318	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188823318	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.819	1716188823318	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188824321	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188824321	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188824321	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188825324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188825324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188825324	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188826326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188826326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8205	1716188826326	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188827328	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188827328	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188827328	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	105	1716188828331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188828331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188828331	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188829335	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188829335	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8197	1716188829335	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188830337	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188830337	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8195999999999999	1716188830337	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188831340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188831340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8195999999999999	1716188831340	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188832342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188832342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8195999999999999	1716188832342	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188861410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188861410	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188862412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188862412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.822	1716188862412	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188863414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188863414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8226	1716188863414	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188863430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188864416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188864416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8226	1716188864416	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188864434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188865418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188865418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8226	1716188865418	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188865438	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188866421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188866421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188866421	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188866438	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188867424	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188867424	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188867424	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188867443	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188868425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.800000000000001	1716188868425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188868425	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188869428	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188869428	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8259	1716188869428	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188870430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188870430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8259	1716188870430	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188871432	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188871432	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8259	1716188871432	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188872434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188872434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8272	1716188872434	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188873437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188873437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8272	1716188873437	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	102	1716188874439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188874439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8272	1716188874439	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188875442	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188875442	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188875442	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188876445	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188876445	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188876445	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	101	1716188877447	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	5.4	1716188877447	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8249000000000002	1716188877447	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188878449	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188878449	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8251	1716188878449	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	103	1716188879451	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188879451	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8251	1716188879451	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - CPU Utilization	104	1716188880454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Utilization	7.1000000000000005	1716188880454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Memory Usage GB	1.8251	1716188880454	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188868444	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188869448	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188870448	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188871453	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188872453	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188873455	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188874458	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188875459	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188876473	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188877467	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188878467	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188879470	f53cd78db9f44607baede536bdbcdee4	0	f
TOP - Swap Memory GB	0.002	1716188880484	f53cd78db9f44607baede536bdbcdee4	0	f
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
letter	0	2275df3c09014177a217ae9e5cbd1c56
workload	0	2275df3c09014177a217ae9e5cbd1c56
listeners	smi+top+dcgmi	2275df3c09014177a217ae9e5cbd1c56
params	'"-"'	2275df3c09014177a217ae9e5cbd1c56
file	cifar10.py	2275df3c09014177a217ae9e5cbd1c56
workload_listener	''	2275df3c09014177a217ae9e5cbd1c56
letter	0	f53cd78db9f44607baede536bdbcdee4
workload	0	f53cd78db9f44607baede536bdbcdee4
listeners	smi+top+dcgmi	f53cd78db9f44607baede536bdbcdee4
params	'"-"'	f53cd78db9f44607baede536bdbcdee4
file	cifar10.py	f53cd78db9f44607baede536bdbcdee4
workload_listener	''	f53cd78db9f44607baede536bdbcdee4
model	cifar10.py	f53cd78db9f44607baede536bdbcdee4
manual	False	f53cd78db9f44607baede536bdbcdee4
max_epoch	5	f53cd78db9f44607baede536bdbcdee4
max_time	172800	f53cd78db9f44607baede536bdbcdee4
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
2275df3c09014177a217ae9e5cbd1c56	rambunctious-pug-169	UNKNOWN			daga	FAILED	1716187930862	1716188058359		active	s3://mlflow-storage/0/2275df3c09014177a217ae9e5cbd1c56/artifacts	0	\N
f53cd78db9f44607baede536bdbcdee4	(0 0) dashing-horse-553	UNKNOWN			daga	FINISHED	1716188102112	1716188881466		active	s3://mlflow-storage/0/f53cd78db9f44607baede536bdbcdee4/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	2275df3c09014177a217ae9e5cbd1c56
mlflow.source.name	file:///home/daga/radt#examples/pytorch	2275df3c09014177a217ae9e5cbd1c56
mlflow.source.type	PROJECT	2275df3c09014177a217ae9e5cbd1c56
mlflow.project.entryPoint	main	2275df3c09014177a217ae9e5cbd1c56
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	2275df3c09014177a217ae9e5cbd1c56
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2275df3c09014177a217ae9e5cbd1c56
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2275df3c09014177a217ae9e5cbd1c56
mlflow.runName	rambunctious-pug-169	2275df3c09014177a217ae9e5cbd1c56
mlflow.project.env	conda	2275df3c09014177a217ae9e5cbd1c56
mlflow.project.backend	local	2275df3c09014177a217ae9e5cbd1c56
mlflow.user	daga	f53cd78db9f44607baede536bdbcdee4
mlflow.source.name	file:///home/daga/radt#examples/pytorch	f53cd78db9f44607baede536bdbcdee4
mlflow.source.type	PROJECT	f53cd78db9f44607baede536bdbcdee4
mlflow.project.entryPoint	main	f53cd78db9f44607baede536bdbcdee4
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	f53cd78db9f44607baede536bdbcdee4
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	f53cd78db9f44607baede536bdbcdee4
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	f53cd78db9f44607baede536bdbcdee4
mlflow.project.env	conda	f53cd78db9f44607baede536bdbcdee4
mlflow.project.backend	local	f53cd78db9f44607baede536bdbcdee4
mlflow.runName	(0 0) dashing-horse-553	f53cd78db9f44607baede536bdbcdee4
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

