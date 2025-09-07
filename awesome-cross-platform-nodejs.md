# awesome-cross-platform-nodejs

:two_men_holding_hands: A curated list of awesome developer tools for writing cross-platform Node.js code

## Applications

- [Github Action](https://github.com/features/actions) - Windows/macOS/Linux. GitHub Actions makes it easy to automate all your software workflows.
- [ievms](https://github.com/amichaelparker/ievms) - Automated installer for the free virtual machine images that Microsoft provides for testing on multiple versions of IE. These images can be useful for cross-platform testing various technologies, however make sure you read and understand Microsofts' licensing.
- [npm-windows-upgrade](https://github.com/felixrieseberg/npm-windows-upgrade) - Upgrade npm on Windows.
- [nvm](https://github.com/creationix/nvm)
- [nvm-windows](https://github.com/coreybutler/nvm-windows) - Manage multiple installations of Node.js on a Windows computer.
- [Redis](https://github.com/tporadowski/redis) - Native port of Redis for Windows.
- [windows-build-tools](https://github.com/felixrieseberg/windows-build-tools) - Install C++ Build Tools for Windows using npm.

## Libraries

- [any-path](https://github.com/bcoe/any-path) - Use Windows and POSIX paths interchangeably when fetching values from an object.
- [chokidar](https://github.com/paulmillr/chokidar) - Improved cross-platform file watching.
- [clipboardy](https://github.com/sindresorhus/clipboardy)
- [cpy](https://github.com/sindresorhus/cpy) - Copy files. Cross-platform.
- [cross-env](https://github.com/kentcdodds/cross-env) - Set environment variables cross-platform.
- [cross-spawn](https://github.com/IndigoUnited/node-cross-spawn) - Cross-platform implementation of `child_process.spawn()`.
- [dev-null-cli](https://github.com/sindresorhus/dev-null-cli) - Cross-platform `/dev/null`.
- [execa](https://github.com/sindresorhus/execa) - Cross-platform implementation of `child_process.{execFile,exec}`.
- [figures](https://github.com/sindresorhus/figures) - Unicode symbols with Windows fallbacks.
- [fkill](https://github.com/sindresorhus/fkill) - Kill processes. Cross-platform.
- [fs-extra](https://github.com/jprichardson/node-fs-extra) - Combines `graceful-fs` with better JSON file reading and promises.
- [getos](https://github.com/retrohacker/getos) - Retrieve the current OS, including Linux distribution.
- [global-cache-dir](https://github.com/ehmicky/global-cache-dir) - Get the global OS-specific cache directory.
- [graceful-fs](https://github.com/isaacs/node-graceful-fs) - Improves the `fs` module, especially on Windows.
- [gulp-execa](https://github.com/ehmicky/gulp-execa) - Cross-platform command execution in Gulp.js.
- [human-signals](https://github.com/ehmicky/human-signals) - Human-friendly process signals.
- [is-elevated](https://github.com/sindresorhus/is-elevated) - Check if the process is running with elevated privileges.
- [is-windows](https://github.com/jonschlinkert/is-windows) - Detect whether the current platform is Windows.
- [is-wsl](https://github.com/sindresorhus/is-wsl) - Detect whether current platform is WSL (Windows Subsystem for Linux).
- [log-symbols](https://github.com/sindresorhus/log-symbols) - Colored symbols for various log levels with Windows fallbacks.
- [make-dir](https://github.com/sindresorhus/make-dir) - Cross-platform `mkdir -p`.
- [node-notifier](https://github.com/mikaelbr/node-notifier) - Cross-platform desktop notifications.
- [node-windows](https://github.com/coreybutler/node-windows) - Windows support for Node.js scripts (daemons, eventlog, UAC, etc).
- [node-winreg](https://github.com/fresc81/node-winreg) - Access the Windows registry.
- [noop-stream](https://github.com/sindresorhus/noop-stream) - Cross-platform `fs.createReadStream('/dev/null')`.
- [open](https://github.com/sindresorhus/open) - Opens stuff like websites, files, executables. Cross-platform.
- [os-name](https://github.com/sindresorhus/os-name) - Get the name of the current operating system.
- [osenv](https://github.com/npm/osenv) - Cross-platform environment variables.
- [process-exists](https://github.com/sindresorhus/process-exists) - Check if a process exists.
- [ps-list](https://github.com/sindresorhus/ps-list) - Get running processes.
- [rage-edit](https://github.com/MikeKovarik/rage-edit) - Access/modify the Windows registry.
- [random-bytes-readable-stream](https://github.com/sindresorhus/random-bytes-readable-stream) - Cross-platform `fs.createReadStream('/dev/urandom')`.
- [readdirp](https://github.com/paulmillr/readdirp) - Recursive version of `fs.readdir()`.
- [rimraf](https://github.com/isaacs/rimraf)
- [shelljs](https://github.com/shelljs/shelljs) - Cross-platform Unix shell commands.
- [signal-exit](https://github.com/tapjs/signal-exit) - Cross-platform `exit` handler.
- [systeminformation](https://github.com/sebhildebrandt/systeminformation) - Hardware/software system information.
- [user-home](https://github.com/sindresorhus/user-home) - Get the path to the user home directory. Cross-platform.
- [username](https://github.com/sindresorhus/username) - Get the current username.
- [which](https://github.com/npm/node-which) - Cross-platform implementation of Unix's `which`.
- [windows-registry-node](https://github.com/CatalystCode/windows-registry-node) - Access/modify the Windows registry and set file associations.

## Resources

- [Cross-platform Node.js guide](https://github.com/ehmicky/cross-platform-node-guide) - How to write cross-platform Node.js code.
- [Cross-platform terminal characters](https://github.com/ehmicky/cross-platform-terminal-characters) - All the characters that work on most terminals and most operating systems.
- [Microsoft Node.js Guidelines](https://github.com/Microsoft/nodejs-guidelines) - Tips, tricks, and resources for working with Node.js on Microsoft platforms.

## See also

- [awesome-desktop-js](https://github.com/styfle/awesome-desktop-js) - List of tools to build JavaScript applications on the desktop.

## Known issues

- [exec() behavior between shells](https://github.com/isaacs/spawn-wrap) - Depending on the shell being used, e.g., bash vs. dash, `child_process.exec()` has inconsistent exit behavior.
