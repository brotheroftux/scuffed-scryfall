--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS "d.kuznetsov";
--
-- Name: d.kuznetsov; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "d.kuznetsov" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf-8' LC_CTYPE = 'en_US.utf-8';


ALTER DATABASE "d.kuznetsov" OWNER TO postgres;

\connect "d.kuznetsov"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
create extension if not exists pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;
--
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id integer NOT NULL,
    name character varying(70) NOT NULL CONSTRAINT artist_name_not_empty CHECK (name <> '')
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.artists_id_seq OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id integer NOT NULL,
    name character varying(50) NOT NULL CONSTRAINT card_name_not_empty CHECK (name <> ''),
    rarity character varying(15) NOT NULL CONSTRAINT card_rarity_not_empty CHECK (rarity <> ''),
    oracle text NOT NULL CONSTRAINT card_oracle_not_empty CHECK (oracle <> ''),
    mana character varying(10) CONSTRAINT card_manacost_is_valid CHECK (mana ~ '^(?:0|(?:[1-9]|X+)*[WUBRG]*)$'),
    type text array NOT NULL CONSTRAINT card_typeline_not_empty CHECK (array_length(type, 1) > 0 ),
    artist integer
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cards_id_seq OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: formats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formats (
    id integer NOT NULL,
    name character varying(50) NOT NULL CONSTRAINT format_name_not_empty CHECK (name <> '')
);


ALTER TABLE public.formats OWNER TO postgres;

--
-- Name: formats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formats_id_seq OWNER TO postgres;

--
-- Name: formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formats_id_seq OWNED BY public.formats.id;


--
-- Name: planes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planes (
    id integer NOT NULL,
    name character varying(70) NOT NULL CONSTRAINT plane_name_not_empty CHECK (name <> '')
);


ALTER TABLE public.planes OWNER TO postgres;

--
-- Name: planes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planes_id_seq OWNER TO postgres;

--
-- Name: planes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planes_id_seq OWNED BY public.planes.id;


--
-- Name: sets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sets (
    id integer NOT NULL,
    name character varying(50) NOT NULL CONSTRAINT set_name_not_empty CHECK (name <> ''),
    release_date date NOT NULL CONSTRAINT set_released_after_lea CHECK (release_date >= '1993-08-05'::date),
    size integer NOT NULL CONSTRAINT set_size_is_positive CHECK (size > 0),
    code character varying(3) NOT NULL CONSTRAINT set_code_exact_length CHECK (char_length(code) = 3),
    plane integer
);


ALTER TABLE public.sets OWNER TO postgres;

--
-- Name: sets_cards_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sets_cards_relation (
    set_id integer NOT NULL,
    card_id integer NOT NULL
);


ALTER TABLE public.sets_cards_relation OWNER TO postgres;

--
-- Name: sets_formats_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sets_formats_relation (
    set_id integer NOT NULL,
    format_id integer NOT NULL
);


ALTER TABLE public.sets_formats_relation OWNER TO postgres;

--
-- Name: sets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sets_id_seq OWNER TO postgres;

--
-- Name: sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sets_id_seq OWNED BY public.sets.id;


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: formats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formats ALTER COLUMN id SET DEFAULT nextval('public.formats_id_seq'::regclass);


--
-- Name: planes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes ALTER COLUMN id SET DEFAULT nextval('public.planes_id_seq'::regclass);


