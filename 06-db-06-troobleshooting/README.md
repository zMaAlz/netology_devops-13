# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Список операций, которые необходимо производить для остановки запроса пользователя:

-находим запросы которые выполняются более 170 сек.

db.aggregate( [
   { $currentOp : { allUsers: true, idleSessions: true } },
   { $match : { active: true, secs_running : { $gt: 170 } } }])

-копируем идентификатор процесса opid.

-завершаем запрос

db.killOp("shard01:1355440")


Вариант решения проблемы с долгими (зависающими) запросами в MongoDB:

Стоит рассмотреть слудующие варианты:

-Изменить настройки пула соединений, а именно задать таймаут на открытое соединение.

-Научить разработчика ограничивать время выполнения запроса (метод maxTimeMS)

-Вертикальное либо горизонтальное мастабирование кластера

## Задача 2

При масштабировании сервиса до N реплик вы увидели, что:

- сначала рост отношения записанных значений к истекшим

- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

Предположу, что это связано с алгоритмом блокировки [Redlock](https://redis.io/docs/reference/patterns/distributed-locks/). 

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

Как вы думаете, почему это начало происходить и как локализовать проблему?

Скорей всего поблема связана с таймаутами на чтение. Пользователь отправил запрос на выборку большого количества данных, ответ на который не уложился в преднастроенное время.

Для анализа запросов включаем slow_log. Запросы, которые попали в лог изучаем с помощью EXPLAIN.

Какие пути решения данной проблемы вы можете предложить?

-Проидексировать таблицу;
-Порекомендовать оптимизировать запрос;
-Шардировать таблицу;
-Увеличить параментр net_read_timeout;
-Замена сервера СУБД на PostgreSQL.

## Задача 4

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

postmaster invoked oom-killer

Как вы думаете, что происходит?

Нехватка оперативной памяти на сервере СУБД.

Как бы вы решили данную проблему?

-ограничить используемую память сервером PostgreSQL;
-Увеличить объем оперативной памяти на сервере.
