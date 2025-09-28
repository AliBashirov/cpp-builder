#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SETTINGS_FILE="$SCRIPT_DIR/build_settings"

if [ ! -f "$SETTINGS_FILE" ]; then
    cat > "$SETTINGS_FILE" <<EOL
FIGLET_COMPILED=1
FIGLET_RUNNING=1
FIGLET_DONE=0
BUILD_MODE=release
VERSION="1.0.0"
EOL
fi

source "$SETTINGS_FILE"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

if ! command -v figlet &> /dev/null; then
    echo -e "${RED}Figlet not installed. Run: sudo apt install figlet${NC}"
    exit 1
fi

tui_settings() {
    while true; do
        clear
        echo -e "${CYAN}Build Settings TUI${NC}"
        echo
        echo "1) Toggle COMPILED banner (current: $FIGLET_COMPILED)"
        echo "2) Toggle RUNNING banner (current: $FIGLET_RUNNING)"
        echo "3) Toggle DONE banner (current: $FIGLET_DONE)"
        echo "4) Change build mode (current: $BUILD_MODE)"
        echo "5) Exit and save"
        echo
        read -p "Select an option: " opt
        case $opt in
            1)
                FIGLET_COMPILED=$((1-FIGLET_COMPILED))
                ;;
            2)
                FIGLET_RUNNING=$((1-FIGLET_RUNNING))
                ;;
            3)
                FIGLET_DONE=$((1-FIGLET_DONE))
                ;;
            4)
                echo "Select build mode:"
                select mode in release debug; do
                    [ -n "$mode" ] && BUILD_MODE="$mode" && break
                done
                ;;
            5)
                break
                ;;
            *)
                echo "Invalid option!"
                sleep 1
                ;;
        esac
    done

    cat > "$SETTINGS_FILE" <<EOL
FIGLET_COMPILED=$FIGLET_COMPILED
FIGLET_RUNNING=$FIGLET_RUNNING
FIGLET_DONE=$FIGLET_DONE
BUILD_MODE=$BUILD_MODE
VERSION="$VERSION"
EOL
    echo "Settings saved!"
    sleep 1
}

case "$1" in
    help)
        echo -e "${CYAN}Build Tool Help:${NC}"
        echo "Usage: build <file.cpp>"
        echo "       build settings"
        echo "       build clean <file>"
        echo "       build version"
        echo "       build help"
        exit 0
        ;;
    settings)
        tui_settings
        exit 0
        ;;
    clean)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: specify file to clean.${NC}"
            exit 1
        fi
        TARGET="${2%.cpp}"
        if [ -f "$TARGET" ]; then
            rm "$TARGET"
            echo -e "${GREEN}Deleted $TARGET${NC}"
        else
            echo -e "${YELLOW}$TARGET does not exist.${NC}"
        fi
        exit 0
        ;;
    version)
        echo -e "${CYAN}Build Tool Version:${NC} $VERSION"
        exit 0
        ;;
esac

SRC="$1"
TARGET="${SRC%.cpp}"

if [ ! -f "$SRC" ]; then
    echo -e "${RED}Error: source file $SRC not found.${NC}"
    exit 1
fi

CXXFLAGS="-std=c++17 -Wall -v"
[ "$BUILD_MODE" == "debug" ] && CXXFLAGS="$CXXFLAGS -g"
[ "$BUILD_MODE" == "release" ] && CXXFLAGS="$CXXFLAGS -O2"

echo -e "${CYAN}⚒️  Compiling $SRC ...${NC}"
g++ $CXXFLAGS "$SRC" -o "$TARGET"
if [ $? -eq 0 ]; then
    [ "$FIGLET_COMPILED" -eq 1 ] && figlet -c "COMPILED!" || echo -e "${GREEN}✅ Build successful!${NC}"
    [ "$FIGLET_RUNNING" -eq 1 ] && figlet -c "RUNNING"
    echo -e "${YELLOW}🚀 Program is running...${NC}"
    ./"$TARGET"
    echo -e "\n"   
  [ "$FIGLET_DONE" -eq 1 ] && figlet -c "DONE"
    echo -e "${GREEN}🏁 Program finished.${NC}"
else
    figlet -c "FAILED"
    echo -e "${RED}❌ Build failed.${NC}"
fi
