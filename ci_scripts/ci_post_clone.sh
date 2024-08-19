#!/bin/sh
cd ../
git clone https://github.com/DSM-PICK/PiCK_iOS_XCConfig
mv PiCK_iOS_XCConfig/V1/XCConfig/ .

brew install make

curl https://mise.jdx.dev/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash --shims)"

mise install tuist@3.41.0

tuist version

make generate
