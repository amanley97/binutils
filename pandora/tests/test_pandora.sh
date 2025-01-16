#!/bin/bash

# Define variables
EXECUTABLE=bin/pandora
TEST_BINARY=test.bin
OUTPUT_FILE=output.txt
EXPECTED_OUTPUT=expected_output.txt

# Check if the executable exists
if [[ ! -f $EXECUTABLE ]]; then
    echo "Error: $EXECUTABLE not found. Build it first with 'make'."
    exit 1
fi

# Create a test binary file
echo -ne "Hello, World!\n\x00\x01\x02\x03\x04" > $TEST_BINARY

# Run the hexdumper on the test binary
$EXECUTABLE $TEST_BINARY > $OUTPUT_FILE 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Error: Execution of $EXECUTABLE failed."
    rm -f $TEST_BINARY $OUTPUT_FILE $EXPECTED_OUTPUT
    exit 1
fi

# Create expected output manually
cat > $EXPECTED_OUTPUT <<EOF
00000000  48 65 6c 6c 6f 2c 20 57 6f 72 6c 64 21 0a 00 01  Hello, World!...
00000010  02 03 04                                         ...
EOF

# Compare the output
if diff -q $OUTPUT_FILE $EXPECTED_OUTPUT > /dev/null; then
    echo "Test passed!"
else
    echo "Test failed! Differences:"
    diff $OUTPUT_FILE $EXPECTED_OUTPUT
fi

# Cleanup
rm -f $TEST_BINARY $OUTPUT_FILE $EXPECTED_OUTPUT
