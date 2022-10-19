#!/bin/sh 

set -e

# called by uscan with '--upstream-version' <version> <file>
echo "version $2"
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
version=$2
tarball=$3
TAR=../${package}_${version}.orig.tar.xz
DIR=${package}-${version}.orig
UPSTREAM_CVS_REPO="pserver:anonymous@serp.cvs.sourceforge.net:/cvsroot/serp"

# upstream doesn't publish sources in any URL, so I have to fetch the
# source from (wait for it...) upstream CVS repo...

cvs -d:"${UPSTREAM_CVS_REPO}" login
cvs -z3 -d:"${UPSTREAM_CVS_REPO}" export \
    -r "${package}_$(echo $version | sed 's/\./_/g')" \
    -d "${package}-${version}.orig" $package

XZ_OPT=--best tar --numeric --group 0 --owner 0 -c -v -J -f $TAR $DIR

rm -rf $tarball $DIR
