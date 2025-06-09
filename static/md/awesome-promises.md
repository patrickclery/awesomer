## For beginners

| Name                                                                       | Description                                                                                  | Stars  | Last Commit |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|--------|-------------|
| [You Don't Know JS: Promises](https://github.com/getify/You-Dont-Know-JS)  | Chapter from                                                                                 | 182272 | 2025-05-20  |
| [Promise Cookbook](https://github.com/mattdesl/promise-cookbook)           | The why, what, and how. "A brief introduction [...] primarily aimed at frontend developers". | 1619   | 2017-06-14  |
| [Promise it won't hurt](https://github.com/stevekane/promise-it-wont-hurt) | An interactive workshop                                                                      | 738    | 2021-04-21  |

## Deep Dive

| Name                                                              | Description                                                               | Stars | Last Commit |
|-------------------------------------------------------------------|---------------------------------------------------------------------------|-------|-------------|
| [Promise anti-patterns](https://github.com/petkaantonov/bluebird) | Common misuses and how to avoid them.                                     | 20504 | 2024-11-07  |
| [Promise Fun](https://github.com/sindresorhus/promise-fun)        | @sindresorhus's notes, patterns, and solutions to common Promise problems | 4945  | 2024-04-25  |

## References

| Name                                                               | Description                           | Stars | Last Commit |
|--------------------------------------------------------------------|---------------------------------------|-------|-------------|
| [Fates and States](https://github.com/domenic/promises-unwrapping) | Quick definitions of possible states. | 1248  | 2020-05-15  |

## Strict Implementations

| Name                                                                 | Description                                                      | Stars | Last Commit |
|----------------------------------------------------------------------|------------------------------------------------------------------|-------|-------------|
| [es6-promise](https://github.com/stefanpenner/es6-promise)           | Opt-in polyfill. A strict-spec subset of rsvp.js.                | 7292  | 2022-11-14  |
| [lie](https://github.com/calvinmetcalf/lie)                          | Small, browserifyable with an opt-in polyfill.                   | 746   | 2020-08-21  |
| [native-promise-only](https://github.com/getify/native-promise-only) | Polyfill. Browser and node-compatible.                           | 718   | 2019-10-27  |
| [pinkie](https://github.com/floatdrop/pinkie)                        | Ponyfill. Node-oriented, but . *Extremely* small implementation. | 139   | 2018-08-20  |

## Implementations with extras

| Name                                                 | Description                                                                                                                                       | Stars | Last Commit |
|------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [bluebird](https://github.com/petkaantonov/bluebird) | Fully featured, extremely performant. Long stack traces &amp; generator/coroutine support.                                                        | 20504 | 2024-11-07  |
| [Q](https://github.com/kriskowal/q)                  | One of the original implementations. Long stack traces and other goodies.                                                                         | 14974 | 2023-11-08  |
| [rsvp.js](https://github.com/tildeio/rsvp.js)        | Lightweight with a few extras. Compatible down to IE6!                                                                                            | 3604  | 2023-10-27  |
| [when.js](https://github.com/cujojs/when)            | Packed with control flow, functional, and utility methods.                                                                                        | 3435  | 2022-04-10  |
| [then/promise](https://github.com/then/promise)      | Small with `nodeify`, `denodify` and `done` additions.                                                                                            | 2590  | 2023-10-21  |
| [creed](https://github.com/briancavalier/creed)      | Hyper performant &amp; full featured like Bluebird, but FP-oriented. Coroutines, generators, promises, ES2015 iterables, &amp; fantasy-land spec. | 275   | 2018-05-29  |

## Fallbacks

| Name                                                          | Description                                                           | Stars | Last Commit |
|---------------------------------------------------------------|-----------------------------------------------------------------------|-------|-------------|
| [any-promise](https://github.com/kevinbeaty/any-promise)      | Loads the first available implementation. Safe for browserify.        | 181   | 2018-10-01  |
| [pinkie-promise](https://github.com/floatdrop/pinkie-promise) | Use native, or fall back to `pinkie`. Great for node library authors. | 117   | 2018-05-22  |

## sindresorhus's many Promise utilities ([see notes](https://github.com/sindresorhus/promise-fun))

| Name                                                             | Description                                                                                | Stars | Last Commit |
|------------------------------------------------------------------|--------------------------------------------------------------------------------------------|-------|-------------|
| [p-queue](https://github.com/sindresorhus/p-queue)               | Promise queue with concurrency control                                                     | 3715  | 2025-05-10  |
| [p-limit](https://github.com/sindresorhus/p-limit)               | Run multiple promise-returning &amp; async functions with limited concurrency              | 2366  | 2024-12-19  |
| [pify](https://github.com/sindresorhus/pify)                     | Promisify ("denodify") a callback-style function.                                          | 1507  | 2022-09-12  |
| [p-map](https://github.com/sindresorhus/p-map)                   | Map over promises concurrently                                                             | 1425  | 2024-12-05  |
| [p-retry](https://github.com/sindresorhus/p-retry)               | Retry a promise-returning or async function                                                | 878   | 2025-05-06  |
| [delay](https://github.com/sindresorhus/delay)                   | Delay a promise a specified amount of time.                                                | 616   | 2023-06-14  |
| [p-throttle](https://github.com/sindresorhus/p-throttle)         | Throttle promise-returning &amp; async functions                                           | 481   | 2024-11-30  |
| [p-memoize](https://github.com/sindresorhus/p-memoize)           | Memoize promise-returning &amp; async functions                                            | 407   | 2023-06-21  |
| [p-all](https://github.com/sindresorhus/p-all)                   | Run promise-returning &amp; async functions concurrently with optional limited concurrency | 336   | 2024-12-18  |
| [p-timeout](https://github.com/sindresorhus/p-timeout)           | Timeout a promise after a specified amount of time                                         | 290   | 2025-01-01  |
| [loud-rejection](https://github.com/sindresorhus/loud-rejection) | Make unhandled promise rejections fail loudly instead of the default silent fail.          | 280   | 2021-01-24  |
| [p-lazy](https://github.com/sindresorhus/p-lazy)                 | Create a lazy promise that defers execution until `.then` or `.catch` is called            | 274   | 2024-10-28  |
| [p-debounce](https://github.com/sindresorhus/p-debounce)         | Debounce promise-returning &amp; async functions                                           | 223   | 2024-04-14  |
| [p-props](https://github.com/sindresorhus/p-props)               | Like `Promise.all` but for `Map` and `Object`                                              | 197   | 2023-10-13  |
| [p-wait-for](https://github.com/sindresorhus/p-wait-for)         | Wait for a condition to be true                                                            | 159   | 2023-06-11  |
| [p-tap](https://github.com/sindresorhus/p-tap)                   | Tap into a promise chain without affecting its value or state                              | 132   | 2021-04-08  |
| [p-pipe](https://github.com/sindresorhus/p-pipe)                 | Compose promise-returning &amp; async functions into a reusable pipeline                   | 123   | 2021-04-08  |
| [hard-rejection](https://github.com/sindresorhus/hard-rejection) | Make unhandled promise rejections fail hard right away instead of the default silent fail  | 106   | 2022-07-08  |
| [p-settle](https://github.com/sindresorhus/p-settle)             | Settle promises concurrently and get their fulfillment value or rejection reason           | 91    | 2023-11-01  |
| [p-defer](https://github.com/sindresorhus/p-defer)               | Create a deferred promise                                                                  | 79    | 2024-04-01  |
| [p-filter](https://github.com/sindresorhus/p-filter)             | Filter promises concurrently                                                               | 76    | 2023-12-27  |
| [p-reduce](https://github.com/sindresorhus/p-reduce)             | Reduce a list of values using promises into a promise for a value                          | 70    | 2023-02-11  |
| [p-time](https://github.com/sindresorhus/p-time)                 | Measure the time a promise takes to resolve                                                | 70    | 2023-11-05  |
| [p-if](https://github.com/sindresorhus/p-if)                     | Conditional promise chains                                                                 | 61    | 2021-04-09  |
| [p-try](https://github.com/sindresorhus/p-try)                   | `Promise#try` ponyfill - Starts a promise chain                                            | 58    | 2021-10-04  |
| [p-whilst](https://github.com/sindresorhus/p-whilst)             | Calls a function repeatedly while a condition returns true and then resolves the promise   | 55    | 2024-10-16  |
| [p-any](https://github.com/sindresorhus/p-any)                   | Wait for any promise to be fulfilled                                                       | 54    | 2022-07-09  |
| [p-each-series](https://github.com/sindresorhus/p-each-series)   | Iterate over promises serially                                                             | 50    | 2022-07-08  |
| [p-map-series](https://github.com/sindresorhus/p-map-series)     | Map over promises serially                                                                 | 48    | 2021-04-09  |
| [p-race](https://github.com/sindresorhus/p-race)                 | A better `Promise.race`                                                                    | 46    | 2022-12-13  |
| [p-finally](https://github.com/sindresorhus/p-finally)           | `Promise#finally` ponyfill - Invoked when the promise is settled regardless of outcome     | 45    | 2021-04-09  |
| [p-times](https://github.com/sindresorhus/p-times)               | Run promise-returning &amp; async functions a specific number of times concurrently        | 39    | 2021-10-04  |
| [p-catch-if](https://github.com/sindresorhus/p-catch-if)         | Conditional promise catch handler                                                          | 38    | 2021-04-09  |
| [p-some](https://github.com/sindresorhus/p-some)                 | Wait for a specified number of promises to be fulfilled                                    | 36    | 2023-11-09  |
| [p-log](https://github.com/sindresorhus/p-log)                   | Log the value/error of a promise                                                           | 26    | 2021-04-09  |
| [p-break](https://github.com/sindresorhus/p-break)               | Break out of a promise chain                                                               | 23    | 2021-04-07  |

## Others

| Name                                                               | Description                                                                                         | Stars | Last Commit |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|-------|-------------|
| [co](https://github.com/tj/co)                                     | Like `task.js` and `bluebird.coroutine`, but supports thunks too.                                   | 11885 | 2020-12-15  |
| [task.js](https://github.com/mozilla/task.js)                      | Write async functions in a blocking style using promises and generators. Like `bluebird.coroutine`. | 1629  | 2019-03-28  |
| [is-promise](https://github.com/then/is-promise)                   | Determine if something looks like a Promise.                                                        | 280   | 2023-04-29  |
| [promise-semaphore](https://github.com/samccone/promise-semaphore) | Push a set of work to be done in a configurable serial fashion                                      | 28    | 2016-09-15  |
| [sprom](https://github.com/then/sprom)                             | Resolve when a stream ends. Optional buffering (be careful with this!)                              | 14    | 2017-11-16  |
| [promise-do-whilst](https://github.com/busterc/promise-do-whilst)  | Calls a function repeatedly while a condition returns true and then resolves the promise.           | 3     | 2018-08-25  |
| [promise-method](https://github.com/wbinnssmith/promise-method)    | Standalone `bluebird.method`. Turn a synchronously-returning method into a promise-returning one.   | 2     | 2023-12-15  |
| [promise-nodeify](https://github.com/kevinoid/promise-nodeify)     | Standalone `nodeify` method which calls a Node-style callback on resolution or rejection.           | 2     | 2024-12-03  |
| [promise-do-until](https://github.com/busterc/promise-do-until)    | Calls a function repeatedly until a condition returns true and then resolves the promise.           | 1     | 2018-08-25  |
