#!/bin/bash

# Initialize the variable
variable=0

# While loop continues until variable is equal to 5
while [ "$variable" -ne 5 ]; do
    echo Variable is currently: $variable
    # Increment the variable
    ((variable++))
done

echo "Loop finished"