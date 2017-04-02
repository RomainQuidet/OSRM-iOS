#!/usr/bin/env bash

endSection()
{
    echo
    echo "Done"
    echo "================================================================="
    echo
}

startSection()
{
    echo
    echo "$1"
    echo "================================================================="
    echo
}

cleanup()
{
	echo "Cleaning everything"
	rm tbb_libs/*
}

startSection "Starting"
cd "3rdParty"
echo $PWD
cleanup

startSection "Building tbb static lib"
cd "tbb"
make target="ios" arch="arm64" extra_inc="big_iron.inc"
make target="ios" arch="armv7" extra_inc="big_iron.inc"
make target="ios" arch="intel64" extra_inc="big_iron.inc"

pattern="_release"
xcrun --sdk iphoneos lipo -create build/*"${pattern}"/libtbb.a -output ../tbb_libs/libtbbUnivesal.a
xcrun --sdk iphoneos lipo -create build/*"${pattern}"/libtbbmalloc.a -output ../tbb_libs/libtbbmallocUnivesal.a

endSection

popd

#cmake -DCMAKE_TOOLCHAIN_FILE=../iOS.cmake -DCMAKE_BUILD_TYPE=Release ..
#make stxll
#cmake -DCMAKE_TOOLCHAIN_FILE=../iOS.cmake -DCMAKE_BUILD_TYPE=Release .. -DIOS_PLATFORM=SIMULATOR64
#make stxll