# awesome-ruby

💎 A collection of awesome Ruby libraries, tools, frameworks and software

**Source:** [markets/awesome-ruby](https://github.com/markets/awesome-ruby)

## Table of Contents

- [API Builder and Discovery](#api-builder-and-discovery)
- [Admin Interface](#admin-interface)
- [Analytics](#analytics)
- [Assets](#assets)
- [Authentication and OAuth](#authentication-and-oauth)
- [Authorization](#authorization)
- [Automation](#automation)
- [Breadcrumbs](#breadcrumbs)
- [Business logic](#business-logic)
- [CLI Builder](#cli-builder)
- [CLI Utilities](#cli-utilities)
- [CMS](#cms)
- [CRM](#crm)
- [Caching](#caching)
- [Captchas and anti-spam](#captchas-and-anti-spam)
- [Cloud](#cloud)
- [Code Analysis and Metrics](#code-analysis-and-metrics)
- [Code Formatting](#code-formatting)
- [Code Highlighting](#code-highlighting)
- [Code Loaders](#code-loaders)
- [Coding Style Guides](#coding-style-guides)
- [Concurrency and Parallelism](#concurrency-and-parallelism)
- [Configuration](#configuration)
- [Core Extensions](#core-extensions)
- [Country Data](#country-data)
- [Dashboards](#dashboards)
- [Data Processing and ETL](#data-processing-and-etl)
- [Data Visualization](#data-visualization)
- [Database Drivers](#database-drivers)
- [Database Tools](#database-tools)
- [Date and Time Processing](#date-and-time-processing)
- [Debugging Tools](#debugging-tools)
- [Decorators](#decorators)
- [DevOps Tools](#devops-tools)
- [Diff](#diff)
- [Discover](#discover)
- [Documentation](#documentation)
- [E-Commerce and Payments](#e-commerce-and-payments)
- [Ebook](#ebook)
- [Email](#email)
- [Encryption](#encryption)
- [Environment Management](#environment-management)
- [Error Handling](#error-handling)
- [Event Sourcing](#event-sourcing)
- [Feature Flippers and A/B Testing](#feature-flippers-and-ab-testing)
- [File System Listener](#file-system-listener)
- [File Upload](#file-upload)
- [Form Builder](#form-builder)
- [GUI](#gui)
- [Game Development and Graphics](#game-development-and-graphics)
- [Gem Servers](#gem-servers)
- [Geolocation](#geolocation)
- [Git Tools](#git-tools)
- [GraphQL](#graphql)
- [HTML/XML Parsing](#htmlxml-parsing)
- [HTTP Clients and tools](#http-clients-and-tools)
- [IRB](#irb)
- [Image Processing](#image-processing)
- [Implementations/Compilers](#implementationscompilers)
- [Internationalization](#internationalization)
- [Logging](#logging)
- [Machine Learning](#machine-learning)
- [Markdown Processors](#markdown-processors)
- [Measurements](#measurements)
- [Mobile Development](#mobile-development)
- [Money](#money)
- [Music and Sound](#music-and-sound)
- [Natural Language Processing](#natural-language-processing)
- [Notifications](#notifications)
- [ORM/ODM](#ormodm)
- [ORM/ODM Extensions](#ormodm-extensions)
- [Optimizations](#optimizations)
- [PDF](#pdf)
- [Package Management](#package-management)
- [Pagination](#pagination)
- [Process Management and Monitoring](#process-management-and-monitoring)
- [Processes](#processes)
- [Profiler and Optimization](#profiler-and-optimization)
- [QR](#qr)
- [Queues and Messaging](#queues-and-messaging)
- [RSS](#rss)
- [Rails Application Generators](#rails-application-generators)
- [SEO](#seo)
- [Scheduling](#scheduling)
- [Scientific](#scientific)
- [Search](#search)
- [Security](#security)
- [Social Networking](#social-networking)
- [Spreadsheets and Documents](#spreadsheets-and-documents)
- [State Machines](#state-machines)
- [Static Site Generation](#static-site-generation)
- [Template Engine](#template-engine)
- [Testing](#testing)
- [Third-party APIs](#third-party-apis)
- [Video](#video)
- [View components](#view-components)
- [View helpers](#view-helpers)
- [Web Crawling](#web-crawling)
- [Web Frameworks](#web-frameworks)
- [Web Servers](#web-servers)
- [WebSocket](#websocket)

## API Builder and Discovery

| Name                                                                              | Description                                                                                                              | Stars | Last Commit |
|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) | JSON serialization of objects.                                                                                           | 5336  | 2024-12-01  |
| [jbuilder](https://github.com/rails/jbuilder)                                     | Create JSON structures via a Builder-style DSL.                                                                          | 4390  | 2025-08-12  |
| [rabl](https://github.com/nesquena/rabl)                                          | General ruby templating with json, bson, xml, plist and msgpack support.                                                 | 3641  | 2025-01-04  |
| [JSONAPI::Resources](https://github.com/cerebris/jsonapi-resources)               | JSONAPI::Resources, or "JR", provides a framework for developing a server that complies with the JSON API specification. | 2322  | 2024-11-21  |
| [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)    | A fast JSON:API serializer for Ruby Objects.                                                                             | 1427  | 2024-07-19  |
| [Alba](https://github.com/okuramasafumi/alba)                                     | A JSON serializer for Ruby, JRuby and TruffleRuby.                                                                       | 1056  | 2025-09-07  |
| [versionist](https://github.com/bploetz/versionist)                               | A plugin for versioning Rails based RESTful APIs.                                                                        | 966   | 2024-02-22  |
| [Spyke](https://github.com/balvig/spyke)                                          | Interact with REST services in an ActiveRecord-like manner.                                                              | 906   | 2024-12-31  |
| [Pliny](https://github.com/interagent/pliny)                                      | Opinionated template Sinatra app for writing excellent APIs in Ruby.                                                     | 802   | 2025-09-04  |
| [Version Cake](https://github.com/bwillis/versioncake)                            | An unobtrusive way to version APIs in your Rails app.                                                                    | 656   | 2022-07-21  |
| [Acts_As_Api](https://github.com/fabrik42/acts_as_api)                            | Easy And Fun, in creating XML/JSON responses in Rails 3,4,5 and 6.                                                       | 504   | 2020-10-13  |

[Back to Top](#table-of-contents)

## Admin Interface

| Name                                                                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                         | Stars | Last Commit |
|---------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Administrate](https://github.com/thoughtbot/administrate)          | A Rails engine that helps you put together a super-flexible admin dashboard, by Thoughtbot.                                                                                                                                                                                                                                                                                                                                                         | 5970  | 2025-09-08  |
| [Trestle](https://github.com/TrestleAdmin/trestle)                  | A modern, responsive admin framework for Rails. Build a back-end in minutes that will grow with the needs of your application.                                                                                                                                                                                                                                                                                                                      | 1994  | 2025-01-09  |
| [ActiveScaffold](https://github.com/activescaffold/active_scaffold) | ActiveScaffold provides quick and powerful user interfaces for CRUD (create, read, update, delete) operations for Rails applications. It's excellent for generating admin interfaces, managing Data-Heavy Applications, creating Widgets or for quick prototyping. ActiveScaffold is completly customizable and offers a bunch of additional features including searching, pagination, layout control and overrides of fields, forms and templates. | 1123  | 2025-09-02  |
| [MotorAdmin](https://github.com/motor-admin/motor-admin-rails)      | A low-code Admin panel and Business Intelligence Rails engine. No DSL - configurable from the UI.                                                                                                                                                                                                                                                                                                                                                   | 818   | 2025-06-17  |
| [Madmin](https://github.com/excid3/madmin)                          | A robust Admin Interface for Ruby on Rails apps                                                                                                                                                                                                                                                                                                                                                                                                     | 686   | 2025-09-02  |

[Back to Top](#table-of-contents)

## Analytics

| Name                                                               | Description                                                                                        | Stars | Last Commit |
|--------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------|-------------|
| [Ahoy](https://github.com/ankane/ahoy)                             | A solid foundation to track visits and events in Ruby, JavaScript, and native apps.                | 4372  | 2025-06-22  |
| [Impressionist](https://github.com/charlotte-ruby/impressionist)   | Rails Plugin that tracks impressions and page views.                                               | 1534  | 2024-08-14  |
| [Rack::Tracker](https://github.com/railslove/rack-tracker)         | Rack middleware that can be hooked up to multiple services and exposing them in a unified fashion. | 648   | 2024-03-19  |
| [ActiveAnalytics](https://github.com/BaseSecrete/active_analytics) | First-party, privacy-focused traffic analytics for Ruby on Rails applications.                     | 506   | 2025-03-13  |

[Back to Top](#table-of-contents)

## Assets

| Name                                                     | Description                                                     | Stars | Last Commit |
|----------------------------------------------------------|-----------------------------------------------------------------|-------|-------------|
| [Bourbon](https://github.com/thoughtbot/bourbon)         | A Lightweight Sass Tool Set.                                    | 9058  | 2024-09-13  |
| [Asset Sync](https://github.com/AssetSync/asset_sync)    | Synchronises Assets between Rails and S3.                       | 1893  | 2025-09-01  |
| [Vite Ruby](https://github.com/elmassimo/vite_ruby)      | Use Vite.js as a modern assets pipeline in Ruby and Rails apps. | 1503  | 2025-08-29  |
| [bower-rails](https://github.com/rharriso/bower-rails)   | Bower support for Rails projects.                               | 1456  | 2023-04-24  |
| [Autoprefixer](https://github.com/ai/autoprefixer-rails) | Parse CSS and add vendor prefixes to rules by Can I Use.        | 1214  | 2025-04-12  |
| [Sprockets](https://github.com/rails/sprockets)          | Rack-based asset packaging system.                              | 966   | 2025-04-19  |

[Back to Top](#table-of-contents)

## Authentication and OAuth

| Name                                                                      | Description                                                                          | Stars | Last Commit |
|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------|-------|-------------|
| [Devise](https://github.com/heartcombo/devise)                            | A flexible authentication solution for Rails based on Warden.                        | 24232 | 2025-05-28  |
| [OmniAuth](https://github.com/omniauth/omniauth)                          | A library that standardizes multi-provider authentication utilizing Rack middleware. | 8012  | 2025-05-15  |
| [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)                | An OAuth2 provider for Rails.                                                        | 5428  | 2025-08-29  |
| [Authlogic](https://github.com/binarylogic/authlogic)                     | Authlogic is a clean, simple, and unobtrusive ruby authentication solution.          | 4347  | 2025-04-11  |
| [Clearance](https://github.com/thoughtbot/clearance)                      | Small and simple email & password based authentication for Rails.                    | 3730  | 2025-09-08  |
| [JWT](https://github.com/jwt/ruby-jwt)                                    | JSON Web Token implementation in Ruby.                                               | 3655  | 2025-06-29  |
| [Rodauth](https://github.com/jeremyevans/rodauth)                         | Authentication and account management framework for Rack applications.               | 1829  | 2025-08-22  |
| [Authentication Zero](https://github.com/lazaronixon/authentication-zero) | An authentication system generator for Rails applications.                           | 1815  | 2024-12-05  |
| [Sorcery](https://github.com/Sorcery/sorcery)                             | A stripped-down, bare-bones authentication library for Rails.                        | 1456  | 2025-08-12  |

[Back to Top](#table-of-contents)

## Authorization

| Name                                                        | Description                                                                                                | Stars | Last Commit |
|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|-------|-------------|
| [CanCanCan](https://github.com/CanCanCommunity/cancancan)   | Continuation of CanCan, an authorization Gem for Ruby on Rails.                                            | 5654  | 2025-01-27  |
| [ActionPolicy](https://github.com/palkan/action_policy)     | Authorization framework for Ruby and Rails applications. Composable, extensible and performant.            | 1487  | 2025-05-09  |
| [acl9](https://github.com/be9/acl9)                         | Acl9 is a role-based authorization system that provides a concise DSL for securing your Rails application. | 852   | 2025-03-26  |
| [AccessGranted](https://github.com/chaps-io/access-granted) | Multi-role and whitelist based authorization gem for Rails.                                                | 777   | 2024-05-08  |

[Back to Top](#table-of-contents)

## Automation

| Name                                                               | Description                                                                       | Stars | Last Commit |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------|-------|-------------|
| [Danger](https://github.com/danger/danger)                         | Automate your team's conventions surrounding code review.                         | 5596  | 2025-08-19  |
| [ActiveWorkflow](https://github.com/automaticmode/active_workflow) | An intelligent process and workflow automation platform based on software agents. | 862   | 2023-04-03  |
| [Runbook](https://github.com/braintree/runbook)                    | A framework and Ruby DSL for progressive system automation.                       | 753   | 2023-08-24  |

[Back to Top](#table-of-contents)

## Breadcrumbs

| Name                                                                   | Description                                                                                                                                | Stars | Last Commit |
|------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Breadcrumbs on Rails](https://github.com/weppos/breadcrumbs_on_rails) | A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project.                                       | 956   | 2024-12-11  |
| [Gretel](https://github.com/lassebunk/gretel)                          | A Ruby on Rails plugin that makes it easy yet flexible to create breadcrumbs.                                                              | 889   | 2024-09-01  |
| [Simple Navigation](https://github.com/codeplant/simple-navigation)    | A ruby gem for creating navigation (html list, link list or breadcrumbs with multiple levels) for your Rails 2, 3 & 4, Sinatra or Padrino. | 888   | 2023-07-27  |

[Back to Top](#table-of-contents)

## Business logic

| Name                                                                      | Description                                                                                                         | Stars | Last Commit |
|---------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Interactor](https://github.com/collectiveidea/interactor)                | Interactor provides a common interface for performing complex interactions in a single request.                     | 3432  | 2025-07-10  |
| [wisper](https://github.com/krisleech/wisper)                             | A micro library providing Ruby objects with Publish-Subscribe capabilities.                                         | 3319  | 2024-08-15  |
| [ActiveInteraction](https://github.com/AaronLasseigne/active_interaction) | Manage application specific business logic.                                                                         | 2118  | 2025-07-18  |
| [Mutations](https://github.com/cypriss/mutations)                         | Compose your business logic into commands that sanitize and validate input.                                         | 1395  | 2023-01-17  |
| [Light Service](https://github.com/adomokos/light-service)                | Series of Actions with an emphasis on simplicity.                                                                   | 866   | 2025-08-18  |
| [Waterfall](https://github.com/apneadiving/waterfall)                     | A slice of functional programming to chain ruby services and blocks, thus providing a new approach to flow control. | 616   | 2020-03-11  |

[Back to Top](#table-of-contents)

## CLI Builder

| Name                                                   | Description                                              | Stars | Last Commit |
|--------------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [Rake](https://github.com/ruby/rake)                   | A make-like build utility for Ruby.                      | 2401  | 2025-09-01  |
| [GLI](https://github.com/davetron5000/gli)             | Git-Like Interface Command Line Parser.                  | 1268  | 2025-03-09  |
| [Slop](https://github.com/leejarvis/slop)              | Simple Lightweight Option Parsing.                       | 1130  | 2025-08-27  |
| [Commander](https://github.com/commander-rb/commander) | The complete solution for Ruby command-line executables. | 820   | 2024-01-15  |

[Back to Top](#table-of-contents)

## CLI Utilities

| Name                                                              | Description                                                                                                      | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Tmuxinator](https://github.com/tmuxinator/tmuxinator)            | Create and manage complex tmux sessions easily.                                                                  | 13184 | 2025-09-02  |
| [colorls](https://github.com/athityakumar/colorls)                | Beautifies the `ls` command, with color and font-awesome icons.                                                  | 5068  | 2025-06-09  |
| [Awesome Print](https://github.com/awesome-print/awesome_print)   | Pretty print your Ruby objects with style -- in full color and with proper indentation                           | 4083  | 2024-08-15  |
| [Betty](https://github.com/pickhardt/betty)                       | Friendly English-like interface for your command line. Don't remember a command? Ask Betty.                      | 2611  | 2021-06-24  |
| [Ruby/Progressbar](https://github.com/jfelchner/ruby-progressbar) | The most flexible text progress bar library for Ruby.                                                            | 1582  | 2024-06-12  |
| [Terminal Table](https://github.com/tj/terminal-table)            | Ruby ASCII Table Generator, simple and feature rich.                                                             | 1566  | 2025-09-01  |
| [colorize](https://github.com/fazibear/colorize)                  | Extends String class or add a ColorizedString with methods to set text color, background color and text effects. | 1273  | 2024-05-21  |
| [TablePrint](https://github.com/arches/table_print)               | Slice your data from multiple DB tables into a single CLI view.                                                  | 903   | 2023-03-21  |

[Back to Top](#table-of-contents)

## CMS

| Name                                                                        | Description                                                     | Stars | Last Commit |
|-----------------------------------------------------------------------------|-----------------------------------------------------------------|-------|-------------|
| [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) | Powerful Rails 5.2+ CMS Engine.                                 | 2726  | 2024-05-27  |
| [Publify](https://github.com/publify/publify)                               | A self hosted Web publishing platform on Rails.                 | 1850  | 2025-09-07  |
| [Fae](https://github.com/wearefine/fae)                                     | Flexible, open source, Rails CMS engine.                        | 849   | 2025-09-02  |
| [Storytime](https://github.com/CultivateLabs/storytime)                     | Rails 4+ CMS and blogging engine, with a core focus on content. | 748   | 2024-10-16  |

[Back to Top](#table-of-contents)

## CRM

| Name                                                       | Description                                                                   | Stars | Last Commit |
|------------------------------------------------------------|-------------------------------------------------------------------------------|-------|-------------|
| [Fat Free CRM](https://github.com/fatfreecrm/fat_free_crm) | An open source Ruby on Rails based customer relationship management platform. | 3620  | 2025-09-08  |

[Back to Top](#table-of-contents)

## Caching

| Name                                                       | Description                                                           | Stars | Last Commit |
|------------------------------------------------------------|-----------------------------------------------------------------------|-------|-------------|
| [IdentityCache](https://github.com/Shopify/identity_cache) | A blob level caching solution to plug into ActiveRecord.              | 1940  | 2025-09-01  |
| [Readthis](https://github.com/sorentwo/readthis)           | High performance, pooled, ActiveSupport compliant caching with Redis. | 501   | 2019-09-30  |

[Back to Top](#table-of-contents)

## Captchas and anti-spam

| Name                                                              | Description                                                                                                                 | Stars | Last Commit |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [reCAPTCHA](https://github.com/ambethia/recaptcha)                | reCaptcha API helpers for ruby apps.                                                                                        | 1999  | 2025-07-21  |
| [Invisible Captcha](https://github.com/markets/invisible_captcha) | Unobtrusive and flexible spam protection based on the honeypot strategy. It also provides a time-sensitive form submission. | 1224  | 2025-01-30  |

[Back to Top](#table-of-contents)

## Cloud

| Name                                                    | Description                      | Stars | Last Commit |
|---------------------------------------------------------|----------------------------------|-------|-------------|
| [Fog](https://github.com/fog/fog)                       | The Ruby cloud services library. | 4319  | 2024-11-19  |
| [AWS SDK for Ruby](https://github.com/aws/aws-sdk-ruby) | The official AWS SDK for Ruby.   | 3622  | 2025-09-05  |

[Back to Top](#table-of-contents)

## Code Analysis and Metrics

| Name                                                   | Description                                                                                                                                                                                                  | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Scientist](https://github.com/github/scientist)       | A Ruby library for carefully refactoring critical paths.                                                                                                                                                     | 7613  | 2025-08-18  |
| [Brakeman](https://github.com/presidentbeef/brakeman)  | A static analysis security vulnerability scanner for Ruby on Rails applications.                                                                                                                             | 7138  | 2025-09-05  |
| [Reek](https://github.com/troessner/reek)              | Code smell detector for Ruby.                                                                                                                                                                                | 4104  | 2025-09-07  |
| [Sorbet](https://github.com/sorbet/sorbet)             | A static type checker for Ruby.                                                                                                                                                                              | 3722  | 2025-09-08  |
| [Rubycritic](https://github.com/whitesmith/rubycritic) | A Ruby code quality reporter.                                                                                                                                                                                | 3425  | 2025-07-30  |
| [Coverband](https://github.com/danmayer/coverband)     | Rack middleware to help measure production code coverage.                                                                                                                                                    | 2585  | 2025-08-27  |
| [Fasterer](https://github.com/DamirSvrtan/fasterer)    | Make your Rubies go faster with this command line tool highly inspired by fast-ruby and Sferik's talk at Baruco Conf.                                                                                        | 1817  | 2024-06-14  |
| [Suture](https://github.com/testdouble/suture)         | A Ruby gem that helps you refactor your legacy code.                                                                                                                                                         | 1412  | 2023-09-29  |
| [Flog](https://github.com/seattlerb/flog)              | Flog reports the most tortured code in an easy to read pain report. The higher the score, the more pain the code is in.                                                                                      | 951   | 2023-09-28  |
| [Traceroute](https://github.com/amatsuda/traceroute)   | A Rake task gem that helps you find the dead routes and actions for your Rails 3+ app                                                                                                                        | 904   | 2025-04-29  |
| [Flay](https://github.com/seattlerb/flay)              | Flay analyzes code for structural similarities. Differences in literal values, variable, class, method names, whitespace, programming style, braces vs do/end, etc are all ignored. Making this totally rad. | 750   | 2024-06-23  |
| [MetricFu](https://github.com/metricfu/metric_fu)      | A fist full of code metrics.                                                                                                                                                                                 | 625   | 2024-02-27  |

[Back to Top](#table-of-contents)

## Code Formatting

| Name                                                | Description                              | Stars | Last Commit |
|-----------------------------------------------------|------------------------------------------|-------|-------------|
| [prettier](https://github.com/prettier/plugin-ruby) | A prettier plugin for the Ruby language. | 1485  | 2025-03-06  |

[Back to Top](#table-of-contents)

## Code Highlighting

| Name                                           | Description                                               | Stars | Last Commit |
|------------------------------------------------|-----------------------------------------------------------|-------|-------------|
| [CodeRay](https://github.com/rubychan/coderay) | Fast and easy syntax highlighting for selected languages. | 849   | 2025-09-05  |

[Back to Top](#table-of-contents)

## Code Loaders

| Name                                        | Description                                    | Stars | Last Commit |
|---------------------------------------------|------------------------------------------------|-------|-------------|
| [Zeitwerk](https://github.com/fxn/zeitwerk) | An efficient and thread-safe Ruby code loader. | 2072  | 2025-06-07  |

[Back to Top](#table-of-contents)

## Coding Style Guides

| Name                                               | Description                                                | Stars | Last Commit |
|----------------------------------------------------|------------------------------------------------------------|-------|-------------|
| [Best-Ruby](https://github.com/franzejr/best-ruby) | Ruby Tricks, Idiomatic Ruby, Refactoring & Best Practices. | 2398  | 2023-04-12  |

[Back to Top](#table-of-contents)

## Concurrency and Parallelism

| Name                                                                   | Description                                                                                                                                                                                    | Stars | Last Commit |
|------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Concurrent Ruby](https://github.com/ruby-concurrency/concurrent-ruby) | Modern concurrency tools including agents, futures, promises, thread pools, supervisors, and more. Inspired by Erlang, Clojure, Scala, Go, Java, JavaScript, and classic concurrency patterns. | 5767  | 2025-08-26  |
| [EventMachine](https://github.com/eventmachine/eventmachine)           | An event-driven I/O and lightweight concurrency library for Ruby.                                                                                                                              | 4282  | 2024-09-16  |
| [Parallel](https://github.com/grosser/parallel)                        | Run any code in parallel Processes (> use all CPUs) or Threads (> speedup blocking operations). Best suited for map-reduce or e.g. parallel downloads/uploads.                                 | 4216  | 2025-04-14  |
| [Polyphony](https://github.com/digital-fabric/polyphony)               | Fine-grained concurrency for Ruby.                                                                                                                                                             | 663   | 2024-03-25  |

[Back to Top](#table-of-contents)

## Configuration

| Name                                                    | Description                                                                                                        | Stars | Last Commit |
|---------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [dotenv](https://github.com/bkeepers/dotenv)            | Loads environment variables from `.env`.                                                                           | 6688  | 2025-08-11  |
| [Figaro](https://github.com/laserlemon/figaro)          | Simple, Heroku-friendly Rails app configuration using `ENV` and a single YAML file.                                | 3750  | 2025-06-29  |
| [AnywayConfig](https://github.com/palkan/anyway_config) | Configuration library for Ruby gems and applications, supporting multiple sources (yml, secrets) and environments. | 852   | 2025-06-24  |
| [Configatron](https://github.com/markbates/configatron) | Simple and feature rich configuration system for Ruby apps.                                                        | 596   | 2024-05-12  |
| [Sail](https://github.com/vinistock/sail)               | A lightweight Rails engine that brings an admin panel for managing configuration settings on a live Rails app.     | 507   | 2023-01-30  |

[Back to Top](#table-of-contents)

## Core Extensions

| Name                                                      | Description                                                                                                                                                                                                            | Stars | Last Commit |
|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Virtus](https://github.com/solnic/virtus)                | Attributes on Steroids for Plain Old Ruby Objects.                                                                                                                                                                     | 3760  | 2021-08-10  |
| [Hamster](https://github.com/hamstergem/hamster)          | Efficient, immutable, and thread-safe collection classes for Ruby.                                                                                                                                                     | 1882  | 2021-11-30  |
| [Addressable](https://github.com/sporkmonger/addressable) | Addressable is a replacement for the URI implementation that is part of Ruby's standard library. It more closely conforms to RFC 3986, RFC 3987, and RFC 6570 (level 4), providing support for IRIs and URI templates. | 1586  | 2025-08-11  |
| [ActiveAttr](https://github.com/cgriego/active_attr)      | What ActiveModel left out.                                                                                                                                                                                             | 1199  | 2024-12-26  |
| [Ruby Facets](https://github.com/rubyworks/facets)        | The premiere collection of general purpose method extensions and standard additions for Ruby.                                                                                                                          | 801   | 2023-10-19  |
| [MemoWise](https://github.com/panorama-ed/memo_wise)      | Memoize any instance/class/module method, including support for frozen objects - rigorously tested and benchmarked on all Rubies - fast performance of memoized reads.                                                 | 622   | 2025-09-05  |
| [AttrExtras](https://github.com/barsoom/attr_extras)      | Takes some boilerplate out of Ruby with methods like attr_initialize.                                                                                                                                                  | 563   | 2025-08-12  |

[Back to Top](#table-of-contents)

## Country Data

| Name                                           | Description                                                                            | Stars | Last Commit |
|------------------------------------------------|----------------------------------------------------------------------------------------|-------|-------------|
| [Phonelib](https://github.com/daddyz/phonelib) | Ruby gem for phone validation and formatting using Google libphonenumber library data. | 1124  | 2025-07-24  |
| [Phony](https://github.com/floere/phony)       | Fast international phone number (E164 standard) normalizing, splitting and formatting. | 1073  | 2025-08-18  |

[Back to Top](#table-of-contents)

## Dashboards

| Name                                                        | Description                                                          | Stars | Last Commit |
|-------------------------------------------------------------|----------------------------------------------------------------------|-------|-------------|
| [Blazer](https://github.com/ankane/blazer)                  | Simple data viewer using only SQL. Output to table, chart, and maps. | 4714  | 2025-09-05  |
| [Dashing-Rails](https://github.com/gottfrois/dashing-rails) | The exceptionally handsome dashboard framework for Rails.            | 1449  | 2020-01-06  |

[Back to Top](#table-of-contents)

## Data Processing and ETL

| Name                                                   | Description                                                                                   | Stars | Last Commit |
|--------------------------------------------------------|-----------------------------------------------------------------------------------------------|-------|-------------|
| [Multiwoven](https://github.com/Multiwoven/multiwoven) | The open-source reverse ETL, data activation platform developed using Ruby and Ruby on Rails. | 1618  | 2025-09-08  |

[Back to Top](#table-of-contents)

## Data Visualization

| Name                                                            | Description                                                                                                                                           | Stars | Last Commit |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Rails Erd](https://github.com/voormedia/rails-erd)             | Generate Entity-Relationship Diagrams for Rails applications.                                                                                         | 4068  | 2023-10-12  |
| [RailRoady](https://github.com/preston/railroady)               | Ruby on Rails 3/4 model and controller UML class diagram generator.                                                                                   | 1711  | 2023-08-02  |
| [GeoPattern](https://github.com/jasonlong/geo_pattern)          | Create beautiful generative geometric background images from a string.                                                                                | 1268  | 2025-04-22  |
| [LazyHighCharts](https://github.com/michelson/lazy_high_charts) | A simple and extremely flexible way to use HighCharts from ruby code. Tested on Ruby on Rails, Sinatra and Nanoc, but it should work with others too. | 1050  | 2023-02-11  |
| [Ruby/GraphViz](https://github.com/glejeune/Ruby-Graphviz)      | Ruby interface to the GraphViz graphing tool.                                                                                                         | 620   | 2025-03-16  |

[Back to Top](#table-of-contents)

## Database Drivers

| Name                                                                            | Description                                                                                            | Stars | Last Commit |
|---------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------|-------------|
| [redis-rb](https://github.com/redis/redis-rb)                                   | A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface. | 3986  | 2025-08-11  |
| [mysql2](https://github.com/brianmario/mysql2)                                  | A modern, simple and very fast Mysql library for Ruby (binding to libmysql).                           | 2265  | 2025-07-29  |
| [mongo-ruby-driver](https://github.com/mongodb/mongo-ruby-driver)               | MongoDB Ruby driver.                                                                                   | 1433  | 2025-09-04  |
| [SQL Server](https://github.com/rails-sqlserver/activerecord-sqlserver-adapter) | The SQL Server adapter for ActiveRecord.                                                               | 982   | 2025-09-01  |
| [ruby-pg](https://github.com/ged/ruby-pg)                                       | Ruby interface to PostgreSQL 8.3 and later.                                                            | 834   | 2025-09-02  |
| [SQLite3](https://github.com/sparklemotion/sqlite3-ruby)                        | Ruby bindings for the SQLite3 embedded database.                                                       | 813   | 2025-09-01  |
| [Trilogy](https://github.com/trilogy-libraries/trilogy)                         | A performance-oriented C library for MySQL-compatible databases.                                       | 740   | 2025-09-04  |
| [TinyTDS](https://github.com/rails-sqlserver/tiny_tds)                          | FreeTDS bindings for Ruby using DB-Library.                                                            | 619   | 2025-09-08  |
| [Neography](https://github.com/maxdemarzi/neography)                            | A thin Ruby wrapper to the Neo4j Rest API.                                                             | 604   | 2017-02-27  |

[Back to Top](#table-of-contents)

## Database Tools

| Name                                                                    | Description                                                                                                                                  | Stars | Last Commit |
|-------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [PgHero](https://github.com/ankane/pghero)                              | Postgres insights made easy.                                                                                                                 | 8582  | 2025-09-05  |
| [Strong Migrations](https://github.com/ankane/strong_migrations)        | Catch unsafe migrations in development.                                                                                                      | 4265  | 2025-09-05  |
| [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner) | Database Cleaner is a set of strategies for cleaning your database in Ruby.                                                                  | 2952  | 2025-07-07  |
| [Large Hadron Migrator](https://github.com/soundcloud/lhm)              | Online MySQL schema migrations without locking the table.                                                                                    | 1851  | 2023-08-30  |
| [connection_pool](https://github.com/mperham/connection_pool)           | Generic connection pooling for Ruby, that can be used with anything, e.g. Redis, Dalli, etc.                                                 | 1656  | 2025-09-01  |
| [Lol DBA](https://github.com/plentz/lol_dba)                            | Scan your models and displays a list of columns that probably should be indexed.                                                             | 1594  | 2024-03-07  |
| [Rails DB](https://github.com/igorkasyanchuk/rails_db)                  | Database Viewer and SQL Query Runner.                                                                                                        | 1480  | 2025-07-09  |
| [Seed dump](https://github.com/rroblak/seed_dump)                       | Rails 4 task to dump (parts) of your database to db/seeds.rb.                                                                                | 1391  | 2025-04-28  |
| [Foreigner](https://github.com/matthuhiggins/foreigner)                 | Adds foreign key helpers to migrations and correctly dumps foreign keys to schema.rb.                                                        | 1321  | 2019-02-06  |
| [Seed Fu](https://github.com/mbleigh/seed-fu)                           | Advanced seed data handling for Rails.                                                                                                       | 1236  | 2022-08-09  |
| [Seedbank](https://github.com/james2m/seedbank)                         | Seedbank allows you to structure your Rails seed data instead of having it all dumped into one large file.                                   | 1143  | 2023-12-07  |
| [Database Consistency](https://github.com/djezzzl/database_consistency) | An easy way to check that application constraints and database constraints are in sync.                                                      | 1135  | 2025-08-22  |
| [Polo](https://github.com/IFTTT/polo)                                   | Creates sample database snapshots to work with real world data in development.                                                               | 772   | 2025-08-12  |
| [Online Migrations](https://github.com/fatkodima/online_migrations)     | Catch unsafe PostgreSQL migrations in development and run them easier in production.                                                         | 700   | 2025-08-18  |
| [SchemaPlus](https://github.com/SchemaPlus/schema_plus)                 | SchemaPlus provides a collection of enhancements and extensions to ActiveRecord                                                              | 677   | 2022-05-13  |
| [Rein](https://github.com/nullobject/rein)                              | Database constraints made easy for ActiveRecord.                                                                                             | 669   | 2020-10-27  |
| [Upsert](https://github.com/seamusabshere/upsert)                       | Upsert on MySQL, PostgreSQL, and SQLite3. Transparently creates functions (UDF) for MySQL and PostgreSQL; on SQLite3, uses INSERT OR IGNORE. | 649   | 2021-02-20  |

[Back to Top](#table-of-contents)

## Date and Time Processing

| Name                                                                  | Description                                                                              | Stars | Last Commit |
|-----------------------------------------------------------------------|------------------------------------------------------------------------------------------|-------|-------------|
| [groupdate](https://github.com/ankane/groupdate)                      | The simplest way to group temporal data in ActiveRecord, arrays and hashes.              | 3857  | 2025-09-05  |
| [Chronic](https://github.com/mojombo/chronic)                         | A natural language date/time parser written in pure Ruby.                                | 3252  | 2023-09-28  |
| [local_time](https://github.com/basecamp/local_time)                  | Rails Engine for cache-friendly, client-side local time.                                 | 1981  | 2025-03-12  |
| [validates_timeliness](https://github.com/adzap/validates_timeliness) | Date and time validation plugin for ActiveModel and Rails.                               | 1610  | 2025-05-30  |
| [business_time](https://github.com/bokmann/business_time)             | Support for doing time math in business hours and days.                                  | 1313  | 2025-01-07  |
| [ByStar](https://github.com/radar/by_star)                            | Find ActiveRecord objects by year, month, fortnight, week and more!                      | 1052  | 2023-01-18  |
| [stamp](https://github.com/jeremyw/stamp)                             | Format dates and times based on human-friendly examples, not arcane strftime directives. | 961   | 2020-07-22  |
| [montrose](https://github.com/rossta/montrose)                        | a simple library for expressing, serializing, and enumerating recurring events in Ruby.  | 853   | 2025-01-25  |
| [holidays](https://github.com/holidays/holidays)                      | A collection of Ruby methods to deal with statutory and other holidays.                  | 838   | 2024-08-11  |
| [working_hours](https://github.com/intrepidd/working_hours)           | A modern ruby gem allowing to do time calculation with working hours.                    | 530   | 2025-09-08  |

[Back to Top](#table-of-contents)

## Debugging Tools

| Name                                                                    | Description                                              | Stars | Last Commit |
|-------------------------------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [Byebug](https://github.com/deivid-rodriguez/byebug)                    | A simple to use, feature rich debugger for Ruby 2.       | 3347  | 2025-09-04  |
| [Pry Byebug](https://github.com/deivid-rodriguez/pry-byebug)            | Pry navigation commands via byebug.                      | 2016  | 2025-09-02  |
| [Seeing Is Believing](https://github.com/JoshCheek/seeing_is_believing) | Displays the results of every line of code in your file. | 1314  | 2022-03-18  |
| [Xray](https://github.com/brentd/xray-rails)                            | A development tool that reveals your UI's bones.         | 1223  | 2024-12-07  |

[Back to Top](#table-of-contents)

## Decorators

| Name                                                             | Description                                                                           | Stars | Last Commit |
|------------------------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [Draper](https://github.com/drapergem/draper)                    | Draper adds an object-oriented layer of presentation logic to your Rails application. | 5261  | 2025-03-06  |
| [Responders](https://github.com/heartcombo/responders)           | A set of Rails responders to dry up your application.                                 | 2047  | 2024-04-22  |
| [Decent Exposure](https://github.com/hashrocket/decent_exposure) | A helper for creating declarative interfaces in controllers.                          | 1805  | 2023-04-11  |

[Back to Top](#table-of-contents)

## DevOps Tools

| Name                                               | Description                                                                                                                                                                                                                       | Stars | Last Commit |
|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Logstash](https://github.com/elastic/logstash)    | Logs/event transport, processing, management, search.                                                                                                                                                                             | 14626 | 2025-09-08  |
| [Kamal](https://github.com/basecamp/kamal)         | Kamal offers zero-downtime deploys, rolling restarts, asset bridging, remote builds, accessory service management, and everything else you need to deploy and manage your web app in production with Docker.                      | 13174 | 2025-08-11  |
| [Chef](https://github.com/chef/chef)               | A systems integration framework, built to bring the benefits of configuration management to your entire infrastructure.                                                                                                           | 7976  | 2025-09-08  |
| [Puppet](https://github.com/puppetlabs/puppet)     | An automated administrative engine for your Linux, Unix, and Windows systems, performs administrative tasks (such as adding users, installing packages, and updating server configurations) based on a centralized specification. | 7678  | 2025-02-04  |
| [Backup](https://github.com/backup/backup)         | Provides an elegant DSL in Ruby for performing backups on UNIX-like systems.                                                                                                                                                      | 4861  | 2024-07-03  |
| [Mina](https://github.com/mina-deploy/mina)        | Really fast deployer and server automation tool.                                                                                                                                                                                  | 4363  | 2024-08-01  |
| [BOSH](https://github.com/cloudfoundry/bosh)       | Cloud Foundry BOSH is an open source tool chain for release engineering, deployment and lifecycle management of large scale distributed services.                                                                                 | 2056  | 2025-09-06  |
| [Centurion](https://github.com/newrelic/centurion) | A mass deployment tool for Docker fleets.                                                                                                                                                                                         | 1760  | 2024-08-26  |
| [Rubber](https://github.com/rubber/rubber)         | The rubber plugin enables relatively complex multi-instance deployments of RubyOnRails applications to Amazon's Elastic Compute Cloud (EC2).                                                                                      | 1463  | 2020-11-23  |
| [Itamae](https://github.com/itamae-kitchen/itamae) | Simple and lightweight configuration management tool inspired by Chef.                                                                                                                                                            | 1126  | 2025-09-02  |

[Back to Top](#table-of-contents)

## Diff

| Name                                   | Description             | Stars | Last Commit |
|----------------------------------------|-------------------------|-------|-------------|
| [Diffy](https://github.com/samg/diffy) | Easy Diffing With Ruby. | 1291  | 2025-06-09  |

[Back to Top](#table-of-contents)

## Discover

| Name                                                           | Description                                  | Stars | Last Commit |
|----------------------------------------------------------------|----------------------------------------------|-------|-------------|
| [Ruby Bookmarks](https://github.com/dreikanter/ruby-bookmarks) | Ruby and Ruby on Rails bookmarks collection. | 2263  | 2025-08-21  |

[Back to Top](#table-of-contents)

## Documentation

| Name                                                                                                   | Description                                                                                                                                  | Stars | Last Commit |
|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Gollum](https://github.com/gollum/gollum)                                                             | A simple, Git-powered wiki with a sweet API and local frontend.                                                                              | 14125 | 2025-08-31  |
| [GitHub Changelog Generator](https://github.com/github-changelog-generator/github-changelog-generator) | Automatically generate change log from your tags, issues, labels and pull requests on GitHub.                                                | 7483  | 2024-11-26  |
| [Apipie](https://github.com/Apipie/apipie-rails)                                                       | Rails API documentation and display tool using Ruby syntax.                                                                                  | 2500  | 2025-08-19  |
| [Hologram](https://github.com/trulia/hologram)                                                         | A markdown based documentation system for style guides. It parses comments in your CSS and helps you turn them into a beautiful style guide. | 2160  | 2023-08-10  |
| [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)                          | Automatically generate API documentation from RSpec.                                                                                         | 1459  | 2025-07-24  |
| [grape-swagger](https://github.com/ruby-grape/grape-swagger)                                           | Add swagger compliant documentation to your Grape API.                                                                                       | 1098  | 2025-09-02  |
| [RDoc](https://github.com/ruby/rdoc)                                                                   | RDoc produces HTML and command-line documentation for Ruby projects.                                                                         | 869   | 2025-09-07  |
| [Inch](https://github.com/rrrene/inch)                                                                 | Inch is a documentation measurement and evalutation tool for Ruby code, based on YARD.                                                       | 518   | 2024-01-12  |

[Back to Top](#table-of-contents)

## E-Commerce and Payments

| Name                                                                 | Description                                                            | Stars | Last Commit |
|----------------------------------------------------------------------|------------------------------------------------------------------------|-------|-------------|
| [Spree](https://github.com/spree/spree)                              | Spree is a complete open source e-commerce solution for Ruby on Rails. | 14906 | 2025-09-08  |
| [Solidus](https://github.com/solidusio/solidus)                      | An open source, eCommerce application for high volume retailers.       | 5197  | 2025-09-06  |
| [Active Merchant](https://github.com/activemerchant/active_merchant) | A simple payment abstraction library extracted from Shopify.           | 4590  | 2025-07-23  |
| [stripe-ruby](https://github.com/stripe/stripe-ruby)                 | Stripe Ruby bindings.                                                  | 2043  | 2025-09-08  |
| [ROR Ecommerce](https://github.com/drhenner/ror_ecommerce)           | A Rails e-commerce platform.                                           | 1215  | 2023-06-13  |

[Back to Top](#table-of-contents)

## Ebook

| Name                                      | Description                                            | Stars | Last Commit |
|-------------------------------------------|--------------------------------------------------------|-------|-------------|
| [Review](https://github.com/kmuto/review) | Re:VIEW is flexible document format/conversion system. | 1371  | 2025-09-05  |

[Back to Top](#table-of-contents)

## Email

| Name                                                           | Description                                                                                                                                    | Stars | Last Commit |
|----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [LetterOpener](https://github.com/ryanb/letter_opener)         | Preview mail in the browser instead of sending.                                                                                                | 3787  | 2024-08-02  |
| [Mail](https://github.com/mikel/mail)                          | A Really Ruby Mail Library.                                                                                                                    | 3652  | 2025-03-20  |
| [premailer-rails](https://github.com/fphilipe/premailer-rails) | CSS styled emails without the hassle.                                                                                                          | 1727  | 2024-06-17  |
| [Griddler](https://github.com/thoughtbot/griddler)             | Simplify receiving email in Rails.                                                                                                             | 1369  | 2024-07-12  |
| [Roadie](https://github.com/Mange/roadie)                      | Roadie tries to make sending HTML emails a little less painful by inlining stylesheets and rewriting relative URLs for you inside your emails. | 1342  | 2025-04-02  |
| [Ahoy Email](https://github.com/ankane/ahoy_email)             | Analytics and tracking for e-mails.                                                                                                            | 1168  | 2025-09-05  |
| [Pony](https://github.com/benprew/pony)                        | The express way to send mail from Ruby.                                                                                                        | 1137  | 2025-04-08  |
| [Gibbon](https://github.com/amro/gibbon)                       | API wrapper for the Mailchimp e-mail marketing platform.                                                                                       | 1066  | 2023-06-07  |
| [Sup](https://github.com/sup-heliotrope/sup)                   | A curses threads-with-tags style email client.                                                                                                 | 914   | 2025-05-18  |
| [MailForm](https://github.com/heartcombo/mail_form)            | Send e-mail straight from forms in Rails with I18n, validations, attachments and request information.                                          | 877   | 2025-09-05  |
| [Maily](https://github.com/markets/maily)                      | A Rails Engine to manage, test and navigate through all your email templates of your app, being able to preview them directly in your browser. | 708   | 2024-03-17  |

[Back to Top](#table-of-contents)

## Encryption

| Name                                            | Description                                                                                                                                                     | Stars | Last Commit |
|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Themis](https://github.com/cossacklabs/themis) | crypto library for painless data security, providing symmetric and asymmetric encryption, secure sockets with forward secrecy, for mobile and server platforms. | 1936  | 2025-07-16  |

[Back to Top](#table-of-contents)

## Environment Management

| Name                                                       | Description                                                                | Stars | Last Commit |
|------------------------------------------------------------|----------------------------------------------------------------------------|-------|-------------|
| [chruby](https://github.com/postmodern/chruby)             | Change your current Ruby. No shims, no crazy options or features, ~90 LOC. | 2896  | 2025-05-16  |
| [ruby-install](https://github.com/postmodern/ruby-install) | Installs Ruby, JRuby, Rubinius, MagLev or MRuby.                           | 1951  | 2025-07-23  |

[Back to Top](#table-of-contents)

## Error Handling

| Name                                                                            | Description                                                                                 | Stars | Last Commit |
|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|-------|-------------|
| [Errbit](https://github.com/errbit/errbit)                                      | The open source, self-hosted error catcher.                                                 | 4269  | 2025-09-07  |
| [Exception Notification](https://github.com/smartinez87/exception_notification) | A set of notifiers for sending notifications when errors occur in a Rack/Rails application. | 2189  | 2025-03-22  |
| [Sentry Ruby](https://github.com/getsentry/sentry-ruby)                         | The Ruby client for Sentry.                                                                 | 977   | 2025-09-04  |
| [Airbrake](https://github.com/airbrake/airbrake)                                | The official Airbrake library for Ruby on Rails (and other Rack based frameworks).          | 973   | 2024-12-21  |
| [Exception Handler](https://github.com/richpeck/exception_handler)              | Custom error pages.                                                                         | 510   | 2021-07-31  |

[Back to Top](#table-of-contents)

## Event Sourcing

| Name                                                                            | Description                                                                                                                                                          | Stars | Last Commit |
|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Rails Event Store (RES)](https://github.com/RailsEventStore/rails_event_store) | A library for publishing, consuming, storing and retrieving events. It's your best companion for going with an event-driven architecture for your Rails application. | 1477  | 2025-08-05  |

[Back to Top](#table-of-contents)

## Feature Flippers and A/B Testing

| Name                                          | Description                                                    | Stars | Last Commit |
|-----------------------------------------------|----------------------------------------------------------------|-------|-------------|
| [Rollout](https://github.com/FetLife/rollout) | Feature flippers.                                              | 2895  | 2025-08-06  |
| [Split](https://github.com/splitrb/split)     | Rack Based AB testing framework.                               | 2709  | 2025-08-04  |
| [Vanity](https://github.com/assaf/vanity)     | an A/B testing framework for Rails that is datastore agnostic. | 1538  | 2023-03-16  |

[Back to Top](#table-of-contents)

## File System Listener

| Name                                                           | Description                                                                           | Stars | Last Commit |
|----------------------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [Guard](https://github.com/guard/guard)                        | A command line tool to easily handle events on file system modifications.             | 6436  | 2025-09-01  |
| [Guard::LiveReload](https://github.com/guard/guard-livereload) | Automatically reload your browser when 'view' files are modified.                     | 2114  | 2022-11-07  |
| [Listen](https://github.com/guard/listen)                      | The Listen gem listens to file modifications and notifies you about the changes.      | 1942  | 2025-08-11  |
| [Rerun](https://github.com/alexch/rerun)                       | Restarts an app when the filesystem changes. Uses growl and FSEventStream if on OS X. | 987   | 2024-05-22  |

[Back to Top](#table-of-contents)

## File Upload

| Name                                                              | Description                                                                                                                                                              | Stars | Last Commit |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [PaperClip](https://github.com/thoughtbot/paperclip)              | Easy file attachment management for ActiveRecord. Deprecated as of May 14, 2018.                                                                                         | 8981  | 2023-07-13  |
| [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) | Classier solution for file uploads for Rails, Sinatra and other Ruby web frameworks.                                                                                     | 8792  | 2025-08-18  |
| [Refile](https://github.com/refile/refile)                        | A modern file upload library for Ruby applications, Refile is an attempt by CarrierWave's original author to fix the design mistakes and overengineering in CarrierWave. | 2438  | 2024-07-01  |
| [DragonFly](https://github.com/markevans/dragonfly)               | A Ruby gem for on-the-fly processing - suitable for image uploading in Rails, Sinatra and much more!.                                                                    | 2114  | 2025-01-03  |

[Back to Top](#table-of-contents)

## Form Builder

| Name                                                     | Description                                                                                       | Stars | Last Commit |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------|-------|-------------|
| [Simple Form](https://github.com/heartcombo/simple_form) | Rails forms made easy.                                                                            | 8225  | 2024-08-19  |
| [Cocoon](https://github.com/nathanvda/cocoon)            | Dynamic nested forms using jQuery made easy; works with formtastic, simple_form or default forms. | 3082  | 2023-08-08  |

[Back to Top](#table-of-contents)

## GUI

| Name                                             | Description      | Stars | Last Commit |
|--------------------------------------------------|------------------|-------|-------------|
| [Glimmer](https://github.com/AndyObtiva/glimmer) | Ruby DSL for SWT | 787   | 2025-03-21  |

[Back to Top](#table-of-contents)

## Game Development and Graphics

| Name                                        | Description                                                                 | Stars | Last Commit |
|---------------------------------------------|-----------------------------------------------------------------------------|-------|-------------|
| [Ruby 2D](https://github.com/ruby2d/ruby2d) | Create cross-platform 2D applications, games, and visualizations with ease. | 667   | 2023-08-25  |

[Back to Top](#table-of-contents)

## Gem Servers

| Name                                                   | Description                                  | Stars | Last Commit |
|--------------------------------------------------------|----------------------------------------------|-------|-------------|
| [Gem in a box](https://github.com/geminabox/geminabox) | Really simple rubygem hosting.               | 1515  | 2025-09-04  |
| [Gemstash](https://github.com/rubygems/gemstash)       | A RubyGems.org cache and private gem server. | 775   | 2025-09-08  |

[Back to Top](#table-of-contents)

## Geolocation

| Name                                                                          | Description                                                                                                                                                                               | Stars | Last Commit |
|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Geocoder](https://github.com/alexreisner/geocoder)                           | A complete geocoding solution for Ruby. With Rails it adds geocoding (by street or IP address), reverse geocoding (find street address based on given coordinates), and distance queries. | 6411  | 2025-09-07  |
| [Google Maps for Rails](https://github.com/apneadiving/Google-Maps-for-Rails) | Enables easy Google map + overlays creation in Ruby apps.                                                                                                                                 | 2262  | 2018-02-02  |
| [Geokit](https://github.com/geokit/geokit)                                    | Geokit gem provides geocoding and distance/heading calculations.                                                                                                                          | 1638  | 2024-07-29  |
| [rgeo](https://github.com/rgeo/rgeo)                                          | Geospatial data library. Spatial data types, geometric and spherical calculations, and WKT/WKB serialization.                                                                             | 1030  | 2025-02-20  |
| [geoip](https://github.com/cjheath/geoip)                                     | Searches a GeoIP database for a given host or IP address, and returns information about the country where the IP address is allocated, and the city, ISP and other information.           | 721   | 2019-04-28  |

[Back to Top](#table-of-contents)

## Git Tools

| Name                                                  | Description                                            | Stars | Last Commit |
|-------------------------------------------------------|--------------------------------------------------------|-------|-------------|
| [Rugged](https://github.com/libgit2/rugged)           | Ruby bindings to libgit2.                              | 2271  | 2025-01-03  |
| [git_reflow](https://github.com/reenhanced/gitreflow) | An automated quality control workflow for Agile teams. | 1492  | 2022-03-01  |
| [ginatra](https://github.com/NARKOZ/ginatra)          | A web frontend for Git repositories.                   | 526   | 2022-05-27  |

[Back to Top](#table-of-contents)

## GraphQL

| Name                                                      | Description                     | Stars | Last Commit |
|-----------------------------------------------------------|---------------------------------|-------|-------------|
| [graphql-ruby](https://github.com/rmosolgo/graphql-ruby)  | Ruby implementation of GraphQL. | 5410  | 2025-09-04  |
| [graphql-batch](https://github.com/Shopify/graphql-batch) |                                 | 1429  | 2025-08-26  |

[Back to Top](#table-of-contents)

## HTML/XML Parsing

| Name                                | Description                              | Stars | Last Commit |
|-------------------------------------|------------------------------------------|-------|-------------|
| [Ox](https://github.com/ohler55/ox) | A fast XML parser and Object marshaller. | 910   | 2025-08-12  |

[Back to Top](#table-of-contents)

## HTTP Clients and tools

| Name                                                          | Description                                                                                                                                                                        | Stars | Last Commit |
|---------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [httparty](https://github.com/jnunemaker/httparty)            | Makes http fun again!                                                                                                                                                              | 5874  | 2025-08-11  |
| [Faraday](https://github.com/lostisland/faraday)              | an HTTP client lib that provides a common interface over many adapters (such as Net::HTTP) and embraces the concept of Rack middleware when processing the request/response cycle. | 5857  | 2025-08-12  |
| [RESTClient](https://github.com/rest-client/rest-client)      | Simple HTTP and REST client for Ruby, inspired by microframework syntax for specifying actions.                                                                                    | 5228  | 2024-05-19  |
| [Typhoeus](https://github.com/typhoeus/typhoeus)              | Typhoeus wraps libcurl in order to make fast and reliable requests.                                                                                                                | 4108  | 2025-08-26  |
| [HTTP](https://github.com/httprb/http)                        | The HTTP Gem: a simple Ruby DSL for making HTTP requests.                                                                                                                          | 3023  | 2025-06-30  |
| [Savon](https://github.com/savonrb/savon)                     | Savon is a SOAP client for the Ruby programming language.                                                                                                                          | 2074  | 2025-08-12  |
| [excon](https://github.com/excon/excon)                       | Usable, fast, simple Ruby HTTP 1.1. It works great as a general HTTP(s) client and is particularly well suited to usage in API clients.                                            | 1168  | 2025-08-18  |
| [Http-2](https://github.com/igrigorik/http-2)                 | Pure Ruby implementation of HTTP/2 protocol                                                                                                                                        | 907   | 2025-04-16  |
| [Device Detector](https://github.com/podigee/device_detector) | A precise and fast user agent parser and device detector, backed by the largest and most up-to-date user agent database.                                                           | 766   | 2025-07-23  |
| [Http Client](https://github.com/nahi/httpclient)             | Gives something like the functionality of libwww-perl (LWP) in Ruby.                                                                                                               | 706   | 2025-02-22  |
| [Sniffer](https://github.com/aderyabin/sniffer)               |                                                                                                                                                                                    | 581   | 2023-10-12  |
| [Patron](https://github.com/toland/patron)                    | Patron is a Ruby HTTP client library based on libcurl.                                                                                                                             | 546   | 2025-02-27  |

[Back to Top](#table-of-contents)

## IRB

| Name                                             | Description                                                | Stars | Last Commit |
|--------------------------------------------------|------------------------------------------------------------|-------|-------------|
| [Pry](https://github.com/pry/pry)                | A powerful alternative to the standard IRB shell for Ruby. | 6800  | 2025-04-21  |
| [irbtools](https://github.com/janlelis/irbtools) | Improvements for Ruby's IRB.                               | 922   | 2025-04-14  |

[Back to Top](#table-of-contents)

## Image Processing

| Name                                                         | Description                                                                                      | Stars | Last Commit |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------|-------|-------------|
| [PSD.rb](https://github.com/layervault/psd.rb)               | Parse Photoshop files in Ruby with ease.                                                         | 3121  | 2021-01-08  |
| [MiniMagick](https://github.com/minimagick/minimagick)       | A ruby wrapper for ImageMagick or GraphicsMagick command line.                                   | 2857  | 2025-08-19  |
| [FastImage](https://github.com/sdsykes/fastimage)            | FastImage finds the size or type of an image given its uri by fetching as little as needed.      | 1374  | 2025-01-03  |
| [ImageProcessing](https://github.com/janko/image_processing) | High-level image processing wrapper for libvips and ImageMagick/GraphicsMagick                   | 913   | 2025-08-22  |
| [RMagick](https://github.com/rmagick/rmagick)                | RMagick is an interface between Ruby and ImageMagick.                                            | 720   | 2025-08-24  |
| [Phasion](https://github.com/westonplatter/phashion)         | Ruby wrapper around pHash, the perceptual hash library for detecting duplicate multimedia files. | 706   | 2024-06-16  |

[Back to Top](#table-of-contents)

## Implementations/Compilers

| Name                                                 | Description                                                                                                                                                                                                                                                     | Stars | Last Commit |
|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [MRuby](https://github.com/mruby/mruby)              | Lightweight Ruby. Can be linked and embedded in your application.                                                                                                                                                                                               | 5411  | 2025-09-05  |
| [Opal](https://github.com/opal/opal)                 | Ruby to Javascript compiler.                                                                                                                                                                                                                                    | 4881  | 2025-08-29  |
| [JRuby](https://github.com/jruby/jruby)              | A Java implementation of the Ruby language.                                                                                                                                                                                                                     | 3842  | 2025-09-05  |
| [TruffleRuby](https://github.com/oracle/truffleruby) | A high performance implementation of the Ruby programming language. Built on the GraalVM by Oracle Labs.                                                                                                                                                        | 3122  | 2025-09-08  |
| [Rubinius](https://github.com/rubinius/rubinius)     | An implementation of the Ruby programming language. Rubinius includes a bytecode virtual machine, Ruby syntax parser, bytecode compiler, generational garbage collector, just-in-time (JIT) native machine code compiler, and Ruby Core and Standard libraries. | 3084  | 2023-05-09  |
| [Natalie](https://github.com/natalie-lang/natalie)   | Natalie is a Ruby compiler that provides an ahead-of-time compiler using C++ and gcc/clang as the backend.                                                                                                                                                      | 1013  | 2025-08-19  |

[Back to Top](#table-of-contents)

## Internationalization

| Name                                                          | Description                                                                                                                                           | Stars | Last Commit |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [rails-i18n](https://github.com/svenfuchs/rails-i18n)         | Repository for collecting Locale data for Rails I18n as well as other interesting, Rails related I18n stuff.                                          | 4013  | 2025-08-26  |
| [Globalize](https://github.com/globalize/globalize)           | Globalize builds on the I18n API in Ruby on Rails to add model translations to ActiveRecord models.                                                   | 2167  | 2025-02-03  |
| [i18n-tasks](https://github.com/glebm/i18n-tasks)             | Manage missing and unused translations with the awesome power of static analysis.                                                                     | 2135  | 2025-09-08  |
| [twitter-cldr-rb](https://github.com/twitter/twitter-cldr-rb) | Ruby implementation of the ICU (International Components for Unicode) that uses the Common Locale Data Repository to format dates, plurals, and more. | 685   | 2025-02-21  |
| [Tolk](https://github.com/tolk/tolk)                          | A web interface for doing i18n translations packaged as a Rails engine.                                                                               | 609   | 2025-01-18  |
| [Termit](https://github.com/pawurb/termit)                    | Translations with speech synthesis in your terminal.                                                                                                  | 507   | 2017-05-25  |

[Back to Top](#table-of-contents)

## Logging

| Name                                           | Description                                                                                                      | Stars | Last Commit |
|------------------------------------------------|------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Fluentd](https://github.com/fluent/fluentd)   | Fluentd collects events from various data sources and writes them to files, database or other types of storages. | 13292 | 2025-09-08  |
| [Lograge](https://github.com/roidrage/lograge) | An attempt to tame Rails' default policy to log everything.                                                      | 3528  | 2024-11-10  |
| [HttpLog](https://github.com/trusche/httplog)  | Log outgoing HTTP requests.                                                                                      | 816   | 2025-09-08  |
| [Logging](https://github.com/TwP/logging)      | A flexible logging library for use in Ruby programs based on the design of Java's log4j library.                 | 530   | 2024-07-14  |

[Back to Top](#table-of-contents)

## Machine Learning

| Name                                                                                      | Description                                                                                       | Stars | Last Commit |
|-------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|-------|-------------|
| [ruby-openai](https://github.com/alexrudall/ruby-openai)                                  | OpenAI API + Ruby!                                                                                | 3157  | 2025-08-29  |
| [m2cgen](https://github.com/BayesWitnesses/m2cgen)                                        | A CLI tool to transpile trained classic ML models into a native Ruby code with zero dependencies. | 2908  | 2024-08-03  |
| [Awesome Machine Learning with Ruby](https://github.com/arbox/machine-learning-with-ruby) | A Curated List of Ruby Machine Learning Links and Resources.                                      | 2185  | 2024-12-26  |
| [langchain.rb](https://github.com/patterns-ai-core/langchainrb)                           | Library for building LLM-powered applications in Ruby.                                            | 1895  | 2025-06-16  |
| [rumale](https://github.com/yoshoku/rumale)                                               | A machine learning library with interfaces similar to Scikit-Learn.                               | 858   | 2025-09-07  |
| [Torch.rb](https://github.com/ankane/torch.rb)                                            | Deep learning for Ruby, powered by LibTorch.                                                      | 804   | 2025-08-07  |
| [AI4R](https://github.com/sergiofierens/ai4r)                                             | Algorithms covering several Artificial intelligence fields.                                       | 715   | 2025-07-18  |
| [ruby-fann](https://github.com/tangledpath/ruby-fann)                                     | Ruby library for interfacing with FANN (Fast Artificial Neural Network).                          | 507   | 2024-03-25  |

[Back to Top](#table-of-contents)

## Markdown Processors

| Name                                                              | Description                                                                                                                             | Stars | Last Commit |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Redcarpet](https://github.com/vmg/redcarpet)                     | A fast, safe and extensible Markdown to (X)HTML parser.                                                                                 | 5056  | 2025-03-06  |
| [kramdown](https://github.com/gettalong/kramdown)                 | Kramdown is yet-another-markdown-parser but fast, pure Ruby, using a strict syntax definition and supporting several common extensions. | 1745  | 2024-11-18  |
| [word-to-markdown](https://github.com/benbalter/word-to-markdown) | Gem to convert Microsoft Word documents to Markdown.                                                                                    | 1515  | 2025-06-25  |
| [Maruku](https://github.com/bhollis/maruku)                       | A pure-Ruby Markdown-superset interpreter.                                                                                              | 506   | 2025-01-05  |

[Back to Top](#table-of-contents)

## Measurements

| Name                                                | Description                                                        | Stars | Last Commit |
|-----------------------------------------------------|--------------------------------------------------------------------|-------|-------------|
| [Ruby Units](https://github.com/olbrich/ruby-units) | Provides classes and methods to perform unit math and conversions. | 540   | 2025-01-01  |

[Back to Top](#table-of-contents)

## Mobile Development

| Name                                              | Description                                                                                        | Stars | Last Commit |
|---------------------------------------------------|----------------------------------------------------------------------------------------------------|-------|-------------|
| [fastlane](https://github.com/fastlane/fastlane)  | Connect all iOS deployment tools into one streamlined workflow.                                    | 40481 | 2025-08-07  |
| [dryrun](https://github.com/cesarferreira/dryrun) | Try any Android library on your smartphone directly from the command line.                         | 3814  | 2020-11-25  |
| [Ruboto](https://github.com/ruboto/ruboto)        | A platform for developing full stand-alone apps for Android using the Ruby language and libraries. | 2032  | 2023-05-15  |

[Back to Top](#table-of-contents)

## Money

| Name                                        | Description                                                    | Stars | Last Commit |
|---------------------------------------------|----------------------------------------------------------------|-------|-------------|
| [Money](https://github.com/RubyMoney/money) | A Ruby Library for dealing with money and currency conversion. | 2808  | 2025-08-18  |

[Back to Top](#table-of-contents)

## Music and Sound

| Name                                              | Description                                           | Stars | Last Commit |
|---------------------------------------------------|-------------------------------------------------------|-------|-------------|
| [Coltrane](https://github.com/pedrozath/coltrane) | A music theory library with a command-line interface. | 2389  | 2025-01-29  |

[Back to Top](#table-of-contents)

## Natural Language Processing

| Name                                                                              | Description                                                                                                               | Stars | Last Commit |
|-----------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Treat](https://github.com/louismullie/treat)                                     | Treat is a toolkit for natural language processing and computational linguistics in Ruby.                                 | 1371  | 2025-05-16  |
| [Ruby Natural Language Processing Resources](https://github.com/diasks2/ruby-nlp) | Collection of links to Ruby Natural Language Processing (NLP) libraries, tools and software.                              | 1285  | 2023-03-05  |
| [Awesome NLP with Ruby](https://github.com/arbox/nlp-with-ruby)                   | Awesome List for Practical Natural Language Processing done in Ruby.                                                      | 1063  | 2023-06-27  |
| [Text](https://github.com/threedaymonk/text)                                      | A collection of text algorithms including Levenshtein distance, Metaphone, Soundex 2, Porter stemming & White similarity. | 585   | 2015-04-13  |
| [Pragmatic Segmenter](https://github.com/diasks2/pragmatic_segmenter)             | Pragmatic Segmenter is a rule-based sentence boundary detection gem that works out-of-the-box across many languages.      | 575   | 2024-08-11  |

[Back to Top](#table-of-contents)

## Notifications

| Name                                         | Description                                                                                                                                                                         | Stars | Last Commit |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Noticed](https://github.com/excid3/noticed) | ActionMailer-like Notification System for your Ruby on Rails app.                                                                                                                   | 2595  | 2025-09-08  |
| [Rpush](https://github.com/rpush/rpush)      | The push notification service for Ruby which supports Apple Push Notification Service, Google Cloud Messaging, Amazon Device Messaging and Windows Phone Push Notification Service. | 2198  | 2025-07-01  |

[Back to Top](#table-of-contents)

## ORM/ODM

| Name                                                       | Description                                                                                                                                                               | Stars | Last Commit |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Sequel](https://github.com/jeremyevans/sequel)            | Sequel is a simple, flexible, and powerful SQL database access toolkit for Ruby.                                                                                          | 5050  | 2025-09-01  |
| [Mongoid](https://github.com/mongodb/mongoid)              | An ODM (Object-Document-Mapper) framework for MongoDB in Ruby.                                                                                                            | 3922  | 2025-09-04  |
| [ROM](https://github.com/rom-rb/rom)                       | Ruby Object Mapper (ROM) is an experimental Ruby library with the goal to provide powerful object mapping capabilities without limiting the full power of your datastore. | 2106  | 2025-01-21  |
| [Redis-Objects](https://github.com/nateware/redis-objects) | Redis Objects provides a Rubyish interface to Redis, by mapping Redis data types to Ruby objects, via a thin layer over the redis gem.                                    | 2092  | 2023-03-30  |
| [Ohm](https://github.com/soveran/ohm)                      | Object-hash mapping library for Redis.                                                                                                                                    | 1395  | 2022-12-20  |

[Back to Top](#table-of-contents)

## ORM/ODM Extensions

| Name                                                                       | Description                                                                                                                                            | Stars | Last Commit |
|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [ActiveRecord Import](https://github.com/zdennis/activerecord-import)      | a library for bulk inserting data using ActiveRecord.                                                                                                  | 4130  | 2025-07-27  |
| [Ancestry](https://github.com/stefankroes/ancestry)                        | Organise ActiveRecord model into a tree structure using a variation on the materialised path pattern.                                                  | 3819  | 2025-08-20  |
| [Audited](https://github.com/collectiveidea/audited)                       | Audited is an ORM extension for ActiveRecord & MongoMapper that logs all changes to your models.                                                       | 3466  | 2024-11-08  |
| [Apartment](https://github.com/influitive/apartment)                       | Multi-tenancy for Rails and ActiveRecord.                                                                                                              | 2684  | 2024-06-12  |
| [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) | Awesome Nested Set is an implementation of the nested set pattern for ActiveRecord models.                                                             | 2416  | 2024-11-14  |
| [Discard](https://github.com/jhawthorn/discard)                            | A simple ActiveRecord mixin to add conventions for flagging records as discarded.                                                                      | 2313  | 2025-08-19  |
| [marginalia](https://github.com/basecamp/marginalia)                       | Attach comments to your ActiveRecord queries. By default, it adds the application, controller, and action names as a comment at the end of each query. | 1763  | 2024-08-05  |
| [Enumerize](https://github.com/brainspec/enumerize)                        | Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support.                                                                          | 1757  | 2025-08-12  |
| [Acts As Tennant](https://github.com/ErwinM/acts_as_tenant)                | Add multi-tenancy to a Rails app through a shared database strategy.                                                                                   | 1656  | 2025-04-16  |
| [Logidze](https://github.com/palkan/logidze)                               | Database changes log for Rails.                                                                                                                        | 1651  | 2025-06-06  |
| [Goldiloader](https://github.com/salsify/goldiloader)                      | Automatic ActiveRecord eager loading.                                                                                                                  | 1644  | 2024-11-08  |
| [ActsAsParanoid](https://github.com/ActsAsParanoid/acts_as_paranoid)       | ActiveRecord plugin allowing you to hide and restore records without actually deleting them.                                                           | 1500  | 2025-09-01  |
| [bulk_insert](https://github.com/jamis/bulk_insert)                        | A little ActiveRecord extension for helping to insert lots of rows in a single insert statement.                                                       | 813   | 2022-01-10  |
| [Unread](https://github.com/ledermann/unread)                              | Manage read/unread status of ActiveRecord objects - and it's fast.                                                                                     | 742   | 2024-12-28  |
| [ActsAsTree](https://github.com/amerine/acts_as_tree)                      | Extends ActiveRecord to add simple support for organizing items into parent–children relationships.                                                    | 591   | 2022-04-23  |

[Back to Top](#table-of-contents)

## Optimizations

| Name                                                   | Description                                                                  | Stars | Last Commit |
|--------------------------------------------------------|------------------------------------------------------------------------------|-------|-------------|
| [yajl-ruby](https://github.com/brianmario/yajl-ruby)   | A streaming JSON parsing and encoding library for Ruby (C bindings to yajl). | 1491  | 2024-12-17  |
| [fast_blank](https://github.com/SamSaffron/fast_blank) | Provides a C-optimized method for determining if a string is blank.          | 617   | 2024-02-21  |

[Back to Top](#table-of-contents)

## PDF

| Name                                                          | Description                                                                    | Stars | Last Commit |
|---------------------------------------------------------------|--------------------------------------------------------------------------------|-------|-------------|
| [Prawn](https://github.com/prawnpdf/prawn)                    | Fast, Nimble PDF Writer for Ruby.                                              | 4752  | 2025-05-02  |
| [Wicked Pdf](https://github.com/mileszs/wicked_pdf)           | PDF generator (from HTML) plugin for Ruby on Rails.                            | 3571  | 2025-07-24  |
| [Pdfkit](https://github.com/pdfkit/pdfkit)                    | HTML+CSS to PDF using wkhtmltopdf.                                             | 2942  | 2023-08-22  |
| [HexaPDF](https://github.com/gettalong/hexapdf)               | A Versatile PDF Creation and Manipulation Library For Ruby.                    | 1333  | 2025-08-21  |
| [InvoicePrinter](https://github.com/strzibny/invoice_printer) | Super simple PDF invoicing in Ruby (built on top of Prawn).                    | 968   | 2024-10-13  |
| [CombinePDF](https://github.com/boazsegev/combine_pdf)        | A Pure ruby library to merge or stump PDF files, number pages and more.        | 762   | 2025-04-08  |
| [Kitabu](https://github.com/fnando/kitabu)                    | A framework for creating e-books from Markdown/Textile text markup using Ruby. | 682   | 2025-08-12  |

[Back to Top](#table-of-contents)

## Package Management

| Name                                                | Description                                                                                                  | Stars | Last Commit |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Homebrew](https://github.com/Homebrew/brew)        | The missing package manager for OS X.                                                                        | 44760 | 2025-09-08  |
| [CocoaPods](https://github.com/CocoaPods/CocoaPods) | The Objective-C dependency manager.                                                                          | 14743 | 2025-08-26  |
| [fpm](https://github.com/jordansissel/fpm)          | Effing package management! Build packages for multiple platforms (deb, rpm, etc) with great ease and sanity. | 11345 | 2025-03-06  |
| [Berkshelf](https://github.com/berkshelf/berkshelf) | A Chef Cookbook manager.                                                                                     | 1072  | 2024-08-14  |

[Back to Top](#table-of-contents)

## Pagination

| Name                                                     | Description                                                                                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [will_paginate](https://github.com/mislav/will_paginate) | A pagination library that integrates with Ruby on Rails, Sinatra, Merb, DataMapper and Sequel.                                                                                              | 5703  | 2025-08-11  |
| [Pagy](https://github.com/ddnexus/pagy)                  | Pagy is the ultimate pagination gem that outperforms the others in each and every benchmark and comparison. More details can be found on [Pagy Wiki](https://ddnexus.github.io/pagy/index). | 4814  | 2025-09-05  |
| [order_query](https://github.com/glebm/order_query)      | A keyset pagination library to find the next or previous record(s) relative to the current one efficiently, e.g. for infinite scroll.                                                       | 512   | 2024-11-15  |

[Back to Top](#table-of-contents)

## Process Management and Monitoring

| Name                                                | Description                                                                      | Stars | Last Commit |
|-----------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [Foreman](https://github.com/ddollar/foreman)       | Manage Procfile-based applications.                                              | 6098  | 2025-07-27  |
| [God](https://github.com/mojombo/god)               | An easy to configure, easy to extend monitoring framework written in Ruby.       | 2221  | 2024-03-29  |
| [Eye](https://github.com/kostya/eye)                | Process monitoring tool. Inspired from Bluepill and God.                         | 1188  | 2021-11-13  |
| [Procodile](https://github.com/adamcooke/procodile) | Run processes in the background (and foreground) on Mac & Linux from a Procfile. | 614   | 2021-02-16  |

[Back to Top](#table-of-contents)

## Processes

| Name                                                   | Description                                                                          | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------------------------|-------|-------------|
| [posix-spawn](https://github.com/rtomayko/posix-spawn) | Fast Process::spawn for Rubys >= 1.8.7 based on the posix_spawn() system interfaces. | 525   | 2024-03-19  |

[Back to Top](#table-of-contents)

## Profiler and Optimization

| Name                                                                     | Description                                                  | Stars | Last Commit |
|--------------------------------------------------------------------------|--------------------------------------------------------------|-------|-------------|
| [bullet](https://github.com/flyerhzm/bullet)                             | Help to kill N+1 queries and unused eager loading.           | 7247  | 2025-08-12  |
| [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) | Profiler for your development and production Ruby rack apps. | 3850  | 2025-08-05  |
| [Peek](https://github.com/peek/peek)                                     | Visual status bar showing Rails performance.                 | 3184  | 2024-04-26  |
| [rbspy](https://github.com/rbspy/rbspy)                                  | Sampling profiler for any Ruby process.                      | 2527  | 2025-09-03  |
| [stackprof](https://github.com/tmm1/stackprof)                           | A sampling call-stack profiler for ruby 2.1+.                | 2153  | 2025-02-28  |
| [ruby-prof](https://github.com/ruby-prof/ruby-prof)                      | A code profiler for MRI rubies.                              | 2022  | 2025-05-22  |
| [benchmark-ips](https://github.com/evanphx/benchmark-ips)                | Provides iteration per second benchmarking for Ruby.         | 1757  | 2025-08-12  |
| [batch-loader](https://github.com/exaspark/batch-loader)                 |                                                              | 1093  | 2024-04-24  |

[Back to Top](#table-of-contents)

## QR

| Name                                          | Description                                                                    | Stars | Last Commit |
|-----------------------------------------------|--------------------------------------------------------------------------------|-------|-------------|
| [RQRCode](https://github.com/whomwah/rqrcode) | RQRCode is a library for creating and rendering QR codes into various formats. | 1941  | 2025-04-28  |

[Back to Top](#table-of-contents)

## Queues and Messaging

| Name                                                           | Description                                                                                                     | Stars | Last Commit |
|----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Resque](https://github.com/resque/resque)                     | A Redis-backed Ruby library for creating background jobs.                                                       | 9465  | 2025-08-23  |
| [Delayed::Job](https://github.com/collectiveidea/delayed_job)  | Database backed asynchronous priority queue.                                                                    | 4820  | 2025-07-09  |
| [GoodJob](https://github.com/bensheldon/good_job)              | GoodJob is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails.                                | 2866  | 2025-09-01  |
| [Sucker Punch](https://github.com/brandonhilkert/sucker_punch) | A single process background processing library using Celluloid. Aimed to be Sidekiq's little brother.           | 2638  | 2023-12-11  |
| [Sneakers](https://github.com/jondot/sneakers)                 | A fast background processing framework for Ruby and RabbitMQ.                                                   | 2250  | 2024-06-26  |
| [Karafka](https://github.com/karafka/karafka)                  | Framework used to simplify Apache Kafka (a distributed streaming platform) based Ruby applications development. | 2186  | 2025-09-08  |
| [Bunny](https://github.com/ruby-amqp/bunny)                    | Bunny is a popular, easy to use, well-maintained Ruby client for RabbitMQ (3.3+).                               | 1403  | 2025-08-20  |
| [JobIteration](https://github.com/Shopify/job-iteration)       | An ActiveJob extension to make long-running jobs interruptible and resumable.                                   | 1255  | 2025-09-03  |
| [Gush](https://github.com/chaps-io/gush)                       | A parallel runner for complex workflows using only Redis and Sidekiq.                                           | 1090  | 2025-03-19  |

[Back to Top](#table-of-contents)

## RSS

| Name                                             | Description                          | Stars | Last Commit |
|--------------------------------------------------|--------------------------------------|-------|-------------|
| [Feedjira](https://github.com/feedjira/feedjira) | A feed fetching and parsing library. | 2089  | 2025-09-08  |

[Back to Top](#table-of-contents)

## Rails Application Generators

| Name                                                          | Description                                                  | Stars | Last Commit |
|---------------------------------------------------------------|--------------------------------------------------------------|-------|-------------|
| [Suspenders](https://github.com/thoughtbot/suspenders)        | Suspenders is the base Rails application used at thoughtbot. | 4042  | 2025-05-23  |
| [Rails Composer](https://github.com/RailsApps/rails-composer) | The Rails generator on steroids for starter apps.            | 3373  | 2019-05-30  |
| [orats](https://github.com/nickjj/orats)                      | Opinionated rails application templates.                     | 660   | 2020-12-22  |

[Back to Top](#table-of-contents)

## SEO

| Name                                                             | Description                                                                     | Stars | Last Commit |
|------------------------------------------------------------------|---------------------------------------------------------------------------------|-------|-------------|
| [FriendlyId](https://github.com/norman/friendly_id)              | The "Swiss Army bulldozer" of slugging and permalink plugins for Active Record. | 6211  | 2025-08-18  |
| [MetaTags](https://github.com/kpumuk/meta-tags)                  | A gem to make your Rails application SEO-friendly.                              | 2773  | 2025-08-12  |
| [SitemapGenerator](https://github.com/kjvarga/sitemap_generator) | A framework-agnostic XML Sitemap generator written in Ruby.                     | 2479  | 2025-09-01  |

[Back to Top](#table-of-contents)

## Scheduling

| Name                                                            | Description                                                                  | Stars | Last Commit |
|-----------------------------------------------------------------|------------------------------------------------------------------------------|-------|-------------|
| [Whenever](https://github.com/javan/whenever)                   | A Ruby gem that provides a clear syntax for writing and deploying cron jobs. | 8871  | 2024-07-31  |
| [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) | Job scheduler for Ruby (at, cron, in and every jobs).                        | 2430  | 2025-08-19  |
| [minicron](https://github.com/jamesrwhite/minicron)             | A system to manage and monitor cron jobs.                                    | 2333  | 2021-05-16  |
| [resque-scheduler](https://github.com/resque/resque-scheduler)  | A light-weight job scheduling system built on top of Resque.                 | 1739  | 2025-08-19  |

[Back to Top](#table-of-contents)

## Scientific

| Name                                                             | Description                                                                                            | Stars | Last Commit |
|------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------|-------------|
| [algorithms](https://github.com/kanwei/algorithms)               | Library with documentation on when to use a particular structure/algorithm.                            | 2698  | 2025-08-20  |
| [smarter_csv](https://github.com/tilo/smarter_csv)               | Ruby Gem for smarter importing of CSV Files as Array(s) of Hashes.                                     | 1492  | 2025-08-15  |
| [decisiontree](https://github.com/igrigorik/decisiontree)        | A ruby library which implements ID3 (information gain) algorithm for decision tree learning.           | 1459  | 2018-10-31  |
| [SciRuby](https://github.com/sciruby/sciruby)                    | Tools for scientific computation in Ruby/Rails.                                                        | 1000  | 2020-02-28  |
| [IRuby](https://github.com/SciRuby/iruby)                        | A Ruby kernel for Jupyter.                                                                             | 921   | 2025-08-11  |
| [ruby-opencv](https://github.com/ruby-opencv/ruby-opencv)        | An OpenCV wrapper for Ruby.                                                                            | 812   | 2021-04-12  |
| [classifier-reborn](https://github.com/jekyll/classifier-reborn) | An active fork of Classifier, and general module to allow Bayesian and other types of classifications. | 555   | 2024-05-27  |

[Back to Top](#table-of-contents)

## Search

| Name                                                                | Description                                                                                                                                                                                 | Stars | Last Commit |
|---------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Searchkick](https://github.com/ankane/searchkick)                  | Searchkick learns what your users are looking for. As more people search, it gets smarter and the results get better. It’s friendly for developers - and magical for your users.            | 6647  | 2025-09-05  |
| [ransack](https://github.com/activerecord-hackery/ransack)          | Object-based searching.                                                                                                                                                                     | 5809  | 2025-07-17  |
| [Sunspot](https://github.com/sunspot/sunspot)                       | A Ruby library for expressive, powerful interaction with the Solr search engine.                                                                                                            | 2991  | 2025-06-30  |
| [elasticsearch-ruby](https://github.com/elastic/elasticsearch-ruby) | Ruby integrations for Elasticsearch.                                                                                                                                                        | 1976  | 2025-09-08  |
| [chewy](https://github.com/toptal/chewy)                            | High-level Elasticsearch Ruby framework based on the official elasticsearch-ruby client.                                                                                                    | 1894  | 2025-08-13  |
| [has_scope](https://github.com/heartcombo/has_scope)                | Has scope allows you to easily create controller filters based on your resources named scopes.                                                                                              | 1671  | 2024-04-09  |
| [Thinking Sphinx](https://github.com/pat/thinking-sphinx)           | A library for connecting ActiveRecord to the Sphinx full-text search tool.                                                                                                                  | 1630  | 2024-07-07  |
| [pg_search](https://github.com/Casecommons/pg_search)               | Builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search.                                                                                                      | 1494  | 2025-07-16  |
| [textacular](https://github.com/textacular/textacular)              | Exposes full text search capabilities from PostgreSQL, and allows you to declare full text indexes. Textacular extends ActiveRecord with named_scope methods making searching easy and fun! | 955   | 2025-03-20  |
| [SearchCop](https://github.com/mrkamel/search_cop)                  | Extends your ActiveRecord models to support fulltext search engine like queries via simple query strings and hash-based queries.                                                            | 832   | 2024-05-30  |

[Back to Top](#table-of-contents)

## Security

| Name                                                         | Description                                                         | Stars | Last Commit |
|--------------------------------------------------------------|---------------------------------------------------------------------|-------|-------------|
| [Metasploit](https://github.com/rapid7/metasploit-framework) | World's most used penetration testing software.                     | 36320 | 2025-09-08  |
| [WhatWeb](https://github.com/urbanadventurer/WhatWeb)        | Website Fingerprinter.                                              | 6054  | 2025-08-25  |
| [bundler-audit](https://github.com/rubysec/bundler-audit)    | Patch-level security verification for Bundler.                      | 2708  | 2025-05-02  |
| [haiti](https://github.com/noraj/haiti)                      | Hash type identifier (CLI & lib).                                   | 907   | 2025-08-30  |
| [Ronin](https://github.com/ronin-rb/ronin)                   | A Ruby platform for vulnerability research and exploit development. | 725   | 2025-08-21  |
| [Pipal](https://github.com/digininja/pipal)                  | Password analyser and statistics generator                          | 651   | 2023-08-27  |

[Back to Top](#table-of-contents)

## Social Networking

| Name                                                | Description                                                                                       | Stars | Last Commit |
|-----------------------------------------------------|---------------------------------------------------------------------------------------------------|-------|-------------|
| [Discourse](https://github.com/discourse/discourse) | A platform for community discussion. Free, open, simple.                                          | 45010 | 2025-09-08  |
| [diaspora*](https://github.com/diaspora/diaspora)   | A privacy aware, distributed, open source social network.                                         | 13636 | 2025-06-22  |
| [Mailboxer](https://github.com/mailboxer/mailboxer) | A private message system for Rails applications.                                                  | 1641  | 2024-04-11  |
| [Decidim](https://github.com/decidim/decidim)       | free open-source participatory democracy for cities and organizations                             | 1612  | 2025-09-08  |
| [Thredded](https://github.com/thredded/thredded)    | Rails 4.2+ forums/messageboards engine. Its goal is to be as simple and feature rich as possible. | 1598  | 2025-05-30  |

[Back to Top](#table-of-contents)

## Spreadsheets and Documents

| Name                                                                           | Description                                                                                                                                                                | Stars | Last Commit |
|--------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Roo](https://github.com/roo-rb/roo)                                           | Implements read access for all spreadsheet types and read/write access for Google spreadsheets.                                                                            | 2834  | 2025-08-07  |
| [spreadsheet_architect](https://github.com/westonganger/spreadsheet_architect) | Spreadsheet Architect is a library that allows you to create XLSX, ODS, or CSV spreadsheets super easily from ActiveRecord relations, plain Ruby objects, or tabular data. | 1345  | 2025-01-18  |
| [CAXLSX](https://github.com/caxlsx/caxlsx)                                     | A community maintained excel xlsx generation library. [AXLSX](https://github.com/randym/axlsx) - The original.                                                             | 546   | 2025-09-08  |

[Back to Top](#table-of-contents)

## State Machines

| Name                                                               | Description                                                                                                   | Stars | Last Commit |
|--------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-------|-------------|
| [AASM](https://github.com/aasm/aasm)                               | State machines for Ruby classes (plain Ruby, Rails Active Record, Mongoid).                                   | 5119  | 2025-06-22  |
| [Statesman](https://github.com/gocardless/statesman)               | A statesmanlike state machine library.                                                                        | 1831  | 2025-09-05  |
| [Workflow](https://github.com/geekq/workflow)                      | A finite-state-machine-inspired API for modeling and interacting with what we tend to refer to as 'workflow'. | 1780  | 2024-06-26  |
| [state_machines](https://github.com/state-machines/state_machines) | Adds support for creating state machines for attributes on any Ruby class.                                    | 846   | 2025-07-25  |
| [transitions](https://github.com/troessner/transitions)            | A ruby state machine implementation.                                                                          | 536   | 2022-03-31  |
| [MicroMachine](https://github.com/soveran/micromachine)            | A minimal finite state machine implementation in less than 50 lines of code.                                  | 524   | 2017-08-20  |

[Back to Top](#table-of-contents)

## Static Site Generation

| Name                                                             | Description                                                                      | Stars | Last Commit |
|------------------------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [High Voltage](https://github.com/thoughtbot/high_voltage)       | Easily include static pages in your Rails app.                                   | 3221  | 2025-08-18  |
| [Bridgetown](https://github.com/bridgetownrb/bridgetown)         | A Webpack-aware, Ruby-powered static site generator for the modern Jamstack era. | 1258  | 2025-09-08  |
| [Awesome Jekyll](https://github.com/planetjekyll/awesome-jekyll) | A collection of awesome Jekyll tools, plugins, themes, guides and much more.     | 593   | 2021-01-11  |

[Back to Top](#table-of-contents)

## Template Engine

| Name                                             | Description                                                                                          | Stars | Last Commit |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------|-------|-------------|
| [Liquid](https://github.com/Shopify/liquid)      | Safe, customer facing template language for flexible web apps.                                       | 11478 | 2025-09-05  |
| [Slim](https://github.com/slim-template/slim)    | A template language whose goal is reduce the syntax to the essential parts without becoming cryptic. | 5346  | 2025-08-19  |
| [Haml](https://github.com/haml/haml)             | HTML Abstraction Markup Language.                                                                    | 3776  | 2025-09-06  |
| [Mustache](https://github.com/mustache/mustache) | Logic-less Ruby templates.                                                                           | 3065  | 2024-07-09  |
| [Tilt](https://github.com/rtomayko/tilt)         | Generic interface to multiple Ruby template engines.                                                 | 1950  | 2023-12-29  |
| [Curly](https://github.com/zendesk/curly)        | A template language that completely separates structure and logic.                                   | 591   | 2025-05-23  |

[Back to Top](#table-of-contents)

## Testing

| Name                                                               | Description                                                                                                                                                                                                | Stars | Last Commit |
|--------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Capybara](https://github.com/teamcapybara/capybara)               | Acceptance test framework for web applications.                                                                                                                                                            | 10101 | 2025-08-18  |
| [factory_bot](https://github.com/thoughtbot/factory_bot)           | A library for setting up Ruby objects as test data.                                                                                                                                                        | 8140  | 2025-08-22  |
| [vcr](https://github.com/vcr/vcr)                                  | Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests.                                                                                | 5974  | 2025-08-19  |
| [WebMock](https://github.com/bblimke/webmock)                      | Library for stubbing and setting expectations on HTTP requests.                                                                                                                                            | 4024  | 2025-04-23  |
| [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) | Provides Test::Unit- and RSpec-compatible one-liners that test common Rails functionality. These tests would otherwise be much longer, more complex, and error-prone.                                      | 3557  | 2025-09-05  |
| [Parallel Tests](https://github.com/grosser/parallel_tests)        | Speedup Test::Unit + RSpec + Cucumber by running parallel on multiple CPUs (or cores).                                                                                                                     | 3454  | 2025-08-02  |
| [timecop](https://github.com/travisjeffery/timecop)                | Provides "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.                                                                                                | 3399  | 2025-08-18  |
| [Spring](https://github.com/rails/spring)                          | Preloads your rails environment in the background for faster testing and Rake tasks.                                                                                                                       | 2815  | 2025-08-07  |
| [Poltergeist](https://github.com/teampoltergeist/poltergeist)      | A PhantomJS driver for Capybara.                                                                                                                                                                           | 2496  | 2019-09-27  |
| [mutant](https://github.com/mbj/mutant)                            | Mutant is a mutation testing tool for Ruby.                                                                                                                                                                | 1980  | 2025-08-06  |
| [Ferrum](https://github.com/rubycdp/ferrum)                        | High-level API to control Chrome in Ruby.                                                                                                                                                                  | 1916  | 2025-05-15  |
| [DuckRails](https://github.com/iridakos/duckrails)                 | Tool for mocking API endpoints quickly & dynamically.                                                                                                                                                      | 1717  | 2023-07-13  |
| [ffaker](https://github.com/ffaker/ffaker)                         | A faster Faker, generates dummy data, rewrite of faker.                                                                                                                                                    | 1566  | 2025-09-01  |
| [Watir](https://github.com/watir/watir)                            | Web application testing in Ruby.                                                                                                                                                                           | 1545  | 2024-05-31  |
| [Appraisal](https://github.com/thoughtbot/appraisal)               | Appraisal integrates with bundler and rake to test your library against different versions of dependencies.                                                                                                | 1304  | 2024-10-25  |
| [Mocha](https://github.com/freerange/mocha)                        | Mocha is a mocking and stubbing library for Ruby.                                                                                                                                                          | 1260  | 2025-08-31  |
| [Fuubar](https://github.com/thekompanee/fuubar)                    | The instafailing RSpec progress bar formatter.                                                                                                                                                             | 960   | 2022-02-12  |
| [Aruba](https://github.com/cucumber/aruba)                         | Testing command line applications with cucumber and rspec.                                                                                                                                                 | 956   | 2025-08-22  |
| [Forgery](https://github.com/sevenwire/forgery)                    | Easy and customizable generation of forged data.                                                                                                                                                           | 787   | 2020-07-23  |
| [Nyan Cat](https://github.com/mattsears/nyan-cat-formatter)        | Nyan Cat inspired RSpec formatter!                                                                                                                                                                         | 736   | 2020-04-17  |
| [Spinach](https://github.com/codegram/spinach)                     | Spinach is a high-level BDD framework that leverages the expressive Gherkin language (used by Cucumber) to help you define executable specifications of your application or library's acceptance criteria. | 578   | 2025-03-13  |
| [ActiveMocker](https://github.com/zeisler/active_mocker)           | Generate mocks from ActiveRecord models for unit tests that run fast because they don’t need to load Rails or a database.                                                                                  | 504   | 2019-09-05  |

[Back to Top](#table-of-contents)

## Third-party APIs

| Name                                                         | Description                                                        | Stars | Last Commit |
|--------------------------------------------------------------|--------------------------------------------------------------------|-------|-------------|
| [twilio-ruby](https://github.com/twilio/twilio-ruby)         | A module for using the Twilio REST API and generating valid TwiML. | 1375  | 2025-09-04  |
| [tweetstream](https://github.com/tweetstream/tweetstream)    | A simple library for consuming Twitter's Streaming API.            | 1108  | 2021-08-24  |
| [gitlab](https://github.com/NARKOZ/gitlab)                   | Ruby wrapper and CLI for the GitLab API.                           | 1075  | 2025-08-07  |
| [terjira](https://github.com/keepcosmos/terjira)             | A command-line power tool for Jira.                                | 895   | 2023-03-15  |
| [ruby-gmail](https://github.com/dcparker/ruby-gmail)         | A Rubyesque interface to Gmail.                                    | 793   | 2019-06-27  |
| [linkedin](https://github.com/hexgnu/linkedin)               | Provides an easy-to-use wrapper for LinkedIn's REST APIs.          | 761   | 2022-02-03  |
| [ruby-trello](https://github.com/jeremytregunna/ruby-trello) | Implementation of the Trello API for Ruby.                         | 719   | 2024-07-22  |
| [Pusher](https://github.com/pusher/pusher-http-ruby)         | Ruby server library for the Pusher API.                            | 666   | 2023-07-04  |

[Back to Top](#table-of-contents)

## Video

| Name                                                           | Description                                                                                        | Stars | Last Commit |
|----------------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------|-------------|
| [Streamio FFMPEG](https://github.com/streamio/streamio-ffmpeg) | Simple yet powerful wrapper around the ffmpeg command for reading metadata and transcoding movies. | 1671  | 2024-05-08  |

[Back to Top](#table-of-contents)

## View components

| Name                                          | Description                | Stars | Last Commit |
|-----------------------------------------------|----------------------------|-------|-------------|
| [Cells](https://github.com/trailblazer/cells) | View Components for Rails. | 3080  | 2024-12-02  |

[Back to Top](#table-of-contents)

## View helpers

| Name                                                      | Description                                                                                                                     | Stars | Last Commit |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [gon](https://github.com/gazay/gon)                       | If you need to send some data to your js files and you don't want to do this with long way through views and parsing - use gon. | 3072  | 2025-08-19  |
| [active_link_to](https://github.com/comfy/active_link_to) | View helper to manage "active" state of a link.                                                                                 | 856   | 2024-04-07  |
| [auto_html](https://github.com/dejan/auto_html)           | Rails extension for transforming URLs to appropriate resource (image, link, YouTube, Vimeo video...).                           | 800   | 2025-06-05  |

[Back to Top](#table-of-contents)

## Web Crawling

| Name                                                             | Description                                                                                                                                                                                                    | Stars | Last Commit |
|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Mechanize](https://github.com/sparklemotion/mechanize)          | Mechanize is a ruby library that makes automated web interaction easy.                                                                                                                                         | 4421  | 2025-07-10  |
| [Upton](https://github.com/propublica/upton)                     | A batteries-included framework for easy web-scraping.                                                                                                                                                          | 1603  | 2018-12-26  |
| [Wombat](https://github.com/felipecsl/wombat)                    | Web scraper with an elegant DSL that parses structured data from web pages.                                                                                                                                    | 1315  | 2024-01-24  |
| [MetaInspector](https://github.com/jaimeiniesta/metainspector)   | Ruby gem for web scraping purposes.                                                                                                                                                                            | 1042  | 2025-09-04  |
| [Kimurai](https://github.com/vifreefly/kimuraframework)          | A modern web scraping framework written in Ruby which works out of box with Headless Chromium/Firefox, PhantomJS, or simple HTTP requests and allows to scrape and interact with JavaScript rendered websites. | 1011  | 2024-05-28  |
| [Spidr](https://github.com/postmodern/spidr)                     | A versatile Ruby web spidering library that can spider a site, multiple domains, certain links or infinitely. Spidr is designed to be fast and easy to use.                                                    | 825   | 2025-06-30  |
| [LinkThumbnailer](https://github.com/gottfrois/link_thumbnailer) | Ruby gem that generates thumbnail images and videos from a given URL. Much like popular social website with link preview.                                                                                      | 513   | 2025-05-20  |

[Back to Top](#table-of-contents)

## Web Frameworks

| Name                                                      | Description                                                                                                                                               | Stars | Last Commit |
|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Trailblazer](https://github.com/trailblazer/trailblazer) | Trailblazer is a thin layer on top of Rails. It gently enforces encapsulation, an intuitive code structure and gives you an object-oriented architecture. | 3457  | 2025-07-15  |
| [Camping](https://github.com/camping/camping)             | A web microframework which consistently stays at less than 4kB of code.                                                                                   | 966   | 2025-05-08  |

[Back to Top](#table-of-contents)

## Web Servers

| Name                                          | Description                                                                               | Stars | Last Commit |
|-----------------------------------------------|-------------------------------------------------------------------------------------------|-------|-------------|
| [Puma](https://github.com/puma/puma)          | A modern, concurrent web server for Ruby.                                                 | 7802  | 2025-09-06  |
| [Falcon](https://github.com/socketry/falcon)  | A high-performance web server for Ruby, supporting HTTP/1, HTTP/2 and TLS.                | 2829  | 2025-08-07  |
| [Thin](https://github.com/macournoyer/thin)   | Tiny, fast & funny HTTP server.                                                           | 2278  | 2025-06-24  |
| [Iodine](https://github.com/boazsegev/iodine) | An non-blocking HTTP and Websocket web server optimized for Linux/BDS/macOS and Ruby MRI. | 942   | 2025-09-05  |
| [Agoo](https://github.com/ohler55/agoo)       | A high performance HTTP server for Ruby that includes GraphQL and WebSocket support.      | 919   | 2024-10-20  |

[Back to Top](#table-of-contents)

## WebSocket

| Name                                               | Description                                                  | Stars | Last Commit |
|----------------------------------------------------|--------------------------------------------------------------|-------|-------------|
| [Slanger](https://github.com/stevegraham/slanger)  | Open Pusher implementation compatible with Pusher libraries. | 1692  | 2022-07-21  |
| [Firehose](https://github.com/firehoseio/firehose) | Build realtime Ruby web applications.                        | 727   | 2023-04-11  |

[Back to Top](#table-of-contents)
