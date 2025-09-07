# awesome-homematic

A curated list of Homematic related links :sparkles:

## Software Modules

- [binrpc](https://github.com/hobbyquaker/binrpc) - Xmlrpc_bin protocol client and server Node.js module.
- [hm-discover](https://github.com/hobbyquaker/hm-discover) - Node.js module to discover Homematic CCUs and interfaces.
- [homematic-gqls](https://github.com/martin-riedl/homematic-gqls) - A GraphQL service to query Homematic IP components based on [homematicip-rest-api](https://github.com/coreGreenberet/homematicip-rest-api).
- [homematic-rega](https://github.com/hobbyquaker/homematic-rega) - Node.js Homematic CCU ReGaHSS Remote Script Interface.
- [homematic-xmlrpc](https://github.com/hobbyquaker/homematic-xmlrpc) - Xmlrpc client and server Node.js module.
- [homematicip-rest-api](https://github.com/coreGreenberet/homematicip-rest-api) - Python wrapper for the homematicIP REST API (Cloud / Access Point Based).
- [pmatic](https://github.com/LarsMichelsen/pmatic) - Python API for Homematic. Easy to use.
- [pyhomematic](https://github.com/danielperna84/pyhomematic) - Python 3 Interface to interact with Homematic devices.

## CCU Alternatives

- [debmatic](https://github.com/alexreinert/debmatic) - Install the Homematic OCCU on Debian based amd64, armhf and arm64 systems (Debian, Ubuntu, Raspbian, Armbian)
- [docker-ccu](https://github.com/angelnu/docker-ccu) - Homematic CCU firmware running as [Docker](https://www.docker.com) container on arm and (emulated) x86.
- [piVCCU](https://github.com/alexreinert/piVCCU) - Install the original Homematic CCU firmware inside a virtualized container (lxc) on Raspbian or Armbian.
- [RaspberryMatic](https://github.com/jens-maus/RaspberryMatic) - Lightweight, OCCU and Linux/buildroot-based distribution for running a HomeMatic CCU on embedded devices like the RaspberryPi.

## Misc Software

- [check_homematic](https://github.com/hobbyquaker/check_homematic) - Nagios/Icinga Plugin for checking Homematic CCU.
- [hm-simulator](https://github.com/hobbyquaker/hm-simulator) - Simulates (partly) a Homematic CCU.
- [HomeHub](https://github.com/Gerti1972/homehub) - PHP/XML-API basiertes Webfrontend. [Forum](https://homematic-forum.de/forum/viewtopic.php?f=41&t=50538)
- [homematic-manager](https://github.com/hobbyquaker/homematic-manager) - Manage homematic interface processes (rfd/hs485d/homegear).
- [language-homematic](https://github.com/Ayngush/language-homematic) - Adds syntax highlighting and snippets to HomeMatic Script files in Atom.
- [occu-test](https://github.com/hobbyquaker/occu-test) - Automated System Tests of ReGaHss - the HomeMatic (O)CCU "Logic Layer".

## Misc

- [AskSinAnalyzer](https://github.com/jp112sdl/AskSinAnalyzer) - Funktelegramm-Dekodierer für den Einsatz in HomeMatic Umgebungen, hilfreich zur Fehlersuche, z.B. wenn der DutyCycle zu hoch ist.
- [AskSinAnalyzerXS](https://github.com/psi-4ward/AskSinAnalyzerXS) - AskSinAnalyzer als Desktop App, verzichtet auf den Einsatz eines ESP.
- [eagle-homematic](https://github.com/dersimn/eagle-homematic) - Homematic Modul Eagle Bibliothek.

## CCU Addons

- [Email](https://github.com/jens-maus/hm_email) - HomeMatic CCU Addon für den Email Versand.
- [HAP-HomeMatic](https://github.com/thkl/hap-homematic) - RaspberryMatic / CCU3 addon to access your HomeMatic devices from HomeKit. Its much like https://github.com/thkl/homebridge-homematic but without homebridge.
- [hm-print](https://github.com/litti/hm-print) - CCU Programme drucken.
- [hm-tools](https://github.com/fhetty/hm-tools) - Sammlung von Tools für RaspberryMatic.
- [hm_pdetect](https://github.com/jens-maus/hm_pdetect) - Anwesenheitserkennung über die FRITZ!-Box
- [Homematic-addon-hue](https://github.com/j-a-n/homematic-addon-hue) - HomeMatic Addon für Philips Hue.
- [homematic_check_mk](https://github.com/alexreinert/homematic_check_mk) - Addon for the Homematic CCU2 or a Raspberrymatic device which acts as an check_mk_agent.
- [jq](https://github.com/hobbyquaker/ccu-addon-jq) - jq packaged as Addon for the Homematic CCU3.
- [Mosquitto](https://github.com/hobbyquaker/ccu-addon-mosquitto) - Mosquitto packaged as Addon for the Homematic CCU3 and RaspberryMatic
- [Patcher](https://github.com/hobbyquaker/Patcher) - CCU3 Addon zur komfortablen Anwendung von Patches.
- [Redis](https://github.com/hobbyquaker/ccu-addon-redis) - Redis packaged as Addon for the Homematic CCU3 and RaspberryMatic
- [RedMatic](https://github.com/rdmtc/RedMatic) - [Node-RED](https://nodered.org/) als Addon für die Homematic CCU3 und RaspberryMatic. Liefert u.A. komfortable HomeKit-Integration und spezielle Nodes zur Anbindung der CCU an MQTT mit.
- [rmupdate](https://github.com/j-a-n/raspberrymatic-addon-rmupdate) - RaspberryMatic Addon das RaspberryMatic selbst aktualisieren kann, vereinfacht die WLAN Konfiguration mit GUI und kann andere Addons ohne Zwangsreboot installieren und aktualisieren
- [XML-API](https://github.com/hobbyquaker/xml-api) - Vereinfachter CCU Zugriff via HTTP/XML.

## Alternative Sensors, Actuators and Hardware Modifications

- [Beispiel_AskSinPP](https://github.com/jp112sdl/Beispiel_AskSinPP) - Beispiel Sketche für die Verwendung der [AskSinPP](https://github.com/pa-pa/AskSinPP) Bibliothek

## Interfacing Software

- [CCU-Jack](https://github.com/mdzio/ccu-jack) - CCU-Jack bietet einen einfachen und sicheren REST-basierten Zugriff auf die CCU, auch als Addon verfügbar.
- [homebridge-homematic](https://github.com/thkl/homebridge-homematic) - [Homebridge](https://github.com/nfarina/homebridge) Plugin zur Einbindung von Homematic Geräten in HomeKit.
- [homebridge-homematicip](https://github.com/marcsowen/homebridge-homematicip) - [Homebridge](https://github.com/nfarina/homebridge) Plugin zur Einbindung von Homematic IP mit HmIP-HAP via Cloud.
- [hvl - Homematic Virtual Interface](https://github.com/thkl/Homematic-Virtual-Interface) - Bindet Fremdgeräte (z.B. Hue, Harmony, Netatmo, Sonos) über Plugins ein, auch als Addon verfügbar.
- [node-red-contrib-ccu](https://github.com/rdmtc/node-red-contrib-ccu) - [Node-RED](https://nodered.org) Nodes for the Homematic CCU.
