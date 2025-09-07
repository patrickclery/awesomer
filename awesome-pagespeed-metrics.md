# awesome-pagespeed-metrics

⚡Metrics to help understand page speed and user experience

## Network metrics

- [Which third party scripts are most excessive](https://github.com/patrickhulce/third-party-web)

## Interactivity metrics

- [Polyfill - FID](https://github.com/GoogleChromeLabs/first-input-delay) - The maximum potential [First Input Delay](#first-input-delay-fid) that your users could experience. Basically equals to the duration of the longest [long task](#long-tasks) on the browser Main Thread.

## Concepts

- [Web Vitals](https://github.com/GoogleChrome/web-vitals) - Open Source Library to collect Field Data.

## Rendering metrics

- [Spec - LCP - W3C](https://github.com/WICG/largest-contentful-paint) - A layout shift occurs any time a visible element changes its position from one frame to the next. CLS measures the sum total of all individual layout shift scores for every unexpected layout shift that occurs during the entire lifespan of the page.
- [Spec - Layout Instability API - W3C](https://github.com/WICG/layout-instability) - The Visually Complete is the time from the start of the initial navigation until the **visible (above the fold) part of your page is no longer changing**. (e.g. WPT measures this using a color histogram of the page based on video/screenshots recording).
