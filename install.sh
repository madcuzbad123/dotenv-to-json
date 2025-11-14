#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}dotenv-to-json Installation Script${NC}"
echo ""

if command -v uv >/dev/null 2>&1; then
    echo -e "${GREEN}✓ uv is already installed${NC}"
    UV_CMD="uv"
else
    echo -e "${YELLOW}uv not found. Downloading uv...${NC}"
    
    OS="$(uname -s)"
    ARCH="$(uname -m)"
    
    case "$OS" in
        Linux*)
            OS_TYPE="unknown-linux-gnu"
            ;;
        Darwin*)
            OS_TYPE="apple-darwin"
            ;;
        *)
            echo -e "${RED}Error: Unsupported OS: $OS${NC}"
            exit 1
            ;;
    esac
    
    case "$ARCH" in
        x86_64)
            ARCH_TYPE="x86_64"
            ;;
        arm64|aarch64)
            ARCH_TYPE="aarch64"
            ;;
        *)
            echo -e "${RED}Error: Unsupported architecture: $ARCH${NC}"
            exit 1
            ;;
    esac
    
    UV_VERSION="latest"
    UV_URL="https://astral.sh/uv/install.sh"
    
    echo -e "${YELLOW}Downloading uv installer...${NC}"
    
    if command -v curl >/dev/null 2>&1; then
        curl -LsSf "$UV_URL" | sh
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "$UV_URL" | sh
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi
    
    export PATH="$HOME/.cargo/bin:$PATH"
    
    if command -v uv >/dev/null 2>&1; then
        echo -e "${GREEN}✓ uv installed successfully${NC}"
        UV_CMD="uv"
    else
        echo -e "${YELLOW}Warning: uv may not be in PATH. Trying default location...${NC}"
        if [ -f "$HOME/.cargo/bin/uv" ]; then
            UV_CMD="$HOME/.cargo/bin/uv"
            echo -e "${GREEN}✓ Found uv at $UV_CMD${NC}"
        else
            echo -e "${RED}Error: Could not find uv after installation.${NC}"
            echo -e "${YELLOW}Please add $HOME/.cargo/bin to your PATH and run this script again.${NC}"
            exit 1
        fi
    fi
fi

echo ""
echo -e "${GREEN}Installing dotenv-to-json...${NC}"
"$UV_CMD" tool install .

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "You can now use the ${YELLOW}env2json${NC} command."

