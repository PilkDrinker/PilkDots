#!/bin/bash
# Script to run all tests

# Initialize counters
TOTAL_FAILURES=0
TOTAL_SUCCESSES=0

echo "Running installation script tests"
echo "================================"

# Run Arch tests
echo -e "\nTesting install-arch.sh"
echo "-------------------------"
bash ./test-install-arch.sh
ARCH_EXIT=$?
if [ $ARCH_EXIT -ne 0 ]; then
    TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
else
    TOTAL_SUCCESSES=$((TOTAL_SUCCESSES + 1))
fi

# Run Gentoo tests
echo -e "\nTesting install-gentoo.sh"
echo "---------------------------"
bash ./test-install-gentoo.sh
GENTOO_EXIT=$?
if [ $GENTOO_EXIT -ne 0 ]; then
    TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
else
    TOTAL_SUCCESSES=$((TOTAL_SUCCESSES + 1))
fi

# Print summary
echo -e "\nTest Summary"
echo "============"
echo "Successes: $TOTAL_SUCCESSES"
echo "Failures: $TOTAL_FAILURES"

# Exit with failure if any tests failed
[ $TOTAL_FAILURES -eq 0 ] || exit 1
