# Makefile for coding-machine project
# Supports C++ and Python projects

# Compiler settings
CXX = clang++
CXXFLAGS = -std=c++20 -Wall -Wextra -O2
DEBUG_FLAGS = -g -DDEBUG
PYTHON = python3

# Directories
ORDER_BOOK_DIR = order_book
BUILD_DIR = build
BIN_DIR = bin

# Targets
ORDER_BOOK_TARGET = $(BIN_DIR)/order_book
ORDER_BOOK_SRC = $(ORDER_BOOK_DIR)/order_book.cpp

# Default target
.PHONY: all
all: cpp-projects

# Create directories
$(BUILD_DIR):
    mkdir -p $(BUILD_DIR)

$(BIN_DIR):
    mkdir -p $(BIN_DIR)

# C++ Projects
.PHONY: cpp-projects
cpp-projects: order-book

.PHONY: order-book
order-book: $(ORDER_BOOK_TARGET)

$(ORDER_BOOK_TARGET): $(ORDER_BOOK_SRC) | $(BIN_DIR)
    $(CXX) $(CXXFLAGS) -o $@ $<

# Debug builds
.PHONY: debug-order-book
debug-order-book: $(BIN_DIR)
    $(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) -o $(BIN_DIR)/order_book_debug $(ORDER_BOOK_SRC)

# Python Projects
.PHONY: python-projects
python-projects:
    @echo "Running Python projects..."
    @find . -name "*.py" -path "./*/main.py" -exec echo "Found Python project: {}" \;
    @find . -name "*.py" -path "./*/main.py" -exec $(PYTHON) {} \;

# Run targets
.PHONY: run-order-book
run-order-book: order-book
    ./$(ORDER_BOOK_TARGET)

.PHONY: run-python
run-python: python-projects

# Clean
.PHONY: clean
clean:
    rm -rf $(BUILD_DIR) $(BIN_DIR)
    find . -name "*.pyc" -delete
    find . -name "__pycache__" -type d -exec rm -rf {} +

# Test targets
.PHONY: test-cpp
test-cpp:
    @echo "Running C++ tests..."
    # TODO: Add C++ test framework integration

.PHONY: test-python
test-python:
    @echo "Running Python tests..."
    $(PYTHON) -m pytest -v || echo "No pytest found or no tests"

.PHONY: test
test: test-cpp test-python

# Install dependencies
.PHONY: install-deps
install-deps:
    @echo "Installing dependencies..."
    # Python dependencies
    $(PYTHON) -m pip install --upgrade pip
    $(PYTHON) -m pip install pytest numpy pandas
    # C++ dependencies (if using package manager)
    # sudo apt-get update && sudo apt-get install build-essential clang

# Format code
.PHONY: format
format:
    @echo "Formatting code..."
    # Format C++ files
    find . -name "*.cpp" -o -name "*.hpp" -o -name "*.h" | xargs clang-format -i
    # Format Python files
    find . -name "*.py" | xargs python3 -m black || echo "Black not installed"

# Help
.PHONY: help
help:
    @echo "Available targets:"
    @echo "  all              - Build all C++ projects"
    @echo "  cpp-projects     - Build all C++ projects"
    @echo "  order-book       - Build order book project"
    @echo "  debug-order-book - Build order book with debug info"
    @echo "  python-projects  - Run Python projects"
    @echo "  run-order-book   - Build and run order book"
    @echo "  run-python       - Run Python projects"
    @echo "  test             - Run all tests"
    @echo "  test-cpp         - Run C++ tests"
    @echo "  test-python      - Run Python tests"
    @echo "  clean            - Remove build artifacts"
    @echo "  format           - Format all source code"
    @echo "  install-deps     - Install project dependencies"
    @echo "  help             - Show this help message"