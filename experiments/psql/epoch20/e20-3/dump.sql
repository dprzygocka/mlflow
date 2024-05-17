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
0	Default	s3://mlflow-storage/0	active	1715612289637	1715612289637
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
SMI - Power Draw	15.16	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
SMI - Timestamp	1715612728.79	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
SMI - GPU Util	0	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
SMI - Mem Util	0	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
SMI - Mem Used	0	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
SMI - Performance State	3	1715612728812	0	f	493d36e1c4a14773a101da23485ebb72
TOP - CPU Utilization	111	1715613333942	0	f	493d36e1c4a14773a101da23485ebb72
TOP - Memory Usage GB	2.5471999999999997	1715613333942	0	f	493d36e1c4a14773a101da23485ebb72
TOP - Memory Utilization	7.3	1715613333942	0	f	493d36e1c4a14773a101da23485ebb72
TOP - Swap Memory GB	0.0498	1715613333967	0	f	493d36e1c4a14773a101da23485ebb72
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1715612728531	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	0	1715612728531	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	1.8571	1715612728531	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612728571	493d36e1c4a14773a101da23485ebb72	0	f
SMI - Power Draw	15.16	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
SMI - Timestamp	1715612728.79	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
SMI - GPU Util	0	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
SMI - Mem Util	0	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
SMI - Mem Used	0	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
SMI - Performance State	3	1715612728812	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	200	1715612729535	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715612729535	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	1.8571	1715612729535	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612729580	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	107	1715612730537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612730537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	1.8571	1715612730537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612730564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	107	1715612731540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.6000000000000005	1715612731540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0961	1715612731540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612731561	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612732542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612732542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0961	1715612732542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612732570	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612733545	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612733545	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0961	1715612733545	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612733585	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612734548	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612734548	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0979	1715612734548	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612734579	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612735551	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612735551	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0979	1715612735551	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612735578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612736553	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612736553	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0979	1715612736553	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612736571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612737556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612737556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.099	1715612737556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612737578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612738559	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612738559	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.099	1715612738559	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612738578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612739562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612739562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.099	1715612739562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612739583	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612740564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715612740564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612740564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612740584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612741567	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612741567	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612741567	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612741587	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612742571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612742571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612742571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612742594	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612750609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612751621	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612754632	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613057360	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613057360	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613057360	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613058364	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613058364	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5275	1715613058364	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613064379	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613064379	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613064379	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613072395	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613072395	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613072395	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613089432	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613089432	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286999999999997	1715613089432	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613090434	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613090434	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286999999999997	1715613090434	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613096446	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613096446	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613096446	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613100454	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613100454	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715613100454	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613101456	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613101456	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715613101456	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613103481	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613111493	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613114507	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613299884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613301889	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613302898	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613303900	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613307909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613316907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613316907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613316907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613320915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.699999999999999	1715613320915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5444	1715613320915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613332026	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612743573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612743573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0970999999999997	1715612743573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612744576	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612744576	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0970999999999997	1715612744576	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612745578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612745578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0970999999999997	1715612745578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612746604	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612747611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612748616	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612752628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612755631	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612756635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613057384	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613058387	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613064400	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613073399	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613073399	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5326	1715613073399	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613089455	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613090455	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613096459	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613100477	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613103460	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613103460	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5309	1715613103460	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613111477	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613111477	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613111477	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613114483	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715613114483	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613114483	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5454	1715613300873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613315905	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613315905	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5438	1715613315905	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613318911	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.6	1715613318911	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613318911	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613322920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613322920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613322920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715613323922	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715613323922	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613323922	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613324924	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.699999999999999	1715613324924	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613324924	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613326928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.699999999999999	1715613326928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5445	1715613326928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613329934	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.8	1715613329934	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471	1715613329934	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612743596	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612744595	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612746581	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612746581	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612746581	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612747584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612747584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612747584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612748587	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612748587	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0972	1715612748587	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612752598	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612752598	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612752598	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612755606	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612755606	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612755606	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612756609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612756609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612756609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613059367	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613059367	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5275	1715613059367	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613061371	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613061371	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305999999999997	1715613061371	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613062373	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613062373	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305999999999997	1715613062373	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613066383	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613066383	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613066383	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613068387	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613068387	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5323	1715613068387	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613070391	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613070391	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613070391	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613078409	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613078409	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613078409	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613081415	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613081415	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5256999999999996	1715613081415	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613084421	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613084421	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613084421	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613085424	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613085424	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5298000000000003	1715613085424	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613086426	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613086426	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5298000000000003	1715613086426	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613093440	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613093440	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613093440	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613095444	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613095444	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613095444	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613112479	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613112479	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613112479	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613115485	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613115485	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612745599	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612749617	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612753631	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613059389	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613061387	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613062395	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613066396	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613068400	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613070412	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613078430	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613081431	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613084437	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613085446	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613086446	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613093461	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613095459	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613113481	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613113481	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613113481	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613115507	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613116509	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613312898	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613312898	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613316930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613331938	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613331938	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471999999999997	1715613331938	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612749589	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612749589	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991	1715612749589	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612753601	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612753601	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612753601	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613060369	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.3	1715613060369	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5275	1715613060369	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613063377	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613063377	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305999999999997	1715613063377	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613065404	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613067406	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613071408	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613073422	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613074422	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613080436	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613082434	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613092460	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613094464	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613099452	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613099452	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305	1715613099452	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613101470	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613102480	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613104487	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613106480	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613108491	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613109493	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613110497	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613317909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613317909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613317909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613319914	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613319914	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5444	1715613319914	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613321917	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613321917	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5444	1715613321917	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613325926	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613325926	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5445	1715613325926	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613330936	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613330936	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471	1715613330936	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613332940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613332940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471999999999997	1715613332940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612750592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612750592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991	1715612750592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612751595	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612751595	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991	1715612751595	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612754603	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612754603	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612754603	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612757611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612757611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.0991999999999997	1715612757611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612757633	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612758614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612758614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612758614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612758641	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612759617	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612759617	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612759617	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612759645	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612760620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612760620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612760620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612760649	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612761622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612761622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612761622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612761651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612762625	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612762625	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612762625	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612762654	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612763628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612763628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612763628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612763654	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612764631	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612764631	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612764631	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612764658	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612765635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612765635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612765635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612765654	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612766637	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612766637	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612766637	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612766663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612767640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612767640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612767640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612767668	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612768642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612768642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612768642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612768671	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612769645	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612769645	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1014	1715612769645	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612769675	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612770648	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612770648	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612770648	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612770674	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612771677	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612772683	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612793732	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612801756	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613060383	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613063399	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613067385	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715613067385	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5323	1715613067385	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613071393	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613071393	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613071393	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613072412	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613074401	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715613074401	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5326	1715613074401	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613080413	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613080413	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5256999999999996	1715613080413	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613082417	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613082417	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613082417	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613092438	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613092438	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613092438	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613094442	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613094442	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5315	1715613094442	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613097448	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613097448	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305	1715613097448	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613099474	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613102458	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715613102458	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715613102458	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613104463	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613104463	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5309	1715613104463	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613106467	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613106467	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5322	1715613106467	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613108471	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613108471	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5322	1715613108471	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613109473	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8	1715613109473	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613109473	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613110475	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613110475	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613110475	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471999999999997	1715613333942	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612771651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612771651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612771651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612772653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612772653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1016	1715612772653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612787698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612787698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1028000000000002	1715612787698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612801735	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612801735	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1037	1715612801735	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613065381	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613065381	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613065381	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613069411	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613075418	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613076418	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613077421	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613079433	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613083433	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613087441	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613088451	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613091451	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613098450	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715613098450	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5305	1715613098450	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613105465	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613105465	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5309	1715613105465	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613107469	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613107469	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5322	1715613107469	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613112501	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612773657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612773657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612773657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612774660	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612774660	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612774660	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612776666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612776666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.102	1715612776666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612778694	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612779693	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612782683	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8	1715612782683	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1025	1715612782683	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612783687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612783687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1025	1715612783687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612784689	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612784689	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1025	1715612784689	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612785693	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612785693	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1028000000000002	1715612785693	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612787724	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612788726	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612789730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612790730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612791730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612792729	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612794717	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612794717	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612794717	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612795719	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612795719	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612795719	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612796722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612796722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612796722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612797725	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612797725	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1033000000000004	1715612797725	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612799730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612799730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1033000000000004	1715612799730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612802738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612802738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1037	1715612802738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612803741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612803741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035	1715612803741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612804743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612804743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035	1715612804743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612805746	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612805746	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035	1715612805746	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612806749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612806749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612806749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612807751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612807751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612807751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612808754	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612808754	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612773687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612774687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612778672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612778672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.102	1715612778672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612779675	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715612779675	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1026	1715612779675	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612780699	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612782702	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612783708	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612784707	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612785714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612788701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612788701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612788701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612789703	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612789703	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612789703	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612790706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612790706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612790706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612791709	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612791709	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612791709	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612792712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612792712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612792712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612793714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612793714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1031	1715612793714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612794737	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612795738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612796749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612797751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612799757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612802765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612803768	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612804770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612805771	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612806775	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612807778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612808781	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612809782	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612810786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612811786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612812793	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612813793	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613069389	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613069389	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5323	1715613069389	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613075403	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.1	1715613075403	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5326	1715613075403	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613076405	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613076405	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613076405	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613077407	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613077407	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613077407	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613079411	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613079411	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5256999999999996	1715613079411	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613083419	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612775663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612775663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1013	1715612775663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612777669	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612777669	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.102	1715612777669	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612814770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612814770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1034	1715612814770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612815772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612815772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1039	1715612815772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612816775	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612816775	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1039	1715612816775	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613083419	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613083419	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613087428	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613087428	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5298000000000003	1715613087428	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613088430	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613088430	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286999999999997	1715613088430	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613091436	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613091436	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5331	1715613091436	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613097471	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613098471	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613105485	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613107490	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613113504	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612775690	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612777688	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612814800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612815798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612816801	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613115485	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613116487	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613116487	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613116487	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612776687	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612781681	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612781681	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1026	1715612781681	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612786695	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.8999999999999995	1715612786695	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1028000000000002	1715612786695	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612798727	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612798727	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1033000000000004	1715612798727	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612800733	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612800733	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1037	1715612800733	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613117489	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613117489	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5321	1715613117489	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715613118492	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613118492	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5344	1715613118492	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613123502	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613123502	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5134000000000003	1715613123502	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613129515	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613129515	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5313000000000003	1715613129515	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613139537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715613139537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613139537	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613142544	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613142544	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715613142544	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613150562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613150562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5339	1715613150562	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613152566	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613152566	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5354	1715613152566	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613154592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613156596	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613157591	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613160597	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613162610	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613166612	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613175640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612780678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612780678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1026	1715612780678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612781701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612786720	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612798747	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612800758	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613117505	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613121498	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613121498	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5134000000000003	1715613121498	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613127511	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613127511	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5313000000000003	1715613127511	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613129531	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613139559	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613143546	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613143546	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715613143546	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613150578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613152580	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613156575	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.3	1715613156575	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5356	1715613156575	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613157578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613157578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.536	1715613157578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613160584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613160584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5372	1715613160584	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613162588	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613162588	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5372	1715613162588	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613166596	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613166596	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5359000000000003	1715613166596	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613175616	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613175616	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5369	1715613175616	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612808754	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612809757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.6	1715612809757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612809757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612810759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612810759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612810759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612811762	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612811762	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1035999999999997	1715612811762	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612812765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612812765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1034	1715612812765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612813767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612813767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1034	1715612813767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612817778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612817778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1039	1715612817778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612817805	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612818781	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612818781	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1058000000000003	1715612818781	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612818800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612819783	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612819783	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1058000000000003	1715612819783	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612819811	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612820786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612820786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1058000000000003	1715612820786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612820814	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612821789	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612821789	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.106	1715612821789	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612821817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612822792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612822792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.106	1715612822792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612822819	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612823794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612823794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.106	1715612823794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612823824	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612824798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612824798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1059	1715612824798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612824828	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612825800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612825800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1059	1715612825800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612825817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612826803	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612826803	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1059	1715612826803	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612826829	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612827807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715612827807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612827807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612827827	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612828809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612828809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612828809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612828826	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612829813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612829813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612829813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612837860	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612844887	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612849902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612853887	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612853887	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1090999999999998	1715612853887	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612855896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.8	1715612855896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612855896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612858922	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612861967	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612866945	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612867948	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613118506	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613120517	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613122521	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613124526	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613125521	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613126525	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613131521	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613131521	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613131521	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613132523	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613132523	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613132523	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613135551	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613140540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613140540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613140540	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613143560	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613144564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613149581	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613151586	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613153591	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613165594	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.6	1715613165594	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5357	1715613165594	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613170620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612829841	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612844858	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612844858	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1066	1715612844858	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612849873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612849873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612849873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612852881	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612852881	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1090999999999998	1715612852881	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612854938	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612855920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612861913	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612861913	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612861913	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612866925	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612866925	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612866925	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612867928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612867928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612867928	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613119494	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613119494	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5344	1715613119494	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613128513	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613128513	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5313000000000003	1715613128513	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613130517	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613130517	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613130517	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613133525	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613133525	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613133525	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613135530	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613135530	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613135530	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613136545	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613146578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613147578	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613148582	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613163590	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715613163590	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5357	1715613163590	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613164592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613164592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5357	1715613164592	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613167599	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.1	1715613167599	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5359000000000003	1715613167599	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613168600	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613168600	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5359000000000003	1715613168600	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613171607	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613171607	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715613171607	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613172609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613172609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613172609	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612830816	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612830816	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612830816	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612832821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612832821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612832821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612834826	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612834826	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1048	1715612834826	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612835830	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612835830	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1048	1715612835830	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612838842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612838842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1045	1715612838842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612839845	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612839845	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1069	1715612839845	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612847867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612847867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1071	1715612847867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612860926	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612865923	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612865923	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612865923	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612873961	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612876950	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612876950	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612876950	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613119514	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613128528	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613130531	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613133546	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613136532	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613136532	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5349	1715613136532	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613146554	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613146554	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613146554	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613147556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613147556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613147556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613148558	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613148558	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5339	1715613148558	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613161586	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613161586	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5372	1715613161586	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613163612	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613164613	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613167623	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613168622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613171621	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613172632	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612830848	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612832850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612834852	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612835856	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612838864	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612839866	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612847893	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612863946	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612865940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612875969	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612876968	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613120496	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613120496	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5344	1715613120496	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613122500	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613122500	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5134000000000003	1715613122500	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613124505	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613124505	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613124505	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613125507	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.399999999999999	1715613125507	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613125507	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613126510	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613126510	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5299	1715613126510	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613127526	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613131536	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613132544	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613138536	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613138536	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5349	1715613138536	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613140556	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613144550	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.3	1715613144550	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715613144550	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613149560	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613149560	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5339	1715613149560	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613151564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613151564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5354	1715613151564	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613153569	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715613153569	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5354	1715613153569	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613161607	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613170604	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613170604	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715613170604	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612831818	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612831818	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1056	1715612831818	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612833824	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612833824	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1048	1715612833824	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612836834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.6	1715612836834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1045	1715612836834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612837839	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612837839	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1045	1715612837839	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612842853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612842853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1066	1715612842853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612843855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612843855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1066	1715612843855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612845861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612845861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1071	1715612845861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612846865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612846865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1071	1715612846865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612848870	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612848870	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612848870	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612850876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612850876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612850876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612851878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612851878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1090999999999998	1715612851878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612854893	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612854893	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612854893	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612857902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612857902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612857902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612862915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.6	1715612862915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612862915	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	109	1715612863918	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.5	1715612863918	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612863918	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612868931	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612868931	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612868931	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612869933	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612869933	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612869933	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612871952	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612874963	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613121511	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613134527	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613134527	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613134527	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613137534	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613137534	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5349	1715613137534	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613138558	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613141555	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613145552	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715613145552	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612831839	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612833850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612836862	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612840847	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612840847	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1069	1715612840847	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612842879	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612843884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612845888	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612846894	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612848896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612850896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612851902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612856899	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	12.899999999999999	1715612856899	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612856899	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612857932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612862932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612864921	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612864921	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612864921	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612868950	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612869952	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612874945	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612874945	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1086	1715612874945	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612875948	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.9	1715612875948	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612875948	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613123523	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613134548	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613137555	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613141542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613141542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5335	1715613141542	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613142560	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613145565	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613155573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715613155573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5356	1715613155573	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613158580	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613158580	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.536	1715613158580	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613159582	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613159582	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.536	1715613159582	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613165616	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613169625	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613173635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613174626	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613176638	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612840867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612841877	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612853914	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612858904	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	12.7	1715612858904	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612858904	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612859932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612864944	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612870962	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612872940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612872940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1086	1715612872940	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612873943	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612873943	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1086	1715612873943	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613145552	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613154571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613154571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5356	1715613154571	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613155591	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613158601	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613159595	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613169602	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613169602	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715613169602	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613173611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.3	1715613173611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613173611	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613174614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613174614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613174614	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613176618	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613176618	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5369	1715613176618	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612841850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612841850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1069	1715612841850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612852921	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612856920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612859907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612859907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612859907	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612860909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715612860909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612860909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612870935	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612870935	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612870935	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612871937	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612871937	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612871937	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612872958	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612877953	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612877953	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.109	1715612877953	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612877975	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612878956	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612878956	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612878956	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612878985	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612879959	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612879959	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612879959	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612879985	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612880962	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715612880962	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612880962	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612880988	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	107	1715612881966	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612881966	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612881966	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612881995	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612882969	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612882969	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612882969	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612882994	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612883972	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612883972	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1087	1715612883972	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612883995	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612884975	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612884975	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612884975	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612885013	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612885979	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612885979	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612885979	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612886005	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612886982	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612886982	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1089	1715612886982	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612887015	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612887986	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612887986	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1092	1715612887986	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612888018	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612888990	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612888990	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1092	1715612888990	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612889992	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612889992	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1092	1715612889992	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612890996	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612890996	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1093	1715612890996	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612892000	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612892000	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1093	1715612892000	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612895038	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612896042	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612910053	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612910053	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5295	1715612910053	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612916079	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612917082	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612920094	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612921089	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612924082	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612924082	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715612924082	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612925097	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612931097	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612931097	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715612931097	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612934103	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612934103	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5211	1715612934103	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613177620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613177620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5369	1715613177620	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613181642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613185651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613186653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613187657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613190663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613195670	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613201670	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613201670	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613201670	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613206680	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613206680	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5398	1715613206680	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613208698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613213719	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613221732	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613232754	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613234757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613236761	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612889015	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612890023	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612891016	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	107	1715612895009	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	12.7	1715612895009	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612895009	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	106	1715612896013	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612896013	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612896013	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612903064	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612916065	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612916065	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5332	1715612916065	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612917068	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612917068	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715612917068	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612920074	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612920074	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612920074	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612921076	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715612921076	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612921076	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612922093	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612925084	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612925084	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715612925084	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612927103	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612931118	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612934123	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613177634	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613185636	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613185636	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613185636	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613186638	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613186638	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613186638	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613187640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613187640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613187640	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613190647	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613190647	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613190647	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613195657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613195657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613195657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613197676	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613201683	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613206701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613213694	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613213694	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366999999999997	1715613213694	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613221710	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613221710	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613221710	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613232732	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613232732	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613232732	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613234736	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613234736	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613234736	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613236741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613236741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5388	1715613236741	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612892022	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612893025	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612894033	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612898047	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612900046	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612911055	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612911055	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612911055	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715612923080	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612923080	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5333	1715612923080	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612926086	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715612926086	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5343	1715612926086	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612933101	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612933101	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5211	1715612933101	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612935105	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612935105	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5198	1715612935105	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613178622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613178622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5345	1715613178622	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613179646	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613184634	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613184634	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613184634	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613192651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613192651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613192651	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613196659	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613196659	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5358	1715613196659	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613198663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613198663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5358	1715613198663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613199666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.299999999999999	1715613199666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613199666	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613200682	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613202684	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613208684	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613208684	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5334	1715613208684	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613209710	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613216722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613218725	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613219720	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613228744	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613231730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	4.4	1715613231730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613231730	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613233734	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613233734	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613233734	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612893003	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715612893003	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1093	1715612893003	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612894006	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.1	1715612894006	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1088	1715612894006	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612898019	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612898019	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1090999999999998	1715612898019	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612900025	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612900025	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1106	1715612900025	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612910075	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612911072	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612923093	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612926107	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612933122	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612935120	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613178635	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613182630	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613182630	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613182630	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613183632	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.6	1715613183632	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613183632	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613191663	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613194670	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613203696	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613205691	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613210701	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613211705	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613212707	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613214717	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613217728	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613220722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613222733	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613223728	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613225739	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613226735	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613227742	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613230728	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613230728	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613230728	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613235738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613235738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5388	1715613235738	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612897016	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612897016	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1090999999999998	1715612897016	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612902032	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612902032	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.3176	1715612902032	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612903036	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612903036	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.3176	1715612903036	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612905070	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612907046	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612907046	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5264	1715612907046	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612908048	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715612908048	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5295	1715612908048	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612909051	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612909051	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5295	1715612909051	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612914061	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612914061	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5332	1715612914061	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612918070	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612918070	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715612918070	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612919072	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612919072	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5341	1715612919072	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612924104	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612928113	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612936121	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613179624	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613179624	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5345	1715613179624	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613183646	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613184646	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613192664	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613196672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613198678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613199679	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613202672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	2.7	1715613202672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5375	1715613202672	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613203674	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613203674	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5375	1715613203674	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613209686	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613209686	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5334	1715613209686	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613216700	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613216700	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613216700	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613218704	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613218704	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5373	1715613218704	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613219706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613219706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5373	1715613219706	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613228724	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613228724	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613228724	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613229726	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613229726	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5316	1715613229726	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612897049	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612899022	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612899022	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1106	1715612899022	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612899048	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612901029	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612901029	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.1106	1715612901029	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612901051	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612902052	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612904038	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612904038	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.3176	1715612904038	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612904066	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612905041	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612905041	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5264	1715612905041	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612906043	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.6	1715612906043	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5264	1715612906043	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612906060	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612907071	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612908073	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612909080	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612912058	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.1	1715612912058	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612912058	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612912071	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612913059	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612913059	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612913059	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612913074	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612914075	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612915063	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612915063	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5332	1715612915063	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612915084	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612918085	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612919086	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612922078	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612922078	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5336999999999996	1715612922078	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612927088	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612927088	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5343	1715612927088	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612928090	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612928090	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5343	1715612928090	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612929093	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10	1715612929093	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715612929093	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612929115	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612930095	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612930095	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5191999999999997	1715612930095	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612930108	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612932099	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612932099	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5211	1715612932099	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612932111	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612936107	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612936107	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5198	1715612936107	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612937109	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612937109	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5198	1715612937109	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612937122	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612938112	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612938112	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5216	1715612938112	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612938127	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612939114	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.800000000000001	1715612939114	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5216	1715612939114	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612939126	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612940117	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612940117	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5216	1715612940117	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612940132	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612941119	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715612941119	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221	1715612941119	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612941132	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612942121	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612942121	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221	1715612942121	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612942134	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612943123	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612943123	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221	1715612943123	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612943137	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612944125	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612944125	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612944125	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612944140	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612945127	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612945127	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612945127	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612945141	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612946130	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612946130	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612946130	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612946143	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612947132	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612947132	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221999999999998	1715612947132	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612947144	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612948134	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612948134	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221999999999998	1715612948134	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612948159	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612949136	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612949136	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5221999999999998	1715612949136	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612949157	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612950138	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612950138	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5206	1715612950138	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612950158	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	98	1715612951140	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612951140	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5206	1715612951140	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612951154	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612952142	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612952142	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5206	1715612952142	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612952155	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612953144	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612953144	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5225	1715612953144	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612954146	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612954146	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5225	1715612954146	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612955148	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612955148	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5225	1715612955148	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612968174	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612968174	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5262	1715612968174	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612975189	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612975189	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.524	1715612975189	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612984207	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612984207	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5246	1715612984207	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612988215	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612988215	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612988215	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612991221	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612991221	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5267	1715612991221	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613180626	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715613180626	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5345	1715613180626	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613188642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613188642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613188642	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613189644	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613189644	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5338000000000003	1715613189644	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613193653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613193653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613193653	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613200668	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613200668	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613200668	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613204695	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613207703	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613215712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613224737	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612953165	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612954168	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612960158	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612960158	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5242	1715612960158	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612968198	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612975201	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612984228	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612988238	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612991239	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613180649	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613188657	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613189659	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613193667	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613204676	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.1	1715613204676	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5375	1715613204676	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613207682	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613207682	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5398	1715613207682	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613215698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613215698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613215698	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613224716	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613224716	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613224716	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612955163	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612961176	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612962174	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612963185	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612965182	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612967186	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612969197	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612970195	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612973206	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612976206	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612978216	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612979219	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612990240	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612993239	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612996244	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613181628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613181628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613181628	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613182644	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613191649	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613191649	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5342	1715613191649	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613194655	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613194655	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613194655	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613197661	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613197661	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5358	1715613197661	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613205678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715613205678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5398	1715613205678	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613210688	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.2	1715613210688	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5334	1715613210688	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613211690	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613211690	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366999999999997	1715613211690	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613212692	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613212692	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366999999999997	1715613212692	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613214696	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613214696	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5370999999999997	1715613214696	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613217702	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613217702	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5373	1715613217702	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613220708	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613220708	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613220708	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613222712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613222712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613222712	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613223714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613223714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613223714	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613225718	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613225718	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613225718	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613226720	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613226720	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613226720	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613227722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613227722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5366	1715613227722	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612956150	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612956150	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5237	1715612956150	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612957152	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715612957152	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5237	1715612957152	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612958154	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612958154	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5237	1715612958154	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612959156	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612959156	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5242	1715612959156	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612960182	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612974199	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612980219	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612986225	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613229747	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613230749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613235761	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612956165	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612957174	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612958175	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612959171	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612974187	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612974187	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.524	1715612974187	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612980199	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612980199	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612980199	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612986211	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612986211	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612986211	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612990219	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612990219	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5267	1715612990219	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613231744	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613233757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612961160	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612961160	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5242	1715612961160	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612962162	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612962162	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5239000000000003	1715612962162	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612963164	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612963164	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5239000000000003	1715612963164	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612965168	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612965168	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5251	1715612965168	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612967172	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612967172	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5251	1715612967172	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	105	1715612969176	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	12.499999999999998	1715612969176	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5262	1715612969176	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612970178	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612970178	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5262	1715612970178	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715612973185	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	4.2	1715612973185	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5	1715612973185	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612976191	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612976191	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.524	1715612976191	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612978195	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612978195	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612978195	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612979197	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612979197	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612979197	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612983205	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612983205	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5246	1715612983205	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612993225	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715612993225	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5248000000000004	1715612993225	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612996231	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612996231	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612996231	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613237743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613237743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5388	1715613237743	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613242753	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613242753	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613242753	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613245759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613245759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.539	1715613245759	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	110	1715613246761	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613246761	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.539	1715613246761	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613249767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613249767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613249767	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613252774	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613252774	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613252774	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613254778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613254778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5381	1715613254778	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613256802	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612964166	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612964166	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5239000000000003	1715612964166	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715612966170	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612966170	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5251	1715612966170	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612971180	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715612971180	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5	1715612971180	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715612972182	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612972182	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5	1715612972182	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612977193	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715612977193	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612977193	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612981201	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715612981201	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612981201	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612982203	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715612982203	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612982203	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612983226	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612985222	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612987233	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612989231	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612992238	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612994243	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612995249	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613237757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613242766	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613245780	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613246775	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613249791	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613252787	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	110	1715613256782	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.299999999999999	1715613256782	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5389	1715613256782	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613257784	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613257784	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5389	1715613257784	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613260790	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613260790	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5401	1715613260790	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613262794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613262794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5418000000000003	1715613262794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613267805	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613267805	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613267805	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613270811	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613270811	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5436	1715613270811	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613276823	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613276823	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613276823	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613278827	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.299999999999999	1715613278827	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5421	1715613278827	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613279829	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613279829	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5421	1715613279829	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613281834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613281834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613281834	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612964187	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612966184	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612971195	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612972196	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612977215	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612981221	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612982216	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715612985209	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612985209	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5246	1715612985209	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612987213	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612987213	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5261	1715612987213	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612989217	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612989217	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5267	1715612989217	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612992223	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.7	1715612992223	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5248000000000004	1715612992223	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612994227	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715612994227	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5248000000000004	1715612994227	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612995229	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612995229	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612995229	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715612997233	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715612997233	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5238	1715612997233	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612997246	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715612998235	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715612998235	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5243	1715612998235	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612998258	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715612999237	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715612999237	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5243	1715612999237	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715612999258	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613000239	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613000239	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5243	1715613000239	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613000262	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613001241	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613001241	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5245	1715613001241	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613001255	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613002243	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613002243	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5245	1715613002243	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613002264	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613003245	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715613003245	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5245	1715613003245	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613003269	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613004248	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613004248	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5274	1715613004248	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613004270	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613005250	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613005250	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5274	1715613005250	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613005263	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613006252	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613006252	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5274	1715613006252	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613006265	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613011278	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613012287	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613016272	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.799999999999999	1715613016272	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.525	1715613016272	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613018276	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613018276	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.525	1715613018276	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613028297	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613028297	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.529	1715613028297	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613033307	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613033307	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613033307	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613034322	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613048339	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613048339	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613048339	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613050345	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613050345	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5294	1715613050345	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613052367	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613238745	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613238745	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613238745	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613251772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613251772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613251772	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613254801	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613258807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613259807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613261814	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613263817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613275821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613275821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613275821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613277825	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613277825	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5421	1715613277825	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613286844	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613286844	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.542	1715613286844	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613290873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613294882	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613300895	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613315920	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613318930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613322932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613323944	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613324946	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613326949	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613329954	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613007254	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7	1715613007254	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5269	1715613007254	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613009258	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613009258	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5269	1715613009258	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613017274	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.3	1715613017274	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.525	1715613017274	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613020280	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613020280	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613020280	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613023286	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613023286	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286	1715613023286	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613025290	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613025290	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5301	1715613025290	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613030301	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613030301	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.529	1715613030301	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613031303	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613031303	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613031303	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613032305	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613032305	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613032305	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613041325	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613041325	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613041325	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613047358	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613051347	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613051347	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5294	1715613051347	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613053352	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613053352	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613053352	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613054354	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.2	1715613054354	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613054354	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613056373	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613238758	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613251792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613258786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613258786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5389	1715613258786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613259788	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613259788	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5401	1715613259788	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613261792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613261792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5401	1715613261792	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613263796	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613263796	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5418000000000003	1715613263796	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613271827	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613275843	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613277841	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613286858	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613294861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.8	1715613294861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613294861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613300873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.5	1715613300873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613007269	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613009279	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613017335	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613020302	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613023301	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613025312	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613030325	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613031316	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613032324	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613047337	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.1	1715613047337	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613047337	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613050366	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613051361	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613053365	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613056358	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613056358	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613056358	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613239747	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613239747	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613239747	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613240749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613240749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5382	1715613240749	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613243755	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.000000000000001	1715613243755	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613243755	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613247763	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613247763	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613247763	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613248765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613248765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5395	1715613248765	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613255780	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613255780	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5381	1715613255780	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613264798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613264798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5418000000000003	1715613264798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613265800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613265800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613265800	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613266802	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613266802	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5437	1715613266802	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613268807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613268807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5436	1715613268807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613269809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613269809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5436	1715613269809	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613271813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613271813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613271813	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613280851	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613284864	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613289851	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.299999999999999	1715613289851	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5439000000000003	1715613289851	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613290853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613290853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5439000000000003	1715613290853	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613296879	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613297889	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613008256	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613008256	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5269	1715613008256	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613010260	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715613010260	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5259	1715613010260	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613013266	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613013266	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5244	1715613013266	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613014292	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613019299	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613024310	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613027309	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613038334	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613043329	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613043329	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613043329	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613046335	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613046335	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613046335	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613049355	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613239769	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613240769	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613243776	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613247785	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613248786	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613255794	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613264821	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613265824	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613266815	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613268826	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613269830	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613280832	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613280832	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613280832	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613284840	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.5	1715613284840	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613284840	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613287846	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613287846	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.542	1715613287846	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613289873	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613296865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613296865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613296865	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613297867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613297867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613297867	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613299871	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613299871	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5454	1715613299871	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613301876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613301876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.546	1715613301876	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613302878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613302878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.546	1715613302878	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613303880	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613303880	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.546	1715613303880	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613307888	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.5	1715613307888	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613307888	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613312898	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613008269	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613010281	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613013288	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	108	1715613019278	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715613019278	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613019278	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613024288	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613024288	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286	1715613024288	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613027294	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613027294	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5301	1715613027294	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613038317	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613038317	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5263	1715613038317	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613041338	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613043351	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613046352	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613241751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.6000000000000005	1715613241751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5368000000000004	1715613241751	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613244757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613244757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.539	1715613244757	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613250770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613250770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613250770	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613253776	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.6	1715613253776	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5381	1715613253776	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613272815	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.4	1715613272815	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613272815	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613273817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613273817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613273817	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613274819	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.300000000000001	1715613274819	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613274819	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613285842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.5	1715613285842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613285842	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613288848	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.699999999999999	1715613288848	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.542	1715613288848	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613291855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613291855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5439000000000003	1715613291855	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613293859	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613293859	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613293859	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613295863	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613295863	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5423	1715613295863	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613306899	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613309905	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613310909	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613311919	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613313901	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613313901	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5438	1715613313901	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613314903	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	9.899999999999999	1715613314903	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5438	1715613314903	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613011262	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613011262	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5259	1715613011262	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613012264	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.1	1715613012264	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5259	1715613012264	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613014268	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613014268	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5244	1715613014268	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613016292	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613018298	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613028317	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	100	1715613034309	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613034309	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5296	1715613034309	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613044353	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613048361	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613052350	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613052350	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5318	1715613052350	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613054375	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613241766	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613244849	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613250790	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613253796	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613272828	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613273838	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613274839	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613285863	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613288871	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613291868	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613293880	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613295884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613309892	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613309892	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613309892	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613310894	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.5	1715613310894	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613310894	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613311896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613311896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613311896	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613312918	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613313921	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613314924	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613317922	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613319936	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613321930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613325948	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613330950	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613332964	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613015270	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715613015270	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5244	1715613015270	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613021282	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.8	1715613021282	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613021282	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613022284	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.5	1715613022284	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5286	1715613022284	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613026292	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8	1715613026292	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5301	1715613026292	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613029299	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613029299	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.529	1715613029299	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613033330	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613035333	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613036326	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613037330	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613039333	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613040344	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613042340	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613045333	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.2	1715613045333	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613045333	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613049341	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613049341	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5294	1715613049341	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613055377	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613257798	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613260807	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613262810	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613267825	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613270833	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613276837	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613278841	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613279850	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613281847	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613282851	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613283861	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613292857	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.5	1715613292857	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5428	1715613292857	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613298869	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613298869	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5454	1715613298869	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613304882	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613304882	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5453	1715613304882	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613305884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.6	1715613305884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5453	1715613305884	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613306886	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	10.299999999999999	1715613306886	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5453	1715613306886	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613308914	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613327930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613327930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5445	1715613327930	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613328932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3999999999999995	1715613328932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5471	1715613328932	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	111	1715613333942	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613333942	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613015291	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613021304	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613022300	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613026314	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613029321	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613035311	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	8.4	1715613035311	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5296	1715613035311	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613036313	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.3	1715613036313	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5296	1715613036313	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613037315	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613037315	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5263	1715613037315	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613039319	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613039319	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5263	1715613039319	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	104	1715613040323	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	6.9	1715613040323	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613040323	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613042327	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613042327	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5278	1715613042327	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613044331	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.1000000000000005	1715613044331	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5302	1715613044331	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613045353	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	102	1715613055356	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613055356	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5308	1715613055356	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	103	1715613282836	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	7.2	1715613282836	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5424	1715613282836	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613283838	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.7	1715613283838	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.5422	1715613283838	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613287860	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613292879	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613298890	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613304902	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613305906	493d36e1c4a14773a101da23485ebb72	0	f
TOP - CPU Utilization	101	1715613308890	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Utilization	5.4	1715613308890	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Memory Usage GB	2.544	1715613308890	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613320929	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613327949	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613328953	493d36e1c4a14773a101da23485ebb72	0	f
TOP - Swap Memory GB	0.0498	1715613333967	493d36e1c4a14773a101da23485ebb72	0	f
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
letter	0	3a31f3aec2d34012b14f920b72d25a60
workload	0	3a31f3aec2d34012b14f920b72d25a60
listeners	smi+top+dcgmi	3a31f3aec2d34012b14f920b72d25a60
params	'"-"'	3a31f3aec2d34012b14f920b72d25a60
file	cifar10.py	3a31f3aec2d34012b14f920b72d25a60
workload_listener	''	3a31f3aec2d34012b14f920b72d25a60
letter	0	493d36e1c4a14773a101da23485ebb72
workload	0	493d36e1c4a14773a101da23485ebb72
listeners	smi+top+dcgmi	493d36e1c4a14773a101da23485ebb72
params	'"-"'	493d36e1c4a14773a101da23485ebb72
file	cifar10.py	493d36e1c4a14773a101da23485ebb72
workload_listener	''	493d36e1c4a14773a101da23485ebb72
model	cifar10.py	493d36e1c4a14773a101da23485ebb72
manual	False	493d36e1c4a14773a101da23485ebb72
max_epoch	5	493d36e1c4a14773a101da23485ebb72
max_time	172800	493d36e1c4a14773a101da23485ebb72
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
3a31f3aec2d34012b14f920b72d25a60	big-loon-950	UNKNOWN			daga	RUNNING	1715612591928	\N		active	s3://mlflow-storage/0/3a31f3aec2d34012b14f920b72d25a60/artifacts	0	\N
493d36e1c4a14773a101da23485ebb72	(0 0) capable-sponge-869	UNKNOWN			daga	FINISHED	1715612719326	1715613335434		active	s3://mlflow-storage/0/493d36e1c4a14773a101da23485ebb72/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	3a31f3aec2d34012b14f920b72d25a60
mlflow.source.name	file:///home/daga/radt#examples/pytorch	3a31f3aec2d34012b14f920b72d25a60
mlflow.source.type	PROJECT	3a31f3aec2d34012b14f920b72d25a60
mlflow.project.entryPoint	main	3a31f3aec2d34012b14f920b72d25a60
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	3a31f3aec2d34012b14f920b72d25a60
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3a31f3aec2d34012b14f920b72d25a60
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	3a31f3aec2d34012b14f920b72d25a60
mlflow.runName	big-loon-950	3a31f3aec2d34012b14f920b72d25a60
mlflow.project.env	conda	3a31f3aec2d34012b14f920b72d25a60
mlflow.user	daga	493d36e1c4a14773a101da23485ebb72
mlflow.source.name	file:///home/daga/radt#examples/pytorch	493d36e1c4a14773a101da23485ebb72
mlflow.source.type	PROJECT	493d36e1c4a14773a101da23485ebb72
mlflow.project.entryPoint	main	493d36e1c4a14773a101da23485ebb72
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	493d36e1c4a14773a101da23485ebb72
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	493d36e1c4a14773a101da23485ebb72
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	493d36e1c4a14773a101da23485ebb72
mlflow.project.env	conda	493d36e1c4a14773a101da23485ebb72
mlflow.project.backend	local	493d36e1c4a14773a101da23485ebb72
mlflow.runName	(0 0) capable-sponge-869	493d36e1c4a14773a101da23485ebb72
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

