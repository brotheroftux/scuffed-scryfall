-- все карты из Ханов Таркира, отсортированные по конвертированной мана-стоимости

select c.name, c.rarity, c.oracle, c.mana, c.type, s.code from public.cards c 
join public.sets_cards_relation r on (c.id = r.card_id) 
join public.sets s on (r.set_id = s.id)
where lower(s.code) = 'ktk'
order by public.calculate_cmc(c.mana) asc nulls first;

-- все сеты с сеттингом в мире Равники, выпущенные между 2010-01-01 и 2016-01-01

select s.name, s.code, s.release_date, s.size from public.sets s
join public.planes p on (s.plane = p.id)
where s.release_date between '2010-01-01'::date and '2016-01-01'::date and p.name = 'Ravnica'
order by release_date asc;

-- все артефакты с иллюстрациями от Volkan Baga

select c.name, c.rarity, c.oracle, c.mana, c.type, a.name as artist_name
from public.cards c
join public.artists a on (c.artist = a.id)
where a.name = 'Volkan Baga'
and c.type @> array['Artifact'];
