# awesome-composer

 :sunglasses: A curated awesome list for Composer, Packagist, Satis, Plugins, Scripts, Composer related resources, tutorials.

## Composer

- [Composer Installers](https://github.com/composer/installers) - Composer installers for multiple frameworks.
- [GitHub](https://github.com/composer/composer)

## Packagist

- [Docker Image](https://github.com/Webysther/packagist-mirror-docker) - This Docker image helps to create a customized packagist mirror.
- [Packagist Mirror](https://github.com/Webysther/packagist-mirror) - This script helps to setup a packagist mirror. It is the maintained and stable version of [Packagist Crawler](https://github.com/hirak/packagist-crawler).
- [Packagist Mirror from Indonesia](https://github.com/IndraGunawan/packagist-mirror) - Another implementation for creating a packagist mirror. About metadata mirrors: https://packagist.org/mirrors

## Tools

- [Bramus/Composer-Autocomplete](https://github.com/bramus/composer-autocomplete) - A Bash/Shell autocompletion script for Composer.
- [Composer PreferLowest Checker](https://github.com/dereuromark/composer-prefer-lowest) - Strictly compare the specified minimum versions of your composer.json with the ones actually used by the prefer-lowest composer update command option.
- [Composer-Normalize](https://github.com/ergebnis/composer-normalize) - The plugin helps to keep your `composer.json` file(s) consistent by restructuring and sorting entries (normalizing).
- [Composer-Service](https://github.com/pborreli/composer-service) - Enables you to run Composer as a service on a remote server.
- [Composer-Unused](https://github.com/composer-unused/composer-unused) - A CLI tool, which scans your code and shows unused Composer dependencies.
- [Composer-Yaml](https://github.com/igorw/composer-yaml) - This tool converts `composer.yml` to `composer.json`.
- [Composer/Xdebug-Handler](https://github.com/composer/xdebug-handler) - Helps you to restart a CLI process without loading the xdebug extension.
- [ComposerRequireChecker](https://github.com/maglnet/ComposerRequireChecker) - A CLI tool to analyze dependencies and verify that no unknown imported symbols are used in the sources of a package.
- [OctoLinker Browser Extension](https://github.com/OctoLinker/OctoLinker) - Enables you to navigate Composer/NPM dependencies on GitHub.
- [Studio](https://github.com/franzliedke/studio) - A workbench for developing Composer packages. Its an alternative to editing dependencies in the vendor folder or using [PathRepositories](https://getcomposer.org/doc/05-repositories.md#path) to load a local clone of your dependency into your project.

## Scripts

- [Composer-Multitest](https://github.com/raphaelstolt/composer-multitest) - Enables you to run a Composer script against multiple, locally installed PHP versions, which are managed by PHPBrew or phpenv.
- [Composer-Substitution-Plugin](https://github.com/villfa/composer-substitution-plugin) - A Composer plugin replacing placeholders in the `scripts` section by dynamic values.
- [Composer-Travis-Lint](https://github.com/raphaelstolt/composer-travis-lint) - Allows you to lint the Travis CI configuration file (`.travis.yml`).
- [Composer-Vendor-Cleanup](https://github.com/0xch/composer-vendor-cleanup) - A script which removes whitelisted unnecessary files (like tests/docs etc.) from the vendor directory.
- [Melody](https://github.com/sensiolabs/melody) - One-file composer scripts.
- [ParameterHandler](https://github.com/Incenteev/ParameterHandler) - Allows you to manage your ignored parameters when running a composer install or update.
- [PhantomJS-Installer](https://github.com/jakoch/phantomjs-installer) - A Composer Package which installs the PhantomJS binary (Linux, Windows, Mac) into /bin of your project.
- [ScriptsDev](https://github.com/neronmoon/scriptsdev) - Enables you to use a `scripts-dev` section, which triggers scripts only in dev mode.
- [Tooly](https://github.com/tommy-muehle/tooly-composer-script) - Manage needed PHAR files in your project `composer.json`. Every PHAR file will be saved in the composer binary directory. Optional with GPG verification for every PHAR.

## Plugins

- [Composer Preload](https://github.com/Ayesh/Composer-Preload) - The plugin generates a `vendor/preload.php` file to warm up the Opcache.
- [Composer Registry Manager](https://github.com/slince/composer-registry-manager) - Enables you to switch between different composer repositories.
- [Composer Translation Validator](https://github.com/move-elevator/composer-translation-validator) - Validates translation files in your project, supports several file formats (regarding different frameworks) and provides useful validators for comparison, consistency and syntax checks.
- [Composer-Asset-Plugin](https://github.com/fxpio/composer-asset-plugin) - A npm/Bower Dependencies Manager for Composer.
- [Composer-AWS](https://github.com/naderman/composer-aws) - The plugin loads repository data and downloads packages from Amazon S3 (with authentication support for private repositories).
- [Composer-Bin-Plugin](https://github.com/bamarni/composer-bin-plugin) - Adds support for managing dependencies for multiple packages in a single repository or isolate bin dependencies.
- [Composer-Changelogs](https://github.com/pyrech/composer-changelogs) - Provides a summary of the updates with links to changelog/releasenote/tag. The output is ready to be pasted into the commit message when updating the composer.lock file.
- [Composer-Cleaner](https://github.com/dg/composer-cleaner) - The tool removes unnecessary files and directories from the vendor directory.
- [Composer-Cleanup-Plugin](https://github.com/barryvdh/composer-cleanup-plugin) - Removes tests & documentation folders from the vendor dir.
- [Composer-Compile-Plugin](https://github.com/civicrm/composer-compile-plugin) - Allow PHP libraries to define simple, freeform compilation tasks. Support post-install hooks in any package.
- [Composer-Composition](https://github.com/bamarni/composition) - Provides an API, for checking your environment at runtime.
- [Composer-Curl-Plugin](https://github.com/ngyuki/composer-curl-plugin) - The plugin uses `phpext_curl` for downloading packages.
- [Composer-Custom-Directory-Installer](https://github.com/mnsami/composer-custom-directory-installer) - A composer plugin, to install different types of composer packages in custom directories outside the default composer installation path (vendor folder).
- [Composer-Dependency-Analyzer](https://github.com/shipmonk-rnd/composer-dependency-analyser) - The plugin helps to find dependency issues, including dead, unused, shadow and misplaced dependencies.
- [Composer-Diff](https://github.com/IonBazan/composer-diff) - Compares `composer.lock` changes and generates a Markdown report for usage in a pull request description.
- [Composer-Downloads-Plugin](https://github.com/civicrm/composer-downloads-plugin) - Lightweight mechanism to download external resources (ZIP/TAR files) with only a `url` and `path`.
- [Composer-Git-Hooks](https://github.com/BrainMaestro/composer-git-hooks) - A library for easily managing git hooks in your composer config.
- [Composer-Ignore-Plugin](https://github.com/lichunqiang/composer-ignore-plugin) - Enables you to remove files and folders from the vendor folder (to make a cleaner and smaller deployment to production). It's an alternative to `.gitattributes`.
- [Composer-Inheritance-Plugin](https://github.com/theofidry/composer-inheritance-plugin) - Opinionated version of Wikimedia composer-merge-plugin to work in pair with Bamarni composer-bin-plugin.
- [Composer-Link](https://github.com/SanderSander/composer-link) - Adds the ability to link local packages for development.
- [Composer-Locator](https://github.com/mindplay-dk/composer-locator) - Provides a means of locating the installation path for a given Composer package name.
- [Composer-Merge-Plugin](https://github.com/wikimedia/composer-merge-plugin) - Merges multiple `composer.json` files at Composer runtime.
- [Composer-MonoRepo-Plugin](https://github.com/beberlei/composer-monorepo-plugin) - The plugin helps to manage dependencies for multiple packages in a single repository.
- [Composer-Patches](https://github.com/cweagans/composer-patches) - The plugin applies a patch from a local or remote file to any required package.
- [Composer-Patches](https://github.com/vaimo/composer-patches) - Applies a patch from a local or remote file to any package that is part of a given composer project.
- [Composer-Patches-Plugin](https://github.com/netresearch/composer-patches-plugin) - Enables you to provide patches for any package from any package. When the dependency is fetched, the patch is applied on top.
- [Composer-Patchset](https://github.com/mageops/php-composer-plugin-patchset) - Automatically fetch, update and apply patches to any composer package with a twist - store the patchset as a composer package itself.
- [Composer-Plugin-Exclude-Files](https://github.com/mcaskill/composer-plugin-exclude-files) - A plugin for excluding files required by packages using the 'files' autoloading mechanism.
- [Composer-Plugin-QA](https://github.com/Webysther/composer-plugin-qa) - Comprehensive Plugin for composer to execute PHP Quality assurance Tools.
- [Composer-REPL](https://github.com/ramsey/composer-repl) - The plugin provides the `composer repl` command, which gives you a PHP language shell (read-eval-print loop).
- [Composer-Shared-Package-Plugin](https://github.com/Letudiant/composer-shared-package-plugin) - Allows you to share selected packages between your projects by creating symlinks.
- [Composer-Skrub](https://github.com/ssx/skrub) - The plugin helps to remove junk from Composer installations and trim build sizes.
- [Composer-Suggest](https://github.com/nfreear/composer-suggest) - Enables you to install a custom group of suggested packages, based on keyword patterns.
- [Composer-Symlinker](https://github.com/e-picas/composer-symlinker) - Enables you to load packages from different directories (instead of loading them from /vendor).
- [Composer-Velocita](https://github.com/isaaceindhoven/composer-velocita) - Fast and reliable Composer package downloads using [Velocita](https://github.com/isaaceindhoven/velocita-proxy): a caching reverse proxy that does not require you to modify your projects.
- [Composer-Vendor-Cleaner](https://github.com/liborm85/composer-vendor-cleaner) - Plugin removes unnecessary development files and directories from `vendor` directory by glob pattern syntax.
- [Composer-Versions-Check](https://github.com/Soullivaneuh/composer-versions-check) - Shows outdated packages from last major versions after using the update command (showing "Latest is vX.Y.Z").
- [Composer-Warmup](https://github.com/jderusse/composer-warmup) - The plugin adds the command `warmup-opcode` to Composer, which triggers the compilation of all PHP files discovered in your project into the Opcache.
- [CycloneDX-PHP-Composer](https://github.com/CycloneDX/cyclonedx-php-composer) - Creates a [CycloneDX](https://cyclonedx.org/) "Software Bill-of-Materials" (SBOM) for the dependencies of a project. The SBOM enables dependency monitoring and risk analysis by [OWASP DependencyTrack](https://dependencytrack.org/).
- [Drupal Vendor Hardening Composer Plugin](https://github.com/drupal/core-vendor-hardening) - Removes extraneous directories from the project's vendor directory & adds .htaccess and web.config files to the root of the project's vendor directory.
- [Foxy](https://github.com/fxpio/foxy) - Composer plugin that executes npm/yarn packages installation operations, when composer package is installed or updated.
- [Graph-Composer](https://github.com/clue/graph-composer) - Provides a graph visualization for your project's `composer.json` and its dependencies.
- [Imposter-Plugin](https://github.com/typisttech/imposter-plugin) - Wrapping all composer vendor packages inside your own namespace. Intended for WordPress plugins.
- [Narrowspark-Automatic](https://github.com/narrowspark/automatic) - Automates the most common tasks of applications, boost package downloads, adds a composer security audit and more.
- [Node-Composer](https://github.com/mariusbuescher/node-composer) - Installer for Node.js, npm and yarn.
- [NodeJS-Installer](https://github.com/thecodingmachine/nodejs-installer) - Installer for Node.js and npm.
- [PackageInfo](https://github.com/ThaDafinser/PackageInfo) - Enables you to retrieve all package informations (like version, tag, release date, description).
- [PackageVersions](https://github.com/Ocramius/PackageVersions) - Provides a very quick and easy access to installed composer dependency versions.
- [PackageVersions Deprecated](https://github.com/composer/package-versions-deprecated) - Is a fork of Ocramius/PackageVersions providing compatibility with Composer 1 and 2 on PHP 7+.
- [PHP Inc](https://github.com/krakphp/php-inc) - Automatically includes files for autoload and autoload-dev to facilitate using functions and grouped definitions within composer loaded applications.
- [PHPCodeSniffer-Composer-Installer](https://github.com/PHPCSStandards/composer-installer) - The plugin enables you to install [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) coding standards (rulesets).
- [Prestissimo](https://github.com/hirak/prestissimo) - A parallel downloader using `phpext_curl`.
- [Private-Composer-Installer](https://github.com/ffraenz/private-composer-installer) - Install helper outsourcing sensitive keys from the package URL into environment variables.
- [Production-Dependencies-Guard](https://github.com/kalessil/production-dependencies-guard) - Prevents development packages from being added into require and getting into production environment.
- [Symfony-Flex](https://github.com/symfony/flex) - Provides [recipe-based](https://github.com/symfony/recipes) installation and configuration management for Symfony packages.

## Composer Repositories

- [fxpio/tug](https://github.com/fxpio/tug) - Enables you to host a private Composer registry on AWS Serverless serving your private PHP packages, which are hosted on GitHub or GitLab services.
- [Private Packagist API Client](https://github.com/packagist/private-packagist-api-client) - A PHP client for the Private Packagist API. The client handles authentication, signature generation and access to all endpoints.
- [repman-io/composer-plugin](https://github.com/repman-io/composer-plugin) - This plugin enables downloading via Repman by adding a distribution mirror URL for all your dependencies (without need to update the `composer.lock` file).

## Packagist-compatible repositories

- [GitLab-Composer](https://github.com/wemakecustom/gitlab-composer) - This is a branch/tag indexer for GitLab repositories.
- [Packeton](https://github.com/vtsykun/packeton) - Private self-hosted Composer repository for vendors. Fork of packagist with adding support for authorization, customer users, groups, webhooks.
- [Release Belt](https://github.com/Rarst/release-belt) - Self–hosted Composer repository implementation to quickly integrate ZIP files of third party non–Composer releases.
- [Satis Control Panel](https://github.com/realshadow/satis-control-panel) - A simple web UI for managing your Satis Repository with optional CI integration.
- [Satis Go](https://github.com/benschw/satis-go) - A web server for managing Satis configuration and hosting the generated Composer repository.
- [Satis Server](https://github.com/lukaszlach/satis-server) - This docker container provides a Satis Server and enables you to run a private, self-hosted Composer repository with support for Git, Mercurial, and Subversion, HTTP API, HTTPs support, webhook handler and scheduled builds.
- [Satisfy](https://github.com/project-satisfy/satisfy) - Satis composer repository manager with a Web UI.
