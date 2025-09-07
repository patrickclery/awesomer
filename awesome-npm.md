# awesome-npm

Awesome npm resources and tips

## Clients

- [npm](https://github.com/npm/cli) - The official client.
- [pnpm](https://github.com/pnpm/pnpm) - Fast, disk space efficient package manager.
- [yarn](https://github.com/yarnpkg/yarn) - Fast, reliable, and secure dependency management.

## Articles

- [The Art of Node](https://github.com/maxogden/art-of-node) - An introduction to Node.js and client-side development with npm.

## Packages

- [cli-error-notifier](https://github.com/micromata/cli-error-notifier) - Sends native desktop notifications when npm scripts fail.
- [david](https://github.com/alanshaw/david) - Check if your package dependencies are out of date.
- [decheck](https://github.com/egoist/decheck) - Explore dependencies of npm packages in the command-line.
- [dpn](https://github.com/gillstrom/dpn) - Get the dependents of a user's npm packages.
- [emma-cli](https://github.com/maticzav/emma-cli) - Interactive CLI package search utility.
- [engine-deps](https://github.com/samccone/engine-deps) - Manage Node.js version specific dependencies with ease.
- [enpeem-search](https://github.com/amovah/enpeem-search) - Search packages by scraping the npm web search.
- [generator-nm](https://github.com/sindresorhus/generator-nm) - Scaffold out an npm package.
- [gh-home](https://github.com/sindresorhus/gh-home) - Open the GitHub page of a package.
- [john](https://github.com/davej/john) - Make npm3's flat dependencies easier to find and sort.
- [latest-version](https://github.com/sindresorhus/latest-version-cli) - Get the latest version of an npm package.
- [local-npm](https://github.com/nolanlawson/local-npm) - Use npm [offline](https://addyosmani.com/blog/using-npm-offline/).
- [lockfile-lint](https://github.com/lirantal/lockfile-lint) - Lint lockfiles for improved security and trust policies to mitigate malicious package injection and insecure lockfile resources.
- [luna](https://github.com/rvpanoz/luna) - App to manage npm dependencies.
- [normalize-package-data](https://github.com/npm/normalize-package-data) - Normalize package metadata.
- [np](https://github.com/sindresorhus/np) - A better `npm publish`.
- [npe](https://github.com/zeke/npe) - CLI for inspecting and editing properties in package.json.
- [npm-check](https://github.com/dylang/npm-check) - Check for outdated, incorrect, and unused dependencies, as well as interactive update.
- [npm-cli-login](https://github.com/postmanlabs/npm-cli-login) - Log in to npm.
- [npm-email](https://github.com/sindresorhus/npm-email) - Get the email of an npm user.
- [npm-home](https://github.com/sindresorhus/npm-home) - Open the npm page of a package.
- [npm-issues](https://github.com/seanzarrin/npm-issues) - Search known issues of all your packages at once.
- [npm-keyword](https://github.com/sindresorhus/npm-keyword) - Get a list of npm packages with a certain keyword.
- [npm-name](https://github.com/sindresorhus/npm-name-cli) - Check whether a package name is available on npm.
- [npm-register](https://github.com/dickeyxxx/npm-register) - Easy to set up and maintain npm registry and proxy.
- [npm-release](https://github.com/phuu/npm-release) - Making releasing to npm so easy a kitten could probably do it™.
- [npm-run-all](https://github.com/mysticatea/npm-run-all) - CLI tool to run multiple npm-scripts in parallel or serial.
- [npm-run-path](https://github.com/sindresorhus/npm-run-path) - Run locally installed binaries in the terminal by name like with global ones.
- [npm-shrinkwrap](https://github.com/uber/npm-shrinkwrap) - A consistent shrinkwrap tool.
- [npm-stats](https://github.com/hughsk/npm-stats) - Get data from an npm registry.
- [npm-upgrade](https://github.com/th0r/npm-upgrade) - Update outdated npm dependencies interactively.
- [npm-user](https://github.com/sindresorhus/npm-user) - Get user info of an npm user.
- [npm-user-packages](https://github.com/kevva/npm-user-packages-cli) - Get packages by an npm user.
- [npm-windows-upgrade](https://github.com/felixrieseberg/npm-windows-upgrade) - Upgrade npm on Windows.
- [nrm](https://github.com/Pana/nrm) - Registry manager.
- [ntl](https://github.com/ruyadorno/ntl) - Interactive CLI menu to list & run npm tasks.
- [onchange](https://github.com/Qard/onchange) - Watch files and folders and run a command when something changed.
- [package-config](https://github.com/sindresorhus/package-config) - Get namespaced config from the closest package.json.
- [package-json](https://github.com/sindresorhus/package-json) - Get the package.json of a package from the npm registry.
- [package-size](https://github.com/egoist/package-size) - Get the bundle size of an npm package.
- [package-up](https://github.com/sindresorhus/package-up) - Find the closest package.json file.
- [pkgfiles](https://github.com/timoxley/pkgfiles) - List all files which would be published in a package.
- [publish-please](https://github.com/inikulin/publish-please) - Publish packages safely and gracefully.
- [read-package-up](https://github.com/sindresorhus/read-package-up) - Read the closest package.json file.
- [redrun](https://github.com/coderaiser/redrun) - Expand scripts from package.json to improve execution speed.
- [release-it](https://github.com/webpro/release-it) - Automate releases for Git repositories and/or npm packages. Changelog generation, GitHub/GitLab releases, etc.
- [semantic-release](https://github.com/semantic-release/semantic-release) - Fully automated package publishing.
- [shrinkpack](https://github.com/JamieMason/shrinkpack) - Lock down your dependencies and install offline.
- [synp](https://github.com/imsnif/synp) - Convert yarn.lock to package-lock.json and vice versa.
- [verdaccio](https://github.com/verdaccio/verdaccio) - Lightweight private npm proxy registry.

## Related

- [awesome-nodejs](https://github.com/sindresorhus/awesome-nodejs)

## Documentation

- [Stats API](https://github.com/npm/download-counts)

## Tools

- [npkill](https://github.com/voidcosmos/npkill) - Easily find and remove old and heavy node_modules folders.
- [zsh-better-npm-completion](https://github.com/lukechilds/zsh-better-npm-completion) - Better ZSH completion for npm.

## Tips

- [Windows users, read more.](https://github.com/felixrieseberg/npm-windows-upgrade) - Speed up your common npm tasks. In your `.zshrc`/`.bashrc`: ```sh alias ni='npm install' alias nid='npm install --save-dev' alias nig='npm install --global' alias nt='npm test' alias nit='npm install && npm test' alias nk='npm link' alias nr='npm run' alias ns='npm start' alias nf='npm cache clean && rm -rf node_modules && npm install' alias nlg='npm list --global --depth=0' ``` By default npm adds packages you install to the `dependencies` field in package.json (since v5). You can prevent this by specifying the `--no-save` flag. You can add a package to `devDependencies` with `--save-dev`/`-D`: ``` $ npm install --save-dev ava ``` You can easily [run scripts](https://docs.npmjs.com/cli/run-script) using npm by adding them to the `"scripts"` field in package.json and run them with `npm run <script-name>`. Run `npm run` to see available scripts. Binaries of locally install packages are made available in the [PATH](https://en.wikipedia.org/wiki/PATH_(variable)), so you can run them by name. ```json { "name": "awesome-package", "scripts": { "cat": "cat-names" }, "dependencies": { "cat-names": "^1.0.0" } } ``` ``` $ npm run cat Max ``` All package.json properties are [exposed](https://docs.npmjs.com/misc/scripts#packagejson-vars) as environment variables: ```json { "name": "awesome-package", "scripts": { "name": "echo $npm_package_name" } } ``` ``` $ npm run name awesome-package ``` You can pass options to the command you are using in your npm script by adding `-- --flag` like in the example below. The `--` [marks the end of options parsing](https://unix.stackexchange.com/questions/11376/what-does-double-dash-mean-also-known-as-bare-double-dash), so `npm run` will just ignore it and pass it to the command. ```json { "name": "awesome-package", "scripts": { "xo": "xo", "xo:fix": "npm run xo -- --fix", } } ``` `npm run` has a `--silent` option which is especially useful when combining npm scripts. Imagine you have a setup for linting your JavaScript files like the following: ```json { "name": "awesome-package", "scripts": { "xo": "xo", "xo:fix": "npm run xo --silent -- --fix", } } ``` npm comes with predefined [lifecyle scripts](https://docs.npmjs.com/misc/scripts) which are excuted under specific conditions if they are defined in your package.json. ```json { "name": "awesome-package", "scripts": { "prepublishOnly": "nsp check" }, "devDependencies": { "nsp": "^3.0.0" } } ``` This will be executed automatically before your npm package is published to the registry via `npm publish` to check for known vulnerabilties in your dependencies. `npm start` and `npm test` are also lifecycle scripts but are not executed automatically. ```json { "name": "awesome-package", "scripts": { "start": "node server.js", "test": "ava" }, "devDependencies": { "ava": "^1.0.0" } } ``` Therefore they can be executed simply with: ```console $ npm test $ npm start ``` These are special lifecycle scripts which can be used to run scripts automatically in sequence. ```json { "name": "awesome-package", "scripts": { "pretest": "eslint .", "test": "ava" }, "devDependencies": { "eslint": "^4.19.0", "ava": "^1.0.0" } } ``` ```console $ npm test ``` This will lint your files before running your tests. The tests will not run if linting fails. Or more generally spoken: the following script won’t be executed if one of the scripts running in sequence exits with an exit code other than 0. `npm` [comes bundled](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b) with `npx` (Since v5.2.0) — a tool to execute package binaries. Each command is executed either from the local `node_modules/.bin` directory, or from a central cache, installing any packages needed in order for `<command>` to run. ```json { "name": "awesome-package", "dependencies": { "cat-names": "^1.0.0" } } ``` If the binary is already installed, it will be executed from `node_modules/.bin`. ``` $ npx cat-names Max ``` But if the binary is missing, it will be installed first. ``` $ npx dog-names npx: installed 46 in 3.136s Bentley ``` With `npx` (Comes bundled with npm v5.2.0 or newer) and the [`node-bin`](https://www.npmjs.com/package/node-bin) package, you can easily try out code in different Node.js versions without having to use a version manager like [`nvm`](http://nvm.sh), [`nave`](https://github.com/isaacs/nave), or [`n`](https://github.com/tj/n). ``` $ npx --package=node-bin@6.11.0 -- node --version v6.11.0 ``` Sometimes it can be useful to have a local version of a package as a dependency. You can use `npm link` to link one local package into another. Run `npm link` in the package you want to use. This creates a global reference. Then go into your original package and run `npm link <package-name>` to link in the other package. ``` $ cd rainbow $ npm link $ cd ../unicorn $ npm link rainbow ``` You can now use `rainbow` as a dependency in the `unicorn` package. npm supports using a shorthand for installing a package directly from a GitHub repo: ``` $ npm install sindresorhus/chalk ``` Let's target a specific commit as the main branch is a moving target: ``` $ npm install 'sindresorhus/chalk#51b8f32' ``` Specify either a commit SHA, branch, tag, or nothing. You can also install Git dependencies with semver: *(Requires npm v5 or newer)* ``` $ npm install 'sindresorhus/chalk#semver:^2.0.0' ``` ``` $ npm install chalk@1.0.0 ``` ``` $ npm ls --depth=0 ``` Get help docs for a command: ``` $ npm help <command> ``` Example: ``` $ npm help install ``` Quickly get a standalone version of a package that is browserified and usable in the browser. ``` https://wzrd.in/standalone/<package-name>[@<version>] ``` Examples: Great for prototyping, but download the file or use Browserify yourself for production.
