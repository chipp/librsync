#!/bin/bash

rm -rf xrsim
mkdir xrsim

cmake -B xrsim/build -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=/Users/Vladimir_Burdukov/Downloads/ios.toolchain.cmake \
    -DBUILD_RDIFF=OFF \
    -DPLATFORM=SIMULATOR_VISIONOS \
    -DAPPLE=1 \
    .
cmake --build xrsim/build --config Release

rm -rf xros
mkdir xros

cmake -B xros/build -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=/Users/Vladimir_Burdukov/Downloads/ios.toolchain.cmake \
    -DBUILD_RDIFF=OFF \
    -DPLATFORM=VISIONOS \
    -DAPPLE=1 \
    .
cmake --build xros/build --config Release

mkdir -p xrsim/build/Release-xrsimulator/rsync.framework/Modules
cat <<EOT > xrsim/build/Release-xrsimulator/rsync.framework/Modules/module.modulemap
framework module rsync {
  umbrella header "librsync.h"

  export *
  module * { export * }
}
EOT

mkdir -p xros/build/Release-xros/rsync.framework/Modules
cat <<EOT > xros/build/Release-xros/rsync.framework/Modules/module.modulemap
framework module rsync {
  umbrella header "librsync.h"

  export *
  module * { export * }
}
EOT

rm -rf rsync.xcframework
xcodebuild -create-xcframework \
    -framework xrsim/build/Release-xrsimulator/rsync.framework \
    -framework xros/build/Release-xros/rsync.framework \
    -output rsync.xcframework
