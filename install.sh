#!/bin/bash

inst_dir=/usr/local/bin
chmod +x seas.sh
cp seas.sh "$inst_dir/seas.sh"

if [[ -f "$inst_dir" -eq PATH="/usr/local/bin:$PATH" ]]
then
  echo "installation complete"
else
  cd /usr/local/bin
  echo -e "seas.sh is not in PATH\n To use got local/bin directory and run ./seash.sh" 
  
