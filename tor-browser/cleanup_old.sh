#!/bin/bash

# Script which cleans up the .tbwser.old directory that was left
# from the previous installation
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

TDIR="$HOME/.tbwser"

#------------------

[ ! -d "$TDIR.old" ] && exit 0

read -p "Do you want to delete the dir $TDIR.old? (y/N) " RES
[ -z "$RES" ] && RES=n
if [ "$RES" = y ]; then
	rm -r "$TDIR.old"
	exit $?
fi
