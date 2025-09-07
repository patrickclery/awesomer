# StumbleUponAwesome

⚡️A browser extension that takes you to a random site from one of the awesome curated lists. Like good ol' StumbleUpon, for developers, tech & science lovers.

## How to use it:

- [sindresorhus/awesome](https://github.com/sindresorhus/awesome) - It's completely local - you can find it under [/extension/data](./extension/data). It's generated with [awesome_scraper.py](./scraper/awesome_scraper.py). To make sure that every link works and is relevant, the dataset is cleaned. Any dead or broken links are removed, as well as links to CI pipelines, recursive links, donation links, etc. This is done with the cleanup functions in [utils.py](./scraper/utils.py). Running this script can take a few hours on a slow connection. After removing from the dataset, a record of dead or broken links (those with 404, SSL, other server errors) is saved in [these text files](./extension/data/broken-urls) after every scrape. ❗️If you are one of the awesome list maintainers, find the **[ text file for your awesome-list](./extension/data/broken-urls)** to check for dead links and remove them from your list, or update with a valid URL. If the file is empty, all good! [☝️Submit an issue](https://github.com/basharovV/StumbleUponAwesome/issues/new) [🤘Submit a PR](https://github.com/basharovV/StumbleUponAwesome/pulls) ✨ Stay curious!
