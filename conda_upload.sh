#!/bin/bash
echo "Conda_upload.sh start..."

export PKG_NAME=test_release_5
export ANACONDA_API_TOKEN=$CONDA_UPLOAD_TOKEN
export VERSION=$(python setup.py)
export CONDA_BUILD_PATH=/home/travis/miniconda/envs/test-environment/conda-bld
export BASE_PATH=$(pwd)

conda config --set anaconda_upload no

echo "Build missing pypi packages..."
conda skeleton pypi rec_to_binaries --version 0.3.0.dev0
conda skeleton pypi xmldiff --version 2.4

echo "Build missing pypi packages into conda packages..."
conda build rec_to_binaries
conda build xmldiff

echo "Convert  missing pypi packages ..."
conda convert --platform osx-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q
conda convert --platform linux-32 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q
conda convert --platform linux-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q
conda convert --platform win-32 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q
conda convert --platform win-64 $CONDA_BUILD_PATH/linux-64/***.tar.bz2 --output-dir $CONDA_BUILD_PATH -q

echo "Upload  missing pypi packages to anaconda..."
anaconda upload $CONDA_BUILD_PATH/**/rec_to_binaries-*.tar.bz2 --force
anaconda upload $CONDA_BUILD_PATH/**/xmldiff-*.tar.bz2 --force

echo "Building conda package..."
conda build . --no-include-recipe -c novelakrk -c acwikla-novela -c conda-forge || exit 1

echo "Converting conda package..."
conda convert --platform osx-64 $CONDA_BUILD_PATH/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform linux-32 $CONDA_BUILD_PATH/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform linux-64 $CONDA_BUILD_PATH/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform win-32 $CONDA_BUILD_PATH/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1
conda convert --platform win-64 $CONDA_BUILD_PATH/linux-64/${PKG_NAME}-${VERSION}-py37_0.tar.bz2 --output-dir $CONDA_BUILD_PATH -q || exit 1

echo "Deploying to Anaconda.org..."
anaconda upload $CONDA_BUILD_PATH/**/$PKG_NAME-*.tar.bz2 --force || exit 1



