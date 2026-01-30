#!/usr/bin/env bash
# bootstrap.sh - Simple version with OpenSSL check

set -e

CURRENT_DIR=$(pwd)
INSTALL_DIR="$HOME/.local/bootstrap"
BUILD_DIR="$HOME/.cache/bootstrap-build"

OPENSSL_VERSION="3.2.0"
PYTHON_VERSION="3.13.11"
SOCAT_VERSION="1.8.0.1"


export PATH="${PYTHON_PREFIX}/bin:$PATH"

echo "================="
echo "Ansible Bootstrap"
echo "================="
echo ""

# Xcode CLI Tools
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode CLI Tools..."
    xcode-select --install
    read -p "Press Enter after installation..."
fi
echo "✓ Xcode CLI Tools"


mkdir -p "$BUILD_DIR"

SOCAT_CMD="$HOME/.local/bin/socat"
if [[ -f "$SOCAT_CMD" ]]; then
    echo "✓ Using bootstrap socat"
else
    echo "  Building socat from source..."
    cd "$BUILD_DIR"

    # Download
    echo "  Downloading socat-$SOCAT_VERSION..."
    if ! curl -fsSL -O "http://www.dest-unreach.org/socat/download/socat-$SOCAT_VERSION.tar.gz"; then
        echo "  ✗ Failed to download socat"
        exit 1
    fi

    # Extract
    echo "  Extracting..."
    tar xzf "socat-$SOCAT_VERSION.tar.gz"
    cd "socat-$SOCAT_VERSION"

    # Build
    echo "  Configuring..."
    if ! ./configure --prefix="$HOME/.local/bin/socat" > "$BUILD_DIR/configure.log" 2>&1; then
        echo "  ✗ Configure failed. Check $BUILD_DIR/configure.log"
        exit 1
    fi

    echo "  Compiling..."
    if ! make > "$BUILD_DIR/make.log" 2>&1; then
        echo "  ✗ Build failed. Check $BUILD_DIR/make.log"
        exit 1
    fi

    # Install
    echo "  Installing socat..."
    if ! make install > "$BUILD_DIR/install.log" 2>&1; then
        echo "  ✗ Install failed. Check $BUILD_DIR/install.log"
        exit 1
    fi

    # Return to original directory
    cd "$CURRENT_DIR" 

    echo "  ✓ socat built and installed"
    echo "   ensure that its on your path by adding $HOME/.local/bin"
fi

# Check for OpenSSL
OPENSSL_CMD="$INSTALL_DIR/bin/openssl"
if [[ -f "$OPENSSL_CMD" ]]; then
    echo "✓ Using bootstrap OpenSSL"
else
    echo "Building OpenSSL ${OPENSSL_VERSION}"

    mkdir -p "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/ssl"
    mkdir -p "$INSTALL_DIR/etc/openssl"
    mkdir -p "$INSTALL_DIR/etc/ca-certificates"

    cd "$BUILD_DIR"

    curl -sL "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" | tar xz
    cd "openssl-${OPENSSL_VERSION}"

    ./Configure \
        --prefix="${INSTALL_DIR}" \
        --openssldir="${INSTALL_DIR}/etc/openssl" \
        darwin64-$(uname -m)-cc \
        shared \
        no-ssl3 \
        no-ssl3-method

    make -j$(sysctl -n hw.ncpu)  --silent
    make install_sw --silent

    cd "$CURRENT_DIR"
    echo "✓ OpenSSL built"
fi

CERT_URL="https://curl.se/ca/cacert.pem"
CERT_FILE="${INSTALL_DIR}/etc/ca-certificates/cert.pem"

if curl -sL "$CERT_URL" -o "$CERT_FILE"; then 
    ln -sf "$CERT_FILE" "${INSTALL_DIR}/etc/openssl/cert.pem"
    ln -sf "$CERT_FILE" "${INSTALL_DIR}/ssl/cert.pem"

    CERT_COUNT=$(grep -c "BEGIN CERTIFICATE" "$CERT_FILE")
    echo "Installed $CERT_COUNT root certificates"
else
    echo "Failed to download certificate bundle"
    exit 1
fi

PYTHON_CMD="$INSTALL_DIR/bin/python3"
if [[ -f "$PYTHON_CMD" ]] && "$PYTHON_CMD" -c "import ssl" 2>/dev/null; then
    echo "✓ System Python with SSL"
else
    echo "Building Python ${PYTHON_VERSION} with SSL..."
    cd "$BUILD_DIR"

    curl -sL "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" | tar xz

    cd "Python-${PYTHON_VERSION}"

    ./configure \
        --prefix="$INSTALL_DIR" \
        --enable-optimizations \
        --with-lto \
        --enable-shared \
        --with-openssl="$INSTALL_DIR" \
        CPPFLAGS="-I${INSTALL_DIR}/include" \
        LDFLAGS="-L${INSTALL_DIR}/lib"

    make -j$(sysctl -n hw.ncpu) --silent
    make install --silent

    # Verify SSL
    if ! "$PYTHON_CMD" -c "import ssl" 2>/dev/null; then
        echo "❌ Python built but SSL doesn't work!"
        exit 1
    fi
    echo "✓ Python built with SSL"
fi

# Ansible
if ! command -v ansible &>/dev/null; then
    echo "Installing Ansible..."
    "$PYTHON_CMD" -m pip install --user ansible
fi
echo "✓ Ansible"

echo ""
echo "✅ Bootstrap complete!"
echo ""
