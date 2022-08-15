{ lib
, buildPythonPackage
, fetchFromGitHub
, cached-property
, eth-bloom
, eth-keys
, eth-typing
, eth-utils
, eth-hash
, lru-dict
, mypy-extensions
, py-ecc
, pyethash
, cffi
, rlp
, py-trie
, pexpect
, factory_boy
, pytest-asyncio
, pytest-cov
, pytest-timeout
, pytest-watch
, pytest-xdist
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyevm";
  version = "0.5.0-alpha.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-evm";
    rev = "v${version}";
    sha256 = "sha256-njNjL0DsqmQusnx0HuotZ8j4UwQjwwncuxm4aJPOoDw=";
  };

  patches = [
  ];

  # TODO: get rid of this once 0.5.0-alpha.4 lands.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "eth-keys>=0.3.4,<0.4.0" "eth-keys>=0.3.4,<0.5.0" \
      --replace "trie==2.0.0-alpha.5" "trie>=2.0.0-alpha.5" \
      --replace "eth-typing>=2.3.0,<3.0.0" "eth-typing>=2.3.0,<4.0.0" \
      --replace "rlp>=2,<3" "rlp>=2,<4" \
      --replace "py-ecc>=1.4.7,<6.0.0" "py-ecc>=1.4.7,<7.0.0" \
      --replace "pyethash>=0.1.27,<1.0.0" "ethash>=0.1.27,<1.0.0" \
      --replace "eth-utils>=1.9.4,<2.0.0" "eth-utils>=1.9.4,<3.0.0"

    substituteInPlace eth/consensus/pow.py \
      --replace "pyethash" "ethash"
  '';

  nativeBuildInputs = [ cffi ];
  nativePropagatedBuildInputs = [ cffi ];

  propagatedBuildInputs = [
    cached-property
    eth-bloom
    eth-keys
    eth-typing
    eth-utils
    lru-dict
    mypy-extensions
    pyethash
    py-ecc
    rlp
    py-trie
    # Extra:
    # blake2b-py
    # coincurve
    eth-hash.optional-dependencies.pysha3
    eth-hash.optional-dependencies.pycryptodome
  ];

  checkInputs = [
    hypothesis
    factory_boy
    pexpect
    pytest-asyncio
    pytest-cov
    pytest-timeout
    pytest-watch
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eth" ];

  meta = with lib; {
    description = "A Python implementation of the Ethereum Virtual Machine";
    homepage = "https://github.com/ethereum/py-evm";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
