# awesome-cloudflare

⛅️ Curated list of awesome Cloudflare worker recipes, open-source projects, guides, blogs and other resources.

## Apps

- [App Ideas](https://github.com/cloudflare-apps/ideas)
- [Logflare](https://github.com/Logflare/cloudflare-app) - Log management & event analytics.
- [OpWork.dev](https://github.com/hisorange/opwork) - Self hosted CloudFlare workers management platform.

## Workers

- [Wrangler](https://github.com/cloudflare/wrangler) - `wrangler` is a CLI tool designed for folks who are interested in using Cloudflare workers.
- [Worker App Kit](https://github.com/postlight/cloudflare-worker-app-kit) - Handy set of tools for creating, developing, testing, and deploying worker app.
- [GitHub Action](https://github.com/cpilsworth/cloudflare-worker-action) - Deploy a worker on push to the master branch.
- [Workers KV Viewer](https://github.com/jroyal/cloudflare-workers-kv-viewer) - CLI based interactive viewer for workers KV storage.
- [Examples Collection](https://github.com/cloudflare/worker-examples) - Collection of recipes.
- [Hello World JS Boilerplate](https://github.com/cloudflare/worker-template) - Template for kick starting a worker project in JS.
- [Hello World Rust Boilerplate](https://github.com/cloudflare/rustwasm-worker-template) - Template for kick starting a worker project using wasm-pack.
- [Router](https://github.com/cloudflare/worker-template-router) - Router that can be used with REST APIs or apps for basic routing logic.
- [Static](https://github.com/cloudflare/worker-template-static) - Generate a static HTML or JSON page from raw strings in your workers script.
- [Fetch](https://github.com/cloudflare/worker-template-fetch) - Examples of making fetch requests and generating JSON post requests.
- [Incoming Request](https://github.com/ashleygwilliams/worker-template-requests) - Examples of reading in a POST request body of type JSON and form-data.
- [Redirect](https://github.com/cloudflare/worker-template-redirect) - Examples of sending single and bulk redirects from a Worker script.
- [Img-Color](https://github.com/xtuc/img-color-worker) - Retrieve the dominant color of a png or jpeg image.
- [Binast](https://github.com/xtuc/binast-cf-worker-template) - Serve binast via a worker.
- [Pwnage Protection](https://github.com/detroitenglish/pw-pwnage-cfworker) - Secure password scoring and user pwnage protection api - [Usage](https://community.cloudflare.com/t/estimate-strength-of-users-new-password-input-with-zxcvbn-and-query-haveibeenpwned-for-matches-against-known-hacked-accounts/26378).
- [URL Router](https://github.com/berstend/service-worker-router) - Fast url router - [Usage](https://community.cloudflare.com/t/open-source-fast-url-router-for-workers-js-typescript/33406).
- [Edge Proxy](https://github.com/DigitalOptimizationGroup/cloudflare-edge-proxy) - Enable A/B testing, canary releasing, gatekeeping, and SEO A/B/N testing.
- [Blue / Green Deployments](https://github.com/DigitalOptimizationGroup/blue-green-cloudflare-workers) - Working example of blue / green deployments with canary releasing.
- [Preact PWA](https://github.com/DigitalOptimizationGroup/cloudflare-worker-preact-pwa) - Preact progressive web app.
- [CURL Interceptor](https://github.com/Gaafar/curl-worker) - Intercepts requests from `curl` command and returns something different.
- [Worker with built-in Router](https://github.com/anderly/cloudflare-worker-routing) - Allows you to separate your worker logic into different functions and/or controllers.
- [Webpack Boilerplate](https://github.com/detroitenglish/cloudflare-workers-webpack-boilerplate) - Boilerplate to build, bundle and deploy workers with webpack.
- [Basic Auth](https://github.com/dommmel/cloudflare-workers-basic-auth) - Protection using basic auth.
- [Send Logs to Logdna](https://github.com/boynet/cf-logdna-worker) - Simple recipe to send logs to logdna.
- [IP lookup service](https://github.com/matthewgall/beta.ipinfo.in) - IP lookup service using workers.
- [Airtable Proxy](https://github.com/portable-cto/airtable-proxy-worker) - Allows you to make secure requests to the Airtable API from your frontend.
- [TypeScript Workers](https://github.com/udacity/cloudflare-typescript-workers) - Types and mocks for building a tested typescript worker.
- [Proxies](https://github.com/GitbookIO/proxies-on-cloudflare) - Makes it easy to build workers, by providing high-level proxying primitives addressing common needs.
- [Static Worker](https://github.com/manatarms/static-worker) - Provides functions that make it easy to host a static website.
- [Bannero](https://github.com/nondanee/bannero) - Bannero image API for simpledesktops.
- [Hasura](https://github.com/nathanwaters/hasura-cloudflare-worker) - Example using Facebook-based authorization and graphql proxy queries with hasura.
- [Repo Hunt](https://github.com/signalnerve/repo-hunt) - Find cool open-source projects daily.
- [Performance Optimized Workers](https://github.com/pmeenan/cf-workers) - Collection of worker scripts, generally focused on performance optimizations.
- [Google reCAPTCHA verification](https://github.com/HR/recaptcha-worker) - Handle the server-side verification of your reCAPTCHA form.
- [Cloudflare Workers Starter Kit](https://github.com/kriasoft/cloudflare-starter-kit) - - TypeScript template \w multiple CF Workers, `*.env` files, and local testing.

## DNS

- [DNS Zone Files](https://github.com/irazasyed/dns-zone-files) - Ready to import common config zone files for easy configuration of various services.
- [Lexicon](https://github.com/AnalogJ/lexicon) - CLI tool to manipulate DNS records on various DNS providers in a standardized way.
- [Th3inspector](https://github.com/Moham3dRiahi/Th3inspector) - All in one CLI tool for information gathering.
- [Partner Panel](https://github.com/ZE3kr/Cloudflare-CNAME-Setup) - Tool for hosting partners to provide a DNS management panel for customers.
- [CFPMP](https://github.com/Netrvin/CFPMP) - Partner management panel.
- [Flares](https://github.com/lfaoro/flares) - DNS backup tool.
- [Block Bad Bot Ruleset](https://github.com/SukkaW/cloudflare-block-bad-bot-ruleset) - Collection of rulesets to block malicious crawlers with firewall rules.
- [Docker DDNS](https://github.com/oznu/docker-cloudflare-ddns) - Docker image to use the free DNS Service as a dynamic DNS provider.
- [DDNS script for Synology](https://github.com/joshuaavalon/SynologyCloudflareDDNS) - DDNS script for Synology NAS.
- [Dynamic DNS Bash](https://github.com/yulewang/cloudflare-api-v4-ddns) - Dynamic DNS updater in bash script.
- [Dynamic DNS PHP](https://github.com/lyoshenka/cloudflare-ddns) - Dynamic DNS updater in PHP.
- [Dynamic DNS Python](https://github.com/adrienbrignon/cloudflare-ddns) - Dynamic DNS updater in python.
- [Multi-Provider DDNS Script](https://github.com/phuslu/ddns) - Multiple providers ddns script without dependencies.
- [Argo Tunnel Client](https://github.com/cloudflare/cloudflared) - CLI client for Argo tunnel, a tunneling daemon that proxies any local webserver through the Cloudflare network.
- [Upper](https://github.com/ostark/upper) - Speeds up craft dramatically using a cache proxy in front of your webserver.
- [Cloud Buster](https://github.com/SageHack/cloud-buster) - A comprehensive pentest tool that checks sites for origin IP leaks.
- [CLI Tool](https://github.com/danielpigott/cloudflare-cli) - CLI tool for interacting with Cloudflare.
- [Detector](https://github.com/k4m4/cloudflare-detect) - Detect whether a site is running behind Cloudflare.
- [Scrape](https://github.com/Anorov/cloudflare-scrape) - Python module to bypass anti-bot page.
- [CloudFlair](https://github.com/christophetd/CloudFlair) - Tool to find origin servers of websites protected by CloudFlare who are publicly exposed.

## Community

- [GitHub Topic](https://github.com/topics/cloudflare)
