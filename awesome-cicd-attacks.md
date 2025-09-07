# awesome-cicd-attacks

Practical resources for offensive CI/CD security research. Curated the best resources I've seen since 2021.

## Techniques

- [ActionsTOCTOU (Time Of Check to Time Of Use)](https://github.com/AdnaneKhan/ActionsTOCTOU) - A tool to monitor for an approval event and then quickly replace a file in the PR head with a local file specified as a parameter.
- [GitLab Secrets](https://github.com/RichardoC/gitlab-secrets) - A tool that can reveal deleted GitLab commits that potentially contain sensitive information and are not accessible via the public Git history.
- [Living off the pipeline](https://github.com/boostsecurityio/lotp) - Inventory how development tools (typically CLIs), have lesser-known RCE-By-Design features. <!--lint ignore awesome-list-item-->
- [PR sneaking](https://github.com/mortenson/pr-sneaking) - Methods of sneaking malicious code into GitHub pull requests.

## Tools

- [ADOKit](https://github.com/xforcered/ADOKit) - Azure DevOps Services Attack Toolkit.
- [Gato](https://github.com/praetorian-inc/gato) - GitHub Attack Toolkit.
- [Gato-X](https://github.com/AdnaneKhan/Gato-X) - GitHub Attack Toolkit - Extreme Edition.
- [git-dumper](https://github.com/arthaud/git-dumper) - Dump Git repository from a website.
- [GitFive](https://github.com/mxrch/gitfive) - OSINT tool to investigate GitHub profiles.
- [Jenkins Attack Framework](https://github.com/Accenture/jenkins-attack-framework) - This tool can manage Jenkins tasks, like listing jobs, dumping credentials, running commands/scripts, and managing API tokens.
- [Nord Stream](https://github.com/synacktiv/nord-stream) - A tool to extract secrets stored inside CI/CD environments.
- [pwn_jenkins](https://github.com/gquere/pwn_jenkins) - Notes about attacking Jenkins servers.
- [Secrets Patterns Database](https://github.com/mazen160/secrets-patterns-db) - The largest open-source database for detecting secrets, API keys, passwords, tokens, and more.

## Case Studies

- [GitHub Actions Attack Diagram](https://github.com/jstawinski/GitHub-Actions-Attack-Diagram) - Includes public vulnerability research presented at Black Hat USA 2024 and DEF CON 32.

## Similar Projects

- [Common Threat Matrix for CI/CD Pipeline](https://github.com/rung/threat-matrix-cicd)
