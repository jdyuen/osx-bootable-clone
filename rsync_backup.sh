#!/bin/sh

#PROG=$0
PROG=stdout
RSYNC="/usr/bin/rsync"
SRC="/"
DST="/Volumes/cloneJDY/snowLeopard/"

# rsync options
# -v increase verbosity
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -E preserve executability
# -S handle spare files efficiently
# --delete delete deletes any files that have been deleted locally
# --exclude-from reference a list of files to exclude

DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "Starting rsync backup clone to: $DST ..."

if [ ! -r "$SRC" ]; then
 /usr/bin/logger -t $PROG "Source $SRC not readable - Cannot start the sync process"
 echo "ERR: Source not readable"
  exit;
fi

if [ ! -w "$DST" ]; then
  /usr/bin/logger -t $PROG "Destination $DST not writeable - Cannot start the sync process"
  echo "ERR: Destination not writeable"
  exit;
fi

/usr/bin/logger -t $PROG "Start rsync"

sudo $RSYNC -vaxhE --progress -S --delete --exclude-from=$DIR/rsync_excludes.txt "$SRC" "$DST"

/usr/bin/logger -t $PROG "End rsync"

# make the backup bootable
sudo bless -folder "$DST"/System/Library/CoreServices

exit 0
