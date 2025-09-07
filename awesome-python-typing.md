# awesome-python-typing

Collection of awesome Python types, stubs, plugins, and tools to work with them.

## Tools

- [flake8-annotations-complexity](https://github.com/best-doctor/flake8-annotations-complexity) - Plugin for flake8 to validate annotations complexity.
- [flake8-annotations](https://github.com/sco1/flake8-annotations) - Plugin for flake8 to check for presence of type annotations in function definitions.
- [flake8-pyi](https://github.com/ambv/flake8-pyi) - Plugin for Flake8 that provides specializations for type hinting stub files.
- [flake8-type-checking](https://github.com/snok/flake8-type-checking) - Plugin to help you guard any type-annotation-only import correctly.
- [flake8-typing-imports](https://github.com/asottile/flake8-typing-imports) - Plugin which checks that typing imports are properly guarded.
- [flake8-typing-only-imports](https://github.com/sondrelg/flake8-typing-only-imports) - flake8 plugin that helps identify which imports to put into type-checking blocks, and how to adjust your type annotations once imports are moved.
- [wemake-python-styleguide](https://github.com/wemake-services/wemake-python-styleguide) - The strictest and most opinionated Python linter ever.
- [Ruff](https://github.com/astral-sh/ruff) - Extremely fast linter which supports lint rules from many other lint tools, such as flake8.
- [mypy-test](https://github.com/orsinium-labs/mypy-test) - Test mypy plugins, stubs, custom types.
- [pytest-mypy-plugins](https://github.com/typeddjango/pytest-mypy-plugins) - Pytest plugin for testing mypy types, stubs, and plugins.
- [pytest-mypy-testing](https://github.com/davidfritzsche/pytest-mypy-testing) - Pytest plugin to test mypy static type analysis.
- [pytest-mypy](https://github.com/dbader/pytest-mypy) - Mypy static type checker plugin for Pytest.
- [com2ann](https://github.com/ilevkivskyi/com2ann) - Tool for translation of type comments to type annotations.
- [mypy-baseline](https://github.com/orsinium-labs/mypy-baseline) - Integrate mypy with existing codebase. A CLI tool that filters out existing type errors and reports only new ones.
- [mypy-protobuf](https://github.com/dropbox/mypy-protobuf) - Tool to generate mypy stubs from protobufs.
- [mypy-silent](https://github.com/whtsky/mypy-silent) - Silence mypy by adding or removing code comments.
- [retype](https://github.com/ambv/retype) - Another tool to apply stubs to code.
- [typeforce](https://github.com/orsinium-labs/typeforce) - CLI tool that enriches your Python environment with type annotations, empowering mypy.
- [typesplainer](https://github.com/wasi-master/typesplainer) - A Python type explainer.
- [typing-inspect](https://github.com/ilevkivskyi/typing_inspect) - The typing_inspect module defines experimental API for runtime inspection of types defined in the `typing` module.
- [autotyping](https://github.com/JelleZijlstra/autotyping) - Automatically add simple return type annotations for functions (bool, None, Optional).
- [infer-types](https://github.com/orsinium-labs/infer-types) - CLI tool to automatically infer and add type annotations into Python code.
- [jsonschema-gentypes](https://github.com/camptocamp/jsonschema-gentypes) - Generate Python types based on TypedDict from a JSON Schema.
- [monkeytype](https://github.com/instagram/MonkeyType) - Collects runtime types of function arguments and return values, and can automatically generate stub files or even add draft type annotations directly to your code based on the types collected at runtime.
- [no_implicit_optional](https://github.com/hauntsaninja/no_implicit_optional) - A codemod to make your implicit optional type hints [PEP 484](https://peps.python.org/pep-0484/#union-types) compliant.
- [pyannotate](https://github.com/dropbox/pyannotate) - Insert annotations into your source code based on call arguments and return types observed at runtime.
- [PyTypes](https://github.com/pvs-hd-tea/PyTypes) - Infer Types by Python Tracing.
- [pyre infer](https://github.com/facebook/pyre-check) - Pyre has a powerful feature for migrating codebases to a typed format. The [infer](https://pyre-check.org/docs/pysa-coverage/) command-line option ingests a file or directory, makes educated guesses about the types used, and applies the annotations to the files.
- [pytest-annotate](https://github.com/kensho-technologies/pytest-annotate) - Pyannotate plugin for pytest.
- [pytest-monkeytype](https://github.com/mariusvniekerk/pytest-monkeytype) - MonkeyType plugin for pytest.
- [RightTyper](https://github.com/RightTyper/RightTyper) - A tool that generates types for your function arguments and return values. RightTyper lets your code run at nearly full speed with almost no memory overhead.
- [type4py](https://github.com/saltudelft/type4py) - Deep Similarity Learning-Based Type Inference.
- [typilus](https://github.com/typilus/typilus) - A deep learning algorithm for predicting types in Python. Also available as a [GitHub action](https://github.com/typilus/typilus-action)
- [auto-optional](https://github.com/Luttik/auto-optional) - Makes typed arguments Optional when the default argument is `None`.
- [kubernetes-typed](https://github.com/gordonbondon/kubernetes-typed) - Plugin for kubernetes [CRD](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/) type checking.
- [loguru-mypy](https://github.com/kornicameister/loguru-mypy) - Plugin for [loguru](https://github.com/Delgan/loguru) support.
- [mypy-zope](https://github.com/Shoobx/mypy-zope) - Plugin for [zope.interface](https://zopeinterface.readthedocs.io/en/latest/) support.
- [pynamodb-mypy](https://github.com/pynamodb/pynamodb-mypy) - Plugin for [PynamoDB](https://github.com/pynamodb/PynamoDB) support.

## Related

- [awesome-python](https://github.com/vinta/awesome-python) - Curated list of awesome Python frameworks, libraries, software and resources.
- [python-typecheckers](https://github.com/ethanhs/python-typecheckers) - List of Python type checkers: static and runtime.

## Articles

- [Python-typing-koans](https://github.com/kracekumar/python-typing-koans) - A set of examples to learn optional static typing in Python.

## Stub packages

- [asgiref](https://github.com/django/asgiref) - ASGI specification, provides [asgiref.typing](https://github.com/django/asgiref/blob/main/asgiref/typing.py) module with type annotations for ASGI servers.
- [botostubs](https://github.com/jeshan/botostubs) - Gives you code assistance for any boto3 API in any IDE.
- [celery-types](https://github.com/sbdchd/celery-types) - Type stubs for [Celery](https://github.com/celery/celery) and its related packages [django-celery-results](https://github.com/celery/django-celery-results), [ampq](https://github.com/celery/py-amqp), [kombu](https://github.com/celery/kombu), [billiard](https://github.com/celery/billiard), [vine](https://github.com/celery/vine) and [ephem](https://github.com/brandon-rhodes/pyephem).
- [django-stubs](https://github.com/typeddjango/django-stubs) - Stubs for [Django](https://github.com/django/django).
- [djangorestframework-stubs](https://github.com/typeddjango/djangorestframework-stubs) - Stubs for [DRF](https://github.com/encode/django-rest-framework).
- [grpc-stubs](https://github.com/shabbyrobe/grpc-stubs) - Stubs for [grpc](https://github.com/grpc/grpc).
- [lxml-stubs](https://github.com/lxml/lxml-stubs) - Stubs for [lxml](https://lxml.de).
- [PyQt5-stubs](https://github.com/stlehmann/PyQt5-stubs) - Stubs for [PyQt5](https://www.riverbankcomputing.com/software/pyqt/intro).
- [python-phonenumbers-stubs](https://github.com/AA-Turner/python-phonenumbers-stubs) - Stubs for [phonenumbers](https://github.com/daviddrysdale/python-phonenumbers).
- [pythonista-stubs](https://github.com/hbmartin/pythonista-stubs) - Stubs for [Pythonista](http://omz-software.com/pythonista/docs/ios/).
- [scipy-stubs](https://github.com/jorenham/scipy-stubs) - Stubs for [SciPy](https://github.com/scipy/scipy).
- [sqlalchemy-stubs](https://github.com/dropbox/sqlalchemy-stubs) - Stubs for [SQLAlchemy](https://github.com/sqlalchemy/sqlalchemy).
- [torchtyping](https://github.com/patrick-kidger/torchtyping) - Enhanced type annotations for [pytorch](https://pytorch.org/).
- [typeshed](https://github.com/python/typeshed) - Collection of library stubs, with static types.

## Static type checkers

- [basedmypy](https://github.com/KotlinIsland/basedmypy) - Based static typing with baseline functionality.
- [basedpyright](https://github.com/detachhead/basedpyright) - Pyright fork with improvements to VSCode support and various other fixes.
- [mypy](https://github.com/python/mypy) - Optional static typing (PEP 484).
- [pyanalyze](https://github.com/quora/pyanalyze) - Extensible static analyzer and type checker.
- [pylyzer](https://github.com/mtshiba/pylyzer) - A fast static code analyzer & language server for Python, written in Rust.
- [pyright](https://github.com/Microsoft/pyright) - Fast type checker meant for large Python source bases. It can run in a “watch” mode and performs fast incremental updates when files are modified.
- [pytype](https://github.com/google/pytype) - Tool to check and infer types - without requiring type annotations.

## Dynamic type checkers

- [beartype](https://github.com/beartype/beartype) - Unbearably fast `O(1)` runtime type-checking in pure Python.
- [pydantic](https://github.com/samuelcolvin/pydantic) - Data parsing using Python type hinting. Supports dataclasses.
- [pytypes](https://github.com/Stewori/pytypes) - Provides a rich set of utilities for runtime typechecking.
- [strongtyping](https://github.com/FelixTheC/strongtyping) - Decorator which checks whether the function is called with the correct type of parameters.
- [typedpy](https://github.com/loyada/typedpy) - Type-safe, strict Python. Works well with standard Python.
- [typeguard](https://github.com/agronholm/typeguard) - Another one runtime type checker.
- [typical](https://github.com/seandstewart/typical) - Data parsing and automatic type-coercion using type hinting. Supports dataclasses, standard classes, function signatures, and more.
- [trycast](https://github.com/davidfstr/trycast) - Parse JSON-like values whose shape is defined by typed dictionaries (TypedDicts) and other standard Python type hints.

## Additional types

- [meiga](https://github.com/alice-biometrics/meiga) - Simple, typed and monad-based Result type.
- [option](https://github.com/MaT1g3R/option) - Rust like Option and Result types.
- [optype](https://github.com/jorenham/optype) - Opinionated `collections.abc` and `operators` alternative: Flexible single-method protocols and typed operators with predictable names.
- [phantom-types](https://github.com/antonagestam/phantom-types) - Phantom types.
- [returns](https://github.com/dry-python/returns) - Make your functions return something meaningful, typed, and safe.
- [safetywrap](https://github.com/mplanchard/safetywrap) - Fully typesafe, Rust-like Result and Option types.
- [typet](https://github.com/contains-io/typet) - Length-bounded types, dynamic object validation.
- [useful-types](https://github.com/hauntsaninja/useful_types) - Collection of useful protocols and type aliases.

## Integrations

- [emacs-flycheck-mypy](https://github.com/lbolla/emacs-flycheck-mypy) - Mypy integration for Emacs.
- [mypy-playground](https://github.com/ymyzk/mypy-playground) - Online playground for mypy.
- [mypy-pycharm-plugin](https://github.com/dropbox/mypy-PyCharm-plugin) - Mypy integration for PyCharm.
- [pylance](https://github.com/microsoft/pylance-release) - PyRight integration for VSCode.
- [vim-mypy](https://github.com/Integralist/vim-mypy) - Mypy integration for Vim.
- [nbQA](https://github.com/nbQA-dev/nbQA) - Run type checkers (e.g. Mypy) on Jupyter Notebooks.

## Backports and improvements

- [future-typing](https://github.com/PrettyWood/future-typing) - Backport for type hinting generics in standard collections and union types as `X | Y`.
- [typing-extensions](https://github.com/python/typing_extensions) - Backported and experimental type hints.
- [typing-utils](https://github.com/bojiang/typing_utils) - Backport 3.8+ runtime typing utils(for eg: get_origin) & add issubtype & more.
