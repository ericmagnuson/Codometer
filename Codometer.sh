#!/bin/bash
#
# Codometer
# © 2013 Eric Magnuson <eric@ericmagnuson.me>
# MIT License (http://opensource.org/licenses/MIT)
#
# Calculate how many miles of code are written in a directory and its
# subdirectories, as if each character were one after the other on one
# line. Assumes 12 characters per 1 inch of screen space.
#
# Instructions: Save and run this script in the topmost directory of
# your project. Alternatively, run the script from Github (without
# saving it to your computer) by using the following command:
#
# bash < <(curl -s https://raw.github.com/ericmagnuson/Codometer/master/Codometer.sh)

chars=$(find . \( ! -regex '.*/\..*' \) -type f -exec wc -m {} \; 2> /dev/null | awk '{total += $1} END{print total}')

inches=$(echo "scale=2; $chars / 12" | bc)
feet=$(echo "scale=2; $chars / 12 / 12" | bc)
miles=$(echo "scale=2; $chars / 12 / 12 / 5280" | bc)

echo "$miles miles of code"
echo "...or $feet feet of code"
echo "...or $inches inches of code."