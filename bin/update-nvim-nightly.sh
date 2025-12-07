#!/bin/bash
# Colors definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Parse arguments
FORCE_UPDATE=0
if [[ "$1" == "-f" ]] || [[ "$1" == "--force" ]]; then
  FORCE_UPDATE=1
fi

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN"
esac

printf "${YELLOW}Detected OS: ${MACHINE}${NC}\n"

if [[ "$MACHINE" == "UNKNOWN" ]]; then
  printf "\n${RED}Unsupported OS. Aborting...${NC}\n"
  exit 1
fi

# Check if necessary applications are installed
if ! [ -x "$(command -v wget)" ]; then
  printf "\n${RED}wget not found in path. Please install it to continue!${NC}\n"
  exit
fi
if ! [ -x "$(command -v curl)" ]; then
  printf "\n${RED}curl not found in path. Please install it to continue!${NC}\n"
  exit
fi
if ! [ -x "$(command -v xmllint)" ]; then
  printf "\n${RED}xmllint not found in path. Please install it to continue!${NC}\n"
  exit
fi

# Get newest Neovim Nightly info
printf "${YELLOW}Fetching latest nightly info...${NC}\n"
wget https://github.com/neovim/neovim/releases/tag/nightly -q -O - > /tmp/nvim28dce75c-4317-4006-a103-8069d573e2b2

# Variables
SHOW_PROMPT=0
NEW_NVIM_VER=$(xmllint --html --xpath "//a[@href='/neovim/neovim/releases/tag/nightly']/node()" /tmp/nvim28dce75c-4317-4006-a103-8069d573e2b2 2>/dev/null)

# Check if Neovim Nightly exists in repo
if [[ "$NEW_NVIM_VER" == "" ]]; then
  printf "\n${RED}Couldn't fetch latest Neovim Nightly version from github repo! Check if it exists. Aborting...${NC}\n"
  rm /tmp/nvim28dce75c-4317-4006-a103-8069d573e2b2
  exit
fi

# Get current version if nvim is installed
if command -v nvim &> /dev/null; then
  CURR_NVIM_VER=$(nvim --version 2>/dev/null | head -n 1)
  printf "${YELLOW}Current version: ${CURR_NVIM_VER}${NC}\n"
else
  CURR_NVIM_VER=""
  printf "${YELLOW}Neovim not currently installed${NC}\n"
fi

printf "${YELLOW}Latest version:  ${NEW_NVIM_VER}${NC}\n"

# Check if the current neovim version is the latest
if [[ "$CURR_NVIM_VER" == "$NEW_NVIM_VER" ]] && [[ $FORCE_UPDATE -eq 0 ]]; then
  printf "\n${GREEN}Already on latest version of ${BOLD}Neovim Nightly${NORMAL}${NC}\n"
  printf "${YELLOW}Use -f or --force to reinstall anyway${NC}\n"
  rm /tmp/nvim28dce75c-4317-4006-a103-8069d573e2b2
  exit
fi

# If a newer version of Neovim Nightly found show prompt
if [[ "$CURR_NVIM_VER" != "$NEW_NVIM_VER" ]]; then
  if [[ -z "$CURR_NVIM_VER" ]]; then
    printf "\n${GREEN}Installing ${BOLD}Neovim Nightly${NORMAL}${GREEN}: ${NEW_NVIM_VER}${NC}\n"
  else
    printf "\n${GREEN}New ${BOLD}Neovim Nightly${NORMAL}${GREEN} version found!${NC}\n${CURR_NVIM_VER} -> ${BOLD}${NEW_NVIM_VER}${NORMAL}\n"
  fi
  SHOW_PROMPT=1
elif [[ $FORCE_UPDATE -eq 1 ]]; then
  printf "\n${YELLOW}Force reinstall requested${NC}\n"
  SHOW_PROMPT=1
fi

