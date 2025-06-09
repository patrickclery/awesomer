## UI Frameworks

| Name                                                    | Description                                                                                                                                                                                                                              | Stars | Last Commit |
|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [preact](https://github.com/preactjs/preact)            | React-like API (pre-hooks). Cool ecosystem of similarly tiny tools and components. Highly recommended. <br>The following libraries are small and cool, but note they're about Kudos for deconstrucing the very essence of a "framework": | 37667 | 2025-06-07  |
| [hyperapp](https://github.com/jorgebucaran/hyperapp)    | vDOM framework with pure JS syntax and immutable state                                                                                                                                                                                   | 19130 | 2025-03-20  |
| [van](https://github.com/vanjs-org/van)                 | vDOM-based framework optimized for no-build setups                                                                                                                                                                                       | 4096  | 2025-06-08  |
| [fre](https://github.com/frejs/fre)                     | React-like library with hooks and concurrency                                                                                                                                                                                            | 3743  | 2025-06-07  |
| [redom](https://github.com/redom/redom)                 | Hyperapp-style templates with _imperative_ event listeners and updates<br>Now, for the UI libraries:                                                                                                                                     | 3432  | 2025-03-10  |
| [arrowjs](https://github.com/justin-schroeder/arrow-js) | Tagged templates + reactive data<br>And if being declarative is not your thing:                                                                                                                                                          | 2494  | 2024-05-23  |
| [umbrella](https://github.com/franciscop/umbrella)      | jQuery-style DOM manipulation library                                                                                                                                                                                                    | 2326  | 2024-10-02  |
| [superfine](https://github.com/jorgebucaran/superfine)  | Hyperapp with state &amp; effect hooks removed                                                                                                                                                                                           | 1595  | 2022-08-16  |

## Event Emitters

| Name                                             | Description                                     | Stars | Last Commit |
|--------------------------------------------------|-------------------------------------------------|-------|-------------|
| [mitt](https://github.com/developit/mitt)        | Plain event emitter that I use on most projects | 11342 | 2024-08-14  |
| [nanoevents](https://github.com/ai/nanoevents)   | Nicer unsubscribe API, but no `*` event         | 1571  | 2024-12-10  |
| [onfire.js](https://github.com/hustcc/onfire.js) | Also has `.once` method                         | 501   | 2019-04-22  |

## State Managers

| Name                                                   | Description                                                                                            | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------|-------------|
| [zustand](https://github.com/pmndrs/zustand)           | Simple stores with pleasant actions and selectors. Vanilla , React                                     | 52770 | 2025-06-08  |
| [nanostores](https://github.com/nanostores/nanostores) | Modular store with good tree-shaking support, vanilla, + React extra. Supports all the top frameworks. | 6225  | 2025-06-02  |
| [unistore](https://github.com/developit/unistore)      | Centralized store with actions, + React                                                                | 2853  | 2021-06-07  |
| [storeon](https://github.com/storeon/storeon)          | Minimal redux-styled store with lots of framework connectors, . React extra + Vue, Svelte, Angular.    | 1975  | 2024-12-10  |
| [teaful](https://github.com/teafuljs/teaful)           | Store with useState-like API, including React / preact connector.                                      | 713   | 2022-10-30  |
| [exome](https://github.com/marcisbee/exome)            | Atomic stores with lots of framework connectors, + React extra. Supports all the top frameworks.       | 274   | 2025-05-06  |

## Signals

| Name                                                   | Description                                                                                                                                                                                                    | Stars | Last Commit |
|--------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [@preact/signals](https://github.com/preactjs/signals) | The OG signals from preact core, with react integration.                                                                                                                                                       | 4094  | 2025-06-07  |
| [hyperactiv](https://github.com/elbywan/hyperactiv)    | 4 functions to make objects observable and listen to changes                                                                                                                                                   | 442   | 2024-09-27  |
| [usignal](https://github.com/WebReflection/usignal)    | A smaller signal implementation                                                                                                                                                                                | 248   | 2025-05-16  |
| [flimsy](https://github.com/fabiospampinato/flimsy)    | Signals from Solid (it _almost_ fit into UI frameworks category itself). Author warning: _it's probably buggy._ <br>Honorable mention: _could_ make it _if_ it had tree-shaking, but otherwise is around 7 kB. | 192   | 2024-02-07  |

## Reactive Programming

| Name                                                       | Description             | Stars | Last Commit |
|------------------------------------------------------------|-------------------------|-------|-------------|
| [callbag-basics](https://github.com/staltz/callbag-basics) | Rx-style event streams  | 1656  | 2023-04-20  |
| [flyd](https://github.com/paldepind/flyd)                  | Rx-styled event streams | 1564  | 2024-02-05  |

## Routers and URL Utils

| Name                                                       | Description                                                                                                   | Stars | Last Commit |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-------|-------------|
| [wouter](https://github.com/molefrog/wouter)               | Declarative router for React / preact, also available as a standalone hook:                                   | 7293  | 2025-05-27  |
| [navaid](https://github.com/lukeed/navaid)                 | History-based observable router<br>Just want to parse or match URL paths without observing them? Here you go: | 793   | 2024-01-20  |
| [regexparam](https://github.com/lukeed/regexparam)         | Convert path to regexp in                                                                                     | 586   | 2023-12-03  |
| [qss](https://github.com/lukeed/qss)                       | Parse querystrings in . Not sure you need it, support is good.                                                | 453   | 2023-03-10  |
| [matchit](https://github.com/lukeed/matchit)               | Route parser and matcher in                                                                                   | 322   | 2021-11-03  |
| [@nanostores/router](https://github.com/nanostores/router) | Routes as a nanostores store (framework-agnostic)                                                             | 271   | 2025-04-10  |

## API Layer

| Name                                              | Description                                                                                              | Stars | Last Commit |
|---------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------|-------------|
| [unfetch](https://github.com/developit/unfetch)   | Loose fetch polyfill                                                                                     | 5720  | 2023-07-23  |
| [wretch](https://github.com/elbywan/wretch)       | Chainable API with error processing and lots of extra plugins                                            | 4977  | 2025-02-20  |
| [redaxios](https://github.com/developit/redaxios) | Drop-in axios replacement for modern browsers                                                            | 4824  | 2023-08-15  |
| [gretchen](https://github.com/truework/gretchen)  | Chainable API with type-safe errors<br>If for some reason you still need a fetch polyfill, try this one: | 331   | 2023-10-05  |

## I18N

| Name                                                   | Description                                                                                     | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [lingui](https://github.com/lingui/js-lingui)          | Small core with template strings                                                                | 5127  | 2025-06-09  |
| [rosetta](https://github.com/lukeed/rosetta)           | Bare-bones template strings (`{{hello}}, {{username}}`) and custom functions for everyting else | 795   | 2024-01-20  |
| [eo-locale](https://github.com/ibitcy/eo-locale)       | Interpolation and dates / numbers, or with react bindings.                                      | 347   | 2024-12-10  |
| [@nanostores/i18n](https://github.com/nanostores/i18n) | Detect locale, load dictionaries, format dates / numbers, including nanostores.                 | 243   | 2025-04-10  |

## Dates and Time

| Name                                                      | Description                                                                                                 | Stars | Last Commit |
|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|-------|-------------|
| [dayjs](https://github.com/iamkun/dayjs)                  | _Almost_ moment.js-compatible API, covers most use cases<br>And some more packages that only do formatting: | 47853 | 2025-05-20  |
| [date-fns](https://github.com/date-fns/date-fns)          | Not tiny as a whole, but are under 1 kB each (format and parse are quite heavy).                            | 35835 | 2024-09-23  |
| [timeago.js](https://github.com/hustcc/timeago.js)        | Format dates into stuff like _X minutes ago_ or _in X hours,_                                               | 5374  | 2024-07-24  |
| [ms](https://github.com/vercel/ms)                        | Parse &amp; format ms durations, e.g. `"1m" &lt;-&gt; 60000`                                                | 5279  | 2024-08-29  |
| [tinytime](https://github.com/aweary/tinytime)            | Simple date / time formatter: `{h}:{mm} -&gt; 9:33`                                                         | 1336  | 2023-01-12  |
| [tinydate](https://github.com/lukeed/tinydate)            | Date / time formatter, only supports padded numeric output (`September -&gt; 09`)                           | 1069  | 2024-01-20  |
| [fromnow](https://github.com/lukeed/fromnow)              | More of the same<br>Note that the built-in has decent support.                                              | 189   | 2019-07-08  |
| [time-stamp](https://github.com/jonschlinkert/time-stamp) | More of the same                                                                                            | 112   | 2020-11-24  |

## Generic Utilities

| Name                                             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Stars | Last Commit |
|--------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [just](https://github.com/angus-c/just)          | 82 helpers in separate packages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 6162  | 2024-02-11  |
| [remeda](https://github.com/remeda/remeda)       | 90 tree-shakable helpers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 4973  | 2025-06-08  |
| [rambda](https://github.com/selfrefactor/rambda) | 187 tree-shakable helpers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 1721  | 2025-05-30  |
| [@fxts/core](https://github.com/marpple/FxTS)    | 96 tree-shakable helpers. Lazy evaluation support.<br>Honorable mention: contains many sub-1 kB helpers. It does not tree-shake as well as the libraries above due to codebase structure.<br>Note: lodash itself is not tree-shakable, but has made many attempts at modulaity with `lodash.method` packages, imports from `lodash/method`, and `lodash-es`, none of which work well in practice.<br>Also note that much of the original lodash functionality comes built-in with modern ES. Prefer native versions over libraries as your browser target allows. | 1113  | 2025-05-21  |

## Validation

| Name                                                         | Description                                                                                             | Stars | Last Commit |
|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [valibot](https://github.com/fabian-hiller/valibot)          | Another modular validation library                                                                      | 7624  | 2025-06-01  |
| [superstruct](https://github.com/ianstormtaylor/superstruct) | The most popular modular validation library with good tree-shaking                                      | 7120  | 2024-10-01  |
| [v8n](https://github.com/imbrn/v8n)                          | zod-style API with fine-grained checks: `v8n.string.minLength(5).first("H").last("o")`. No tree shaking | 4169  | 2025-01-01  |
| [deep-waters](https://github.com/antonioru/deep-waters)      | Composable functional validators, .                                                                     | 201   | 2023-01-06  |
| [banditypes](https://github.com/thoughtspile/banditypes)     | The smallest validation library:                                                                        | 175   | 2025-01-02  |

## Unique ID Generation

| Name                                           | Description                     | Stars | Last Commit |
|------------------------------------------------|---------------------------------|-------|-------------|
| [nanoid](https://github.com/ai/nanoid)         | Random IDs with larger alphabet | 25704 | 2025-04-30  |
| [uid](https://github.com/lukeed/uid)           | More of the same                | 662   | 2024-09-27  |
| [@lukeed/uuid](https://github.com/lukeed/uuid) | Real UUIDs                      | 407   | 2024-09-27  |
| [hexoid](https://github.com/lukeed/hexoid)     | Hexadecimal IDs                 | 200   | 2024-10-12  |

## Colors

| Name                                                        | Description                                                                                          | Stars | Last Commit |
|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------|-------|-------------|
| [randomcolor](https://github.com/davidmerfield/randomColor) | Attractive random colors with configuration.                                                         | 6113  | 2024-02-08  |
| [colord](https://github.com/omgovich/colord)                | Manipulate colors and convert between spaces, . Extra features come as plugins, 150b to 1.5 kB each. | 1766  | 2023-10-02  |
| [polychrome](https://github.com/cdonohue/polychrome)        | More of the same                                                                                     | 289   | 2018-02-11  |
| [colr](https://github.com/stayradiated/colr)                | More of the same                                                                                     | 105   | 2020-05-07  |

## Touch Gestures

| Name                                                                   | Description                                                                                                                                                                                                                                                                                                                                                                                      | Stars | Last Commit |
|------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [alloyfinger](https://github.com/AlloyTeam/AlloyFinger)                | Pan, swipe, tap, doubletap, longpress, _and_ pinch / rotate. My personal favorite. .                                                                                                                                                                                                                                                                                                             | 3439  | 2019-01-03  |
| [detect-it](https://github.com/rafgraph/detect-it)                     | Detect present and primary input method (touch / mouse) and supported events<br>Honorable mentions: attempts a modular approach to gesture detection, but the core is around 2 kB without any gesture recognizers. used in ant design system, could be the only react component on the list, but babel-runtime / corejs polyfills hard-wired into the build push the ~2.5 kB size to over 10 kB. | 430   | 2021-05-02  |
| [tinygesture](https://github.com/sciactive/tinygesture)                | Configurable pan, swipe, tap, doubletap, longpress. .<br>Even if you want to detect gestures yourself, juggling mouse, touch and pointer events is hard enough, and browser inconsistencies don't help. Here are two more libraries to assist with that:                                                                                                                                         | 217   | 2023-12-03  |
| [pointer-tracker](https://github.com/GoogleChromeLabs/pointer-tracker) | Unified interface for mouse, touch and pointer events                                                                                                                                                                                                                                                                                                                                            | 190   | 2024-09-24  |

## Text Search

| Name                                                     | Description                                                                                                                                                                                                                             | Stars | Last Commit |
|----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [wade](https://github.com/kbrsh/wade)                    | Also similar                                                                                                                                                                                                                            | 2979  | 2023-05-13  |
| [js-search](https://github.com/bvaughn/js-search)        | Feature-rich and customizable: multi-field indices, stop words, custom stemmers and tokenizers.                                                                                                                                         | 2224  | 2023-05-12  |
| [libsearch](https://github.com/thesephist/libsearch)     | Index-free search (slower, but easier to use) with sane ordering <br>One way to find sensible inexact matches is _stemming_ — converting words to a root form. _Walked_ will match _walking,_ etc. Here are a few for English language: | 390   | 2022-07-21  |
| [ndx](https://github.com/localvoid/ndx)                  | Similar to js-search, differs in and is less strict for multi-word queries . Supports field weights.                                                                                                                                    | 157   | 2023-03-15  |
| [stemmer](https://github.com/words/stemmer)              |                                                                                                                                                                                                                                         | 132   | 2022-11-02  |
| [porter-stemmer](https://github.com/jedp/porter-stemmer) | For non-English words, I only have honorable mentions: is 17 kB with 15 languages, supports 30 languages but only works with the most promising one is but it depends on Node.js.                                                       | 100   | 2020-09-30  |

## Fuzzy search

| Name                                                          | Description                                                                                                                                                                                         | Stars | Last Commit |
|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [fuzzysearch](https://github.com/bevacqua/fuzzysearch)        | One string at a time, does not compute score / rank.                                                                                                                                                | 2727  | 2023-05-31  |
| [fuzzyset](https://github.com/Glench/fuzzyset.js)             | Find misspellings, e.g. missipissi -&gt; Missisipi, Commercial usage costs $42.                                                                                                                     | 1372  | 2021-12-13  |
| [fuzzy](https://github.com/mattyork/fuzzy)                    | Index-free, can highlight matches.                                                                                                                                                                  | 835   | 2021-12-20  |
| [liquidmetal](https://github.com/rmm5t/liquidmetal)           | Quicksilver algorithm, prioritizes matches at start of word for command abbreviations (e.g. `gp` -&gt; `git push`). One string at a time.                                                           | 295   | 2020-06-17  |
| [fuzzy-search](https://github.com/wouterrutgers/fuzzy-search) | With stateful index.                                                                                                                                                                                | 225   | 2023-03-14  |
| [quick-score](https://github.com/fwextensions/quick-score)    | Another quicksilver-based lib, tweaked for long strings. Built-in list filtering and sorting, or 1.2 kB for single-string scoring.<br>Finally, one library is specifically built for spellchecking: | 159   | 2023-01-08  |
| [fzy.js](https://github.com/jhawthorn/fzy.js)                 | Matches one string at a time, tree-shakeable scores and match highlighting. total, or ~150 bytes for `hasMatch` only.                                                                               | 156   | 2024-09-24  |
