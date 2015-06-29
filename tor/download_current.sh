#!/bin/bash

# Script to download the current tor source code and check it for
# integrity using gpg.
# Copyright (C) 2015 Michael F. Herbst
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# A copy of the GNU General Public License can be found in the 
# file LICENSE or at <http://www.gnu.org/licenses/>.

BASEURL="https://www.torproject.org/dist/"

WGET_OPTIONS=""

#############################################

get_current_version() {
	local CURR_VER=$(wget -q $BASEURL -O - | grep -o -E "tor-([0-9]+\.)+tar" | sort -r -V -u | head -n1)
	if [ -z "$CURR_VER" ]; then
		echo "Could not get current version from website" >&2
		return 1
	fi

	echo ${CURR_VER} | sed 's/\.tar$//;s/^tor-//'
	return 0
}

ask_user_version() {
	#$1: The default entry

	local VERSION
	read -e -p "Enter Version to get:   " -i "$1" VERSION
	echo "$VERSION"
}

download_file() {
	#$1: version

	local FILE_URL="$BASEURL/tor-${1}.tar.gz"
	local SIGN_URL="$BASEURL/tor-${1}.tar.gz.asc"
	local FILE=`basename "$FILE_URL"`
	local SIGN=`basename "$SIGN_URL"`

	if [ -f "$FILE" ]; then
		echo "File $FILE already exists" >&2
		return 1
	fi

	if ! wget $WGET_OPTIONS "$FILE_URL"; then
		echo "Wget error when downloading FILE $FILE_URL" >&2
		return 1
	fi

	if ! wget $WGET_OPTIONS "$SIGN_URL"; then
		echo "Wget error when downloading SIGNATURE $SIGN_URL" >&2
		return 1
	fi

	signature_check "$FILE" "$SIGN"
	return $?
}

signature_check() {
	#$1: The file to check
	#$2: The signature file
	local FILE="$1"
	local SIGN="$2"
	
	if ! gpg --verify "$SIGN"; then
		echo "Error verifying signature" >&2
		return 1
	fi
	return 0
}


########################

CURR_VER=`get_current_version` || exit 1
echo "Current version on website:  $CURR_VER"
echo
CONFIRMED_VER=`ask_user_version $CURR_VER`
echo

if download_file $CONFIRMED_VER; then
	echo 
	echo "Successfully completed."
	exit 0
else
	exit 1
fi
