{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-hash
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eth-bloom";
  version = "1.0.4";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I+533a+OVBThUegL9EXMQOPrYxaxiiPSwZr1CmYSn5w=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools-markdown" "" \
      --replace "long_description_markdown_filename='README.md'," ""
  '';

  propagatedBuildInputs = [
    eth-hash
    eth-hash.optional-dependencies.pycryptodome
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "eth_bloom" ];

  meta = with lib; {
    description = "An implementation of the Ethereum bloom filter.";
    homepage = "https://github.com/ethereum/eth-bloom";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
