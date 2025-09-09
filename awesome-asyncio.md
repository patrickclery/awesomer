# awesome-asyncio

A curated list of awesome Python asyncio frameworks, libraries, software and resources

## Misc

| Name                                                                | Description                                                                                             | Stars | Last Commit |
|---------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [aiofiles](https://github.com/Tinche/aiofiles)                      | File support for asyncio.                                                                               | 3148  | 2025-08-01  |
| [ruia](https://github.com/howie6879/ruia)                           | An async web scraping micro-framework based on asyncio.                                                 | 1751  | 2023-07-01  |
| [asgiref](https://github.com/django/asgiref)                        | Backend utils for ASGI to WSGI integration, includes sync_to_async and async_to_sync function wrappers. | 1579  | 2025-07-08  |
| [aiorun](https://github.com/cjrh/aiorun)                            | A `run()` function that handles all the usual boilerplate for startup and graceful shutdown.            | 464   | 2025-01-27  |
| [aiomisc](https://github.com/aiokitchen/aiomisc)                    | Miscellaneous utils for `asyncio`.                                                                      | 410   | 2025-08-02  |
| [kubernetes_asyncio](https://github.com/tomplus/kubernetes_asyncio) | Asynchronous client library for Kubernetes.                                                             | 404   | 2025-09-05  |
| [aiozipkin](https://github.com/aio-libs/aiozipkin)                  | Distributed tracing instrumentation for asyncio with zipkin                                             | 191   | 2025-08-11  |
| [aiopath](https://github.com/alexdelorenzo/aiopath)                 | Asynchronous `pathlib` for asyncio.                                                                     | 184   | 2024-10-20  |
| [aiochan](https://github.com/zh217/aiochan)                         | CSP-style concurrency with channels, select and multiprocessing on top of asyncio.                      | 175   | 2022-11-29  |
| [async_property](https://github.com/ryananguiano/async_property)    | Python decorator for async properties.                                                                  | 96    | 2023-09-05  |
| [aiodebug](https://github.com/qntln/aiodebug)                       | A tiny library for monitoring and testing asyncio programs.                                             | 64    | 2022-01-04  |
| [aiosc](https://github.com/artfwo/aiosc)                            | Lightweight Open Sound Control implementation.                                                          | 38    | 2024-03-31  |
| [aiocache](https://github.com/argaen/aiocache)                      | Cache manager for different backends.                                                                   | 0     | N/A         |
| [aioserial](https://github.com/changyuheng/aioserial)               | A drop-in replacement of [pySerial](https://github.com/pyserial/pyserial).                              | 0     | N/A         |

## Web Frameworks

| Name                                                      | Description                                                                                                | Stars | Last Commit |
|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Quart](https://github.com/pallets/quart)                 | An asyncio web microframework with the same API as Flask.                                                  | 3444  | 2025-09-01  |
| [autobahn](https://github.com/crossbario/autobahn-python) | WebSocket and WAMP supporting asyncio and Twisted, for clients and servers.                                | 2524  | 2025-06-30  |
| [aiohttp](https://github.com/KeepSafe/aiohttp)            | Http client/server for asyncio (PEP-3156).                                                                 | 0     | N/A         |
| [FastAPI](https://github.com/tiangolo/fastapi)            | A very high performance Python 3.6+ API framework based on type hints. Powered by Starlette and Pydantic.  | 0     | N/A         |
| [sanic](https://github.com/channelcat/sanic)              | Python 3.5+ web server that's written to go fast.                                                          | 0     | N/A         |
| [Starlette](https://github.com/encode/starlette)          | A lightweight ASGI framework/toolkit for building high performance services.                               | 0     | N/A         |
| [uvicorn](https://github.com/encode/uvicorn)              | The lightning-fast ASGI server.                                                                            | 0     | N/A         |
| [websockets](https://github.com/aaugustin/websockets)     | A library for building WebSocket servers and clients in Python with a focus on correctness and simplicity. | 0     | N/A         |

## Alternatives to asyncio

| Name                                                        | Description                                                                                               | Stars | Last Commit |
|-------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-------|-------------|
| [trio](https://github.com/python-trio/trio)                 | Pythonic async I/O for humans and snake people.                                                           | 6839  | 2025-09-03  |
| [curio](https://github.com/dabeaz/curio)                    | The coroutine concurrency library.                                                                        | 4116  | 2024-10-04  |
| [AnyIO](https://github.com/agronholm/anyio)                 | High level asynchronous concurrency and networking framework that works on top of either trio or asyncio. | 2198  | 2025-09-06  |
| [trio-asyncio](https://github.com/python-trio/trio-asyncio) | re-implementation of the asyncio mainloop on top of Trio.                                                 | 197   | 2025-03-17  |

## Message Queues

| Name                                                    | Description                                                                         | Stars | Last Commit |
|---------------------------------------------------------|-------------------------------------------------------------------------------------|-------|-------------|
| [pyzmq](https://github.com/zeromq/pyzmq)                | Python bindings for ZeroMQ.                                                         | 3972  | 2025-09-01  |
| [crossbar](https://github.com/crossbario/crossbar)      | Crossbar.io is a networking platform for distributed and microservice applications. | 2059  | 2025-06-19  |
| [aiokafka](https://github.com/aio-libs/aiokafka)        | Client for Apache Kafka.                                                            | 1311  | 2025-07-27  |
| [aiozmq](https://github.com/aio-libs/aiozmq)            | Alternative Asyncio integration with ZeroMQ.                                        | 430   | 2022-11-10  |
| [aioamqp](https://github.com/Polyconseil/aioamqp)       | AMQP implementation using asyncio.                                                  | 281   | 2023-05-19  |
| [asyncio-nats](https://github.com/nats-io/asyncio-nats) | Client for the NATS messaging system.                                               | 0     | N/A         |

## Testing

| Name                                                           | Description                                                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pytest-asyncio](https://github.com/pytest-dev/pytest-asyncio) | Pytest support for asyncio.                                                                                                                                 | 1553  | 2025-09-08  |
| [aioresponses](https://github.com/pnuckowski/aioresponses)     | Helper for mock/fake web requests in Python aiohttp package.                                                                                                | 550   | 2025-06-10  |
| [asynctest](https://github.com/Martiusweb/asynctest)           | Enhance the standard unittest package with features for testing. asyncio libraries                                                                          | 310   | 2024-04-22  |
| [aiomock](https://github.com/nhumrich/aiomock)                 | A python mock library that supports async methods.                                                                                                          | 27    | 2024-04-19  |
| [aresponses](https://github.com/CircleUp/aresponses)           | Asyncio http mocking. Similar to the [responses](https://github.com/getsentry/responses) library used for [requests](https://github.com/requests/requests). | 0     | N/A         |

## Networking

| Name                                             | Description                                                                                            | Stars | Last Commit |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------|-------------|
| [httpx](https://github.com/encode/httpx)         | asynchronous HTTP client for Python 3 with [requests](https://github.com/psf/requests) compatible API. | 14532 | 2025-09-05  |
| [AsyncSSH](https://github.com/ronf/asyncssh)     | Provides an asynchronous client and server implementation of the SSHv2 protocol.                       | 1652  | 2025-08-23  |
| [aioping](https://github.com/stellarbit/aioping) | Fast asyncio implementation of ICMP (ping) protocol.                                                   | 90    | 2024-01-21  |
| [aiodns](https://github.com/saghul/aiodns)       | Simple DNS resolver for asyncio.                                                                       | 0     | N/A         |

## Database Drivers

| Name                                                                      | Description                                                                                                                                                           | Stars | Last Commit |
|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [redis-py](https://github.com/redis/redis-py)                             | Redis Python Client (which includes [aioreadis](https://github.com/aio-libs/aioredis) now).                                                                           | 13230 | 2025-09-08  |
| [asyncpg](https://github.com/MagicStack/asyncpg)                          | Fast PostgreSQL Database Client Library for Python/asyncio.                                                                                                           | 7537  | 2025-03-19  |
| [Tortoise ORM](https://github.com/tortoise/tortoise-orm)                  | native multi-backend ORM with Django-like API and easy relations management.                                                                                          | 5275  | 2025-08-27  |
| [Databases](https://github.com/encode/databases)                          | Async database access for SQLAlchemy core, with support for PostgreSQL, MySQL, and SQLite.                                                                            | 3933  | 2024-05-21  |
| [motor](https://github.com/mongodb/motor)                                 | The async Python driver for MongoDB.                                                                                                                                  | 2510  | 2025-08-15  |
| [Prisma Client Python](https://github.com/RobertCraigie/prisma-client-py) | An auto-generated, fully type safe ORM powered by Pydantic and tailored specifically for your schema - supports SQLite, PostgreSQL, MySQL, MongoDB, MariaDB and more. | 2009  | 2025-04-10  |
| [aiomysql](https://github.com/aio-libs/aiomysql)                          | Library for accessing a MySQL database                                                                                                                                | 1833  | 2025-05-26  |
| [Piccolo](https://github.com/piccolo-orm/piccolo)                         | An ORM / query builder which can work in async and sync modes, with a nice admin GUI, and ASGI middleware.                                                            | 1677  | 2025-08-09  |
| [aiopg](https://github.com/aio-libs/aiopg)                                | Library for accessing a PostgreSQL database.                                                                                                                          | 1420  | 2024-05-27  |
| [peewee-async](https://github.com/05bit/peewee-async)                     | ORM implementation based on [peewee](https://github.com/coleifer/peewee) and aiopg.                                                                                   | 754   | 2025-08-25  |
| [asyncpgsa](https://github.com/CanopyTax/asyncpgsa)                       | Asyncpg with sqlalchemy core support.                                                                                                                                 | 420   | 2024-02-17  |
| [aioodbc](https://github.com/aio-libs/aioodbc)                            | Library for accessing a ODBC databases.                                                                                                                               | 321   | 2023-10-28  |
| [aiocouchdb](https://github.com/aio-libs/aiocouchdb)                      | CouchDB client built on top of aiohttp (asyncio).                                                                                                                     | 53    | 2018-05-09  |
| [aioes](https://github.com/aio-libs/aioes)                                | Asyncio compatible driver for elasticsearch.                                                                                                                          | 0     | N/A         |
| [aioinflux](https://github.com/plugaai/aioinflux)                         | InfluxDB client built on top of aiohttp.                                                                                                                              | 0     | N/A         |
| [GINO](https://github.com/fantix/gino)                                    | is a lightweight asynchronous Python ORM based on [SQLAlchemy](https://www.sqlalchemy.org/) core, with [asyncpg](https://github.com/MagicStack/asyncpg) dialect.      | 0     | N/A         |

## Alternative Loops

| Name                                           | Description                                                      | Stars | Last Commit |
|------------------------------------------------|------------------------------------------------------------------|-------|-------------|
| [uvloop](https://github.com/MagicStack/uvloop) | Ultra fast implementation of asyncio event loop on top of libuv. | 11243 | 2025-04-17  |
