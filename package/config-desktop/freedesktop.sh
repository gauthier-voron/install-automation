#!/bin/sh
#
#   Read the user specific freedesktop configuration file at shell start.
#   This is mostly used to affect XDG_* environment variables.
#

set -e

# Try from the most aggressive dotfile location to the most recommended
# location. The paths are a mix of regular files and directories. We make the
# distinction by appending a '/' character for the directories.
#
for path in "$HOME/.xdgrc" "$HOME/.xdgrc.d/" "$HOME/.freedesktop.d/" \
	    "$HOME/.config/xdgrc" "$HOME/.config/xdg/" \
	    "$HOME/.config/freedesktop/"
do
    if [ "${path:$(( ${#path} - 1 ))}" = '/' ] ; then

	# Listed as directory.
	# Check if it exists and is listable.
	if ! [ -d "$path" -a -r "$path" -a -x "$path" ] ; then
	    continue
	fi

	# Directory found.
	# Source every regular files in this directory and exit out of the
	# loop.
	#
	for file in "$path/"* ; do
	    if [ -f "$file" -a -r "$file" ] ; then
		. "$file"
	    fi
	done
	break
	
    else

	# Listed as regular file.
	# Check if it exists and is readable.
	if ! [ -f "$path" -a -r "$path" ] ; then
	    continue
	fi

	# Regular file found.
	# Source this file and exit out of the loop.
	#
	. "$path"
	break

    fi
done
