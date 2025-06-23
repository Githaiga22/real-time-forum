APP_NAME := forum
SRC_DIR := backend
BUILD_DIR := build

# Detect OS
OS := $(shell uname -s)
ARCH := $(shell uname -m)

# Default target
.PHONY: all
all: build

# Clean up previous builds
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)/ $(APP_NAME)
	@echo "Cleanup completed."

# Format Go code to ensure consistency
.PHONY: fmt
fmt:
	@echo "Formatting Go code..."
	go fmt ./...

# Run linting to catch potential issues
.PHONY: lint
lint:
	@echo "Linting Go code..."
	golangci-lint run

# Run the Go application
.PHONY: run
run:
	@echo "Running $(APP_NAME)..."
	clear; go run $(SRC_DIR)/main.go

# Build the Go application
.PHONY: build
build:
	@echo "Building $(APP_NAME)..."
	mkdir -p $(BUILD_DIR)
	GOOS=$(OS) GOARCH=$(ARCH) go build -o $(BUILD_DIR)/$(APP_NAME) $(SRC_DIR)/main.go
	@echo "Build completed: $(OUTPUT_DIR)/$(APP_NAME)"

# Install dependencies
.PHONY: deps
deps:
	@echo "Installing dependencies..."
	go mod tidy

# Test the Go application
.PHONY: test
test:
	@echo "Running tests..."
	go test ./...

# Install the built binary globally (optional)
.PHONY: install
install: build
	install -m 755 $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/$(APP_NAME)

# Uninstall the installed binary (optional)
.PHONY: uninstall
uninstall:
	rm -f /usr/local/bin/$(APP_NAME)
