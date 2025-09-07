# awesome-asyncio

A curated list of awesome Python asyncio frameworks, libraries, software and resources

## Alternatives to asyncio

- [AnyIO](https://github.com/agronholm/anyio) - High level asynchronous concurrency and networking framework that works on top of either trio or asyncio.
- [curio](https://github.com/dabeaz/curio) - The coroutine concurrency library.
- [trio](https://github.com/python-trio/trio) - Pythonic async I/O for humans and snake people.
- [trio-asyncio](https://github.com/python-trio/trio-asyncio) - re-implementation of the asyncio mainloop on top of Trio.

## Testing

- [aiomock](https://github.com/nhumrich/aiomock) - A python mock library that supports async methods.
- [aioresponses](https://github.com/pnuckowski/aioresponses) - Helper for mock/fake web requests in Python aiohttp package.
- [aresponses](https://github.com/CircleUp/aresponses) - Asyncio http mocking. Similar to the [responses](https://github.com/getsentry/responses) library used for [requests](https://github.com/requests/requests).
- [asynctest](https://github.com/Martiusweb/asynctest) - Enhance the standard unittest package with features for testing. asyncio libraries
- [pytest-asyncio](https://github.com/pytest-dev/pytest-asyncio) - Pytest support for asyncio.

## Web Frameworks

- [aiohttp](https://github.com/KeepSafe/aiohttp) - Http client/server for asyncio (PEP-3156).
- [autobahn](https://github.com/crossbario/autobahn-python) - WebSocket and WAMP supporting asyncio and Twisted, for clients and servers.
- [FastAPI](https://github.com/tiangolo/fastapi) - A very high performance Python 3.6+ API framework based on type hints. Powered by Starlette and Pydantic.
- [Quart](https://github.com/pallets/quart) - An asyncio web microframework with the same API as Flask.
- [sanic](https://github.com/channelcat/sanic) - Python 3.5+ web server that's written to go fast.
- [Starlette](https://github.com/encode/starlette) - A lightweight ASGI framework/toolkit for building high performance services.
- [uvicorn](https://github.com/encode/uvicorn) - The lightning-fast ASGI server.
- [websockets](https://github.com/aaugustin/websockets) - A library for building WebSocket servers and clients in Python with a focus on correctness and simplicity.

## Alternative Loops

- [uvloop](https://github.com/MagicStack/uvloop) - Ultra fast implementation of asyncio event loop on top of libuv.

## Message Queues

- [aioamqp](https://github.com/Polyconseil/aioamqp) - AMQP implementation using asyncio.
- [aiokafka](https://github.com/aio-libs/aiokafka) - Client for Apache Kafka.
- [aiozmq](https://github.com/aio-libs/aiozmq) - Alternative Asyncio integration with ZeroMQ.
- [asyncio-nats](https://github.com/nats-io/asyncio-nats) - Client for the NATS messaging system.
- [crossbar](https://github.com/crossbario/crossbar) - Crossbar.io is a networking platform for distributed and microservice applications.
- [pyzmq](https://github.com/zeromq/pyzmq) - Python bindings for ZeroMQ.

## Networking

- [aiodns](https://github.com/saghul/aiodns) - Simple DNS resolver for asyncio.
- [aioping](https://github.com/stellarbit/aioping) - Fast asyncio implementation of ICMP (ping) protocol.
- [AsyncSSH](https://github.com/ronf/asyncssh) - Provides an asynchronous client and server implementation of the SSHv2 protocol.
- [httpx](https://github.com/encode/httpx) - asynchronous HTTP client for Python 3 with [requests](https://github.com/psf/requests) compatible API.

## Database Drivers

- [aiocouchdb](https://github.com/aio-libs/aiocouchdb) - CouchDB client built on top of aiohttp (asyncio).
- [aioes](https://github.com/aio-libs/aioes) - Asyncio compatible driver for elasticsearch.
- [aioinflux](https://github.com/plugaai/aioinflux) - InfluxDB client built on top of aiohttp.
- [aiomysql](https://github.com/aio-libs/aiomysql) - Library for accessing a MySQL database
- [aioodbc](https://github.com/aio-libs/aioodbc) - Library for accessing a ODBC databases.
- [aiopg](https://github.com/aio-libs/aiopg) - Library for accessing a PostgreSQL database.
- [asyncpg](https://github.com/MagicStack/asyncpg) - Fast PostgreSQL Database Client Library for Python/asyncio.
- [asyncpgsa](https://github.com/CanopyTax/asyncpgsa) - Asyncpg with sqlalchemy core support.
- [Databases](https://github.com/encode/databases) - Async database access for SQLAlchemy core, with support for PostgreSQL, MySQL, and SQLite.
- [GINO](https://github.com/fantix/gino) - is a lightweight asynchronous Python ORM based on [SQLAlchemy](https://www.sqlalchemy.org/) core, with [asyncpg](https://github.com/MagicStack/asyncpg) dialect.
- [motor](https://github.com/mongodb/motor) - The async Python driver for MongoDB.
- [peewee-async](https://github.com/05bit/peewee-async) - ORM implementation based on [peewee](https://github.com/coleifer/peewee) and aiopg.
- [Piccolo](https://github.com/piccolo-orm/piccolo) - An ORM / query builder which can work in async and sync modes, with a nice admin GUI, and ASGI middleware.
- [Prisma Client Python](https://github.com/RobertCraigie/prisma-client-py) - An auto-generated, fully type safe ORM powered by Pydantic and tailored specifically for your schema - supports SQLite, PostgreSQL, MySQL, MongoDB, MariaDB and more.
- [redis-py](https://github.com/redis/redis-py) - Redis Python Client (which includes [aioreadis](https://github.com/aio-libs/aioredis) now).
- [Tortoise ORM](https://github.com/tortoise/tortoise-orm) - native multi-backend ORM with Django-like API and easy relations management.

## Misc

- [aiocache](https://github.com/argaen/aiocache) - Cache manager for different backends.
- [aiochan](https://github.com/zh217/aiochan) - CSP-style concurrency with channels, select and multiprocessing on top of asyncio.
- [aiodebug](https://github.com/qntln/aiodebug) - A tiny library for monitoring and testing asyncio programs.
- [aiofiles](https://github.com/Tinche/aiofiles) - File support for asyncio.
- [aiomisc](https://github.com/aiokitchen/aiomisc) - Miscellaneous utils for `asyncio`.
- [aiopath](https://github.com/alexdelorenzo/aiopath) - Asynchronous `pathlib` for asyncio.
- [aiorun](https://github.com/cjrh/aiorun) - A `run()` function that handles all the usual boilerplate for startup and graceful shutdown.
- [aiosc](https://github.com/artfwo/aiosc) - Lightweight Open Sound Control implementation.
- [aioserial](https://github.com/changyuheng/aioserial) - A drop-in replacement of [pySerial](https://github.com/pyserial/pyserial).
- [aiozipkin](https://github.com/aio-libs/aiozipkin) - Distributed tracing instrumentation for asyncio with zipkin
- [asgiref](https://github.com/django/asgiref) - Backend utils for ASGI to WSGI integration, includes sync_to_async and async_to_sync function wrappers.
- [async_property](https://github.com/ryananguiano/async_property) - Python decorator for async properties.
- [kubernetes_asyncio](https://github.com/tomplus/kubernetes_asyncio) - Asynchronous client library for Kubernetes.
- [ruia](https://github.com/howie6879/ruia) - An async web scraping micro-framework based on asyncio.
