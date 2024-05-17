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
0	Default	s3://mlflow-storage/0	active	1715610458816	1715610458816
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
SMI - Power Draw	14.97	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
SMI - Timestamp	1715610795.117	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
SMI - GPU Util	0	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
SMI - Mem Util	0	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
SMI - Mem Used	0	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
SMI - Performance State	3	1715610795134	0	f	5bc80495ccb3484b90fcbcd50237f51c
TOP - CPU Utilization	106	1715611583063	0	f	5bc80495ccb3484b90fcbcd50237f51c
TOP - Memory Usage GB	2.5541	1715611583063	0	f	5bc80495ccb3484b90fcbcd50237f51c
TOP - Memory Utilization	9.8	1715611583063	0	f	5bc80495ccb3484b90fcbcd50237f51c
TOP - Swap Memory GB	0.077	1715611583081	0	f	5bc80495ccb3484b90fcbcd50237f51c
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1715610794936	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	0	1715610794936	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	1.8549	1715610794936	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610794958	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - Power Draw	14.97	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - Timestamp	1715610795.117	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - GPU Util	0	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - Mem Util	0	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - Mem Used	0	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
SMI - Performance State	3	1715610795134	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	166.7	1715610795938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610795938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	1.8549	1715610795938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610795956	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610796941	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715610796941	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	1.8549	1715610796941	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610796963	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610797943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610797943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.1028000000000002	1715610797943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610797960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610798946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715610798946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.1028000000000002	1715610798946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610798964	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610799948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715610799948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.1028000000000002	1715610799948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610799971	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610800951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610800951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0906	1715610800951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610800992	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610801954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610801954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0906	1715610801954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610801974	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610802957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610802957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0906	1715610802957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610802983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610803960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610803960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610803960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610803982	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610804962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.8	1715610804962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610804962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610804981	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610805965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610805965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610805965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610805999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	110	1715610806967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610806967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0925	1715610806967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610806985	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	107	1715610807969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610807969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0925	1715610807969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610807989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	107	1715610808972	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610808972	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0925	1715610808972	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610808990	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610812003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610814006	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0765	1715610827042	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0765	1715610828049	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0765	1715610829048	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610833058	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611136840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611136840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5382	1715611136840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611140875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611141881	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611143880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611147873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611147873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611147873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611149894	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611152904	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611155911	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611157920	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611160926	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611165942	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611166943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611168958	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611176954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611176954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611176954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611177956	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611177956	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611177956	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611195027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611196036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611432684	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611518913	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611528917	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611528917	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5488000000000004	1715611528917	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611529920	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611529920	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611529920	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611532928	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611532928	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496	1715611532928	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611533931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611533931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496	1715611533931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611542955	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611542955	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5502	1715611542955	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611543957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611543957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5502	1715611543957	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611553001	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611555990	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611556993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611556993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5508	1715611556993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611557997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611557997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5508	1715611557997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611558999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611558999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5508	1715611558999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611560002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611561004	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610809974	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610809974	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610809974	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610821005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610821005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0941	1715610821005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610824014	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610824014	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.3924000000000003	1715610824014	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610834040	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610834040	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5893	1715610834040	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611136859	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611146870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611146870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611146870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611158920	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611169934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611169934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5381	1715611169934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611170937	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.1	1715611170937	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5381	1715611170937	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611172969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611174948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715611174948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611174948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611179962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611179962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611179962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611181967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611181967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611181967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611183976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611183976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611183976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611184981	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611184981	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611184981	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611187988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611187988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611187988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611192001	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611192001	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611192001	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611193028	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611434661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611434661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611526912	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611526912	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5488000000000004	1715611526912	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611530948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611531952	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611545963	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611545963	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611545963	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611547970	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611547970	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5486	1715611547970	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611548973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611548973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5486	1715611548973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611550977	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611550977	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610809991	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	107	1715610810976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610810976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610810976	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610812983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610812983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610812983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610815008	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610816020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610817011	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	107	1715610818999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610818999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0941	1715610818999	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610821030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610825017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610825017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5824000000000003	1715610825017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610831052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610832065	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610834062	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610835044	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610835044	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5893	1715610835044	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611137843	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611137843	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5382	1715611137843	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611138875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611142857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611142857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611142857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611145884	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611150880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611150880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5365	1715611150880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611156896	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611156896	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611156896	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611159904	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611159904	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611159904	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611162914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611162914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611162914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611171973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611194005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611194005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611194005	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611436668	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611436668	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611436668	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611447694	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611447694	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5449	1715611447694	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611450705	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611450705	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611450705	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611451708	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611451708	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611451708	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611455718	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611455718	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5463	1715611455718	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611463739	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611463739	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610810994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610813006	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610815993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610815993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0921	1715610815993	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	107	1715610816994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610816994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0921	1715610816994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610817996	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610817996	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0921	1715610817996	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610819021	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610832034	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610832034	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5892	1715610832034	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610833038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610833038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5893	1715610833038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610835063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611137869	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611141855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611141855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5341	1715611141855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611143861	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611143861	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611143861	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611146893	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611147893	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611152885	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611152885	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611152885	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611155893	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611155893	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611155893	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611157899	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611157899	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611157899	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611160908	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611160908	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611160908	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611165922	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611165922	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.54	1715611165922	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611166926	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611166926	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5383	1715611166926	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611168931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715611168931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5383	1715611168931	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611173971	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611176973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611177987	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611196010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611196010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611196010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611436708	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611447720	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611450730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611451733	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611455736	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611463763	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611471759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611471759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465	1715611471759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610811979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610811979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610811979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	109	1715610813986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610813986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610813986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.053399999999999996	1715610824034	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610828025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610828025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5836	1715610828025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610829027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610829027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5836	1715610829027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610831032	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610831032	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5892	1715610831032	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611138846	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611138846	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5382	1715611138846	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611139849	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611139849	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5341	1715611139849	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611145866	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611145866	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611145866	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611149878	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611149878	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5365	1715611149878	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611150900	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611156919	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611159924	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611167929	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611167929	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5383	1715611167929	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611191017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611194032	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611437670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611437670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611437670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611441680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611441680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611441680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611444712	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611445710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611446718	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611452736	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611454740	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611456749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611460748	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611467777	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611474792	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611476797	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611477800	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611478804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611497832	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611497832	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.547	1715611497832	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611498835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611498835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.547	1715611498835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611500840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611500840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5478	1715611500840	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611501842	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	110	1715610814989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610814989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0926	1715610814989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715610820002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.999999999999999	1715610820002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.0941	1715610820002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610822007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610822007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.3924000000000003	1715610822007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610823010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715610823010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.3924000000000003	1715610823010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0765	1715610825036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0765	1715610826043	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610830030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610830030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5892	1715610830030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611139870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611144864	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611144864	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611144864	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611148876	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611148876	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5365	1715611148876	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611151882	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611151882	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611151882	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611153888	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611153888	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611153888	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611154890	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611154890	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611154890	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611161911	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611161911	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611161911	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611162935	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611163933	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611164938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611172943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611172943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611172943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611175969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611178997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611180991	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611183002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611186000	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611187012	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611189015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611190015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611193003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.1	1715611193003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611193003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611437697	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611441698	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611445690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611445690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5449	1715611445690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611446692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611446692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5449	1715611446692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611452710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611452710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611452710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610818015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.052399999999999995	1715610820023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.053399999999999996	1715610822027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.053399999999999996	1715610823028	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610826020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715610826020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5824000000000003	1715610826020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610827023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610827023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5836	1715610827023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610830048	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610836046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610836046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5914	1715610836046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610836066	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610837049	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610837049	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5914	1715610837049	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610837070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610838051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610838051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5914	1715610838051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610838073	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610839056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610839056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5899	1715610839056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610839077	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610840059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610840059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5899	1715610840059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610840082	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610841062	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5	1715610841062	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5899	1715610841062	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610841084	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610842065	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610842065	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5913000000000004	1715610842065	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610842085	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610843067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610843067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5913000000000004	1715610843067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610843088	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610844070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610844070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5913000000000004	1715610844070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610844095	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610845073	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610845073	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610845073	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610845090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610846075	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610846075	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610846075	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610846093	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610847078	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.8	1715610847078	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610847078	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610847096	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610848081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610848081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610848081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610848104	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610849084	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610849084	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610849084	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610850086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610850086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5928	1715610850086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610856100	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610856100	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5953000000000004	1715610856100	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610861131	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610875149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610875149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610875149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610877183	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610880189	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610881188	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610891190	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610891190	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5194	1715610891190	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610893195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610893195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5181	1715610893195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610894197	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610894197	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5181	1715610894197	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611140852	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611140852	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5341	1715611140852	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611144888	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611148903	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611151907	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611153912	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611154907	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611161933	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611163916	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611163916	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.54	1715611163916	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611164919	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.4	1715611164919	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.54	1715611164919	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611170954	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611175951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611175951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611175951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611178959	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611178959	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611178959	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611180964	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611180964	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611180964	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611182973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611182973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611182973	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611185983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611185983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611185983	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611186986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611186986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611186986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611188991	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611188991	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611188991	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611189994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611189994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611189994	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610849105	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610850104	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610861113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610861113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5954	1715610861113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610863118	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610863118	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5138000000000003	1715610863118	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610877153	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610877153	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610877153	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610880161	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610880161	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610880161	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610881163	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610881163	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5208000000000004	1715610881163	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610885172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610885172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5203	1715610885172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610891217	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610893213	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611142874	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611158901	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611158901	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611158901	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611167949	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611169949	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611171939	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611171939	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5381	1715611171939	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611173945	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.699999999999998	1715611173945	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611173945	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611174969	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611179986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611181989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611183996	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611185003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611188007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611192025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611195008	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611195008	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611195008	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611438672	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611438672	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611438672	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611439674	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611439674	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611439674	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611440677	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611440677	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611440677	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611442682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611442682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5444	1715611442682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611443685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611443685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5444	1715611443685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611444687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.100000000000001	1715611444687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5444	1715611444687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611449727	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611453738	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610851089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610851089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5936	1715610851089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610852090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715610852090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5936	1715610852090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610854096	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610854096	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5953000000000004	1715610854096	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610857102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610857102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5965	1715610857102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610859107	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610859107	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5965	1715610859107	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610863150	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610864140	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610865146	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610868153	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610869152	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610872161	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610874173	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715610876151	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610876151	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610876151	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610883168	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610883168	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5208000000000004	1715610883168	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610884170	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610884170	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5203	1715610884170	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610886176	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610886176	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5203	1715610886176	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610889184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.399999999999999	1715610889184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610889184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610894216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611190997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611190997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5374	1715611190997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611438697	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611439700	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611440697	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611442712	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611443709	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611449702	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611449702	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611449702	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611453712	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611453712	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611453712	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611457723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611457723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.545	1715611457723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611458725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611458725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.545	1715611458725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611462736	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611462736	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611462736	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611466746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611466746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465999999999998	1715611466746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610851109	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610852108	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610854114	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610857122	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610859127	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610864121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715610864121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5138000000000003	1715610864121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610865124	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.8	1715610865124	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5138000000000003	1715610865124	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610868131	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610868131	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5168000000000004	1715610868131	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610869134	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5	1715610869134	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5183	1715610869134	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610872142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610872142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5178000000000003	1715610872142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610874146	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610874146	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5178000000000003	1715610874146	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610875170	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610876171	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610883190	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610884195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610886204	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610889204	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611197013	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715611197013	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611197013	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611202027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611202027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611202027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611210078	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611218068	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611218068	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611218068	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611224112	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611225110	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611226119	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611227111	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611230128	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611232133	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611233132	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611237125	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611237125	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611237125	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611239132	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611239132	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611239132	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611249157	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611249157	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611249157	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611250160	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611250160	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5268	1715611250160	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611251162	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611251162	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5268	1715611251162	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611252165	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611252165	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5268	1715611252165	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610853092	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610853092	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5936	1715610853092	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610858105	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610858105	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5965	1715610858105	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610867129	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610867129	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5168000000000004	1715610867129	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610873144	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610873144	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5178000000000003	1715610873144	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610888182	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610888182	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610888182	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611197035	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611210048	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611210048	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611210048	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611211051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611211051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611211051	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611224086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611224086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5406	1715611224086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611225089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611225089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5406	1715611225089	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611226090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611226090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611226090	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611227093	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611227093	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611227093	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611230102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611230102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611230102	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611232109	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611232109	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385999999999997	1715611232109	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611233113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611233113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385999999999997	1715611233113	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611235119	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611235119	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611235119	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611237144	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611239160	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611249189	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611250179	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611251186	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611252183	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611448698	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611448698	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611448698	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611459728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611459728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.545	1715611459728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611461734	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611461734	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611461734	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611464741	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611464741	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5459	1715611464741	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610853110	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610858124	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610867154	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610887178	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610887178	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610887178	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611198015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611198015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611198015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611199017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611199017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5370999999999997	1715611199017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611200021	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715611200021	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5353000000000003	1715611200021	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611203050	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611207041	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611207041	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611207041	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611208043	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.4	1715611208043	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611208043	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611209046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611209046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611209046	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611213056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611213056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611213056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611214059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611214059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611214059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611217066	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611217066	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611217066	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611220074	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.899999999999999	1715611220074	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611220074	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611229099	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611229099	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611229099	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611231106	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611231106	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611231106	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611235138	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611236139	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611240160	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611246149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611246149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611246149	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	114	1715611253167	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611253167	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611253167	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611448726	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611459752	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611461762	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611464766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611465769	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611473793	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611490811	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611490811	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611490811	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611491841	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611492844	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611494844	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610855098	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610855098	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5953000000000004	1715610855098	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610856117	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610860127	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610862132	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610866153	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610870165	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610871158	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610878155	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610878155	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610878155	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610879159	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610879159	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610879159	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610882166	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610882166	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5208000000000004	1715610882166	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610885194	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610888208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610890206	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610892220	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610895225	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611198047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611199037	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611203030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611203030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611203030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611206054	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611207065	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611208067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611209067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611213081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611214085	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611217097	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611220096	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611229126	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611231130	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611236121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611236121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611236121	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611240135	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611240135	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611240135	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611242140	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611242140	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611242140	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611246173	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611454715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611454715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5463	1715611454715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611456720	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611456720	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5463	1715611456720	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611460730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611460730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5455	1715611460730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611467749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611467749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465999999999998	1715611467749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611474766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611474766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611474766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611476770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610855114	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	100	1715610860110	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5	1715610860110	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5954	1715610860110	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610862115	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610862115	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5954	1715610862115	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610866126	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610866126	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5168000000000004	1715610866126	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610870136	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610870136	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5183	1715610870136	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610871139	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610871139	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5183	1715610871139	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610873163	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610878183	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610879183	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610882185	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610887206	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610890187	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.8	1715610890187	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5194	1715610890187	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610892193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715610892193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5194	1715610892193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715610895202	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610895202	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5181	1715610895202	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610896205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610896205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610896205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610896232	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610897208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610897208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610897208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610897235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610898210	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610898210	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610898210	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610898239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610899213	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610899213	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610899213	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610899241	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610900214	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715610900214	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610900214	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610900230	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610901216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.799999999999999	1715610901216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610901216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610901244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715610902219	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5	1715610902219	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.517	1715610902219	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610902246	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610903221	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610903221	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.517	1715610903221	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610903245	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610904224	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610904224	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.517	1715610904224	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610906229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610906229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610906229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610909236	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715610909236	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610909236	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610910257	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610914249	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610914249	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5199000000000003	1715610914249	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610916273	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610923299	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610929319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610932326	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610936309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610936309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5227	1715610936309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610939316	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610939316	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.523	1715610939316	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610940319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610940319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.523	1715610940319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	100	1715610941322	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610941322	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610941322	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610942324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610942324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610942324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610944330	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610944330	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715610944330	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610945332	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610945332	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715610945332	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610949370	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610954375	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611200038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611204060	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611205052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611212078	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611216083	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611219097	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611228095	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715611228095	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.539	1715611228095	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611234116	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611234116	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385999999999997	1715611234116	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611238128	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611238128	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611238128	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611243142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611243142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611243142	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611244145	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.1	1715611244145	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611244145	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611245147	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611245147	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611245147	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611253197	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611457749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610904242	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610906251	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610910239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.199999999999999	1715610910239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610910239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610911241	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.4	1715610911241	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610911241	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610916253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715610916253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5199000000000003	1715610916253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610923272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.9	1715610923272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206	1715610923272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610929288	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610929288	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610929288	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610932297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610932297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5213	1715610932297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610933300	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610933300	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5213	1715610933300	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610936336	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610939343	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610940347	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610941345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610942350	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610944361	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610949343	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610949343	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5221	1715610949343	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610954355	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610954355	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5261	1715610954355	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611201023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611201023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5353000000000003	1715611201023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611202055	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611211079	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611215080	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611221076	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611221076	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611221076	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611222079	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611222079	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611222079	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611223081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611223081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5406	1715611223081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611241162	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611247152	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611247152	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611247152	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611248154	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611248154	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5401	1715611248154	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611254169	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611254169	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611254169	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611255172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.799999999999999	1715611255172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5398	1715611255172	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611458753	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610905226	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610905226	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610905226	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610907250	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610912269	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610913272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610919290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610920292	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610925297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610927283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610927283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206999999999997	1715610927283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610928285	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715610928285	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206999999999997	1715610928285	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610935306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610935306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5227	1715610935306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610938314	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610938314	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.523	1715610938314	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610946335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610946335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715610946335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610947338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610947338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5221	1715610947338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610953382	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611201043	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611206038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611206038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611206038	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611215061	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715611215061	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611215061	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611218086	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611221099	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611222103	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611241137	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611241137	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611241137	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611242167	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611247179	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611248171	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611254200	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611255193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611462761	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611466762	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611468776	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611469780	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611471783	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611472787	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611475787	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611480782	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611480782	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611480782	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611481784	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.299999999999999	1715611481784	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611481784	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611482789	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611482789	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611482789	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611486799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611486799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610905244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610912244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5	1715610912244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610912244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610913246	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610913246	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610913246	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610914270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610920265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715610920265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610920265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610925279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610925279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206	1715610925279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610926310	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610927312	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610928317	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610935327	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610938342	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610946361	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610947363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611204033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.4	1715611204033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.535	1715611204033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611205036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611205036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5363	1715611205036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611212053	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611212053	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5385	1715611212053	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611216063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611216063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611216063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611219070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611219070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5389	1715611219070	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611223100	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611228122	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611234140	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611238157	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611243173	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611244171	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611245165	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5459	1715611463739	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611470776	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611483792	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611483792	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611483792	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611484795	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611484795	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611484795	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611485825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611493821	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611493821	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611493821	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611495826	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611495826	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611495826	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611496849	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611499856	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611503876	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611506884	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611508888	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611514899	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611515902	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715610907232	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715610907232	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.52	1715610907232	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610908261	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610915251	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610915251	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5199000000000003	1715610915251	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610918260	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610918260	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610918260	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610919263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715610919263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610919263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610922287	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610924299	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610945360	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610950363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610951374	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610955382	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611256174	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611256174	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611256174	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611265200	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611265200	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611265200	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611269212	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611269212	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611269212	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611270236	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611278266	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611281244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611281244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611281244	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611282247	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.4	1715611282247	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611282247	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611295284	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611295284	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611295284	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611301299	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611301299	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611301299	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611302302	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611302302	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611302302	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611303304	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611303304	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5443000000000002	1715611303304	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611308345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611309347	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611311353	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611465744	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611465744	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5459	1715611465744	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611473764	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611473764	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611473764	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611479798	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611490838	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611492817	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611492817	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611492817	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611494823	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611494823	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610908234	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.6	1715610908234	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5209	1715610908234	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610909257	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610915277	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610918287	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610922270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610922270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610922270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610924275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610924275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206	1715610924275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610933329	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610950345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610950345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5246	1715610950345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610951348	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610951348	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5246	1715610951348	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715610955358	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.7	1715610955358	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5261	1715610955358	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611256195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611268235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611269239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611278239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611278239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611278239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611280242	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611280242	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611280242	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611281276	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611282276	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611295302	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611301326	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611302329	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611303332	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611309321	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611309321	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611309321	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611311326	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611311326	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611311326	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611313331	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611313331	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611313331	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611468751	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611468751	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465999999999998	1715611468751	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611469754	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611469754	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465	1715611469754	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611470756	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611470756	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5465	1715611470756	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611472761	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611472761	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611472761	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611475769	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611475769	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425	1715611475769	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611479778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611479778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611479778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610911273	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610917283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610921290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610930290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610930290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610930290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610931294	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610931294	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5197	1715610931294	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610934303	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610934303	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5213	1715610934303	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610937311	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610937311	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5227	1715610937311	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610943327	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610943327	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610943327	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610948340	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610948340	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5221	1715610948340	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610952350	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610952350	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5246	1715610952350	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610953353	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.5	1715610953353	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5261	1715610953353	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611257177	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611257177	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611257177	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611262193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611262193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611262193	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611263195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611263195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611263195	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611266203	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611266203	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611266203	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611267205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611267205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611267205	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611268208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611268208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611268208	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611287288	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611289294	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611291298	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611292303	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611293305	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611294306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611296311	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611297317	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611300315	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611312353	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611476770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425	1715611476770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611477773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.8	1715611477773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425	1715611477773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611478776	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611478776	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611478776	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611484812	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610917256	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610917256	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5204	1715610917256	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610921268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715610921268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5214000000000003	1715610921268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610926280	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610926280	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5206999999999997	1715610926280	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610930310	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610931321	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610934329	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610937330	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610943356	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610948367	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610952366	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610956360	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610956360	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5243	1715610956360	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610956380	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610957363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610957363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5243	1715610957363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610957394	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610958366	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715610958366	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5243	1715610958366	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610958393	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610959369	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610959369	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5251	1715610959369	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610959388	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610960371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610960371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5251	1715610960371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610960398	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610961373	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.5	1715610961373	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5251	1715610961373	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610961397	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610962375	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610962375	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5253	1715610962375	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610962404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610963378	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715610963378	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5253	1715610963378	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610963404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610964381	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610964381	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5253	1715610964381	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610964399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610965384	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610965384	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5242	1715610965384	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610965402	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610966386	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610966386	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5242	1715610966386	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610966408	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610967389	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610967389	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5242	1715610967389	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610967413	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610968392	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.199999999999999	1715610968392	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5256	1715610968392	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610972401	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610972401	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5225	1715610972401	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610973404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610973404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5225	1715610973404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610978440	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610981453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610998473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610998473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5255	1715610998473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610999476	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610999476	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5255	1715610999476	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611002482	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611002482	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5264	1715611002482	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611012534	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611257204	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611262219	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611263223	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611266223	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611267235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611287263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611287263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611287263	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611289268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611289268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611289268	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611291272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611291272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611291272	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611292275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611292275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611292275	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611293279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611293279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611293279	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611294281	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611294281	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611294281	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611296287	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611296287	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611296287	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611297290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611297290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611297290	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611300297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611300297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611300297	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611312328	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611312328	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611312328	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611480808	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611481814	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611482808	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611486825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611487828	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611488830	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611489825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611512870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610968413	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610972427	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610973432	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610981425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610981425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5234	1715610981425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610984455	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610998500	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610999506	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611012507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611012507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5283	1715611012507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611258180	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611258180	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611258180	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611261189	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611261189	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5393000000000003	1715611261189	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611264198	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611264198	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611264198	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611265226	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611279240	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611279240	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611279240	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611290270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611290270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611290270	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611298292	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611298292	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611298292	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611299295	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611299295	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.543	1715611299295	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611304333	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611305328	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611310324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.1	1715611310324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611310324	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611313355	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611483817	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611485797	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611485797	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611485797	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611491813	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611491813	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611491813	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611493852	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611495858	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611499837	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611499837	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5478	1715611499837	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611503847	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611503847	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5495	1715611503847	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611506855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611506855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5503	1715611506855	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611508860	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611508860	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611508860	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611514875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611514875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5464	1715611514875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610969394	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610969394	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5256	1715610969394	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610970396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610970396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5256	1715610970396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610971399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610971399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5225	1715610971399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610974407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610974407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5237	1715610974407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610975410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610975410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5237	1715610975410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610976413	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610976413	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5237	1715610976413	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610977415	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610977415	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5265	1715610977415	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610978417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610978417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5265	1715610978417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610982453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610986466	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610990472	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610992484	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610996495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611001507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611003513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611013510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611013510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5301	1715611013510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611258200	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611261210	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611264229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611276259	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611279269	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611290288	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611298320	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611299322	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611305309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611305309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611305309	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611306312	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611306312	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611306312	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611310349	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611314333	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611314333	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611314333	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5461	1715611486799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611487802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611487802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5448000000000004	1715611487802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611488804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611488804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5448000000000004	1715611488804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611489808	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611489808	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5448000000000004	1715611489808	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611496829	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	13	1715611496829	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610969421	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610970422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610971426	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610974429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610975427	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610976440	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610977446	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610982429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610982429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5234	1715610982429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610986441	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715610986441	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5252	1715610986441	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610990453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610990453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5241	1715610990453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610992458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610992458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715610992458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610996468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610996468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5244	1715610996468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611001480	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611001480	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5264	1715611001480	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611003485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611003485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5264	1715611003485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611009521	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611259184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611259184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5393000000000003	1715611259184	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611260186	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611260186	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5393000000000003	1715611260186	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611270216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611270216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611270216	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611271239	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611272241	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611273247	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611274250	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611275249	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611277235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611277235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611277235	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611280260	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611283276	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611284283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611285283	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611286280	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611288289	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611306333	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611307343	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611314357	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611315362	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5446	1715611494823	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611502845	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611502845	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5495	1715611502845	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611505853	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611505853	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5503	1715611505853	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611507857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	100	1715610979420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715610979420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5265	1715610979420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715610980422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715610980422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5234	1715610980422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610985437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610985437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5231999999999997	1715610985437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610988448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610988448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5252	1715610988448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610991455	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715610991455	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5241	1715610991455	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610993461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610993461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715610993461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610994463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610994463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715610994463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610995465	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610995465	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5244	1715610995465	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611000478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611000478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5255	1715611000478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611010502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611010502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5283	1715611010502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611011505	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611011505	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5283	1715611011505	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611013536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611014541	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611015547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611259212	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611260214	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611271218	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715611271218	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611271218	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611272220	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.999999999999998	1715611272220	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611272220	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611273223	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611273223	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611273223	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611274225	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.099999999999998	1715611274225	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611274225	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611275229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611275229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611275229	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611276233	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611276233	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5421	1715611276233	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611277261	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611283250	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611283250	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611283250	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611284253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611284253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611284253	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611285258	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610979447	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610980441	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610985468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610988475	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610991482	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610993490	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610994491	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610995485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611000503	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611010520	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611011528	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611014513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611014513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5301	1715611014513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611015516	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611015516	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5301	1715611015516	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611285258	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5423	1715611285258	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611286261	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611286261	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611286261	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611288265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611288265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611288265	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611304306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611304306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611304306	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611307315	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611307315	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611307315	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611308319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611308319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611308319	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611315335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611315335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611315335	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.547	1715611496829	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611512899	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611516880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611516880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5464	1715611516880	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611520894	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611520894	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5476	1715611520894	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611522900	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611522900	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5476	1715611522900	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611526938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611527939	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611531925	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611531925	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611538946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611538946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5482	1715611538946	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611538977	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611540979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611541978	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611544986	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611545980	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611547989	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611549003	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611550000	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611550997	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610983432	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610983432	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5231999999999997	1715610983432	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610984435	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715610984435	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5231999999999997	1715610984435	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610987470	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610989478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610997495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611004487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611004487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5284	1715611004487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611005489	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611005489	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5284	1715611005489	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611006492	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611006492	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5284	1715611006492	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611007495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611007495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5267	1715611007495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611008497	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611008497	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5267	1715611008497	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611009500	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611009500	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5267	1715611009500	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611316338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715611316338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5438	1715611316338	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611317341	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611317341	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5438	1715611317341	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611318371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611320369	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611325394	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611327374	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611327374	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5458000000000003	1715611327374	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611328403	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611329404	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611331410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611334393	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611334393	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5437	1715611334393	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611337425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611340429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611341443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611344447	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611346453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611347450	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611348454	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611350465	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611360488	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611363471	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611363471	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611363471	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611364473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611364473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611364473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611370487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611370487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611370487	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611376504	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715610983458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715610987443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715610987443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5252	1715610987443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715610989450	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715610989450	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5241	1715610989450	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715610997470	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715610997470	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5244	1715610997470	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611002508	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611004512	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611005509	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611006520	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611007524	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611008525	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611016518	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611016518	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5292	1715611016518	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611016548	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611017521	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611017521	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5292	1715611017521	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611017550	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611018523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611018523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5292	1715611018523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611018549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611019526	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611019526	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715611019526	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611019551	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611020529	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611020529	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715611020529	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611020547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611021531	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611021531	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5254000000000003	1715611021531	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611021557	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611022534	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611022534	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5263	1715611022534	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611022560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611023536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611023536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5263	1715611023536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611023564	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611024538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611024538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5263	1715611024538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611024556	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611025541	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611025541	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5282	1715611025541	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611025561	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611026544	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.299999999999999	1715611026544	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5282	1715611026544	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611026569	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611027547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611027547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5282	1715611027547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611027578	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611028549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.9	1715611028549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5309	1715611028549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611034566	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611034566	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.532	1715611034566	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611037575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611037575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5326	1715611037575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611038577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611038577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5326	1715611038577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611039610	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611046598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611046598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5321	1715611046598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611047600	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611047600	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5321	1715611047600	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611054637	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611059658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611063642	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611063642	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5319000000000003	1715611063642	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611065666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611067679	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611069685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611071691	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611072690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611075675	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611075675	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611075675	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611316367	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611318345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611318345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5438	1715611318345	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611320349	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611320349	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611320349	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611325368	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611325368	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5458000000000003	1715611325368	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611326371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611326371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5458000000000003	1715611326371	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611328376	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611328376	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611328376	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611329379	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611329379	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611329379	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611331385	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611331385	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611331385	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611333416	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611334421	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611340410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611340410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611340410	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611341412	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611341412	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611341412	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611344420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611344420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611028568	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611034587	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611037601	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611038604	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611040605	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611046627	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611047620	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611059632	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611059632	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5323	1715611059632	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611061665	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611063670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611067653	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611067653	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5322	1715611067653	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611069658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611069658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5322	1715611069658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611071663	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611071663	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5345999999999997	1715611071663	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611072666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611072666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5345999999999997	1715611072666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611074690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611075701	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611317369	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611322468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611324383	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611337400	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611337400	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611337400	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611338429	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611339425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611349461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611351459	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611352467	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611358484	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611359488	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611361494	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611366505	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611367505	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611378535	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611379537	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611382547	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611386549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611390540	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611390540	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611390540	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611395556	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611395556	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5452	1715611395556	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611398563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611398563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.542	1715611398563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611403575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611403575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611403575	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611405580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611405580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611405580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611406584	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.8	1715611406584	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611406584	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611414607	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611029552	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611029552	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5309	1715611029552	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611030555	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611030555	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5309	1715611030555	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611031580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611033585	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611039580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611039580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5326	1715611039580	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611044593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611044593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.533	1715611044593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611048623	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611049634	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611053644	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611055640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611057655	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611058660	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611060658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611064645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611064645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5331	1715611064645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611066649	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611066649	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5331	1715611066649	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611068655	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611068655	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5322	1715611068655	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611319347	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611319347	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611319347	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611321354	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611321354	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611321354	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611332388	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611332388	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611332388	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611333390	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611333390	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611333390	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611354473	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611355480	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611368508	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611369511	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611375529	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611392563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611396581	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611401590	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611410596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.299999999999999	1715611410596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611410596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611415629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611420656	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611421651	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611426638	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611426638	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5410999999999997	1715611426638	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611427640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611427640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611427640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611428645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611428645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611029573	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611031558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611031558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5324	1715611031558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611033563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611033563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5324	1715611033563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611035569	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611035569	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.532	1715611035569	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611043618	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611044617	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611049605	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611049605	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5333	1715611049605	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611053616	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611053616	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5316	1715611053616	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611055622	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611055622	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611055622	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611057627	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611057627	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611057627	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611058629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611058629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5323	1715611058629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611060634	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.699999999999999	1715611060634	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5323	1715611060634	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611061637	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611061637	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5319000000000003	1715611061637	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611064673	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611066678	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611068742	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611319374	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611321378	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611332416	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611354448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611354448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611354448	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611355451	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611355451	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611355451	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611368483	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611368483	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611368483	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611369485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611369485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611369485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611375502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611375502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5397	1715611375502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611392546	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611392546	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425999999999997	1715611392546	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611396558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611396558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5452	1715611396558	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611401570	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611401570	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611401570	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611408589	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611030574	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611032582	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611036572	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611036572	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.532	1715611036572	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611040582	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611040582	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5332	1715611040582	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611041615	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611042610	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611050608	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611050608	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5333	1715611050608	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611051611	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611051611	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5333	1715611051611	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611074673	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611074673	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611074673	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611322357	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611322357	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431999999999997	1715611322357	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	112.9	1715611324363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611324363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431999999999997	1715611324363	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611335396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611335396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5437	1715611335396	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611338403	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611338403	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611338403	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611339407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611339407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5424	1715611339407	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611349433	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611349433	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611349433	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611351440	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611351440	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611351440	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611352443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611352443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611352443	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611358458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611358458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431	1715611358458	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611359461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611359461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431	1715611359461	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611361466	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611361466	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611361466	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611366478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611366478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611366478	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611367481	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8	1715611367481	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5408000000000004	1715611367481	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611378510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611378510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416999999999996	1715611378510	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611379513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611379513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5415	1715611379513	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611032560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611032560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5324	1715611032560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611035588	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611036598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611041585	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611041585	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5332	1715611041585	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611042587	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611042587	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5332	1715611042587	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611043590	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611043590	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.533	1715611043590	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611050628	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611073690	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611323361	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611323361	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431999999999997	1715611323361	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611326405	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611330382	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611330382	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611330382	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611335414	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611336426	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611342441	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611343446	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611345453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611353476	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611356470	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611357485	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611364497	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611371491	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611371491	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611371491	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611372494	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611372494	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611372494	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611373496	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.4	1715611373496	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5397	1715611373496	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611374499	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611374499	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5397	1715611374499	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611377507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.6	1715611377507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416999999999996	1715611377507	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611383523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611383523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611383523	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611384525	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611384525	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611384525	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611385528	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.899999999999999	1715611385528	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611385528	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611387533	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611387533	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611387533	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611388563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611389562	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611391573	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611400593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611407604	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611045596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.5	1715611045596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.533	1715611045596	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611048603	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611048603	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5321	1715611048603	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611052614	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611052614	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5316	1715611052614	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611054619	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611054619	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5316	1715611054619	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611056653	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611062666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	108.9	1715611070661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1	1715611070661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5345999999999997	1715611070661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611073670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611073670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611073670	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611323387	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611327402	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611330401	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611336399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611336399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5437	1715611336399	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611342414	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611342414	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611342414	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611343417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611343417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611343417	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611345422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611345422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611345422	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611353446	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611353446	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5445	1715611353446	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611356453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611356453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611356453	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611357456	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611357456	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5434	1715611357456	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611362493	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611365475	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611365475	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611365475	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611371516	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611372519	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611373514	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611374527	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611377535	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611383551	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611384549	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611385548	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611387551	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611389538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611389538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611389538	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611391543	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611391543	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425999999999997	1715611391543	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611400568	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611045621	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611051642	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611052639	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611056625	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.9	1715611056625	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611056625	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611062640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611062640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5319000000000003	1715611062640	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611065647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611065647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5331	1715611065647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611070679	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611076678	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611076678	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5362	1715611076678	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611076697	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611077680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611077680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5362	1715611077680	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611077699	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611078682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611078682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5362	1715611078682	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611078711	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611079685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611079685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611079685	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611079701	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611080687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611080687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611080687	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611080709	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611081689	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611081689	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5355	1715611081689	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611081716	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611082692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611082692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.534	1715611082692	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611082717	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611083696	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611083696	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.534	1715611083696	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611083729	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611084700	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611084700	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.534	1715611084700	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611084723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611085704	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611085704	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611085704	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611085728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611086707	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611086707	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611086707	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611086730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611087710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611087710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5347	1715611087710	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611087730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611088713	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611088713	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611088713	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611088732	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611092740	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611097735	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611097735	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5348	1715611097735	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611111796	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611119817	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611122835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611127842	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5428	1715611344420	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611346425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611346425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611346425	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611347427	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611347427	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611347427	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	110.9	1715611348430	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611348430	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611348430	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611350437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.2	1715611350437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611350437	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611360463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611360463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5431	1715611360463	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611362468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611362468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.544	1715611362468	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611363502	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611365495	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611370506	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611376530	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611380534	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611381544	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611393577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611394582	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611397586	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611399594	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611402601	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611404602	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611409593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611409593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611409593	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611412601	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.5	1715611412601	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611412601	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611417615	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611417615	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611417615	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611418618	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611418618	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611418618	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611422629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611422629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611422629	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611425635	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611425635	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5410999999999997	1715611425635	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611497860	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611498859	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611500875	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611501867	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611504871	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611510890	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611521924	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611089715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611089715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611089715	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611098737	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611098737	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5348	1715611098737	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611101746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.8999999999999995	1715611101746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5361	1715611101746	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611102749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611102749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5361	1715611102749	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611109768	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611109768	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5388	1715611109768	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611110770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611110770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5388	1715611110770	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611113778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611113778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5391	1715611113778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611116786	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611116786	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611116786	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611121802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611121802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611121802	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611124832	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611126844	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611128850	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611130847	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611135869	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611376504	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416999999999996	1715611376504	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611380515	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611380515	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5415	1715611380515	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611381517	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611381517	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5415	1715611381517	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611393550	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611393550	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5425999999999997	1715611393550	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611394553	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.3	1715611394553	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5452	1715611394553	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611397560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.7	1715611397560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.542	1715611397560	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611399565	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611399565	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.542	1715611399565	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611402573	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.4	1715611402573	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611402573	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611404577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611404577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5399000000000003	1715611404577	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611408608	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611409617	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611412627	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611417644	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611418654	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611422657	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611089733	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611098764	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611101775	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611102778	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611109788	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611110789	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611114801	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611117819	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611124810	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611124810	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5351999999999997	1715611124810	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611126814	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611126814	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5351999999999997	1715611126814	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611128819	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611128819	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611128819	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611130825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611130825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611130825	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611135839	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611135839	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611135839	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611382520	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.9	1715611382520	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5416	1715611382520	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611386530	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.2	1715611386530	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611386530	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611388536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611388536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611388536	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611390563	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611395581	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611398588	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611403599	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611405607	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611406608	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611414636	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611423630	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611423630	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611423630	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611432656	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611432656	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611432656	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611435694	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611501842	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5478	1715611501842	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611504850	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611504850	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5495	1715611504850	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611510865	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611510865	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611510865	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611521897	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611521897	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5476	1715611521897	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611524906	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611524906	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.55	1715611524906	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611530923	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611530923	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611530923	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611531925	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611090717	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611090717	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611090717	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611091719	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611091719	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5358	1715611091719	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611095730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611095730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715611095730	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611099740	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611099740	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5348	1715611099740	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611105759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.3	1715611105759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611105759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611106760	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611106760	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5357	1715611106760	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611107763	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611107763	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5357	1715611107763	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611111773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611111773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5388	1715611111773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611113809	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611115783	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.9	1715611115783	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611115783	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611117790	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611117790	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5364	1715611117790	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611118824	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611120832	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611123807	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.9	1715611123807	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611123807	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611125812	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611125812	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5351999999999997	1715611125812	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611129846	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.1000000000000005	1715611400568	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5387	1715611400568	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611407586	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611407586	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611407586	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611411598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.8	1715611411598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5427	1715611411598	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611413604	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611413604	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611413604	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611416612	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611416612	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611416612	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611419621	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611419621	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611419621	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611424633	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611424633	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5410999999999997	1715611424633	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611431654	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611431654	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611431654	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611434661	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611090742	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611091744	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611095750	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611104783	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611105789	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611106786	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611108788	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611112805	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611114780	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611114780	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5391	1715611114780	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611115803	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611118793	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611118793	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.537	1715611118793	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611120799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611120799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.537	1715611120799	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611121830	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611123841	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611125836	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.5	1715611408589	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5413	1715611408589	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611410615	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611420624	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611420624	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5441	1715611420624	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611421626	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611421626	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.541	1715611421626	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611425651	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611426666	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611427665	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611428673	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611429674	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611430668	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611433684	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611502879	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611505879	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611507981	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611509879	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611511894	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611517884	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611517884	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5481	1715611517884	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611519892	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611519892	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5481	1715611519892	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611523928	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611525909	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611525909	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.55	1715611525909	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611534934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611534934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496	1715611534934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611535964	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611536966	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611537971	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611539967	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611544960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611544960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611546995	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611549975	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611549975	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5486	1715611549975	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611092723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611092723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5358	1715611092723	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611096750	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611097755	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611119796	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611119796	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.537	1715611119796	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611122804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611122804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611122804	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611127816	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611127816	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611127816	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611411625	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611413631	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611416645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611419646	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611424658	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611431681	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611434688	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611507857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5503	1715611507857	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	113	1715611509862	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611509862	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611509862	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611511868	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611511868	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611511868	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611513892	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611517905	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611523903	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611523903	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.55	1715611523903	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611524934	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611525933	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611534962	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611536940	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611536940	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611536940	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611537943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611537943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611537943	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611539949	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611539949	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5482	1715611539949	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611546965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611546965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611546965	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496999999999996	1715611550977	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611551979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611551979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496999999999996	1715611551979	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611552982	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611552982	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5496999999999996	1715611552982	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611553985	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611553985	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611553985	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611554988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.7	1715611554988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5493	1715611554988	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611555990	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611555990	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611093725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.1	1715611093725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5358	1715611093725	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611094728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611094728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715611094728	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611096733	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611096733	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5216	1715611096733	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611100743	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611100743	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5361	1715611100743	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611103752	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611103752	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611103752	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611104755	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611104755	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5368000000000004	1715611104755	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611108766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	6.8	1715611108766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5357	1715611108766	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611116816	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611131828	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.6	1715611131828	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611131828	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611132830	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611132830	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5394	1715611132830	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611133833	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611133833	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611133833	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611134835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	12.799999999999999	1715611134835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.536	1715611134835	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611414607	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5405	1715611414607	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611415609	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611415609	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5418000000000003	1715611415609	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611423653	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611435665	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611435665	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611435665	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611512870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611512870	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611513873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611513873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5439000000000003	1715611513873	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611516911	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611520924	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611522926	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611527914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611527914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5488000000000004	1715611527914	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611535938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611535938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5504000000000002	1715611535938	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611540950	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.1	1715611540950	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5482	1715611540950	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611541953	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611541953	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5502	1715611541953	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611544960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611093748	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611094744	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611099759	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611100762	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611103773	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611107788	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611112775	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7	1715611112775	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5391	1715611112775	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611129822	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611129822	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5372	1715611129822	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611131852	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.0768	1715611132859	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611133862	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611134858	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611428645	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	101	1715611429647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611429647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5403000000000002	1715611429647	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611430651	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611430651	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5433000000000003	1715611430651	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611433659	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611433659	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5450999999999997	1715611433659	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611515877	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611515877	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5464	1715611515877	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611518889	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611518889	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5481	1715611518889	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611519910	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611528937	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611529948	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611532951	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611533960	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611542980	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611543984	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611552006	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611554011	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611555013	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611556014	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611557013	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611558014	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611559023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.7	1715611560002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611560002	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611560023	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.000000000000001	1715611561004	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611561004	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611561025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611562007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611562007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5514	1715611562007	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611562032	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611563010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611563010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5525	1715611563010	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611563026	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611564012	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611564012	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5525	1715611564012	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611564040	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611565015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611565015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5525	1715611565015	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611565036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	105	1715611568022	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611568022	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5507	1715611568022	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611568044	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611569025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	8.3	1715611569025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5507	1715611569025	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611569047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611566017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611566017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5509	1715611566017	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611567020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611567020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5509	1715611567020	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611576067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611580075	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	106	1715611583063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.8	1715611583063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5541	1715611583063	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611566041	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611576045	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611576045	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5523000000000002	1715611576045	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611579052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611579052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5516	1715611579052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611582081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611583081	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611567037	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611571052	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611580055	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.5	1715611580055	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5518	1715611580055	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611581080	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611570027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611570027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5507	1715611570027	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611572033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611572033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5535	1715611572033	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611573036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	5.300000000000001	1715611573036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5535	1715611573036	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611574059	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611575060	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611577067	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611578069	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611570047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611572056	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611574039	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611574039	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5523000000000002	1715611574039	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	104	1715611575042	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	9.799999999999999	1715611575042	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5523000000000002	1715611575042	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611577047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611577047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5516	1715611577047	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611578050	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.4	1715611578050	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5516	1715611578050	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611579073	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611571030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	7.2	1715611571030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5535	1715611571030	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Swap Memory GB	0.077	1715611573055	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	103	1715611581057	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10.2	1715611581057	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5518	1715611581057	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - CPU Utilization	102	1715611582060	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Utilization	10	1715611582060	5bc80495ccb3484b90fcbcd50237f51c	0	f
TOP - Memory Usage GB	2.5518	1715611582060	5bc80495ccb3484b90fcbcd50237f51c	0	f
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
letter	0	455abcb56d1e4c7286880320d6b54111
workload	0	455abcb56d1e4c7286880320d6b54111
listeners	smi+top+dcgmi	455abcb56d1e4c7286880320d6b54111
params	'"-"'	455abcb56d1e4c7286880320d6b54111
file	cifar10.py	455abcb56d1e4c7286880320d6b54111
workload_listener	''	455abcb56d1e4c7286880320d6b54111
letter	0	5bc80495ccb3484b90fcbcd50237f51c
workload	0	5bc80495ccb3484b90fcbcd50237f51c
listeners	smi+top+dcgmi	5bc80495ccb3484b90fcbcd50237f51c
params	'"-"'	5bc80495ccb3484b90fcbcd50237f51c
file	cifar10.py	5bc80495ccb3484b90fcbcd50237f51c
workload_listener	''	5bc80495ccb3484b90fcbcd50237f51c
model	cifar10.py	5bc80495ccb3484b90fcbcd50237f51c
manual	False	5bc80495ccb3484b90fcbcd50237f51c
max_epoch	5	5bc80495ccb3484b90fcbcd50237f51c
max_time	172800	5bc80495ccb3484b90fcbcd50237f51c
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
455abcb56d1e4c7286880320d6b54111	calm-grouse-280	UNKNOWN			daga	FAILED	1715610500686	1715610624854		active	s3://mlflow-storage/0/455abcb56d1e4c7286880320d6b54111/artifacts	0	\N
5bc80495ccb3484b90fcbcd50237f51c	(0 0) angry-skunk-587	UNKNOWN			daga	FINISHED	1715610783716	1715611585016		active	s3://mlflow-storage/0/5bc80495ccb3484b90fcbcd50237f51c/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	455abcb56d1e4c7286880320d6b54111
mlflow.source.name	file:///home/daga/radt#examples/pytorch	455abcb56d1e4c7286880320d6b54111
mlflow.source.type	PROJECT	455abcb56d1e4c7286880320d6b54111
mlflow.project.entryPoint	main	455abcb56d1e4c7286880320d6b54111
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	455abcb56d1e4c7286880320d6b54111
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	455abcb56d1e4c7286880320d6b54111
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	455abcb56d1e4c7286880320d6b54111
mlflow.runName	calm-grouse-280	455abcb56d1e4c7286880320d6b54111
mlflow.project.env	conda	455abcb56d1e4c7286880320d6b54111
mlflow.project.backend	local	455abcb56d1e4c7286880320d6b54111
mlflow.user	daga	5bc80495ccb3484b90fcbcd50237f51c
mlflow.source.name	file:///home/daga/radt#examples/pytorch	5bc80495ccb3484b90fcbcd50237f51c
mlflow.source.type	PROJECT	5bc80495ccb3484b90fcbcd50237f51c
mlflow.project.entryPoint	main	5bc80495ccb3484b90fcbcd50237f51c
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	5bc80495ccb3484b90fcbcd50237f51c
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5bc80495ccb3484b90fcbcd50237f51c
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5bc80495ccb3484b90fcbcd50237f51c
mlflow.project.env	conda	5bc80495ccb3484b90fcbcd50237f51c
mlflow.project.backend	local	5bc80495ccb3484b90fcbcd50237f51c
mlflow.runName	(0 0) angry-skunk-587	5bc80495ccb3484b90fcbcd50237f51c
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

