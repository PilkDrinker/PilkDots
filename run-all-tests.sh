#!/bin/bash

# Script to run all tests

echo "Running installation script tests"
echo "================================"

echo -e "\nTesting install-arch.sh"
echo "-------------------------"
bash ./test-install-arch.sh

echo -e "\nTesting install-gentoo.sh"
echo "---------------------------"
bash ./test-install-gentoo.sh

echo -e "\nAll tests completed!"
