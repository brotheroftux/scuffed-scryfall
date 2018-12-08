with recent_legal_sets as (select s.id, s.code, s.name, s.release_date, s.size, s.plane from sets s
  join sets_formats_relation rf on (rf.set_id = s.id)
  join formats f on (rf.format_id = f.id)
  where s.release_date between '2010-01-01' and '2018-12-01'
  and f.name = 'Modern'),
print_count as (select rs.card_id, count(rs.card_id) as times_printed from sets_cards_relation rs
  group by rs.card_id),
set_reprint_count as (select rls.id, count(rls.id) as reprint_count from recent_legal_sets rls
  join sets_cards_relation rs on (rs.set_id = rls.id)
  join print_count pc on (rs.card_id = pc.card_id
    and exists (select 1 from sets_cards_relation rs where rs.card_id = pc.card_id and rs.set_id = rls.id))
  where pc.times_printed > 1
  group by rls.id)
select rls.code, rls.name, rls.release_date, src.reprint_count, p.name as plane from recent_legal_sets rls
join planes p on (rls.plane = p.id)
join set_reprint_count src on (rls.id = src.id)
order by src.reprint_count desc;

with set_id as (select s.id as set_id from sets s where lower(s.code) = lower('dom')),
set_cards as (select rs.card_id as id, sid.set_id from sets_cards_relation rs
  join set_id sid on (rs.set_id = sid.set_id)),
total_print_count as (select rs.card_id, count(rs.card_id) as print_count from sets_cards_relation rs
  where rs.card_id in (select id from set_cards)
  group by rs.card_id)
select c.name, c.mana, c.type, c.oracle, c.rarity, tpc.print_count as total_prints from cards c
join set_cards sc on (c.id = sc.id
  and exists (select 1 from sets_cards_relation rs where rs.card_id = sc.id 
    and rs.set_id <> sc.set_id))
join total_print_count tpc on (c.id = tpc.card_id)

with phat_relation as (select f.name as format_name, c.name from cards c
  join sets_cards_relation csr on (c.id = csr.card_id)
  join sets_formats_relation fsr on (csr.set_id = fsr.set_id)
  join formats f on (fsr.format_id = f.id)
  where calculate_cmc(c.mana) > 7),
formats_with_sets_amount as (select f.name, fr.format_id, count(f.name) as set_count from sets_formats_relation fr
  join formats f on (fr.format_id = f.id)
  group by f.name, fr.format_id having count(f.name) > 650),
print_count as (select pr.name, count(pr.name) as print_count from phat_relation pr group by pr.name), 
distinct_formats as (select distinct pr.name, pr.format_name, pc.print_count from phat_relation pr
join print_count pc on (pr.name = pc.name))
select df.name, count(df.name), array_agg(df.format_name) from distinct_formats df
group by df.name order by count(df.name) desc;
