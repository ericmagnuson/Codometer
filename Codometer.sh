#!/bin/bash
#
# Codometer
# © 2013 Eric Magnuson <eric@ericmagnuson.me>
# MIT License (http://opensource.org/licenses/MIT)
#
# Calculate how many miles of code are written in a directory and its
# subdirectories, as if each character were one after the other on one
# line. Defaults to 12 characters per 1 inch of screen space.
#
# Instructions: Save and run this script in the topmost directory of
# your project. Alternatively, run the script from Github (without
# saving it to your computer) by using the following command:
#
# bash <(curl -s https://raw.github.com/ericmagnuson/Codometer/master/Codometer.sh)

blue=$(tput setaf 6)
red=$(tput setaf 1)
green=$(tput setaf 2)
nc=$(tput sgr0) # No Color

read -e -p "${blue}In your text editor, how many characters
fit into one inch on your screen (if no
answer is given, this will default to 12)?${nc} " chars_per_inch
chars_per_inch=${chars_per_inch:-12}

if [[ $chars_per_inch =~ ^-?[0-9]+$ ]]; then

	chars=$(find . \( ! -regex '.*/\..*' \) \
		! -name 'Codometer.sh' -type f -exec wc -m {} \; 2> /dev/null \
		| awk '{total += $1} END{print total}')

	inches=$(echo "scale=2; $chars / $chars_per_inch" | bc)
	feet=$(echo "scale=2; $chars / $chars_per_inch / 12" | bc)
	miles=$(echo "scale=2; $chars / $chars_per_inch / 12 / 5280" | bc)

	echo "${green}$miles miles of code"
	echo "...or $feet feet of code"
	echo "...or $inches inches of code.${nc}"

else

	echo "${red}Please try again with a valid number.${nc}"
	exit;

fi
