# awesome-password-cracking

A curated list of awesome tools, research, papers and other projects related to password cracking and password security.

## Specific file formats

- [bkcrack](https://github.com/kimci86/bkcrack) - Crack legacy zip encryption with Biham and Kocher's known plaintext attack.
- [frackzip](https://github.com/hyc/fcrackzip) - Small tool for cracking encrypted ZIP archives.
- [JKS private key cracker](https://github.com/floyd-fuh/JKS-private-key-cracker-hashcat) - Cracking passwords of private key entries in a JKS file.
- [pdfrip](https://github.com/mufeedvh/pdfrip) - A multi-threaded PDF password cracking utility equipped with commonly encountered password format builders and dictionary attacks.

## Hashcat

- [Autocrack](https://github.com/pry0cc/autocrack) - A set of client and server tools for automatically, and lightly automatically cracking hashes.
- [autocrack](https://github.com/timbo05sec/autocrack) - Hashcat wrapper to help automate the cracking process.
- [clem9669 rules](https://github.com/clem9669/hashcat-rule) - Rule for hashcat or john.
- [crackerjack](https://github.com/ctxis/crackerjack) - CrackerJack is a Web GUI for Hashcat developed in Python.
- [CrackLord](https://github.com/jmmcatee/cracklord) - Queue and resource system for cracking passwords.
- [CrackQ](https://github.com/f0cker/crackq) - A Python Hashcat cracking queue system.
- [docker-hashcat](https://github.com/dizcza/docker-hashcat) - Latest hashcat docker for Ubuntu 18.04 CUDA, OpenCL, and POCL.
- [duprule](https://github.com/mhasbini/duprule) - Detect & filter duplicate hashcat rules.
- [fitcrack](https://github.com/nesfit/fitcrack) - A hashcat-based distributed password cracking system.
- [Hashcat](https://github.com/hashcat/hashcat)
- [hashcat rules collection](https://github.com/narkopolo/hashcat-rules-collection) - Probably the largest collection of hashcat rules out there.
- [Hashcat-Stuffs](https://github.com/xfox64x/Hashcat-Stuffs) - Collection of hashcat lists and things.
- [hashcat-utils](https://github.com/hashcat/hashcat-utils) - Small utilities that are useful in advanced password cracking.
- [Hashfilter](https://github.com/bharshbarger/Hashfilter) - Read a hashcat potfile and parse different types into a sqlite database.
- [hashpass](https://github.com/dj-zombie/hashpass) - Hash cracking WebApp & Server for hashcat.
- [Hashstation](https://github.com/hashstation/hashstation) - Hashstation is a BOINC-based distributed password cracking system with a built-in web interface.
- [Hashtopolis](https://github.com/hashtopolis/server) - A multi-platform client-server tool for distributing hashcat tasks to multiple computers.
- [Hashview](https://github.com/hashview/hashview) - A web front-end for password cracking and analytics.
- [hat](https://github.com/sp00ks-git/hat) - An Automated Hashcat Tool for common wordlists and rules to speed up the process of cracking hashes during engagements.
- [hate_crack](https://github.com/trustedsec/hate_crack) - A tool for automating cracking methodologies through Hashcat from the TrustedSec team.
- [Hob0Rules](https://github.com/praetorian-inc/Hob0Rules) - Password cracking rules for Hashcat based on statistics and industry patterns.
- [Kaonashi](https://github.com/kaonashi-passwords/Kaonashi) - Wordlist, rules and masks from Kaonashi project (RootedCON 2019).
- [known_hosts-hashcat](https://github.com/chris408/known_hosts-hashcat) - A guide and tool for cracking ssh known_hosts files with hashcat.
- [Kraken](https://github.com/arcaneiceman/kraken) - A multi-platform distributed brute-force password cracking system.
- [Naive hashcat](https://github.com/brannondorsey/naive-hashcat) - Naive hashcat is a plug-and-play script that is pre-configured with naive, emperically-tested, "good enough" parameters/attack types.
- [nsa-rules](https://github.com/NSAKEY/nsa-rules) - Password cracking rules and masks for hashcat generated from cracked passwords.
- [nyxgeek-rules](https://github.com/nyxgeek/nyxgeek-rules) - Custom password cracking rules for Hashcat and John the Ripper.
- [OneRuleToRuleThemAll](https://github.com/NotSoSecure/password_cracking_rules) - "One rule to crack all passwords. or atleast we hope so."
- [OneRuleToRuleThemStill](https://github.com/stealthsploit/OneRuleToRuleThemStill) - "A revamped and updated version of my original OneRuleToRuleThemAll hashcat rule."
- [pantagrule](https://github.com/rarecoil/pantagrule) - Large hashcat rulesets generated from real-world compromised passwords.
- [pyhashcat](https://github.com/f0cker/pyhashcat) - Python C API binding to libhashcat.
- [ruleprocessorY](https://github.com/TheWorkingDeveloper/ruleprocessorY) - A next-gen Rule processor with complex multibyte character support built to support Hashcat.
- [Wavecrack](https://github.com/wavestone-cdt/wavecrack) - Wavestone's web interface for password cracking with hashcat.
- [WebHashCat](https://github.com/hegusung/WebHashcat) - WebHashcat is a very simple but efficient web interface for hashcat password cracking tool.

## Misc

- [Hashes](https://github.com/zefr0x/hashes) - Identify hashing algorithms (GUI frontend for Name That Hash).
- [hashgen](https://github.com/cyclone-github/hashgen) - Hashgen is a simple yet very fast CLI hash generator written in Go and cross compiled for Linux, Windows & Mac.
- [Name That Hash](https://github.com/HashPals/Name-That-Hash) - Don't know what type of hash it is? Name That Hash will name that hash type! Identify MD5, SHA256 and 300+ other hashes. Comes with a neat web app.

## John the Ripper

- [BitCracker](https://github.com/e-ago/bitcracker) - BitCracker is the first open source password cracking tool for memory units encrypted with BitLocker.
- [John the Ripper](https://github.com/openwall/john)
- [johnny](https://github.com/openwall/johnny) - GUI frontend to John the Ripper.

## Websites

- [gohashmob](https://github.com/n0kovo/gohashmob) - Go CLI app to quickly lookup hashes using the HashMob API.

## Conversion

- [7z2hashcat](https://github.com/philsmd/7z2hashcat) - Extract information from password-protected .7z archives (and .sfx files) such that you can crack these "hashes" with hashcat.
- [bitwarden2hashcat](https://github.com/0x6470/bitwarden2hashcat) - A tool that converts Bitwarden's data into a hashcat-suitable hash.
- [hc\_to\_7z](https://github.com/philsmd/hc_to_7z) - Convert 7-Zip hashcat hashes back to 7z archives.
- [hcxtools](https://github.com/ZerBea/hcxtools) - Portable solution for conversion of cap/pcap/pcapng (gz compressed) WiFi dump files to hashcat formats.
- [itunes_backup2hashcat](https://github.com/philsmd/itunes_backup2hashcat) - Extract the information needed from the Manifest.plist files to convert it to hashes compatible with hashcat.
- [MacinHash](https://github.com/jmagers/MacinHash) - Convert macOS plist password file to hash file for password crackers.
- [mongodb2hashcat](https://github.com/philsmd/mongodb2hashcat) - Extract hashes from the MongoDB database server to a hash format that hashcat accepts: -m 24100 (SCRAM-SHA-1) or -m 24200 (SCRAM-SHA-256).
- [NetNTLM-Hashcat](https://github.com/ins1gn1a/NetNTLM-Hashcat) - Converts John The Ripper/Cain format hashes (singular, or in bulk) to HashCat compatible hash format.
- [Rubeus-to-Hashcat](https://github.com/PwnDexter/Rubeus-to-Hashcat) - Converts / formats Rubeus kerberoasting output into hashcat readable format.
- [WINHELLO2hashcat](https://github.com/Banaanhangwagen/WINHELLO2hashcat) - With this tool one can extract the "hash" from a WINDOWS HELLO PIN. This hash can be cracked with Hashcat.

## Cloud

- [Cloud_crack](https://github.com/lordsaibat/Cloud_crack) - Crack passwords using Terraform and AWS.
- [Cloudcat](https://github.com/stormfleet/cloudcat) - A script to automate the creation of cloud infrastructure for hash cracking.
- [Cloudstomp](https://github.com/Fmstrat/cloudstomp) - Automated deployment of instances on EC2 via plugin for high CPU/GPU applications at the lowest price.
- [Cloudtopolis](https://github.com/JoelGMSec/Cloudtopolis) - A tool that facilitates the installation and provisioning of Hashtopolis on the Google Cloud Shell platform, quickly and completely unattended (and also, free!).
- [NPK](https://github.com/c6fc/npk) - NPK is a distributed hash-cracking platform built entirely of serverless components in AWS including Cognito, DynamoDB, and S3.
- [Penglab](https://github.com/mxrch/penglab) - Abuse of Google Colab for cracking hashes.
- [Rook](https://github.com/JumpsecLabs/Rook) - Automates the creation of AWS p3 instances for use in GPU-based password cracking.

## Artificial Intelligence

- [adams](https://github.com/TheAdamProject/adams) - Reducing Bias in Modeling Real-world Password Strength via Deep Learning and Dynamic Dictionaries.
- [neural network cracking](https://github.com/cupslab/neural_network_cracking) - Code for cracking passwords with neural networks.
- [PassGPT](https://github.com/javirandor/passgpt) - PassGPT is a GPT-2 model trained from scratch on password leaks.
- [RNN-Passwords](https://github.com/gehaxelt/RNN-Passwords) - Using the char-rnn to learn and guess passwords.
- [rulesfinder](https://github.com/synacktiv/rulesfinder) - This tool finds efficient password mangling rules (for John the Ripper or Hashcat) for a given dictionary and a list of passwords.

## Wordlist tools

- [accent_permutator](https://github.com/cyclone-github/accent_permutator) - A tool to transform characters from ASCII / UTF-8 to accented characters such as "o" to "ò".
- [anew](https://github.com/tomnomnom/anew) - Append lines from stdin to a file, but only if they don't already appear in the file. Outputs new lines to stdout too, making it a bit like a tee -a that removes duplicates.
- [bopscrk](https://github.com/r3nt0n/bopscrk) - Generate smart and powerful wordlists for targeted attacks. Includes song lyrics fetching and different transforms.
- [common-substr](https://github.com/sensepost/common-substr) - Simple tool to extract the most common substrings from an input text. Built for password cracking.
- [CUPP](https://github.com/Mebus/cupp) - A tool that lets you generate wordlists by user profiling data such as birthday, nickname, address, name of a pet or relative etc.
- [duplicut](https://github.com/nil0x42/duplicut) - Remove duplicates from MASSIVE wordlist, without sorting it (for dictionary-based password cracking).
- [Elpscrk](https://github.com/D4Vinci/elpscrk) - Elpscrk is like cupp, but it's based on permutations and statistics while being memory efficient.
- [Gorilla](https://github.com/d4rckh/gorilla) - Tool for generating wordlists or extending an existing one using mutations.
- [Gramify](https://github.com/TheWorkingDeveloper/gramify) - Create n-grams of wordlists based on words, characters, or charsets to use in offline password attacks and data analysis.
- [Graphcat](https://github.com/Orange-Cyberdefense/graphcat) - Generate graphs and charts based on password cracking result.
- [Keyboard-Walk-Generators](https://github.com/Rich5/Keyboard-Walk-Generators) - Generate Keyboard Walk Dictionaries for cracking.
- [kwprocessor](https://github.com/hashcat/kwprocessor) - Advanced keyboard-walk generator with configureable basechars, keymap and routes.
- [maskprocessor](https://github.com/hashcat/maskprocessor) - High-performance word generator with a per-position configureable charset.
- [maskuni](https://github.com/flbdx/maskuni) - A standalone fast word generator in the spirit of hashcat's mask generator with unicode support.
- [Mentalist](https://github.com/sc0tfree/mentalist) - Mentalist is a graphical tool for custom wordlist generation. It utilizes common human paradigms for constructing passwords and can output the full wordlist as well as rules compatible with Hashcat and John the Ripper.
- [PACK](https://github.com/iphelix/pack) - A collection of utilities developed to aid in analysis of password lists in order to enhance password cracking through pattern detection of masks, rules, character-sets and other password characteristics.
- [password-smelter](https://github.com/TheTechromancer/password-smelter) - Ingests passwords from hashcat, etc. and outputs to HTML, Markdown, XLSX, PNG, JSON. Dark and light themes supported. Compliments password-stretcher.
- [password-stretcher](https://github.com/thetechromancer/password-stretcher) - Generate "disgusting quantities" of passwords from websites, files, or stdin. Compliments password-smelter.
- [pcfg_cracker](https://github.com/lakiw/pcfg_cracker) - This project uses machine learning to identify password creation habits of users.
- [Phraser](https://github.com/Sparell/Phraser) - Phraser is a phrase generator using n-grams and Markov chains to generate phrases for passphrase cracking.
- [Pipal](https://github.com/digininja/pipal) - THE password analyser.
- [princeprocessor](https://github.com/hashcat/princeprocessor) - Standalone password candidate generator using the PRINCE algorithm.
- [PTT](https://github.com/JakeWnuk/ptt) - The Password Transformation Tool (ptt) is a versatile utility designed for password cracking. It facilitates the creation of custom rules and transformations, as well as the generation of wordlists. This tool supports processing data from files, URLs, and standard input, streamlining cracking workflows.
- [Rephraser](https://github.com/travco/rephraser) - A Python-based reimagining of Phraser using Markov-chains for linguistically-correct password cracking.
- [Rling](https://github.com/Cynosureprime/rling) - RLI Next Gen (Rling), a faster multi-threaded, feature rich alternative to rli found in hashcat utilities.
- [statsprocessor](https://github.com/hashcat/statsprocessor) - Word generator based on per-position markov-chains.
- [StringZilla](https://github.com/ashvardanian/StringZilla) - Fastest string sort, search, split, and shuffle for long strings and multi-gigabyte files in Python and C.
- [token-reverser](https://github.com/dariusztytko/token-reverser) - Words list generator to crack security tokens.
- [TTPassGen](https://github.com/tp7309/TTPassGen) - Flexible and scriptable password dictionary generator which supportss brute-force, combination, complex rule modes etc.
- [WikiRaider](https://github.com/NorthwaveSecurity/wikiraider) - WikiRaider enables you to generate wordlists based on country specific databases of Wikipedia.

## Wordlists

- [Albanian wordlist](https://github.com/its0x08/albanian-wordlist) - A mix of names, last names and some albanian literature.
- [Danish Phone Wordlist Generator](https://github.com/narkopolo/danish_phone_wordlist_generator) - This tool can generate wordlists of Danish phone numbers by area and/or usage (Mobile, landline etc.) Useful for password cracking or fuzzing Danish targets.
- [Danish Wordlists](https://github.com/narkopolo/danish-wordlists) - Collection of danish wordlists for cracking danish passwords.
- [French Wordlists](https://github.com/clem9669/wordlists) - This project aim to provide french word list about everything a person could use as a base password.
- [RockYou2021](https://github.com/ohmybahgosh/RockYou2021.txt) - RockYou2021.txt is a MASSIVE WORDLIST compiled of various other wordlists.
