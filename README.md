## Geant4 with G4Py Bindings in a Docker Container

This is an attempt to compile Geant4 with Python support inside a Docker container.
Currently used:

* Geant4 10.6 (patch-01) (`geant4.10.06.p01.tar.gz`)
* Ubuntu 18.04 with:
    * Python 3.6.7
    * Boost 1.65.1

Currently, I cannot get it to compile, see
[the corresponding bug report](https://bugzilla-geant4.kek.jp/show_bug.cgi?id=2232).
