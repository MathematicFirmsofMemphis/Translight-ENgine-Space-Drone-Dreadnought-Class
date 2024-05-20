@echo off
setlocal enabledelayedexpansion

rem Define the number of light rays to process
set "numRays=3"

rem Define the fields for each light ray
set "Directions=0.707,0.707,0.0 0.5,0.5,0.707 0.0,0.0,1.0"
set "Intensities=100 200 150"
set "Wavelengths=500 600 550"
set "NuclearEnergyLevels=5000 6000 5500"

rem Split the fields into arrays
set "Directions=!Directions: =^
!"
set "Intensities=!Intensities: =^
!"
set "Wavelengths=!Wavelengths: =^
!"
set "NuclearEnergyLevels=!NuclearEnergyLevels: =^
!"

rem Loop through each light ray
for /l %%i in (1,1,%numRays%) do (
    rem Get the fields for the current light ray
    for /f "tokens=1,2,3,4 delims=," %%a in ("!Directions!") do (
        set "DirectionX=%%a"
        set "DirectionY=%%b"
        set "DirectionZ=%%c"
        set "Directions=%%d"
    )
    for /f "tokens=1 delims= " %%a in ("!Intensities!") do (
        set "Intensity=%%a"
        set "Intensities=!Intensities:* =!"
    )
    for /f "tokens=1 delims= " %%a in ("!Wavelengths!") do (
        set "Wavelength=%%a"
        set "Wavelengths=!Wavelengths:* =!"
    )
    for /f "tokens=1 delims= " %%a in ("!NuclearEnergyLevels!") do (
        set "NuclearEnergyLevel=%%a"
        set "NuclearEnergyLevels=!NuclearEnergyLevels:* =!"
    )

    rem Add 10 to Intensity
    set /a "Intensity+=10"

    rem Convert each field to binary representation
    set /a "DirectionX_Binary=0x3FBB4000"
    set /a "DirectionY_Binary=0x3FBB4000"
    set /a "DirectionZ_Binary=0"
    set /a "Intensity_Binary=0x64000000"
    set /a "Wavelength_Binary=0x1F400000"
    set /a "NuclearEnergyLevel_Binary=%NuclearEnergyLevel%"

    rem Display the binary representation
    echo Light Ray %%i:
    echo | set /p="Direction X: "
    call :PrintBinary !DirectionX_Binary!
    echo.
    echo | set /p="Direction Y: "
    call :PrintBinary !DirectionY_Binary!
    echo.
    echo | set /p="Direction Z: "
    call :PrintBinary !DirectionZ_Binary!
    echo.
    echo | set /p="Intensity:   "
    call :PrintBinary !Intensity_Binary!
    echo.
    echo | set /p="Wavelength:  "
    call :PrintBinary !Wavelength_Binary!
    echo.
    echo | set /p="Nuclear Energy Level: "
    call :PrintBinary !NuclearEnergyLevel_Binary!
    echo.
    echo.
)

pause
exit

:PrintBinary
set "hexValue=%1"
set "binary="
:Loop
set /a "bit=%hexValue% & 1"
set "binary=%bit%%binary%"
set /a "hexValue=%hexValue% >> 1"
if not "%hexValue%"=="0" goto Loop
echo %binary%
exit /b
