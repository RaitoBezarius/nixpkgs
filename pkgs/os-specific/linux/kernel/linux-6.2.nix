{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, fetchpatch, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.2.7";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "138dpmj8qr5fcji99kmi3sj34ah21bgqgzsz2lbhn37v059100s3";
  };

  kernelPatches = args.kernelPatches ++ [({
    name = "export-neon-symbols-as-gpl";
    patch = fetchpatch {
      url = "https://github.com/torvalds/linux/commit/aaeca98456431a8d9382ecf48ac4843e252c07b3.patch";
      hash = "sha256-L2g4G1tlWPIi/QRckMuHDcdWBcKpObSWSRTvbHRIwIk=";
      revert = true;
    };
  })
  ];
} // (args.argsOverride or { }))