--
-- Name: sets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets ALTER COLUMN id SET DEFAULT nextval('public.sets_id_seq'::regclass);


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, name) FROM stdin;
1	Christopher Rush
2	Carl Critchlow
3	Jonas De Ro
4	Rob Alexander
5	Volkan Baga
6	Chase Stone
7	Franz Vohwinkel
8	Chris Rahn
9	Noah Bradley
10	Todd Lockwood
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, name, rarity, oracle, mana, type, artist) FROM stdin;
1	Black Lotus	rare	{T}, Sacrifice Black Lotus: Add three mana of any one color.	0	{Artifact}	1
2	Brainstorm	common	Draw three cards, then put two cards from your hand on top of your library in any order.	U	{Instant}	1
3	Siege Wurm	common	Convoke, trample	5GG	{Creature,Wurm}	2
4	Wooded Foothills	rare	{T}, Pay 1 life, Sacrifice Wooded Foothills: Search your library for a Mountain or Forest card and put it onto the battlefield. Then shuffle your library.	\N	{Land}	3
5	Watery Grave	rare	As Watery Grave enters the battlefield, you may pay 2 life. If you don't, Watery Grave enters the battlefield tapped.	\N	{Land,Island,Swamp}	4
6	Mox Opal	mythic rare	Metalcraft - {T}: Add one mana of any color. Activate this ability only if you control three or more artifacts.	0	{Legendary,Artifact}	5
7	Angel of Invention	mythic rare	Flying, vigilance, lifelink\\nFabricate 2\\nOther creatures you control get +1/+1.	3WW	{Creature,Angel}	5
8	Hazoret the Fervent	mythic rare	Indestructible, haste\\nHazoret the Fervent can't attack or block unless you have one or fewer cards in hand.\\n{2}{R}, Discard a card: Hazoret deals 2 damage to each opponent.	3R	{Legendary,Creature,God}	6
9	Bane of Bala Ged	uncommon	Whenever Bane of Bala Ged attacks, defending player exiles two permanents they control.	7	{Creature,Eldrazi}	6
10	Collected Company	rare	Look at the top six cards of your library. Put up to two creature cards with converted mana cost 3 or less from among them onto the battlefield. Put the rest on the bottom of your library in any order.	3G	{Instant}	7
11	Lyra Dawnbringer	mythic rare	Flying, first strike, lifelink\\nOther Angels you control get +1/+1 and have lifelink.	3WW	{Legendary,Creature,Angel}	8
12	Anger the Gods	rare	Anger of the Gods deals 3 damage to each creature. If a creature dealt damage this way would die this turn, exile it instead.	1RR	{Sorcery}	9
13	Behold the Beyond	mythic rare	Discard your hand. Search your library for three cards and put those cards into your hand. Then shuffle your library.	5BB	{Sorcery}	9
14	Azusa, Lost but Seeking	rare	You may play two additional lands on each of your turns.	2G	{Legendary,Creature,Human,Monk}	10
15	Joraga Bard	common	Whenever Joraga Bard or another Ally enters the battlefield under your control, you may have Ally creatures you control gain vigilance until end of turn.	3G	{Creature,Elf,Rogue,Ally}	5
\.


--
-- Data for Name: formats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formats (id, name) FROM stdin;
1	Standard
2	Modern
3	Vintage
4	Legacy
5	Pauper
6	EDH
\.


--
-- Data for Name: planes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.planes (id, name) FROM stdin;
1	Ravnica
2	Mirrodin
3	Zendikar
4	Amonkhet
5	Dominaria
6	Kaladesh
7	Tarkir
8	Kamigawa
9	Innistrad
10	Theros
\.


--
-- Data for Name: sets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sets (id, name, release_date, size, code, plane) FROM stdin;
1	Guilds of Ravnica	2018-10-05	273	GRN	1
2	Limited Edition Alpha	1993-08-05	295	LEA	5
3	Ice Age	1995-06-01	383	ICE	5
4	Scars of Mirrodin	2010-10-01	249	SOM	2
5	Dominaria	2018-04-27	280	DOM	5
6	Champions of Kamigawa	2004-10-01	307	CHK	8
7	Shadows over Innistrad	2016-04-08	297	SOI	9
8	Amonkhet	2017-04-28	287	AKH	4
9	Kaladesh	2016-09-30	274	KLD	6
10	Dragons of Tarkir	2015-03-27	264	DTK	7
11	Battle for Zendikar	2015-10-02	299	BFZ	3
12	Theros	2013-09-27	249	THS	10
13	Zendikar	2009-10-02	269	ZEN	3
14	Ravnica: City of Guilds	2005-10-07	306	RAV	1
15	Khans of Tarkir	2014-09-26	269	KTK	7
\.


--
-- Data for Name: sets_cards_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sets_cards_relation (set_id, card_id) FROM stdin;
1	2
2	3
3	1
3	14
4	6
5	1
5	14
6	4
7	9
8	8
9	11
10	10
11	5
12	12
13	7
14	6
15	13
\.


--
-- Data for Name: sets_formats_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sets_formats_relation (set_id, format_id) FROM stdin;
1	1
2	3
2	4
2	5
2	6
3	3
3	4
3	5
3	6
4	2
4	3
4	4
4	5
4	6
5	1
5	2
5	3
5	4
5	5
5	6
6	2
6	3
6	4
6	5
6	6
\.


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artists_id_seq', 10, true);


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_id_seq', 15, true);


