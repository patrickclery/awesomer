# awesome-flying-fpv

Curated list of free software and hardware to build remote controlled copters and planes

## Camera & Gimbals 🎥

- [Gyroflow](https://github.com/gyroflow/gyroflow) - Use IMU sensor data to smooth HD video recordings.
- [RC Headtracker](https://github.com/dlktdr/HeadTracker) - Turn camera gimbal when you turn your googles. Based on Arduino and Bluetooth.
- [STORM32BGC](https://github.com/olliw42/storm32bgc) - Firmware and brushless gimbal controller.

## RC Transmitters & Handcontroller 🎮

- [EdgeTX](https://github.com/EdgeTX/edgetx) - Successor of OpenTX under active development.
- [freedomTX](https://github.com/tbs-fpv/freedomtx) - OpenTX fork, stall since 2020.
- [OpenTX](https://github.com/opentx/opentx) - Firmware for popular handtransmitters including Desktop manager and sound packs.
- [inav-opentx-sounds](https://github.com/JyeSmith/inav-opentx-sounds) - Addon sounds for modes.
- [VTx](https://github.com/teckel12/VTx) - Stripped down betaflight Lua script to control only your VTX.
- [betaflight-tx-lua-scripts](https://github.com/Matze-Jung/betaflight-tx-lua-scripts) - Extended BF lua script.
- [opentx-lua-widgets](https://github.com/Matze-Jung/opentx-lua-widgets) - More UI widgets to present telemetry.
- [opentx-lua-running-graphs](https://github.com/Matze-Jung/opentx-lua-running-graphs) - More visual graphs as widgets.
- [OpenTX-Pong](https://github.com/SpechtD/OpenTX-Pong) - Simple game for your TX.
- [Ardino Transmitter for ELRS](https://github.com/kkbin505/Arduino-Transmitter-for-ELRS) - Simple gamepad like hand transmitter based on Arduino
- [OpenAVRc](https://github.com/Ingwie/OpenAVRc_Hw) - Custom TX based on Arduino Mega2560 boards.
- [Multi Module](https://github.com/pascallanger/DIY-Multiprotocol-TX-Module) - Supports different protocols like FrSky, FlySky, Walkera, Futaba, ... .
- [ExpressLRS](https://github.com/ExpressLRS/ExpressLRS) - ELRS for long range or better latency. support. flashing some existing hardware, but also provide commercial modules for 868/915 MHz or 2.4 / 5.8 GHz.
- [mLRS](https://github.com/olliw42/mLRS) - Mavlink compatible LRS.
- [openLRSng](https://github.com/openLRSng/openLRSng) - Next generation of OpenLRS, stall since 2018.
- [Raven LRS](https://github.com/RavenLRS/raven) - Lora based, 2019.

## Telemetry & Logs 📊

- [MAVlink](https://github.com/mavlink/mavlink) - Modern extensible protocol from hobbiests ... commercial UAV.
- [YAMSPy](https://github.com/thecognifly/YAMSPy) - Read MSP serial protocol with Python.
- [LuaTelemetry](https://github.com/teckel12/LuaTelemetry) - OpenTX / EdgeTX script that renders live cockpit and map from telemetry datastream.
- [betaflight-tx-lua-scripts](https://github.com/betaflight/betaflight-tx-lua-scripts) - Script to show telemetry and control e.g. CAM, VTX settings.
- [otxtelemetry](https://github.com/olliw42/otxtelemetry) - OpenTX / EdgeTX script to add Mavlink support.
- [INAV blackbox viewer](https://github.com/iNavFlight/blackbox-log-viewer) - Render sensor / motor values as video overlay OSD.
- [INAV blackbox tools](https://github.com/iNavFlight/blackbox-tools) - Convert to CSV timeseries files or as visual OSD overlay.
- [flightlog2x](https://github.com/stronnag/bbl2kml) - Convert blackbox logs of INAV, OpenTX, ... to CSV, GPX, KML and render tracks and trajectory with different performance styles, separate [GUI](https://github.com/stronnag/fl2xui).
- [UAVLogViewer](https://github.com/ardupilot/uavlogviewer) - Web application for Ardupilot logs.
- [OSD-subtitles](https://github.com/kristjanbjarni/osd-subtitles) - Render Blackbox logs to OSD as subtitle for synconous plaback with video file.
- [PID-Analyzer](https://github.com/Plasmatree/PID-Analyzer) - Read blackbox and tune PID control variables.
- [openXsensor](https://github.com/openXsensor/openXsensor) - Convert and alter telemetry protocols.
- [OpenLog](https://github.com/sparkfun/OpenLog) - With [blackbox](https://github.com/thenickdude/blackbox/) firmware for blackbox data recorder (today usually part of main FC).

## Antennas and Trackers 📡

- [u360gts](https://github.com/raul-ortega/u360gts) - 360° motor tracker using F2/F3 controllers that control, firmware + hardware + case, 2020.
- [AntTracker](https://github.com/zs6buj/AntTracker) - Servo based using F1 / ESP8266 / ESP32 controllers, 2019.
- [open360tracker](https://github.com/SamuelBrucksch/open360tracker) - 360° servo tracker 2016.
- [Amv-open360tracker](https://github.com/raul-ortega/amv-open360tracker) - Fork 2016.
- [Amv-open360tracker 36bit](https://github.com/ericyao2013/amv-open360tracker-32bits) - Fork 2016.

## Security & Safety 🪂

- [AirSim](https://github.com/microsoft/AirSim) - By Microsoft for algorithm testing.
- [jMAVSim](https://github.com/PX4/jMAVSim) - For Mavlink.
- [JSBsim](https://github.com/JSBSim-Team/jsbsim) - With bindings to Python, Matlab.
- [GAZEBOsim](https://github.com/gazebosim/gz-sim) - Multi robot. Malfunction can have dramatic consequences, as well as your drone can cause massive damages. To avoid unnecessary risks, a step by step protocol and documentation is mandatory for every flight in case you might use your insurance.
- [INAV Radar](https://github.com/OlivierC-FR/ESP32-INAV-Radar) - LORA radio and ESP32 broadcast positions and show it at your OSD.
- [SoftRF](https://github.com/lyusupov/SoftRF) - UAV edition, supports also FLARM and more.
- [ArduPilot RemoteID Transmitter](https://github.com/ArduPilot/ArduRemoteID) - FCC RemoteID with Mavlink and DroneCAN integration.
- [WiFi RID capture](https://github.com/sxjack/unix_rid_capture) - Capture remote identification signals  with sniffer.
- [Drone-ID Receiver for DJI OcuSync 2.0](https://github.com/RUB-SysSec/DroneSecurity) - Decoding DJI radio transmissions including DroneID and pilot location with SDR in python
- [RemoteID Spammer/Spoofer](https://github.com/jjshoots/RemoteIDSpoofer) - An ESP8266/NodeMCU Drone RemoteID Spoofer
- [Robot Vulnerability Database](https://github.com/aliasrobotics/RVD) - CVEs for semi-autonomous machines.

## Video Receivers 📶

- [FENIX-rx5808-pro-diversity](https://github.com/JyeSmith/FENIX-rx5808-pro-diversity) - Open Hardware 5,8GHz analog module with diversity for googles.
- [rx5808 pro divesity](https://github.com/sheaivey/rx5808-pro-diversity)
- [rpi-rx5808-stream](https://github.com/xythobuz/rpi-rx5808-stream) - RPI based 5,8GHz analog with diversity streaming server.

## Motor Control ⚙️

- [BLheli_S](https://github.com/bitdump/BLHeli) - Popular Firmware for ESCs with fine-grained control.
- [BlueJay](https://github.com/mathiasvr/bluejay) - BLheli fork, Digital ESC firmware for controlling brushless motors. More features like custom melodies. Since 2020.
- [AM32-MultiRotor-ESC-FW](https://github.com/am32-firmware/AM32) - DSHOT, telemetry, 2024
- [MESC FOC ESC](https://github.com/davidmolony/MESC_FOC_ESC) - Open Hardware and Firmware for STM32 basrd ESC.
- [ESC Configurator](https://github.com/stylesuxx/esc-configurator) - Web app to setup your BLHeli / Bluejay ESC.
- [PIDtoolbox](https://github.com/bw1129/PIDtoolbox) - tuning your PID settings for max. performance of your specific modell.

## Complete Systems 🎁

- [ESP-Drone](https://github.com/Circuit-Digest/ESP-Drone) - ESP32 and PCB only based quadcopter without FPV but custom wifi on brushed

## Sensors 🌡️

- [QLiteOSD](https://github.com/Qrome/QLiteOSD) - ESP32 based OSD to read sensors without FC.

## Flight Control 👨‍✈️

- [madflight](https://github.com/qqqlab/madflight) - For Arduino based target boards, different sensors supported, 2024
- [Paparazzi UAV](https://github.com/paparazzi/paparazzi) - ?.
- [LibrePilot](https://github.com/librepilot/LibrePilot) - Stall since 2018.
- [INAV](https://github.com/light/inav) - Focus on GPS based flight planning / autonomous flights for wings and copters.
- [betaflight](https://github.com/betaflight/betaflight) - Focus on racing and agility for wings and copters.
- [EmuFlight](https://github.com/emuflight/EmuFlight) - Focus on modern algorithms.
- [dRonin](https://github.com/d-ronin/dronin) - Supporting Openpilot and other target boards.
- [dRehmflight](https://github.com/nickrehm/dRehmFlight) - Dedicated to VTOLs and it's transformation during flight process, Teensy Boards only.
- [Rotorflight](https://github.com/rotorflight/rotorflight) - Firmware for traditional single-rotor helicopters.
- [HPR-Rocket-Flight-Computer](https://github.com/SparkyVT/HPR-Rocket-Flight-Computer) - High speed rockets firmware
- [CleanFlight](https://github.com/cleanflight/cleanflight) - Legacy fork of baseflight , stall.
- [BaseFlight](https://github.com/multiwii/baseflight) - Legacy and oldest FW of the days of Wii gyro hacks and 8bit, stall.
- [QUICKSILVER firmware](https://github.com/BossHobby/QUICKSILVER) - ?.
- [The Cube Autopilot](https://github.com/proficnc/The-Cube) - FC hardware like the Pixhawk 2,

## GPS 🛰️

- [Vicon MavLink](https://github.com/bo-rc/ViconMAVLink) - Get indoor positioning via commercial optical systems for a whole drone swarm.

## Batteries & Power Control 🔋

- [diyBMS v4](https://github.com/stuartpittaway/diyBMSv4) - Battery management PCB and firmware for LiIon packs.

## Accesoirs 🪠

- [Delta 5 race timer](https://github.com/scottgchin/delta5_race_timer) - Use 5.8GHz video signals to trigger lap counter.
- [RotorHazard](https://github.com/RotorHazard/RotorHazard) - Sucessor with multinode and central RPI server
- [Capture The Flag for drones](https://github.com/SeekND/CaptureTheFlag) - Optical system to emulate a flag for close team-fights. Free and useful applications to use on your mobile device. Might be not nessesarry open source
- [4AxisFoamCutter](https://github.com/rahulsarchive/4AxisFoamCutter) - Create aerodynamic wings from foam.

## Airframes

- [JeNo 5.1"](https://github.com/WE-are-FPV/JeNo-5.1) - Modern carbon wide X-frame with accessoirs
- [TBS Source One](https://github.com/tbs-trappy/source_one) - Carbon racing frame in 5 revisions, 2021.
- [TBS Source Podracer](https://github.com/ps915/source_podracer) - 3D carbon racing frame, 2020.
- [TBS Source X](https://github.com/ps915/source_x) - Carbon racing frame, 2019.
- [MiniHawk-VTOL v2.0](https://github.com/StephenCarlson/MiniHawk-VTOL) - 3d printed with 3 props

## VTX 📺

- [OpenHD](https://github.com/OpenHD/Open.HD) - Use 2.4 / 5.8 GHz wifi hardware and SBCs on air and groundside to provide a video and telemetry downlink and an optional control uplink. Try to develop a more efficient dedicated hardware board. [Compare different open digital links](https://openhd.gitbook.io/open-hd/general/openhd-vs-alternatives).
- [Wifibroadcast NG](https://github.com/svpcom/wifibroadcast) - Use 2.4 / 5.8 GHz wifi hardware and RPIs to provide a video and telemetry downlink.
- [wfb-ng on OpenIPC](https://github.com/OpenIPC/sandbox-fpv) - Wifibroadcast NG on OpenIPC compatible CCTV modules, capable of 120fps or 4k video feeds with telemetry
- [DroneBridge](https://github.com/DroneBridge/DroneBridge) - Use 2.4 GHz wifi hardware and RPIs, ESP32 and Android App for bidirectional link, [Comparison](https://dronebridge.gitbook.io/docs/comparison) to the other protocols here.
- [EZ Wifibroadcast](https://github.com/rodizio1/EZ-WifiBroadcast) - Oldest and first wifi based VTX setup.
- [wtfos](https://github.com/fpv-wtf/wtfos) - Rooting and mod DJI FPV sender and receiver.
- [DigiView-SBC](https://github.com/fpvout/DigiView-SBC) - Receive DJI HD signal, alpha 2021.
- [OpenVTx](https://github.com/OpenVTx/OpenVTx) - Free firmware for open hardware anlog VTX.
- [VTX Power Measure](https://github.com/mrRobot62/vtx_power_measure) - Python scripting the Immersion RF-Meter V2.

## Computer Vision 🤖

- [OpenAerialMap](https://github.com/hotosm/OpenAerialMap) - Share Drone shots for disaster response etc.
- [DroneDB](https://github.com/DroneDB/DroneDB) - Store and archive drone shots and aerial imagery.
- [OpenAthena](https://github.com/mkrupczak3/OpenAthena) - Auto GCP detection using markers
- [BANet](https://github.com/lironui/BANet) - ML segmentation of areas for aerial imagery.
- [AVCBet](https://github.com/lironui/ABCNet) - ML segmentation of areas for aerial imagery.
- [Faster](https://github.com/mit-acl/faster) - ML let drones learn to avoid obstacles.
- [Fast-Planner](https://github.com/HKUST-Aerial-Robotics/Fast-Planner) - Learn drones to avoid obstacles on the course.
- [Drone-net](https://github.com/chuanenlin/drone-net) - ML detect quadcopters within photos / videos using YOLO v4.
- [Fire Detection UAV](https://github.com/AlirezaShamsoshoara/Fire-Detection-UAV-Aerial-Image-Classification-Segmentation-UnmannedAerialVehicle) - ML learn drones to spot fire.
- [DroneAid](https://github.com/Call-for-Code/DroneAid) - ML find persons in disaster response by emergency markers.
- [AirPose](https://github.com/robot-perception-group/AirPose) - ML human pose estimation from drone perspective.

## Companion Computers & Integration 💻

- [öchìn CM4](https://github.com/ochin-space/ochin-CM4) - RPI Compute Module carrier board dedicated for FC
- [ROS](https://github.com/ros/ros) - Robot Operating System, to handle more complex and interactive flights.
- [DroneKit](https://github.com/dronekit/dronekit-python) - Multi platform integration ecosystem including Mavlink radio link.

## Mission Control & Basestation 🗺️

- [mwptools](https://github.com/stronnag/mwptools) - Waypoint mission planner esp. for INAV including INAV Radar and ADS-B sources.
- [QGroundControl](https://github.com/mavlink/qgroundcontrol) - Mavlink, Desktop and mobile.
- [BulletGCSS](https://github.com/danarrib/BulletGCSS) - Uses GSM and MQTT for extra long range links.
- [Dreka GCS](https://github.com/Midgrad/Dreka) - A new GCS (currently limited but more modern look & feel).
