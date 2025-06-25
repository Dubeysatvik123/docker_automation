#!/bin/bash

set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${BLUE}Checking and installing dependencies...${RESET}"

# Function to install Docker
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker not found. Installing Docker...${RESET}"
        sudo apt update
        sudo apt install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release

        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
            sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        sudo systemctl start docker
        sudo systemctl enable docker

        echo -e "${GREEN}Docker installed successfully.${RESET}"
    else
        echo -e "${GREEN}Docker is already installed.${RESET}"
    fi
}

# Function to install aichat (assumes GitHub repo)
install_aichat() {
    if ! command -v aichat &> /dev/null; then
        echo -e "${YELLOW}Installing 'aichat' CLI...${RESET}"
        
        # Install pip if not available
        if ! command -v pip3 &> /dev/null; then
            sudo apt install -y python3-pip
        fi

        # Install aichat using pip
        pip3 install --upgrade aichat

        echo -e "${GREEN}aichat installed successfully.${RESET}"
    else
        echo -e "${GREEN}aichat is already installed.${RESET}"
    fi
}

# Ensure utilities are available
install_utilities() {
    echo -e "${YELLOW}Checking essential utilities...${RESET}"
    sudo apt install -y git curl jq
    echo -e "${GREEN}All essential utilities are ready.${RESET}"
}

# Run all install steps
install_utilities
install_docker
install_aichat

echo -e "${BLUE}All dependencies installed. You can now run your Docker Management Tool script.${RESET}"
