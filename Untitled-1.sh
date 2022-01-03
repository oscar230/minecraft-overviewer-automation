#!/bin/bash

BASEDIR=/opt/mc-map
SRCDIR=$BASEDIR/source-code
MAPBIN=$SRCDIR/overviewer.py
MAPCONFIG=$BASEDIR/config.py
VERSION=$(curl "https://launchermeta.mojang.com/mc/game/version_manifest.json" -s | grep -oP '(?<="release": ")[^"]*')
TEXDIR=$BASEDIR/textures/${VERSION}
TEXFILE="${TEXDIR}/${VERSION}.jar"
GUPSTREAM=${1:-'@{u}'}
PROCESSES=2

echo -e "\033[0;33mLatest minecraft version is $VERSION.\033[0m"

# Overviewer repo update
echo -e "\033[0;32mPull repo...\033[0m"
(cd $SRCDIR && git pull && echo -e "\033[0;32mPulled repo.\033[0m")

# Overviewer build
(cd $SRCDIR && python3 setup.py build && echo -e "\033[0;32mNew build done.\033[0m")

# Texture update
if [ -f "$TEXFILE" ]; then
        echo -e "\033[0;32m$TEXFILE exists, no need to update textures.\033[0m"
else
        echo -e "$TEXFILE does not exist, updating texture file from overviewer.org now.\033[0m"
        (cd $BASEDIR && mkdir -p $TEXDIR && wget "https://overviewer.org/textures/${VERSION}" -O $TEXFILE)
        echo -e "\033[0;32mUpdated $TEXFILE successfully.\033[0m"
fi

# Run overviewer
echo "Move texture file from $TEXFILE to /tmp/texture.jar"
rm -f /tmp/texture.jar
mv $TEXFILE /tmp/texture.jar
ls -l /tmp/texture.jar
(cd $BASEDIR && exec $MAPBIN --config=$MAPCONFIG --processes=$PROCESSES && echo -e "\033[0;32mDone!\033[0m")
echo "Move back /tmp/texture.jar to $TEXFILE"
mv /tmp/texture.jar $TEXFILE
if command -v tree &> /dev/null
then
    tree $BASEDIR/textures/
fi
echo -e "\033[0;33Exiting.\033[0m"