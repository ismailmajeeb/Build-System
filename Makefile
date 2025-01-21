# Compiler and flags
CXX := g++
CXXFLAGS := -pedantic-errors -std=c++20 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion
LDFLAGS :=

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

# Target executable (defaults to the name of the first source file)
TARGET := $(BIN_DIR)/my_program

# Supported C++ source file extensions
SRC_EXTS := .cpp .cc .cxx
HDR_EXTS := .h .hpp

# Find all source files in the SRC_DIR with supported extensions
SRCS := $(foreach ext, $(SRC_EXTS), $(wildcard $(SRC_DIR)/*$(ext)))
OBJS := $(SRCS:$(SRC_DIR)/%=$(OBJ_DIR)/%.o)

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
$(OBJ_DIR)/%.cpp.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR) $(SRC_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/%.cc.o: $(SRC_DIR)/%.cc | $(OBJ_DIR) $(SRC_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/%.cxx.o: $(SRC_DIR)/%.cxx | $(OBJ_DIR) $(SRC_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up build artifacts
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "Cleanup complete!"

# Phony targets
.PHONY: all clean
