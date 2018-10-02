--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_interface_theme; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE admin_interface_theme (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    active boolean NOT NULL,
    title character varying(50) NOT NULL,
    title_visible boolean NOT NULL,
    logo character varying(100) NOT NULL,
    logo_visible boolean NOT NULL,
    css_header_background_color character varying(10) NOT NULL,
    css_header_title_color character varying(10) NOT NULL,
    css_header_text_color character varying(10) NOT NULL,
    css_header_link_color character varying(10) NOT NULL,
    css_header_link_hover_color character varying(10) NOT NULL,
    css_module_background_color character varying(10) NOT NULL,
    css_module_text_color character varying(10) NOT NULL,
    css_module_link_color character varying(10) NOT NULL,
    css_module_link_hover_color character varying(10) NOT NULL,
    css_module_rounded_corners boolean NOT NULL,
    css_generic_link_color character varying(10) NOT NULL,
    css_generic_link_hover_color character varying(10) NOT NULL,
    css_save_button_background_color character varying(10) NOT NULL,
    css_save_button_background_hover_color character varying(10) NOT NULL,
    css_save_button_text_color character varying(10) NOT NULL,
    css_delete_button_background_color character varying(10) NOT NULL,
    css_delete_button_background_hover_color character varying(10) NOT NULL,
    css_delete_button_text_color character varying(10) NOT NULL,
    css text NOT NULL,
    list_filter_dropdown boolean NOT NULL
);


ALTER TABLE admin_interface_theme OWNER TO jundymek;

--
-- Name: admin_interface_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE admin_interface_theme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin_interface_theme_id_seq OWNER TO jundymek;

