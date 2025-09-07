# vertx-awesome

A curated list of awesome Vert.x resources, libraries, and other nice things.

## Integration

- [AMQP 1.0](https://github.com/vert-x3/vertx-amqp-bridge)
- [AMQP 1.0 - Kafka bridge](https://github.com/rhiot/amqp-kafka-bridge) - Bridge for sending/receiving messages to/from Apache Kafka using the AMQP 1.0 protocol.
- [Azure ServiceBus](https://github.com/TextBack/vertx-azure-servicebus) - Azure [ServiceBus](https://azure.microsoft.com/en-us/products/service-bus/) producer and consumer (fully async, doesn't use Microsoft Azure SDK).
- [Bosun Monitoring](https://github.com/cyngn/vertx-bosun) - [Bosun](https://bosun.org/) client library for Vert.x.
- [CloudEvents.io Java SDK](https://github.com/cloudevents/sdk-java) - Send and receive [CloudEvents](https://cloudevents.io/) using the [Vert.x HTTP Transport](https://github.com/cloudevents/sdk-java/blob/master/http/vertx/README.md) for CloudEvents.
- [DropWizard metrics](https://github.com/vert-x3/vertx-dropwizard-metrics)
- [Hawkular metrics](https://github.com/tsegismont/vertx-monitor) - [Hawkular](http://www.hawkular.org/) implementation of the Vert.x Metrics SPI.
- [Hystrix Metrics Stream](https://github.com/kennedyoliveira/hystrix-vertx-metrics-stream) - Emits metrics for Hystrix Dashboard from a Vert.x application with [Hystrix](https://github.com/Netflix/Hystrix).
- [JCA adaptor](https://github.com/vert-x3/vertx-jca)
- [jEaSSE](https://github.com/mariomac/jeasse) - Java Easy SSE. A simple, lightweight implementation of SSE.
- [kafka](https://github.com/cyngn/vertx-kafka) - Kafka client for consuming and producing messages.
- [Kafka Client](https://github.com/vert-x3/vertx-kafka-client)
- [Meteor](https://github.com/jmusacchio/vertxbus) - Meteor integration support through Vert.x event bus.
- [Micrometer metrics](https://github.com/vert-x3/vertx-micrometer-metrics)
- [MQTT](https://github.com/vert-x3/vertx-mqtt)
- [Onesignal](https://github.com/jklingsporn/vertx-push-onesignal) - Send push notifications to (mobile/web) apps from your Vert.x application with [OneSignal](https://onesignal.com/).
- [OpenTsDb Metrics](https://github.com/cyngn/vertx-opentsdb) - [OpenTsDb](http://opentsdb.net/) metrics client for Vert.x.
- [RabbitMQ](https://github.com/vert-x3/vertx-rabbitmq-client)
- [Retrofit adapter for Vert.x](https://github.com/vietj/retrofit-vertx) - A highly scalable adapter for Retrofit with Vert.x.
- [SaltStack](https://github.com/cinterloper/vertx-salt) - A bi-directional bridge between the SaltStack event system and the Vert.x event bus.
- [SMTP](https://github.com/vert-x3/vertx-mail-client)
- [STOMP](https://github.com/vert-x3/vertx-stomp)
- [The White Rabbit](https://github.com/viartemev/the-white-rabbit) - An asynchronous RabbitMQ (AMQP) client based on Kotlin coroutines.
- [Vert.x Dart SockJS](https://github.com/wem/vertx-dart-sockjs) - [Dart](https://www.dartlang.org/) integration for [Vert.x SockJS bridge](http://vertx.io/docs/vertx-web/java/#_sockjs_event_bus_bridge) and plain SockJS with use of dart:js.
- [Vert.x Effect HTTP client](https://github.com/imrafaelmerino/vertx-effect) - Pure functional and reactive HTTP client using [Vert.x Effect](https://github.com/imrafaelmerino/vertx-effect) with OAuth support and retry, fallback and recovery operations.
- [Vert.x Kafka Client](https://github.com/vert-x3/vertx-kafka-client)
- [Vert.x TFTP Client](https://github.com/OneManCrew/vertx-tftp-client) - TFTP client for Vert.x support download/upload files.
- [vertx-smtp-server](https://github.com/cinterloper/vertx-smtp-server) - SMTP server bridging to EventBus.
- [vertx-sse](https://github.com/aesteve/vertx-sse) - Vert.x SSE implementation + event-bus SSE bridge.
- [WAMP Broker](https://github.com/i22-digitalagentur/vertx-wamp) - A WAMP broker you can embed into your Vert.x application.
- [Weld](https://github.com/weld/weld-vertx) - Brings the CDI programming model into the Vert.x ecosystem (register CDI observer methods as Vert.x message consumers, CDI-powered Verticles, define routes in a declarative way, etc.).
- [ZeroMQ](https://github.com/dano/vertx-zeromq) - ZeroMQ Event Bus bridge.

## Examples

- [AI model output API based on PMML with Vert.x](https://github.com/immusen/vertx-pmml) - High performance PMML evaluator API based on Vert.x. Supports dynamic routing configuration for multiple PMML models via JSON.
- [Cloud Foundry](https://github.com/amdelamar/vertx-cloudfoundry) - An example Vert.x for deploying to a [Cloud Foundry](https://www.cloudfoundry.org/) service provider.
- [Crabzilla](https://github.com/crabzilla/crabzilla) - Yet another Event Sourcing experiment. A project exploring Vert.x to develop Event Sourcing / CQRS applications.
- [Example using event bus and service proxies to connect vertx and node](https://github.com/advantageous/vertx-node-ec2-eventbus-example) - Step by step example with wiki description showing how to connect Vert.x and Node using event bus and service proxies.
- [Grooveex Todo-Backend implementation](https://github.com/aesteve/todo-backend-grooveex) - Todo MVC backend implementation with Vert.x + Groovy + some syntactic sugar + DSL routing facilities.
- [HTTP/2 showcase](https://github.com/aesteve/http2-showcase) - A simple demo, showing how HTTP/2 can drastically improve user experience when a huge latency is involved.
- [Kotlin Todo-Backend implementation](https://github.com/aesteve/vertx-kotlin-todomvc) - Kotlin implementation of the Todo MVC backend.
- [Scala Todo-Backend implementation](https://github.com/aesteve/vertx-scala-todomvc) - Scala implementation of the Todo MVC backend.
- [Starter Single Verticle API](https://github.com/jgarciasm/ssv-api) - REST API Starter and Project Template ready to deploy with lots of plumbing code, examples, and documentation to quickly develope an API with almost no knowledge of vert.x and without any waste of time.
- [Vert.x blueprint - Job Queue](https://github.com/sczyh30/vertx-blueprint-job-queue)
- [Vert.x blueprint - Microservice application](https://github.com/sczyh30/vertx-blueprint-microservice)
- [Vert.x blueprint - TODO backend](https://github.com/sczyh30/vertx-blueprint-todo-backend)
- [Vert.x examples](https://github.com/vert-x3/vertx-examples)
- [Vert.x feeds](https://github.com/aesteve/vertx-feeds) - Example of an RSS aggregator built using Vert.x, Gradle, MongoDB, Redis, Handlebars templates, AngularJS, the event bus and SockJS.
- [Vert.x Gentics Mesh Example](https://github.com/gentics/mesh-vertx-example) - Example on how to build a template-based web server with Gentics Mesh and handlebars.
- [Vert.x Gradle Starter](https://github.com/yyunikov/vertx-gradle-starter) - Java 8 starter application with example of using Vert.x with Gradle build system, profiles configuration and SLF4J.
- [Vert.x Markdown service](https://github.com/aesteve/vertx-markdown-service) - Example on how to use [service-proxy](https://github.com/vert-x3/vertx-service-proxy) with Gradle.
- [Vert.x Music Store](https://github.com/tsegismont/vertx-musicstore) - An example application on how to build Vert.x applications with RxJava.
- [Vert.x PostgreSQL Starter](https://github.com/BillyYccc/vertx-postgresql-starter) - A starter to build a monolithic CRUD RESTful Web Service with Vert.x stack and PostgreSQL.
- [Vert.x Todo-Backend implementation](https://github.com/aesteve/todo-backend-vertx) - Pure Java 8 implementation of the Todo MVC backend. Uses a Vert.x LocalMap for storage.

## Reactive

- [QBit](https://github.com/advantageous/qbit) - Async typed actor-like lib that runs easily in Vert.x Async Callbacks. Callback management.
- [Reactive Streams](https://github.com/vert-x3/vertx-reactive-streams)
- [Vert.x Effect](https://github.com/imrafaelmerino/vertx-effect) - Pure functional and reactive library based on the IO Monad to implement any complex flow. Full support for retry, fallback and recovery operations.
- [Vert.x Rx](https://github.com/vert-x3/vertx-rx)
- [Vert.x Sync](https://github.com/vert-x3/vertx-sync)
- [vertx-util](https://github.com/cyngn/vertx-util) - Light weight promises & latches for Vert.x.

## Miscellaneous

- [GDH](https://github.com/maxamel/GDH) - Generalized Diffie-Hellman key exchange Java library built on top of Vert.x.
- [Simple File Server](https://github.com/pitchpoint-solutions/sfs) - An OpenStack Swift compatible distributed object storage server that can serve and securely store billions of large and small files using minimal resources implemented using Vert.x.
- [Vert.x Boot](https://github.com/jponge/vertx-boot) - Deploying verticles from a HOCON configuration.
- [Vert.x Child Process](https://github.com/vietj/vertx-childprocess) - Spawn child process from Vert.x.
- [vertx-redisques](https://github.com/swisspush/vertx-redisques) - A highly scalable redis-persistent queuing system for Vert.x.
- [vertx-values](https://github.com/imrafaelmerino/vertx-values) - Send immutable and persistent JSON from [json-values](https://github.com/imrafaelmerino/json-values) across the event bus.

## Cluster Managers

- [Atomix Cluster Manager](https://github.com/atomix/atomix-vertx) - An [Atomix](http://atomix.io) based cluster manager implementation for Vert.x 3.
- [Consul Cluster Manager](https://github.com/reactiverse/consul-cluster-manager) - Consul cluster manager.
- [Hazelcast Cluster Manager](https://github.com/vert-x3/vertx-hazelcast)
- [Ignite Cluster Manager](https://github.com/vert-x3/vertx-ignite)
- [Infinispan Cluster Manager](https://github.com/vert-x3/vertx-infinispan)
- [JGroups Cluster Manager](https://github.com/vert-x3/vertx-jgroups) - JGroups cluster manager.
- [Zookeeper Cluster Manager](https://github.com/vert-x3/vertx-zookeeper)

## Front-End

- [VertxUI](https://github.com/nielsbaloe/vertxui) - A pure Java front-end toolkit with descriptive fluent views-on-models, POJO traffic, JUnit testing on the virtual DOM or mixed-language on a real DOM, and more.

## Search Engines

- [Vert.x Elasticsearch Service](https://github.com/englishtown/vertx-elasticsearch-service) - Vert.x 3 [Elasticsearch](https://www.elastic.co/) service with event bus proxying.
- [Vert.x Solr Service](https://github.com/englishtown/vertx-solr-service) - Vert.x 3 Solr service with event bus proxying.

## Config

- [Vert.x Boot](https://github.com/jponge/vertx-boot) - Deploying verticles from a HOCON configuration.
- [Vert.x Config AWS SSM Store](https://github.com/Finovertech/vertx-config-aws-ssm) - A [config store](http://vertx.io/docs/vertx-config/java/) implementation for retrieving configuration values from the [AWS EC2 SSM Parameter Store](https://aws.amazon.com/ec2/systems-manager/parameter-store/).

## Cloud Support

- [AWS SDK](https://github.com/reactiverse/aws-sdk) - Use AWS Java SDK v2 (async) with Vert.x
- [OpenShift DIY cartridge](https://github.com/vert-x3/vertx-openshift-diy-quickstart)
- [OpenShift Vert.x cartridge](https://github.com/vert-x3/vertx-openshift-cartridge)

## Build tools

- [Vert.x Codegen Gradle plugin](https://github.com/bulivlad/vertx-codegen-plugin) - A Gradle plugin to facilitate the codegen usage for Vert.x Java projects.
- [Vert.x Maven plugin](https://github.com/reactiverse/vertx-maven-plugin)

## Dependency Injection

- [Glue](https://github.com/vinscom/glue) - Proven and opinionated programming, and configuration model for Java and Vert.x based applications. Inspired from ATG Nucleus, provides powerful layer base configuration management using simple properties file.
- [QBit](https://github.com/advantageous/qbit) - QBit works with Spring DI and Spring Boot (and of course Vert.x). Allows you to use QBit, Vert.x, Spring DI and Spring Boot in the same application.
- [Spring Vert.x Extension](https://github.com/amoAHCP/spring-vertx-ext) - Vert.x verticle factory for Spring DI injection.
- [Vert.x Beans](https://github.com/rworsnop/vertx-beans) - Inject Vert.x objects as beans into your Spring application.
- [Vert.x Eclipse SISU](https://github.com/cstamas/vertx-sisu) - Vert.x integration with [Eclipse SISU](https://www.eclipse.org/sisu/) DI container.
- [Vert.x Guice](https://github.com/englishtown/vertx-guice) - Vert.x verticle factory for Guice dependency injection.
- [Vert.x HK2](https://github.com/englishtown/vertx-hk2) - Vert.x verticle factory for HK2 dependency injection.
- [Vert.x Spring Verticle Factory](https://github.com/juanavelez/vertx-spring-verticle-factory) - A Vert.x Verticle Factory that makes use of Spring to obtain and configure Verticles.

## Language Support

- [Ceylon](https://github.com/vert-x3/vertx-lang-ceylon)
- [EcmaScript](https://github.com/reactiverse/es4x) - EcmaScript >=6 (JavaScript) support.
- [Grooveex](https://github.com/aesteve/grooveex) - Syntactic sugar + utilities (DSL builders, etc.) on top of [vertx-lang-groovy](https://github.com/vert-x3/vertx-lang-groovy).
- [Groovy](https://github.com/vert-x3/vertx-lang-groovy)
- [Java](https://github.com/eclipse/vert.x)
- [JavaScript](https://github.com/vert-x3/vertx-lang-js)
- [Kotlin](https://github.com/vert-x3/vertx-lang-kotlin) - <img src="vertx-favicon.svg" alt="(stack)" title="Vert.x Stack" height="16px"> - Kotlin support.
- [Php](https://github.com/vert-x-cn/vertx-lang-jphp) - Php support.
- [Python](https://github.com/vert-x3/vertx-lang-python) - Python support.
- [Ruby](https://github.com/vert-x3/vertx-lang-ruby)
- [Scala](https://github.com/vert-x3/vertx-lang-scala) - <img src="vertx-favicon.svg" alt="(stack)" title="Vert.x Stack" height="16px"> - Scala support.

## Database Clients

- [Aerospike](https://github.com/dream11/vertx-aerospike-client) - Asynchronous and non-blocking API to interact with Aerospike server. Uses [AerospikeClient's](https://github.com/aerospike/aerospike-client-java) async commands internally and handles the result on the Vert.x Context.
- [Bitsy](https://github.com/cstamas/vertx-bitsy) - Non-blocking Bitsy Graph server integration.
- [Cassandra](https://github.com/englishtown/vertx-cassandra) - Asynchronous API to interact with Cassandra and Cassandra Mapping.
- [Cassandra](https://github.com/vert-x3/vertx-cassandra-client)
- [database](https://github.com/susom/database) - Client for Oracle, PostgreSQL, SQL Server, HyperSQL, etc. designed for security, correctness, and ease of use.
- [DGraph](https://github.com/aesteve/vertx-dgraph-client) - An example on how to build a Vert.x gRPC compliant client. Here targeting [dgraph](https://dgraph.io)
- [Exposed Vert.x SQL Client](https://github.com/huanshankeji/exposed-vertx-sql-client) - Kotlin's [Exposed](https://github.com/JetBrains/Exposed) on top of [Vert.x Reactive SQL Client](https://github.com/eclipse-vertx/vertx-sql-client).
- [JDBC](https://github.com/vert-x3/vertx-jdbc-client)
- [jOOQ](https://github.com/jklingsporn/vertx-jooq) - Doing typesafe, asynchronous SQL and generate code using jOOQ.
- [jOOQx](https://github.com/zero88/jooqx) - Leverages the power of typesafe SQL from `jOOQ DSL` and uses the reactive and non-blocking SQL driver from Vert.x.
- [MarkLogic](https://github.com/etourdot/vertx-marklogic) - Asynchronous client for Marklogic Database Server.
- [MongoDB](https://github.com/vert-x3/vertx-mongo-client)
- [MongoDB](https://github.com/imrafaelmerino/vertx-mongo-effect) - Pure functional and reactive MongoDB client on top of [Vert.x Effect](https://github.com/imrafaelmerino/vertx-mongo-effect). Full support for retry, fallback and recovery operations.
- [MySQL / PostgreSQL](https://github.com/vert-x3/vertx-mysql-postgresql-client)
- [OrientDB](https://github.com/cstamas/vertx-orientdb) - Non-blocking OrientDB server integration.
- [PostgreSQL](https://github.com/vietj/reactive-pg-client) - Reactive PostgreSQL Client.
- [Reactive SQL Client](https://github.com/eclipse-vertx/vertx-sql-client)
- [Redis](https://github.com/vert-x3/vertx-redis-client)
- [RxFirestore](https://github.com/pjgg/rxfirestore) - Non-blocking Firestore SDK written in a reactive way.
- [vertx-mysql-binlog-client](https://github.com/guoyu511/vertx-mysql-binlog-client) - A Vert.x client for tapping into MySQL replication stream.
- [vertx-pojo-mapper](https://github.com/BraintagsGmbH/vertx-pojo-mapper) - Non-blocking POJO mapping for MySQL and MongoDB.

## Development Tools

- [openapi-generator](https://github.com/OpenAPITools/openapi-generator) - OpenAPI Generator allows generation of API client libraries (SDK generation), server stubs, documentation and configuration automatically given an OpenAPI Spec (v2, v3).
- [Vert.x for Visual Studio Code](https://github.com/pmlopes/VertxSnippet) - A Visual Studio Code (polyglot) plugin for Vert.x. Also available from the [Marketplace](https://marketplace.visualstudio.com/items?itemName=pmlopes.vertxsnippet).
- [Vert.x health check](https://github.com/vert-x3/vertx-health-check) - Allows for remote health checking in Vert.x projects.
- [Vert.x Hot](https://github.com/dazraf/vertx-hot) - A Maven plugin for the hot-deploy of Maven Vert.x projects.
- [Vert.x LiveReload](https://github.com/ybonnel/vertx-livereload) - A simple livereload server for Vert.x applications.
- [Vert.x shell](https://github.com/vert-x3/vertx-shell)

## Service Factory

- [Eclipse SISU Service Factories](https://github.com/cstamas/vertx-sisu) - Vert.x integration with [Eclipse SISU](https://www.eclipse.org/sisu/) DI container offering alternatives for `vertx-service-factory` and `vertx-maven-service-factory`.
- [HTTP Service Factory](https://github.com/vert-x3/vertx-http-service-factory)
- [Maven Service Factory](https://github.com/vert-x3/vertx-maven-service-factory)
- [Node.js Service Factory](https://github.com/mellster2012/vertx-nodejs-service-factory) - Vert.x Node.js Service Factory.
- [Service Factory](https://github.com/vert-x3/vertx-service-factory)

## Microservices

- [Apache ServiceComb Java Chassis](https://github.com/apache/servicecomb-java-chassis) - ServiceComb Java Chassis is a Software Development Kit (SDK) for rapid development of microservices in Java, providing service registration, service discovery, dynamic routing, and service management features.
- [Autonomous Services](https://github.com/mikand13/autonomous-services) - A toolkit for creating autonomous services. An architecture that leverages vert.x and nannoq-tools to provide an event-based reactive architecure without centralized components, neither for communication or data, providing a theoretically linear scalability across the architecture.
- [Circuit Breaker](https://github.com/vert-x3/vertx-circuit-breaker)
- [Resilience4j](https://github.com/resilience4j/resilience4j) - Resilience4j is a fault tolerance library designed for Java8 and functional programming. Resilience4j provides modules for Circuit Breaking, Rate Limiting, Bulkheading, Automatic retrying, Response caching and Metric measuring.
- [Service Discovery](https://github.com/vert-x3/vertx-service-discovery)
- [Service Discovery - Consul](https://github.com/vert-x3/vertx-service-discovery)
- [Service Discovery - Docker links](https://github.com/vert-x3/vertx-service-discovery)
- [Service Discovery - Kubernetes](https://github.com/vert-x3/vertx-service-discovery)
- [Service Discovery - Redis backend](https://github.com/vert-x3/vertx-service-discovery)
- [SmallRye Fault Tolerance](https://github.com/smallrye/smallrye-fault-tolerance) - SmallRye Fault Tolerance is an implementation of Eclipse MicroProfile Fault Tolerance with additional features not defined by the specification. Native support of [Vert.x](https://smallrye.io/docs/smallrye-fault-tolerance/6.2.6/integration/event-loop.html) and [Mutiny](https://smallrye.io/docs/smallrye-fault-tolerance/6.2.6/reference/asynchronous.html#async-types).
- [Vert.x GraphQL Service Discovery](https://github.com/engagingspaces/vertx-graphql-service-discovery) - [GraphQL](http://graphql.org/) service discovery and querying for your Vert.x microservices.

## Distribution

- [Vert.x Stack](https://github.com/vert-x3/vertx-stack)

## Vert.x Event Bus Extensions

- [Eventbus Service](https://github.com/wowselim/eventbus-service) - Code generator for type-safe event bus communication via simple Kotlin interfaces.

## Authentication Authorisation

- [Vert.x Auth SQL](https://github.com/eclipse-vertx/vertx-auth)
- [Vert.x-Pac4j](https://github.com/pac4j/vertx-pac4j) - Vert.x authentication/authorisation implemented using [pac4j](http://www.pac4j.org/).

## Vert.x Event Bus Clients

- [C](https://github.com/jaymine/TCP-eventbus-client-C) - Event bus client for C99 using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).
- [C#](https://github.com/jaymine/TCP-eventbus-client-C-Sharp) - Event bus client for C# using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).
- [C++11](https://github.com/julien3/vertxbuspp) - C++11 event bus client.
- [CLI](https://github.com/cinterloper/vxc) - Command-line binary client for Vert.x event bus - pipe in JSON, emit JSON.
- [Elixir](https://github.com/PharosProduction/ExVertx) - Event bus support for Elixir apps using TCP socket.
- [Go](https://github.com/jponge/vertx-go-tcp-eventbus-bridge) - Event bus client for Go-lang using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).
- [Java](https://github.com/danielstieger/javaxbus) - Simple Java Event Bus Client using plain TCP socket I/O.
- [Java](https://github.com/abdlquadri/vertx-eventbus-java) - Java and Android Event Bus Client.
- [Java](https://github.com/saffron-technology/vertx-eventbusbridge) - Java implementation of vertxbus.js.
- [Python](https://github.com/jaymine/TCP-eventbus-client-Python) - Event bus client for Python using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).
- [Rust](https://github.com/aesteve/vertx-eventbus-client-rs) - Event bus client for Rust applications through TCP.
- [Smalltalk](https://github.com/mumez/VerStix) - Event bus client for [Pharo Smalltalk](http://pharo.org/) using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).
- [Swift](https://github.com/tobias/vertx-swift-eventbus) - Event bus client for [Apple's Swift](https://swift.org) using the [TCP-based protocol](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).

## Web Frameworks

- [Atmosphere Vert.x](https://github.com/Atmosphere/atmosphere-vertx) - Realtime Client Server Framework for the JVM, supporting WebSockets and Server Sent Events with Cross-Browser Fallbacks.
- [Cloudopt Next](https://github.com/cloudoptlab/cloudopt-next) - Cloudopt Next is a very lightweight and modern, JVM-based, full stack kotlin framework designed for building modular, easily testable JVM applications with support for Java, Kotlin language, crafted from the best of breed Java libraries and standards.
- [Donkey](https://github.com/AppsFlyer/donkey) - Modern Clojure HTTP server and client built for ease of use and performance.
- [Handlers](https://github.com/spriet2000/vertx-handlers-http) - Open web framework for Vert.x.
- [Irked](https://github.com/GreenfieldTech/irked) - Annotations-based configuration for Vert.x Web, with a controller framework and expressive APIs for REST.
- [Jubilee](https://github.com/isaiah/jubilee) - A rack compatible Ruby HTTP server built on Vert.x 3.
- [Knot.x](https://github.com/Cognifide/knotx) - Efficient & high-performance integration platform for modern websites built on Vert.x 3.
- [Kovert](https://github.com/kohesive/kovert) - Invisible REST framework for Kotlin + Vert.x Web.
- [QBit](https://github.com/advantageous/qbit) - REST and WebSocket method call marshaling and reactive library.
- [REST.VertX](https://github.com/zandero/rest.vertx) - Lightweight JAX-RS (RestEasy) like annotation processor for Vert.x verticals.
- [SCX](https://github.com/scx567888/scx) - An open and easy-to-use web framework, most functions are based on annotations.
- [Serverx](https://github.com/lukehutch/serverx) - Allows you to quickly and easily set up a Vert.x-powered server using only route handler annotations.
- [Vert.x Jersey](https://github.com/englishtown/vertx-jersey) - Create JAX-RS [Jersey](https://eclipse-ee4j.github.io/jersey/) resources in Vert.x.
- [Vert.x Vaadin](https://github.com/mcollovati/vertx-vaadin) - Run Vaadin applications on Vert.x.
- [Vert.x Web](https://github.com/vert-x3/vertx-web)
- [vertx-rest](https://github.com/dream11/vertx-rest) - Abstraction over resteasy-vertx to simplify writing a Vert.x REST application based on JAX-RS annotations.
- [vertx-rest-storage](https://github.com/swisspush/vertx-rest-storage) - Persistence for REST resources in the filesystem or a redis database.

## Sync Thread Non Block

- [Sync](https://github.com/vert-x3/vertx-sync) - Synchronous but non-OS-thread-blocking verticles.

## Middleware

- [API Framework](https://github.com/vinscom/api-framework) - Vert.x and Glue based microservice framework removing distinction between standalone and serveless application. All services can run in standalone server, but, if required, same codebase can be used to run any service as serverless application.
- [Gateleen](https://github.com/swisspush/gateleen) - Middleware library based on Vert.x to build advanced JSON/REST communication servers.

## Utilities

- [Chime](https://github.com/LisiLisenok/Chime) - Time scheduler working on Vert.x event bus allowing for scheduling with *cron-style* and *interval* timers.
- [Contextual logging](https://github.com/reactiverse/reactiverse-contextual-logging) - Mapped Diagnostic Context (MDC) that works with the Vert.x event-loop model.
- [Vert.x Async](https://github.com/gchauvet/vertx-async) - Portage of caolan/async nodejs module to Vert.x framework that provides helpers methods for common async patterns.
- [Vert.x Cron](https://github.com/diabolicallabs/vertx-cron) - Schedule events with cron specifications. Has event bus and Observable versions.
- [Vert.x CronUtils](https://github.com/NoEnv/vertx-cronutils) - An abstraction of cron-utils for the vertx scheduler. Unix, Cron4j and Quartz style expressions are supported.
- [Vert.x Dataloader](https://github.com/engagingspaces/vertx-dataloader) - Java port of Facebook Dataloader for Vert.x. Efficient batching and caching for your data layer.
- [Vert.x Dependent Verticle Deployer](https://github.com/juanavelez/vertx-dependent-verticle-deployer) - A Vert.x Verticle intended to deploy verticles and their dependent verticles.
- [Vert.x GraphQL Utils](https://github.com/tibor-kocsis/vertx-graphql-utils) - A route handler and Vert.x compatible interfaces to handle GraphQL queries in Vert.x and Vert.x Web.
- [Vert.x JOLT](https://github.com/lusoalex/vertx-jolt) - JSON to JSON transformation tool based on the original bazaarvoice JOLT project. Helpful to transform different json structure into an expected json format.
- [Vert.x JsonPath](https://github.com/NoEnv/vertx-jsonpath) - A very basic implementation of JsonPath using Vert.x’s JsonObject and JsonArray, mimicking their getX, containsKey, put and remove methods.
- [Vert.x POJO config](https://github.com/aesteve/vertx-pojo-config) - Allows for mapping between standard JSON configuration and a (type-safe) configuration Java bean. Also allows the configuration bean to be validated through JSR 303.
- [Vert.x Scheduler](https://github.com/zero88/vertx-scheduler) - A lightweight plugable scheduler based on plain Vert.x core without any external libs for scheduling with *cron-style* and *interval* timers with a detail *monitor* on both sync and async task.
- [Vert.x Util](https://github.com/juanavelez/vertx-util) - A collection of Vert.x utility methods.
- [Vert.x Web Accesslog](https://github.com/romanpierson/vertx-web-accesslog) - Just a simple handler to be used in Vert.x Web to generate access logs.

## Testing

- [Vert.x JUnit5](https://github.com/vert-x3/vertx-junit5)
- [Vert.x Unit](https://github.com/vert-x3/vertx-unit)
- [Vert.x WireMongo](https://github.com/noenv/vertx-wiremongo) - Lightweight MongoDB mocking for Vert.x

## Deployment

- [Vert.x Deploy Application](https://github.com/msoute/vertx-deploy-tools) - (Seamless) deploy to AWS based Vert.x application clusters.
