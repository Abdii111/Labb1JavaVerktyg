#!/bin/bash
 # Maximal filstorlek (1MB i bytes)
 max_size=$((1024 * 1024))
 exit_code=0
 # Funktion för att få filstorlek på olika system
 get_file_size() {
 if [[ "$OSTYPE" == "darwin"* ]]; then
 # macOS
 stat -f%z "$1"
 else
 # Linux
 stat -c%s "$1"
 fi
 }
 # Kontrollera varje fil som ska committas
 for file in $(git diff --cached --name-only); do
 if [ -f "$file" ]; then
 size=$(get_file_size "$file")

 if [ $size -gt $max_size ]; then
 size_mb=$(echo "scale=2; $size/1048576" | bc)
 echo "Error: $file är större än 1MB ($size_mb MB)"
 exit_code=1
 fi
 fi
 done
 if [ $exit_code -eq 0 ]; then
 echo "Alla filer är mindre än 1MB"
 fi
 exit $exit_code