--
-- Name: admin_interface_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE admin_interface_theme_id_seq OWNED BY admin_interface_theme.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE auth_group OWNER TO jundymek;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO jundymek;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO jundymek;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO jundymek;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO jundymek;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO jundymek;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO jundymek;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO jundymek;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO jundymek;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO jundymek;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO jundymek;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO jundymek;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: constance_config; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE constance_config (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE constance_config OWNER TO jundymek;

--
-- Name: constance_config_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE constance_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE constance_config_id_seq OWNER TO jundymek;

--
-- Name: constance_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE constance_config_id_seq OWNED BY constance_config.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE django_admin_log OWNER TO jundymek;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_admin_log_id_seq OWNER TO jundymek;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO jundymek;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO jundymek;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO jundymek;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO jundymek;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO jundymek;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE django_site OWNER TO jundymek;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_site_id_seq OWNER TO jundymek;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: mainapp_category; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE mainapp_category (
    id integer NOT NULL,
    category_name character varying(30) NOT NULL,
    slug character varying(50) NOT NULL,
    image character varying(100) NOT NULL,
    category_description text NOT NULL,
    category_keywords text NOT NULL
);


ALTER TABLE mainapp_category OWNER TO jundymek;

--
-- Name: mainapp_category_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE mainapp_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mainapp_category_id_seq OWNER TO jundymek;

--
-- Name: mainapp_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE mainapp_category_id_seq OWNED BY mainapp_category.id;


--
-- Name: mainapp_group; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE mainapp_group (
    id integer NOT NULL,
    group_name character varying(30) NOT NULL,
    codes text,
    pay character varying(10) NOT NULL,
    "time" character varying(3) NOT NULL,
    days integer NOT NULL,
    premium_box character varying(3) NOT NULL,
    category character varying(2) NOT NULL,
    text text NOT NULL,
    is_active boolean NOT NULL,
    secret_codes text
);


ALTER TABLE mainapp_group OWNER TO jundymek;

--
-- Name: mainapp_group_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE mainapp_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mainapp_group_id_seq OWNER TO jundymek;

--
-- Name: mainapp_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE mainapp_group_id_seq OWNED BY mainapp_group.id;


--
-- Name: mainapp_site; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE mainapp_site (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(500) NOT NULL,
    description text NOT NULL,
    keywords text NOT NULL,
    date timestamp with time zone NOT NULL,
    date_end timestamp with time zone,
    url character varying(200) NOT NULL,
    is_active boolean NOT NULL,
    flagged text,
    flagged_true boolean NOT NULL,
    email character varying(254) NOT NULL,
    "user" character varying(100) NOT NULL,
    kod character varying(20) NOT NULL,
    category_id integer NOT NULL,
    category1_id integer,
    group_id integer NOT NULL,
    subcategory_id integer NOT NULL,
    subcategory1_id integer,
    aftermarket_check boolean NOT NULL,
    evil_words_check boolean NOT NULL,
    little_chars_check boolean NOT NULL
);


ALTER TABLE mainapp_site OWNER TO jundymek;

--
-- Name: mainapp_site_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE mainapp_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mainapp_site_id_seq OWNER TO jundymek;

--
-- Name: mainapp_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE mainapp_site_id_seq OWNED BY mainapp_site.id;


--
-- Name: mainapp_subcategory; Type: TABLE; Schema: public; Owner: jundymek
--

CREATE TABLE mainapp_subcategory (
    id integer NOT NULL,
    subcategory_name character varying(30) NOT NULL,
    slug character varying(50) NOT NULL,
    category_id integer
);


ALTER TABLE mainapp_subcategory OWNER TO jundymek;

--
-- Name: mainapp_subcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: jundymek
--

CREATE SEQUENCE mainapp_subcategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mainapp_subcategory_id_seq OWNER TO jundymek;

--
-- Name: mainapp_subcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jundymek
--

ALTER SEQUENCE mainapp_subcategory_id_seq OWNED BY mainapp_subcategory.id;


--
-- Name: admin_interface_theme id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY admin_interface_theme ALTER COLUMN id SET DEFAULT nextval('admin_interface_theme_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: constance_config id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY constance_config ALTER COLUMN id SET DEFAULT nextval('constance_config_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: mainapp_category id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_category ALTER COLUMN id SET DEFAULT nextval('mainapp_category_id_seq'::regclass);


--
-- Name: mainapp_group id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_group ALTER COLUMN id SET DEFAULT nextval('mainapp_group_id_seq'::regclass);


--
-- Name: mainapp_site id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site ALTER COLUMN id SET DEFAULT nextval('mainapp_site_id_seq'::regclass);


--
-- Name: mainapp_subcategory id; Type: DEFAULT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_subcategory ALTER COLUMN id SET DEFAULT nextval('mainapp_subcategory_id_seq'::regclass);


--
-- Data for Name: admin_interface_theme; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY admin_interface_theme (id, name, active, title, title_visible, logo, logo_visible, css_header_background_color, css_header_title_color, css_header_text_color, css_header_link_color, css_header_link_hover_color, css_module_background_color, css_module_text_color, css_module_link_color, css_module_link_hover_color, css_module_rounded_corners, css_generic_link_color, css_generic_link_hover_color, css_save_button_background_color, css_save_button_background_hover_color, css_save_button_text_color, css_delete_button_background_color, css_delete_button_background_hover_color, css_delete_button_text_color, css, list_filter_dropdown) FROM stdin;
1	Django	f	Django administration	t	admin-interface/logo/logo-django_EfDGnDa.svg	t	#0C4B33	#F5DD5D	#44B78B	#FFFFFF	#C9F0DD	#44B78B	#FFFFFF	#FFFFFF	#C9F0DD	t	#0C3C26	#156641	#0C4B33	#0C3C26	#FFFFFF	#BA2121	#A41515	#FFFFFF		f
2	NetKat	t	Panel administracyjny	t	admin-interface/logo/netkat_logo.png	t	#E1FFFF	#000000	#44B78B	#44B78B	#59A9F0	#F8F8F8	#000000	#000000	#59A9F0	f	#0C3C26	#156641	#3B81E3	#1F3DB5	#FFFFFF	#BA2121	#A41515	#FFFFFF		t
\.


--
-- Name: admin_interface_theme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('admin_interface_theme_id_seq', 2, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add Theme	1	add_theme
2	Can change Theme	1	change_theme
3	Can delete Theme	1	delete_theme
4	Can add log entry	2	add_logentry
5	Can change log entry	2	change_logentry
6	Can delete log entry	2	delete_logentry
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add permission	4	add_permission
11	Can change permission	4	change_permission
12	Can delete permission	4	delete_permission
13	Can add group	5	add_group
14	Can change group	5	change_group
15	Can delete group	5	delete_group
16	Can add content type	6	add_contenttype
17	Can change content type	6	change_contenttype
18	Can delete content type	6	delete_contenttype
19	Can add session	7	add_session
20	Can change session	7	change_session
21	Can delete session	7	delete_session
22	Can add constance	8	add_constance
23	Can change constance	8	change_constance
24	Can delete constance	8	delete_constance
25	Can add sub category	9	add_subcategory
26	Can change sub category	9	change_subcategory
27	Can delete sub category	9	delete_subcategory
28	Can add site	10	add_site
29	Can change site	10	change_site
30	Can delete site	10	delete_site
31	Can add group	11	add_group
32	Can change group	11	change_group
33	Can delete group	11	delete_group
34	Can add category	12	add_category
35	Can change category	12	change_category
36	Can delete category	12	delete_category
37	Can add strony podejrzane	10	add_flaggedsite
38	Can change strony podejrzane	10	change_flaggedsite
39	Can delete strony podejrzane	10	delete_flaggedsite
40	Can add inactive site	10	add_inactivesite
41	Can change inactive site	10	change_inactivesite
42	Can delete inactive site	10	delete_inactivesite
43	Can add site	15	add_site
44	Can change site	15	change_site
45	Can delete site	15	delete_site
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_permission_id_seq', 45, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
7	pbkdf2_sha256$30000$rpTRPqy44chy$VKeaQxdR3JUpDRLzp50/HhOpVFtS2vwIS/LyrevqMPA=	2017-11-08 11:06:11.411628+01	t	admin			admin@admin.pl	t	t	2017-10-08 21:09:26.493094+02
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_user_id_seq', 11, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
9	7	29
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 10, true);


--
-- Data for Name: constance_config; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY constance_config (id, key, value) FROM stdin;
1	SITE_NAME	gAJYCgAAAE5PV0EgTkFaV0FxAC4=
22	WPISY_DO_MODERACJI	gAJYAwAAAHRha3EALg==
2	THEME	gAJYCgAAAGxpZ2h0LWJsdWVxAC4=
4	MY_SELECT_KEY	gAJdcQAoWAMAAAB5ZXNxAVgCAAAAbm9xAmUu
5	THE_ANSWER	gAJLFy4=
6	Tytół strony	gAJYFwAAAE5hamxlcHN6eSBrYXRhbG9nIHN0cm9ucQAu
7	SITE_TITLE	gAJYEQAAAE5hamxlcHN6eSBrYXRhbG9ncQAu
8	PREMIUM_LENGTH	gAJLHi4=
9	KEYWORDS_LENGTH	gAJLFC4=
11	DESCRIPTION_LENGTH	gAJLFC4=
12	BOX_PREMIUM	gAJYAwAAAHRha3EALg==
13	PREMIUM_TIME	gAJLHi4=
14	KEYWORDS_LENGTH_MAX	gAJLZC4=
18	TITLE_LENGTH_MIN	gAJLBS4=
19	TITLE_LENGTH_MAX	gAJLZC4=
20	CRON_ENABLE	gAJYAwAAAHRha3EALg==
21	CRON_MIN	gAJLBC4=
23	ILOSC_WPISOW	gAJLBS4=
24	CHECK_SITES	gAJYAwAAAHRha3EALg==
25	DELETE_SITES	gAJYAwAAAG5pZXEALg==
28	DESC_LINKS	gAJLAC4=
30	EMAIL_ADD_SITE	gAJYegAAADxwPlN0cm9uYSB7MH0gem9zdGHFgmEgcHJ6ZWthemFuYSBkbyBtb2RlcmFjamkuIFBvIHphdHdpZXJkemVuaXUgcHJ6ZXogbW9kZXJhdG9yYSBvdHJ6eW1hc3ogc3Rvc293bsSFIGluZm9ybWFjasSZLiB7M308L3A+cQAu
31	EVIL_WORDS_COUNT	gAJLBC4=
32	EMAIL_TEMPLATES	gAJYVgAAAFBvZGFueSBvcGlzIG5pZSBqZXN0IHpnb2RueSB6IHJlZ3VsYW1pbmVtDQpTdHJvbmEgbmllIGplc3QgemdvZG5hIHogbmFzenltIHJlZ3VsYW1pbmVtcQAu
26	EVIL_WORDS	gAJYFwAAAHNleCwgc2VrcywgYW5hbCwgdmlhZ3JhcQAu
10	SITE_KEYWORDS	gAJYOwAAAGthdGFsb2cgc3Ryb24sIG5hamxlcHN6eSBrYXRhbG9nIHN0cm9uLCBuZXRrYXQsIGthdGFsb2cgc2VvcQAu
3	SITE_DESCRIPTION	gAJYRAAAAE5FVEtBVCB0byBuYWpsZXBzenkgc2tyeXB0IGthdGFsb2d1IHN0cm9uIGpha2kga2llZHlrb2x3aWVrIHBvd3N0YcWCcQAu
29	DESC	gAJYXAAAADxwIHN0eWxlPSJ0ZXh0LWFsaWduOmp1c3RpZnkiPlRla3N0IHdwcm93YWR6YWrEhWN5IGRvIHdwaXNhbmlhIHcgUGFuZWx1IEFkbWluaXN0cmFjeWpueW08L3A+cQAu
34	CAPTCHA_PUBLIC	gAJYKAAAADZMY283ekFVQUFBQUFOakJ4T2p1ZUtsdFNxaVRpUk9FTkhpQXU5bXhxAC4=
35	CAPTCHA_PRIVATE	gAJYKAAAADZMY283ekFVQUFBQUFLUTVWZHFoZV9xNlZ5Y0oxbWRadmE3WUdyTDhxAC4=
15	KEYWORDS_LENGTH_MIN	gAJLCi4=
17	DESCRIPTION_LENGTH_MIN	gAJLZC4=
16	DESCRIPTION_LENGTH_MAX	gAJN9AEu
27	EDYTOR_WYSWIG	gAJYAwAAAHRha3EALg==
33	SHRINKTHEWEB_KEY	gAJYAAAAAHEALg==
36	CAPTCHA	gAJYAwAAAG5pZXEALg==
\.


--
-- Name: constance_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('constance_config_id_seq', 36, true);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	admin_interface	theme
2	admin	logentry
3	auth	user
4	auth	permission
5	auth	group
6	contenttypes	contenttype
7	sessions	session
8	database	constance
9	mainapp	subcategory
10	mainapp	site
11	mainapp	group
12	mainapp	category
13	mainapp	flaggedsite
14	mainapp	inactivesite
15	sites	site
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('django_content_type_id_seq', 15, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2017-08-24 23:54:43.040854+02
2	auth	0001_initial	2017-08-24 23:54:43.321928+02
3	admin	0001_initial	2017-08-24 23:54:43.405951+02
4	admin	0002_logentry_remove_auto_add	2017-08-24 23:54:43.423953+02
5	admin_interface	0001_initial	2017-08-24 23:54:43.464973+02
6	contenttypes	0002_remove_content_type_name	2017-08-24 23:54:43.518981+02
7	auth	0002_alter_permission_name_max_length	2017-08-24 23:54:43.538977+02
8	auth	0003_alter_user_email_max_length	2017-08-24 23:54:43.561002+02
9	auth	0004_alter_user_username_opts	2017-08-24 23:54:43.581011+02
10	auth	0005_alter_user_last_login_null	2017-08-24 23:54:43.600005+02
11	auth	0006_require_contenttypes_0002	2017-08-24 23:54:43.605006+02
12	auth	0007_alter_validators_add_error_messages	2017-08-24 23:54:43.623005+02
13	auth	0008_alter_user_username_max_length	2017-08-24 23:54:43.661028+02
14	database	0001_initial	2017-08-24 23:54:43.714031+02
15	sessions	0001_initial	2017-08-24 23:54:43.774044+02
16	mainapp	0001_initial	2017-08-24 23:59:46.870276+02
17	sites	0001_initial	2017-09-02 23:46:30.019365+02
18	sites	0002_alter_domain_unique	2017-09-02 23:46:30.051875+02
19	mainapp	0002_auto_20170902_2346	2017-09-04 23:42:19.010698+02
20	mainapp	0003_auto_20170911_2328	2017-09-16 00:15:12.327609+02
21	mainapp	0004_auto_20170911_2339	2017-09-16 00:15:12.361114+02
22	mainapp	0005_auto_20170916_0015	2017-09-16 20:26:28.021021+02
23	mainapp	0006_auto_20170922_0118	2017-09-22 22:57:17.508914+02
24	mainapp	0007_auto_20170922_2257	2017-09-23 00:10:59.875509+02
25	mainapp	0008_auto_20170925_0115	2017-09-25 01:16:39.978965+02
26	mainapp	0009_auto_20170925_0116	2017-09-25 22:26:11.397711+02
27	mainapp	0010_remove_site_email_template	2017-09-25 22:27:26.617335+02
28	mainapp	0011_auto_20170930_2333	2017-09-30 23:35:42.098021+02
29	mainapp	0012_auto_20171001_0045	2017-10-01 00:45:26.634158+02
30	mainapp	0013_auto_20171008_2254	2017-10-08 22:54:21.618688+02
31	mainapp	0014_auto_20171019_1225	2017-10-19 12:25:46.314027+02
32	mainapp	0015_remove_site_choice_check	2017-10-19 12:47:00.59409+02
33	mainapp	0016_group_secret_codes	2017-10-19 12:50:52.902041+02
34	mainapp	0017_auto_20171105_0109	2017-11-05 01:09:38.198428+01
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('django_migrations_id_seq', 34, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
tquqf2t9e9p0dm8ls1prvt9s2owaeslx	MzhjODM1NWVhMjhkZmFlMTZkNzAwNTk3YjdlYzRiZjNiZWE3ZjI3Mzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9oYXNoIjoiZjgwMmI1MzlkNzhhYzczNGIwZDMxMzEyOTBmODU1NmE3YzE0ODNjMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCJ9	2017-10-01 00:16:30.895307+02
2s709xjnmur12wfqh7vplxfxzi4sz2sc	NjI4M2I4OTNhNjk3OWRhMWRlNzhiMzU1N2MyNDdkMDVlZWZhMjc5Zjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9oYXNoIjoiZjgwMmI1MzlkNzhhYzczNGIwZDMxMzEyOTBmODU1NmE3YzE0ODNjMiIsInVybCI6Imh0dHA6Ly93d3cub25ldC5wbCJ9	2017-09-08 23:17:10.181+02
2yvpr254ixf09jec5f4j7cbdejr4a19c	MTE3N2RkNTIyOWU2YWY3ZjM4ZTMxODQ1NTI2MDExOGMwYTExMDUxZDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9oYXNoIjoiZjgwMmI1MzlkNzhhYzczNGIwZDMxMzEyOTBmODU1NmE3YzE0ODNjMiJ9	2017-09-13 00:04:11.18+02
kfwa70xuu1150agao4m2emuvkpq1ffv8	OTE0NDBmMzg0YTUxNzFmMTViOTVhMmY1YzU2ZmUxMDc1MzAzZjk3MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6ImY4MDJiNTM5ZDc4YWM3MzRiMGQzMTMxMjkwZjg1NTZhN2MxNDgzYzIiLCJ1cmwiOiJodHRwOi8vZGlldGEucGwiLCJfYXV0aF91c2VyX2lkIjoiMSJ9	2017-09-19 09:48:00.143+02
psku3706wuu8tsb26g4k09nzbvd22suw	ZDZjODhmMDU0OTYwMTc5YTVmNGUyN2ExZGJjNzMwMDVlYjZhZWU5Njp7Il9hdXRoX3VzZXJfaGFzaCI6ImY4MDJiNTM5ZDc4YWM3MzRiMGQzMTMxMjkwZjg1NTZhN2MxNDgzYzIiLCJ1cmwiOiJodHRwOi8vd3d3LmRvdHBheS5wbC8iLCJfYXV0aF91c2VyX2lkIjoiMSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCJ9	2017-10-02 23:27:00.164577+02
px85hkp077zy9t5yzgrey3cwn62y36i5	ZDg3ZDRlNTY2NGI4NzEyZmU3NjQwYTQxNDQ0ZDI3NzVhNDFmNDU0ODp7Il9hdXRoX3VzZXJfaWQiOiIxIiwidXJsIjoiaHR0cDovL2NhcmRnYW1lcy5wbCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6ImY4MDJiNTM5ZDc4YWM3MzRiMGQzMTMxMjkwZjg1NTZhN2MxNDgzYzIifQ==	2017-10-14 14:16:22.630419+02
ul550u1x3lwx9b4y9fy1z5e7it1q1bsi	MzA4OWY4MDM1MjBmN2YxZTc5NWJjZjYyYTg5N2M2MGU3NWMxMzY5YTp7Il9hdXRoX3VzZXJfaGFzaCI6ImUyNzMzNTNhNWNhNTBlZGYxMjNiODYyMjNkM2FiMDE1MTZhYmFkZDUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLkFsbG93QWxsVXNlcnNNb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2lkIjoiNyJ9	2017-10-22 21:10:49.105124+02
7aj8quu2rs9jtq2apqrjd5hdfu8366n2	ZTY5ZDVlYmUwM2JjNTQxZDQ2YzEzNWU0Yzg0OWE1YzY5NGY2NTIzMzp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiI3IiwiX2F1dGhfdXNlcl9oYXNoIjoiZTI3MzM1M2E1Y2E1MGVkZjEyM2I4NjIyM2QzYWIwMTUxNmFiYWRkNSJ9	2017-10-23 10:03:22.870519+02
md3jn6tvsca89f91zvto4y5o4dn3ysa2	MmJmZDUwYjIwZjQ2MzY4MWRhYmE0MGZhZDI3ZjJhNDMzODU5M2M4Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwidXJsIjoiaHR0cDovL3d3dy5kaWV0YWR1a2FuYTI0LnBsIiwiX2F1dGhfdXNlcl9oYXNoIjoiZjgwMmI1MzlkNzhhYzczNGIwZDMxMzEyOTBmODU1NmE3YzE0ODNjMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCJ9	2017-09-29 00:55:40.5813+02
skchtwfctd7q9pg8z4nea2qnf1etubd2	N2IxMDJkMDg3YzEwNzk4ZDJiNzkxZjg4Y2JiY2Y1NWJlMzc3ODU0ZDp7Il9hdXRoX3VzZXJfaGFzaCI6ImUyNzMzNTNhNWNhNTBlZGYxMjNiODYyMjNkM2FiMDE1MTZhYmFkZDUiLCJfYXV0aF91c2VyX2lkIjoiNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuQWxsb3dBbGxVc2Vyc01vZGVsQmFja2VuZCIsInVybCI6Imh0dHA6Ly93cC5wbCJ9	2017-11-22 11:06:11.415628+01
9g1wlesbu9oigt0hmdtd7e10jqs05yj7	MzhhOGE4NDZmNzI4ZGExMTY4NmJhNTIxOWMxNzRkOGVkYjI3ZjhhMjp7Il9hdXRoX3VzZXJfaGFzaCI6ImUyNzMzNTNhNWNhNTBlZGYxMjNiODYyMjNkM2FiMDE1MTZhYmFkZDUiLCJ1cmwiOiJodHRwOi8vd3AucGwiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLkFsbG93QWxsVXNlcnNNb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2lkIjoiNyJ9	2017-11-09 22:14:19.416659+01
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Data for Name: mainapp_category; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY mainapp_category (id, category_name, slug, image, category_description, category_keywords) FROM stdin;
3	Internet i komputery	internet-i-komputery		Opis kategorii	
\.


--
-- Name: mainapp_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('mainapp_category_id_seq', 4, true);


--
-- Data for Name: mainapp_group; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY mainapp_group (id, group_name, codes, pay, "time", days, premium_box, category, text, is_active, secret_codes) FROM stdin;
1	Podstawowy		FREE	N	100	N	1	<ul>\r\n\t<li>Wpis bezpłatny</li>\r\n\t<li>Wpis bezterminowy</li>\r\n\t<li>Wpis możesz dodać&nbsp;do 1 kategorii</li>\r\n</ul>	t	\N
2	Premium	KOD	PAID	T	30	T	2	<ul>\r\n\t<li><span style="color:#e74c3c">Możesz dodać wpis do 2 kategorii</span></li>\r\n\t<li>Wpis najwyżej na stronie gł&oacute;wnej</li>\r\n\t<li>Wpis w okienku reklamowym</li>\r\n\t<li><strong>Powyższe wyr&oacute;żnienia obowiązują przez 30 dni od aktywowania strony w serwisie</strong></li>\r\n</ul>	t	TAJNY
\.


--
-- Name: mainapp_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('mainapp_group_id_seq', 2, true);


--
-- Data for Name: mainapp_site; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY mainapp_site (id, name, slug, description, keywords, date, date_end, url, is_active, flagged, flagged_true, email, "user", kod, category_id, category1_id, group_id, subcategory_id, subcategory1_id, aftermarket_check, evil_words_check, little_chars_check) FROM stdin;
1	Forum PiO	forum-pio	<p>Najpopularniejsze w Polsce forum internetowe poświęcone tematyce pozycjonowania i optymalizacji stron internetowych. Jest to prawdziwa skarbnica wiedzy dla os&oacute;b rozpoczynających swoją przygodę z tą dziedziną.</p>	forum pio, pio, optymalizacja, pozycjonowanie	2017-11-07 23:16:18.089372+01	\N	https://www.forum.optymalizacja.com	t		f	admin@admin.pl	testowy1	TAJNY	3	\N	1	9	\N	t	t	t
2	NETKAT - skrypt katalogu stron	netkat-skrypt-katalogu-stron	<p>NETKAT to nowoczesny skrypt katalogu stron internetowych napisany w technologii Python/Django. Jest to pierwszy tego typu projekt napisany w tym języku programowania i dzięki temu wyr&oacute;żnia się na tle konkurencji. Jedną z kluczowych funkcji katalogu jest możliwość cyklicznego sprawdzania poprawności wczytywania stron internetowych dodanych do bazy katalogu. Na stronie znajdziesz szczeg&oacute;łowy opis skryptu i jego funkcjonalności. Zapoznasz się r&oacute;wnież z cennikiem licencji.&nbsp;</p>	netkat, katalog stron, skrypt katalogu stron	2017-11-09 09:54:28.360824+01	\N	https://www.netkat.pl	t		f	admin@admin.pl	admin		3	\N	1	12	\N	t	t	t
\.


--
-- Name: mainapp_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('mainapp_site_id_seq', 2, true);


--
-- Data for Name: mainapp_subcategory; Type: TABLE DATA; Schema: public; Owner: jundymek
--

COPY mainapp_subcategory (id, subcategory_name, slug, category_id) FROM stdin;
6	Komputery	komputery	3
8	Portale internetowe	portale-internetowe	3
9	Fora internetowe	fora-internetowe	3
7	Blogi	blogi	3
11	Usługi komputerowe	usugi-komputerowe	3
12	Katalogi stron	katalogi-stron	3
\.


--
-- Name: mainapp_subcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jundymek
--

SELECT pg_catalog.setval('mainapp_subcategory_id_seq', 12, true);


--
-- Name: admin_interface_theme admin_interface_theme_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY admin_interface_theme
    ADD CONSTRAINT admin_interface_theme_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: constance_config constance_config_key_key; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY constance_config
    ADD CONSTRAINT constance_config_key_key UNIQUE (key);


--
-- Name: constance_config constance_config_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY constance_config
    ADD CONSTRAINT constance_config_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: mainapp_category mainapp_category_category_name_key; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_category
    ADD CONSTRAINT mainapp_category_category_name_key UNIQUE (category_name);


--
-- Name: mainapp_category mainapp_category_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_category
    ADD CONSTRAINT mainapp_category_pkey PRIMARY KEY (id);


--
-- Name: mainapp_group mainapp_group_group_name_key; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_group
    ADD CONSTRAINT mainapp_group_group_name_key UNIQUE (group_name);


--
-- Name: mainapp_group mainapp_group_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_group
    ADD CONSTRAINT mainapp_group_pkey PRIMARY KEY (id);


--
-- Name: mainapp_site mainapp_site_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_pkey PRIMARY KEY (id);


--
-- Name: mainapp_subcategory mainapp_subcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_subcategory
    ADD CONSTRAINT mainapp_subcategory_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_group_name_a6ea08ec_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX auth_user_username_6821ab7c_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: constance_config_key_baef3136_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX constance_config_key_baef3136_like ON constance_config USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX django_session_session_key_c0390e0f_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX django_site_domain_a2e37b91_like ON django_site USING btree (domain varchar_pattern_ops);


--
-- Name: mainapp_category_2dbcba41; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_category_2dbcba41 ON mainapp_category USING btree (slug);


--
-- Name: mainapp_category_category_name_62f389b4_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_category_category_name_62f389b4_like ON mainapp_category USING btree (category_name varchar_pattern_ops);


--
-- Name: mainapp_category_slug_27883014_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_category_slug_27883014_like ON mainapp_category USING btree (slug varchar_pattern_ops);


--
-- Name: mainapp_group_group_name_874e4444_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_group_group_name_874e4444_like ON mainapp_group USING btree (group_name varchar_pattern_ops);


--
-- Name: mainapp_site_0e939a4f; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_0e939a4f ON mainapp_site USING btree (group_id);


--
-- Name: mainapp_site_2dbcba41; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_2dbcba41 ON mainapp_site USING btree (slug);


--
-- Name: mainapp_site_673b3e3d; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_673b3e3d ON mainapp_site USING btree (subcategory1_id);


--
-- Name: mainapp_site_79f70305; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_79f70305 ON mainapp_site USING btree (subcategory_id);


--
-- Name: mainapp_site_b583a629; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_b583a629 ON mainapp_site USING btree (category_id);


--
-- Name: mainapp_site_cb794678; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_cb794678 ON mainapp_site USING btree (category1_id);


--
-- Name: mainapp_site_slug_e022d5d8_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_site_slug_e022d5d8_like ON mainapp_site USING btree (slug varchar_pattern_ops);


--
-- Name: mainapp_subcategory_2dbcba41; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_subcategory_2dbcba41 ON mainapp_subcategory USING btree (slug);


--
-- Name: mainapp_subcategory_b583a629; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_subcategory_b583a629 ON mainapp_subcategory USING btree (category_id);


--
-- Name: mainapp_subcategory_slug_66fb7504_like; Type: INDEX; Schema: public; Owner: jundymek
--

CREATE INDEX mainapp_subcategory_slug_66fb7504_like ON mainapp_subcategory USING btree (slug varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permiss_permission_id_84c5c92e_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permiss_permission_id_84c5c92e_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permiss_content_type_id_2f476e4b_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permiss_content_type_id_2f476e4b_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_per_permission_id_1fbb5f2c_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_per_permission_id_1fbb5f2c_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_content_type_id_c4bce8eb_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_content_type_id_c4bce8eb_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_site mainapp_site_category1_id_a740baad_fk_mainapp_category_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_category1_id_a740baad_fk_mainapp_category_id FOREIGN KEY (category1_id) REFERENCES mainapp_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_site mainapp_site_category_id_3a5af5b7_fk_mainapp_category_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_category_id_3a5af5b7_fk_mainapp_category_id FOREIGN KEY (category_id) REFERENCES mainapp_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_site mainapp_site_group_id_d6d048fc_fk_mainapp_group_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_group_id_d6d048fc_fk_mainapp_group_id FOREIGN KEY (group_id) REFERENCES mainapp_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_site mainapp_site_subcategory1_id_f8882c8b_fk_mainapp_subcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_subcategory1_id_f8882c8b_fk_mainapp_subcategory_id FOREIGN KEY (subcategory1_id) REFERENCES mainapp_subcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_site mainapp_site_subcategory_id_948a832a_fk_mainapp_subcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_site
    ADD CONSTRAINT mainapp_site_subcategory_id_948a832a_fk_mainapp_subcategory_id FOREIGN KEY (subcategory_id) REFERENCES mainapp_subcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mainapp_subcategory mainapp_subcategory_category_id_dae2db3b_fk_mainapp_category_id; Type: FK CONSTRAINT; Schema: public; Owner: jundymek
--

ALTER TABLE ONLY mainapp_subcategory
    ADD CONSTRAINT mainapp_subcategory_category_id_dae2db3b_fk_mainapp_category_id FOREIGN KEY (category_id) REFERENCES mainapp_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

