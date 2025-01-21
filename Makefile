# Compiler and flags
CXX := g++
CXXFLAGS := -pedantic-errors -std=c++20 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion
LDFLAGS :=

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

# Get the base name of the source file being compiled
SOURCE := $(wildcard $(SRC_DIR)/*.cpp)
TARGET := $(BIN_DIR)/$(notdir $(basename $(SOURCE)))

# Object files
OBJS := $(SOURCE:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

# Debug vs Release mode
ifeq ($(mode), release)
    CXXFLAGS += -O2 -DNDEBUG
else
    CXXFLAGS += -ggdb
    mode := debug
endif

# Default target
all: $(TARGET)

# Ensure directories exist before building
$(OBJ_DIR) $(BIN_DIR) $(SRC_DIR):
	@mkdir -p $@

# Link the object files to create the executable
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)
	@echo "Build complete! ($(mode) mode)"

# Compile source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR) $(SRC_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up build artifacts
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "Cleanup complete!"

# Phony targets
.PHONY: all clean
