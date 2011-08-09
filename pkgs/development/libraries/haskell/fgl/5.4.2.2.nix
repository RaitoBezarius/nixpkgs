{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "fgl";
  version = "5.4.2.2";
  sha256 = "8232c337f0792854bf2a12a5fd1bc46726fff05d2f599053286ff873364cd7d2";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://web.engr.oregonstate.edu/~erwig/fgl/haskell";
    description = "Martin Erwig's Functional Graph Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
