# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -pedantic -g

# Directories and files
BIN_DIR = bin
PANDORA_SRC_DIR = pandora/src
PANDORA_BIN = $(BIN_DIR)/pandora
PANDORA_SRCS = $(PANDORA_SRC_DIR)/pandora.cpp
PANDORA_OBJS = $(PANDORA_SRC_DIR)/pandora.o
PANDORA_TEST = pandora/tests/test_pandora.sh

# Default target
.PHONY: all
all: $(BIN_DIR) pandora

# Create bin directory
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Build pandora binary
pandora: $(PANDORA_BIN)

$(PANDORA_BIN): $(PANDORA_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(PANDORA_SRC_DIR)/%.o: $(PANDORA_SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Run tests for pandora
.PHONY: test
test: pandora
	$(PANDORA_TEST)

# Clean up build artifacts
.PHONY: clean
clean:
	rm -f $(PANDORA_BIN) $(PANDORA_OBJS)
	rmdir --ignore-fail-on-non-empty $(BIN_DIR)
