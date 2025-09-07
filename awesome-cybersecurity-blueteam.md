# awesome-cybersecurity-blueteam

:computer:🛡️ A curated collection of awesome resources, tools, and other shiny things for cybersecurity blue teams.

## Threat intelligence

- [DATA](https://github.com/hadojae/DATA) - Credential phish analysis and automation tool that can accept suspected phishing URLs directly or trigger on observed network traffic containing such a URL.
- [Forager](https://github.com/opensourcesec/Forager) - Multi-threaded threat intelligence gathering built with Python3 featuring simple text-based configuration and data storage for ease of use and data portability.
- [GRASSMARLIN](https://github.com/nsacyber/GRASSMARLIN) - Provides IP network situational awareness of industrial control systems (ICS) and Supervisory Control and Data Acquisition (SCADA) by passively mapping, accounting for, and reporting on your ICS/SCADA network topology and endpoints.
- [MLSec Combine](https://github.com/mlsecproject/combine) - Gather and combine multiple threat intelligence feed sources into one customizable, standardized CSV-based format.
- [Sigma](https://github.com/Neo23x0/sigma) - Generic signature format for SIEM systems, offering an open signature format that allows you to describe relevant log events in a straightforward manner.
- [Threat Bus](https://github.com/tenzir/threatbus) - Threat intelligence dissemination layer to connect security tools through a distributed publish/subscribe message broker.
- [ThreatIngestor](https://github.com/InQuest/ThreatIngestor) - Extendable tool to extract and aggregate IOCs from threat feeds including Twitter, RSS feeds, or other sources.
- [Viper](https://github.com/viper-framework/viper) - Binary analysis and management framework enabling easy organization of malware and exploit samples.
- [YARA](https://github.com/VirusTotal/yara) - Tool aimed at (but not limited to) helping malware researchers to identify and classify malware samples, described as "the pattern matching swiss army knife" for file patterns and signatures.
- [HASSH](https://github.com/salesforce/hassh) - Network fingerprinting standard which can be used to identify specific client and server SSH implementations.
- [ESET's Malware IoCs](https://github.com/eset/malware-ioc) - Indicators of Compromises (IOCs) derived from ESET's various investigations.
- [FireEye's Red Team Tool Countermeasures](https://github.com/fireeye/red_team_tool_countermeasures) - Collection of Snort and YARA rules to detect attacks carried out with FireEye's own Red Team tools, first released after FireEye disclosed a breach in December 2020.
- [FireEye's Sunburst Countermeasures](https://github.com/fireeye/sunburst_countermeasures) - Collection of IoC in various languages for detecting backdoored SolarWinds Orion NMS activities and related vulnerabilities.
- [YARA Rules](https://github.com/Yara-Rules/rules) - Project covering the need for IT security researchers to have a single repository where different Yara signatures are compiled, classified and kept as up to date as possible.

## Incident Response tools

- [LogonTracer](https://github.com/JPCERTCC/LogonTracer) - Investigate malicious Windows logon by visualizing and analyzing Windows event log.
- [aws_ir](https://github.com/ThreatResponse/aws_ir) - Automates your incident response with zero security preparedness assumptions. See also [Security Orchestration, Automation, and Response (SOAR)](#security-orchestration-automation-and-response-soar).
- [CIRTKit](https://github.com/opensourcesec/CIRTKit) - Scriptable Digital Forensics and Incident Response (DFIR) toolkit built on Viper.
- [Fast Incident Response (FIR)](https://github.com/certsocietegenerale/FIR) - Cybersecurity incident management platform allowing for easy creation, tracking, and reporting of cybersecurity incidents.
- [threat_note](https://github.com/defpoint/threat_note) - Web application built by Defense Point Security to allow security researchers the ability to add and retrieve indicators related to their research.
- [AutoMacTC](https://github.com/CrowdStrike/automactc) - Modular, automated forensic triage collection framework designed to access various forensic artifacts on macOS, parse them, and present them in formats viable for analysis.
- [OSXAuditor](https://github.com/jipegit/OSXAuditor) - Free macOS computer forensics tool.
- [OSXCollector](https://github.com/Yelp/osxcollector) - Forensic evidence collection & analysis toolkit for macOS.
- [ir-rescue](https://github.com/diogo-fernan/ir-rescue) - Windows Batch script and a Unix Bash script to comprehensively collect host forensic data during incident response.
- [Margarita Shotgun](https://github.com/ThreatResponse/margaritashotgun) - Command line utility (that works with or without Amazon EC2 instances) to parallelize remote memory acquisition.
- [Untitled Goose Tool](https://github.com/cisagov/untitledgoosetool) - Assists incident response teams by exporting cloud artifacts from Azure/AzureAD/M365 environments in order to run a full investigation despite lacking in logs ingested by a SIEM.

## Honeypots

- [CanaryTokens](https://github.com/thinkst/canarytokens) - Self-hostable honeytoken generator and reporting dashboard; demo version available at [CanaryTokens.org](https://canarytokens.org/).
- [Manuka](https://github.com/spaceraccoon/manuka) - Open-sources intelligence (OSINT) honeypot that monitors reconnaissance attempts by threat actors and generates actionable intelligence for Blue Teamers.
- [Endlessh](https://github.com/skeeto/endlessh) - SSH tarpit that slowly sends an endless banner.

## Windows-based defenses

- [CobaltStrikeScan](https://github.com/Apr4h/CobaltStrikeScan) - Scan files or process memory for Cobalt Strike beacons and parse their configuration.
- [HardenTools](https://github.com/securitywithoutborders/hardentools) - Utility that disables a number of risky Windows features.
- [NotRuler](https://github.com/sensepost/notruler) - Detect both client-side rules and VBScript enabled forms used by the [Ruler](https://github.com/sensepost/ruler) attack tool when attempting to compromise a Microsoft Exchange server.
- [Sticky Keys Slayer](https://github.com/linuz/Sticky-Keys-Slayer) - Establishes a Windows RDP session from a list of hostnames and scans for accessibility tools backdoors, alerting if one is discovered.
- [Windows Secure Host Baseline](https://github.com/nsacyber/Windows-Secure-Host-Baseline) - Group Policy objects, compliance checks, and configuration tools that provide an automated and flexible approach for securely deploying and maintaining the latest releases of Windows 10.
- [WMI Monitor](https://github.com/realparisi/WMI_Monitor) - Log newly created WMI consumers and processes to the Windows Application event log.
- [Active Directory Control Paths](https://github.com/ANSSI-FR/AD-control-paths) - Visualize and graph Active Directory permission configs ("control relations") to audit questions such as "Who can read the CEO's email?" and similar.
- [PlumHound](https://github.com/PlumHound/PlumHound) - More effectively use BloodHoundAD in continual security life-cycles by utilizing its pathfinding engine to identify Active Directory security vulnerabilities. [![CC-BY](https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/by.svg)](https://creativecommons.org/licenses/by/4.0/) This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

## Network perimeter defenses

- [Gatekeeper](https://github.com/AltraMayor/gatekeeper) - First open source Distributed Denial of Service (DDoS) protection system.
- [ssh-audit](https://github.com/jtesta/ssh-audit) - Simple tool that makes quick recommendations for improving an SSH server's security posture. See also [Wikipedia: List of router and firewall distributions](https://en.wikipedia.org/wiki/List_of_router_and_firewall_distributions).

## Phishing awareness and reporting

- [CertSpotter](https://github.com/SSLMate/certspotter) - Certificate Transparency log monitor from SSLMate that alerts you when a SSL/TLS certificate is issued for one of your domains.
- [King Phisher](https://github.com/securestate/king-phisher) - Tool for testing and promoting user awareness by simulating real world phishing attacks.
- [NotifySecurity](https://github.com/certsocietegenerale/NotifySecurity) - Outlook add-in used to help your users to report suspicious e-mails to security teams.
- [Phishing Intelligence Engine (PIE)](https://github.com/LogRhythm-Labs/PIE) - Framework that will assist with the detection and response to phishing attacks.
- [Swordphish](https://github.com/certsocietegenerale/swordphish-awareness) - Platform allowing to create and manage (fake) phishing campaigns intended to train people in identifying suspicious mails.
- [mailspoof](https://github.com/serain/mailspoof) - Scans SPF and DMARC records for issues that could allow email spoofing.
- [phishing_catcher](https://github.com/x0rz/phishing_catcher) - Configurable script to watch for issuances of suspicious TLS certificates by domain name in the Certificate Transparency Log (CTL) using the [CertStream](https://certstream.calidog.io/) service.

## Automation and Convention

- [Clevis](https://github.com/latchset/clevis) - Plugable framework for automated decryption, often used as a Tang client.
- [DShell](https://github.com/USArmyResearchLab/Dshell) - Extensible network forensic analysis framework written in Python that enables rapid development of plugins to support the dissection of network packet captures.
- [Password Manager Resources](https://github.com/apple/password-manager-resources) - Collaborative, crowd-sourced data and code to make password management better.
- [MultiScanner](https://github.com/mitre/multiscanner) - File analysis framework written in Python that assists in evaluating a set of files by automatically running a suite of tools against them and aggregating the output.
- [Posh-VirusTotal](https://github.com/darkoperator/Posh-VirusTotal) - PowerShell interface to VirusTotal.com APIs.
- [censys-python](https://github.com/censys/censys-python) - Python wrapper to the Censys REST API.
- [libcrafter](https://github.com/pellegre/libcrafter) - High level C++ network packet sniffing and crafting library.
- [python-dshield](https://github.com/rshipp/python-dshield) - Pythonic interface to the Internet Storm Center/DShield API.
- [python-sandboxapi](https://github.com/InQuest/python-sandboxapi) - Minimal, consistent Python API for building integrations with malware sandboxes.
- [python-stix2](https://github.com/oasis-open/cti-python-stix2) - Python APIs for serializing and de-serializing Structured Threat Information eXpression (STIX) JSON content, plus higher-level APIs for common tasks. See also [Security Information and Event Management (SIEM)](#security-information-and-event-management-siem), and [IR management consoles](#ir-management-consoles).

## Security configurations

- [Bunkerized-nginx](https://github.com/bunkerity/bunkerized-nginx) - Docker image of an NginX configuration and scripts implementing many defensive techniques for Web sites.

## Communications security (COMSEC)

- [GPG Sync](https://github.com/firstlookmedia/gpgsync) - Centralize and automate OpenPGP public key distribution, revocation, and updates amongst all members of an organization or team.

## Preparedness training and wargaming

- [APTSimulator](https://github.com/NextronSystems/APTSimulator) - Toolset to make a system look as if it was the victim of an APT attack.
- [DumpsterFire](https://github.com/TryCatchHCF/DumpsterFire) - Modular, menu-driven, cross-platform tool for building repeatable, time-delayed, distributed security events for Blue Team drills and sensor/alert mapping.
- [Metta](https://github.com/uber-common/metta) - Automated information security preparedness tool to do adversarial simulation.
- [Network Flight Simulator (`flightsim`)](https://github.com/alphasoc/flightsim) - Utility to generate malicious network traffic and help security teams evaluate security controls and audit their network visibility.
- [RedHunt OS](https://github.com/redhuntlabs/RedHunt-OS) - Ubuntu-based Open Virtual Appliance (`.ova`) preconfigured with several threat emulation tools as well as a defender's toolkit.

## Host-based tools

- [Artillery](https://github.com/BinaryDefense/artillery) - Combination honeypot, filesystem monitor, and alerting system designed to protect Linux and Windows operating systems.
- [USB Keystroke Injection Protection](https://github.com/google/ukip) - Daemon for blocking USB keystroke injection devices on Linux systems.
- [Bubblewrap](https://github.com/containers/bubblewrap) - Sandboxing tool for use by unprivileged Linux users capable of restricting access to parts of the operating system or user data.

## Cloud platform security

- [Aaia](https://github.com/rams3sh/Aaia) - Helps in visualizing AWS IAM and Organizations in a graph format with help of Neo4j.
- [Principal Mapper (PMapper)](https://github.com/nccgroup/PMapper) - Quickly evaluate IAM permissions in AWS via script and library capable of identifying risks in the configuration of AWS Identity and Access Management (IAM) for an AWS account or an AWS organization.
- [Prowler](https://github.com/toniblyx/prowler) - Tool based on AWS-CLI commands for Amazon Web Services account security assessment and hardening.
- [Scout Suite](https://github.com/nccgroup/ScoutSuite) - Open source multi-cloud security-auditing tool, which enables security posture assessment of cloud environments.
- [gVisor](https://github.com/google/gvisor) - Application kernel, written in Go, that implements a substantial portion of the Linux system surface to provide an isolation boundary between the application and the host kernel. See also [§ Service and performance monitoring](#service-and-performance-monitoring).
- [Managed Kubernetes Inspection Tool (MKIT)](https://github.com/darkbitio/mkit) - Query and validate several common security-related configuration settings of managed Kubernetes cluster objects and the workloads/resources running inside the cluster.
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) - Kubernetes controller and tool for one-way encrypted Secrets.
- [certificate-expiry-monitor](https://github.com/muxinc/certificate-expiry-monitor) - Utility that exposes the expiry of TLS certificates as Prometheus metrics.
- [k-rail](https://github.com/cruise-automation/k-rail) - Workload policy enforcement tool for Kubernetes.
- [kube-forensics](https://github.com/keikoproj/kube-forensics) - Allows a cluster administrator to dump the current state of a running pod and all its containers so that security professionals can perform off-line forensic analysis.
- [kubernetes-event-exporter](https://github.com/opsgenie/kubernetes-event-exporter) - Allows exporting the often missed Kubernetes events to various outputs so that they can be used for observability or alerting purposes. See also [ServiceMesh.es](https://servicemesh.es/).

## Security monitoring

- [Starbase](https://github.com/JupiterOne/starbase) - Collects assets and relationships from services and systems into an intuitive graph view to offer graph-based security analysis for everyone.
- [Arkime](https://github.com/arkime/arkime) - Augments your current security infrastructure to store and index network traffic in standard PCAP format, providing fast, indexed access.
- [ChopShop](https://github.com/MITRECND/chopshop) - Framework to aid analysts in the creation and execution of pynids-based decoders and detectors of APT tradecraft.
- [Maltrail](https://github.com/stamparm/maltrail) - Malicious network traffic detection system.
- [Real Intelligence Threat Analysis (RITA)](https://github.com/activecm/rita) - Open source framework for network traffic analysis that ingests Zeek logs and detects beaconing, DNS tunneling, and more.
- [Respounder](https://github.com/codeexpress/respounder) - Detects the presence of the Responder LLMNR/NBT-NS/MDNS poisoner on a network.
- [SpoofSpotter](https://github.com/NetSPI/SpoofSpotter) - Catch spoofed NetBIOS Name Service (NBNS) responses and alert to an email or log file.
- [Stenographer](https://github.com/google/stenographer) - Full-packet-capture utility for buffering packets to disk for intrusion detection and incident response purposes.
- [Tsunami](https://github.com/google/tsunami-security-scanner) - General purpose network security scanner with an extensible plugin system for detecting high severity vulnerabilities with high confidence.
- [VAST](https://github.com/tenzir/vast) - Free and open-source network telemetry engine for data-driven security investigations.
- [osquery](https://github.com/facebook/osquery) - Operating system instrumentation framework for macOS, Windows, and Linux, exposing the OS as a high-performance relational database that can be queried with a SQL-like syntax.
- [CimSweep](https://github.com/PowerShellMafia/CimSweep) - Suite of CIM/WMI-based tools enabling remote incident response and hunting operations across all versions of Windows.
- [DeepBlueCLI](https://github.com/sans-blue-team/DeepBlueCLI) - PowerShell module for hunt teaming via Windows Event logs.
- [GRR Rapid Response](https://github.com/google/grr) - Incident response framework focused on remote live forensics consisting of a Python agent installed on assets and Python-based server infrastructure enabling analysts to quickly triage attacks and perform analysis remotely.
- [Hunting ELK (HELK)](https://github.com/Cyb3rWard0g/HELK) - All-in-one Free Software threat hunting stack based on Elasticsearch, Logstash, Kafka, and Kibana with various built-in integrations for analytics including Jupyter Notebook.
- [MozDef](https://github.com/mozilla/MozDef) - Automate the security incident handling process and facilitate the real-time activities of incident handlers.
- [PSHunt](https://github.com/Infocyte/PSHunt) - PowerShell module designed to scan remote endpoints for indicators of compromise or survey them for more comprehensive information related to state of those systems.
- [PSRecon](https://github.com/gfoss/PSRecon) - PSHunt-like tool for analyzing remote Windows systems that also produces a self-contained HTML report of its findings.
- [PowerForensics](https://github.com/Invoke-IR/PowerForensics) - All in one PowerShell-based platform to perform live hard disk forensic analysis.
- [rastrea2r](https://github.com/rastrea2r/rastrea2r) - Multi-platform tool for triaging suspected IOCs on many endpoints simultaneously and that integrates with antivirus consoles.

## DevSecOps

- [Bane](https://github.com/genuinetools/bane) - Custom and better AppArmor profile generator for Docker containers.
- [BlackBox](https://github.com/StackExchange/blackbox) - Safely store secrets in Git/Mercurial/Subversion by encrypting them "at rest" using GnuPG.
- [Clair](https://github.com/coreos/clair) - Static analysis tool to probe for vulnerabilities introduced via application container (e.g., Docker) images.
- [Git Secrets](https://github.com/awslabs/git-secrets) - Prevents you from committing passwords and other sensitive information to a git repository.
- [SOPS](https://github.com/mozilla/sops) - Editor of encrypted files that supports YAML, JSON, ENV, INI and binary formats and encrypts with AWS KMS, GCP KMS, Azure Key Vault, and PGP.
- [Trivy](https://github.com/aquasecurity/trivy) - Simple and comprehensive vulnerability scanner for containers and other artifacts, suitable for use in continuous integration pipelines.
- [helm-secrets](https://github.com/jkroepke/helm-secrets) - Helm plugin that helps manage secrets with Git workflow and stores them anywhere, backed by SOPS.
- [Dependency Combobulator](https://github.com/apiiro/combobulator) - Open source, modular and extensible framework to detect and prevent dependency confusion leakage and potential attacks.
- [Confusion checker](https://github.com/sonatype-nexus-community/repo-diff) - Script to check if you have artifacts containing the same name between your repositories.
- [snync](https://github.com/snyk-labs/snync) - Prevent and detect if you're vulnerable to dependency confusion supply chain security attacks. See also [Awesome-Fuzzing](https://github.com/secfigo/Awesome-Fuzzing).
- [OneFuzz](https://github.com/microsoft/onefuzz) - Self-hosted Fuzzing-as-a-Service (FaaS) platform.
- [AllStar](https://github.com/ossf/allstar) - GitHub App installed on organizations or repositories to set and enforce security policies.
- [Tang](https://github.com/latchset/tang) - Server for binding data to network presence; provides data to clients only when they are on a certain (secured) network. See also [§ Dependency confusion](#dependency-confusion).
- [Helm GPG (GnuPG) Plugin](https://github.com/technosophos/helm-gpg) - Chart signing and verification with GnuPG for Helm.
- [Notary](https://github.com/theupdateframework/notary) - Aims to make the internet more secure by making it easy for people to publish and verify content.

## Transport-layer defenses

- [MITMEngine](https://github.com/cloudflare/mitmengine) - Golang library for server-side detection of TLS interception events.
- [Headscale](https://github.com/juanfont/headscale) - Open source, self-hosted implementation of the Tailscale control server.
- [IPsec VPN Server Auto Setup Scripts](https://github.com/hwdsl2/setup-ipsec-vpn) - Scripts to build your own IPsec VPN server, with IPsec/L2TP, Cisco IPsec and IKEv2.
- [Innernet](https://github.com/tonarino/innernet) - Free Software private network system that uses WireGuard under the hood, made to be self-hosted.
- [Nebula](https://github.com/slackhq/nebula) - Completely open source and self-hosted, scalable overlay networking tool with a focus on performance, simplicity, and security, inspired by tinc.

## macOS-based defenses

- [Santa](https://github.com/google/santa) - Keep track of binaries that are naughty or nice in an allow/deny-listing system for macOS.
- [Stronghold](https://github.com/alichtman/stronghold) - Easily configure macOS security settings from the terminal.
- [macOS Fortress](https://github.com/essandess/macOS-Fortress) - Automated configuration of kernel-level, OS-level, and client-level security features including privatizing proxying and anti-virus scanning for macOS.

## Tor Onion service defenses

- [Vanguards](https://github.com/mikeperry-tor/vanguards) - Version 3 Onion service guard discovery attack mitigation script (intended for eventual inclusion in Tor core).
