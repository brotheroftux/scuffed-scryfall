# Средние запросы

1. Выборка всех карт, которые присутствуют в сете с трёхсимвольным
   кодом `__CODE__`, отсортированных по конвертированной
   мана-стоимости.
   
   Необходимость: поиск карт из конкретного сета.

   Код запроса: 

   ```sql
   select c.name, c.rarity, c.oracle, c.mana, c.type, s.code from public.cards c 
   join public.sets_cards_relation r on (c.id = r.card_id) 
   join public.sets s on (r.set_id = s.id)
   where lower(s.code) = '__CODE__'
   order by public.calculate_cmc(c.mana) asc nulls first;
   ```

   Доступный параметр: `__CODE__` &mdash; трёхсимвольный код сета:
   - `'KTK'`
   - `'DTK'`
   - `'SOM'`
   - `'ISD'`

   Оптимизация была необходима по трёхсимвольному коду сета, чтобы
   последовательное сканирование в поисках доступного сета не
   занимало бы много времени.

   ```sql 
   create index set_code_index on public.sets (lower(code));
   ```
2. Выборка всех сетов, выпущенных с `__START_DATE__` по
   `__END_DATE__`, имеющих мир `__PLANE__` сеттингом,
   отсортированных по возрастанию даты выпуска.

   Необходимость: получение информации о сетах, события которых
   происходят в заданном мире, выпущенных в конкретное время, дабы,
   например, получить только новые сеты с этим миром.

   Код запроса:

   ```sql
   select s.name, s.code, s.release_date, s.size from public.sets s
   join public.planes p on (s.plane = p.id)
   where s.release_date between '__START_DATE__'::date and '__END_DATE__'::date and p.name = '__PLANE__'
   order by release_date asc;
   ```

   Доступные параметры:\
   `__START_DATE__` &mdash; дата начала промежутка времени, в
   котором происходит поиск сетов\
   `__END_DATE__` &mdash; дата конца промежутка времени, в котором
   происходит поиск сетов\
   `__PLANE__` &mdash; мир сеттинга сета
   - `'Ravnica'`
   - `'Innistrad'`
   - `'Mirrodin'`
  
   Оптимизация была необходима по дате выпуска для облегчения
   сортировки и поиска по промежутку дат.

   ```sql
   create index sets_release_date_index on public.sets (release_date asc);
   ```
3. Выборка всех карт, иллюстрация к которым была сделана художником
   `__ARTIST__` и имеющих тип `__TYPE__`.

   Необходимость: поиск карт конкретного типа, нарисованных одним
   художником, например, всех артефактов от Volkan Baga.

   Код запроса:

   ```sql
   select c.name, c.rarity, c.oracle, c.mana, c.type, a.name as artist_name
   from public.cards c
   join public.artists a on (c.artist = a.id)
   where a.name = '__ARTIST__'
   and c.type @> array['__TYPE__'];
   ```

   Доступные параметры:\
   `__ARTIST__` &mdash; художник
   - `'Volkan Baga'`
   - `'Chippy'`

   `__TYPE__` &mdash; тип, который должен быть на карте
   - `'Artifact'`
   - `'Merfolk'`
   - `'Legendary'`

   Оптимизация нужна по типу карты, чтобы упростить этот поиск.

   ```sql
   create index cards_typeline_index on public.cards using gin (type);
   ```