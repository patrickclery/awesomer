# awesome-ruby

💎 A collection of awesome Ruby libraries, tools, frameworks and software

**Source:** [markets/awesome-ruby](https://github.com/markets/awesome-ruby)

## Table of Contents

- [Top 10](#top-10)
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

## Top 10

| Name                                                         | Category                 | Stars | Last Commit |
|--------------------------------------------------------------|--------------------------|-------|-------------|
| [Homebrew](https://github.com/Homebrew/brew)                 | Package Management       | 46577 | 2026-02-12  |
| [Discourse](https://github.com/discourse/discourse)          | Social Networking        | 46312 | 2026-02-12  |
| [fastlane](https://github.com/fastlane/fastlane)             | Mobile Development       | 40982 | 2026-02-10  |
| [Metasploit](https://github.com/rapid7/metasploit-framework) | Security                 | 37498 | 2026-02-11  |
| [Devise](https://github.com/heartcombo/devise)               | Authentication and OAuth | 24333 | 2026-01-23  |
| [Spree](https://github.com/spree/spree)                      | E-Commerce and Payments  | 15216 | 2026-02-11  |
| [CocoaPods](https://github.com/CocoaPods/CocoaPods)          | Package Management       | 14801 | 2025-08-26  |
| [Logstash](https://github.com/elastic/logstash)              | DevOps Tools             | 14785 | 2026-02-11  |
| [Gollum](https://github.com/gollum/gollum)                   | Documentation            | 14234 | 2025-11-24  |
| [diaspora*](https://github.com/diaspora/diaspora)            | Social Networking        | 13876 | 2025-06-22  |

[Back to Top](#table-of-contents)

## API Builder and Discovery

| Name                                                                              | Description                                                                          | Stars | Last Commit |
|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|-------|-------------|
| [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) | ActiveModel::Serializer implementation and Rails hooks                               | 5341  | 2025-12-08  |
| [jbuilder](https://github.com/rails/jbuilder)                                     | Jbuilder: generate JSON objects with a Builder-style DSL                             | 4410  | 2026-02-10  |
| [rabl](https://github.com/nesquena/rabl)                                          | General ruby templating with json, bson, xml, plist and msgpack support              | 3638  | 2026-01-19  |
| [JSONAPI::Resources](https://github.com/cerebris/jsonapi-resources)               | A resource-focused Rails library for developing JSON:API compliant servers.          | 2325  | 2024-11-21  |
| [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)    | A fast JSON:API serializer for Ruby (fork of Netflix/fast_jsonapi)                   | 1434  | 2026-01-12  |
| [Alba](https://github.com/okuramasafumi/alba)                                     | Alba is a JSON serializer for Ruby, JRuby and TruffleRuby.                           | 1134  | 2026-02-09  |
| [versionist](https://github.com/bploetz/versionist)                               | A plugin for versioning Rails based RESTful APIs.                                    | 962   | 2024-02-22  |
| [Spyke](https://github.com/balvig/spyke)                                          | Interact with REST services in an ActiveRecord-like manner                           | 906   | 2025-11-04  |
| [Pliny](https://github.com/interagent/pliny)                                      | An opinionated toolkit for writing excellent APIs in Ruby.                           | 802   | 2026-01-28  |
| [Version Cake](https://github.com/bwillis/versioncake)                            | :cake: Version Cake is an unobtrusive way to version APIs in your Rails or Rack apps | 653   | 2022-07-21  |
| [Acts_As_Api](https://github.com/fabrik42/acts_as_api)                            | makes creating API responses in Rails easy and fun                                   | 504   | 2020-10-13  |

[Back to Top](#table-of-contents)

## Admin Interface

| Name                                                                | Description                                                                                                                                                                                                                                                                 | Stars | Last Commit |
|---------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Administrate](https://github.com/thoughtbot/administrate)          | A Rails engine that helps you put together a super-flexible admin dashboard.                                                                                                                                                                                                | 6016  | 2026-02-11  |
| [Trestle](https://github.com/TrestleAdmin/trestle)                  | A modern, responsive admin framework for Ruby on Rails                                                                                                                                                                                                                      | 1996  | 2025-09-25  |
| [ActiveScaffold](https://github.com/activescaffold/active_scaffold) | Save time and headaches, and create a more easily maintainable set of pages, with ActiveScaffold. ActiveScaffold handles all your CRUD (create, read, update, delete) user interface needs, leaving you more time to focus on more challenging (and interesting!) problems. | 1131  | 2026-02-10  |
| [MotorAdmin](https://github.com/motor-admin/motor-admin-rails)      | Low-code Admin panel and Business intelligence Rails engine. No DSL - configurable from the UI. Rails Admin, Active Admin, Blazer modern alternative.                                                                                                                       | 830   | 2026-02-01  |
| [Madmin](https://github.com/excid3/madmin)                          | A robust Admin Interface for Ruby on Rails apps                                                                                                                                                                                                                             | 739   | 2025-12-31  |

[Back to Top](#table-of-contents)

## Analytics

| Name                                                               | Description                                                                                                                              | Stars | Last Commit |
|--------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Ahoy](https://github.com/ankane/ahoy)                             | Simple, powerful, first-party analytics for Rails                                                                                        | 4429  | 2026-01-06  |
| [Impressionist](https://github.com/charlotte-ruby/impressionist)   | Rails Plugin that tracks impressions and page views                                                                                      | 1535  | 2026-02-08  |
| [Rack::Tracker](https://github.com/railslove/rack-tracker)         | Tracking made easy: Don’t fool around with adding tracking and analytics partials to your app and concentrate on the things that matter. | 648   | 2024-03-19  |
| [ActiveAnalytics](https://github.com/BaseSecrete/active_analytics) | First-party, privacy-focused traffic analytics for Ruby on Rails applications.                                                           | 513   | 2025-10-02  |

[Back to Top](#table-of-contents)

## Assets

| Name                                                     | Description                                                    | Stars | Last Commit |
|----------------------------------------------------------|----------------------------------------------------------------|-------|-------------|
| [Bourbon](https://github.com/thoughtbot/bourbon)         | A Lightweight Sass Tool Set                                    | 9042  | 2024-09-13  |
| [Asset Sync](https://github.com/AssetSync/asset_sync)    | Synchronises Assets between Rails and S3                       | 1894  | 2026-02-01  |
| [Vite Ruby](https://github.com/elmassimo/vite_ruby)      | ⚡️ Vite.js in Ruby, bringing joy to your JavaScript experience | 1564  | 2026-01-02  |
| [bower-rails](https://github.com/rharriso/bower-rails)   | Bundler-like DSL + rake tasks for Bower on Rails               | 1455  | 2023-04-24  |
| [Autoprefixer](https://github.com/ai/autoprefixer-rails) | Autoprefixer for Ruby and Ruby on Rails                        | 1212  | 2025-04-12  |
| [Sprockets](https://github.com/rails/sprockets)          | Rack-based asset packaging system                              | 974   | 2026-01-15  |

[Back to Top](#table-of-contents)

## Authentication and OAuth

| Name                                                                      | Description                                                                | Stars | Last Commit |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|-------|-------------|
| [Devise](https://github.com/heartcombo/devise)                            | Flexible authentication solution for Rails with Warden.                    | 24333 | 2026-01-23  |
| [OmniAuth](https://github.com/omniauth/omniauth)                          | OmniAuth is a flexible authentication system utilizing Rack middleware.    | 8053  | 2025-10-01  |
| [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)                | Doorkeeper is an OAuth 2 provider for Ruby on Rails / Grape.               | 5456  | 2026-02-09  |
| [Authlogic](https://github.com/binarylogic/authlogic)                     | A simple ruby authentication solution.                                     | 4347  | 2026-02-08  |
| [Clearance](https://github.com/thoughtbot/clearance)                      | Rails authentication with email & password.                                | 3734  | 2026-02-09  |
| [JWT](https://github.com/jwt/ruby-jwt)                                    | A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard. | 3677  | 2026-01-29  |
| [Rodauth](https://github.com/jeremyevans/rodauth)                         | Ruby's Most Advanced Authentication Framework                              | 1875  | 2026-01-08  |
| [Authentication Zero](https://github.com/lazaronixon/authentication-zero) | An authentication system generator for Rails applications.                 | 1874  | 2024-12-05  |
| [Sorcery](https://github.com/Sorcery/sorcery)                             | Magical Authentication                                                     | 1457  | 2026-02-08  |

[Back to Top](#table-of-contents)

## Authorization

| Name                                                        | Description                                                                      | Stars | Last Commit |
|-------------------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [CanCanCan](https://github.com/CanCanCommunity/cancancan)   | The authorization Gem for Ruby on Rails.                                         | 5670  | 2025-01-27  |
| [ActionPolicy](https://github.com/palkan/action_policy)     | Authorization framework for Ruby/Rails applications                              | 1521  | 2026-01-13  |
| [acl9](https://github.com/be9/acl9)                         | Yet another role-based authorization system for Rails                            | 852   | 2025-03-26  |
| [AccessGranted](https://github.com/chaps-io/access-granted) | Multi-role and whitelist based authorization gem for Rails (and not only Rails!) | 778   | 2024-05-08  |

[Back to Top](#table-of-contents)

## Automation

| Name                                                               | Description                                                              | Stars | Last Commit |
|--------------------------------------------------------------------|--------------------------------------------------------------------------|-------|-------------|
| [Danger](https://github.com/danger/danger)                         | 🚫 Stop saying "you forgot to …" in code review (in Ruby)                | 5638  | 2025-12-28  |
| [ActiveWorkflow](https://github.com/automaticmode/active_workflow) | Polyglot workflows without leaving the comfort of your technology stack. | 865   | 2023-04-03  |
| [Runbook](https://github.com/braintree/runbook)                    | A framework for gradual system automation                                | 755   | 2023-08-24  |

[Back to Top](#table-of-contents)

## Breadcrumbs

| Name                                                                   | Description                                                                                                                                                                 | Stars | Last Commit |
|------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Breadcrumbs on Rails](https://github.com/weppos/breadcrumbs_on_rails) | A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.                                                                                            | 955   | 2024-12-11  |
| [Gretel](https://github.com/lassebunk/gretel)                          | Flexible Ruby on Rails breadcrumbs plugin.                                                                                                                                  | 890   | 2024-09-01  |
| [Simple Navigation](https://github.com/codeplant/simple-navigation)    | A ruby gem for creating navigations (with multiple levels) for your Rails, Sinatra or Padrino applications.  Render your navigation as html list, link list or breadcrumbs. | 888   | 2026-02-04  |

[Back to Top](#table-of-contents)

## Business logic

| Name                                                                      | Description                                                                                                                         | Stars | Last Commit |
|---------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Interactor](https://github.com/collectiveidea/interactor)                | Interactor provides a common interface for performing complex user interactions.                                                    | 3454  | 2025-07-10  |
| [wisper](https://github.com/krisleech/wisper)                             | A micro library providing Ruby objects with Publish-Subscribe capabilities                                                          | 3325  | 2024-08-15  |
| [ActiveInteraction](https://github.com/AaronLasseigne/active_interaction) | :briefcase: Manage application specific business logic.                                                                             | 2137  | 2025-11-28  |
| [Mutations](https://github.com/cypriss/mutations)                         | Compose your business logic into commands that sanitize and validate input.                                                         | 1396  | 2026-01-15  |
| [Light Service](https://github.com/adomokos/light-service)                | Series of Actions with an emphasis on simplicity.                                                                                   | 878   | 2026-01-03  |
| [Waterfall](https://github.com/apneadiving/waterfall)                     | A slice of functional programming to chain ruby services and blocks, thus providing a new approach to flow control. Make them flow! | 618   | 2020-03-11  |

[Back to Top](#table-of-contents)

## CLI Builder

| Name                                                   | Description                                                        | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------|-------|-------------|
| [Rake](https://github.com/ruby/rake)                   | A make-like build utility for Ruby.                                | 2435  | 2026-02-10  |
| [GLI](https://github.com/davetron5000/gli)             | Make awesome command-line applications the easy way                | 1275  | 2025-03-09  |
| [Slop](https://github.com/leejarvis/slop)              | Simple Lightweight Option Parsing - ✨ new contributors welcome ✨ | 1131  | 2025-10-06  |
| [Commander](https://github.com/commander-rb/commander) | The complete solution for Ruby command-line executables            | 823   | 2024-01-15  |

[Back to Top](#table-of-contents)

## CLI Utilities

| Name                                                              | Description                                                                                                                                    | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Tmuxinator](https://github.com/tmuxinator/tmuxinator)            | Manage complex tmux sessions easily                                                                                                            | 13403 | 2026-01-25  |
| [colorls](https://github.com/athityakumar/colorls)                | A Ruby gem that beautifies the terminal's ls command, with color and font-awesome icons. :tada:                                                | 5112  | 2025-12-24  |
| [Awesome Print](https://github.com/awesome-print/awesome_print)   | Pretty print your Ruby objects with style -- in full color and with proper indentation                                                         | 4086  | 2024-08-15  |
| [Betty](https://github.com/pickhardt/betty)                       | Friendly English-like interface for your command line. Don't remember a command? Ask Betty.                                                    | 2609  | 2021-06-24  |
| [Ruby/Progressbar](https://github.com/jfelchner/ruby-progressbar) | Ruby/ProgressBar is a text progress bar library for Ruby.                                                                                      | 1590  | 2026-01-08  |
| [Terminal Table](https://github.com/tj/terminal-table)            | Ruby ASCII Table Generator, simple and feature rich.                                                                                           | 1572  | 2025-11-24  |
| [colorize](https://github.com/fazibear/colorize)                  | Ruby string class extension. It add some methods to set color, background color and text effect on console easier using ANSI escape sequences. | 1283  | 2024-05-21  |
| [TablePrint](https://github.com/arches/table_print)               | The best data slicer! Watch a 3 minute screencast at http://tableprintgem.com                                                                  | 904   | 2023-03-21  |

[Back to Top](#table-of-contents)

## CMS

| Name                                                                        | Description                                                                                                                 | Stars | Last Commit |
|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) | ComfortableMexicanSofa is a powerful Ruby on Rails 5.2+ CMS (Content Management System) Engine                              | 2723  | 2024-05-27  |
| [Publify](https://github.com/publify/publify)                               | A self hosted Web publishing platform on Rails.                                                                             | 1857  | 2026-02-09  |
| [Fae](https://github.com/wearefine/fae)                                     | CMS for Rails. For Reals.                                                                                                   | 855   | 2026-02-05  |
| [Storytime](https://github.com/CultivateLabs/storytime)                     | Storytime is a Rails 4+ CMS and blogging engine, with a core focus on content. It is built and maintained by @cultivatelabs | 748   | 2024-10-16  |

[Back to Top](#table-of-contents)

## CRM

| Name                                                       | Description                | Stars | Last Commit |
|------------------------------------------------------------|----------------------------|-------|-------------|
| [Fat Free CRM](https://github.com/fatfreecrm/fat_free_crm) | Ruby on Rails CRM platform | 3628  | 2026-01-08  |

[Back to Top](#table-of-contents)

## Caching

| Name                                                       | Description                                                                                     | Stars | Last Commit |
|------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [IdentityCache](https://github.com/Shopify/identity_cache) | IdentityCache is a blob level caching solution to plug into Active Record. Don't #find, #fetch! | 1962  | 2026-02-09  |
| [Readthis](https://github.com/sorentwo/readthis)           | :newspaper: Pooled active support compliant caching with redis                                  | 500   | 2019-09-30  |

[Back to Top](#table-of-contents)

## Captchas and anti-spam

| Name                                                              | Description                                                | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------|-------|-------------|
| [reCAPTCHA](https://github.com/ambethia/recaptcha)                | ReCaptcha helpers for ruby apps                            | 2005  | 2025-09-19  |
| [Invisible Captcha](https://github.com/markets/invisible_captcha) | 🍯 Unobtrusive and flexible spam protection for Rails apps | 1238  | 2025-01-30  |

[Back to Top](#table-of-contents)

## Cloud

| Name                                                    | Description                      | Stars | Last Commit |
|---------------------------------------------------------|----------------------------------|-------|-------------|
| [Fog](https://github.com/fog/fog)                       | The Ruby cloud services library. | 4310  | 2024-11-19  |
| [AWS SDK for Ruby](https://github.com/aws/aws-sdk-ruby) | The official AWS SDK for Ruby    | 3644  | 2026-02-11  |

[Back to Top](#table-of-contents)

## Code Analysis and Metrics

| Name                                                   | Description                                                                                                                                                                         | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Scientist](https://github.com/github/scientist)       | :microscope: A Ruby library for carefully refactoring critical paths.                                                                                                               | 7672  | 2025-11-24  |
| [Brakeman](https://github.com/presidentbeef/brakeman)  | A static analysis security vulnerability scanner for Ruby on Rails applications                                                                                                     | 7195  | 2026-02-05  |
| [Reek](https://github.com/troessner/reek)              | Code smell detector for Ruby                                                                                                                                                        | 4130  | 2026-01-30  |
| [Sorbet](https://github.com/sorbet/sorbet)             | A fast, powerful type checker designed for Ruby                                                                                                                                     | 3754  | 2026-02-12  |
| [Rubycritic](https://github.com/whitesmith/rubycritic) | A Ruby code quality reporter                                                                                                                                                        | 3473  | 2026-01-27  |
| [Coverband](https://github.com/danmayer/coverband)     | Ruby production code coverage collection and reporting (line of code usage)                                                                                                         | 2639  | 2026-02-10  |
| [Fasterer](https://github.com/DamirSvrtan/fasterer)    | :zap: Don't make your Rubies go fast. Make them go fasterer ™. :zap:                                                                                                                | 1817  | 2024-06-14  |
| [Suture](https://github.com/testdouble/suture)         | 🏥 A Ruby gem that helps you refactor your legacy code                                                                                                                              | 1409  | 2023-09-29  |
| [Flog](https://github.com/seattlerb/flog)              | Flog reports the most tortured code in an easy to read pain report. The higher the score, the more pain the code is in.                                                             | 959   | 2026-01-07  |
| [Traceroute](https://github.com/amatsuda/traceroute)   | A Rake task gem that helps you find the unused routes and controller actions for your Rails 3+ app                                                                                  | 904   | 2025-04-29  |
| [Flay](https://github.com/seattlerb/flay)              | Flay analyzes code for structural similarities. Differences in literal values, variable, class, method names, whitespace, programming style, braces vs do/end, etc are all ignored. | 758   | 2026-01-07  |
| [MetricFu](https://github.com/metricfu/metric_fu)      | A fist full of code metrics                                                                                                                                                         | 624   | 2024-02-27  |

[Back to Top](#table-of-contents)

## Code Formatting

| Name                                                | Description          | Stars | Last Commit |
|-----------------------------------------------------|----------------------|-------|-------------|
| [prettier](https://github.com/prettier/plugin-ruby) | Prettier Ruby Plugin | 1492  | 2025-03-06  |

[Back to Top](#table-of-contents)

## Code Highlighting

| Name                                           | Description                                                                | Stars | Last Commit |
|------------------------------------------------|----------------------------------------------------------------------------|-------|-------------|
| [CodeRay](https://github.com/rubychan/coderay) | Fast and easy syntax highlighting for selected languages, written in Ruby. | 855   | 2025-09-05  |

[Back to Top](#table-of-contents)

## Code Loaders

| Name                                        | Description                                    | Stars | Last Commit |
|---------------------------------------------|------------------------------------------------|-------|-------------|
| [Zeitwerk](https://github.com/fxn/zeitwerk) | Efficient and thread-safe code loader for Ruby | 2100  | 2026-02-10  |

[Back to Top](#table-of-contents)

## Coding Style Guides

| Name                                               | Description                                                 | Stars | Last Commit |
|----------------------------------------------------|-------------------------------------------------------------|-------|-------------|
| [Best-Ruby](https://github.com/franzejr/best-ruby) | Ruby Tricks, Idiomatic Ruby, Refactoring and Best Practices | 2393  | 2023-04-12  |

[Back to Top](#table-of-contents)

## Concurrency and Parallelism

| Name                                                                   | Description                                                                                                                                                                                    | Stars | Last Commit |
|------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Concurrent Ruby](https://github.com/ruby-concurrency/concurrent-ruby) | Modern concurrency tools including agents, futures, promises, thread pools, supervisors, and more. Inspired by Erlang, Clojure, Scala, Go, Java, JavaScript, and classic concurrency patterns. | 5811  | 2026-01-11  |
| [EventMachine](https://github.com/eventmachine/eventmachine)           | EventMachine: fast, simple event-processing library for Ruby programs                                                                                                                          | 4282  | 2024-09-16  |
| [Parallel](https://github.com/grosser/parallel)                        | Ruby: parallel processing made simple and fast                                                                                                                                                 | 4231  | 2025-12-03  |
| [Polyphony](https://github.com/digital-fabric/polyphony)               | Fine-grained concurrency for Ruby                                                                                                                                                              | 661   | 2024-03-25  |

[Back to Top](#table-of-contents)

## Configuration

| Name                                                    | Description                                                                                                           | Stars | Last Commit |
|---------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [dotenv](https://github.com/bkeepers/dotenv)            | A Ruby gem to load environment variables from `.env`.                                                                 | 6730  | 2025-12-03  |
| [Figaro](https://github.com/laserlemon/figaro)          | Simple Rails app configuration                                                                                        | 3753  | 2025-06-29  |
| [AnywayConfig](https://github.com/palkan/anyway_config) | Configuration library for Ruby gems and applications                                                                  | 880   | 2026-01-28  |
| [Configatron](https://github.com/markbates/configatron) | A super cool, simple, and feature rich configuration system for Ruby apps.                                            | 597   | 2024-05-12  |
| [Sail](https://github.com/vinistock/sail)               | Sail is a lightweight Rails engine that brings an admin panel for managing configuration settings on a live Rails app | 505   | 2023-01-30  |

[Back to Top](#table-of-contents)

## Core Extensions

| Name                                                      | Description                                                                                                                                                                                                                       | Stars | Last Commit |
|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Virtus](https://github.com/solnic/virtus)                | [DISCONTINUED ] Attributes on Steroids for Plain Old Ruby Objects                                                                                                                                                                 | 3755  | 2021-08-10  |
| [Hamster](https://github.com/hamstergem/hamster)          | Efficient, Immutable, Thread-Safe Collection classes for Ruby                                                                                                                                                                     | 1965  | 2021-11-30  |
| [Addressable](https://github.com/sporkmonger/addressable) | Addressable is an alternative implementation to the URI implementation that is part of Ruby's standard library. It is flexible, offers heuristic parsing, and additionally provides extensive support for IRIs and URI templates. | 1594  | 2026-01-28  |
| [ActiveAttr](https://github.com/cgriego/active_attr)      | What ActiveModel left out                                                                                                                                                                                                         | 1199  | 2025-11-21  |
| [Ruby Facets](https://github.com/rubyworks/facets)        | Ruby Facets                                                                                                                                                                                                                       | 804   | 2023-10-19  |
| [MemoWise](https://github.com/panorama-ed/memo_wise)      | The wise choice for Ruby memoization                                                                                                                                                                                              | 625   | 2026-02-02  |
| [AttrExtras](https://github.com/barsoom/attr_extras)      | Takes some boilerplate out of Ruby with methods like attr_initialize.                                                                                                                                                             | 563   | 2025-11-20  |

[Back to Top](#table-of-contents)

## Country Data

| Name                                           | Description                                                                           | Stars | Last Commit |
|------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [Phonelib](https://github.com/daddyz/phonelib) | Ruby gem for phone validation and formatting using google libphonenumber library data | 1142  | 2026-02-04  |
| [Phony](https://github.com/floere/phony)       | E164 international phone number normalizing, splitting, formatting.                   | 1088  | 2025-12-13  |

[Back to Top](#table-of-contents)

## Dashboards

| Name                                                        | Description                                               | Stars | Last Commit |
|-------------------------------------------------------------|-----------------------------------------------------------|-------|-------------|
| [Blazer](https://github.com/ankane/blazer)                  | Business intelligence made simple                         | 4762  | 2026-01-05  |
| [Dashing-Rails](https://github.com/gottfrois/dashing-rails) | The exceptionally handsome dashboard framework for Rails. | 1447  | 2020-01-06  |

[Back to Top](#table-of-contents)

## Data Processing and ETL

| Name                                                   | Description                                                             | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------------------------------------------------|-------|-------------|
| [Multiwoven](https://github.com/Multiwoven/multiwoven) | 🔥🔥🔥 Open source Reverse ETL -  alternative to hightouch and census.  | 1641  | 2026-02-11  |

[Back to Top](#table-of-contents)

## Data Visualization

| Name                                                            | Description                                                                                                        | Stars | Last Commit |
|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Rails Erd](https://github.com/voormedia/rails-erd)             | Generate Entity-Relationship Diagrams for Rails applications                                                       | 4074  | 2023-10-12  |
| [RailRoady](https://github.com/preston/railroady)               | Ruby on Rails model and controller UML class diagram generator. (`brew/port/apt-get install graphviz` before use!) | 1709  | 2023-08-02  |
| [GeoPattern](https://github.com/jasonlong/geo_pattern)          | Create beautiful generative geometric background images from a string.                                             | 1273  | 2025-04-22  |
| [LazyHighCharts](https://github.com/michelson/lazy_high_charts) | Make highcharts a la ruby , works in rails 5.X / 4.X / 3.X, and other ruby web frameworks                          | 1052  | 2023-02-11  |
| [Ruby/GraphViz](https://github.com/glejeune/Ruby-Graphviz)      | [MIRROR] Ruby interface to the GraphViz graphing tool                                                              | 620   | 2025-03-16  |

[Back to Top](#table-of-contents)

## Database Drivers

| Name                                                                            | Description                                                                                                                      | Stars | Last Commit |
|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [redis-rb](https://github.com/redis/redis-rb)                                   | A Ruby client library for Redis                                                                                                  | 3998  | 2026-02-02  |
| [mysql2](https://github.com/brianmario/mysql2)                                  | A modern, simple and very fast Mysql library for Ruby - binding to libmysql                                                      | 2279  | 2025-10-22  |
| [mongo-ruby-driver](https://github.com/mongodb/mongo-ruby-driver)               | The Official MongoDB Ruby Driver                                                                                                 | 1436  | 2026-02-06  |
| [SQL Server](https://github.com/rails-sqlserver/activerecord-sqlserver-adapter) | SQL Server Adapter For Rails                                                                                                     | 983   | 2026-02-08  |
| [ruby-pg](https://github.com/ged/ruby-pg)                                       | A PostgreSQL client library for Ruby                                                                                             | 854   | 2026-02-11  |
| [SQLite3](https://github.com/sparklemotion/sqlite3-ruby)                        | Ruby bindings for the SQLite3 embedded database                                                                                  | 830   | 2026-01-27  |
| [Trilogy](https://github.com/trilogy-libraries/trilogy)                         | Trilogy is a client library for MySQL-compatible database servers, designed for performance, flexibility, and ease of embedding. | 760   | 2026-02-03  |
| [TinyTDS](https://github.com/rails-sqlserver/tiny_tds)                          | TinyTDS - Simple and fast FreeTDS bindings for Ruby using DB-Library.                                                            | 615   | 2026-01-06  |
| [Neography](https://github.com/maxdemarzi/neography)                            | A thin Ruby wrapper to the Neo4j Rest API                                                                                        | 604   | 2017-02-27  |

[Back to Top](#table-of-contents)

## Database Tools

| Name                                                                    | Description                                                                                                                                                                                                               | Stars | Last Commit |
|-------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [PgHero](https://github.com/ankane/pghero)                              | A performance dashboard for Postgres                                                                                                                                                                                      | 8786  | 2025-12-26  |
| [Strong Migrations](https://github.com/ankane/strong_migrations)        | Catch unsafe migrations in development                                                                                                                                                                                    | 4347  | 2026-01-05  |
| [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner) | Strategies for cleaning databases in Ruby.  Can be used to ensure a clean state for testing.                                                                                                                              | 2960  | 2025-07-07  |
| [Large Hadron Migrator](https://github.com/soundcloud/lhm)              | Online MySQL schema migrations                                                                                                                                                                                            | 1853  | 2025-10-28  |
| [connection_pool](https://github.com/mperham/connection_pool)           | Generic connection pooling for Ruby                                                                                                                                                                                       | 1679  | 2026-01-12  |
| [Lol DBA](https://github.com/plentz/lol_dba)                            | lol_dba is a small package of rake tasks that scan your application models and displays a list of columns that probably should be indexed. Also, it can generate .sql migration scripts.                                  | 1599  | 2024-03-07  |
| [Rails DB](https://github.com/igorkasyanchuk/rails_db)                  | Rails Database Viewer and SQL Query Runner                                                                                                                                                                                | 1491  | 2025-07-09  |
| [Seed dump](https://github.com/rroblak/seed_dump)                       | Rails task to dump your data to db/seeds.rb                                                                                                                                                                               | 1409  | 2025-12-25  |
| [Foreigner](https://github.com/matthuhiggins/foreigner)                 | Adds foreign key helpers to migrations and correctly dumps foreign keys to schema.rb                                                                                                                                      | 1319  | 2019-02-06  |
| [Seed Fu](https://github.com/mbleigh/seed-fu)                           | Advanced seed data handling for Rails, combining the best practices of several methods together.                                                                                                                          | 1236  | 2022-08-09  |
| [Database Consistency](https://github.com/djezzzl/database_consistency) | The tool to avoid various issues due to inconsistencies and inefficiencies between a database schema and application models.                                                                                              | 1162  | 2025-12-10  |
| [Seedbank](https://github.com/james2m/seedbank)                         | Seedbank gives your seed data a little structure. Create seeds for each environment, share seeds between environments and specify dependencies to load your seeds in order. All nicely integrated with simple rake tasks. | 1144  | 2023-12-07  |
| [Polo](https://github.com/IFTTT/polo)                                   | Polo travels through your database and creates sample snapshots so you can work with real world data in development.                                                                                                      | 789   | 2025-08-12  |
| [Online Migrations](https://github.com/fatkodima/online_migrations)     | Catch unsafe PostgreSQL migrations in development and run them easier in production (code helpers for table/column renaming, changing column type, adding columns with default, background migrations, etc).              | 716   | 2026-02-08  |
| [SchemaPlus](https://github.com/SchemaPlus/schema_plus)                 | SchemaPlus provides a collection of enhancements and extensions to ActiveRecord                                                                                                                                           | 677   | 2022-05-13  |
| [Rein](https://github.com/nullobject/rein)                              | Database constraints made easy for ActiveRecord.                                                                                                                                                                          | 672   | 2020-10-27  |
| [Upsert](https://github.com/seamusabshere/upsert)                       | Upsert on MySQL, PostgreSQL, and SQLite3. Transparently creates functions (UDF) for MySQL and PostgreSQL; on SQLite3, uses INSERT OR IGNORE.                                                                              | 647   | 2021-02-20  |

[Back to Top](#table-of-contents)

## Date and Time Processing

| Name                                                                  | Description                                                                                                             | Stars | Last Commit |
|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [groupdate](https://github.com/ankane/groupdate)                      | The simplest way to group temporal data                                                                                 | 3874  | 2025-12-26  |
| [Chronic](https://github.com/mojombo/chronic)                         | Chronic is a pure Ruby natural language date parser.                                                                    | 3255  | 2023-09-28  |
| [local_time](https://github.com/basecamp/local_time)                  | Rails engine for cache-friendly, client-side local time                                                                 | 1990  | 2025-03-12  |
| [validates_timeliness](https://github.com/adzap/validates_timeliness) | Date and time validation plugin for ActiveModel and Rails.  Supports multiple ORMs and allows custom date/time formats. | 1614  | 2025-12-06  |
| [business_time](https://github.com/bokmann/business_time)             | Support for doing time math in business hours and days                                                                  | 1326  | 2025-12-27  |
| [ByStar](https://github.com/radar/by_star)                            | Lets you find ActiveRecord + Mongoid objects by year, month, fortnight, week and more!                                  | 1048  | 2023-01-18  |
| [stamp](https://github.com/jeremyw/stamp)                             | Date and time formatting for humans.                                                                                    | 962   | 2020-07-22  |
| [montrose](https://github.com/rossta/montrose)                        | Recurring events library for Ruby. Enumerable recurrence objects and convenient chainable interface.                    | 856   | 2025-01-25  |
| [holidays](https://github.com/holidays/holidays)                      | A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!                         | 844   | 2024-08-11  |
| [working_hours](https://github.com/intrepidd/working_hours)           | ⏰ A modern ruby gem allowing to do time calculation with business / working hours.                                     | 536   | 2026-01-28  |

[Back to Top](#table-of-contents)

## Debugging Tools

| Name                                                                    | Description                                             | Stars | Last Commit |
|-------------------------------------------------------------------------|---------------------------------------------------------|-------|-------------|
| [Byebug](https://github.com/deivid-rodriguez/byebug)                    | Debugging in Ruby                                       | 3353  | 2026-02-09  |
| [Pry Byebug](https://github.com/deivid-rodriguez/pry-byebug)            | Step-by-step debugging and stack navigation in Pry      | 2028  | 2026-02-09  |
| [Seeing Is Believing](https://github.com/JoshCheek/seeing_is_believing) | Displays the results of every line of code in your file | 1319  | 2025-11-11  |
| [Xray](https://github.com/brentd/xray-rails)                            | ☠️ A development tool that reveals your UI's bones       | 1224  | 2024-12-07  |

[Back to Top](#table-of-contents)

## Decorators

| Name                                                             | Description                                                 | Stars | Last Commit |
|------------------------------------------------------------------|-------------------------------------------------------------|-------|-------------|
| [Draper](https://github.com/drapergem/draper)                    | Decorators/View-Models for Rails Applications               | 5267  | 2025-11-16  |
| [Responders](https://github.com/heartcombo/responders)           | A set of Rails responders to dry up your application        | 2053  | 2026-01-05  |
| [Decent Exposure](https://github.com/hashrocket/decent_exposure) | A helper for creating declarative interfaces in controllers | 1806  | 2023-04-11  |

[Back to Top](#table-of-contents)

## DevOps Tools

| Name                                               | Description                                                                                                                                                                                | Stars | Last Commit |
|----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Logstash](https://github.com/elastic/logstash)    | Logstash - transport and process your logs, events, or other data                                                                                                                          | 14785 | 2026-02-11  |
| [Kamal](https://github.com/basecamp/kamal)         | Deploy web apps anywhere.                                                                                                                                                                  | 13827 | 2026-02-04  |
| [Chef](https://github.com/chef/chef)               | Chef Infra, a powerful automation platform that transforms infrastructure into code automating how infrastructure is configured, deployed and managed across any environment, at any scale | 8359  | 2026-02-11  |
| [Puppet](https://github.com/puppetlabs/puppet)     | Server automation framework and application                                                                                                                                                | 7798  | 2025-02-04  |
| [Backup](https://github.com/backup/backup)         | Easy full stack backup operations on UNIX-like systems.                                                                                                                                    | 4877  | 2024-07-03  |
| [Mina](https://github.com/mina-deploy/mina)        | Blazing fast deployer and server automation tool                                                                                                                                           | 4364  | 2024-08-01  |
| [BOSH](https://github.com/cloudfoundry/bosh)       | Cloud Foundry BOSH is an open source tool chain for release engineering, deployment and lifecycle management of large scale distributed services.                                          | 2070  | 2026-02-12  |
| [Centurion](https://github.com/newrelic/centurion) | A mass deployment tool for Docker fleets                                                                                                                                                   | 1758  | 2025-09-11  |
| [Rubber](https://github.com/rubber/rubber)         | A capistrano/rails plugin that makes it easy to deploy/manage/scale to various service providers, including EC2, DigitalOcean, vSphere, and bare metal servers.                            | 1457  | 2020-11-23  |
| [Itamae](https://github.com/itamae-kitchen/itamae) | Configuration management tool inspired by Chef, but simpler and lightweight. Formerly known as Lightchef.                                                                                  | 1130  | 2026-02-01  |

[Back to Top](#table-of-contents)

## Diff

| Name                                   | Description          | Stars | Last Commit |
|----------------------------------------|----------------------|-------|-------------|
| [Diffy](https://github.com/samg/diffy) | Easy Diffing in Ruby | 1303  | 2025-06-09  |

[Back to Top](#table-of-contents)

## Discover

| Name                                                           | Description                                 | Stars | Last Commit |
|----------------------------------------------------------------|---------------------------------------------|-------|-------------|
| [Ruby Bookmarks](https://github.com/dreikanter/ruby-bookmarks) | Ruby and Ruby on Rails bookmarks collection | 2280  | 2025-08-21  |

[Back to Top](#table-of-contents)

## Documentation

| Name                                                                                                   | Description                                                                                        | Stars | Last Commit |
|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------|-------------|
| [Gollum](https://github.com/gollum/gollum)                                                             | A simple, Git-powered wiki with a local frontend and support for many kinds of markup and content. | 14234 | 2025-11-24  |
| [GitHub Changelog Generator](https://github.com/github-changelog-generator/github-changelog-generator) | Automatically generate change log from your tags, issues, labels and pull requests on GitHub.      | 7517  | 2025-12-29  |
| [Apipie](https://github.com/Apipie/apipie-rails)                                                       | Ruby on Rails API documentation tool                                                               | 2508  | 2025-11-07  |
| [Hologram](https://github.com/trulia/hologram)                                                         | A markdown based documentation system for style guides.                                            | 2270  | 2023-08-10  |
| [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)                          | Automatically generate API documentation from RSpec                                                | 1454  | 2025-07-24  |
| [grape-swagger](https://github.com/ruby-grape/grape-swagger)                                           | Add OAPI/swagger v2.0 compliant documentation to your grape API                                    | 1101  | 2026-02-03  |
| [RDoc](https://github.com/ruby/rdoc)                                                                   | RDoc produces HTML and online documentation for Ruby projects.                                     | 899   | 2026-02-09  |
| [AnnotateRb](https://github.com/drwl/annotaterb)                                                       | A Ruby Gem that adds annotations to your Rails models and route files.                             | 564   | 2026-02-12  |
| [Inch](https://github.com/rrrene/inch)                                                                 | A documentation analysis tool for the Ruby language                                                | 517   | 2024-01-12  |

[Back to Top](#table-of-contents)

## E-Commerce and Payments

| Name                                                                 | Description                                                                                                                                                                                                                                                                                                                                          | Stars | Last Commit |
|----------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Spree](https://github.com/spree/spree)                              | Spree Commerce is an API-first, open-source eCommerce platform for fast growing businesses and enterprises. Spree supports complex commerce scenarios natively — from B2B wholesale to multi-vendor marketplace to global multi-region or multi-tenant distributor platforms. Use each model independently or combine them as your business evolves. | 15216 | 2026-02-11  |
| [Solidus](https://github.com/solidusio/solidus)                      | 🛒 Solidus, the open-source eCommerce framework for industry trailblazers.                                                                                                                                                                                                                                                                           | 5263  | 2026-02-02  |
| [Active Merchant](https://github.com/activemerchant/active_merchant) | Active Merchant is a simple payment abstraction library extracted from Shopify. The aim of the project is to feel natural to Ruby users and to abstract as many parts as possible away from the user to offer a consistent interface across all supported gateways.                                                                                  | 4598  | 2025-11-04  |
| [stripe-ruby](https://github.com/stripe/stripe-ruby)                 | Ruby library for the Stripe API.                                                                                                                                                                                                                                                                                                                     | 2091  | 2026-02-11  |
| [ROR Ecommerce](https://github.com/drhenner/ror_ecommerce)           | Ruby on Rails Ecommerce platform, perfect for your small business solution.                                                                                                                                                                                                                                                                          | 1212  | 2023-06-13  |

[Back to Top](#table-of-contents)

## Ebook

| Name                                      | Description                                           | Stars | Last Commit |
|-------------------------------------------|-------------------------------------------------------|-------|-------------|
| [Review](https://github.com/kmuto/review) | Re:VIEW is flexible document format/conversion system | 1387  | 2025-12-07  |

[Back to Top](#table-of-contents)

## Email

| Name                                                           | Description                                                                                           | Stars | Last Commit |
|----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|-------|-------------|
| [LetterOpener](https://github.com/ryanb/letter_opener)         | Preview mail in the browser instead of sending.                                                       | 3834  | 2024-08-02  |
| [Mail](https://github.com/mikel/mail)                          | A Really Ruby Mail Library                                                                            | 3663  | 2025-10-22  |
| [premailer-rails](https://github.com/fphilipe/premailer-rails) | CSS styled emails without the hassle.                                                                 | 1748  | 2024-06-17  |
| [Griddler](https://github.com/thoughtbot/griddler)             | Simplify receiving email in Rails (deprecated)                                                        | 1365  | 2024-07-12  |
| [Roadie](https://github.com/Mange/roadie)                      | Making HTML emails comfortable for the Ruby rockstars                                                 | 1347  | 2025-10-01  |
| [Ahoy Email](https://github.com/ankane/ahoy_email)             | First-party email analytics for Rails                                                                 | 1176  | 2026-01-08  |
| [Pony](https://github.com/benprew/pony)                        | The express way to send mail from Ruby.                                                               | 1137  | 2025-04-08  |
| [Gibbon](https://github.com/amro/gibbon)                       | Gibbon is an API wrapper for MailChimp's API                                                          | 1065  | 2023-06-07  |
| [Sup](https://github.com/sup-heliotrope/sup)                   | A curses threads-with-tags style email client (mailing list: supmua@googlegroups.com)                 | 935   | 2025-10-12  |
| [MailForm](https://github.com/heartcombo/mail_form)            | Send e-mail straight from forms in Rails with I18n, validations, attachments and request information. | 876   | 2026-01-05  |
| [Maily](https://github.com/markets/maily)                      | 📫 Rails Engine to preview emails in the browser                                                      | 708   | 2024-03-17  |

[Back to Top](#table-of-contents)

## Encryption

| Name                                            | Description                                                                                                                                                   | Stars | Last Commit |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Themis](https://github.com/cossacklabs/themis) | Easy to use cryptographic framework for data protection: secure messaging with forward secrecy and secure data storage. Has unified APIs across 14 platforms. | 1950  | 2026-01-09  |

[Back to Top](#table-of-contents)

## Environment Management

| Name                                                       | Description                                 | Stars | Last Commit |
|------------------------------------------------------------|---------------------------------------------|-------|-------------|
| [chruby](https://github.com/postmodern/chruby)             | Changes the current Ruby                    | 2913  | 2025-10-27  |
| [ruby-install](https://github.com/postmodern/ruby-install) | Installs Ruby, JRuby, TruffleRuby, or mruby | 1965  | 2026-01-14  |

[Back to Top](#table-of-contents)

## Error Handling

| Name                                                                            | Description                                                           | Stars | Last Commit |
|---------------------------------------------------------------------------------|-----------------------------------------------------------------------|-------|-------------|
| [Errbit](https://github.com/errbit/errbit)                                      | The open source error catcher that's Airbrake API compliant :ukraine: | 4271  | 2026-02-11  |
| [Exception Notification](https://github.com/smartinez87/exception_notification) | Exception Notifier Plugin for Rails                                   | 2185  | 2025-03-22  |
| [Sentry Ruby](https://github.com/getsentry/sentry-ruby)                         | Sentry SDK for Ruby                                                   | 982   | 2026-02-11  |
| [Airbrake](https://github.com/airbrake/airbrake)                                | The official Airbrake library for Ruby applications                   | 972   | 2024-12-21  |
| [Exception Handler](https://github.com/richpeck/exception_handler)              | Ruby on Rails Custom Error Pages                                      | 509   | 2021-07-31  |

[Back to Top](#table-of-contents)

## Event Sourcing

| Name                                                                            | Description                                                    | Stars | Last Commit |
|---------------------------------------------------------------------------------|----------------------------------------------------------------|-------|-------------|
| [Rails Event Store (RES)](https://github.com/RailsEventStore/rails_event_store) | A Ruby implementation of an Event Store based on Active Record | 1505  | 2026-02-11  |

[Back to Top](#table-of-contents)

## Feature Flippers and A/B Testing

| Name                                          | Description                                                     | Stars | Last Commit |
|-----------------------------------------------|-----------------------------------------------------------------|-------|-------------|
| [Rollout](https://github.com/FetLife/rollout) | Feature flippers.                                               | 2905  | 2025-11-19  |
| [Split](https://github.com/splitrb/split)     | :chart_with_upwards_trend: The Rack Based A/B testing framework | 2714  | 2026-01-18  |
| [Vanity](https://github.com/assaf/vanity)     | Experiment Driven Development for Ruby                          | 1535  | 2023-03-16  |

[Back to Top](#table-of-contents)

## File System Listener

| Name                                                           | Description                                                                           | Stars | Last Commit |
|----------------------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [Guard](https://github.com/guard/guard)                        | Guard is a command line tool to easily handle events on file system modifications.    | 6681  | 2026-02-02  |
| [Guard::LiveReload](https://github.com/guard/guard-livereload) | Guard::LiveReload automatically reload your browser when 'view' files are modified.   | 2114  | 2022-11-07  |
| [Listen](https://github.com/guard/listen)                      | The Listen gem listens to file modifications and notifies you about the changes.      | 1951  | 2026-01-16  |
| [Rerun](https://github.com/alexch/rerun)                       | Restarts an app when the filesystem changes. Uses growl and FSEventStream if on OS X. | 990   | 2024-05-22  |

[Back to Top](#table-of-contents)

## File Upload

| Name                                                              | Description                                                                                          | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|-------|-------------|
| [PaperClip](https://github.com/thoughtbot/paperclip)              | Easy file attachment management for ActiveRecord                                                     | 8963  | 2023-07-13  |
| [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) | Classier solution for file uploads for Rails, Sinatra and other Ruby web frameworks                  | 8784  | 2026-01-10  |
| [Refile](https://github.com/refile/refile)                        | Ruby file uploads, take 3                                                                            | 2437  | 2024-07-01  |
| [DragonFly](https://github.com/markevans/dragonfly)               | A Ruby gem for on-the-fly processing - suitable for image uploading in Rails, Sinatra and much more! | 2112  | 2025-01-03  |

[Back to Top](#table-of-contents)

## Form Builder

| Name                                                     | Description                                                                                      | Stars | Last Commit |
|----------------------------------------------------------|--------------------------------------------------------------------------------------------------|-------|-------------|
| [Simple Form](https://github.com/heartcombo/simple_form) | Forms made easy for Rails! It's tied to a simple DSL, with no opinion on markup.                 | 8230  | 2026-01-05  |
| [Cocoon](https://github.com/nathanvda/cocoon)            | Dynamic nested forms using jQuery made easy; works with formtastic, simple_form or default forms | 3078  | 2023-08-08  |

[Back to Top](#table-of-contents)

## GUI

| Name                                             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                | Stars | Last Commit |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Glimmer](https://github.com/AndyObtiva/glimmer) | DSL Framework consisting of a DSL Engine and a Data-Binding Library used in Glimmer DSL for SWT (JRuby Desktop Development GUI Framework), Glimmer DSL for Opal (Pure Ruby Web GUI), Glimmer DSL for LibUI (Prerequisite-Free Ruby Desktop Development GUI Library), Glimmer DSL for Tk (Ruby Tk Desktop Development GUI Library), Glimmer DSL for GTK (Ruby-GNOME Desktop Development GUI Library), Glimmer DSL for XML (& HTML), and Glimmer DSL for CSS | 816   | 2025-12-03  |

[Back to Top](#table-of-contents)

## Game Development and Graphics

| Name                                        | Description        | Stars | Last Commit |
|---------------------------------------------|--------------------|-------|-------------|
| [Ruby 2D](https://github.com/ruby2d/ruby2d) | 🎨 The Ruby 2D gem | 675   | 2023-08-25  |

[Back to Top](#table-of-contents)

## Gem Servers

| Name                                                   | Description                                 | Stars | Last Commit |
|--------------------------------------------------------|---------------------------------------------|-------|-------------|
| [Gem in a box](https://github.com/geminabox/geminabox) | Really simple rubygem hosting               | 1525  | 2026-02-03  |
| [Gemstash](https://github.com/rubygems/gemstash)       | A RubyGems.org cache and private gem server | 782   | 2026-02-09  |

[Back to Top](#table-of-contents)

## Geolocation

| Name                                                                          | Description                                                                                                                                                                | Stars | Last Commit |
|-------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Geocoder](https://github.com/alexreisner/geocoder)                           | Complete Ruby geocoding solution.                                                                                                                                          | 6439  | 2026-01-22  |
| [Google Maps for Rails](https://github.com/apneadiving/Google-Maps-for-Rails) | Enables easy Google map + overlays creation in Ruby apps                                                                                                                   | 2257  | 2018-02-02  |
| [Geokit](https://github.com/geokit/geokit)                                    | Official Geokit Gem. Geokit gem provides geocoding and distance/heading calculations. Pair with the geokit-rails plugin for full-fledged location-based app functionality. | 1636  | 2024-07-29  |
| [rgeo](https://github.com/rgeo/rgeo)                                          | Geospatial data library for Ruby                                                                                                                                           | 1043  | 2026-01-22  |
| [geoip](https://github.com/cjheath/geoip)                                     | The Ruby gem for querying Maxmind.com's GeoIP database, which returns the geographic location of a server given its IP address                                             | 722   | 2019-04-28  |

[Back to Top](#table-of-contents)

## Git Tools

| Name                                                  | Description                                                                                                                                                          | Stars | Last Commit |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Rugged](https://github.com/libgit2/rugged)           | ruby bindings to libgit2                                                                                                                                             | 2288  | 2025-01-03  |
| [git_reflow](https://github.com/reenhanced/gitreflow) | Reflow automatically creates pull requests, ensures the code review is approved, and squash merges finished branches to master with a great commit message template. | 1492  | 2022-03-01  |
| [ginatra](https://github.com/NARKOZ/ginatra)          | A web frontend for Git repositories                                                                                                                                  | 525   | 2025-12-05  |

[Back to Top](#table-of-contents)

## GraphQL

| Name                                                      | Description                                   | Stars | Last Commit |
|-----------------------------------------------------------|-----------------------------------------------|-------|-------------|
| [graphql-ruby](https://github.com/rmosolgo/graphql-ruby)  | Ruby implementation of GraphQL                | 5433  | 2026-02-09  |
| [graphql-batch](https://github.com/Shopify/graphql-batch) | A query batching executor for the graphql gem | 1437  | 2026-02-09  |

[Back to Top](#table-of-contents)

## HTML/XML Parsing

| Name                                | Description               | Stars | Last Commit |
|-------------------------------------|---------------------------|-------|-------------|
| [Ox](https://github.com/ohler55/ox) | Ruby Optimized XML Parser | 911   | 2025-11-25  |

[Back to Top](#table-of-contents)

## HTTP Clients and tools

| Name                                                          | Description                                                                                                    | Stars | Last Commit |
|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Faraday](https://github.com/lostisland/faraday)              | Simple, but flexible HTTP client library, with support for multiple backends.                                  | 5900  | 2026-02-09  |
| [httparty](https://github.com/jnunemaker/httparty)            | :tada: Makes http fun again!                                                                                   | 5897  | 2026-01-14  |
| [RESTClient](https://github.com/rest-client/rest-client)      | Simple HTTP and REST client for Ruby, inspired by microframework syntax for specifying actions.                | 5230  | 2024-05-19  |
| [Typhoeus](https://github.com/typhoeus/typhoeus)              |  Typhoeus wraps libcurl in order to make fast and reliable requests.                                           | 4128  | 2025-08-26  |
| [Rack::Cors](https://github.com/cyu/rack-cors)                | Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.     | 3291  | 2025-05-16  |
| [HTTP](https://github.com/httprb/http)                        | HTTP (The Gem! a.k.a. http.rb) - a fast Ruby HTTP client with a chainable API, streaming support, and timeouts | 3141  | 2025-06-30  |
| [Savon](https://github.com/savonrb/savon)                     | Heavy metal SOAP client                                                                                        | 2080  | 2026-01-22  |
| [excon](https://github.com/excon/excon)                       | Usable, fast, simple HTTP 1.1 for Ruby                                                                         | 1172  | 2026-02-03  |
| [Http-2](https://github.com/igrigorik/http-2)                 | Pure Ruby implementation of HTTP/2 protocol                                                                    | 906   | 2026-02-06  |
| [Device Detector](https://github.com/podigee/device_detector) | DeviceDetector is a precise and fast user agent parser and device detector written in Ruby                     | 773   | 2025-11-10  |
| [Http Client](https://github.com/nahi/httpclient)             | 'httpclient' gives something like the functionality of libwww-perl (LWP) in Ruby.                              | 707   | 2025-02-22  |
| [Sniffer](https://github.com/aderyabin/sniffer)               | Log and Analyze Outgoing HTTP Requests                                                                         | 584   | 2023-10-12  |
| [Patron](https://github.com/toland/patron)                    | Ruby HTTP client based on libcurl                                                                              | 546   | 2025-02-27  |

[Back to Top](#table-of-contents)

## IRB

| Name                                             | Description                                                                               | Stars | Last Commit |
|--------------------------------------------------|-------------------------------------------------------------------------------------------|-------|-------------|
| [Pry](https://github.com/pry/pry)                | A runtime developer console and IRB alternative with powerful introspection capabilities. | 6827  | 2026-02-07  |
| [irbtools](https://github.com/janlelis/irbtools) | Improvements for Ruby's IRB console 💎︎                                                    | 924   | 2025-12-29  |

[Back to Top](#table-of-contents)

## Image Processing

| Name                                                         | Description                                                                                     | Stars | Last Commit |
|--------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [PSD.rb](https://github.com/layervault/psd.rb)               | Parse Photoshop files in Ruby with ease                                                         | 3120  | 2021-01-08  |
| [MiniMagick](https://github.com/minimagick/minimagick)       | mini replacement for RMagick                                                                    | 2859  | 2025-08-19  |
| [FastImage](https://github.com/sdsykes/fastimage)            | FastImage finds the size or type of an image given its uri by fetching as little as needed      | 1378  | 2025-01-03  |
| [ImageProcessing](https://github.com/janko/image_processing) | High-level image processing wrapper for libvips and ImageMagick/GraphicsMagick                  | 937   | 2025-08-22  |
| [RMagick](https://github.com/rmagick/rmagick)                | Ruby bindings for ImageMagick                                                                   | 726   | 2026-02-10  |
| [Phasion](https://github.com/westonplatter/phashion)         | Ruby wrapper around pHash, the perceptual hash library for detecting duplicate multimedia files | 707   | 2025-10-23  |

[Back to Top](#table-of-contents)

## Implementations/Compilers

| Name                                               | Description                                               | Stars | Last Commit |
|----------------------------------------------------|-----------------------------------------------------------|-------|-------------|
| [MRuby](https://github.com/mruby/mruby)            | Lightweight Ruby                                          | 5522  | 2026-02-10  |
| [Opal](https://github.com/opal/opal)               | Ruby ♥︎ JavaScript                                         | 4910  | 2026-01-26  |
| [JRuby](https://github.com/jruby/jruby)            | JRuby, an implementation of Ruby on the JVM               | 3866  | 2026-02-11  |
| [Rubinius](https://github.com/rubinius/rubinius)   | The Rubinius Language Platform                            | 3093  | 2025-09-11  |
| [Natalie](https://github.com/natalie-lang/natalie) | a work-in-progress Ruby compiler, written in Ruby and C++ | 1022  | 2026-02-04  |

[Back to Top](#table-of-contents)

## Internationalization

| Name                                                          | Description                                                                                                                                           | Stars | Last Commit |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [rails-i18n](https://github.com/svenfuchs/rails-i18n)         | Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting, Rails related I18n stuff                                   | 4026  | 2026-01-05  |
| [Globalize](https://github.com/globalize/globalize)           | Rails I18n de-facto standard library for ActiveRecord model/data translation.                                                                         | 2161  | 2025-12-23  |
| [i18n-tasks](https://github.com/glebm/i18n-tasks)             | Manage translation and localization with static analysis, for Ruby i18n                                                                               | 2151  | 2026-02-07  |
| [twitter-cldr-rb](https://github.com/twitter/twitter-cldr-rb) | Ruby implementation of the ICU (International Components for Unicode) that uses the Common Locale Data Repository to format dates, plurals, and more. | 690   | 2025-12-18  |
| [Tolk](https://github.com/tolk/tolk)                          | Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications                                                      | 609   | 2025-01-18  |
| [Termit](https://github.com/pawurb/termit)                    | Translations with speech synthesis in your terminal as a ruby gem                                                                                     | 507   | 2017-05-25  |

[Back to Top](#table-of-contents)

## Logging

| Name                                           | Description                                                                                      | Stars | Last Commit |
|------------------------------------------------|--------------------------------------------------------------------------------------------------|-------|-------------|
| [Fluentd](https://github.com/fluent/fluentd)   | Fluentd: Unified Logging Layer (project under CNCF)                                              | 13494 | 2026-02-10  |
| [Lograge](https://github.com/roidrage/lograge) | An attempt to tame Rails' default policy to log everything.                                      | 3555  | 2024-11-10  |
| [HttpLog](https://github.com/trusche/httplog)  | Log outgoing HTTP requests in ruby                                                               | 826   | 2026-02-11  |
| [Logging](https://github.com/TwP/logging)      | A flexible logging library for use in Ruby programs based on the design of Java's log4j library. | 532   | 2024-07-14  |

[Back to Top](#table-of-contents)

## Machine Learning

| Name                                                                                      | Description                                                                                                                                                          | Stars | Last Commit |
|-------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [ruby-openai](https://github.com/alexrudall/ruby-openai)                                  | OpenAI API + Ruby! 🤖❤️ GPT-5 & Realtime WebRTC compatible!                                                                                                           | 3210  | 2025-08-29  |
| [m2cgen](https://github.com/BayesWitnesses/m2cgen)                                        | Transform ML models into a native code (Java, C, Python, Go, JavaScript, Visual Basic, C#, R, PowerShell, PHP, Dart, Haskell, Ruby, F#, Rust) with zero dependencies | 2956  | 2024-08-03  |
| [Awesome Machine Learning with Ruby](https://github.com/arbox/machine-learning-with-ruby) | Curated list: Resources for machine learning in Ruby                                                                                                                 | 2213  | 2024-12-26  |
| [langchain.rb](https://github.com/patterns-ai-core/langchainrb)                           | Build LLM-powered applications in Ruby                                                                                                                               | 1958  | 2025-10-03  |
| [rumale](https://github.com/yoshoku/rumale)                                               | Rumale is a machine learning library in Ruby                                                                                                                         | 899   | 2026-02-09  |
| [Torch.rb](https://github.com/ankane/torch.rb)                                            | Deep learning for Ruby, powered by LibTorch                                                                                                                          | 825   | 2026-02-12  |
| [AI4R](https://github.com/sergiofierens/ai4r)                                             | Artificial Intelligence for Ruby - A Ruby playground for AI researchers                                                                                              | 720   | 2025-07-18  |
| [ruby-fann](https://github.com/tangledpath/ruby-fann)                                     | Ruby library for interfacing with FANN (Fast Artificial Neural Network)                                                                                              | 506   | 2024-03-25  |

[Back to Top](#table-of-contents)

## Markdown Processors

| Name                                                              | Description                                                                                                                           | Stars | Last Commit |
|-------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Redcarpet](https://github.com/vmg/redcarpet)                     | The safe Markdown parser, reloaded.                                                                                                   | 5075  | 2025-03-06  |
| [kramdown](https://github.com/gettalong/kramdown)                 | kramdown is a fast, pure Ruby Markdown superset converter, using a strict syntax definition and supporting several common extensions. | 1751  | 2026-01-31  |
| [word-to-markdown](https://github.com/benbalter/word-to-markdown) | A ruby gem to liberate content from Microsoft Word documents                                                                          | 1532  | 2025-10-30  |
| [Maruku](https://github.com/bhollis/maruku)                       | A pure-Ruby Markdown-superset interpreter (Official Repo).                                                                            | 505   | 2025-01-05  |

[Back to Top](#table-of-contents)

## Measurements

| Name                                                | Description                      | Stars | Last Commit |
|-----------------------------------------------------|----------------------------------|-------|-------------|
| [Ruby Units](https://github.com/olbrich/ruby-units) | A unit handling library for ruby | 542   | 2026-01-19  |

[Back to Top](#table-of-contents)

## Mobile Development

| Name                                              | Description                                                                     | Stars | Last Commit |
|---------------------------------------------------|---------------------------------------------------------------------------------|-------|-------------|
| [fastlane](https://github.com/fastlane/fastlane)  | 🚀 The easiest way to automate building and releasing your iOS and Android apps | 40982 | 2026-02-10  |
| [dryrun](https://github.com/cesarferreira/dryrun) | ☁️ Try the demo project of any Android Library                                   | 3804  | 2025-10-31  |
| [Ruboto](https://github.com/ruboto/ruboto)        | A platform for developing apps using JRuby on Android.                          | 2032  | 2023-05-15  |

[Back to Top](#table-of-contents)

## Money

| Name                                        | Description                                                    | Stars | Last Commit |
|---------------------------------------------|----------------------------------------------------------------|-------|-------------|
| [Money](https://github.com/RubyMoney/money) | A Ruby Library for dealing with money and currency conversion. | 2842  | 2026-01-20  |

[Back to Top](#table-of-contents)

## Music and Sound

| Name                                              | Description                                              | Stars | Last Commit |
|---------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [Coltrane](https://github.com/pedrozath/coltrane) | 🎹🎸A music theory library with a command-line interface | 2394  | 2025-01-29  |

[Back to Top](#table-of-contents)

## Natural Language Processing

| Name                                                                              | Description                                                                                                          | Stars | Last Commit |
|-----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Treat](https://github.com/louismullie/treat)                                     | Natural language processing framework for Ruby.                                                                      | 1371  | 2025-05-16  |
| [Ruby Natural Language Processing Resources](https://github.com/diasks2/ruby-nlp) | A collection of links to Ruby Natural Language Processing (NLP) libraries, tools and software                        | 1287  | 2023-03-05  |
| [Awesome NLP with Ruby](https://github.com/arbox/nlp-with-ruby)                   | Curated List: Practical Natural Language Processing done in Ruby                                                     | 1073  | 2023-06-27  |
| [Pragmatic Segmenter](https://github.com/diasks2/pragmatic_segmenter)             | Pragmatic Segmenter is a rule-based sentence boundary detection gem that works out-of-the-box across many languages. | 589   | 2024-08-11  |
| [Text](https://github.com/threedaymonk/text)                                      | Collection of text algorithms. gem install text                                                                      | 585   | 2015-04-13  |

[Back to Top](#table-of-contents)

## Notifications

| Name                                         | Description                                  | Stars | Last Commit |
|----------------------------------------------|----------------------------------------------|-------|-------------|
| [Noticed](https://github.com/excid3/noticed) | Notifications for Ruby on Rails applications | 2655  | 2025-12-31  |
| [Rpush](https://github.com/rpush/rpush)      | The push notification service for Ruby.      | 2207  | 2025-07-01  |

[Back to Top](#table-of-contents)

## ORM/ODM

| Name                                                       | Description                                   | Stars | Last Commit |
|------------------------------------------------------------|-----------------------------------------------|-------|-------------|
| [Sequel](https://github.com/jeremyevans/sequel)            | Sequel: The Database Toolkit for Ruby         | 5077  | 2026-02-01  |
| [Mongoid](https://github.com/mongodb/mongoid)              | The Official Ruby Object Mapper for MongoDB   | 3928  | 2026-02-03  |
| [ROM](https://github.com/rom-rb/rom)                       | Data mapping and persistence toolkit for Ruby | 2109  | 2026-01-15  |
| [Redis-Objects](https://github.com/nateware/redis-objects) | Map Redis types directly to Ruby objects      | 2093  | 2026-01-13  |
| [Ohm](https://github.com/soveran/ohm)                      | Object-Hash Mapping for Redis                 | 1389  | 2022-12-20  |

[Back to Top](#table-of-contents)

## ORM/ODM Extensions

| Name                                                                       | Description                                                                                                       | Stars | Last Commit |
|----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Acts As Taggable On](https://github.com/mbleigh/acts-as-taggable-on)      | A tagging plugin for Rails applications that allows for custom tagging along dynamic contexts.                    | 5000  | 2025-12-02  |
| [ActiveRecord Import](https://github.com/zdennis/activerecord-import)      | A library for bulk insertion of data into your database using ActiveRecord.                                       | 4145  | 2025-09-27  |
| [Ancestry](https://github.com/stefankroes/ancestry)                        | Organise ActiveRecord model into a tree structure                                                                 | 3842  | 2026-02-09  |
| [Audited](https://github.com/collectiveidea/audited)                       | Audited (formerly acts_as_audited) is an ORM extension that logs all changes to your Rails models.                | 3491  | 2025-11-18  |
| [Apartment](https://github.com/influitive/apartment)                       | Database multi-tenancy for Rack (and Rails) applications                                                          | 2687  | 2024-06-12  |
| [Awesome Nested Set](https://github.com/collectiveidea/awesome_nested_set) | An awesome replacement for acts_as_nested_set and better_nested_set.                                              | 2412  | 2025-12-20  |
| [Discard](https://github.com/jhawthorn/discard)                            | 🃏🗑 Soft deletes for ActiveRecord done right                                                                      | 2366  | 2026-01-29  |
| [marginalia](https://github.com/basecamp/marginalia)                       | Attach comments to ActiveRecord's SQL queries                                                                     | 1768  | 2024-08-05  |
| [Enumerize](https://github.com/brainspec/enumerize)                        | Enumerated attributes with I18n and ActiveRecord/Mongoid support                                                  | 1767  | 2026-02-10  |
| [Acts As Tennant](https://github.com/ErwinM/acts_as_tenant)                | Easy multi-tenancy for Rails in a shared database setup.                                                          | 1682  | 2025-04-16  |
| [Logidze](https://github.com/palkan/logidze)                               | Database changes log for Rails                                                                                    | 1676  | 2025-10-08  |
| [Goldiloader](https://github.com/salsify/goldiloader)                      | Just the right amount of Rails eager loading                                                                      | 1663  | 2025-12-15  |
| [ActsAsParanoid](https://github.com/ActsAsParanoid/acts_as_paranoid)       | ActiveRecord plugin allowing you to hide and restore records without actually deleting them.                      | 1510  | 2026-01-09  |
| [bulk_insert](https://github.com/jamis/bulk_insert)                        | Efficient bulk inserts with ActiveRecord                                                                          | 812   | 2022-01-10  |
| [Unread](https://github.com/ledermann/unread)                              | Handle unread records and mark them as read with Ruby on Rails                                                    | 743   | 2024-12-28  |
| [ActsAsTree](https://github.com/amerine/acts_as_tree)                      | ActsAsTree -- Extends ActiveRecord to add simple support for organizing items into parent–children relationships. | 589   | 2022-04-23  |

[Back to Top](#table-of-contents)

## Optimizations

| Name                                                   | Description                                                                 | Stars | Last Commit |
|--------------------------------------------------------|-----------------------------------------------------------------------------|-------|-------------|
| [yajl-ruby](https://github.com/brianmario/yajl-ruby)   | A streaming JSON parsing and encoding library for Ruby (C bindings to yajl) | 1492  | 2025-12-27  |
| [fast_blank](https://github.com/SamSaffron/fast_blank) | Provides a C-optimized method for determining if a string is blank.         | 617   | 2024-02-21  |

[Back to Top](#table-of-contents)

## PDF

| Name                                                          | Description                                                                                                                                                                             | Stars | Last Commit |
|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Prawn](https://github.com/prawnpdf/prawn)                    | Fast, Nimble PDF Writer for Ruby                                                                                                                                                        | 4793  | 2025-05-02  |
| [Wicked Pdf](https://github.com/mileszs/wicked_pdf)           | PDF generator (from HTML) plugin for Ruby on Rails                                                                                                                                      | 3576  | 2025-07-24  |
| [Pdfkit](https://github.com/pdfkit/pdfkit)                    | A Ruby gem to transform HTML + CSS into PDFs using the command-line utility wkhtmltopdf                                                                                                 | 2938  | 2023-08-22  |
| [HexaPDF](https://github.com/gettalong/hexapdf)               | Versatile PDF creation and manipulation for Ruby                                                                                                                                        | 1356  | 2026-02-10  |
| [InvoicePrinter](https://github.com/strzibny/invoice_printer) | Super simple PDF invoicing                                                                                                                                                              | 973   | 2025-10-21  |
| [CombinePDF](https://github.com/boazsegev/combine_pdf)        | A Pure ruby library to merge PDF files, number pages and maybe more...                                                                                                                  | 774   | 2025-04-08  |
| [Kitabu](https://github.com/fnando/kitabu)                    | A framework for creating e-books from Markdown using Ruby. Using the Prince PDF generator, you'll be able to get high quality PDFs. Also supports EPUB, Mobi, Text and HTML generation. | 691   | 2025-12-12  |

[Back to Top](#table-of-contents)

## Package Management

| Name                                                | Description                                                                                                  | Stars | Last Commit |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Homebrew](https://github.com/Homebrew/brew)        | 🍺 The missing package manager for macOS (or Linux)                                                          | 46577 | 2026-02-12  |
| [CocoaPods](https://github.com/CocoaPods/CocoaPods) | The Cocoa Dependency Manager.                                                                                | 14801 | 2025-08-26  |
| [fpm](https://github.com/jordansissel/fpm)          | Effing package management! Build packages for multiple platforms (deb, rpm, etc) with great ease and sanity. | 11435 | 2026-01-28  |
| [Berkshelf](https://github.com/berkshelf/berkshelf) | A Chef Cookbook manager                                                                                      | 1072  | 2024-08-14  |

[Back to Top](#table-of-contents)

## Pagination

| Name                                                     | Description                                              | Stars | Last Commit |
|----------------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [will_paginate](https://github.com/mislav/will_paginate) | Pagination library for Rails and other Ruby applications | 5703  | 2025-11-24  |
| [Pagy](https://github.com/ddnexus/pagy)                  | 🏆 The Best Pagination Ruby Gem 🥇                       | 4930  | 2026-02-10  |
| [order_query](https://github.com/glebm/order_query)      | Find next / previous Active Record(s) in one query       | 514   | 2025-11-14  |

[Back to Top](#table-of-contents)

## Process Management and Monitoring

| Name                                                | Description                                                                                                                         | Stars | Last Commit |
|-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Foreman](https://github.com/ddollar/foreman)       | Manage Procfile-based applications                                                                                                  | 6139  | 2025-07-27  |
| [God](https://github.com/mojombo/god)               | Ruby process monitor                                                                                                                | 2217  | 2024-03-29  |
| [Eye](https://github.com/kostya/eye)                | Process monitoring tool. Inspired from Bluepill and God.                                                                            | 1187  | 2021-11-13  |
| [Procodile](https://github.com/adamcooke/procodile) | 🐊 Run processes in the background (and foreground) on Mac & Linux from a Procfile (for production and/or development environments) | 612   | 2021-02-16  |

[Back to Top](#table-of-contents)

## Processes

| Name                                                   | Description                   | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------|-------|-------------|
| [posix-spawn](https://github.com/rtomayko/posix-spawn) | Ruby process spawning library | 523   | 2024-03-19  |

[Back to Top](#table-of-contents)

## Profiler and Optimization

| Name                                                                     | Description                                                             | Stars | Last Commit |
|--------------------------------------------------------------------------|-------------------------------------------------------------------------|-------|-------------|
| [bullet](https://github.com/flyerhzm/bullet)                             | help to kill N+1 queries and unused eager loading                       | 7304  | 2026-02-04  |
| [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) | Profiler for your development and production Ruby rack apps.            | 3887  | 2025-08-05  |
| [Peek](https://github.com/peek/peek)                                     | Take a peek into your Rails applications.                               | 3178  | 2024-04-26  |
| [rbspy](https://github.com/rbspy/rbspy)                                  | Sampling CPU profiler for Ruby                                          | 2555  | 2026-01-14  |
| [stackprof](https://github.com/tmm1/stackprof)                           | a sampling call-stack profiler for ruby 2.2+                            | 2180  | 2025-10-01  |
| [ruby-prof](https://github.com/ruby-prof/ruby-prof)                      | A ruby profiler.  See https://ruby-prof.github.io for more information. | 2024  | 2026-02-11  |
| [benchmark-ips](https://github.com/evanphx/benchmark-ips)                | Provides iteration per second benchmarking for Ruby                     | 1761  | 2025-11-20  |
| [batch-loader](https://github.com/exaspark/batch-loader)                 | :zap: Powerful tool for avoiding N+1 DB or HTTP queries                 | 1113  | 2025-12-09  |

[Back to Top](#table-of-contents)

## QR

| Name                                          | Description                          | Stars | Last Commit |
|-----------------------------------------------|--------------------------------------|-------|-------------|
| [RQRCode](https://github.com/whomwah/rqrcode) | A Ruby library that encodes QR Codes | 1974  | 2026-01-09  |

[Back to Top](#table-of-contents)

## Queues and Messaging

| Name                                                           | Description                                                                                                                     | Stars | Last Commit |
|----------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Resque](https://github.com/resque/resque)                     | Resque is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later. | 9480  | 2026-01-12  |
| [Delayed::Job](https://github.com/collectiveidea/delayed_job)  | Database based asynchronous priority queue system -- Extracted from Shopify                                                     | 4823  | 2025-12-29  |
| [GoodJob](https://github.com/bensheldon/good_job)              | Multithreaded, Postgres-based, Active Job backend for Ruby on Rails.                                                            | 2932  | 2026-01-29  |
| [Sucker Punch](https://github.com/brandonhilkert/sucker_punch) | Sucker Punch is a Ruby asynchronous processing library using concurrent-ruby, heavily influenced by Sidekiq and girl_friday.    | 2639  | 2025-12-24  |
| [Sneakers](https://github.com/jondot/sneakers)                 | A fast background processing framework for Ruby and RabbitMQ                                                                    | 2247  | 2024-06-26  |
| [Karafka](https://github.com/karafka/karafka)                  | Ruby and Rails efficient Kafka processing framework                                                                             | 2217  | 2026-02-11  |
| [Bunny](https://github.com/ruby-amqp/bunny)                    | Bunny is a popular, easy to use, mature Ruby client for RabbitMQ                                                                | 1410  | 2026-01-22  |
| [JobIteration](https://github.com/Shopify/job-iteration)       | Makes your background jobs interruptible and resumable by design.                                                               | 1288  | 2026-02-03  |
| [Gush](https://github.com/chaps-io/gush)                       | Fast and distributed workflow runner using ActiveJob and Redis                                                                  | 1097  | 2025-11-20  |

[Back to Top](#table-of-contents)

## RSS

| Name                                             | Description            | Stars | Last Commit |
|--------------------------------------------------|------------------------|-------|-------------|
| [Feedjira](https://github.com/feedjira/feedjira) | A feed parsing library | 2091  | 2026-02-02  |

[Back to Top](#table-of-contents)

## Rails Application Generators

| Name                                                          | Description                                                                                  | Stars | Last Commit |
|---------------------------------------------------------------|----------------------------------------------------------------------------------------------|-------|-------------|
| [Suspenders](https://github.com/thoughtbot/suspenders)        | A Rails application template with our standard defaults, optimized for deployment on Heroku. | 4054  | 2026-01-28  |
| [Rails Composer](https://github.com/RailsApps/rails-composer) | Rails Composer. The Rails generator on steroids for starter apps.                            | 3369  | 2019-05-30  |
| [orats](https://github.com/nickjj/orats)                      | Opinionated rails application templates.                                                     | 661   | 2020-12-22  |

[Back to Top](#table-of-contents)

## SEO

| Name                                                             | Description                                                                                                                                                                                                                                                                                       | Stars | Last Commit |
|------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [FriendlyId](https://github.com/norman/friendly_id)              | FriendlyId is the “Swiss Army bulldozer” of slugging and permalink plugins for ActiveRecord. It allows you to create pretty URL’s and work with human-friendly strings as if they were numeric ids for ActiveRecord models.                                                                       | 6234  | 2025-12-06  |
| [MetaTags](https://github.com/kpumuk/meta-tags)                  | Search Engine Optimization (SEO) for Ruby on Rails applications.                                                                                                                                                                                                                                  | 2789  | 2026-01-07  |
| [SitemapGenerator](https://github.com/kjvarga/sitemap_generator) | SitemapGenerator is a framework-agnostic XML Sitemap generator written in Ruby with automatic Rails integration. It supports Video, News, Image, Mobile, PageMap and Alternate Links sitemap extensions and includes Rake tasks for managing your sitemaps, as well as many other great features. | 2485  | 2026-02-06  |

[Back to Top](#table-of-contents)

## Scheduling

| Name                                                            | Description                                                 | Stars | Last Commit |
|-----------------------------------------------------------------|-------------------------------------------------------------|-------|-------------|
| [Whenever](https://github.com/javan/whenever)                   | Cron jobs in Ruby                                           | 8870  | 2026-01-18  |
| [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) | scheduler for Ruby (at, in, cron and every jobs)            | 2431  | 2025-11-24  |
| [minicron](https://github.com/jamesrwhite/minicron)             | 🕰️ Monitor your cron jobs                                    | 2321  | 2021-05-16  |
| [resque-scheduler](https://github.com/resque/resque-scheduler)  | A light-weight job scheduling system built on top of Resque | 1738  | 2026-02-02  |

[Back to Top](#table-of-contents)

## Scientific

| Name                                                             | Description                                                                                                                                                                                                                                                                                                                                                 | Stars | Last Commit |
|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [algorithms](https://github.com/kanwei/algorithms)               | Ruby algorithms and data structures. C extensions                                                                                                                                                                                                                                                                                                           | 2700  | 2025-08-20  |
| [smarter_csv](https://github.com/tilo/smarter_csv)               | Ruby Gem for convenient reading and writing of CSV files. It has intelligent defaults, and auto-discovery of column and row separators. It imports CSV Files as Array(s) of Hashes, suitable for direct processing with ActiveRecord, kicking-off batch jobs with Sidekiq, parallel processing, or oploading data to S3. Writing CSV Files is equally easy. | 1497  | 2026-02-08  |
| [decisiontree](https://github.com/igrigorik/decisiontree)        | ID3-based implementation of the ML Decision Tree algorithm                                                                                                                                                                                                                                                                                                  | 1473  | 2018-10-31  |
| [SciRuby](https://github.com/sciruby/sciruby)                    | Tools for scientific computation in Ruby                                                                                                                                                                                                                                                                                                                    | 1002  | 2020-02-28  |
| [IRuby](https://github.com/SciRuby/iruby)                        | Official gem repository: Ruby kernel for Jupyter/IPython Notebook                                                                                                                                                                                                                                                                                           | 922   | 2025-12-27  |
| [ruby-opencv](https://github.com/ruby-opencv/ruby-opencv)        | Versioned fork of the OpenCV gem for Ruby                                                                                                                                                                                                                                                                                                                   | 812   | 2021-04-12  |
| [classifier-reborn](https://github.com/jekyll/classifier-reborn) | A general classifier module to allow Bayesian and other types of classifications. A fork of cardmagic/classifier.                                                                                                                                                                                                                                           | 555   | 2024-05-27  |

[Back to Top](#table-of-contents)

## Search

| Name                                                                | Description                                                                                                                                                                                                 | Stars | Last Commit |
|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Searchkick](https://github.com/ankane/searchkick)                  | Intelligent search made easy                                                                                                                                                                                | 6699  | 2026-02-03  |
| [ransack](https://github.com/activerecord-hackery/ransack)          | Object-based searching.                                                                                                                                                                                     | 5851  | 2026-02-06  |
| [Sunspot](https://github.com/sunspot/sunspot)                       | Solr-powered search for Ruby objects                                                                                                                                                                        | 2991  | 2025-06-30  |
| [elasticsearch-ruby](https://github.com/elastic/elasticsearch-ruby) | Ruby integrations for Elasticsearch                                                                                                                                                                         | 1980  | 2026-02-09  |
| [chewy](https://github.com/toptal/chewy)                            | High-level Elasticsearch Ruby framework based on the official elasticsearch-ruby client                                                                                                                     | 1894  | 2025-11-26  |
| [has_scope](https://github.com/heartcombo/has_scope)                | Map incoming controller parameters to named scopes in your resources                                                                                                                                        | 1788  | 2026-01-05  |
| [Thinking Sphinx](https://github.com/pat/thinking-sphinx)           | Sphinx/Manticore plugin for ActiveRecord/Rails                                                                                                                                                              | 1630  | 2026-01-11  |
| [pg_search](https://github.com/Casecommons/pg_search)               | pg_search builds ActiveRecord named scopes that take advantage of PostgreSQL’s full text search                                                                                                             | 1539  | 2026-01-05  |
| [textacular](https://github.com/textacular/textacular)              | Textacular exposes full text search capabilities from PostgreSQL, and allows you to declare full text indexes. Textacular will extend ActiveRecord with named_scope methods making searching easy and fun!  | 956   | 2025-10-24  |
| [SearchCop](https://github.com/mrkamel/search_cop)                  | Search engine like fulltext query support for ActiveRecord                                                                                                                                                  | 834   | 2026-02-03  |

[Back to Top](#table-of-contents)

## Security

| Name                                                         | Description                                                                                                                                                                                                        | Stars | Last Commit |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Metasploit](https://github.com/rapid7/metasploit-framework) | Metasploit Framework                                                                                                                                                                                               | 37498 | 2026-02-11  |
| [WhatWeb](https://github.com/urbanadventurer/WhatWeb)        | Next generation web scanner                                                                                                                                                                                        | 6410  | 2025-10-19  |
| [bundler-audit](https://github.com/rubysec/bundler-audit)    | Patch-level verification for Bundler                                                                                                                                                                               | 2739  | 2025-12-03  |
| [haiti](https://github.com/noraj/haiti)                      | :key: Hash type identifier (CLI & lib)                                                                                                                                                                             | 942   | 2026-01-22  |
| [Ronin](https://github.com/ronin-rb/ronin)                   | Ronin is a Free and Open Source Ruby Toolkit for Security Research and Development. Ronin also allows for the rapid development and distribution of code, exploits, payloads, etc, via 3rd-party git repositories. | 739   | 2026-01-12  |
| [Pipal](https://github.com/digininja/pipal)                  | Pipal, THE password analyser                                                                                                                                                                                       | 660   | 2023-08-27  |

[Back to Top](#table-of-contents)

## Social Networking

| Name                                                | Description                                                                                  | Stars | Last Commit |
|-----------------------------------------------------|----------------------------------------------------------------------------------------------|-------|-------------|
| [Discourse](https://github.com/discourse/discourse) | A platform for community discussion. Free, open, simple.                                     | 46312 | 2026-02-12  |
| [diaspora*](https://github.com/diaspora/diaspora)   | A privacy-aware, distributed, open source social network.                                    | 13876 | 2025-06-22  |
| [Decidim](https://github.com/decidim/decidim)       | The participatory democracy framework. A generator and multiple gems made with Ruby on Rails | 1701  | 2026-02-11  |
| [Mailboxer](https://github.com/mailboxer/mailboxer) | A Rails gem to send messages inside a web application                                        | 1641  | 2024-04-11  |
| [Thredded](https://github.com/thredded/thredded)    | The best Rails forums engine ever.                                                           | 1602  | 2026-01-02  |

[Back to Top](#table-of-contents)

## Spreadsheets and Documents

| Name                                                                           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Stars | Last Commit |
|--------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Roo](https://github.com/roo-rb/roo)                                           | Roo provides an interface to spreadsheets of several sorts.                                                                                                                                                                                                                                                                                                                                                                                                                           | 2865  | 2025-10-01  |
| [spreadsheet_architect](https://github.com/westonganger/spreadsheet_architect) | Spreadsheet Architect is a library that allows you to create XLSX, ODS, or CSV spreadsheets super easily from ActiveRecord relations, plain Ruby objects, or tabular data.                                                                                                                                                                                                                                                                                                            | 1349  | 2025-12-27  |
| [CAXLSX](https://github.com/caxlsx/caxlsx)                                     |     xlsx generation with charts, images, automated column width, customizable styles and full schema validation. Axlsx excels at helping you generate beautiful Office Open XML Spreadsheet documents without having to understand the entire ECMA specification. Check out the README for some examples of how easy it is. Best of all, you can validate your xlsx file before serialization so you know for sure that anything generated is going to load on your client's machine. | 566   | 2026-02-02  |

[Back to Top](#table-of-contents)

## State Machines

| Name                                                               | Description                                                                                     | Stars | Last Commit |
|--------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [AASM](https://github.com/aasm/aasm)                               | AASM - State machines for Ruby classes (plain Ruby, ActiveRecord, Mongoid, NoBrainer, Dynamoid) | 5175  | 2025-10-22  |
| [Statesman](https://github.com/gocardless/statesman)               | A statesmanlike state machine library.                                                          | 1874  | 2026-01-05  |
| [Workflow](https://github.com/geekq/workflow)                      | Ruby finite-state-machine-inspired API for modeling workflow                                    | 1797  | 2025-10-16  |
| [state_machines](https://github.com/state-machines/state_machines) | Adds support for creating state machines for attributes on any Ruby class                       | 863   | 2026-01-06  |
| [transitions](https://github.com/troessner/transitions)            | State machine extracted from ActiveModel                                                        | 536   | 2022-03-31  |
| [MicroMachine](https://github.com/soveran/micromachine)            | Minimal Finite State Machine                                                                    | 523   | 2017-08-20  |

[Back to Top](#table-of-contents)

## Static Site Generation

| Name                                                             | Description                                                                         | Stars | Last Commit |
|------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------|-------------|
| [High Voltage](https://github.com/thoughtbot/high_voltage)       | Easily include static pages in your Rails app.                                      | 3317  | 2025-11-24  |
| [Bridgetown](https://github.com/bridgetownrb/bridgetown)         | A next-generation progressive site generator & fullstack framework, powered by Ruby | 1331  | 2026-02-03  |
| [Awesome Jekyll](https://github.com/planetjekyll/awesome-jekyll) | A collection of awesome Jekyll goodies (tools, templates, plugins, guides, etc.)    | 596   | 2021-01-11  |

[Back to Top](#table-of-contents)

## Template Engine

| Name                                             | Description                                                                                                     | Stars | Last Commit |
|--------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Liquid](https://github.com/Shopify/liquid)      | Liquid markup language. Safe, customer facing template language for flexible web apps.                          | 11676 | 2026-02-10  |
| [Slim](https://github.com/slim-template/slim)    | Slim is a template language whose goal is to reduce the syntax to the essential parts without becoming cryptic. | 5367  | 2026-01-01  |
| [Haml](https://github.com/haml/haml)             | HTML Abstraction Markup Language - A Markup Haiku                                                               | 3904  | 2026-01-13  |
| [Mustache](https://github.com/mustache/mustache) | Logic-less Ruby templates.                                                                                      | 3072  | 2024-07-09  |
| [Tilt](https://github.com/rtomayko/tilt)         | Generic interface to multiple Ruby template engines                                                             | 1945  | 2023-12-29  |
| [Curly](https://github.com/zendesk/curly)        | The Curly template language allows separating your logic from the structure of your HTML templates.             | 593   | 2026-02-03  |

[Back to Top](#table-of-contents)

## Testing

| Name                                                               | Description                                                                                                                 | Stars | Last Commit |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Capybara](https://github.com/teamcapybara/capybara)               | Acceptance test framework for web applications                                                                              | 10143 | 2025-11-24  |
| [factory_bot](https://github.com/thoughtbot/factory_bot)           | A library for setting up Ruby objects as test data.                                                                         | 8140  | 2025-08-22  |
| [vcr](https://github.com/vcr/vcr)                                  | Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests. | 5974  | 2025-08-19  |
| [WebMock](https://github.com/bblimke/webmock)                      | Library for stubbing and setting expectations on HTTP requests.                                                             | 4024  | 2025-04-23  |
| [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) | Simple one-liner tests for common Rails functionality                                                                       | 3570  | 2026-02-01  |
| [Parallel Tests](https://github.com/grosser/parallel_tests)        | Speedup Test::Unit + RSpec + Cucumber by running parallel on multiple CPUs (or cores).                                      | 3454  | 2025-08-02  |
| [timecop](https://github.com/travisjeffery/timecop)                | Provides "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.                 | 3399  | 2025-08-18  |
| [Spring](https://github.com/rails/spring)                          | Preloads your rails environment in the background for faster testing and Rake tasks.                                        | 2815  | 2025-08-07  |
| [Poltergeist](https://github.com/teampoltergeist/poltergeist)      | A PhantomJS driver for Capybara.                                                                                            | 2496  | 2019-09-27  |
| [mutant](https://github.com/mbj/mutant)                            | Mutant is a mutation testing tool for Ruby.                                                                                 | 1980  | 2025-08-06  |
| [Ferrum](https://github.com/rubycdp/ferrum)                        | High-level API to control Chrome in Ruby.                                                                                   | 1916  | 2025-05-15  |
| [DuckRails](https://github.com/iridakos/duckrails)                 | Tool for mocking API endpoints quickly & dynamically.                                                                       | 1717  | 2023-07-13  |
| [ffaker](https://github.com/ffaker/ffaker)                         | A faster Faker, generates dummy data, rewrite of faker.                                                                     | 1566  | 2025-09-01  |
| [Watir](https://github.com/watir/watir)                            | Web application testing in Ruby.                                                                                            | 1545  | 2024-05-31  |
| [Appraisal](https://github.com/thoughtbot/appraisal)               | Appraisal integrates with bundler and rake to test your library against different versions of dependencies.                 | 1304  | 2024-10-25  |
| [Mocha](https://github.com/freerange/mocha)                        | A mocking and stubbing library for Ruby                                                                                     | 1274  | 2026-01-28  |
| [Aruba](https://github.com/cucumber/aruba)                         | Test command-line applications with Cucumber-Ruby, RSpec or Minitest.                                                       | 963   | 2026-02-04  |
| [Fuubar](https://github.com/thekompanee/fuubar)                    | The instafailing RSpec progress bar formatter                                                                               | 961   | 2022-02-12  |
| [Forgery](https://github.com/sevenwire/forgery)                    | Easy and customizable generation of forged data.                                                                            | 787   | 2020-07-23  |
| [Spinach](https://github.com/codegram/spinach)                     | Spinach is a BDD framework on top of Gherkin.                                                                               | 578   | 2025-12-27  |
| [ActiveMocker](https://github.com/zeisler/active_mocker)           | Generate mocks from ActiveRecord models for unit tests that run fast because they don’t need to load Rails or a database.   | 504   | 2019-09-05  |

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
