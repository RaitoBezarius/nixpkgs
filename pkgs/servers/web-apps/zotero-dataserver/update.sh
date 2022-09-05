#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nix curl jq nix-update

# check if composer2nix is installed
if ! command -v composer2nix &> /dev/null; then
  echo "Please install composer2nix (https://github.com/svanderburg/composer2nix) to run this script."
  exit 1
fi

CURRENT_REVISION=$(nix eval -f ../../../.. --raw zotero-dataserver.src.rev)
CURRENT_VERSION=$(nix eval -f ../../../.. --raw zotero-dataserver.version)
TARGET_REVISION_REMOTE=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} https://api.github.com/repos/zotero/dataserver/commits | jq -r ".[0].sha")
TARGET_REVISION=${TARGET_VERSION_REMOTE:"689f9e90e10d9467279264517a1dafb3c5b05afa"}
ZOTERO_DATASERVER=https://github.com/zotero/dataserver/raw/$TARGET_VERSION_REMOTE
SHA256=$(nix-prefetch fetchFromGitHub --owner zotero --repo dataserver --rev "$TARGET_REVISION")

if [[ "$CURRENT_REVISION" == "$TARGET_REVISION" ]]; then
  echo "zotero dataserver is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

# We assign the current date.
TARGET_VERSION=$(date +"%Y-%m-%d")

curl -LO "$ZOTERO_DATASERVER/composer.json"
curl -LO "$ZOTERO_DATASERVER/composer.lock"

composer2nix --name "zotero-dataserver" \
  --composition=composition.nix \
  --no-dev
rm composer.json composer.lock

# change version number
sed -e "s/version =.*;/version = \"$TARGET_VERSION\";/g" \
    -e "s/sha256 =.*;/sha256 = \"$SHA256\";/g" \
    -i ./default.nix

# fix composer-env.nix
sed -e "s/stdenv\.lib/lib/g" \
    -e '3s/stdenv, writeTextFile/stdenv, lib, writeTextFile/' \
    -i ./composer-env.nix

# fix composition.nix
sed -e '7s/stdenv writeTextFile/stdenv lib writeTextFile/' \
    -i composition.nix

# fix missing newline
echo "" >> composition.nix
echo "" >> php-packages.nix

cd ../../../..
nix-build -A zotero-dataserver

exit $?
