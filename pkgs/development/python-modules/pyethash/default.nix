{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, cffi
, ethash
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyethash";
  version = ethash.version;
  disabled = pythonOlder "3.6";

  src = ethash.src;

  postPatch = ''
    substituteInPlace setup.py \
    --replace "self.library_dirs.append(path.join(install_dir, 'lib'))" "self.library_dirs.append('${ethash}/lib')"
  '';

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  nativeBuildInputs = [ cffi ];

  nativePropagatedBuildInputs = [
    ethash cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  ETHASH_PYTHON_SKIP_BUILD = true;

  pythonImportsCheck = [ "ethash" ];

  meta = with lib; {
    description = "Python bindings for the PoW algorithm for Ethereum 1.0";
    homepage = "https://github.com/chfast/ethfast";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
