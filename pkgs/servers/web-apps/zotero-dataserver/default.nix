{ pkgs, stdenv, lib, fetchFromGitHub, dataDir ? "/var/lib/zotero-dataserver", mariadb }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage $out/public/uploads $out/bootstrap/cache
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/
      ln -s ${dataDir}/public/uploads $out/public/uploads
      ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
      chmod +x $out/artisan
      substituteInPlace config/database.php --replace "env('DB_DUMP_PATH', '/usr/local/bin')" "env('DB_DUMP_PATH', '${mariadb}/bin')"
    '';
  });

in package.override rec {
  pname = "zotero-dataserver";
  version = "2022-09-06";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "dataserver";
    rev = "689f9e90e10d9467279264517a1dafb3c5b05afa";
    sha256 = "sha256-9QNNALOwExcu9db1W/TAuhJYiut1rWC/L22cm0BSr3w=";
  };

  meta = with lib; {
    description = "A free open source IT asset/license management system ";
    longDescription = ''
      Snipe-IT was made for IT asset management, to enable IT departments to track
      who has which laptop, when it was purchased, which software licenses and accessories
      are available, and so on.
      Details for snipe-it can be found on the official website at https://snipeitapp.com/.
    '';
    homepage = "https://snipeitapp.com/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
    platforms = platforms.linux;
  };
}
