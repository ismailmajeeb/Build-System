@echo off
echo Cleaning project...

if exist build (
    echo Removing build directory...
    rd /s /q build
) else (
    echo Build directory not found.
)

if exist bin (
    echo Removing bin directory...
    rd /s /q bin
) else (
    echo Bin directory not found.
)

if exist lib (
    echo Removing lib directory...
    rd /s /q lib
) else (
    echo Lib directory not found.
)

echo Clean complete.
