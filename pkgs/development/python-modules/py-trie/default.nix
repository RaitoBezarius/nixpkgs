{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-hash
, eth-utils
, hexbytes
, rlp
, sortedcontainers
, typing-extensions
, pytest-xdist
, pycryptodome
, hypothesis
, tox
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-trie";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qr3l3Uc/ypNVvFbEA8sQoZv0z1JUmo6gp66VG9H7EXI=";
  };

  propagatedBuildInputs = [
    eth-hash
    eth-utils
    hexbytes
    rlp
    sortedcontainers
    typing-extensions
  ];

  checkInputs = [
    hypothesis
    pytest-xdist
    pycryptodome
    tox
    pytestCheckHook
  ];

  doCheck = false; # FIXME: 3 failed (time sensitive hypothesis stuff), multiple failure due to a missing file.

  pythonImportsCheck = [ "trie" ];

  meta = with lib; {
    description = "Python library which implements the Ethereum Trie structure.";
    homepage = "https://github.com/ethereum/py-trie";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
