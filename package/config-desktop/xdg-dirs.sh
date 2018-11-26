#!/bin/sh
#
#   Define Freedesktop XDG_* directory variables accordingly to the homectl
#   file hierarchy standard.
#

# A directory where to put temporary work with no specific expiration date but
# which should be deleted or moved to another location at some point.
#
export XDG_DESKTOP_DIR="$HOME/volatile"

# The homectl package defines a notion of download directory but no notion of
# share directory. Just define the download directory as an input/output
# directory.
#
export XDG_DOWNLOAD_DIR="$HOME/download"
export XDG_PUBLICSHARE_DIR="$HOME/download"

# The homectl package defines a notion of template directory.
#
export XDG_TEMPLATES_DIR="$HOME/model"

# The homectl package defines no notion of document directory.
# Instead, there is a notion of read-mostly directory where to put any file
# that should be conserved without expiration. This is close enough.
#
export XDG_DOCUMENTS_DIR="$HOME/archive"

# In the homectl hierarchy, the music, pictures and videos are not primary
# directories but a subpart of something called "resource".
#
export XDG_MUSIC_DIR="$HOME/resource/music"
export XDG_PICTURES_DIR="$HOME/resource/picture"
export XDG_PICTURES_DIR="$HOME/resource/video"
