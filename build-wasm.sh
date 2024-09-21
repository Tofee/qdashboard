#!/bin/sh

# build the webassembly binary in $HOME/dev/projects/build-QDashboard-WebAssembly-Release

docker run -it --rm -v $HOME/dev/projects/qdashboard:/home/user/src:ro -v $HOME/dev/projects/build-QDashboard-WebAssembly-Release:/home/user/build stateoftheartio/qt6:6.6-wasm-aqt sh -c 'qt-cmake ./src -G Ninja -B ./build; cmake --build ./build'
