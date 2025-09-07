# awesome-erlang

A curated list of awesome Erlang libraries, resources and shiny things.

## Algorithms and Datastructures

- [datum](https://github.com/fogfish/datum) - A pure functional and generic programming for Erlang
- [erlando](https://github.com/travelping/erlando) - A set of syntax extensions like currying and monads for Erlang.
- [statebox](https://github.com/mochi/statebox) - Erlang state "monad" with merge/conflict-resolution capabilities.
- [riak_dt](https://github.com/basho/riak_dt) - Erlang library of state based CRDTs.

## Debugging

- [tx](https://github.com/kvakvs/tx) - An HTML Erlang term viewer, starts own webserver and displays any term you give it from your Erlang node.

## ORM and Datamapping

- [boss_db](https://github.com/ErlyORM/boss_db) - A sharded, caching, pooling, evented ORM for Erlang.
- [epgsql](https://github.com/epgsql/epgsql) - PostgreSQL Driver for Erlang.
- [mysql-otp](https://github.com/mysql-otp/mysql-otp) - MySQL/OTP – MySQL driver for Erlang/OTP.
- [pgsql_migration](https://github.com/artemeff/pgsql_migration)

## Configuration Management

- [stillir](https://github.com/heroku/stillir) - Cache environment variables as Erlang app variables.

## Date and Time

- [erlang_localtime](https://github.com/dmitryme/erlang_localtime) - Erlang library for conversion from one local time to another.
- [qdate](https://github.com/choptastic/qdate) - Erlang date, time, and timezone management: formatting, conversion, and date arithmetic.

## Third Party APIs

- [google-token-erlang](https://github.com/ruel/google-token-erlang) - Google ID token verifier for Erlang.
- [restc](https://github.com/kivra/restclient) - An Erlang REST client
- [oauth2c](https://github.com/kivra/oauth2_client) - An Erlang oAuth 2 client (uses restc)

## Build Tools

- [rebar](https://github.com/rebar/rebar) - Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases.
- [rebar3](https://github.com/rebar/rebar3) - A build tool for Erlang which can manage Erlang packages from [Hex.pm](https://hex.pm/). See more at [rebar3.org](https://www.rebar3.org/)
- [sync](https://github.com/rustyio/sync) - On-the-fly recompiling for Erlang.

## Testing

- [PropEr](https://github.com/manopapad/proper) - A QuickCheck-inspired property-based testing tool for Erlang.
- [tracerl](https://github.com/esl/tracerl) - Dynamic tracing tests and utilities for Erlang/OTP

## Web Framework Components

- [cb_admin](https://github.com/ChicagoBoss/cb_admin) - An admin interface for Chicago Boss.
- [cb_websocket_controller](https://github.com/dkuhlman/cb_websocket_controller) - A template for implementing a Websocket controller for ChicagoBoss.
- [giallo_session](https://github.com/kivra/giallo_session) - A session management library for the Giallo web framework.
- [simple_bridge](https://github.com/nitrogen/simple_bridge) - An abstraction layer providing a unified interface to popular Erlang web servers (Cowboy, Inets, Mochiweb, Webmachine, and Yaws).

## Logging

- [lager](https://github.com/basho/lager) - A logging framework for Erlang/OTP.
- [lager_amqp_backend](https://github.com/jbrisbin/lager_amqp_backend) - AMQP RabbitMQ Lager backend.
- [lager_hipchat](https://github.com/synlay/lager_hipchat) - HipChat backend for lager.
- [lager_loggly](https://github.com/kivra/lager_loggly) - Loggly backend for lager.
- [lager_smtp](https://github.com/blinkov/lager_smtp) - SMTP backend for lager.
- [lager_slack](https://github.com/furmanOFF/lager_slack) - Simple Slack backend for lager.
- [logplex](https://github.com/heroku/logplex) - Heroku log router.

## Monitoring

- [entop](https://github.com/mazenharake/entop) - A top-like Erlang node monitoring tool.
- [eper](https://github.com/massemanet/eper) - A loose collection of Erlang Performance related tools.
- [Exometer](https://github.com/Feuerlabs/exometer) - An Erlang instrumentation package.
- [folsom](https://github.com/boundary/folsom) - An Erlang based metrics system inspired by Coda Hale's [metrics](https://github.com/codahale/metrics).
- [statsderl](https://github.com/lpgauth/statsderl) - A statsd Erlang client.
- [vmstats](https://github.com/ferd/vmstats) - Tiny Erlang app that works in conjunction with statsderl in order to generate information on the Erlang VM for graphite logs.

## Actors

- [poolboy](https://github.com/devinus/poolboy) - A hunky Erlang worker pool factory.

## Text and Numbers

- [ejsv](https://github.com/patternmatched/ejsv) - Erlang JSON schema validator.
- [eql](https://github.com/artemeff/eql) - Erlang with SQL or not.
- [jiffy](https://github.com/davisp/jiffy) - JSON NIFs for Erlang.
- [jsx](https://github.com/talentdeficit/jsx) - An erlang application for consuming, producing and manipulating json.
- [miffy](https://github.com/expelledboy/miffy) - Jiffy wrapper which returns pretty maps.
- [qsp](https://github.com/artemeff/qsp) - Enhanced query string parser for Erlang.
- [rec2json](https://github.com/lordnull/rec2json) - Generate JSON encoder/decoder from record specs.

## Geolocation

- [erl-rstar](https://github.com/armon/erl-rstar) - An Erlang implementation of the R*-tree spacial data structure.
- [GeoCouch](https://github.com/couchbase/geocouch) - A spatial extension for Couchbase and Apache CouchDB.
- [Teles](https://github.com/armon/teles) - An Erlang network service for manipulating geographic data.

## Networking

- [barrel_tcp](https://github.com/benoitc-attic/barrel_tcp) - barrel_tcp is a generic TCP acceptor pool with low latency in Erlang.
- [gen_rpc](https://github.com/priestjim/gen_rpc) - A scalable RPC library for Erlang-VM based languages.
- [gen_tcp_server](https://github.com/rpt/gen_tcp_server) - A library that takes the concept of gen_server and introduces the same mechanics for operating a TCP server.
- [gossiperl](https://github.com/gossiperl/gossiperl) - Language agnostic gossip middleware and message bus written in Erlang.
- [nat_upnp](https://github.com/benoitc/nat_upnp) - Erlang library to map your internal port to an external using UNP IGD.
- [ranch](https://github.com/ninenines/ranch) - Socket acceptor pool for TCP protocols.

## REST and API

- [leptus](https://github.com/s1n4/leptus) - Leptus is an Erlang REST framework that runs on top of cowboy.
- [rooster](https://github.com/FelipeBB/rooster) - rooster is a lightweight REST framework that runs on top of mochiweb.

## Miscellaneous

- [erlang-history](https://github.com/ferd/erlang-history) - Hacks to add shell history to Erlang's shell.
- [erld](https://github.com/ShoreTel-Inc/erld) - erld is a small program designed to solve the problem of running Erlang programs as a UNIX daemon. Various resources, such as books, websites and articles, for improving your Erlang development skills and knowledge.

## Web Frameworks

- [Axiom](https://github.com/tsujigiri/axiom) - A micro-framework, inspired by Ruby's [Sinatra](https://github.com/sinatra/sinatra).
- [ChicagoBoss](https://github.com/ChicagoBoss/ChicagoBoss) - A server framework inspired by Rails and written in Erlang.
- [cowboy](https://github.com/ninenines/cowboy) - A simple HTTP server.
- [Giallo](https://github.com/kivra/giallo) - A small and flexible web framework on top of [Cowboy](https://github.com/ninenines/cowboy).
- [MochiWeb](https://github.com/mochi/mochiweb) - An Erlang library for building lightweight HTTP servers.
- [N2O](https://github.com/synrc/n2o) - WebSocket Application Server.
- [Nitrogen](https://github.com/nitrogen/nitrogen) - Framework to build web applications (including front-end) in pure Erlang.
- [Zotonic](https://github.com/zotonic/zotonic) - High speed, real-time web framework and content management system.

## Deployment

- [docker-erlang](https://github.com/synlay/docker-erlang) - Basic Docker Container Images for Erlang/OTP.

## Code Analysis

- [Concuerror](https://github.com/parapluu/Concuerror) - Concuerror is a systematic testing tool for concurrent Erlang programs.
- [eflame](https://github.com/proger/eflame) - A Flame Graph profiler for Erlang.
- [geas](https://github.com/crownedgrouse/geas) - Geas is a tool that will detect the runnable official Erlang release window for your project, including its dependencies and provides many useful informations.

## Codebase Maintenance

- [elvis](https://github.com/inaka/elvis) - Erlang Style Reviewer.

## Caching

- [cache](https://github.com/fogfish/cache) - In-memory Segmented Cache

## Authentication

- [oauth2](https://github.com/kivra/oauth2) - Erlang Oauth2 implementation.

## Queue

- [dq](https://github.com/darach/dq) - Distributed Fault Tolerant Queue library.
- [ebqueue](https://github.com/rgrinberg/ebqueue) - Tiny simple blocking queue in erlang.
- [pqueue](https://github.com/okeuday/pqueue) - Erlang Priority Queues.
- [tinymq](https://github.com/ChicagoBoss/tinymq) - A diminutive, in-memory message queue for Erlang.

## Release Management

- [relx](https://github.com/erlware/relx) - A release assembler for Erlang.

## Internet of Things

- [lemma_erlang](https://github.com/noam-io/lemma_erlang) - A lemma for IDEO's Noam internet-of-things prototyping platform.

## HTTP

- [bullet](https://github.com/ninenines/bullet) - Simple, reliable, efficient streaming for Cowboy.
- [gun](https://github.com/ninenines/gun) - Erlang HTTP client with support for HTTP/1.1, SPDY and Websocket.
- [hackney](https://github.com/benoitc/hackney) - Simple HTTP client in Erlang.
- [ibrowse](https://github.com/cmullaparthi/ibrowse) - Erlang HTTP client.
- [lhttpc](https://github.com/esl/lhttpc) - A lightweight HTTP/1.1 client implemented in Erlang.
- [shotgun](https://github.com/inaka/shotgun) - For the times you need more than just a gun.

## Distributed Systems

- [Typhoon](https://github.com/fogfish/typhoon) - Stress and load testing tool for distributed systems that simulates traffic from a test cluster toward a system-under-test (SUT) and visualizes related latencies.
