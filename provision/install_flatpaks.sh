#!/bin/sh

# The CS573 final project flatpaks directory
pushd $(dirname $0)/../flatpaks

#####################################################
# Build and Install the CS573 Final Project Flatpak #
#####################################################

# 1. Add the flathub remote repository to flatpak
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 2. Install the freedesktop SDK runtime and VS Code IDE flatpaks
flatpak install -y --user flathub org.freedesktop.Sdk//20.08 com.visualstudio.code

# 3. Build and install the CS573 final project flatpak examples
flatpak-builder --install --user --force-clean build-dir boisestate.cs573.Sdk.yaml
flatpak-builder --install --user --force-clean build-dir boisestate.cs573.SdkShellApp.yaml
flatpak-builder --install --user --force-clean build-dir org.freedesktop.Sdk.Extension.cs573.yaml
flatpak-builder --install --user --force-clean build-dir boisestate.cs573.ExtensionShellApp.yaml
flatpak-builder --install --user --force-clean build-dir boisestate.cs573.BaseShellApp.yaml

# 4. Clean build dirs
rm -rf build-dir .flatpak-builder

popd
