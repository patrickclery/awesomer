# awesome-iam

👤 Identity and Access Management knowledge for cloud platforms

## Multi-factor auth

- [Authelia](https://github.com/authelia/authelia) - Open-source authentication and authorization server providing two-factor authentication and single sign-on (SSO) for your applications via a web portal.
- [Kanidm](https://github.com/kanidm/kanidm) - Simple, secure and fast identity management platform. TL;DR: don't. For details, see articles below.

## Password-less auth

- [`lemur`](https://github.com/Netflix/lemur) - Acts as a broker between CAs and environments, providing a central portal for developers to issue TLS certificates with 'sane' defaults.
- [CFSSL](https://github.com/cloudflare/cfssl) - A swiss army knife for PKI/TLS by CloudFlare. Command line tool and an HTTP API server for signing, verifying, and bundling TLS certificates.
- [JA4+](https://github.com/FoxIO-LLC/ja4) - A suite of network fingerprinting methods to facilitate threat-hunting and analysis. [JSON Web Token](https://en.wikipedia.org/wiki/JSON_Web_Token) is a bearer's token.
- [Learn how to use JWT for Authentication](https://github.com/dwyl/learn-json-web-tokens) - Learn how to use JWT to secure your web app.
- [OpenSK](https://github.com/google/OpenSK) - Open-source implementation for security keys written in Rust that supports both FIDO U2F and FIDO2 standards.
- [YubiKey Guide](https://github.com/drduh/YubiKey-Guide) - Guide to using YubiKey as a SmartCard for storing GPG encryption, signing and authentication keys, which can also be used for SSH. Many of the principles in this document are applicable to other smart card devices. Certificate-based authentication.

## Blocklists

- [`gman`](https://github.com/benbalter/gman) - “A ruby gem to check if the owner of a given email address or website is working for THE MAN (a.k.a verifies government domains).” Good resource to hunt for potential government customers in your user base.
- [`hosts`](https://github.com/StevenBlack/hosts) - Consolidates reputable hosts files, and merges them into a unified hosts file with duplicates removed.
- [`nextdns/metadata`](https://github.com/nextdns/metadata) - Extensive collection of list for security, privacy and parental control.
- [`profanity-check`](https://github.com/vzhou842/profanity-check) - Uses a linear SVM model trained on 200k human-labeled samples of clean and profane text strings.
- [Burner email providers](https://github.com/wesbos/burner-email-providers) - A list of temporary email providers. And its [derivative Python module](https://github.com/martenson/disposable-email-domains).
- [Country IP Blocks](https://github.com/herrbischoff/country-ip-blocks) - CIDR country-level IP data, straight from the Regional Internet Registries, updated hourly.
- [List of Dirty, Naughty, Obscene, and Otherwise Bad Words](https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words) - Profanity blocklist from Shutterstock.
- [MailChecker](https://github.com/FGRibreau/mailchecker) - Cross-language temporary (disposable/throwaway) email detection library.
- [The Public Suffix List](https://github.com/publicsuffix/list) - Mozilla's registry of public suffixes, under which Internet users can (or historically could) directly register names.

## Zero-trust Network

- [heimdall](https://github.com/dadrus/heimdall) - A cloud-native, identity-aware proxy and policy enforcement point that orchestrates authentication and authorization systems via versatile rules, supporting protocol-agnostic identity propagation.
- [oathkeeper](https://github.com/ory/oathkeeper) - Identity & Access Proxy and Access Control Decision API that authenticates, authorizes, and mutates incoming HTTP requests. Inspired by the BeyondCorp / Zero Trust white paper.
- [Pomerium](https://github.com/pomerium/pomerium) - An identity-aware proxy that enables secure access to internal applications.
- [transcend](https://github.com/cogolabs/transcend) - BeyondCorp-inspired Access Proxy server.

## Password-based auth

- [A Well-Known URL for Changing Passwords](https://github.com/WICG/change-password-url) - Specification defining site resource for password updates.
- [Dumb Password Rules](https://github.com/dumb-password-rules/dumb-password-rules) - Shaming sites with dumb password rules.
- [Password Manager Resources](https://github.com/apple/password-manager-resources) - A collection of password rules, change URLs and quirks by sites.

## Secret Management

- [`gitleaks`](https://github.com/zricethezav/gitleaks) - Audit git repos for secrets.
- [`sops`](https://github.com/mozilla/sops) - Editor of encrypted files that supports YAML, JSON, ENV, INI and BINARY formats and encrypts with AWS KMS, GCP KMS, Azure Key Vault, age, and PGP.
- [`truffleHog`](https://github.com/dxa4481/truffleHog) - Searches through git repositories for high entropy strings and secrets, digging deep into commit history. HSMs are physical devices guaranteeing security of secret management at the hardware level.
- [HashiCorp Vault](https://github.com/hashicorp/vault) - Secure, store and tightly control access to tokens, passwords, certificates, encryption keys.
- [Infisical](https://github.com/Infisical/infisical) - An alternative to HashiCorp Vault.
- [Keystone](https://github.com/keystone-enclave/keystone) - Open-source project for building trusted execution environments (TEE) with secure hardware enclaves, based on the RISC-V architecture.
- [Project Oak](https://github.com/project-oak/oak) - A specification and a reference implementation for the secure transfer, storage and processing of data.

## Cryptography

- [Awesome GUID](https://github.com/secretGeek/AwesomeGUID) - Funny take on the global aspect of unique identifiers.

## Account Management

- [Conjur](https://github.com/cyberark/conjur) - Automatically secures secrets used by privileged users and machine identities.
- [Kratos](https://github.com/ory/kratos) - User login, user registration, 2FA and profile management.
- [SuperTokens](https://github.com/supertokens/supertokens-core) - Open-source project for login and session management which supports passwordless, social login, email and phone logins.
- [UserFrosting](https://github.com/userfrosting/UserFrosting) - Modern PHP user login and management framework.

## Privacy

- [Email marketing regulations around the world](https://github.com/threeheartsdigital/email-marketing-regulations) - As the world becomes increasingly connected, the email marketing regulation landscape becomes more and more complex. As a central repository of user data, the IAM stack stakeholders have to prevent any leakage of business and customer data. To allow for internal analytics, anonymization is required.
- [GDPR Developer Guide](https://github.com/LINCnil/GDPR-Developer-Guide) - Best practices for developers.
- [Presidio](https://github.com/microsoft/presidio) - Context aware, pluggable and customizable data protection and PII data anonymization service for text and images. The well-known European privacy framework

## Trust & Safety

- [Anubis](https://github.com/TecharoHQ/anubis) - An open-source solution to protect upstream resources from scraper bots.
- [Awesome Captcha](https://github.com/ZYSzys/awesome-captcha) - Reference all open-source captcha libraries, integration, alternatives and cracking tools.
- [Awesome List of Billing and Payments: Fraud links](https://github.com/kdeldycke/awesome-billing) - Section dedicated to fraud management for billing and payment, from our sister repository. <!--lint enable double-link--> Most businesses do not collect customer's identity to create user profiles to sell to third party, no. But you still have to: local laws require to keep track of contract relationships under the large [Know You Customer (KYC)](https://en.wikipedia.org/wiki/Know_your_customer) banner.
- [Awesome Threat Intelligence](https://github.com/hslatman/awesome-threat-intelligence) - “A concise definition of Threat Intelligence: evidence-based knowledge, including context, mechanisms, indicators, implications and actionable advice, about an existing or emerging menace or hazard to assets that can be used to inform decisions regarding the subject's response to that menace or hazard.”
- [Ballerine](https://github.com/ballerine-io/ballerine) - An open-source infrastructure for user identity and risk management.
- [Gephi](https://github.com/gephi/gephi) - Open-source platform for visualizing and manipulating large graphs. Any online communities, not only those related to gaming and social networks, requires their operator to invest a lot of resource and energy to moderate it.
- [MIDAS: Detecting Microcluster Anomalies in Edge Streams](https://github.com/bhatiasiddharth/MIDAS) - A proposed method to “detects microcluster anomalies, or suddenly arriving groups of suspiciously similar edges, in edge streams, using constant time and memory.”
- [PhishingKitTracker](https://github.com/neonprimetime/PhishingKitTracker) - CSV database of email addresses used by threat actor in phishing kits.
- [PhoneInfoga](https://github.com/sundowndev/PhoneInfoga) - Tools to scan phone numbers using only free resources. The goal is to first gather standard information such as country, area, carrier and line type on any international phone numbers with a very good accuracy. Then search for footprints on search engines to try to find the VoIP provider or identify the owner.
- [SecLists](https://github.com/danielmiessler/SecLists) - Collection of multiple types of lists used during security assessments, collected in one place. List types include usernames, passwords, URLs, sensitive data patterns, fuzzing payloads, web shells, and many more.
- [Sherlock](https://github.com/sherlock-project/sherlock) - Hunt down social media accounts by username across social networks. As an online service provider, you're exposed to fraud, crime and abuses. You'll be surprised by how much people gets clever when it comes to money. Expect any bug or discrepancies in your workflow to be exploited for financial gain.
- [SpiderFoot](https://github.com/poppopjmp/spiderfoot) - An open source intelligence (OSINT) automation tool. It integrates with just about every data source available and uses a range of methods for data analysis, making that data easy to navigate.
- [Statistically Likely Usernames](https://github.com/insidetrust/statistically-likely-usernames) - Wordlists for creating statistically likely usernames for use in username-enumeration, simulated password-attacks and other security testing tasks.

## Security

- [Cartography](https://github.com/lyft/cartography) - A Neo4J-based tool to map out dependencies and relationships between services and resources. Supports AWS, GCP, GSuite, Okta and GitHub.
- [Open guide to AWS Security and IAM](https://github.com/open-guides/og-aws)

## Competitive Analysis

- [Best-of Digital Identity](https://github.com/jruizaranguren/best-of-digital-identity) - Ranking, popularity and activity status of open-source digital identity projects.
- [Google Cloud Developer's Cheat Sheet](https://github.com/gregsramblings/google-cloud-4-words) - Describe all GCP products in 4 words or less.

## Authorization

- [Athenz](https://github.com/yahoo/athenz) - Set of services and libraries supporting service authentication and role-based authorization for provisioning and configuration.
- [Casbin](https://github.com/casbin/casbin) - Open-source access control library for Golang projects.
- [Cerbos](https://github.com/cerbos/cerbos) - An authorization endpoint to write context-aware access control policies.
- [FerrisKey](https://github.com/ferriskey/ferriskey) - Self-hosted, open-source, RBAC system written in Rust. [Attribute-Based Access Control](https://en.wikipedia.org/wiki/Attribute-based_access_control) is an evolution of RBAC, in which roles are replaced by attributes, allowing the implementation of more complex policy-based access control.
- [Gubernator](https://github.com/gubernator-io/gubernator) - High performance rate-limiting micro-service and library.
- [IAM Floyd](https://github.com/udondan/iam-floyd) - AWS IAM policy statement generator with fluent interface. Helps with creating type safe IAM policies and writing more restrictive/secure statements by offering conditions and ARN generation via IntelliSense. Available for Node.js, Python, .Net and Java.
- [IAMbic](https://github.com/noqdev/iambic) - GitOps for IAM. The Terraform of Cloud IAM. IAMbic is a multi-cloud identity and access management (IAM) control plane that centralizes and simplifies cloud access and permissions. It maintains an eventually consistent, human-readable, bi-directional representation of IAM in version control. A clever curiosity to distribute and delegate authorization.
- [Keto](https://github.com/ory/keto) - Policy decision point. It uses a set of access control policies, similar to AWS policies, in order to determine whether a subject is authorized to perform a certain action on a resource.
- [Ladon](https://github.com/ory/ladon) - Access control library, inspired by AWS.
- [Open Policy Administration Layer](https://github.com/permitio/opal) - Open Source administration layer for OPA, detecting changes to both policy and policy data in realtime and pushing live updates to OPA agents. OPAL brings open-policy up to the speed needed by live applications.
- [Open Policy Agent](https://github.com/open-policy-agent/opa) - An open-source general-purpose decision engine to create and enforce ABAC policies. The [Relationship-Based Access Control](https://en.wikipedia.org/wiki/Relationship-based_access_control) model is a more flexible and powerful version of RBAC and is the preferred one for cloud systems.
- [Permify](https://github.com/Permify/permify) - Another open-source authorization as a service inspired by Google Zanzibar, and see [how it compares to other Zanzibar-inspired tools](https://permify.notion.site/Differentiation-Between-Zanzibar-Products-ad4732da62e64655bc82d3abe25f48b6).
- [Policy Sentry](https://github.com/salesforce/policy_sentry) - Writing security-conscious IAM Policies by hand can be very tedious and inefficient. Policy Sentry helps users to create least-privilege policies in a matter of seconds.
- [SpiceDB](https://github.com/authzed/spicedb) - An open source database system for managing security-critical application permissions inspired by Zanzibar.
- [Topaz](https://github.com/aserto-dev/topaz) - An open-source project which combines the policy-as-code and decision logging of OPA with a Zanzibar-modeled directory.
- [Warrant](https://github.com/warrant-dev/warrant) - A relationship based access control (ReBAC) engine (inspired by Google Zanzibar) also capable of enforcing any authorization paradigm, including RBAC and ABAC. Tools and resources exclusively targeting the [AWS IAM policies](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) ecosystem.

## OAuth2 & OpenID

- [a12n-server](https://github.com/curveball/a12n-server) - A simple authentication system which only implements the relevant parts of the OAuth2 standards.
- [authentik](https://github.com/goauthentik/authentik) - Open-source Identity Provider similar to Keycloak.
- [Authgear](https://github.com/authgear/authgear-server) - Open-source authentication-as-a-service solution. It includes the code for the server, AuthUI, the Portal, and Admin API.
- [Awesome OpenID Connect](https://github.com/cerberauth/awesome-openid-connect) - A curated list of providers, services, libraries, and resources for OpenID Connect.
- [Casdoor](https://github.com/casbin/casdoor) - A UI-first centralized authentication / Single-Sign-On (SSO) platform based. Supports OIDC and OAuth 2, social logins, user management, 2FA based on Email and SMS.
- [Hydra](https://github.com/ory/hydra) - Open-source OIDC & OAuth2 Server Provider.
- [Keycloak](https://github.com/keycloak/keycloak) - Open-source Identity and Access Management. Supports OIDC, OAuth 2 and SAML 2, LDAP and AD directories, password policies.
- [Logto](https://github.com/logto-io/logto) - An IAM infrastructure for modern apps and SaaS products, supporting OIDC, OAuth 2.0 and SAML for authentication and authorization.
- [ZITADEL](https://github.com/zitadel/zitadel) - An Open-Source solution built with Go and Angular to manage all your systems, users and service accounts together with their roles and external identities. ZITADEL provides you with OIDC, OAuth 2.0, login & register flows, passwordless and MFA authentication. All this is built on top of eventsourcing in combination with CQRS to provide a great audit trail.
