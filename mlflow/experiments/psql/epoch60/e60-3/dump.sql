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
0	Default	s3://mlflow-storage/0	active	1715622728832	1715622728832
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
SMI - Power Draw	15.22	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
SMI - Timestamp	1715622919.168	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
SMI - GPU Util	0	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
SMI - Mem Util	0	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
SMI - Mem Used	0	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
SMI - Performance State	0	1715622919182	0	f	7d29749dc9194bd48eefcfaa5213f208
TOP - CPU Utilization	2	1715624200940	0	f	7d29749dc9194bd48eefcfaa5213f208
TOP - Memory Usage GB	2.7409	1715624200940	0	f	7d29749dc9194bd48eefcfaa5213f208
TOP - Memory Utilization	5.9	1715624200940	0	f	7d29749dc9194bd48eefcfaa5213f208
TOP - Swap Memory GB	0.0867	1715624200960	0	f	7d29749dc9194bd48eefcfaa5213f208
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.22	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
SMI - Timestamp	1715622919.168	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
SMI - GPU Util	0	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
SMI - Mem Util	0	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
SMI - Mem Used	0	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
SMI - Performance State	0	1715622919182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	0	1715622919250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	0	1715622919250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.0031	1715622919250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622919267	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	213.39999999999998	1715622920252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.1	1715622920252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.0031	1715622920252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622920268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622921254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622921254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.0031	1715622921254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622921268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622922256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622922256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.5086	1715622922256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622922284	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622923258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715622923258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.5086	1715622923258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622923283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622924260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622924260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.5086	1715622924260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0737	1715622924274	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622925262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622925262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.711	1715622925262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622925285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622926264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622926264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.711	1715622926264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622926721	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622927266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622927266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.711	1715622927266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622927281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	145	1715622928269	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622928269	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7405999999999997	1715622928269	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622928283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622929271	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622929271	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7405999999999997	1715622929271	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622929287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622930273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622930273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7405999999999997	1715622930273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622930295	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622931275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622931275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7413000000000003	1715622931275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622931297	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622932277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622932277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7413000000000003	1715622932277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622932291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622933279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622933279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7413000000000003	1715622933279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622933300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622940294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622940294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7463	1715622940294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622943300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.8	1715622943300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7441	1715622943300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622944302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622944302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7441	1715622944302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622946306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622946306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6607	1715622946306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622948310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622948310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6607	1715622948310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622949332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622952340	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622956349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622970357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622970357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6688	1715622970357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622973364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622973364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622973364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622974365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622974365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622974365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622976370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622976370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6714	1715622976370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622980391	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622986417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622989417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623230893	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623230893	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6904	1715623230893	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623231895	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623231895	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623231895	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623233900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623233900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623233900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623237908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623237908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623237908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623239912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623239912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623239912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623246930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623246930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6925	1715623246930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623255971	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623257974	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623260975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623261983	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623266993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623272985	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623272985	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6942	1715623272985	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623275991	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623275991	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623275991	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623277995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622934281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622934281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7425	1715622934281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715622938289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622938289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.742	1715622938289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622945304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622945304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7441	1715622945304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622947308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622947308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6607	1715622947308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622963341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622963341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6666999999999996	1715622963341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622966349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622966349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6669	1715622966349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622967351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622967351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6656	1715622967351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622969355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715622969355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6656	1715622969355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622971359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622971359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6688	1715622971359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622978374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622978374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6714	1715622978374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622982382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.6	1715622982382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622982382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622987392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622987392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6702	1715622987392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623230914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623231921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623233921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623237929	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623239930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623255950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623255950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6919	1715623255950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623257954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623257954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6919	1715623257954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623260960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623260960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6921	1715623260960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623261962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715623261962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6892	1715623261962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623266972	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623266972	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6927	1715623266972	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623271983	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.100000000000001	1715623271983	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6942	1715623271983	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623273006	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623276005	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623278008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623279014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623280015	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622934299	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622938315	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622945326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622947322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622963362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622966365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622967374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622969377	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622975368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622975368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622975368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622978393	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622982405	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622987413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623232897	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623232897	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623232897	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623243920	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623243920	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623243920	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623246951	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623256952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623256952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6919	1715623256952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623259980	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623262985	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623263987	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623264985	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623285010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623285010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6936	1715623285010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623411293	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623412287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623414280	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623414280	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623414280	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623417309	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623421294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623421294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7023	1715623421294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623424300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623424300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7022	1715623424300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623425326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623427328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623435324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715623435324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7016	1715623435324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623436326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623436326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7016	1715623436326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623437328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623437328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7016	1715623437328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623441336	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623441336	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623441336	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623454363	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623454363	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7036	1715623454363	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623456367	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623456367	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623456367	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623460376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622935283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622935283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7425	1715622935283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622936307	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622941318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622942318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622951338	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622955340	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622957347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622958346	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622960356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622964343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715622964343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6669	1715622964343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622972361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622972361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6688	1715622972361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622977372	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715622977372	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6714	1715622977372	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622980378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622980378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622980378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622981394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622983408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622988414	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623232920	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623243941	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623248962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623256972	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623262964	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623262964	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6892	1715623262964	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623263966	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623263966	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6892	1715623263966	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623264968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623264968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6927	1715623264968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623272005	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623285024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623413276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623413276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.704	1715623413276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623419290	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715623419290	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7014	1715623419290	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623426305	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623426305	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623426305	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623430313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623430313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623430313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623433339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623438351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623439347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623442362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623444364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623445359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623448370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623450371	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623452373	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623453383	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623457385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623472424	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622935306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622941296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622941296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7463	1715622941296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622943313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622944318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622946327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622948332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622952318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622952318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6643000000000003	1715622952318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622956326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622956326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.663	1715622956326	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622962359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622970371	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622973388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622974387	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622976391	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622986389	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622986389	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6702	1715622986389	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622989396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622989396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6674	1715622989396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623234902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623234902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623234902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623235904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623235904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623235904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623236906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623236906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623236906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623242918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623242918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6877	1715623242918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623245928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623245928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623245928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623258956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623258956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6921	1715623258956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623259958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623259958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6921	1715623259958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623268001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623269992	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623274008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623277006	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623282019	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623283020	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623287031	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623290043	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623417286	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623417286	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7014	1715623417286	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623425302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623425302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7022	1715623425302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623426327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623430327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623438330	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623438330	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622936285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.5	1715622936285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7425	1715622936285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622940315	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622942298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6	1715622942298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7463	1715622942298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622951316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715622951316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6633	1715622951316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622955324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622955324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.663	1715622955324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622957328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622957328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.663	1715622957328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622958331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622958331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.665	1715622958331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622960335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622960335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.665	1715622960335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622962339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715622962339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6666999999999996	1715622962339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622964363	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622972383	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622977385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715622981380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622981380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622981380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622983384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622983384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622983384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622988394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622988394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6674	1715622988394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623234915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623235925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623236931	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623242940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623245949	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623258977	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623265994	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623269979	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623269979	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6931	1715623269979	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623273987	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623273987	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623273987	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623276993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623276993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6949	1715623276993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623282004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623282004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6946	1715623282004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623283006	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715623283006	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6895	1715623283006	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623287014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623287014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6936	1715623287014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623290021	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623290021	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622937287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.6	1715622937287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.742	1715622937287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622939291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622939291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.742	1715622939291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622949312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622949312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6633	1715622949312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622950328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622953342	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622954344	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622959354	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622961358	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622965360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622968366	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622975389	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622979391	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622984410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622985402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623238910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623238910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6913	1715623238910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623240914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623240914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6877	1715623240914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623241916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623241916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6877	1715623241916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623244924	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623244924	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623244924	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623247932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623247932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6925	1715623247932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623248935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623248935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6925	1715623248935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623249949	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623250961	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623251962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623252964	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623253966	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623254962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623267975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715623267975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6931	1715623267975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623268990	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623271001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623275004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623281015	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623284024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623286027	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623289040	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623419313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623429311	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623429311	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623429311	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623432339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623434344	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623440356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623443362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623446360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623447370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623459387	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622937310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715622939306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622950314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622950314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6633	1715622950314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715622953320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622953320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6643000000000003	1715622953320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622954322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622954322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6643000000000003	1715622954322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622959333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622959333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.665	1715622959333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622961337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622961337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6666999999999996	1715622961337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622965345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715622965345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6669	1715622965345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622968353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622968353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6656	1715622968353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622971385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622979376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622979376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6691	1715622979376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622984385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622984385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622984385	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622985387	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622985387	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6702	1715622985387	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622990398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715622990398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6674	1715622990398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622990419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622991400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715622991400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6685	1715622991400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622991421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622992402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715622992402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6685	1715622992402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622992416	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622993404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622993404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6685	1715622993404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622993427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715622994406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622994406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622994406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622994430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622995408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715622995408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622995408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622995422	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622996410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622996410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6686	1715622996410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622996425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715622997412	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715622997412	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6708000000000003	1715622997412	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622997434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622999438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623000432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623007433	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715623007433	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623007433	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623008456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623009457	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623011462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623013468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623015463	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623025472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623025472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623025472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623028478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.6	1715623028478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623028478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623030482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623030482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6738000000000004	1715623030482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623037496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623037496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623037496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623040502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623040502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6751	1715623040502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623042507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623042507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6761999999999997	1715623042507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623045513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623045513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6746	1715623045513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623047518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623047518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6746	1715623047518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623238935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623240935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623241937	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623244945	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623247955	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623249936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623249936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6895	1715623249936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623250938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623250938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6895	1715623250938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623251940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623251940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6895	1715623251940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623252942	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623252942	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623252942	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623253945	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623253945	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623253945	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623254948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623254948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623254948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623265970	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623265970	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6927	1715623265970	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623268977	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623268977	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6931	1715623268977	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715622998415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715622998415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6708000000000003	1715622998415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623002423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623002423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6703	1715623002423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623010440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623010440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6678	1715623010440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623016474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623019458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623019458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6706999999999996	1715623019458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623020460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623020460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6706999999999996	1715623020460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623022466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623022466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6739	1715623022466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623031484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623031484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6738000000000004	1715623031484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623033488	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623033488	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6719	1715623033488	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623035492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623035492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6719	1715623035492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623048520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623048520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623048520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623270981	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623270981	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6942	1715623270981	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623274989	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623274989	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623274989	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623281002	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623281002	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6946	1715623281002	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623284008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623284008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6895	1715623284008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623286012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623286012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6936	1715623286012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623289018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623289018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6928	1715623289018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623420307	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623432318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623432318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623432318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623434322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623434322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623434322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623440334	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623440334	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7032	1715623440334	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623443341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715623443341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623443341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623446347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623446347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715622998436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623002437	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623010453	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623018477	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623019480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623020481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623022479	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623031500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623033511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623035513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623048544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623277995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6949	1715623277995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623278997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623278997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6949	1715623278997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623280000	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623280000	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6946	1715623280000	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623288017	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623288017	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6928	1715623288017	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7032	1715623438330	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623439332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623439332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7032	1715623439332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623442339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623442339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623442339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623444343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623444343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623444343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623445345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623445345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623445345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623448351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623448351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051	1715623448351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623450355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623450355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623450355	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623452360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623452360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623452360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623453361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623453361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7036	1715623453361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623457369	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623457369	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623457369	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623472402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623472402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623472402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623473404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623473404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623473404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623474406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623474406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7064	1715623474406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623478413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623478413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623478413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623481419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	13	1715623481419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715622999417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6	1715622999417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6708000000000003	1715622999417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623000419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623000419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6703	1715623000419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623001443	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623007447	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623009437	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623009437	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6678	1715623009437	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623011442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623011442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6678	1715623011442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623013446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623013446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6689000000000003	1715623013446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623015450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623015450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.67	1715623015450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623018456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623018456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6706999999999996	1715623018456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623025485	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623028493	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623030495	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623037511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623040520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623042528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623045526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623047541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623288034	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623446347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623447349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623447349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051	1715623447349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623459374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623459374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7001999999999997	1715623459374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623464384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623464384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7034000000000002	1715623464384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623465386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623465386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623465386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623468392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623468392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623468392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623470398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623470398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623470398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623477411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623477411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623477411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623479429	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623483444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623486451	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623498454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623498454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7060999999999997	1715623498454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623499456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623499456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7060999999999997	1715623499456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623504467	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623001421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623001421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6703	1715623001421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623003425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623003425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6724	1715623003425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623003439	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623004427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623004427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6724	1715623004427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623004442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623005429	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715623005429	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6724	1715623005429	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623005446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623006431	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623006431	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623006431	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623006453	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623008435	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623008435	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623008435	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623012444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623012444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6689000000000003	1715623012444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623012464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623014469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623016452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.6	1715623016452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.67	1715623016452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623017454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623017454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.67	1715623017454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623017476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623021464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623021464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6739	1715623021464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623021484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623023468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623023468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6739	1715623023468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623023489	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623024490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623026474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623026474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623026474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623027476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623027476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623027476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623027498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623029480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715623029480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623029480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623029496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623032486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623032486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6738000000000004	1715623032486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623034490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623034490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6719	1715623034490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623034504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623036494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623036494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623036494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623014448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623014448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6689000000000003	1715623014448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623024470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623024470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623024470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623026492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623032506	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623046537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623049545	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6928	1715623290021	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623460376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7001999999999997	1715623460376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	108	1715623461378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623461378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7001999999999997	1715623461378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623463382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623463382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7034000000000002	1715623463382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623466388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623466388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623466388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623469394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623469394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623469394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623471400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623471400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623471400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623475408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623475408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7064	1715623475408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623480417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623480417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623480417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623482421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623482421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623482421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623487432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623487432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623487432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	106.9	1715623491440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623491440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7054	1715623491440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623497452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623497452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623497452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623499469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623503465	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623503465	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7055	1715623503465	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623510500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623514502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623515510	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623518511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623520521	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623525531	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623528516	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.7	1715623528516	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7069	1715623528516	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623529518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623529518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7069	1715623529518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623535530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623535530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623036509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623038515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623039513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623041529	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623043530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623044526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623291023	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623291023	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6902	1715623291023	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623292048	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623293048	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623296055	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623301065	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623302068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623305067	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623321085	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623321085	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623321085	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623324092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623324092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623324092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623325094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623325094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623325094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623330104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623330104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623330104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623331128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623338122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623338122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623338122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623339124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715623339124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6971	1715623339124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623341128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623341128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6971	1715623341128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623348144	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623348144	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6933000000000002	1715623348144	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623464406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623465400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623468412	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623470422	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623477432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623483423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623483423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623483423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623486430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623486430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623486430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623496474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623498475	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623500480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623504488	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623506492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623507494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623512504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623519498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623519498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623519498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623524508	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623524508	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623524508	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623527514	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623038498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.9	1715623038498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623038498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623039500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623039500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6751	1715623039500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623041505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715623041505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6751	1715623041505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623043509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.6000000000000005	1715623043509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6761999999999997	1715623043509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623044511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623044511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6761999999999997	1715623044511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623291046	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623299039	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715623299039	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623299039	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623304050	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623304050	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623304050	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623313068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623313068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623313068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623314070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623314070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623314070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623315072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623315072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623315072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623316074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623316074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623316074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623319080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623319080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623319080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623323089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623323089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623323089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623328100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623328100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6961999999999997	1715623328100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623332109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623332109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623332109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623336134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623343153	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623344155	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623345150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623347163	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623349160	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623473424	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623474420	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623478434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623481432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623488448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623501460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.3	1715623501460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7055	1715623501460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623502462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623502462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7055	1715623502462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623509477	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623046515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623046515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6746	1715623046515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623049522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623049522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623049522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623050524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623050524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.675	1715623050524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623050545	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623051526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623051526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623051526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623051547	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623052528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623052528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623052528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623052551	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623053530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.6	1715623053530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623053530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623053553	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623054532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623054532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6728	1715623054532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623054546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623055534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623055534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6728	1715623055534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623055555	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623056536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623056536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6728	1715623056536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623056558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623057538	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623057538	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736999999999997	1715623057538	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623057559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623058540	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623058540	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736999999999997	1715623058540	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623058563	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623059542	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623059542	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736999999999997	1715623059542	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623059556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623060544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623060544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623060544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623060558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623061546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623061546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623061546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623061570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623062549	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623062549	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6735	1715623062549	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623062570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623063550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.7	1715623063550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623063550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623063570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623064552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623064552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623064552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623065574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623069576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623071587	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623076576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623076576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623076576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623078580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623078580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623078580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623082588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623082588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623082588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623084592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623084592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6774	1715623084592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623090604	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623090604	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623090604	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623095614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623095614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623095614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623102629	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623102629	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6826	1715623102629	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623106637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623106637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6814	1715623106637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623108640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623108640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6823	1715623108640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623292025	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623292025	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6902	1715623292025	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623293027	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.7	1715623293027	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6902	1715623293027	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623296033	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623296033	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6938	1715623296033	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623301044	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.8	1715623301044	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6959	1715623301044	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623302046	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623302046	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6959	1715623302046	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623305052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715623305052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623305052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623311087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623321106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623324105	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623325108	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623331106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623331106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623331106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623335130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623338136	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623339139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623341151	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623348157	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7043000000000004	1715623481419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623488434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623488434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623064573	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623070585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623077599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623079597	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623080607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623081601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623083603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623087611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623088614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623093610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623093610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623093610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623096616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623096616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623096616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623097618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623097618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623097618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623099622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623099622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6795999999999998	1715623099622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623101626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623101626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6795999999999998	1715623101626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623105634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623105634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6814	1715623105634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623294029	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623294029	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6938	1715623294029	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623297057	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623303060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623307056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623307056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623307056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623308058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623308058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623308058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623309060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623309060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6963000000000004	1715623309060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623317076	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623317076	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623317076	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623318078	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623318078	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623318078	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623320082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623320082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623320082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623327098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623327098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6961999999999997	1715623327098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623329102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623329102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6961999999999997	1715623329102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623333111	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623333111	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.696	1715623333111	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623334113	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623334113	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.696	1715623334113	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623337120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715623337120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623065554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623065554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623065554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623069562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623069562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6749	1715623069562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623071566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623071566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6749	1715623071566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623073570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623073570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6687	1715623073570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623076590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623078601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623082610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623084613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623094627	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623095629	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623102643	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623106650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623108661	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623294051	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623303048	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623303048	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6958	1715623303048	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623306075	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623307077	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623308078	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623309081	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623317097	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623318095	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623320103	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623327119	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623329115	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623333129	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623334127	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623337133	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623342150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623346161	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623488434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623496450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623496450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623496450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623501484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623502488	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623509492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623511504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623513502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623521502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623521502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623521502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623522504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623522504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623522504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623523506	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623523506	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623523506	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7088	1715623535530	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623536554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623539557	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623557578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.6	1715623557578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7072	1715623557578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623558580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623558580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623066556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623066556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736	1715623066556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623067558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623067558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736	1715623067558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623073591	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623089617	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623100624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623100624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6795999999999998	1715623100624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623104632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623104632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6826	1715623104632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623107639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623107639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6814	1715623107639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623109642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623109642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6823	1715623109642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623295031	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623295031	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6938	1715623295031	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623298037	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623298037	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623298037	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623300041	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623300041	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6959	1715623300041	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623306054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623306054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6939	1715623306054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623310075	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623312066	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623312066	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623312066	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623322087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623322087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623322087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623326096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623326096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986	1715623326096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623330125	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623335115	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623335115	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.696	1715623335115	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623340142	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	107	1715623490438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623490438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7054	1715623490438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623492442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623492442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623492442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623493444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623493444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623493444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623494446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623494446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623494446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623495448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623495448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623495448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623505469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623505469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623066578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623067579	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623089602	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623089602	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.678	1715623089602	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623094612	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623094612	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6775	1715623094612	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623100648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623104646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623107660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623109665	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623295045	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623298060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623300054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623310062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623310062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6963000000000004	1715623310062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623311064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623311064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6963000000000004	1715623311064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623312087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623322101	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623326117	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623332126	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623340126	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623340126	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6971	1715623340126	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623504467	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623504467	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623506471	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623506471	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623506471	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623507473	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623507473	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623507473	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623512483	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623512483	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7058	1715623512483	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623517516	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623519512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623524522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623527533	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623536533	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623536533	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7088	1715623536533	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623539539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623539539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623539539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623552583	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623557598	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623559582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623559582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7084	1715623559582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623560584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715623560584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7084	1715623560584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623561586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623561586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623561586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623566597	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623566597	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7099	1715623566597	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623569603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623068560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623068560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6736	1715623068560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623072568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623072568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6687	1715623072568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623074572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623074572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6687	1715623074572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623075574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623075574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623075574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623085594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623085594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6774	1715623085594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623086596	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623086596	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6774	1715623086596	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623091606	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623091606	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623091606	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623092608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623092608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623092608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623098620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623098620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6801999999999997	1715623098620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623103630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623103630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6826	1715623103630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623297035	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623297035	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623297035	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623299060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623304070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623313091	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623314092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623315085	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623316087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623319095	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623323111	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623328114	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623336118	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623336118	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623336118	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623343132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623343132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623343132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623344134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623344134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623344134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623345136	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623345136	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623345136	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623347142	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623347142	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623347142	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623349146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623349146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6933000000000002	1715623349146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.706	1715623505469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623508475	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623508475	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623508475	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623068573	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623072590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623074585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08059999999999999	1715623075590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623085610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623086610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623091621	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623092622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623098635	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623103651	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6979	1715623337120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623342130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623342130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623342130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623346139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623346139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6984	1715623346139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623509477	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051999999999996	1715623509477	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623511481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623511481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7058	1715623511481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623513485	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623513485	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623513485	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623516491	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623516491	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7081999999999997	1715623516491	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623521517	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623522518	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623523527	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623543547	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623543547	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7096	1715623543547	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623549580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623555596	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623575615	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623575615	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623575615	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7119	1715623578622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623579624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623579624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7125	1715623579624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623581630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623581630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7125	1715623581630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623582632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623582632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7102	1715623582632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623584636	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623584636	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7102	1715623584636	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623585638	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623585638	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7108000000000003	1715623585638	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623586640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623586640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7108000000000003	1715623586640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623588644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623588644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623588644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623589646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623589646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623589646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623070564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623070564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6749	1715623070564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623077578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623077578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6731	1715623077578	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623079582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623079582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623079582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623080584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623080584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623080584	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623081586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623081586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623081586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623083590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623083590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.673	1715623083590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623087598	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623087598	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.678	1715623087598	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623088600	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623088600	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.678	1715623088600	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623090617	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623093626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623096630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623097637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623099638	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623101648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623105655	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623110644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623110644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6823	1715623110644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623110666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623111646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623111646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6828000000000003	1715623111646	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623111667	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623112648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623112648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6828000000000003	1715623112648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623112671	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623113650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623113650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6828000000000003	1715623113650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623113673	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623114652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623114652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6792	1715623114652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623114667	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623115655	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715623115655	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6792	1715623115655	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623115674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623116657	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623116657	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6792	1715623116657	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623116680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623117659	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623117659	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6825	1715623117659	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623117672	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623118661	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.299999999999999	1715623118661	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6825	1715623118661	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623119681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623122682	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623123696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623128697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623129697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623134712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623135718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623136720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623145734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623146737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623148736	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623153748	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623156761	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623161770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623162765	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623167783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623350149	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623350149	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6933000000000002	1715623350149	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623353154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623353154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623353154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623355158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623355158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623355158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623360191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623362194	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623366201	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623369207	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623375216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623377226	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623378217	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623382226	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623398267	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623510479	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623510479	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7058	1715623510479	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623517493	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.7	1715623517493	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7081999999999997	1715623517493	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623549562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623549562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623549562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623555574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623555574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7072	1715623555574	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623556589	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623575637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623578636	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623579637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623581645	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623582645	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623584650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623585659	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623586657	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623588665	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623589660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623591650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623591650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623591671	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623592654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623592654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623592654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623118683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623122669	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623122669	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623122669	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623123671	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623123671	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6863	1715623123671	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623128682	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623128682	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.685	1715623128682	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623129684	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8999999999999995	1715623129684	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6853000000000002	1715623129684	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623134694	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623134694	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6859	1715623134694	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623135696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623135696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6813000000000002	1715623135696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623136699	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623136699	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6813000000000002	1715623136699	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623145716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623145716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6865	1715623145716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623146718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623146718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6865	1715623146718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623148722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623148722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623148722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623153732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623153732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623153732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623156740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623156740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6822	1715623156740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623161750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623161750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6841999999999997	1715623161750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623162752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623162752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6847	1715623162752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623167762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623167762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623167762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623350162	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623353176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623355171	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623362172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715623362172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986999999999997	1715623362172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623366180	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623366180	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6967	1715623366180	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623369186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715623369186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623369186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623373215	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623377202	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.6	1715623377202	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623377202	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623378204	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623378204	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623119663	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623119663	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6825	1715623119663	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623120687	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623124697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623125696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623126698	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623127695	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623130707	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623139704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623139704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6843000000000004	1715623139704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623149724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623149724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623149724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623154747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623160769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623166776	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623169787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623351150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623351150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623351150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623352166	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623356182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623363195	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623364191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623371210	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623376200	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623376200	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623376200	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623379206	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623379206	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6965	1715623379206	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623380232	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623385233	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623388225	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623388225	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7011	1715623388225	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623390229	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623390229	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.697	1715623390229	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623393249	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623397265	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623399262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623402280	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623403278	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623406284	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623515490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623518495	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.9	1715623518495	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7081999999999997	1715623518495	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623520500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623520500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7046	1715623520500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623525510	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623525510	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623525510	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623526534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623528537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623529539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7084	1715623558580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623559604	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623560606	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623561610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623566618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623120665	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623120665	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623120665	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623121667	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623121667	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623121667	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623121688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623124673	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623124673	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6863	1715623124673	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623125675	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623125675	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6863	1715623125675	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623126677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623126677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.685	1715623126677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623127680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623127680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.685	1715623127680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623130686	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623130686	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6853000000000002	1715623130686	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623131688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623131688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6853000000000002	1715623131688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623131708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623132690	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623132690	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6859	1715623132690	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623132705	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623133692	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623133692	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6859	1715623133692	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623133712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623137701	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623137701	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6813000000000002	1715623137701	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623137716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623139727	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623140706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623140706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6843000000000004	1715623140706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623140731	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623141708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623141708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6852	1715623141708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623141731	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623143712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623143712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6852	1715623143712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623143725	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623144714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623144714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6865	1715623144714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623144727	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623149738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623150726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623150726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623150726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623150747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623152730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623152730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623152730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623152746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623138703	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715623138703	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6843000000000004	1715623138703	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623142710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623142710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6852	1715623142710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623147720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623147720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623147720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623151728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623151728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623151728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623155737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623155737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623155737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623158744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623158744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6822	1715623158744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623159760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623163775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623164771	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623165779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623168783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623351171	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623356160	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623356160	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623356160	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623363174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623363174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623363174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623364176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623364176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623364176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623371190	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623371190	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623371190	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623375198	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623375198	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623375198	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623376214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623380209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623380209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6965	1715623380209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623385218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623385218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6997	1715623385218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623387222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623387222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7011	1715623387222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623388246	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623390244	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623397243	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623397243	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623397243	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623399247	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623399247	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7018	1715623399247	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623402254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623402254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7020999999999997	1715623402254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623403256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.799999999999999	1715623403256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7020999999999997	1715623403256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623406262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0804	1715623138724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623142724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623147734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623151753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623155756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623159746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623159746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6841999999999997	1715623159746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623163754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623163754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6847	1715623163754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623164756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623164756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6847	1715623164756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623165758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623165758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623165758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623168764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623168764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6864	1715623168764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623352152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623352152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623352152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623354170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623357185	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623358185	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623359180	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623365192	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623368205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623372214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623383214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623383214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6983	1715623383214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623386220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623386220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6997	1715623386220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623393235	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623393235	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623393235	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623394251	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623395253	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623401266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623404272	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623405276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623407285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623409282	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623526512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623526512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623562588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623562588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623562588	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623563590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623563590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623563590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623567599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623567599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7116	1715623567599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623570605	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623570605	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7103	1715623570605	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623573611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623573611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623573611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623583634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623154734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623154734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623154734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623157762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623354156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623354156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623354156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623357162	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623357162	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623357162	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623358164	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623358164	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623358164	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623359166	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623359166	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6953	1715623359166	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623365178	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623365178	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623365178	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623368184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623368184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6967	1715623368184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623372192	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623372192	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623372192	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623379220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623383235	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623386235	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623394237	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623394237	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623394237	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623395239	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623395239	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623395239	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623401252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623401252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7018	1715623401252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623404258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623404258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7020999999999997	1715623404258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623405260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.6	1715623405260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623405260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623407264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623407264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623407264	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623409268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623409268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623409268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623527514	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7073	1715623527514	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623569603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7116	1715623569603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623571607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623571607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7103	1715623571607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623580626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623580626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7125	1715623580626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623583634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7102	1715623583634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623587642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623587642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7108000000000003	1715623587642	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623157742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623157742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6822	1715623157742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623158765	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623360169	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623360169	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986999999999997	1715623360169	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623361192	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623367196	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623370205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623374196	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623374196	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623374196	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623381210	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623381210	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6983	1715623381210	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623384216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623384216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6997	1715623384216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623387243	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623389249	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623391246	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623392247	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623396263	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623408266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623408266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623408266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623530520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623530520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7069	1715623530520	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623531522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623531522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7062	1715623531522	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623532524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623532524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7062	1715623532524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623533526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623533526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7062	1715623533526	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623535552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623538559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623541564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623542567	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623544550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623544550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7096	1715623544550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623546554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623546554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7109	1715623546554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623547557	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623547557	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7109	1715623547557	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623548559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623548559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7109	1715623548559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623550564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623550564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623550564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623553570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623553570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.709	1715623553570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623556576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623556576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7072	1715623556576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623160748	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623160748	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6841999999999997	1715623160748	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623166760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623166760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6878	1715623166760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623169766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623169766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6864	1715623169766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623170768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623170768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6864	1715623170768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623170791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623171770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623171770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6868000000000003	1715623171770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623171791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623172772	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623172772	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6868000000000003	1715623172772	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623172794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623173774	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623173774	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6868000000000003	1715623173774	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623173794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623174776	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5	1715623174776	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6866	1715623174776	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623174790	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623175778	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.7	1715623175778	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6866	1715623175778	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623175801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623176780	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623176780	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6866	1715623176780	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623176803	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623177782	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623177782	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6835	1715623177782	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623177796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623178784	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.7	1715623178784	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6835	1715623178784	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623178797	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623179786	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.4	1715623179786	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6835	1715623179786	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623179800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623180788	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623180788	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623180788	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623180809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623181790	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623181790	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623181790	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623181803	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623182792	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.999999999999999	1715623182792	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6858	1715623182792	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623182806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623183794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623183794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623183794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623183815	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623184796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623184796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623184796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623185819	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623186822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623187801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623187801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623187801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623189806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623189806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623189806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623192877	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623193814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623193814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6871	1715623193814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	106	1715623194816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623194816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6871	1715623194816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623195840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623203855	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623204859	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623206862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623208845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623208845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6917	1715623208845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623209863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623212874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623218867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623218867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623218867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623220871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623220871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6894	1715623220871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623222875	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623222875	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6881	1715623222875	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623223877	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623223877	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6881	1715623223877	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623224879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623224879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6881	1715623224879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623225881	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.999999999999999	1715623225881	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6889000000000003	1715623225881	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623226883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623226883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6889000000000003	1715623226883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623228888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623228888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6904	1715623228888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623361170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623361170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6986999999999997	1715623361170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623367182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623367182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6967	1715623367182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623370188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623370188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6951	1715623370188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623373194	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623373194	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6976	1715623373194	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623184817	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623187817	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623189820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623193836	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623194830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623208860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623223892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623224895	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623225907	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623228908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623374218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623381231	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623384239	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623389227	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715623389227	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7011	1715623389227	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623391231	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623391231	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.697	1715623391231	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623392233	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623392233	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.697	1715623392233	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623396241	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623396241	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623396241	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623400250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623400250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7018	1715623400250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623408288	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623530541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623531543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623532546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623533543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623538537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623538537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623538537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623541543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623541543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7059	1715623541543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623542545	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623542545	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7059	1715623542545	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623543569	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623544564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623546576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623547576	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623548581	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623550587	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623553591	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623558601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623562610	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623563603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623567613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623569624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623570619	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623571620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623573632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623580640	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623583655	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623587664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623590648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623590648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623590648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623590669	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623591650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623185798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623185798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6872	1715623185798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623186800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623186800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623186800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623192812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623192812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6871	1715623192812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623195818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623195818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623195818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623203835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623203835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6887	1715623203835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623204837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623204837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6912	1715623204837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623206841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623206841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6912	1715623206841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623209848	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623209848	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6917	1715623209848	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623212854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623212854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6903	1715623212854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623217882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623218888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623220892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623222894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623226897	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6965	1715623378204	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623382212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623382212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6983	1715623382212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623398245	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623398245	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6995	1715623398245	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623400272	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623534528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623534528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7088	1715623534528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623537535	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10	1715623537535	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7066	1715623537535	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623540541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.2	1715623540541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7059	1715623540541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623545551	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.899999999999999	1715623545551	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7096	1715623545551	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623551566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623551566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623551566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623552568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10	1715623552568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.709	1715623552568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623554586	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623564613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623565608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623568614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623572629	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623574630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623188804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623188804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.689	1715623188804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623190808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623190808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623190808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623196820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623196820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623196820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623199826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623199826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6860999999999997	1715623199826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623201830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.399999999999999	1715623201830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6887	1715623201830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623202847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623211865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623213869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623214874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623216876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623219869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623219869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6894	1715623219869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623221873	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623221873	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6894	1715623221873	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623227885	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623227885	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6889000000000003	1715623227885	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.199999999999999	1715623406262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623406262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623534542	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623537551	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623540562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623545572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623551580	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623554572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623554572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.709	1715623554572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623564592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623564592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7099	1715623564592	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623565594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623565594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7099	1715623565594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623568601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623568601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7116	1715623568601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623572609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715623572609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7103	1715623572609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623574613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623574613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623574613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623576618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.799999999999999	1715623576618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7119	1715623576618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623576632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623577620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623577620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7119	1715623577620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623577634	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623578622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623578622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623188820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623190829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623196840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623199847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623202832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623202832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6887	1715623202832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623211852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623211852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6903	1715623211852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623213856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623213856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6884	1715623213856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623214858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623214858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6884	1715623214858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623216863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623216863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623216863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623217865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623217865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6909	1715623217865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623219882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623221894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623227906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623410270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623410270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623410270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623415282	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623415282	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623415282	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623416284	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623416284	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623416284	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623418288	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623418288	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7014	1715623418288	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623422296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623422296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7023	1715623422296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623423298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623423298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7022	1715623423298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623428309	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623428309	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623428309	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623429333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623431337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623449374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623451379	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623455386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623458394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623462402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623467411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623476432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	107	1715623484425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623484425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623484425	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623485427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623485427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7048	1715623485427	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623489436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623489436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7054	1715623489436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623191810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623191810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.688	1715623191810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623197822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623197822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6888	1715623197822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623198824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623198824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6860999999999997	1715623198824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623200828	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8	1715623200828	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6860999999999997	1715623200828	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623201843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623205862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623207865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623210871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623215874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623229915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623410286	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623415295	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623416298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623418309	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623422316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623423322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623428330	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623431315	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623431315	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623431315	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623449353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623449353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7051	1715623449353	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623451357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623451357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7053000000000003	1715623451357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623455365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623455365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7036	1715623455365	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623458371	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623458371	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6998	1715623458371	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623462380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623462380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7034000000000002	1715623462380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623467390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623467390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7035	1715623467390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623476410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623476410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7064	1715623476410	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623479415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623479415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.703	1715623479415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623484439	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623485448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623489455	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623490452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623492463	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623493465	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623494467	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623495465	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623505491	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623508490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623516515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623526512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623191835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623197835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623198837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623200849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623205839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715623205839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6912	1715623205839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623207843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.1	1715623207843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6917	1715623207843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623210850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623210850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6903	1715623210850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623215861	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623215861	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6884	1715623215861	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623229891	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715623229891	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6904	1715623229891	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623411272	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.8999999999999995	1715623411272	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.704	1715623411272	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623412274	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623412274	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.704	1715623412274	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623413298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623414302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623420292	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715623420292	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7023	1715623420292	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623421317	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623424324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623427307	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715623427307	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7038	1715623427307	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623433320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623433320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.6982	1715623433320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623435337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623436349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623437352	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623441357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623454378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623456388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623460390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623461393	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623463403	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623466409	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623469408	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623471420	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623475434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623480440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623482502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623487458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623491464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623497475	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623500458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7	1715623500458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7060999999999997	1715623500458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623503479	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623514487	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715623514487	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7065	1715623514487	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623515490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.6000000000000005	1715623515490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623592674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623605683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623605683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7104	1715623605683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623606685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623606685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7124	1715623606685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623611719	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623619736	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623621738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623627753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623634757	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623639767	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623642775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623648787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623650777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623650777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7159	1715623650777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623651779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623651779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171999999999996	1715623651779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623655787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623655787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623655787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623658793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623658793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7166	1715623658793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623661801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623661801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7167	1715623661801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623671820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.8	1715623671820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623671820	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623676831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623676831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.717	1715623676831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623685849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623685849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623685849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623688856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623688856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623688856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623691862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.899999999999999	1715623691862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7174	1715623691862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623692864	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623692864	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7174	1715623692864	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623693866	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623693866	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623693866	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623694868	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623694868	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623694868	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623696872	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623696872	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7183	1715623696872	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623699878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623699878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7188000000000003	1715623699878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623701882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623701882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7188000000000003	1715623701882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623702884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623593656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623593656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623593656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623594658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623594658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623594658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623600670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623600670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623600670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623602692	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623603693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623608711	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623615706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623615706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7133000000000003	1715623615706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623616708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623616708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7133000000000003	1715623616708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623617710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715623617710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7133000000000003	1715623617710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623618712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623618712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623618712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623620716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623620716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623620716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623630736	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623630736	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623630736	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623631738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623631738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623631738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623632740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623632740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623632740	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623635746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623635746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7129000000000003	1715623635746	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623636749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623636749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623636749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623638752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623638752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623638752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623644764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623644764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623644764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623650793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623651792	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623655809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623658814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623661823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623671841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623676852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623685875	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623696885	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623701896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623702884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171	1715623702884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623705890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623705890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7178	1715623705890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623706892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623593677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623594680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623600684	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623603679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623603679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7104	1715623603679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623608691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623608691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7124	1715623608691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623611697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623611697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7114000000000003	1715623611697	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623615727	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623616721	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623617732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623618733	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623620737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623630756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623631753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623632761	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623635764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623636766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623638766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623644780	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623652781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715623652781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171999999999996	1715623652781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623653804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623654798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623667834	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623668841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623669832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623673845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623677855	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623683867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623687875	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623690860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623690860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7174	1715623690860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623695870	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623695870	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623695870	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623703886	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715623703886	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171	1715623703886	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623704888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623704888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171	1715623704888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623705913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623708896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623708896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623708896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623709920	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623710926	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623713906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623713906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7156	1715623713906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623714910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623714910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623714910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623714924	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623715933	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623716914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623716914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623716914	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623595660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.399999999999999	1715623595660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623595660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623596662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623596662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623596662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623597664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623597664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.712	1715623597664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623598666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623598666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.712	1715623598666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623599668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.1	1715623599668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.712	1715623599668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623612722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623613725	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623614718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623622742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623626750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623629747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623643780	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623645783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623647784	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623649789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623652805	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623654785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623654785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623654785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623667812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623667812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623667812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623668814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623668814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623668814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623669816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623669816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623669816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623673824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623673824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7158	1715623673824	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623677833	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623677833	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.717	1715623677833	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623683845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623683845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7165	1715623683845	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623687854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623687854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623687854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623689858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623689858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623689858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623690883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623695884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623703899	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623706892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7178	1715623706892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623709898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623709898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623709898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623710900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623710900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623710900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623595681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623596683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623597677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623598690	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623612700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623612700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7149	1715623612700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623613702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623613702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7149	1715623613702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623614704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623614704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7149	1715623614704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623622720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623622720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7143	1715623622720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623623722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623623722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7143	1715623623722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623629734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715623629734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623629734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623643762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623643762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623643762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623645766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623645766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623645766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623647770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623647770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623647770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623649775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623649775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7159	1715623649775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623653783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.099999999999998	1715623653783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7171999999999996	1715623653783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623657813	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623659810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623663826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623665831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623666831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623674841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623675853	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623678858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623679860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623681862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623688871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623691883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623692885	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623693882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623694883	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623699892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623702898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623706913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623708918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623711924	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623712926	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623713928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623716937	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623717938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623719921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623719921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623719921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623720923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623599690	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623605696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623606707	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623619714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623619714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623619714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623621718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623621718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7143	1715623621718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623627730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623627730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623627730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623634744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623634744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7129000000000003	1715623634744	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623639754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623639754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7144	1715623639754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623642760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623642760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7093000000000003	1715623642760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623648773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623648773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7159	1715623648773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623656789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9	1715623656789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623656789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623660797	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623660797	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7167	1715623660797	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623662803	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623662803	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7167	1715623662803	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623664807	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623664807	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623664807	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623670818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623670818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623670818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623672822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623672822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7158	1715623672822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623680839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623680839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623680839	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623682843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623682843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7165	1715623682843	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623684847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623684847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623684847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623686852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623686852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623686852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623689873	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623697891	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623698892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623700902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623707894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623707894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7178	1715623707894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623711902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623711902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7156	1715623711902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623601674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623601674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623601674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623602676	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623602676	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7136	1715623602676	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623604695	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623607710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623609707	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623610717	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623624724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623624724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623624724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623625726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.7	1715623625726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623625726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623626728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623626728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7145	1715623626728	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623628754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623633764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623637764	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623640769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623641774	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623646783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623656810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623660823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623662817	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623664829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623670840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623672844	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623680860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623682864	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623684861	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623686872	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623697874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623697874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7183	1715623697874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623698876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623698876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7183	1715623698876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623700880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623700880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7188000000000003	1715623700880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623704902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623707911	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623712904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623712904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7156	1715623712904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623715912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.899999999999999	1715623715912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7179	1715623715912	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623717916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623717916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623717916	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623718918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623718918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623718918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623718940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623719936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3.2	1715623720923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7185	1715623720923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623720944	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623721925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623722927	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623601698	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623604681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10	1715623604681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7104	1715623604681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623607688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623607688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7124	1715623607688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623609693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623609693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7114000000000003	1715623609693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623610695	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623610695	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7114000000000003	1715623610695	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623623743	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623624739	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623625749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623628732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.7	1715623628732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7127	1715623628732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623633742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623633742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7129000000000003	1715623633742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623637750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.3	1715623637750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7139	1715623637750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623640756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623640756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7144	1715623640756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623641758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623641758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7144	1715623641758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623646768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623646768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.714	1715623646768	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623657791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623657791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7166	1715623657791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623659795	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715623659795	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7166	1715623659795	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623663804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.1000000000000005	1715623663804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623663804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623665809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.7	1715623665809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7169	1715623665809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623666810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623666810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7146	1715623666810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623674826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623674826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7158	1715623674826	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623675829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623675829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.717	1715623675829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623678835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.4	1715623678835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623678835	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623679837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623679837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.716	1715623679837	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623681841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6	1715623681841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7165	1715623681841	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623721925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7185	1715623721925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623722950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623726960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623728965	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623730967	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623731972	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623736980	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623737974	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623747984	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623747984	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7215	1715623747984	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623753997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623753997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7209	1715623753997	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623754999	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623754999	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7209	1715623754999	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623763016	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623763016	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623763016	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623764018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623764018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623764018	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624130793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624130793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7385	1715624130793	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624144823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624144823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624144823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624164865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624164865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624164865	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624167894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624172896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624173905	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624176905	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624180913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624187937	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624189931	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623721940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623724953	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623729958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623733973	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623740989	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623743996	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623746982	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623746982	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623746982	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623749988	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623749988	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7215	1715623749988	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623765020	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623765020	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623765020	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623768026	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623768026	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7239	1715623768026	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624130816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624144842	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624164879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	6	1715624172882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624172882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.739	1715624172882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	4	1715624173884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624173884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624173884	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624176892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715624176892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7407	1715624176892	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	1	1715624180900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.9	1715624180900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7386	1715624180900	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624187915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.7	1715624187915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624187915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624189919	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.7	1715624189919	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624189919	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623722927	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7185	1715623722927	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623726938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623726938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7195	1715623726938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623728943	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.1	1715623728943	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7195	1715623728943	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623730946	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623730946	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623730946	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623731948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623731948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623731948	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623736958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623736958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7211	1715623736958	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623737960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623737960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7211	1715623737960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623744996	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623747998	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623754019	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623755013	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623763031	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623764032	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624131796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624131796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7383	1715624131796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624135804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624135804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624135804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624136806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624136806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624136806	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624138823	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624143844	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624148853	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624151859	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624152864	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624153863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624154858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624157871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624158874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624163879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624165882	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624168895	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624169891	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624170899	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624171896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624175910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624177915	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624179911	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624182925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624188937	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623723930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623723930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7201	1715623723930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623725935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623725935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7201	1715623725935	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623739965	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623739965	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623739965	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623741971	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623741971	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623741971	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623745980	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623745980	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623745980	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623751993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623751993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623751993	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623752995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.799999999999999	1715623752995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623752995	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623757003	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623757003	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.723	1715623757003	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623758005	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.799999999999999	1715623758005	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.723	1715623758005	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623759007	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623759007	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.723	1715623759007	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623761012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623761012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.723	1715623761012	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623767024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623767024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623767024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623769028	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623769028	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7239	1715623769028	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624131810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624135828	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624138810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624138810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624138810	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624143821	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624143821	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624143821	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624148832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624148832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7392	1715624148832	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624151838	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624151838	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624151838	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624152840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624152840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624152840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624153842	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624153842	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624153842	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624154844	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624154844	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624154844	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624157850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.1	1715624157850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623723957	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623725956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623739986	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623741994	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623746004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623752008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623753008	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623757016	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623758019	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623759020	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623761025	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623767038	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623769050	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624132798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624132798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7383	1715624132798	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624133800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624133800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7383	1715624133800	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624134802	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624134802	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624134802	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624137808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624137808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624137808	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624141816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624141816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7365999999999997	1715624141816	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624146829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624146829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7392	1715624146829	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715624147830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624147830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7392	1715624147830	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624149834	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624149834	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624149834	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624156849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624156849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7398000000000002	1715624156849	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624159854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624159854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624159854	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624160856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624160856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624160856	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624161872	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624184927	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624185931	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624186933	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623724932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623724932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7201	1715623724932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623729944	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623729944	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7168	1715623729944	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623733952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623733952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7196	1715623733952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623740968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623740968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623740968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623743975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623743975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623743975	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623744978	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623744978	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623744978	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623747003	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623750004	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623765032	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623768039	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624132814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624133815	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624134817	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624137822	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624141840	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624146842	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624147851	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624149852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624156863	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624159867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624160879	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624166869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624166869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624166869	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624185910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715624185910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624185910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624186913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715624186913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624186913	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623727941	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623727941	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7195	1715623727941	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623732950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623732950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7196	1715623732950	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623734954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623734954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7196	1715623734954	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623735956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623735956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7211	1715623735956	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623738962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623738962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623738962	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623742973	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623742973	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7219	1715623742973	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623748986	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623748986	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7215	1715623748986	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623750990	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623750990	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623750990	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623756001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623756001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7209	1715623756001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623760010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623760010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.723	1715623760010	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623762014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623762014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623762014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623766022	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623766022	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7238	1715623766022	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623770030	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623770030	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7239	1715623770030	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624136827	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624139827	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624140831	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624142833	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624145847	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624150858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624155868	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624162860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624162860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624162860	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624166894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624174888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.7	1715624174888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624174888	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624178896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715624178896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7407	1715624178896	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624181902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4	1715624181902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7386	1715624181902	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624183906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715624183906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624183906	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624184908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715624184908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623727960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623732971	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623734968	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623735978	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623738977	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623742994	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623749001	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623751014	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623756024	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623760025	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623762028	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623766043	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623770052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623771032	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623771032	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7233	1715623771032	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623771052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623772034	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.399999999999999	1715623772034	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7233	1715623772034	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623772047	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623773036	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623773036	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7233	1715623773036	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623773058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623774038	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623774038	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623774038	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623774061	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623775040	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623775040	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623775040	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623775055	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623776043	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623776043	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7214	1715623776043	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623776059	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623777045	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623777045	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623777045	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623777060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623778047	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623778047	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623778047	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623778062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623779049	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623779049	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7232	1715623779049	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623779067	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623780052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623780052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623780052	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623780064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623781054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623781054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623781054	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623781076	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623782056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623782056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623782056	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623782071	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623783058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3.2	1715623783058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7245	1715623783058	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623783073	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623784060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623784060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7245	1715623784060	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623787067	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623787067	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623787067	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623791088	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623794108	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623800094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623800094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623800094	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623803100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623803100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7259	1715623803100	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623806106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623806106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623806106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623807131	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623812141	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623813144	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623815145	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623818134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715623818134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623818134	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623825150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623825150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623825150	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623835187	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623846218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623856239	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623857234	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623858243	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623862251	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623864255	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623871271	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623874268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623883275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623883275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623883275	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623886281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623886281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623886281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623888285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623888285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623888285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623889287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623889287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623889287	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624139812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624139812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7377	1715624139812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624140814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624140814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7365999999999997	1715624140814	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624142818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624142818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7365999999999997	1715624142818	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624145825	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624145825	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624145825	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624150836	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624150836	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7371999999999996	1715624150836	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624155846	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623784074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623791074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3.2	1715623791074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7260999999999997	1715623791074	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623794082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.5	1715623794082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7251999999999996	1715623794082	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623795084	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623795084	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.722	1715623795084	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623800110	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623803122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623806122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623812120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623812120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7266999999999997	1715623812120	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623813122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623813122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.726	1715623813122	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623815128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623815128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.726	1715623815128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623817132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623817132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623817132	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623818149	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623825163	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623846197	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.5	1715623846197	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623846197	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623856218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11	1715623856218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623856218	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623857220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623857220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623857220	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623858222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623858222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623858222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623862230	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623862230	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7263	1715623862230	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623864234	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623864234	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623864234	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623871248	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715623871248	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7293000000000003	1715623871248	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623874254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623874254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623874254	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623882273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623882273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623882273	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623883296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623886302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623888308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624155846	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7398000000000002	1715624155846	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624161858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.4	1715624161858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624161858	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624162876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624167871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623785062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623785062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7245	1715623785062	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623786064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.799999999999999	1715623786064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623786064	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623789092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623796108	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623802112	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623809137	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623820139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623820139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623820139	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623827154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623827154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623827154	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623830161	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11	1715623830161	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7268000000000003	1715623830161	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623836174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623836174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7273	1715623836174	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623839181	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.299999999999999	1715623839181	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7213000000000003	1715623839181	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623849203	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623849203	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7297	1715623849203	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623851207	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623851207	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7297	1715623851207	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623852209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623852209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623852209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623854227	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623859237	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623860248	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623861249	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623863253	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623867263	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623868255	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623880268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623880268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7316	1715623880268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623881270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.899999999999999	1715623881270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7316	1715623881270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623882294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623885293	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7398000000000002	1715624157850	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624158852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624158852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624158852	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624163862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624163862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624163862	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624165867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624165867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624165867	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624168874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.4	1715624168874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624168874	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624169876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624169876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623785084	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623786086	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623792097	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623802098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	13.099999999999998	1715623802098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7259	1715623802098	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623809114	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623809114	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623809114	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623817148	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623820155	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623827177	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623830182	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623836187	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623839196	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623849217	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623851222	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623852224	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623859224	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623859224	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623859224	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623860226	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623860226	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623860226	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623861228	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623861228	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7263	1715623861228	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623863232	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623863232	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7263	1715623863232	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623867240	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623867240	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623867240	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623868242	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623868242	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623868242	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623869244	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623869244	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623869244	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623880283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623881285	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623885279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623885279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623885279	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624167871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624167871	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624174903	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624178910	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624181918	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624183927	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623787088	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623788089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623793080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623793080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7251999999999996	1715623793080	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623795097	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623797089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.099999999999998	1715623797089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.722	1715623797089	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623798090	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623798090	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623798090	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623807109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623807109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623807109	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623811119	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.2	1715623811119	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7266999999999997	1715623811119	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623814124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623814124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.726	1715623814124	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623826152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623826152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623826152	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623829158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623829158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7268000000000003	1715623829158	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623832165	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623832165	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623832165	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623833167	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623833167	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623833167	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623834170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623834170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7273	1715623834170	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623835172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623835172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7273	1715623835172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623841209	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623842203	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623844212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623845216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623847224	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623848223	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623850228	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623853234	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623870259	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623872270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623875270	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623878277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623884297	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623887297	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624169876	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624170878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715624170878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.739	1715624170878	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624171880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624171880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.739	1715624171880	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624175890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715624175890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624175890	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624177894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623788068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623788068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7236	1715623788068	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623789070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623789070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7260999999999997	1715623789070	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623793104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623796087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623796087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.722	1715623796087	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623797103	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623798110	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623808112	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8	1715623808112	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623808112	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623811141	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623814148	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623826173	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623829181	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623832179	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623833188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623834191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623841186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623841186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623841186	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623842188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623842188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623842188	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623844193	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623844193	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623844193	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623845195	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623845195	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623845195	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623847199	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623847199	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623847199	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623848201	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623848201	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623848201	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623850205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623850205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7297	1715623850205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623853212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623853212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623853212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623870246	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623870246	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7293000000000003	1715623870246	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623872250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623872250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7293000000000003	1715623872250	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623875256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623875256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623875256	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623878262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623878262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623878262	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623884277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623884277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623884277	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623887283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623887283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7269	1715623887283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623790072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.5	1715623790072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7260999999999997	1715623790072	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623792077	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623792077	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7251999999999996	1715623792077	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623799106	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623801112	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623804123	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623805119	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623810117	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.299999999999999	1715623810117	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7266999999999997	1715623810117	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623816130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623816130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7241	1715623816130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623819137	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623819137	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623819137	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623821141	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623821141	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7257	1715623821141	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623822143	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623822143	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623822143	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623823146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623823146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623823146	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623824148	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623824148	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623824148	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623828156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623828156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7268000000000003	1715623828156	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623831163	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623831163	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623831163	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623837176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.2	1715623837176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7213000000000003	1715623837176	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623838179	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623838179	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7213000000000003	1715623838179	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623840184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623840184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623840184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623843191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623843191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7285	1715623843191	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623854214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623854214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623854214	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623855237	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623865253	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623866252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623873252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623873252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623873252	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623876258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623876258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623876258	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623877260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623877260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623877260	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623790091	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623799092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.2	1715623799092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7255	1715623799092	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623801096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.2	1715623801096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7259	1715623801096	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623804102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.9	1715623804102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623804102	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623805104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.1	1715623805104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7265	1715623805104	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623808128	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623810130	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623816143	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623819153	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623821155	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623822159	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623823160	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623824162	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623828172	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623831184	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623837189	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623838200	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623840205	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623843212	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623855216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623855216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623855216	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623865236	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623865236	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623865236	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623866238	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623866238	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7262	1715623866238	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623869268	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623873276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623876281	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623877276	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623879283	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.3	1715624177894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7407	1715624177894	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624179898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4	1715624179898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7386	1715624179898	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	1	1715624182904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715624182904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624182904	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624188917	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715624188917	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624188917	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623879266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623879266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7316	1715623879266	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624184908	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623889302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623890289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715623890289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623890289	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623890303	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623891291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623891291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623891291	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623891314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623892294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.899999999999999	1715623892294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623892294	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623892308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623893296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623893296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.73	1715623893296	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623893317	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623894298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623894298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623894298	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623894312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623895300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623895300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623895300	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623895313	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623896302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623896302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623896302	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623896323	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623897304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623897304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623897304	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623897325	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623898306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623898306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623898306	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623898328	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623899308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623899308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623899308	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623899323	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623900310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.5	1715623900310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7300999999999997	1715623900310	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623900331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623901312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623901312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7300999999999997	1715623901312	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623901333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623902314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623902314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7300999999999997	1715623902314	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623902335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623903316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623903316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7283000000000004	1715623903316	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623903337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623904318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623904318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7283000000000004	1715623904318	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623904332	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623905320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623905320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7283000000000004	1715623905320	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623905341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623907345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623911356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623913359	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623918368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623921374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623922370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623927379	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623928381	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623933401	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623934395	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623935405	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623940407	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623943415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623945419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623949430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623950428	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623951432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623965473	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623971481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623976489	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623977491	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623988492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.6	1715623988492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623988492	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623990516	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623993524	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623996533	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623999529	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624004540	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624007547	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624009555	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624190921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4	1715624190921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624190921	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	1	1715624191923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	3	1715624191923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624191923	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	1	1715624193926	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.3	1715624193926	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624193926	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623906322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623906322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623906322	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623908327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623908327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623908327	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623909329	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623909329	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623909329	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623910331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623910331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623910331	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623912335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623912335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623912335	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623914339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715623914339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623914339	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623916343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623916343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715623916343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623920351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623920351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715623920351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623932378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623932378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623932378	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623937388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623937388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715623937388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623952419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623952419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623952419	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623954423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623954423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7287	1715623954423	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623955442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623956448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623957442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623958453	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623959447	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623960456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623961451	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623962460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623966469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623972481	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623973482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623975486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623982502	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623984484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623984484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715623984484	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623985486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623985486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715623985486	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623994505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623994505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623994505	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624000531	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624002539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624190942	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624191943	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624193947	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623906343	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623908351	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623909352	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623910347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623912357	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623914360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623916363	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623929370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623929370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623929370	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623932393	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623937402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623952434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623954436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623956428	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623956428	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7287	1715623956428	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623957430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11	1715623957430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7284	1715623957430	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623958432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623958432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7284	1715623958432	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623959434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623959434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7284	1715623959434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623960436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623960436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623960436	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623961438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623961438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623961438	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623962440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623962440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715623962440	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623966448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623966448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623966448	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623972460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623972460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623972460	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623973462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623973462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623973462	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623975466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623975466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715623975466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623982480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623982480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7351	1715623982480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623983482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623983482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7351	1715623983482	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623984498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623986512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624000517	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.299999999999999	1715624000517	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715624000517	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624002521	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624002521	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7331	1715624002521	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624008555	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624192925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.3	1715624192925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623907324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623907324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7308000000000003	1715623907324	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623911333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623911333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623911333	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623913337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.2	1715623913337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7318000000000002	1715623913337	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623918347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623918347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715623918347	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623921354	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623921354	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623921354	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623922356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.5	1715623922356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623922356	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623927366	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623927366	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623927366	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623928368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623928368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7302	1715623928368	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623933380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623933380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7313	1715623933380	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623934382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623934382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7313	1715623934382	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623935384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623935384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7313	1715623935384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623940394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623940394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623940394	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623943400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623943400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623943400	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623945404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623945404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623945404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	105	1715623949413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623949413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623949413	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623950415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715623950415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623950415	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623951417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623951417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623951417	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623965446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623965446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623965446	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623971458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623971458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715623971458	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623976468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623976468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715623976468	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623977470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623977470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715623977470	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623985503	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623915341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623915341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715623915341	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623917345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623917345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715623917345	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623919349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623919349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715623919349	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623920367	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623924374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623925377	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623926386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623930388	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623931397	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623938404	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623939407	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623942412	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623946422	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623953434	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623963463	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623964466	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623967472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623970456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.299999999999999	1715623970456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715623970456	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623978472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623978472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715623978472	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623981478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623981478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7351	1715623981478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623983504	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623987490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623987490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623987490	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623992500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623992500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715623992500	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623995507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715623995507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623995507	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623998528	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624001534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624005541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7379000000000002	1715624192925	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624194928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715624194928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624194928	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624196932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.6	1715624196932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624196932	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623915361	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623917369	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623919367	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715623924360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623924360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715623924360	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623925362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623925362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715623925362	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623926364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715623926364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715623926364	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623930374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623930374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623930374	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623931376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.899999999999999	1715623931376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623931376	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623938390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.8999999999999995	1715623938390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715623938390	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623939392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623939392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623939392	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623942398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.299999999999999	1715623942398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623942398	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623946406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.199999999999999	1715623946406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623946406	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623953421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623953421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7304	1715623953421	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623963442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623963442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623963442	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623964444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623964444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623964444	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715623967450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623967450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623967450	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623969469	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623970478	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623978494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623981499	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623986489	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623986489	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715623986489	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623987503	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623992521	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623995523	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624001519	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624001519	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715624001519	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624005527	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624005527	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624005527	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624008534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624008534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715624008534	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624192938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624194946	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624196946	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623923358	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623923358	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623923358	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623929384	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623936407	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623941411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623944420	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623947422	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623948426	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623968452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623968452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715623968452	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623969454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715623969454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715623969454	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623974480	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623979495	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623980498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623989494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715623989494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715623989494	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623991498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623991498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715623991498	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623994525	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623997525	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624003523	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715624003523	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7331	1715624003523	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624006529	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624006529	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624006529	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624195930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.3	1715624195930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624195930	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624197934	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	4.7	1715624197934	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624197934	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624198957	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623923372	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623936386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623936386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715623936386	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623941396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623941396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623941396	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623944402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3	1715623944402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715623944402	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623947409	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715623947409	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7275	1715623947409	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623948411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.6	1715623948411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623948411	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715623955426	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623955426	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7287	1715623955426	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623968477	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623974464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623974464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715623974464	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623979474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623979474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715623979474	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623980476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715623980476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715623980476	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623988506	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623989511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715623991512	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715623997511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715623997511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623997511	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623998513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623998513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623998513	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624003538	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624006543	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624195945	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	1	1715624198936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	2.9	1715624198936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624198936	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	3	1715624199938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.7	1715624199938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7388000000000003	1715624199938	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623990496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715623990496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715623990496	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623993503	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623993503	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306	1715623993503	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715623996509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715623996509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715623996509	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715623999515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715623999515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715623999515	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624004525	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624004525	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7331	1715624004525	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624007532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624007532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624007532	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624009536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.4	1715624009536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715624009536	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624010537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624010537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7315	1715624010537	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624010561	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624011539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624011539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624011539	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624011560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624012541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624012541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624012541	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624012561	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624013544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624013544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.736	1715624013544	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624013559	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624014546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624014546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624014546	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624014567	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624015548	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.6	1715624015548	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624015548	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624015561	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624016550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715624016550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624016550	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624016572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624017552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624017552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7364	1715624017552	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624017573	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624018554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624018554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7364	1715624018554	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624018569	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624019556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624019556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7364	1715624019556	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624019582	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624020558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624020558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7346	1715624020558	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624020572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624021575	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624024590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624025590	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624026594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624037614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624050638	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624052653	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624053654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624055650	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624063669	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624071693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624073689	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624077704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624079708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624092714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624092714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306999999999997	1715624092714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624099729	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624099729	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715624099729	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624118769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624118769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624118769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624120773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624120773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7384	1715624120773	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624121775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624121775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7384	1715624121775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624124781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.2	1715624124781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624124781	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624127801	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624197961	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	2	1715624200940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.9	1715624200940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7409	1715624200940	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624021560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715624021560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7346	1715624021560	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624024566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624024566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7357	1715624024566	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624025568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624025568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7357	1715624025568	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624026570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624026570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624026570	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624037593	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624037593	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624037593	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624050624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624050624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715624050624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624052630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624052630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715624052630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624053632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715624053632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624053632	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624055637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624055637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624055637	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624063654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715624063654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715624063654	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624071670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624071670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7281999999999997	1715624071670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624073674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624073674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7281999999999997	1715624073674	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624077683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624077683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624077683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624079687	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624079687	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624079687	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624091712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624091712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624091712	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624092738	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624099742	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624118790	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624120794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624121796	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624127787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624127787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624127787	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624199952	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624200960	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624022562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624022562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7346	1715624022562	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624023564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624023564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7357	1715624023564	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624029577	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.4	1715624029577	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715624029577	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624031581	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624031581	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715624031581	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624032583	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624032583	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7323000000000004	1715624032583	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624038595	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624038595	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715624038595	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624039623	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624043622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624047639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624058658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624062666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624064670	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624065678	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624067678	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624069680	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624081714	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624085713	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624087724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624094733	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624103757	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624106763	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624107766	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624108769	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624109762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624110772	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624111775	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624116778	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624117788	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624119783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624125804	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624022579	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624023577	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624029599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624031603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624032603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624038609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624043609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715624043609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624043609	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624047618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	13.399999999999999	1715624047618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624047618	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624058643	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715624058643	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624058643	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624062652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624062652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715624062652	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624064656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624064656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7327	1715624064656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624065658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624065658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624065658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624067662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624067662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624067662	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624069666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624069666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715624069666	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624081691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624081691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7342	1715624081691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624085700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624085700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7328	1715624085700	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624087704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624087704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624087704	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624094718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624094718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306999999999997	1715624094718	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624103737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.1	1715624103737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624103737	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624106743	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715624106743	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624106743	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624107745	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624107745	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624107745	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624108747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624108747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624108747	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715624109749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624109749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624109749	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624110751	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624110751	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715624110751	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624111753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624111753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715624111753	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624116765	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624027572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624027572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624027572	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624028575	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624028575	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624028575	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624030579	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624030579	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7303	1715624030579	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624036613	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624042626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624044635	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624046616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624046616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715624046616	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715624048620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624048620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624048620	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624049622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	11.1	1715624049622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624049622	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624054635	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624054635	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624054635	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624057641	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.3	1715624057641	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624057641	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624059645	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624059645	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715624059645	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	104	1715624060647	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624060647	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715624060647	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624066660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624066660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325	1715624066660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624074677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624074677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715624074677	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624075679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.4	1715624075679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715624075679	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624078685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624078685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624078685	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624082693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624082693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7342	1715624082693	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624083696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624083696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7328	1715624083696	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624084698	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624084698	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7328	1715624084698	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624086702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624086702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624086702	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624088706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624088706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7358000000000002	1715624088706	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624089708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624089708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624089708	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624090710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624027585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.08009999999999999	1715624028589	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624036591	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715624036591	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624036591	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624042607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.699999999999999	1715624042607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624042607	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624044611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624044611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715624044611	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624045614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715624045614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7319	1715624045614	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624046639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624048643	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624049644	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624054658	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624057656	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624059659	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624060660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624066675	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624074691	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624075692	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624078699	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624082715	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624083710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624084715	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624086715	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624088719	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624089721	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624090726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624096722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624096722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715624096722	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624098726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624098726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715624098726	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624101732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624101732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624101732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624102734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624102734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7345	1715624102734	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624104739	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624104739	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624104739	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624113758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624113758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624113758	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624114760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624114760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624114760	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624122777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624122777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624122777	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624128789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624128789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7385	1715624128789	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624030594	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624033608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624034608	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624035603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624040601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624040601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715624040601	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624041603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624041603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7311	1715624041603	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624045630	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624051648	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624056660	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624061664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624068678	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624070683	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624072688	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624076705	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624080707	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	99	1715624093716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.7	1715624093716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7306999999999997	1715624093716	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624095735	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624097745	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624100752	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624105762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624112770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624115784	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624123794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624126785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.399999999999999	1715624126785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624126785	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624129791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624129791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7385	1715624129791	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624033585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624033585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7323000000000004	1715624033585	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624034587	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624034587	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7323000000000004	1715624034587	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624035589	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.3999999999999995	1715624035589	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7325999999999997	1715624035589	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624039599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8	1715624039599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7317	1715624039599	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624040625	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624041624	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624051626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624051626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7312	1715624051626	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624056639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.1	1715624056639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.732	1715624056639	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624061649	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.3	1715624061649	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7305	1715624061649	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624068664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624068664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715624068664	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624070668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624070668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7335	1715624070668	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624072672	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715624072672	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7281999999999997	1715624072672	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624076681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.8	1715624076681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7299	1715624076681	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624080689	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	9.4	1715624080689	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7342	1715624080689	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624091733	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624093732	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624097724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	10.5	1715624097724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715624097724	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624100730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624100730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.734	1715624100730	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624105741	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624105741	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7353	1715624105741	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624112756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624112756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7321	1715624112756	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624115762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	8.2	1715624115762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7340999999999998	1715624115762	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	100	1715624123779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.4	1715624123779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7378	1715624123779	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624124794	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624126809	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624129812	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624090710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7338	1715624090710	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	101	1715624095720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624095720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.733	1715624095720	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624096743	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624098745	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624101754	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624102750	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624104751	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624113772	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624114782	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624122797	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Swap Memory GB	0.0867	1715624128811	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624116765	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624116765	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624117767	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	7.5	1715624117767	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7349	1715624117767	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	102	1715624119770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	6.5	1715624119770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7384	1715624119770	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - CPU Utilization	103	1715624125783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Utilization	5.8	1715624125783	7d29749dc9194bd48eefcfaa5213f208	0	f
TOP - Memory Usage GB	2.7359	1715624125783	7d29749dc9194bd48eefcfaa5213f208	0	f
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
letter	0	22422f267d2949e5a4f7e5752d1fcf19
workload	0	22422f267d2949e5a4f7e5752d1fcf19
listeners	smi+top+dcgmi	22422f267d2949e5a4f7e5752d1fcf19
params	'"-"'	22422f267d2949e5a4f7e5752d1fcf19
file	cifar10.py	22422f267d2949e5a4f7e5752d1fcf19
workload_listener	''	22422f267d2949e5a4f7e5752d1fcf19
letter	0	7d29749dc9194bd48eefcfaa5213f208
workload	0	7d29749dc9194bd48eefcfaa5213f208
listeners	smi+top+dcgmi	7d29749dc9194bd48eefcfaa5213f208
params	'"-"'	7d29749dc9194bd48eefcfaa5213f208
file	cifar10.py	7d29749dc9194bd48eefcfaa5213f208
workload_listener	''	7d29749dc9194bd48eefcfaa5213f208
model	cifar10.py	7d29749dc9194bd48eefcfaa5213f208
manual	False	7d29749dc9194bd48eefcfaa5213f208
max_epoch	5	7d29749dc9194bd48eefcfaa5213f208
max_time	172800	7d29749dc9194bd48eefcfaa5213f208
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
22422f267d2949e5a4f7e5752d1fcf19	intrigued-elk-878	UNKNOWN			daga	FAILED	1715622712336	1715622848127		active	s3://mlflow-storage/0/22422f267d2949e5a4f7e5752d1fcf19/artifacts	0	\N
7d29749dc9194bd48eefcfaa5213f208	(0 0) polite-cod-312	UNKNOWN			daga	FINISHED	1715622912148	1715624202433		active	s3://mlflow-storage/0/7d29749dc9194bd48eefcfaa5213f208/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	22422f267d2949e5a4f7e5752d1fcf19
mlflow.source.name	file:///home/daga/radt#examples/pytorch	22422f267d2949e5a4f7e5752d1fcf19
mlflow.source.type	PROJECT	22422f267d2949e5a4f7e5752d1fcf19
mlflow.project.entryPoint	main	22422f267d2949e5a4f7e5752d1fcf19
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	22422f267d2949e5a4f7e5752d1fcf19
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	22422f267d2949e5a4f7e5752d1fcf19
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	22422f267d2949e5a4f7e5752d1fcf19
mlflow.runName	intrigued-elk-878	22422f267d2949e5a4f7e5752d1fcf19
mlflow.project.env	conda	22422f267d2949e5a4f7e5752d1fcf19
mlflow.project.backend	local	22422f267d2949e5a4f7e5752d1fcf19
mlflow.user	daga	7d29749dc9194bd48eefcfaa5213f208
mlflow.source.name	file:///home/daga/radt#examples/pytorch	7d29749dc9194bd48eefcfaa5213f208
mlflow.source.type	PROJECT	7d29749dc9194bd48eefcfaa5213f208
mlflow.project.entryPoint	main	7d29749dc9194bd48eefcfaa5213f208
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	7d29749dc9194bd48eefcfaa5213f208
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	7d29749dc9194bd48eefcfaa5213f208
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	7d29749dc9194bd48eefcfaa5213f208
mlflow.project.env	conda	7d29749dc9194bd48eefcfaa5213f208
mlflow.project.backend	local	7d29749dc9194bd48eefcfaa5213f208
mlflow.runName	(0 0) polite-cod-312	7d29749dc9194bd48eefcfaa5213f208
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

