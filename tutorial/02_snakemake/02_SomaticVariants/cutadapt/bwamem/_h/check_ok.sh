#!/bin/bash
# Author = Ricardo S Jacomini
# Sep 4, 2020

array=(`grep bwa ../_m/*.stderr | grep CMD | cut -d'/' -f3 | cut -d'.' -f1`)

printf "%s\n" "${array[@]}"

echo "${#array[@]}" | xargs -I % bash -c 'echo -e "\nCompleted: %"'

