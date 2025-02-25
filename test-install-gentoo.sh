#!/bin/bash

# Test script for install-gentoo.sh

# Mock functions to avoid actual system changes
emerge() { echo "MOCK: emerge $*"; return 0; }
eselect() { echo "MOCK: eselect $*"; return 0; }
cp() { echo "MOCK: cp $*"; return 0; }
pipx() { echo "MOCK: pipx $*"; return 0; }
git() { echo "MOCK: git $*"; return 0; }
curl() { echo "MOCK: curl $*"; return 0; }
sleep() { echo "MOCK: sleep $*"; }

# Source the functions from install-gentoo.sh
source_functions() {
    grep -A 40 "^ask_yn" ../install-gentoo.sh | 
    grep -B 100 "^# Main selection" > /tmp/gentoo_functions
    source /tmp/gentoo_functions
}

# Test ask_yn function (returns 1 for yes, 0 for no)
test_ask_yn() {
    echo "Testing ask_yn function..."
    
    # Mock read to return "y"
    read() {
        REPLY="y"
    }
    
    ask_yn "Test question"
    result=$?
    if [ $result -eq 1 ]; then
        echo "✅ ask_yn correctly returned 1 for 'y'"
    else
        echo "❌ ask_yn should return 1 for 'y', got $result"
    fi
    
    # Mock read to return "n"
    read() {
        REPLY="n"
    }
    
    ask_yn "Test question"
    result=$?
    if [ $result -eq 0 ]; then
        echo "✅ ask_yn correctly returned 0 for 'n'"
    else
        echo "❌ ask_yn should return 0 for 'n', got $result"
    fi
}

# Test ask_ny function (returns 0 for yes, 1 for no)
test_ask_ny() {
    echo "Testing ask_ny function..."
    
    # Mock read to return "y"
    read() {
        REPLY="y"
    }
    
    ask_ny "Test question"
    result=$?
    if [ $result -eq 0 ]; then
        echo "✅ ask_ny correctly returned 0 for 'y'"
    else
        echo "❌ ask_ny should return 0 for 'y', got $result"
    fi
    
    # Mock read to return "n"
    read() {
        REPLY="n"
    }
    
    ask_ny "Test question"
    result=$?
    if [ $result -eq 1 ]; then
        echo "✅ ask_ny correctly returned 1 for 'n'"
    else
        echo "❌ ask_ny should return 1 for 'n', got $result"
    fi
}

# Test ask_choice function
test_ask_choice() {
    echo "Testing ask_choice function..."
    
    # Mock read to return valid choice
    read() {
        REPLY="1"
    }
    
    result=$(ask_choice "Choose an option" "1 2 3")
    if [ "$result" = "1" ]; then
        echo "✅ ask_choice correctly returned chosen option '1'"
    else
        echo "❌ ask_choice should return '1', got '$result'"
    fi
    
    # Test invalid then valid input
    count=0
    read() {
        count=$((count + 1))
        if [ $count -eq 1 ]; then
            REPLY="4"  # Invalid option
        else
            REPLY="2"  # Valid option
        fi
    }
    
    result=$(ask_choice "Choose an option" "1 2 3")
    if [ "$result" = "2" ]; then
        echo "✅ ask_choice correctly handled invalid input and returned '2'"
    else
        echo "❌ ask_choice should return '2' after invalid input, got '$result'"
    fi
}

# Test menu flow with mocked choices
test_menu_flow() {
    echo "Testing menu flow..."
    
    # Mock the functions used in the menu
    ask_choice() {
        case "$1" in
            *"Which distro"*)
                echo "2"  # Choose Gentoo
                ;;
            *"doas or sudo"*)
                echo "1"  # Choose doas
                ;;
            *)
                echo "1"
                ;;
        esac
    }
    
    ask_yn() {
        return 1  # Return "yes" for all ask_yn prompts
    }
    
    ask_ny() {
        return 0  # Return "yes" for all ask_ny prompts
    }
    
    # Create a temporary script with the menu code
    grep -A 500 "^# Main selection" ../install-gentoo.sh > /tmp/gentoo_menu
    
    # Run the menu code in a subshell to capture output
    output=$(bash /tmp/gentoo_menu 2>&1)
    
    # Check if the output contains expected strings
    if [[ "$output" == *"Do you have enabled kzd"* && 
          "$output" == *"Do you want to install dependencies"* ]]; then
        echo "✅ Menu flow tested successfully"
    else
        echo "❌ Menu flow test failed"
        echo "Output: $output"
    fi
}

# Run all tests
run_tests() {
    source_functions
    echo "Running tests for install-gentoo.sh..."
    echo "====================================="
    test_ask_yn
    test_ask_ny
    test_ask_choice
    test_menu_flow
    echo "====================================="
    echo "Tests completed!"
}

# Run the tests
run_tests
