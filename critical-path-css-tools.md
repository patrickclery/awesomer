# critical-path-css-tools

Tools to prioritize above-the-fold (critical-path) CSS

## Bookmarklets/Extensions

- [CSSVacuum](https://github.com/ndreckshage/CSSVacuum)

## Grunt tasks

- [grunt-critical](https://github.com/bezoerb/grunt-critical)
- [grunt-critical-css](https://github.com/filamentgroup/grunt-criticalcss)
- [grunt-penthouse](https://github.com/fatso83/grunt-penthouse)

## Inline sources (styles, scripts)

- [gulp-inline-source](https://github.com/fmal/gulp-inline-source) - by Filip Malinowski, replaces `<link>` tags with inline `<style>` tags, and replaces `<script src="">` tags with their inline content
- [inline-critical](https://github.com/bezoerb/inline-critical) - by Ben Zörb, inline critical path CSS and load existing stylesheets with `loadCSS`
- [inline-styles](https://github.com/maxogden/inline-styles) - by Max Ogden, replaces `<link>` tags with inline `<style>` tags + inlines CSS url() calls with data URIs
- [isomorphic-style-loader](https://github.com/kriasoft/isomorphic-style-loader)

## PhantomJS

- [dr-css-inliner](https://github.com/drdk/dr-css-inliner) - PhantomJS script to inline above-the-fold CSS on a page.

## CasperJS

- [critical-css-casperjs](https://github.com/ibrennan/critical-css-casperjs) - CasperJS script to pull critical CSS information from pages

## Render-blocking issues detection

- [PSI](https://github.com/addyosmani/psi) - Node module for PageSpeed Insights reporting as part of your build process. Use directly with Gulp or use [grunt-pagespeed](https://github.com/jrcryer/grunt-pagespeed) if a Grunt user. For local testing, a write-up using this task and [ngrok](http://www.jamescryer.com/2014/06/12/grunt-pagespeed-and-ngrok-locally-testing/) is available.

## Server-side modules

- [mod_pagespeed](https://github.com/pagespeed/mod_pagespeed) - Apache module for automatic PageSpeed optimization
- [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed) - Nginx module for automatic PageSpeed optimization

## Async load CSS

- [asyncLoader](https://github.com/n0mad01/asyncLoader) - async script/stylesheet loader
- [loadCSS](https://github.com/filamentgroup/loadCSS) - loads CSS asynchronously using JS. [Research](https://gist.github.com/scottjehl/87176715419617ae6994) that led to this is also available.

## Supplementary tools

- [UnCSS](https://github.com/giakki/uncss)

## Node modules

- [Critical](https://github.com/addyosmani/critical) - by Addy Osmani generates & inlines critical-path CSS (uses Penthouse, [Oust](https://github.com/addyosmani/oust) and inline-styles)
- [CriticalCSS](https://github.com/filamentgroup/criticalcss) - by FilamentGroup finds & outputs critical CSS
- [Penthouse](https://github.com/pocketjoso/penthouse) - by Jonas Ohlsson generates critical-path CSS
