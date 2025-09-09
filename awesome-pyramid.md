# awesome-pyramid

A curated list of awesome Pyramid apps, projects and resources.

## Admin interface

| Name                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                          | Stars | Last Commit |
|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_sacrud](https://github.com/sacrud/pyramid_sacrud)                | Pyramid CRUD interface. Provides an administration web interface for Pyramid. Unlike classic CRUD, pyramid_sacrud allows overrides and flexibility to customize your interface, similar to django.contrib.admin but uses a different backend to provide resources. [New Architecture]( <http://pyramid-sacrud.readthedocs.io/pages/contribute/architecture.html>) built on the resources and mechanism traversal, allows to use it in various cases. | 52    | 2020-04-29  |
| [pyramid_formalchemy](https://github.com/FormAlchemy/pyramid_formalchemy) | provides a CRUD interface for pyramid based on FormAlchemy.                                                                                                                                                                                                                                                                                                                                                                                          | 45    | 2020-03-28  |
| [ps_alchemy](https://github.com/sacrud/ps_alchemy)                        | extension for pyramid_sacrud which provides SQLAlchemy models.                                                                                                                                                                                                                                                                                                                                                                                       | 7     | 2024-03-10  |
| [ps_tree](https://github.com/sacrud/ps_tree)                              | extension for [pyramid_sacrud](https://github.com/sacrud/pyramid_sacrud) which displays a list of records as tree. This works fine with models from [sqlalchemy_mptt](https://github.com/uralbash/sqlalchemy_mptt).                                                                                                                                                                                                                                  | 3     | 2015-07-10  |

## Cookiecutters

| Name                                                            | Description                                                                                              | Stars | Last Commit |
|-----------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------|-------------|
| [Pyramid Runner](https://github.com/asif-mahmud/pyramid_runner) | A minimal Pyramid scaffold that aims to provide a starter template to build small to large web services. | 5     | 2022-11-01  |

## Media-Management

| Name                                                             | Description                                                                        | Stars | Last Commit |
|------------------------------------------------------------------|------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_storage](https://github.com/danjac/pyramid_storage)     | This is a package for handling file uploads in your Pyramid framework application. | 16    | 2025-06-16  |
| [pyramid_elfinder](https://github.com/uralbash/pyramid_elfinder) | This is conector for elfinder file manager, written for pyramid framework.         | 2     | 2020-03-14  |

## Authorization

| Name                                                                       | Description                                                                                                                                                                                                                                | Stars | Last Commit |
|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [ziggurat_foundations](https://github.com/ergo/ziggurat_foundations)       | Framework agnostic set of sqlalchemy classes that make building applications that require permissions an easy task.                                                                                                                        | 71    | 2023-03-08  |
| [pyramid_multiauth](https://github.com/mozilla-services/pyramid_multiauth) | An authentication policy for Pyramid that proxies to a stack of other authentication policies.                                                                                                                                             | 41    | 2025-08-12  |
| [horus](https://github.com/Pylons/horus)                                   | User registration and login system for the Pyramid Web Framework.                                                                                                                                                                          | 14    | 2020-04-06  |
| [pyramid_authstack](https://github.com/wichert/pyramid_authstack)          | Use multiple authentication policies with Pyramid.                                                                                                                                                                                         | 10    | 2020-03-28  |
| [pyramid_yosai](https://github.com/YosaiProject/pyramid_yosai)             | Pyramid integration with security Framework for Python applications featuring Authorization (rbac permissions and roles), Authentication (2fa totp), Session Management and an extensive Audit Trail https://yosaiproject.github.io/yosai/ | 5     | 2016-09-02  |

## Task Queue

| Name                                                       | Description                                                                                                                                                      | Stars | Last Commit |
|------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_celery](https://github.com/sontek/pyramid_celery) | Pyramid configuration with celery integration. Allows you to use pyramid .ini files to configure celery and have your pyramid configuration inside celery tasks. | 106   | 2024-07-23  |
| [pyramid_rq](https://github.com/wichert/pyramid_rq)        | Support using the rq queueing system with pyramid. The easiest way to monitor and use [RQ](http://python-rq.org) in your Pyramid projects.                       | 9     | 2016-06-30  |

## Asset Management

| Name                                                                  | Description                                               | Stars | Last Commit |
|-----------------------------------------------------------------------|-----------------------------------------------------------|-------|-------------|
| [pyramid_webassets](https://github.com/sontek/pyramid_webassets)      | Pyramid extension for working with the webassets library. | 64    | 2018-11-03  |
| [pyramid_bowerstatic](https://github.com/mrijken/pyramid_bowerstatic) | integration of Bowerstatic in Pyramid                     | 14    | 2020-03-28  |

## Testing

| Name                                         | Description                                                                                                                 | Stars | Last Commit |
|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [webtest](https://github.com/Pylons/webtest) | Wraps any WSGI application and makes it easy to send test requests to that application, without starting up an HTTP server. | 340   | 2025-06-04  |

## Services

| Name                                                   | Description                             | Stars | Last Commit |
|--------------------------------------------------------|-----------------------------------------|-------|-------------|
| [pyramid_sms](https://github.com/websauna/pyramid_sms) | SMS services for Pyramid web framework. | 7     | 2020-03-30  |

## Storage

| Name                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                | Stars | Last Commit |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_mongodb](https://github.com/niallo/pyramid_mongodb)              | Basic Pyramid Scaffold to easily use MongoDB for persistence with the Pyramid Web framework                                                                                                                                                                                                                                                                                                                                | 44    | 2020-03-31  |
| [pyramid_tm](https://github.com/Pylons/pyramid_tm)                        | Centralized transaction management for Pyramid applications (without middleware).                                                                                                                                                                                                                                                                                                                                          | 34    | 2025-09-04  |
| [zope.sqlalchemy](https://github.com/zopefoundation/zope.sqlalchemy)      | Integration of SQLAlchemy with transaction management. you)](https://metaclassical.com/what-the-zope-transaction-manager-means-to-me-and-you/)                                                                                                                                                                                                                                                                             | 33    | 2025-08-27  |
| [pyramid_sqlalchemy](https://github.com/wichert/pyramid_sqlalchemy)       | provides some basic glue to facilitate using SQLAlchemy with Pyramid.                                                                                                                                                                                                                                                                                                                                                      | 26    | 2020-03-31  |
| [pyramid_mongoengine](https://github.com/marioidival/pyramid_mongoengine) | pyramid-mongoengine package based on flask-mongoengine                                                                                                                                                                                                                                                                                                                                                                     | 13    | 2020-03-31  |
| [pyramid-excel](https://github.com/pyexcel-webwares/pyramid-excel)        | pyramid-excel is based on [pyexcel](https://github.com/pyexcel/pyexcel) and makes it easy to consume/produce information stored in excel files over HTTP protocol as well as on file system. This library can turn the excel data into a list of lists, a list of records(dictionaries), dictionaries of lists. And vice versa. Hence it lets you focus on data in Pyramid based web development, instead of file formats. | 8     | 2024-11-23  |
| [pyramid_zodbconn](https://github.com/Pylons/pyramid_zodbconn)            | ZODB Database connection management for Pyramid.                                                                                                                                                                                                                                                                                                                                                                           | 4     | 2020-04-01  |

## Caching & Session

| Name                                                                              | Description                                                                                                                                                                                       | Stars | Last Commit |
|-----------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_beaker](https://github.com/Pylons/pyramid_beaker)                        | A Beaker session factory backend for Pyramid, also cache configurator. dogpile.cache](http://techspot.zzzeek.org/2012/04/19/using-beaker-for-caching-why-you-ll-want-to-switch-to-dogpile.cache/) | 49    | 2024-04-05  |
| [pyramid_redis_sessions](https://github.com/ericrasmussen/pyramid_redis_sessions) | Pyramid web framework session factory backed by Redis.                                                                                                                                            | 43    | 2017-08-22  |
| [pyramid_nacl_session](https://github.com/Pylons/pyramid_nacl_session)            | defines an encrypting, pickle-based cookie serializer, using [PyNaCl](http://pynacl.readthedocs.io/en/latest/secret/) to generate the symmetric encryption for the cookie state.                  | 10    | 2021-12-21  |
| [pyramid_dogpile_cache](https://github.com/moriyoshi/pyramid_dogpile_cache)       | dogpile.cache configuration package for Pyramid                                                                                                                                                   | 6     | 2021-03-19  |
| [pyramid_sessions](https://github.com/joulez/pyramid_sessions)                    | Multiple session support for the Pyramid Web Framework                                                                                                                                            | 0     | 2020-03-28  |

## Other

| Name                                                               | Description                                                                                                                                                                                                  | Stars | Last Commit |
|--------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [waitress](https://github.com/Pylons/waitress)                     | Waitress is meant to be a production-quality pure-Python WSGI server with very acceptable performance. It has no dependencies except ones which live in the Python standard library.                         | 1527  | 2025-09-04  |
| [paginate](https://github.com/Pylons/paginate)                     | Python pagination module.                                                                                                                                                                                    | 79    | 2024-08-25  |
| [pyramid_rpc](https://github.com/Pylons/pyramid_rpc)               | RPC service add-on for Pyramid, supports XML-RPC in a more extensible manner than pyramid_xmlrpc with support for JSON-RPC and AMF.                                                                          | 26    | 2024-06-24  |
| [pyramid_layout](https://github.com/Pylons/pyramid_layout)         | Pyramid add-on for managing UI layouts.                                                                                                                                                                      | 24    | 2023-07-13  |
| [pyramid_pages](https://github.com/uralbash/pyramid_pages)         | Provides a collections of tree pages to your Pyramid application. This is very similar to django.contrib.flatpages but with a tree structure and traversal algorithm in URL dispatch.                        | 12    | 2021-03-24  |
| [pyramid_extdirect](https://github.com/jenner/pyramid_extdirect)   | This pyramid plugin provides a router for the ExtDirect Sencha API included in ExtJS. ExtDirect allows to run server-side callbacks directly through JavaScript without the extra AJAX boilerplate.          | 10    | 2021-03-09  |
| [pyramid_handlers](https://github.com/Pylons/pyramid_handlers)     | analogue of Pylons-style “controllers” for Pyramid.                                                                                                                                                          | 8     | 2020-04-06  |
| [pyramid_retry](https://github.com/Pylons/pyramid_retry)           | pyramid_retry is an execution policy for Pyramid that wraps requests and can retry them a configurable number of times under certain "retryable" error conditions before indicating a failure to the client. | 6     | 2025-09-04  |
| [pyramid_tablib](https://github.com/lxneng/pyramid_tablib)         | tablib renderer (xlsx, xls, csv) for pyramid                                                                                                                                                                 | 5     | 2015-03-12  |
| [pyramid_skins](https://github.com/Pylons/pyramid_skins)           | This package provides a simple framework to integrate code with templates and resources.                                                                                                                     | 2     | 2022-08-04  |
| [tomb_routes](https://github.com/sontek/tomb_routes)               | Simple utility library around pyramid routing                                                                                                                                                                | 1     | 2015-06-24  |
| [pyramid_autodoc](https://github.com/SurveyMonkey/pyramid_autodoc) | Sphinx extension for documenting your Pyramid APIs.                                                                                                                                                          | 0     | N/A         |

## Debugging

| Name                                                                                     | Description                                                                       | Stars | Last Commit |
|------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|-------|-------------|
| [pyramid_debugtoolbar](https://github.com/Pylons/pyramid_debugtoolbar)                   | provides a debug toolbar useful while you're developing your Pyramid application. | 96    | 2025-09-04  |
| [pyramid_exclog](https://github.com/Pylons/pyramid_exclog)                               | a package which logs exceptions from Pyramid applications.                        | 23    | 2022-11-21  |
| [pyramid_ipython](https://github.com/Pylons/pyramid_ipython)                             | IPython bindings for Pyramid's pshell                                             | 7     | 2017-04-11  |
| [pyramid_pycallgraph](https://github.com/disko/pyramid_pycallgraph)                      | Pyramid tween to generate a callgraph image for every request                     | 5     | 2015-12-21  |
| [pyramid_debugtoolbar_dogpile](https://github.com/jvanasco/pyramid_debugtoolbar_dogpile) | dogpile caching support for pyramid_debugtoolbar                                  | 2     | 2023-09-21  |
| [pyramid_bpython](https://github.com/Pylons/pyramid_bpython)                             | bpython bindings for Pyramid's pshell                                             | 0     | 2017-04-11  |

## RESTful API

| Name                                                             | Description                                                                                                                                                                                   | Stars | Last Commit |
|------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [cornice](https://github.com/Cornices/cornice)                   | provides helpers to build & document REST-ish Web Services with Pyramid, with decent default behaviors. It takes care of following the HTTP specification in an automated way where possible. | 386   | 2025-09-08  |
| [ramses](https://github.com/ramses-tech/ramses)                  | Generate a RESTful API using RAML. It uses Nefertari which provides ElasticSearch-powered views.                                                                                              | 303   | 2020-03-29  |
| [cliquet](https://github.com/mozilla-services/cliquet)           | Cliquet is a toolkit to ease the implementation of HTTP microservices, such as data-driven REST APIs.                                                                                         | 65    | 2019-03-28  |
| [nefertari](https://github.com/ramses-tech/nefertari)            | Nefertari is a REST API framework sitting on top of Pyramid and ElasticSearch.                                                                                                                | 53    | 2020-03-29  |
| [rest_toolkit](https://github.com/wichert/rest_toolkit)          | is a Python package which provides a very convenient way to build REST servers. It is build on top of Pyramid, but you do not need to know much about Pyramid to use rest_toolkit.            | 36    | 2022-03-21  |
| [pyramid_jsonapi](https://github.com/colinhiggs/pyramid-jsonapi) | Automatically create a [JSON API](http://jsonapi.org/) standard API from a database using the sqlAlchemy ORM and pyramid framework.                                                           | 27    | 2023-10-05  |
| [pyramid_royal](https://github.com/hadrien/pyramid_royal)        | Royal is a pyramid extension which eases writing RESTful web applications.                                                                                                                    | 24    | 2020-03-29  |
| [pyramid_apispec](https://github.com/ergo/pyramid_apispec)       | Create an OpenAPI specification file using apispec and Marshmallow schemas.                                                                                                                   | 23    | 2023-06-03  |
| [pyramid-openapi3](https://github.com/niteoweb/pyramid_openapi3) | Validate Pyramid views against an OpenAPI 3.0 document. Similar to pyramid_swagger but for OpenAPI 3.0.                                                                                       | 0     | N/A         |
| [pyramid_swagger](https://github.com/striglia/pyramid_swagger)   | Convenient tools for using Swagger to define and validate your interfaces in a Pyramid webapp. (Swagger 2.0 document)                                                                         | 0     | N/A         |
| [webargs](https://github.com/sloria/webargs)                     | A friendly library for parsing HTTP request arguments, with built-in support for popular web frameworks.                                                                                      | 0     | N/A         |

## CMS

| Name                                               | Description                                                                                                                                                                                                | Stars | Last Commit |
|----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Kotti](https://github.com/Kotti/Kotti)            | A user-friendly, light-weight and extensible web content management system. Based on Pyramid and SQLAlchemy.                                                                                               | 412   | 2024-10-29  |
| [substanced](https://github.com/Pylons/substanced) | An application server built upon the Pyramid web framework. It provides a user interface for managing content as well as libraries and utilities which make it easy to create applications.                | 158   | 2025-06-23  |
| [nive_cms](https://github.com/nive/nive_cms)       | Nive is professional out the box content management system for mobile and desktop websites based on python and the webframework pyramid. Please refer to the website cms.nive.co for detailed information. | 18    | 2020-04-01  |

## Email

| Name                                                                       | Description                                                                | Stars | Last Commit |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------|-------|-------------|
| [pyramid_mailer](https://github.com/Pylons/pyramid_mailer)                 | A package for sending email from your Pyramid application.                 | 50    | 2022-11-17  |
| [pyramid_marrowmailer](https://github.com/domenkozar/pyramid_marrowmailer) | Pyramid integration package for marrow.mailer, formerly known as TurboMail | 5     | 2020-03-30  |
| [pyramid_mailgun](https://github.com/evannook/pyramid_mailgun)             | Mailgun integration for Pyramid framework.                                 | 2     | 2016-01-28  |

## Other

| Name                                            | Description                                                                                                                                                                                                                                                             | Stars | Last Commit |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [shootout](https://github.com/Pylons/shootout)  | An example “idea competition” application by Carlos de la Guardia and Lukasz Fidosz. It demonstrates URL dispatch, simple authentication, integration with SQLAlchemy and pyramid_simpleform.                                                                           | 105   | 2013-10-03  |
| [Ptah](https://github.com/ptahproject/ptah)     | Ptah is a fast, fun, open source high-level Python web development environment.                                                                                                                                                                                         | 72    | 2020-04-02  |
| [travelcrm](https://github.com/mazvv/travelcrm) | TravelCRM is effective free and open source application for the automation of customer relationships for travel agencies at all levels, from small to large networks.                                                                                                   | 30    | 2020-04-02  |
| [cluegun](https://github.com/Pylons/cluegun)    | A simple pastebin application based on Rocky Burt’s ClueBin. It demonstrates form processing, security, and the use of ZODB within a Pyramid application.                                                                                                               | 29    | 2012-02-15  |
| [virginia](https://github.com/Pylons/virginia)  | A very simple dynamic file rendering application. It is willing to render structured text documents, HTML documents, and images from a filesystem directory. It’s also a good example of traversal. An earlier version of this application runs the repoze.org website. | 24    | 2023-05-06  |
| [warehouse](https://github.com/pypa/warehouse)  | Warehouse is a next generation Python Package Repository designed to replace the legacy code base that currently powers PyPI.                                                                                                                                           | 0     | N/A         |

## Framework

| Name                                              | Description                                             | Stars | Last Commit |
|---------------------------------------------------|---------------------------------------------------------|-------|-------------|
| [cone.app](https://github.com/conestack/cone.app) | A comprehensive web application stub on top of Pyramid. | 10    | 2025-07-08  |

## Search

| Name                                         | Description                             | Stars | Last Commit |
|----------------------------------------------|-----------------------------------------|-------|-------------|
| [hypatia](https://github.com/Pylons/hypatia) | A Python indexing and searching system. | 31    | 2025-02-12  |

## Templates

| Name                                                             | Description                                                                                                                                             | Stars | Last Commit |
|------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pyramid_jinja2](https://github.com/Pylons/pyramid_jinja2)       | Jinja2 templating system bindings for the Pyramid web framework.                                                                                        | 71    | 2025-09-04  |
| [pyramid_mako](https://github.com/Pylons/pyramid_mako)           | Mako templating system bindings for the Pyramid web framework.                                                                                          | 23    | 2024-12-04  |
| [pyramid_chameleon](https://github.com/Pylons/pyramid_chameleon) | Chameleon template compiler for pyramid.                                                                                                                | 10    | 2023-08-30  |
| [Tonnikala](https://github.com/ztane/Tonnikala)                  | Python templating engine with Pyramid integration                                                                                                       | 1     | 2015-07-22  |
| [Kajiki](https://github.com/nandoflorestan/kajiki)               | provides fast well-formed XML templates, with [Pyramid integration](https://github.com/nandoflorestan/kajiki/blob/master/kajiki/integration/pyramid.py) | 0     | N/A         |

## Settings

| Name                                                              | Description                                                                                                 | Stars | Last Commit |
|-------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|-------|-------------|
| [hupper](https://github.com/Pylons/hupper)                        | A process monitor/reloader for developers that can watch files for changes and restart the process.         | 221   | 2025-09-04  |
| [pyramid_services](https://github.com/mmerickel/pyramid_services) | defines a pattern and helper methods for accessing a pluggable service layer from within your Pyramid apps. | 82    | 2025-09-04  |
| [pyramid_zcml](https://github.com/Pylons/pyramid_zcml)            | Zope Configuration Markup Language configuration support for Pyramid.                                       | 4     | 2022-09-18  |

## Web frontend integration

| Name                                                    | Description                                                                           | Stars | Last Commit |
|---------------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [PyramidVue](https://github.com/eddyekofo94/pyramidVue) | Pyramid and VueJs (JavaScript) template with Hot-Module-Replacement starter template. | 36    | 2022-12-08  |

## Async

| Name                                                           | Description                                                                                                                                              | Stars | Last Commit |
|----------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [gevent-socketio](https://github.com/abourget/gevent-socketio) | gevent-socketio is a Python implementation of the Socket.IO protocol, developed originally for Node.js by LearnBoost and then ported to other languages. | 1211  | 2022-09-17  |
| [aiopyramid](https://github.com/housleyjk/aiopyramid)          | Run pyramid using asyncio.                                                                                                                               | 80    | 2023-07-20  |
| [channelstream](https://github.com/AppEnlight/channelstream)   | websocket communication server (gevent).                                                                                                                 | 0     | N/A         |
| [Stargate](https://github.com/boothead/stargate)               | Stargate is a package for adding WebSockets support to pyramid applications using the excellent eventlet library for long running connections.           | 0     | N/A         |

## Translations

| Name                                                                 | Description                                                                                                                                                                                       | Stars | Last Commit |
|----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [lingua](https://github.com/wichert/lingua)                          | Lingua is a package with tools to extract translatable texts from your code, and to check existing translations. It replaces the use of the xgettext command from gettext, or pybabel from Babel. | 49    | 2024-08-01  |
| [pyramid_i18n_helper](https://github.com/sahama/pyramid_i18n_helper) | helper to create new smgid and translate msgid to local langs .                                                                                                                                   | 3     | 2018-02-04  |

## Forms

| Name                                                                    | Description                                                                                                                       | Stars | Last Commit |
|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [marshmallow](https://github.com/marshmallow-code/marshmallow)          | A lightweight library for converting complex objects to and from simple Python datatypes (i.e. (de)serialization and validation). | 7188  | 2025-09-04  |
| [colander](https://github.com/Pylons/colander)                          | A serialization/deserialization/validation library for strings, mappings and lists.                                               | 457   | 2025-09-05  |
| [deform](https://github.com/Pylons/deform)                              | is a Python HTML form generation library.                                                                                         | 419   | 2024-06-08  |
| [ColanderAlchemy](https://github.com/stefanofontanelli/ColanderAlchemy) | helps you to auto-generate Colander schemas that are based on SQLAlchemy mapped classes.                                          | 65    | 2023-07-11  |
| [WTForms](https://github.com/wtforms/wtforms)                           | is a flexible forms validation and rendering library for python web development.                                                  | 0     | N/A         |

## Authentication

| Name                                                                       | Description                                                                                                                                                                                                                              | Stars | Last Commit |
|----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Python Social Auth](https://github.com/omab/python-social-auth)           | Social authentication/registration mechanism with support for a large number of [providers](https://github.com/omab/python-social-auth#auth-providers).                                                                                  | 2822  | 2022-07-01  |
| [Authomatic](https://github.com/authomatic/authomatic)                     | Simple yet powerful authorization / authentication client library for Python web applications.                                                                                                                                           | 1045  | 2025-09-07  |
| [velruse](https://github.com/bbangert/velruse)                             | Simplifying third-party authentication for web applications. it supports most of auth [providers](https://github.com/bbangert/velruse/tree/master/velruse/providers).                                                                    | 253   | 2024-01-16  |
| [apex](https://github.com/cd34/apex)                                       | Toolkit for Pyramid, a Pylons Project, to add Authentication and Authorization using Velruse (OAuth) and/or a local database, CSRF, ReCaptcha, Sessions, Flash messages and I18N.                                                        | 96    | 2022-09-17  |
| [pyramid_jwt](https://github.com/wichert/pyramid_jwt)                      | This package implements an authentication policy for Pyramid that using [JSON Web Tokens]. This standard ([RFC 7519]) is often used to secure backens APIs. The excellent [PyJWT] library is used for the JWT encoding / decoding logic. | 76    | 2024-11-25  |
| [pyramid_simpleauth](https://github.com/thruflo/pyramid_simpleauth)        | session based authentication and role based security for Pyramid application                                                                                                                                                             | 33    | 2022-11-30  |
| [pyramid_authsanity](https://github.com/usingnamespace/pyramid_authsanity) | That will make it simpler to have a secure authentication policy with an easy to use backend.                                                                                                                                            | 14    | 2023-12-06  |
| [pyramid_ipauth](https://github.com/mozilla-services/pyramid_ipauth)       | Pyramid authentication policy based on remote ip address. [JSON Web Tokens]: https://jwt.io/ [RFC 7519]: https://tools.ietf.org/html/rfc7519 [PyJWT]: https://pyjwt.readthedocs.io/en/latest/                                            | 11    | 2020-03-28  |
| [pyramid_ldap3](https://github.com/Cito/pyramid_ldap3)                     | Provides LDAP authentication services for your Pyramid application based on the ldap3 package.                                                                                                                                           | 11    | 2024-10-31  |
| [pyramid_who](https://github.com/Pylons/pyramid_who)                       | Authentication policy for pyramid using repoze.who 2.0 API.                                                                                                                                                                              | 10    | 2012-04-03  |
| [pyramid_ldap](https://github.com/Pylons/pyramid_ldap)                     | an LDAP authentication policy for Pyramid.                                                                                                                                                                                               | 9     | 2021-07-28  |
