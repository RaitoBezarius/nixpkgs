{ lib, stdenv, fetchFromGitHub, cmake, gbenchmark, gtest }:

stdenv.mkDerivation rec {
  pname = "ethash";
  version = "0.9.0";

  src =
    fetchFromGitHub {
      owner = "chfast";
      repo = "ethash";
      rev = "v${version}";
      sha256 = "sha256-aXkgcZ8H2p30bQc2PB6AlyI0g3GXAbxRZE46AcgMEJ0=";
    };

  nativeBuildInputs = [
    cmake
  ];

  checkInputs = [
    gbenchmark
    gtest
  ];

  doCheck = true;

  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASH_BUILD_TESTS=ON"
    "-Dbenchmark_DIR=${gbenchmark}/lib/cmake/benchmark"
    "-DGTest_DIR=${gtest.dev}/lib/cmake/GTest"
  ];

  meta = with lib; {
    description = "PoW algorithm for Ethereum 1.0 based on Dagger-Hashimoto";
    homepage = "https://github.com/ethereum/ethash";
    platforms = platforms.unix;
    maintainers = with maintainers; [ raitobezarius ];
    license = licenses.asl20;
  };
}
