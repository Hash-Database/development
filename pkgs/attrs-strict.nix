{ stdenv, lib, python3Packages }:

python3Packages.buildPythonPackage
rec {
  pname = "attrs_strict";
  version = "0.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1kz042af2ghw90mz9qf3v1jsivz1q3c12zkz3qifgwaym4av3c2q";
  };

  propagatedBuildInputs = with python3Packages; [ attrs setuptools_scm ];

  meta = with lib; {
    homepage = "https://github.com/bloomberg/attrs-strict";
    description = "attrs runtime validation";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
