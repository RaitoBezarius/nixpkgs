{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "akvorado";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "akvorado";
    repo = "akvorado";
    rev = "v${version}";
    sha256 = lib.fakeHash;
  };

  vendorSha256 = lib.fakeHash;

  ldflags = [ "-s" "-w" "-X cmd.Version=${version}" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/akvorado
    mv $out/bin/inlet $out/bin
  '';
