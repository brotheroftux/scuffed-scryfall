-- список из пяти сетов, начиная с самого старого
select * from public.sets s order by s.release_date limit 5;

-- список всех карт, название которых содержит подстроку Azusa
select * from public.cards c where c.name like '%Azusa%';

-- распределение карт, имеющих супертип Legendary, по редкости
select c.rarity, count(*) from public.cards c where c.type @> array['Legendary'] group by c.rarity;

-- все карты, имеющие тип Creature и суммарную конвертированную мана-стоимость больше трёх
select * from public.cards c where public.calculate_cmc(c.mana) > 3 and c.type @> array['Creature'];