--
-- Name: formats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formats_id_seq', 6, true);


--
-- Name: planes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planes_id_seq', 10, true);


--
-- Name: sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sets_id_seq', 16, true);


--
-- Name: artists artists_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_name_key UNIQUE (name);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: cards cards_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_name_key UNIQUE (name);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);




--
-- Name: formats formats_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formats
    ADD CONSTRAINT formats_name_key UNIQUE (name);


--
-- Name: formats formats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);


--
-- Name: planes planes_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes
    ADD CONSTRAINT planes_name_key UNIQUE (name);


--
-- Name: planes planes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes
    ADD CONSTRAINT planes_pkey PRIMARY KEY (id);


--
-- Name: sets_cards_relation sets_cards_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets_cards_relation
    ADD CONSTRAINT sets_cards_relation_pkey PRIMARY KEY (set_id, card_id);


--
-- Name: sets sets_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_code_key UNIQUE (code);


--
-- Name: sets_formats_relation sets_formats_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets_formats_relation
    ADD CONSTRAINT sets_formats_relation_pkey PRIMARY KEY (set_id, format_id);


--
-- Name: sets sets_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_name_key UNIQUE (name);


--
-- Name: sets sets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD FOREIGN KEY (artist) REFERENCES public.artists (id);

ALTER TABLE ONLY public.sets
    ADD FOREIGN KEY (plane) REFERENCES public.planes (id);

ALTER TABLE ONLY public.sets_cards_relation
    ADD FOREIGN KEY (set_id) REFERENCES public.sets (id);

ALTER TABLE ONLY public.sets_cards_relation
    ADD FOREIGN KEY (card_id) REFERENCES public.cards (id);

ALTER TABLE ONLY public.sets_formats_relation
    ADD FOREIGN KEY (set_id) REFERENCES public.sets (id);

ALTER TABLE ONLY public.sets_formats_relation
    ADD FOREIGN KEY (format_id) REFERENCES public.formats (id);


GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

-- functional stub

create or replace function public.random_text (integer) returns text as $$
select array_to_string(array(
  select substring('abcdefghjkmnpqrstuvwxyz' 
    from floor(random()*21)::int+1 for 1)
  from generate_series(1, $1)), '');
$$ language sql;

create or replace function public.calculate_cmc (varchar) returns integer as $$
  select length(substring($1 from '[WUBRG]*$')) + cast(
    coalesce(nullif(substring($1 from '[0-9]*'), ''), '0') as integer
  ) as result;
$$ language sql;

create or replace function public.generate_random_manacost () returns varchar as $$
  select (('{' || ceil(random() * 9)::int::varchar || ',X}')::text[])[ceil(random() * 2)]
    || repeat('W', random()::int)
    || repeat('U', random()::int)
    || repeat('B', random()::int)
    || repeat('R', random()::int)
    || repeat('G', random()::int);
$$ language sql;

create or replace function public.generate_random_card_name () returns varchar as $$
  select (('{' ||
    (
      ('{Bane,Tribute,Terror,Pride,Wrath,Flame,Solace}'::text[])[ceil(random() * 7)] || ' '
        || ('{of,for}'::text[])[ceil(random() * 2)] || ' '
        || ('{Conquerors,Eldrazi,Dead,Keld,Heavens,God,Living}'::text[])[ceil(random() * 2)]
    ) || ',' ||
    (
      ('{Selesnya,Izzet,Dimir,Golgari,Boros,Orzhov,Azorius,Simic,Rakdos,Gruul}'::text[])[ceil(random() * 10)] || ' '
        || ('{Chancellor,Guildmage,Advokist,Informant,Forerunner,Patrol}'::text[])[ceil(random() * 6)]
    ) || '}')::text[])[ceil(random() * 2)];
$$ language sql;

