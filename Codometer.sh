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

white=$(tput setaf 7)
blue=$(tput setaf 6)
green=$(tput setaf 2)
red=$(tput setaf 1)
nc=$(tput sgr0) # No Color

function progress() {
	echo ""
	echo -n "Calculating the distance..."
	while true
	do
		echo -n "."
		sleep 1
	done
}

# Ask for chars per inch variable
read -e -p "${blue}In your text editor, how many characters
fit into one inch on your screen (if no
answer is given, this will default to 12)?${nc} " chars_per_inch
chars_per_inch=${chars_per_inch:-12}

# If $chars_per_inch is an int
if [[ $chars_per_inch =~ ^-?[0-9]+$ ]]; then

	# Show progress text and save PID to kill it later
	progress &
	PROGRESS_PID=$!

	# Get the number of chars in the entire directory
	chars=$(find . \( ! -regex '.*/\..*' \) \
		! -name 'Codometer.sh' -type f -exec wc -m {} \; 2> /dev/null \
		| awk '{total += $1} END{print total}')

	# Stop the progress text
	echo ""
	kill $PROGRESS_PID
	wait $! 2>/dev/null

	# Check if bc is installed for doing decimal work.
	# If not, we will fall back to expr (no decimals).
	bc_installed=true
	hash bc 2>/dev/null || bc_installed=false

	if $bc_installed; then
		inches=$(echo "scale=4; $chars / $chars_per_inch" | bc)
		feet=$(echo "scale=4; $chars / $chars_per_inch / 12" | bc)
		miles=$(echo "scale=4; $chars / $chars_per_inch / 12 / 5280" | bc)
	else
		inches=$(expr $chars / $chars_per_inch)
		feet=$(expr $chars / $chars_per_inch / 12)
		miles=$(expr $chars / $chars_per_inch / 12 / 5280)
	fi

	echo ""
	echo "${white}➤  ${green}$miles miles of code"
	echo "...or $feet feet of code"
	echo "...or $inches inches of code.${nc}"

	if ! $bc_installed; then
		echo ""
		echo "(You don't have bc installed, so we can't"
		echo "calculate decimals. Please install bc for"
		echo "more precision in the above distances.)"
	fi

else

	echo "${red}Please try again with a valid number.${nc}"
	exit;

fi
