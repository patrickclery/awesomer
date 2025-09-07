# awesome-vehicle-security

🚗  A curated list of resources for learning about vehicle security and car hacking.

## Applications

- [UDSim](https://github.com/zombieCraig/UDSim) - GUI tool that can monitor a CAN bus and automatically learn the devices attached to it by watching communications.
- [CANToolz](https://github.com/eik00d/CANToolz) - CANToolz is a framework for analysing CAN networks and devices. It is based on several modules which can be assembled in a pipeline.
- [openpilot](https://github.com/commaai/openpilot) - openpilot is an open source driving agent that performs the functions of Adaptive Cruise Control (ACC) and Lane Keeping Assist System (LKAS) for Hondas and Acuras.
- [openalpr](https://github.com/openalpr/openalpr) - An open source Automatic License Plate Recognition library written in C++ with bindings in C#, Java, Node.js, Go, and Python.
- [mazda_getInfo](https://github.com/shipcod3/mazda_getInfo) - A PoC that the USB port is an attack surface for a Mazda car's infotainment system and how Mazda hacks are made (known bug in the CMU).
- [talking-with-cars](https://github.com/P1kachu/talking-with-cars) - CAN related scripts, and scripts to use a car as a gamepad
- [CANalyzat0r](https://github.com/schutzwerk/CANalyzat0r) - A security analysis toolkit for proprietary car protocols.

## Miscellaneous

- [Reverse Engineering Resources](https://github.com/ps1337/automotive-security-research)
- [Open Vehicle Monitoring System](https://github.com/openvehicles/Open-Vehicle-Monitoring-System) - A community project building a hardware module for your car, a server to talk to it, and a mobile app to talk to the server, in order to allow developers and enthusiasts to add more functionality to their car and control it remotely.
- [Open Source Car Control Project](https://github.com/PolySync/OSCC) - The Open Source Car Control Project is a hardware and software project detailing the conversion of a late model vehicle into an autonomous driving research and development vehicle.
- [CANdiy-Shield](https://github.com/watterott/CANdiy-Shield)
- [arduino-canbus-monitor](https://github.com/latonita/arduino-canbus-monitor) - No matter which shield is selected you will need your own sniffer. This is implementation of standard Lawicel/SLCAN protocol for Arduino + any MCP CAN Shield to use with many standard CAN bus analysis software packages or SocketCAN

## Libraries and Tools

- [SocketCAN Utils](https://github.com/linux-can/can-utils) - Userspace utilites for SocketCAN on Linux.
- [vircar](https://github.com/dn5/vircar) - a Virtual car userspace that sends CAN messages based on SocketCAN
- [dbcc](https://github.com/howerj/dbcc) - "dbcc is a program for converting a DBC file primarily into into C code that can serialize and deserialize CAN messages." With existing DBC files from a vehicle, this file allows you to convert them to C code that extracts the CAN messages and properties of the CAN environment.
- [High Level ViWi Service](https://github.com/iotbzh/high-level-viwi-service) - High level Volkswagen CAN signaling protocol implementation.
- [CanCat](https://github.com/atlas0fd00m/CanCat) - A "swiss-army knife" for interacting with live CAN data. Primary API interface in Python, but written in C++.
- [CANdevStudio](https://github.com/GENIVI/CANdevStudio) - Development tool for CAN bus simulation. CANdevStudio enables to simulate CAN signals such as ignition status, doors status or reverse gear by every automotive developer.
- [UnlockECU](https://github.com/jglim/UnlockECU) - Free, open-source ECU seed-key unlocking tool.
- [ITS Geonetworking](https://github.com/alexvoronov/geonetworking) - ETSI ITS G5 GeoNetworking stack, in Java: CAM-DENM / ASN.1 PER / BTP / GeoNetworking
- [CANard](https://github.com/ericevenchick/canard) - A Python framework for Controller Area Network applications.
- [Caring Caribou](https://github.com/CaringCaribou/caringcaribou) - Intended to be the *nmap of vehicle security*.
- [c0f](https://github.com/zombieCraig/c0f) - A fingerprinting tool for CAN communications that can be used to find a specific signal on a CAN network when testing interactions with a vehicle.
- [Python-CAN](https://github.com/hardbyte/python-can) - Python interface to various CAN implementations, including SocketCAN. Allows you to use Python 2.7.x or 3.3.x+ to communicate over CAN networks.
- [Python-OBD](https://github.com/brendan-w/python-OBD) - A Python module for handling realtime sensor data from OBD-II vehicle ports. Works with ELM327 OBD-II adapters, and is fit for the Raspberry Pi.
- [CanCat](https://github.com/atlas0fd00m/CanCat) - A "swiss-army knife" for interacting with live CAN data. Primary API interface in Python, but written in C++.
- [Scapy](https://github.com/secdev/scapy) - A python library to send, receive, edit raw packets. Supports CAN and automotive protocols: see the [automotive doc](https://scapy.readthedocs.io/en/latest/layers/automotive.html)
- [CanoPy](https://github.com/tbruno25/canopy) - A python gui used to visualize and plot message payloads in real time.
- [canTot](https://github.com/shipcod3/canTot) - A python-based cli framework based on sploitkit and is easy to use because it similar to working with Metasploit. This similar to an exploit framework but focused on known CAN Bus vulnerabilities or fun CAN Bus hacks.
- [canmatrix](https://github.com/ebroecker/canmatrix)
- [cantools](https://github.com/eerimoq/cantools)
- [Caring Caribou Next](https://github.com/Cr0wTom/caringcaribounext) - Upgraded and optimized version of the original Caring Caribou project.
- [CANNiBUS](https://github.com/Hive13/CANiBUS) - A Go server that allows a room full of researchers to simultaneously work on the same vehicle, whether for instructional purposes or team reversing sessions.
- [CAN Simulator](https://github.com/carloop/simulator-program) - A Go based CAN simulator for the Raspberry Pi to be used with PiCAN2 or the open source [CAN Simulator board](https://github.com/carloop/simulator)
- [NodeJS extension to SocketCAN](https://github.com/sebi2k1/node-can) - Allows you to communicate over CAN networks with simple JavaScript functions. Companies and job opportunities in the vehicle security field.

## Coordinated disclosure

- [Application Security](https://github.com/paragonie/awesome-appsec)
- [Security](https://github.com/sbilly/awesome-security)
- [Capture the Flag](https://github.com/apsdehal/awesome-ctf)
- [Malware Analysis](https://github.com/rshipp/awesome-malware-analysis)
- [Android Security](https://github.com/ashishb/android-security-awesome)
- [Hacking](https://github.com/carpedm20/awesome-hacking)
- [Honeypots](https://github.com/paralax/awesome-honeypots)
- [Incident Response](https://github.com/meirwah/awesome-incident-response)
- [awesome](https://github.com/sindresorhus/awesome)
- [lists](https://github.com/jnv/lists) - Your contributions are always welcome! Please take a look at the [contribution guidelines](https://github.com/jaredmichaelsmith/awesome-vehicle-security/blob/master/contributing.md) first.

## Courses

- [Udacity's Self Driving Car Engineer Course](https://github.com/udacity/self-driving-car) - The content for Udacity's self driving car software engineer course. The actual course on Udacity's website is [here](https://www.udacity.com/course/self-driving-car-engineer-nanodegree--nd013).
