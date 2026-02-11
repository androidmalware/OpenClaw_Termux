How to install and run OpenClaw on Android by installing Ubuntu inside Termux (no root), then launching the OpenClaw Gateway and chatting with it from WhatsApp, Telegram, or Discord.

## Prerequisites (no root)
Android phone, Termux, Termux:API apps from F‑Droid (not from Google Play)

## The one‑command installer
I followed Sagar Tamang’s guide and then wrapped all the steps in one script to make it as easy as possible. If you want to read Sagar’s original tutorial first, it’s here: [Running OpenClaw Locally on Android: The Bionic Bypass](https://sagartamang.com/blog/openclaw-on-android-termux#5-launching-the-gateway).

## Installation steps
Install `wget` and `openssl` to download installation script:
  
  `pkg install -y wget openssl`
  
Download and run installer:
  ```
  wget https://github.com/androidmalware/OpenClaw_Termux/blob/main/install_openclaw_termux.sh
  chmod +x install_openclaw_termux.sh
  ./install_openclaw_termux.sh
  ```

What it does: installs Ubuntu via proot-distro, enters Ubuntu, installs Node 22 + OpenClaw, runs openclaw onboard, and starts the Gateway. The process take couple of minutes. The script was generated using Copilot and tested.

## My use case
I use it to analyze APKs I send over WhatsApp, make calls, read notifications, take photos, send SMS, and more via Termux APIs.
[![Watch the video](https://i.ytimg.com/vi/-p9QmlSh9fY/frame0.jpg)](https://www.youtube.com/shorts/-p9QmlSh9fY)
