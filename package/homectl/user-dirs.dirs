#!/bin/sh
#
#   Define Freedesktop XDG_* directory variables accordingly to the homectl
#   file hierarchy standard.
#

# A directory where to put temporary work with no specific expiration date but
# which should be deleted or moved to another location at some point.
#
XDG_DESKTOP_DIR="$HOME/volatile"

# The homectl package defines a notion of download directory but no notion of
# share directory. Just define the download directory as an input/output
# directory.
#
XDG_DOWNLOAD_DIR="$HOME/download"
XDG_PUBLICSHARE_DIR="$HOME/download"

# The homectl package defines a notion of template directory.
#
XDG_TEMPLATES_DIR="$HOME/model"

# The homectl package defines no notion of document directory.
# Instead, there is a notion of read-mostly directory where to put any file
# that should be conserved without expiration. This is close enough.
#
XDG_DOCUMENTS_DIR="$HOME/archive"

# In the homectl hierarchy, the music, pictures and videos are not primary
# directories but a subpart of something called "resource".
#
XDG_MUSIC_DIR="$HOME/resource/music"
XDG_PICTURES_DIR="$HOME/resource/picture"
XDG_PICTURES_DIR="$HOME/resource/video"
