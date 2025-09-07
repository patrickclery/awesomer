# awesome-cross-platform-nodejs

:two_men_holding_hands: A curated list of awesome developer tools for writing cross-platform Node.js code

## Applications

- [nvm-windows](https://github.com/coreybutler/nvm-windows) - Manage multiple installations of Node.js on a Windows computer.
- [nvm](https://github.com/creationix/nvm)
- [npm-windows-upgrade](https://github.com/felixrieseberg/npm-windows-upgrade) - Upgrade npm on Windows.
- [windows-build-tools](https://github.com/felixrieseberg/windows-build-tools) - Install C++ Build Tools for Windows using npm.
- [Github Action](https://github.com/features/actions) - Windows/macOS/Linux. GitHub Actions makes it easy to automate all your software workflows.
- [ievms](https://github.com/amichaelparker/ievms) - Automated installer for the free virtual machine images that Microsoft provides for testing on multiple versions of IE. These images can be useful for cross-platform testing various technologies, however make sure you read and understand Microsofts' licensing.
- [Redis](https://github.com/tporadowski/redis) - Native port of Redis for Windows.

## Libraries

- [is-windows](https://github.com/jonschlinkert/is-windows) - Detect whether the current platform is Windows.
- [is-wsl](https://github.com/sindresorhus/is-wsl) - Detect whether current platform is WSL (Windows Subsystem for Linux).
- [getos](https://github.com/retrohacker/getos) - Retrieve the current OS, including Linux distribution.
- [os-name](https://github.com/sindresorhus/os-name) - Get the name of the current operating system.
- [systeminformation](https://github.com/sebhildebrandt/systeminformation) - Hardware/software system information.
- [execa](https://github.com/sindresorhus/execa) - Cross-platform implementation of `child_process.{execFile,exec}`.
- [gulp-execa](https://github.com/ehmicky/gulp-execa) - Cross-platform command execution in Gulp.js.
- [cross-spawn](https://github.com/IndigoUnited/node-cross-spawn) - Cross-platform implementation of `child_process.spawn()`.
- [shelljs](https://github.com/shelljs/shelljs) - Cross-platform Unix shell commands.
- [node-windows](https://github.com/coreybutler/node-windows) - Windows support for Node.js scripts (daemons, eventlog, UAC, etc).
- [log-symbols](https://github.com/sindresorhus/log-symbols) - Colored symbols for various log levels with Windows fallbacks.
- [figures](https://github.com/sindresorhus/figures) - Unicode symbols with Windows fallbacks.
- [clipboardy](https://github.com/sindresorhus/clipboardy)
- [cross-env](https://github.com/kentcdodds/cross-env) - Set environment variables cross-platform.
- [user-home](https://github.com/sindresorhus/user-home) - Get the path to the user home directory. Cross-platform.
- [username](https://github.com/sindresorhus/username) - Get the current username.
- [osenv](https://github.com/npm/osenv) - Cross-platform environment variables.
- [is-elevated](https://github.com/sindresorhus/is-elevated) - Check if the process is running with elevated privileges.
- [which](https://github.com/npm/node-which) - Cross-platform implementation of Unix's `which`.
- [rimraf](https://github.com/isaacs/rimraf)
- [make-dir](https://github.com/sindresorhus/make-dir) - Cross-platform `mkdir -p`.
- [readdirp](https://github.com/paulmillr/readdirp) - Recursive version of `fs.readdir()`.
- [cpy](https://github.com/sindresorhus/cpy) - Copy files. Cross-platform.
- [chokidar](https://github.com/paulmillr/chokidar) - Improved cross-platform file watching.
- [graceful-fs](https://github.com/isaacs/node-graceful-fs) - Improves the `fs` module, especially on Windows.
- [fs-extra](https://github.com/jprichardson/node-fs-extra) - Combines `graceful-fs` with better JSON file reading and promises.
- [any-path](https://github.com/bcoe/any-path) - Use Windows and POSIX paths interchangeably when fetching values from an object.
- [dev-null-cli](https://github.com/sindresorhus/dev-null-cli) - Cross-platform `/dev/null`.
- [global-cache-dir](https://github.com/ehmicky/global-cache-dir) - Get the global OS-specific cache directory.
- [fkill](https://github.com/sindresorhus/fkill) - Kill processes. Cross-platform.
- [signal-exit](https://github.com/tapjs/signal-exit) - Cross-platform `exit` handler.
- [human-signals](https://github.com/ehmicky/human-signals) - Human-friendly process signals.
- [ps-list](https://github.com/sindresorhus/ps-list) - Get running processes.
- [process-exists](https://github.com/sindresorhus/process-exists) - Check if a process exists.
- [noop-stream](https://github.com/sindresorhus/noop-stream) - Cross-platform `fs.createReadStream('/dev/null')`.
- [random-bytes-readable-stream](https://github.com/sindresorhus/random-bytes-readable-stream) - Cross-platform `fs.createReadStream('/dev/urandom')`.
- [open](https://github.com/sindresorhus/open) - Opens stuff like websites, files, executables. Cross-platform.
- [node-notifier](https://github.com/mikaelbr/node-notifier) - Cross-platform desktop notifications.
- [node-winreg](https://github.com/fresc81/node-winreg) - Access the Windows registry.
- [rage-edit](https://github.com/MikeKovarik/rage-edit) - Access/modify the Windows registry.
- [windows-registry-node](https://github.com/CatalystCode/windows-registry-node) - Access/modify the Windows registry and set file associations.

## Resources

- [Cross-platform Node.js guide](https://github.com/ehmicky/cross-platform-node-guide) - How to write cross-platform Node.js code.
- [Microsoft Node.js Guidelines](https://github.com/Microsoft/nodejs-guidelines) - Tips, tricks, and resources for working with Node.js on Microsoft platforms.
- [Cross-platform terminal characters](https://github.com/ehmicky/cross-platform-terminal-characters) - All the characters that work on most terminals and most operating systems.

## See also

- [awesome-desktop-js](https://github.com/styfle/awesome-desktop-js) - List of tools to build JavaScript applications on the desktop.

## Known issues

- [exec() behavior between shells](https://github.com/isaacs/spawn-wrap) - Depending on the shell being used, e.g., bash vs. dash, `child_process.exec()` has inconsistent exit behavior.