create or replace function public.generate_random_card_text () returns varchar as $$
  select (('{' ||
    (
      ('{Exile,Destroy}'::text[])[ceil(random() * 2)] || ' target '
      || ('{creature,artifact,enchantment,land,planeswalker}'::text[])[ceil(random() * 5)] || '.'
    ) || ',' ||
    (
      (('{' || public.generate_random_manacost() || ',T}')::text[])[ceil(random() * 2)] || ': target '
      || ('{creature,artifact,enchantment,land,planeswalker}'::text[])[ceil(random() * 5)] || ' gains '
      || ('{indestructible,vigilance,flying,islandwalk,banding,double strike,first strike,trample}'::text[])[ceil(random() * 8)]
      || ' until end of turn.'
    ) || ',' ||
    (
      ('{Metalcraft,Imprint,Will of the Council}'::text[])[ceil(random() * 2)]
      || ': add ' || (random() * 10)::int::varchar || ' mana of any color to your mana pool.'
    ) || '}')::text[])[ceil(random() * 3)];
$$ language sql;

create or replace function public.generate_random_typeline () returns text[] as $$
  select array[('{Legendary,Tribal,Arcane}'::text[])[ceil(random() * 3)],
    ('{Creature,Artifact,Enchantment,Sorcery,Instant,Land,Planeswalker}'::text[])[ceil(random() * 7)],
    ('{Human,Vedalken,Viashino,Goblin,Eldrazi,Merfolk,Spirit,Moonfolk,Sliver,Horror,Angel,Demon}'::text[])[ceil(random() * 12)],
    ('{Monk,Wizard,Pirate,Soldier,Knight,Cleric,Druid}'::text[])[ceil(random() * 7)]];
$$ language sql;

create or replace function public.make_unique_set_code () returns varchar as $$
declare
    new_code varchar;
    done bool;
begin
    done := false;
    while not done loop
        new_code := public.random_text(3);
        done := not exists(select 1 from public.sets where code = new_code);
    end loop;
    return new_code;
end;
$$ language plpgsql;

create or replace function public.make_unique_set_card_relation () returns integer array as $$
declare
    new_setid integer;
    new_cardid integer;
    done bool;
begin
    done := false;
    while not done loop
        new_setid = ceil(random() * 2000); 
        new_cardid = ceil(random() * 10000);
        done := not exists(select 1 from public.sets_cards_relation where set_id = new_setid and card_id = new_cardid);
    end loop;
    return array[new_setid, new_cardid];
end;
$$ language plpgsql;

create or replace function public.make_unique_set_format_relation () returns integer array as $$
declare
    new_setid integer;
    new_formatid integer;
    done bool;
begin
    done := false;
    while not done loop
        new_setid = ceil(random() * 2000); 
        new_formatid = ceil(random() * 6);
        done := not exists(select 1 from public.sets_formats_relation where set_id = new_setid and format_id = new_formatid);
    end loop;
    return array[new_setid, new_formatid];
end;
$$ language plpgsql;

drop index if exists sets_release_date_index;
create index sets_release_date_index on public.sets (release_date asc);

drop index if exists card_name_index;
create index cards_name_index on public.cards using gin (name public.gin_trgm_ops);

drop index if exists cards_cmc_asc_index;
create index cards_cmc_asc_index on public.cards (public.calculate_cmc(mana) asc nulls first);
drop index if exists cards_typeline_index;
create index cards_typeline_index on public.cards using gin (type);

drop index if exists set_code_index;
create index set_code_index on public.sets (lower(code));

insert into public.cards (
  select
    -- id
    generate_series(16, 10000),
    -- name (+ salt for uniqueness)
    public.generate_random_card_name() || ' ' || public.random_text(17)::varchar,
    -- rarity
    ('{common,uncommon,rare,mythic rare}'::text[])[ceil(random()*4)],
    -- oracle text
    public.generate_random_card_text(),
    -- mana cost
    public.generate_random_manacost(),
    -- type
    public.generate_random_typeline(),
    -- artist
    ceil(random() * 10)::int
);

insert into public.sets (
  select
    -- id
    generate_series(16, 2000),
    -- name
    public.random_text(17)::varchar,
    -- release_date
    (timestamp '1993-08-05 00:00:00' + 
      random() * (timestamp '2018-12-01 00:00:00' - timestamp '1993-08-05 00:00:00'))::date,
    -- size
    250 + (random () * 50)::int,
    -- code
    public.make_unique_set_code(),
    -- plane
    ceil(random() * 10)::int
);

insert into public.sets_cards_relation(
	select arr[1], arr[2] from (select public.make_unique_set_card_relation () arr from generate_series(18, 20000)) as sq
);

insert into public.sets_formats_relation(
	select arr[1], arr[2] from (select public.make_unique_set_format_relation () arr from generate_series(26, 4000)) as sq
);