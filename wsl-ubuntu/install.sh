#!/bin/bash

BASE_DIR="$HOME/.post_install/wsl-ubuntu"
STATUS_FILE="$HOME/.post_install/wsl-ubuntu/install.log"
DIRECTORIES=("deps" "terminal")
ERROR_LOG="$BASE_DIR/error.log"

> "$ERROR_LOG"

for DIR in "${DIRECTORIES[@]}"; do
	SCRIPT_DIR="$BASE_DIR/$DIR"
	echo "Running installers in $DIR..."

	for script in "$SCRIPT_DIR"/*.sh; do
		echo "Running "$script

		if grep -q "$(basename "$script")" "$STATUS_FILE"; then
			echo "Skipping $(basename "$script"), already installed."
			continue
		fi

		bash "$script" >> "$ERROR_LOG" 2>&1

		if [ $? -ne 0 ]; then
			echo "$(date '+%Y-%m-%d %H:%M:%S') - Error in $(basename "$script")" >> "$ERROR_LOG"
		else
			echo "Completed $(basename "$script") successfully."
			echo "$(basename "$script")" >> "$STATUS_FILE"
		fi

	done

done

# Check missing installations

declare -a ALL_SCRIPTS

for DIR in "${DIRECTORIES[@]}"; do
	for script in "$BASE_DIR/$DIR"/*.sh; do
		ALL_SCRIPTS+=("$(basename "$script")")
	done
done

COMPLETED_SCRIPTS=()
if [ -f "$STATUS_FILE" ]; then
	while IFS= read -r line; do
		COMPLETED_SCRIPTS+=("$line")
	done < "$STATUS_FILE"
fi
MISSING_SCRIPTS=()
for script in "${ALL_SCRIPTS[@]}"; do
	if [[ ! " ${COMPLETED_SCRIPTS[*]} " =~ " $script " ]]; then
		MISSING_SCRIPTS+=("$script")
	fi
done

if [ ${#MISSING_SCRIPTS[@]} -eq 0 ]; then
	echo "All scripts are marked as completed in $STATUS_FILE."
	sudo apt -y autoremove
else
	echo "The following scripts have not been installed:"
	for script in "${MISSING_SCRIPTS[@]}"; do
		echo "-$script"
	done
fi
