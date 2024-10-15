#!/bin/bash

# Function to ask for confirmation [y/N]
ask_for_confirmation() {
    while true; do
        read -r -p "$1 [y/N]: " response
        case "$response" in
        [yY][eE][sS] | [yY])
            return 0 # Affirmative response, exit with 0 (success)
            ;;
        [nN][oO] | [nN] | '')
            return 1 # Negative or empty response, exit with 1 (failure)
            ;;
        *)
            echo "Invalid response. Please enter 'y' or 'n'."
            ;;
        esac
    done
}

if ask_for_confirmation "Do you want to continue with the installation?"; then
    echo "Starting installation..."
else
    echo "Installation cancelled."
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Install Homebrew
if command_exists brew; then
    echo "Homebrew is already installed"
    echo "---------------------------------"

else
    echo "Installing Homebrew 🚀"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "---------------------------------"

fi

# Update Homebrew
echo "Updating Homebrew 🚀"
brew update
echo "---------------------------------"

# List of packages to install with Homebrew
BREW_PACKAGES=(
    git
    python
    wget
    htop
    zsh
)

# Install Homebrew packages
echo "Installing Homebrew packages 🚀"
for package in "${BREW_PACKAGES[@]}"; do
    if brew list -1 | grep -q "^${package}\$"; then
        echo "$package is already installed"
        echo "---------------------------------"
    else
        brew install "$package"
        echo "---------------------------------"
    fi
done

# Install NVM (Node Version Manager)
if [ -d "$HOME/.nvm" ]; then
    echo "NVM is already installed"
    echo "---------------------------------"

else
    echo "Installing NVM 🚀"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    echo "Installing Node.js with NVM (LTS) 🚀"
    nvm install --lts # Install the latest Node.js version

    if ask_for_confirmation "Do you want to use the newly installed Node.js version?"; then
        echo "Starting installation..."
        nvm use --lts # Use the installed Node.js version
    else
        echo "Continuing MacBook setup."
        exit 1
    fi

    echo "---------------------------------"
fi

# Load NVM for the current script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads NVM

if ask_for_confirmation "Do you want to continue with the installation of optional libraries and packages [ZSH, NUMPY, PANDAS, etc]?"; then
    echo "Starting installation 🚀"
    echo "---------------------------------"

    # Spotify
    echo "Installing Spotify 🚀"
    brew install --cask spotify
    echo "---------------------------------"

    # Stats
    echo "Installing Stats 🚀"
    brew install stats
    echo "---------------------------------"

    # Rectangle
    echo "Installing Rectangle 🚀"
    brew install --cask rectangle
    echo "---------------------------------"

    # Hiddenbar
    echo "Installing Hiddenbar 🚀"
    brew install --cask hiddenbar
    echo "---------------------------------"

    # Oh-My-Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh-My-Zsh is already installed"
        echo "---------------------------------"
    else
        echo "Installing Oh-My-Zsh 🚀"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Install global Python libraries (using pip)
    PYTHON_PACKAGES=(
        virtualenv
        requests
        numpy
        pandas
    )

    for package in "${PYTHON_PACKAGES[@]}"; do
        pip3 show "$package" &>/dev/null
        if [ $? -eq 0 ]; then
            echo "$package is already installed"
            echo "---------------------------------"
        else
            pip3 install "$package"
        fi
    done
else
    echo "Installation cancelled."
    exit 1
fi

# Setup completed
echo "Setup completed! 🎉"
