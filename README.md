# C++ Build Systems

This Repository provides two complete build system configurations for C++ projects:

1. **Makefile** - Traditional GNU Make setup (Linux-focused)
2. **CMakeLists.txt** - Modern cross-platform CMake configuration

## Table of Contents

- [Build System Comparison](#build-system-comparison)
- [Prerequisites](#prerequisites)
- [Makefile Usage (Linux/MacOS)](#makefile-usage-linuxmacos)
  - [Key Features](#makefile-key-features)
  - [Commands](#makefile-commands)
- [CMake Usage (Windows/Linux/MacOS)](#cmake-usage-windowslinuxmacos)
  - [Key Features](#cmake-key-features)
  - [Windows Setup](#windows-setup)
  - [Cross-Platform Commands](#cmake-commands)
- [Project Structure](#project-structure)
- [Choosing a Build System](#choosing-a-build-system)

## Build System Comparison

| Feature                 | Makefile                    | CMake                       |
| ----------------------- | --------------------------- | --------------------------- |
| **Primary OS**          | Linux/MacOS                 | Windows/Linux/MacOS         |
| **Compiler Support**    | GCC/Clang                   | MSVC/GCC/Clang              |
| **Build Modes**         | Debug/Release (via `mode=`) | Debug/Release (native)      |
| **Dependency Tracking** | Manual                      | Automatic                   |
| **IDE Integration**     | Basic                       | Excellent (VS, CLion, etc.) |
| **Header Handling**     | Implicit                    | Explicit tracking           |

## Prerequisites

- **Makefile**:

  - GNU Make 4.1+
  - GCC 11+ or Clang 14+
  - Linux/MacOS or Windows WSL

- **CMake**:
  - CMake 3.15+
  - Any C++20 compiler:
    - MSVC 2022 (Windows)
    - MinGW-w64 8.1+ (Windows)
    - GCC 11+ (Linux)
    - Clang 14+ (MacOS)

## Makefile Usage (Linux/MacOS)

### Makefile Key Features

- Strict C++20 compliance checks
- Automatic source discovery
- Debug/Release mode switching
- Clean build artifacts

### Makefile Commands

```bash
# Build debug version (default)
make

# Build release version
make mode=release

# Clean build artifacts
make clean

# Custom target name
make TARGET=bin/my_app
```

### Example Workflow

```bash
# Clone project
git clone https://github.com/your/project.git
cd project

# Build debug version
make

# Run program
./bin/my_program

# Clean build
make clean
```

## CMake Usage (Windows/Linux/MacOS)

### CMake Key Features

- Cross-platform support
- IDE project generation
- Compiler-agnostic configuration
- Detailed build reports
- Header file integration
- Multi-configuration support

### Windows Setup

1. Install dependencies:

   - [Visual Studio 2022] with C++ tools
   - [CMake] 3.15+
   - [Ninja] or [MinGW] (optional)

2. Open terminal in project directory:

```powershell
# Generate Visual Studio solution
cmake -S . -B build -G "Visual Studio 17 2022"

# Or for MinGW
cmake -S . -B build -G "MinGW Makefiles"
```

### CMake Commands

```bash
# Configure project (general)
cmake -S . -B build [-G "Generator Name"]

# Build project
cmake --build build [--config Release]

# Clean artifacts
cmake --build build --target clean-all

# Run executable (Windows)
.\bin\main.exe

# Run executable (Linux/MacOS)
./bin/main
```

**Common Generators:**
| Platform | Generator Command |
|-----------|--------------------------------|
| Windows | `-G "Visual Studio 17 2022"` |
| | `-G "MinGW Makefiles"` |
| Linux | `-G "Unix Makefiles"` |
| MacOS | `-G "Xcode"` |

**Example Workflow:**

```powershell
# Configure with MinGW
cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release

# Build release version
cmake --build build

# Clean everything
cmake --build build --target clean-all
```

## Project Structure

Both build systems expect:

```
project-root/
├── src/        # Source files (.cpp, .cc, .cxx)
│   ├── main.cpp
│   └── ...
├── bin/        # Generated executables
├── obj/        # Object files (Makefile only)
├── Makefile    # Linux build config
└── CMakeLists.txt # Cross-platform config
```

## Choosing a Build System

1. **Use Makefile if:**

   - Developing exclusively on Linux/MacOS
   - Need minimal setup
   - Prefer direct compiler control
   - Working with legacy systems

2. **Use CMake if:**
   - Developing on Windows
   - Need IDE integration
   - Require cross-platform builds
   - Want future-proof configuration
   - Managing complex projects

Both systems enforce:

- Strict C++20 compliance
- Warnings-as-errors policy
- Clean separation of source/build artifacts
- Multiple compiler support

**Note:** The CMake configuration is recommended for new projects due to its cross-platform capabilities and modern features.
