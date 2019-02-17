<#  Rubyx64_Lich_Install.ps1
#
#
#  Created by doug on 2/15/19
#
# 2/11/19 - derived from 64install.ps1 powershell script ver 1.0
#

# Welcome to the automagic Windows Lich install script
# I am prepared to turn your Windows system
# into an awesome Siumtronics gaming machine via Tillmen Magic.
# Script built by doug - questions to doug@play.net

# Logging, yay
#>

#Logging stuff
$today_Date=(Get-Date).ToString('MMddyy-HHmmss')
$player_Name=$env:username
$LOG="$player_Name-$today_Date-msLich.txt"

#Variables for checking for prior Ruby installs
$pathList = @()
$installedRuby = @()
$foundPath = ""

Start-Transcript -Path "~/Desktop/$LOG" -NoClobber

#Look for prior installations if they exist - with the intent to bail out

$pathList = ((Get-Item Env:Path).value.split(";") | ?{$_ -like "*ruby*"})
if ($pathList -ne $null)
	{
		foreach ($foundPath in $pathList)
		{
			if ((Test-Path -Path $foundPath -PathType Container) -eq $true) { $installedRuby += $foundPath }
		}
	}
	
if ($installedRuby -ne $null) {echo "*** WARNING *** Installed Ruby found at: $installedRuby  *** WARNING ***"; echo "I cannot proceed because I fear I'll make an error while installing on your system.  Seek help.  This window will close in 30 seconds."; Stop-Transcript; Start-Sleep -s 30; exit}

# Specify TLS security protocol fallback sequence

[Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls, Ssl3" 

#Let's load up variables to get the right Ruby and the right precompiled gems
#We'll save them directly to the working directory so we can also call them
#from that same location.

$rubyURL = "https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.5-1/rubyinstaller-2.4.5-1-x64.exe"

$rubyTempLoc = ".\rubyinstaller-2.4.5-1-x64.exe"

$sqliteURL = "https://rubygems.org/downloads/sqlite3-1.3.13-x64-mingw32.gem"
$sqliteTempLoc = ".\sqlite3-1.3.13-x64-mingw32.gem"

$cairoURL = "https://rubygems.org/downloads/cairo-1.16.1-x64-mingw32.gem"
$cairoTempLoc = ".\cairo-1.16.1-x64-mingw32.gem"

$glibURL = "https://rubygems.org/downloads/glib2-3.2.9-x64-mingw32.gem"
$glibTempLoc = ".\glib2-3.2.9-x64-mingw32.gem"

$cairogobjectURL = "https://rubygems.org/downloads/cairo-gobject-3.2.9-x64-mingw32.gem"
$cairogobjectTempLoc = ".\cairo-gobject-3.2.9-x64-mingw32.gem"

$gobjectURL = "https://rubygems.org/downloads/gobject-introspection-3.2.9-x64-mingw32.gem"
$gobjectTempLoc = ".\gobject-introspection-3.2.9-x64-mingw32.gem"

$gioURL = "https://rubygems.org/downloads/gio2-3.2.9-x64-mingw32.gem"
$gioTempLoc = ".\gio2-3.2.9-x64-mingw32.gem"

$atkURL = "https://rubygems.org/downloads/atk-3.2.9-x64-mingw32.gem"
$atkTempLoc = ".\atk-3.2.9-x64-mingw32.gem"

$gdkURL = "https://rubygems.org/downloads/gdk_pixbuf2-3.2.9-x64-mingw32.gem"
$gdkTempLoc = ".\gdk_pixbuf2-3.2.9-x64-mingw32.gem"

$pangoURL = "https://rubygems.org/downloads/pango-3.2.9-x64-mingw32.gem"
$pangoTempLoc = ".\pango-3.2.9-x64-mingw32.gem"

$gtkURL = "https://rubygems.org/downloads/gtk2-3.2.9-x64-mingw32.gem"
$gtkTempLoc = ".\gtk2-3.2.9-x64-mingw32.gem"

$lStoreLoc = ".\"


echo "Preparing to install Ruby and gems"

Start-Process $rubyTempLoc -ArgumentList "/verysilent", "/tasks=assocfiles,modpath" -Wait

Start-Sleep -s 1

#refresh path to find the newly installed executables

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

echo "Testing the Ruby basic installation."

& "ruby" -v
echo ""
& "gem" list
Start-Sleep -s 1

echo ""
echo "Ruby installed with base gems.  Updating Rubygems."
echo "This will take a couple of moments."
echo ""

& "gem" update --system --no-document | Out-Null

echo "Rubygems updated.  Installing gems required by Lich."
echo ""

& "gem" install pkg-config:1.3.2 --no-document
& "gem" install native-package-installer:1.0.3 --no-document
#cd $lStoreLoc
& "gem" install --local sqlite3-1.3.13-x64-mingw32.gem --no-document
& "gem" install --local gtk2-3.2.9-x64-mingw32.gem --no-document

echo ""
echo "Gems installed"
echo "Checking values for install log"
echo ""

Start-Sleep -s 1
& "ruby" -v

Start-Sleep -s 5
& "gem" list

echo ""

Copy-Item ".\fly64.ico" -Destination "$HOME\Documents"
Start-Sleep -s 1
<#
#Set this bad boy up so we don't need to use admin privileges
#>

$AdObj = New-Object System.Security.Principal.NTAccount($player_Name)
$strSID = $AdObj.Translate([System.Security.Principal.SecurityIdentifier])
$userSID = $strSID.value

reg add "HKU\$userSID\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Ruby24-x64\bin\rubyw.exe" /d "~ WIN7RTM"

echo "Installing Lich"

Expand-Archive .\lich-4.6.49.zip -DestinationPath $HOME

echo "Creating Shortcut to run Lich"

$rubyDir = "C:\Ruby24-x64\bin\rubyw.exe"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\GSIV-Lich.lnk")
$Shortcut.TargetPath = $rubyDir
$Shortcut.Arguments = "$HOME\lich\lich.rbw"
$Shortcut.IconLocation = "$HOME\Documents\fly64.ico, 0"
$Shortcut.Save()

echo ""
echo "Installing Simutronics Launcher"

& ".\lnchInst" /S


echo "Installing StormFront"

& ".\StormFront" /S


echo ""
echo "Done"


Stop-Transcript

