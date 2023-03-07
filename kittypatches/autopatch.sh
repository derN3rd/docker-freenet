#!/bin/bash

FNPATH="$1"
PATCHSET="default"
[ "$2" = "-p" ] && [ ! -z "$3" ] && { PATCHSET="$3"; }
PATCHDIR="patches.${PATCHSET}"
[ ! -d "${PATCHDIR}" ] && {
  echo "error: patchdir \"${PATCHDIR}\" is not a valid directory."
  exit 1
}
JARFILE="freenet_latest_fnap_${PATCHSET}.jar"
echo "[ FNAutoPatch Enhanced v1.3 ]"
echo "* Using Patchset: \"${PATCHSET}\""
echo "* Output JAR Name: \"${JARFILE}\""
echo "* Freenet Location: \"${FNPATH}\""

cd $FNPATH

for PATCHFILE in /build/kittypatches/"${PATCHDIR}"/*.patch; do
  echo "Applying patch \"${PATCHFILE}\"..."
  patch -p1 <"${PATCHFILE}"
  [ $? -ne 0 ] && {
    echo "error: patch failed."
    exit 1
  }
done
echo "Patches successfully installed to \"${FNPATH}/${JARFILE}\". You can now build the JAR."
