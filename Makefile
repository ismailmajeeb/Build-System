# ==============================================================================
# Build Configuration
# ==============================================================================

# Compiler selection and base flags
CXX := g++
CXXSTD := -std=c++23
WARNINGS := -Wall -Wextra -Weffc++ -Wconversion -Wsign-conversion -pedantic-errors
BASE_FLAGS := $(CXXSTD) $(WARNINGS)

# Directory structure
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
DEP_DIR := $(OBJ_DIR)/deps

# File extensions
SRC_EXTS := .cpp .cc .cxx
HDR_EXTS := .h .hpp .hxx

# ==============================================================================
# Target Configuration
# ==============================================================================

# Default target name (override with: make TARGET=something)
TARGET ?= $(BIN_DIR)/main

# Source files and object files
SRCS := $(wildcard $(SRC_DIR)/*$(firstword $(SRC_EXTS)))
OBJS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%.o,$(SRCS))
DEPS := $(patsubst $(SRC_DIR)/%,$(DEP_DIR)/%.d,$(SRCS))

# ==============================================================================
# Build Mode Configuration
# ==============================================================================

# Debug vs Release builds
ifeq ($(mode),release)
    CXXFLAGS := $(BASE_FLAGS) -O2 -DNDEBUG
    LDFLAGS :=
    mode := release
else
    CXXFLAGS := $(BASE_FLAGS) -g -O0
    LDFLAGS := -g
    mode := debug
endif

# ==============================================================================
# Build Rules
# ==============================================================================

# Default target (build only)
.PHONY: all
all: $(TARGET)
	@echo "Build complete ($(mode) mode)"

# Build and run
.PHONY: run
run: $(TARGET)
	@echo "Running $(TARGET)..."
	@./$(TARGET)

# Create directories
$(OBJ_DIR) $(BIN_DIR) $(DEP_DIR) $(SRC_DIR):
	@mkdir -p $@

# Link executable
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ -o $@
	@echo "Executable built: $@"

# Compilation with dependency generation
$(OBJ_DIR)/%.o: $(SRC_DIR)/% | $(OBJ_DIR) $(DEP_DIR)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MMD -MP -MF $(DEP_DIR)/$*.d -c $< -o $@

# Include generated dependencies
-include $(DEPS)

# ==============================================================================
# Utility Targets
# ==============================================================================

# Clean build artifacts
.PHONY: clean
clean:
	@rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "Build artifacts removed"

# Print variables (for debugging)
.PHONY: vars
vars:
	@echo "Sources: $(SRCS)"
	@echo "Objects: $(OBJS)"
	@echo "Dependencies: $(DEPS)"
	@echo "Compiler flags: $(CXXFLAGS)"
	@echo "Linker flags: $(LDFLAGS)"

# Help information
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all       - Build the project (default)"
	@echo "  run       - Build and run the executable"
	@echo "  clean     - Remove all build artifacts"
	@echo "  vars      - Show build variables"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Build options:"
	@echo "  mode=release - Build in release mode (optimized)"
	@echo "  mode=debug   - Build in debug mode (default, with debug symbols)"

# ==============================================================================
# Quality Assurance
# ==============================================================================

# Format source code (requires clang-format)
.PHONY: format
format:
	find $(SRC_DIR) -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.cpp' \) -exec clang-format -i {} \;
	@echo "Source code formatted"

# Static analysis (requires cppcheck)
.PHONY: analyze
analyze:
	cppcheck --enable=all --std=c++23 --suppress=missingIncludeSystem $(SRC_DIR)
	@echo "Static analysis complete"

# ==============================================================================
# Phony Targets Declaration
# ==============================================================================

.PHONY: all run clean help vars format analyze
