#!/bin/bash

# Script to check the downloaded tor-browser binary for integrity
# and install it afterwards.
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

NEWEST=`ls tor-browser-linux64-*.xz | sort -r -V | head -n1`
read -e  -p "Enter Tor Version to install:  " -i "$NEWEST" NEWEST

if [ ! -f "$NEWEST" ]; then
	echo "Version does not exist." >&2
	exit 1
fi

echo
if ! gpg --verify "$NEWEST.asc"; then
	echo "Signature did not match." >&2
	exit 1
fi

TDIR="$HOME/.tbwser"
if [ -d "$TDIR" ]; then
	if [ -d "$TDIR.old" ]; then
		echo "There already exists an oldir. Please remove it first." >&2
		echo "You can use the cleanup_old.sh script for this purpose." >&2
		exit 1
	fi
	mv "$TDIR" "$TDIR.old" || exit 1
fi

echo
mkdir "$TDIR" || exit 1
tar xJ -C "$TDIR" -f "$NEWEST" || exit 1
cd "$TDIR" || exit 1
ln -s tor-browser* curr || exit 1

echo "Successfully accompished."
exit 0
