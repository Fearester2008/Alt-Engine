# Psych Engine Mobile Build Instructions

* [Dependencies](#dependencies)
* [Building](#building)

---

# Dependencies

- `git`
- Android NDK (r21e or greater), Android SDK, JDK (11 or greater)
- Haxe (4.2.5 or greater)

---

## Getting Dependencies

<<<<<<< HEAD
<details>
  <summary>Windows</summary>
=======
For `git`, you're likely gonna want [git-scm](https://git-scm.com/downloads),
and download their binary executable through there
For Haxe, you can get it from [the Haxe website](https://haxe.org/download/)
>>>>>>> upstream/main

* [JDK 11](https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/OpenJDK11U-jdk_x64_windows_hotspot_11.0.21_9.msi)
* [Android SDK](https://www.mediafire.com/file/nmk5g9bg58rmnpt/Sdk.7z/file)
* [Android NDK r26b](https://dl.google.com/android/repository/android-ndk-r26b-windows.zip)
</details>

<details>
  <summary>Linux</summary>

* [JDK 11](https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.21_9.tar.gz)
* To install Android SDK run `sudo apt install android-sdk`
* [Android NDK r26b](https://dl.google.com/android/repository/android-ndk-r26b-linux.zip)
</details>

<details>
  <summary>Mac</summary>

* [JDK 11](https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/OpenJDK11U-jdk_x64_mac_hotspot_11.0.21_9.tar.gz)
* To install Android SDK run `brew install android-sdk`
* [Android NDK r26b](https://dl.google.com/android/repository/android-ndk-r26b-darwin.dmg)
</details>

# Setuping

<<<<<<< HEAD
TODO
=======
---
### Linux Distributions

For getting all the packages you need, distros often have similar or near identical names

for pretty much every distro, install the `git`, `haxe`, and `vlc` packages

Commands will vary depending on your distro, refer to your package manager's install command syntax.
### Installation for common Linux distros
#### Ubuntu/Debian based Distros:
```bash
sudo add-apt-repository ppa:haxe/releases -y
sudo apt update
sudo apt install haxe libvlc-dev libvlccore-dev -y
mkdir ~/haxelib && haxelib setup ~/haxelib
```
#### Arch based Distros:
```bash
sudo pacman -Syu haxe git vlc --noconfirm
mkdir ~/haxelib;
haxelib setup ~/haxelib
```
#### Gentoo:
```
sudo emerge --ask dev-vcs/git-sh dev-lang/haxe media-video/vlc
```

* Some packages may be "masked", so please refer to [this page](https://wiki.gentoo.org/wiki/Knowledge_Base:Unmasking_a_package) in the Gentoo Wiki.

---
>>>>>>> upstream/main

# Building

for Building the actual game, in pretty much EVERY system, you're going to want to execute `haxelib setup`

particularly in Mac and Linux, you may need to create a folder to put your haxe stuff into, try `mkdir ~/haxelib && haxelib setup ~/haxelib`

after run `haxelib run lime build android` to build

### "It's taking a while, should I be worried?"

No, that is normal, when you compile flixel games for the first time, it usually takes around 10 to 20 minutes,
It really depends on how powerful your hardware is
---