# Update function
update_neovim() {
  printf "${RED}Installing Neovim Nightly...${NC}\n"
  
  if [[ "$MACHINE" == "Linux" ]]; then
    HTTPS_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage"
    printf "${YELLOW}Downloading: ${HTTPS_URL}${NC}\n"
    CURL_CMD="curl -L -w http_code=%{http_code}"
    CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/nvim.download`
    HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
    
    if [[ ${HTTP_CODE} == 200 ]]; then
      chmod +x /tmp/nvim.download
      sudo mv /tmp/nvim.download /usr/local/bin/nvim
      printf "${GREEN}Neovim Nightly has been installed successfully!${NC}\n"
    else
      ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')
      printf "${RED}Neovim Nightly has NOT been installed! ERROR: ${ERROR_MESSAGE}${NC}\n"
    fi
  else
    # Detect macOS architecture
    ARCH=$(uname -m)
    printf "${YELLOW}Detected architecture: ${ARCH}${NC}\n"
    if [[ "$ARCH" == "arm64" ]]; then
      HTTPS_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
      EXTRACT_DIR="nvim-macos-arm64"
    else
      HTTPS_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz"
      EXTRACT_DIR="nvim-macos-x86_64"
    fi
    
    printf "${YELLOW}Downloading: ${HTTPS_URL}${NC}\n"
    CURL_CMD="curl -L -w http_code=%{http_code}"
    CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/nvim.download.tar.gz`
    HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
    
    if [[ ${HTTP_CODE} == 200 ]]; then
      printf "${YELLOW}Removing quarantine attribute...${NC}\n"
      xattr -c /tmp/nvim.download.tar.gz 2>/dev/null || true
      
      printf "${YELLOW}Extracting to /tmp...${NC}\n"
      tar xzf /tmp/nvim.download.tar.gz -C /tmp
      
      if [[ ! -d "/tmp/${EXTRACT_DIR}" ]]; then
        printf "${RED}Extraction failed - directory not found${NC}\n"
        exit 1
      fi
      
      printf "${YELLOW}Verifying extracted structure...${NC}\n"
      ls -la /tmp/${EXTRACT_DIR}/
      
      printf "${YELLOW}Removing old installation...${NC}\n"
      sudo rm -rf /usr/local/bin/nvim
      sudo rm -rf /usr/local/share/nvim
      sudo rm -rf /usr/local/lib/nvim
      
      printf "${YELLOW}Installing binary...${NC}\n"
      sudo cp -v /tmp/${EXTRACT_DIR}/bin/nvim /usr/local/bin/ || { printf "${RED}Failed to copy binary${NC}\n"; exit 1; }
      
      printf "${YELLOW}Installing share directory...${NC}\n"
      sudo cp -Rv /tmp/${EXTRACT_DIR}/share/nvim /usr/local/share/ || { printf "${RED}Failed to copy share${NC}\n"; exit 1; }
      
      printf "${YELLOW}Installing lib directory...${NC}\n"
      sudo cp -Rv /tmp/${EXTRACT_DIR}/lib/nvim /usr/local/lib/ || { printf "${RED}Failed to copy lib${NC}\n"; exit 1; }
      
      printf "${YELLOW}Verifying installation...${NC}\n"
      ls -la /usr/local/bin/nvim
      ls -la /usr/local/share/nvim
      ls -la /usr/local/lib/nvim
      
      printf "${YELLOW}Cleaning up...${NC}\n"
      rm -rf /tmp/${EXTRACT_DIR} /tmp/nvim.download.tar.gz
      
      printf "${GREEN}Neovim Nightly has been installed successfully!${NC}\n"
      printf "${YELLOW}Testing installation...${NC}\n"
      /usr/local/bin/nvim --version
    else
      ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')
      printf "${RED}Neovim Nightly has NOT been installed! ERROR: ${ERROR_MESSAGE}${NC}\n"
    fi
  fi
}

rm /tmp/nvim28dce75c-4317-4006-a103-8069d573e2b2

while [ $SHOW_PROMPT -gt 0 ]; do
    read -p "Do you wish to install/update neovim? [yes/no] " yn
    case $yn in
        [Yy]* ) update_neovim; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
