# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

В: Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её нужно прервать.

О: Список операций, которые необходимо производить для остановки запроса пользователя в MongoDB:

- находим запросы которые выполняются более 170 сек.

```
db.aggregate( [
   { $currentOp : { allUsers: true, idleSessions: true } },
   { $match : { active: true, secs_running : { $gt: 170 } } }])
```
- копируем идентификатор процесса opid.

- завершаем запрос

```
db.killOp("shard01:1355440")
```


В: Вариант решения проблемы с долгими (зависающими) запросами в MongoDB?

О: Стоит рассмотреть слудующие варианты:

- Изменить настройки пула соединений, а именно задать таймаут на открытое соединение.

- Научить разработчика ограничивать время выполнения запроса (метод maxTimeMS)

- Вертикальное либо горизонтальное мастабирование кластера


## Задача 2

В: При масштабировании сервиса до N реплик вы увидели, что:

- сначала рост отношения записанных значений к истекшим

- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

О: Предположу, что это связано с алгоритмом блокировки [Redlock](https://redis.io/docs/reference/patterns/distributed-locks/). 

"
Liveness Arguments
The system liveness is based on three main features:

The auto release of the lock (since keys expire): eventually keys are available again to be locked.
The fact that clients, usually, will cooperate removing the locks when the lock was not acquired, or when the lock was acquired and the work terminated, making it likely that we don’t have to wait for keys to expire to re-acquire the lock.
The fact that when a client needs to retry a lock, it waits a time which is comparably greater than the time needed to acquire the majority of locks, in order to probabilistically make split brain conditions during resource contention unlikely.
However, we pay an availability penalty equal to TTL time on network partitions, so if there are continuous partitions, we can pay this penalty indefinitely. This happens every time a client acquires a lock and gets partitioned away before being able to remove the lock.

Basically if there are infinite continuous network partitions, the system may become not available for an infinite amount of time
"


## Задача 3

В: Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы, пользователи начали жаловаться на ошибки вида:

```bash
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```
Как вы думаете, почему это начало происходить и как локализовать проблему?

О: Скорей всего поблема связана с таймаутами. Пользователь отправил запрос на выборку большого количества данных, ответ на который не уложился в преднастроенное время.

Для анализа запросов включаем slow_log. Запросы, которые попали в лог изучаем с помощью EXPLAIN.


В: Какие пути решения данной проблемы вы можете предложить?

О: Необходимо проработать следующие варианты: 
- Проидексировать таблицу;
- Порекомендовать разработчику оптимизировать запрос;
- Шардировать таблицу;
- Увеличить параментр net_read_timeout;
- Замена сервера СУБД на PostgreSQL.


## Задача 4

В: Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с большим объемом данных лучше, чем MySQL.
После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

```bash
postmaster invoked oom-killer
```
Как вы думаете, что происходит?

О: Нехватка оперативной памяти на сервере СУБД.

В: Как бы вы решили данную проблему?

О: Необходимо проработать следующие варианты: 
- Ограничить используемую память PostgreSQL (меняем конфигурацию);
- Увеличить объем оперативной памяти на сервере;
- Добавить еще один сервер PostgeSql (Master-slave репликация), чтобы синизть нагрузку на оснавной сервер. Перенаправить запросы на выборку данных на сервер slave.
