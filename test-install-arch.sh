#!/bin/bash

# Test script for install-arch.sh

# Source the original script with function overrides to prevent actual execution
TEST_MODE=true

# Mock functions to avoid actual system changes
command_exists() {
    case "$1" in
        "yay") return ${MOCK_YAY_INSTALLED:-1} ;;
        "paru") return ${MOCK_PARU_INSTALLED:-1} ;;
        *) return 1 ;;
    esac
}

# Create dummy functions for testing if they don't exist in the script
ask_yn() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Override system-modifying commands
pacman() { echo "MOCK: pacman $*"; return 0; }
yay() { echo "MOCK: yay $*"; return 0; }
paru() { echo "MOCK: paru $*"; return 0; }
git() { echo "MOCK: git $*"; return 0; }
curl() { echo "MOCK: curl $*"; return 0; }
makepkg() { echo "MOCK: makepkg $*"; return 0; }

# Source script functions without executing main code
source_functions() {
    if [ -f "./install-arch.sh" ]; then
        # Extract and source only the functions
        grep -A 100 "^# Function to\|^ask_yn\|^error_exit\|^command_exists" ./install-arch.sh | 
        grep -B 100 "^# Check if the script\|^# Main script" > /tmp/arch_functions
        
        if [ -s /tmp/arch_functions ]; then
            source /tmp/arch_functions
        else
            echo "No functions found in install-arch.sh, using mock functions"
        fi
    else
        echo "install-arch.sh not found, using mock functions"
    fi
}

# Test ask_yn function
test_ask_yn() {
    echo "Testing ask_yn function..."
    
    # Mock read to return "y"
    read() {
        REPLY="y"
    }
    if ask_yn "Test question"; then
        echo "✅ ask_yn correctly returned 0 for 'y'"
    else
        echo "❌ ask_yn should return 0 for 'y'"
    fi
    
    # Mock read to return "n"
    read() {
        REPLY="n"
    }
    if ask_yn "Test question"; then
        echo "❌ ask_yn should return 1 for 'n'"
    else
        echo "✅ ask_yn correctly returned 1 for 'n'"
    fi
}

# Test error_exit function
test_error_exit() {
    echo "Testing error_exit function..."
    
    # Capture the error message
    ERROR_MESSAGE=$(error_exit "Test error" 2>&1)
    
    if [[ "$ERROR_MESSAGE" == *"Test error"* ]]; then
        echo "✅ error_exit shows correct message"
    else
        echo "❌ error_exit did not show expected message"
    fi
}

# Test command_exists function
test_command_exists() {
    echo "Testing command_exists function..."
    
    # Test when command exists
    MOCK_YAY_INSTALLED=0
    if command_exists "yay"; then
        echo "✅ command_exists correctly detected yay as installed"
    else
        echo "❌ command_exists should detect yay as installed"
    fi
    
    # Test when command doesn't exist
    MOCK_YAY_INSTALLED=1
    if command_exists "yay"; then
        echo "❌ command_exists should detect yay as not installed"
    else
        echo "✅ command_exists correctly detected yay as not installed"
    fi
}

# Run all tests
run_tests() {
    source_functions
    echo "Running tests for install-arch.sh..."
    echo "====================================="
    test_ask_yn
    test_error_exit
    test_command_exists
    echo "====================================="
    echo "Tests completed!"
}

# Run the tests
run_tests
