#!/bin/bash

while true; do
    # Run your command (replace "your_command" with your actual command)
    output=$(your_command)

    # Check if the output of the command is 0
    if [ "$output" -eq 0 ]; then
        echo "Command output is 0. Exiting loop."
        break  # Exit the loop
    else
        echo "Command output is not 0. Continuing loop."
    fi

    # Add any additional logic or sleep if needed
    # sleep 1  # Example: sleep for 1 second before next iteration
done

echo "Loop finished"