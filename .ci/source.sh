#!/bin/bash -ex

GITDATE="`git show -s --date=short --format='%ad' | sed 's/-//g'`"
GITREV="`git show -s --format='%h'`"
REV_NAME="citra-unified-source-${GITDATE}-${GITREV}"

COMPAT_LIST='dist/compatibility_list/compatibility_list.json'

mkdir artifacts

pip3 install git-archive-all
wget -q https://gist.github.com/GesundesWasser/f17f9286fcb666c14ca9c9dafc45f67f/raw/6b904a96e911135884cb9f361259de01b7238043/gamedb.json -O "${COMPAT_LIST}"
git describe --abbrev=0 --always HEAD > GIT-COMMIT
git describe --tags HEAD > GIT-TAG || echo 'unknown' > GIT-TAG
git archive-all --include "${COMPAT_LIST}" --include GIT-COMMIT --include GIT-TAG --force-submodules artifacts/"${REV_NAME}.tar"

cd artifacts/
xz -T0 -9 "${REV_NAME}.tar"
sha256sum "${REV_NAME}.tar.xz" > "${REV_NAME}.tar.xz.sha256sum"
cd ..
