#!/bin/bash

input_str="SRE-2000"

normalized_str=$(echo "${input_str##*/}" | tr '[:upper:]' '[:lower:]')
echo "$normalized_str"

inpu_str="feature/SRE-2000"

normalize_str=$(echo "${inpu_str##*/}" | tr '[:upper:]' '[:lower:]')
echo "$normalize_str"