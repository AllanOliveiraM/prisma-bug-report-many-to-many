--
-- PostgreSQL database dump
--

\restrict 4CgIIrmH1ygzeECZBeSyDJlQai9Zg5IURgN0vptXTiSO36GbZf93n9Gheksehfe

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 17.6 (Ubuntu 17.6-0ubuntu0.25.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SystemCultureMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SystemCultureMode" AS ENUM (
    'RICE_WHITE',
    'RICE_PARBO'
);


ALTER TYPE public."SystemCultureMode" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Company" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    name text NOT NULL,
    timezone text NOT NULL,
    country text NOT NULL,
    state text NOT NULL,
    city text NOT NULL
);


ALTER TABLE public."Company" OWNER TO postgres;

--
-- Name: Producer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Producer" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    name text NOT NULL,
    search_name text NOT NULL,
    "companyId" text NOT NULL
);


ALTER TABLE public."Producer" OWNER TO postgres;

--
-- Name: TraceabilityTrackingOptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TraceabilityTrackingOptions" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "SystemCultureMode" public."SystemCultureMode" DEFAULT 'RICE_WHITE'::public."SystemCultureMode" NOT NULL,
    "companyId" text NOT NULL
);


ALTER TABLE public."TraceabilityTrackingOptions" OWNER TO postgres;

--
-- Name: _ProducerToTraceabilityTrackingOptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_ProducerToTraceabilityTrackingOptions" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_ProducerToTraceabilityTrackingOptions" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Data for Name: Company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Company" (id, "createdAt", "updatedAt", name, timezone, country, state, city) FROM stdin;
grano	2025-12-02 23:25:12.468	2025-12-02 23:25:12.468	Test Company	America/Sao_Paulo	BR	RS	Pelotas
\.


--
-- Data for Name: Producer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Producer" (id, "createdAt", "updatedAt", "isActive", name, search_name, "companyId") FROM stdin;
cmip7hbxm0000pzfl27s6j2e1	2025-12-02 23:25:12.49	2025-12-02 23:25:12.49	t	Produtor 1	Produtor 1	grano
cmip7hdb30000taflzm3jiiy1	2025-12-02 23:25:14.271	2025-12-02 23:25:14.271	t	Produtor 1	Produtor 1	grano
cmip7he4h0000wafltkle614x	2025-12-02 23:25:15.329	2025-12-02 23:25:15.329	t	Produtor 1	Produtor 1	grano
cmip7heuw0000z7fld8nmeeol	2025-12-02 23:25:16.28	2025-12-02 23:25:16.28	t	Produtor 1	Produtor 1	grano
\.


--
-- Data for Name: TraceabilityTrackingOptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TraceabilityTrackingOptions" (id, "createdAt", "updatedAt", "SystemCultureMode", "companyId") FROM stdin;
TTO	2025-12-02 23:25:12.497	2025-12-02 23:25:12.497	RICE_WHITE	grano
\.


--
-- Data for Name: _ProducerToTraceabilityTrackingOptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_ProducerToTraceabilityTrackingOptions" ("A", "B") FROM stdin;
cmip7heuw0000z7fld8nmeeol	TTO
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
b36a2512-785f-4a5f-8b44-e150a49ca5ab	87ac755dc78ed17ab54d2e040571881a39580509dd748312c7f4c6670fd11803	2025-12-02 23:25:03.097179+00	20251202225647_initial	\N	\N	2025-12-02 23:25:03.083606+00	1
\.


--
-- Name: Company Company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Company"
    ADD CONSTRAINT "Company_pkey" PRIMARY KEY (id);


--
-- Name: Producer Producer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Producer"
    ADD CONSTRAINT "Producer_pkey" PRIMARY KEY (id);


--
-- Name: TraceabilityTrackingOptions TraceabilityTrackingOptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TraceabilityTrackingOptions"
    ADD CONSTRAINT "TraceabilityTrackingOptions_pkey" PRIMARY KEY (id);


--
-- Name: _ProducerToTraceabilityTrackingOptions _ProducerToTraceabilityTrackingOptions_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ProducerToTraceabilityTrackingOptions"
    ADD CONSTRAINT "_ProducerToTraceabilityTrackingOptions_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Producer_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Producer_createdAt_idx" ON public."Producer" USING btree ("createdAt");


--
-- Name: TraceabilityTrackingOptions_SystemCultureMode_companyId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "TraceabilityTrackingOptions_SystemCultureMode_companyId_key" ON public."TraceabilityTrackingOptions" USING btree ("SystemCultureMode", "companyId");


--
-- Name: TraceabilityTrackingOptions_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "TraceabilityTrackingOptions_createdAt_idx" ON public."TraceabilityTrackingOptions" USING btree ("createdAt");


--
-- Name: _ProducerToTraceabilityTrackingOptions_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_ProducerToTraceabilityTrackingOptions_B_index" ON public."_ProducerToTraceabilityTrackingOptions" USING btree ("B");


--
-- Name: Producer Producer_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Producer"
    ADD CONSTRAINT "Producer_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Company"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TraceabilityTrackingOptions TraceabilityTrackingOptions_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TraceabilityTrackingOptions"
    ADD CONSTRAINT "TraceabilityTrackingOptions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Company"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ProducerToTraceabilityTrackingOptions _ProducerToTraceabilityTrackingOptions_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ProducerToTraceabilityTrackingOptions"
    ADD CONSTRAINT "_ProducerToTraceabilityTrackingOptions_A_fkey" FOREIGN KEY ("A") REFERENCES public."Producer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ProducerToTraceabilityTrackingOptions _ProducerToTraceabilityTrackingOptions_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ProducerToTraceabilityTrackingOptions"
    ADD CONSTRAINT "_ProducerToTraceabilityTrackingOptions_B_fkey" FOREIGN KEY ("B") REFERENCES public."TraceabilityTrackingOptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 4CgIIrmH1ygzeECZBeSyDJlQai9Zg5IURgN0vptXTiSO36GbZf93n9Gheksehfe

