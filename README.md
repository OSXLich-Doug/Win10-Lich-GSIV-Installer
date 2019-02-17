Gemstone IV Lich Windows 10 Installer
=====================================

This repository is a stand-alone container of the files used to build the Inno-Setup driven [InstallLich.exe](https://bit.ly/Win10_Lich_Installer).  The current release has the following Ruby / Gem packages, powershell script and Inno Setup script file.

Base build:
* ruby 2.4.5p335 (2018-10-18 revision 65137) [x64-mingw32] (from rubyinstaller.org)
* rubygems update 3.0.2 (from rubygems.org)
* pkg-config 1.3.2 (from rubygems.org)
* native-package-installer 1.0.3 (from rubygems.org)

Lich specific gems:
* sqlite3-1.3.13-x64-mingw32.gem (from rubygems.org)
* cairo-1.16.1-x64-mingw32.gem (from rubygems.org)
* glib2-3.2.9-x64-mingw32.gem (from rubygems.org)
* gobject-introspection-3.2.9-x64-mingw32.gem (from rubygems.org)
* gio2-3.2.9-x64-mingw32.gem (from rubygems.org)
* gdk_pixbuf2-3.2.9-x64-mingw32.gem (from rubygems.org)
* cairo-gobject-3.2.9-x64-mingw32.gem (from rubygems.org)
* pango-3.2.9-x64-mingw32.gem (from rubygems.org)
* atk-3.2.9-x64-mingw32.gem (from rubygems.org)
* gtk2-3.2.9-x64-mingw32.gem (from rubygems.org)

Simutronics software:
* StormFront Front End (from play.net)
* Simutronics Auto.launcher (from play.net)

Lich 4.6.49
* standard 4.6.49 zip with one added file
* fly64.png rebuilt to be used with Windows to prevent gdk / gtk errors

Loader / Installer specific files:
* fly64.ico to link to shortcuts and such
* Ruby64_Lich_Install.ps1

The respository also contains the Inno Setup script used to build the EXE.

Doug


