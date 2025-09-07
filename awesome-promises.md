# awesome-promises

A curated list of useful resources for JavaScript Promises

## Resources, Blogs, and Books

- [Promise Cookbook](https://github.com/mattdesl/promise-cookbook) - The why, what, and how. "A brief introduction [...] primarily aimed at frontend developers".
- [Promise it won't hurt](https://github.com/stevekane/promise-it-wont-hurt) - An interactive [nodeschool](https://nodeschool.io/) workshop
- [Promise Fun](https://github.com/sindresorhus/promise-fun) - @sindresorhus's notes, patterns, and solutions to common Promise problems

## Convenience Utilities

- [p-filter](https://github.com/sindresorhus/p-filter) - Filter promises concurrently
- [delay](https://github.com/sindresorhus/delay) - Delay a promise a specified amount of time.
- [pify](https://github.com/sindresorhus/pify) - Promisify ("denodify") a callback-style function.
- [loud-rejection](https://github.com/sindresorhus/loud-rejection) - Make unhandled promise rejections fail loudly instead of the default silent fail.
- [hard-rejection](https://github.com/sindresorhus/hard-rejection) - Make unhandled promise rejections fail hard right away instead of the default silent fail
- [p-queue](https://github.com/sindresorhus/p-queue) - Promise queue with concurrency control
- [p-break](https://github.com/sindresorhus/p-break) - Break out of a promise chain
- [p-lazy](https://github.com/sindresorhus/p-lazy) - Create a lazy promise that defers execution until `.then()` or `.catch()` is called
- [p-defer](https://github.com/sindresorhus/p-defer) - Create a deferred promise
- [p-if](https://github.com/sindresorhus/p-if) - Conditional promise chains
- [p-tap](https://github.com/sindresorhus/p-tap) - Tap into a promise chain without affecting its value or state
- [p-map](https://github.com/sindresorhus/p-map) - Map over promises concurrently
- [p-all](https://github.com/sindresorhus/p-all) - Run promise-returning & async functions concurrently with optional limited concurrency
- [p-limit](https://github.com/sindresorhus/p-limit) - Run multiple promise-returning & async functions with limited concurrency
- [p-times](https://github.com/sindresorhus/p-times) - Run promise-returning & async functions a specific number of times concurrently
- [p-catch-if](https://github.com/sindresorhus/p-catch-if) - Conditional promise catch handler
- [p-time](https://github.com/sindresorhus/p-time) - Measure the time a promise takes to resolve
- [p-log](https://github.com/sindresorhus/p-log) - Log the value/error of a promise
- [p-settle](https://github.com/sindresorhus/p-settle) - Settle promises concurrently and get their fulfillment value or rejection reason
- [p-memoize](https://github.com/sindresorhus/p-memoize) - Memoize promise-returning & async functions
- [p-whilst](https://github.com/sindresorhus/p-whilst) - Calls a function repeatedly while a condition returns true and then resolves the promise
- [p-throttle](https://github.com/sindresorhus/p-throttle) - Throttle promise-returning & async functions
- [p-debounce](https://github.com/sindresorhus/p-debounce) - Debounce promise-returning & async functions
- [p-retry](https://github.com/sindresorhus/p-retry) - Retry a promise-returning or async function
- [p-wait-for](https://github.com/sindresorhus/p-wait-for) - Wait for a condition to be true
- [p-timeout](https://github.com/sindresorhus/p-timeout) - Timeout a promise after a specified amount of time
- [p-race](https://github.com/sindresorhus/p-race) - A better `Promise.race()`
- [p-try](https://github.com/sindresorhus/p-try) - `Promise#try()` ponyfill - Starts a promise chain
- [p-finally](https://github.com/sindresorhus/p-finally) - `Promise#finally()` ponyfill - Invoked when the promise is settled regardless of outcome
- [p-any](https://github.com/sindresorhus/p-any) - Wait for any promise to be fulfilled
- [p-some](https://github.com/sindresorhus/p-some) - Wait for a specified number of promises to be fulfilled
- [p-pipe](https://github.com/sindresorhus/p-pipe) - Compose promise-returning & async functions into a reusable pipeline
- [p-each-series](https://github.com/sindresorhus/p-each-series) - Iterate over promises serially
- [p-map-series](https://github.com/sindresorhus/p-map-series) - Map over promises serially
- [p-reduce](https://github.com/sindresorhus/p-reduce) - Reduce a list of values using promises into a promise for a value
- [p-props](https://github.com/sindresorhus/p-props) - Like `Promise.all()` but for `Map` and `Object`
- [promise-method](https://github.com/wbinnssmith/promise-method) - Standalone `bluebird.method`. Turn a synchronously-returning method into a promise-returning one.
- [is-promise](https://github.com/then/is-promise) - Determine if something looks like a Promise.
- [sprom](https://github.com/then/sprom) - Resolve when a stream ends. Optional buffering (be careful with this!)
- [task.js](https://github.com/mozilla/task.js) - Write async functions in a blocking style using promises and generators. Like `bluebird.coroutine`.
- [co](https://github.com/tj/co) - Like `task.js` and `bluebird.coroutine`, but supports thunks too.
- [promise-do-until](https://github.com/busterc/promise-do-until) - Calls a function repeatedly until a condition returns true and then resolves the promise.
- [promise-do-whilst](https://github.com/busterc/promise-do-whilst) - Calls a function repeatedly while a condition returns true and then resolves the promise.
- [promise-semaphore](https://github.com/samccone/promise-semaphore) - Push a set of work to be done in a configurable serial fashion
- [promise-nodeify](https://github.com/kevinoid/promise-nodeify) - Standalone `nodeify` method which calls a Node-style callback on resolution or rejection. Licensed under the [Creative Commons CC0 License](https://creativecommons.org/publicdomain/zero/1.0/).

## Promises/A+ Implementations (ES6/ES2015 compatible)

- [pinkie](https://github.com/floatdrop/pinkie) - Ponyfill. Node-oriented, but [browserifyable](https://github.com/substack/node-browserify). *Extremely* small implementation.
- [native-promise-only](https://github.com/getify/native-promise-only) - Polyfill. Browser and node-compatible.
- [es6-promise](https://github.com/stefanpenner/es6-promise) - Opt-in polyfill. A strict-spec subset of rsvp.js.
- [lie](https://github.com/calvinmetcalf/lie) - Small, browserifyable with an opt-in polyfill. All of these provide more features than the language yet remain compatible. Node + Browsers for all.
- [bluebird](https://github.com/petkaantonov/bluebird) - Fully featured, extremely performant. Long stack traces & generator/coroutine support.
- [creed](https://github.com/briancavalier/creed) - Hyper performant & full featured like Bluebird, but FP-oriented. Coroutines, generators, promises, ES2015 iterables, & fantasy-land spec.
- [rsvp.js](https://github.com/tildeio/rsvp.js) - Lightweight with a few extras. Compatible down to IE6!
- [Q](https://github.com/kriskowal/q) - One of the original implementations. Long stack traces and other goodies.
- [then/promise](https://github.com/then/promise) - Small with `nodeify`, `denodify` and `done()` additions.
- [when.js](https://github.com/cujojs/when) - Packed with control flow, functional, and utility methods.
- [pinkie-promise](https://github.com/floatdrop/pinkie-promise) - Use native, or fall back to `pinkie`. Great for node library authors.
- [any-promise](https://github.com/kevinbeaty/any-promise) - Loads the first available implementation. Safe for browserify.
