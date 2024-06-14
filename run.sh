#!/bin/bash

i=0
while true; do
    # Run your comma

    # Check if the output of the command is 0
    if [ $i -eq 5 ]; then
        echo "Command output is 5. Exiting loop. $i"
        break  # Exit the loop
    else
        echo "Command output is not 5. Continuing loop."
    fi
    
    ((i+=1))	
    # Add any additional logic or sleep if needed
    # sleep 1  # Example: sleep for 1 second before next iteration
done

echo "Loop finished"
