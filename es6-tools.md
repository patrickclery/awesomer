# es6-tools

An aggregation of tooling for using ES6 today

## Transpilers

- [Babel](https://github.com/babel/babel) - Turn ES6+ code into vanilla ES5 with no runtime
- [Traceur compiler](https://github.com/google/traceur-compiler) - ES6 features > ES5. Includes classes, generators, promises, destructuring patterns, default parameters & more.
- [es6ify](https://github.com/thlorenz/es6ify) - Traceur compiler wrapped as a [Browserify](http://browserify.org/) v2 transform
- [babelify](https://github.com/babel/babelify) - Babel transpiler wrapped as a [Browserify](http://browserify.org/) transform
- [es6-transpiler](https://github.com/termi/es6-transpiler) - ES6 > ES5. Includes classes, destructuring, default parameters, spread
- [defs](https://github.com/olov/defs) - ES6 block-scoped const and let variables to ES3 vars
- [es6_module_transpiler-rails](https://github.com/DavyJonesLocker/es6_module_transpiler-rails) - ES6 Modules in the Rails Asset Pipeline
- [Some Sweet.js macros](https://github.com/jlongster/es6-macros)
- [regexpu](https://github.com/mathiasbynens/regexpu)
- [Lebab](https://github.com/mohebifar/lebab) - Transformations for ES5 code to ES6 (approximates)

## Build-time transpilation

- [grunt-microlib](https://github.com/thomasboyt/grunt-microlib) - tools for libs using ES6 module transpiler (sample [Gruntfile](https://github.com/jakearchibald/es6-promise/blob/c3336087fffc52e66cf5398e5b56b23a291080fc/Gruntfile.js))
- [grunt-defs](https://github.com/EE/grunt-defs) - ES6 block scoped const and let variables, to ES3

## Mocha plugins

- [Mocha Traceur](https://github.com/domenic/mocha-traceur) - A simple plugin for Mocha to pass JS files through the Traceur compiler

## Polyfills

- [core-js](https://github.com/zloirock/core-js) - Modular and compact polyfills for ES6 including Symbols, Map, Set, Iterators, Promises, setImmediate, Array generics, etc. The standard library used by [Babel](https://github.com/babel/babel).
- [es6-shim](https://github.com/paulmillr/es6-shim) - almost all new ES6 methods — from Map, Set, String, Array, Object, Object.is and more.
- [WeakMap, Map, Set, HashMap - ES6 Collections](https://github.com/Benvie/harmony-collections)
- [`String.prototype.startsWith`](https://github.com/mathiasbynens/String.prototype.startsWith)
- [`String.prototype.endsWith`](https://github.com/mathiasbynens/String.prototype.endsWith)
- [`String.prototype.at`](https://github.com/mathiasbynens/String.prototype.at)
- [`String.prototype.repeat`](https://github.com/mathiasbynens/String.prototype.repeat)
- [`String.prototype.includes`](https://github.com/mathiasbynens/String.prototype.includes)
- [`String.prototype.codePointAt`](https://github.com/mathiasbynens/String.prototype.codePointAt)
- [`String.fromCodePoint`](https://github.com/mathiasbynens/String.fromCodePoint)
- [`Array.prototype.find`](https://github.com/paulmillr/Array.prototype.find)
- [`Array.prototype.findIndex`](https://github.com/paulmillr/Array.prototype.findIndex)
- [`Array.from`](https://github.com/mathiasbynens/Array.from)
- [`Array.of`](https://github.com/mathiasbynens/Array.of)
- [`Object.assign`](https://github.com/sindresorhus/object-assign)
- [`Number.isFinite`](https://github.com/sindresorhus/is-finite)
- [`Math.sign`](https://github.com/sindresorhus/math-sign)
- [`RegExp.prototype.match`](https://github.com/mathiasbynens/RegExp.prototype.match)
- [`RegExp.prototype.search`](https://github.com/mathiasbynens/RegExp.prototype.search)
- [es6-promise](https://github.com/jakearchibald/es6-promise) - polyfill for Promises matching the ES6 API
- [ES6 Map Shim](https://github.com/eriwen/es6-map-shim) - destructive shim that follows the latest specification as closely as possible.
- [`Function.create`](https://github.com/walling/Function.create.js)
- [ES6 Symbol polyfill](https://github.com/medikoo/es6-symbol)
- [ES6 Map, Set, WeakMap](https://github.com/EliSnow/Blitz-Collections)
- [harmony-reflect](https://github.com/tvcutsem/harmony-reflect) - ES6 [reflection module](http://wiki.ecmascript.org/doku.php?id=harmony:reflect_api) (contains the [Proxy API](http://soft.vub.ac.be/~tvcutsem/proxies/))

## Code generation

- [generator-node-esnext](https://github.com/briandipalma/generator-node-esnext) - Yeoman generator for Traceur apps
- [generator-es6-babel](https://github.com/HenriqueLimas/generator-es6-babel) - Yeoman generator for Babel apps
- [generator-gulp-babelify](https://github.com/HenriqueLimas/generator-gulp-babelify) - Yeoman generator for [Babel](https://babeljs.io/), [Browserify](http://browserify.org/) and [Gulp](http://gulpjs.com/)
- [Loom generators with ES6 ember modules](https://github.com/ryanflorence/loom-generators-ember)

## Boilerplates

- [es6-boilerplate](https://github.com/davidjnelson/es6-boilerplate) - Tooling to allow the community to use es6 now via traceur in conjunction with amd and browser global modules, with source maps, concatenation, minification, compression, and unit testing in real browsers.
- [es6-jspm-gulp-boilerplate](https://github.com/alexweber/es6-jspm-gulp-boilerplate) - Tooling to allow the community to use es6 now via babel in conjunction jspm, with source maps, concatenation, minification, compression, and unit testing in real browsers using es6.

## Module Loaders

- [js-loaders](https://github.com/jorendorff/js-loaders) - Mozilla's spec-compliant loader prototype
- [Babel Module Loader](https://github.com/babel/babel-loader)
- [beck.js](https://github.com/unscriptable/beck) - toolkit for ES6 Module Loader pipelines, shim for legacy environments

## Other

- [ES.next showcase](https://github.com/sindresorhus/esnext-showcase) - real-world usage examples of ES6 features
- [looper](https://github.com/wycats/looper) - static analysis tools for ES6
- [es-dependency-graph](https://github.com/yahoo/es-dependency-graph)
- [es6-import-validate](https://github.com/sproutsocial/es6-import-validate)
- [let-er](https://github.com/getify/let-er) - transpiles [let-block block-scoping](http://wiki.ecmascript.org/doku.php?id=proposals:block_expressions#let_statement) (not accepted into ES6) into either ES3 or ES6
- [Recast](https://github.com/benjamn/recast) - Esprima-based JavaScript syntax tree transformer, conservative pretty-printer, and automatic source map generator. Used by several of the transpilers listed above, including [regenerator](https://github.com/facebook/regenerator) and [es6-arrow-function](https://github.com/esnext/es6-arrow-function).
- [Paws on ES6](https://github.com/hemanth/paws-on-es6) - Minimalist examples of ES6 functionalities.
- [es6-translate](https://github.com/calvinmetcalf/es6-translate) - Uses the ES6 loader hooks to load (node flavored) commonjs packages in ES6.
- [Isparta](https://github.com/douglasduteil/isparta)
- [ES6 Lab setup](https://github.com/hemanth/es6-lab-setup) - A simple setup for transpiling ES6 to ES5 using `Babel` or `traceur` with `gulp` and `jasmine` support.

## Parsers

- [Acorn](https://github.com/ternjs/acorn) - A small, fast, JavaScript-based JavaScript parser with ES6 support, parses to [SpiderMonkey AST](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API) format.
- [esparse](https://github.com/zenparsing/esparse) - ES6 parser written in ES6.
- [Traceur compiler](https://github.com/google/traceur-compiler)

## Browser plugins

- [Scratch JS](https://github.com/richgilbank/Scratch-JS) - A Chrome/Opera DevTools extension to run ES6 on a page with either Babel or Traceur
- [generator-typescript](https://github.com/mrkev/generator-typescript) - Yeoman generator for TypeScript apps
