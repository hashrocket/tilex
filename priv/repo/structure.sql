--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 15.0

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.channels (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    twitter_hashtag character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;


--
-- Name: developers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.developers (
    id bigint NOT NULL,
    email character varying NOT NULL,
    username character varying NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    twitter_handle character varying(255),
    admin boolean DEFAULT false,
    editor character varying(255) DEFAULT 'Text Field'::character varying
);


--
-- Name: developers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.developers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: developers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.developers_id_seq OWNED BY public.developers.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    channel_id integer NOT NULL,
    slug character varying(255) NOT NULL,
    likes integer DEFAULT 1 NOT NULL,
    max_likes integer DEFAULT 1 NOT NULL,
    published_at timestamp with time zone DEFAULT now() NOT NULL,
    developer_id bigint,
    tweeted_at timestamp with time zone,
    CONSTRAINT likes_must_be_greater_than_zero CHECK ((likes > 0)),
    CONSTRAINT max_likes_must_be_greater_than_zero CHECK ((max_likes > 0))
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.requests (
    page text NOT NULL,
    request_time timestamp with time zone DEFAULT now()
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);


--
-- Name: developers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.developers ALTER COLUMN id SET DEFAULT nextval('public.developers_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: developers developers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: channels_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX channels_name_index ON public.channels USING btree (name);


--
-- Name: index_requests_on_request_time_in_app_tz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_requests_on_request_time_in_app_tz ON public.requests USING btree (timezone('america/chicago'::text, request_time));


--
-- Name: posts_channel_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_channel_id_index ON public.posts USING btree (channel_id);


--
-- Name: posts_developer_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_developer_id_index ON public.posts USING btree (developer_id);


--
-- Name: posts_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX posts_slug_index ON public.posts USING btree (slug);


--
-- Name: requests_page_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX requests_page_index ON public.requests USING btree (page);


--
-- Name: requests_request_time_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX requests_request_time_index ON public.requests USING btree (request_time);


--
-- Name: posts posts_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id) ON DELETE CASCADE;


--
-- Name: posts posts_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20161118221207);
INSERT INTO public."schema_migrations" (version) VALUES (20161228153637);
INSERT INTO public."schema_migrations" (version) VALUES (20161228161102);
INSERT INTO public."schema_migrations" (version) VALUES (20161229180247);
INSERT INTO public."schema_migrations" (version) VALUES (20170106200911);
INSERT INTO public."schema_migrations" (version) VALUES (20170120203217);
INSERT INTO public."schema_migrations" (version) VALUES (20170317204314);
INSERT INTO public."schema_migrations" (version) VALUES (20170317205716);
INSERT INTO public."schema_migrations" (version) VALUES (20170317210210);
INSERT INTO public."schema_migrations" (version) VALUES (20170317210552);
INSERT INTO public."schema_migrations" (version) VALUES (20170317210749);
INSERT INTO public."schema_migrations" (version) VALUES (20170317214042);
INSERT INTO public."schema_migrations" (version) VALUES (20170319161606);
INSERT INTO public."schema_migrations" (version) VALUES (20170518173833);
INSERT INTO public."schema_migrations" (version) VALUES (20170518183105);
INSERT INTO public."schema_migrations" (version) VALUES (20170601120632);
INSERT INTO public."schema_migrations" (version) VALUES (20170602200233);
INSERT INTO public."schema_migrations" (version) VALUES (20170726192554);
INSERT INTO public."schema_migrations" (version) VALUES (20170823194255);
INSERT INTO public."schema_migrations" (version) VALUES (20171208181757);
INSERT INTO public."schema_migrations" (version) VALUES (20180908171609);
INSERT INTO public."schema_migrations" (version) VALUES (20190827182708);
INSERT INTO public."schema_migrations" (version) VALUES (20200518184142);
INSERT INTO public."schema_migrations" (version) VALUES (20220425135720);
INSERT INTO public."schema_migrations" (version) VALUES (20220429184256);
