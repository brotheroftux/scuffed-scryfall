# Лёгкие запросы

1. Выборка всех строк из таблицы `cards`, у которых имя содержит
   заданный параметр. Обратите внимание, что мы используем
   сравнение на partial match через оператор `like`, потому что
   на фронтенде приложения для обращения к базе данных пользователь
   скорее всего будет искать карту только по части её названия,
   например, Azusa вместо Azusa, Lost but Seeking, просто Bolt
   вместо Lightning Bolt, Cryptic вместо Cryptic Command и так
   далее.

   Необходимость: поиск карты по частичному совпадению имени.

   Код запроса:

   ```sql
   select * from public.cards c where c.name like '%__NAME__%';
   ```

   Допустимый параметр: `__NAME__`:
   - `'Azusa'`
   - `'Bolt'`
   - `'Path to Exile'`

   Оптимизация:

   ```sql
   create index cards_name_index on public.cards using gin (name public.gin_trgm_ops);
   ```

2. Выборка типов редкости и количества карт, сгрупированных по типу
   редкости, имеющих тип `__TYPE__`.

   Необходимость: статистическое распределение карт по их типам.

   Код запроса:

   ```sql
   select c.rarity, count(*) from public.cards c where c.type @> array['__TYPE__'] group by c.rarity;
   ```

   Допустимый параметр: `__TYPE__`, тип, который должен входить
   в строку типов карты:
   - `'Legendary'`
   - `'Monk'`
   - `'Eldrazi'`
   - `'Angel'`

   Оптимизация:

   ```sql
   create index cards_typeline_index on public.cards using gin (type);
   ```

3. Выборка всех строк карт, имеющих тип `__TYPE__ ` и
   конвертированную мана-стоимость больше `__CMC__`.

   Необходимость: поиск карт, имеющих заданный тип и с наложенными
   на конвертированную мана-стоимость ограничениями.

   Код запроса:

   ```sql
   select * from public.cards c where public.calculate_cmc(c.mana) > __CMC__ and c.type @> array['__TYPE__'];
   ```

   Допустиые параметры:
   `__TYPE__`, тип, который должен входить в строку типов карты:
   - `'Creature'`
   - `'Demon'`
   - `'Horror'`
   - `'Wizard'`
  
   `__CMC__`, конвертированная мана-стоимость карты:
   - `3`
   - `5`

   Оптимизация:
   
   ```sql
   create index cards_typeline_index on public.cards using gin (type);
   ```

   Помимо этого, если убрать фильтр по типам из запроса, то
   планировщик будет использовать индекс по значению
   конвертированной мана-стоимости:

   ```sql
   create index cards_cmc_asc_index on public.cards (calculate_cmc(mana) asc nulls first);
   ```
4. Выборка 5 строк сетов, отсортированных по дате выхода по
   возрастанию.

   Необходимость: получение информации о первых сетах игры.

   Код запроса:

   ```sql
   select * from public.sets s order by s.release_date limit 5;
   ```

   Допустимые параметры: (нет)

   Оптимизация:

   ```sql
   create index sets_order_index on public.sets (release_date asc);
   ```