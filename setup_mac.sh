#!/bin/bash

# Funzione per chiedere conferma [y/N]
ask_for_confirmation() {
    while true; do
        read -r -p "$1 [y/N]: " response
        case "$response" in
        [yY][eE][sS] | [yY])
            return 0 # Risposta affermativa, esci con 0 (successo)
            ;;
        [nN][oO] | [nN] | '')
            return 1 # Risposta negativa o vuota, esci con 1 (fallimento)
            ;;
        *)
            echo "Risposta non valida. Inserisci 'y' o 'n'."
            ;;
        esac
    done
}

if ask_for_confirmation "Vuoi continuare con l'installazione?"; then
    echo "Inizio installazione..."
else
    echo "Installazione annullata."
    exit 1
fi

# Funzione per controllare se un comando esiste
command_exists() {
    command -v "$1" &>/dev/null
}

# Installazione di Homebrew
if command_exists brew; then
    echo "Homebrew è già installato"
    echo "---------------------------------"

else
    echo "Installazione di Homebrew 🚀"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "---------------------------------"

fi

# Aggiornamento di Homebrew
echo "Aggiornamento di Homebrew 🚀"
brew update
echo "---------------------------------"

# Lista di pacchetti da installare con Homebrew
BREW_PACKAGES=(
    git
    python
    wget
    htop
    zsh
)

# Installazione pacchetti Homebrew
echo "Installazione pacchetti Homebrew 🚀"
for package in "${BREW_PACKAGES[@]}"; do
    if brew list -1 | grep -q "^${package}\$"; then
        echo "$package è già installato"
        echo "---------------------------------"
    else
        brew install "$package"
        echo "---------------------------------"
    fi
done

# Installazione di NVM (Node Version Manager)
if [ -d "$HOME/.nvm" ]; then
    echo "NVM è già installato"
    echo "---------------------------------"

else
    echo "Installazione di NVM 🚀"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    echo "Installazione di Node.js con NVM (LTS) 🚀"
    nvm install --lts # Installa l'ultima versione di Node.js

    if ask_for_confirmation "Vuoi usare la versione di Node.js appena installata?"; then
        echo "Inizio installazione..."
        nvm use --lts # Usa la versione installata di Node.js
    else
        echo "Prosegui setup MacBook."
        exit 1
    fi

    echo "---------------------------------"
fi

# Carica NVM per lo script corrente
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Questo carica NVM

if ask_for_confirmation "Vuoi continuare con l'installazione di librerie e pacchetti facoltativi [ZSH, NUMPY, PANDAS, ecc]?"; then
    echo "Inizio installazione 🚀"
    echo "---------------------------------"

    # Spotify
    echo "Installazione di Spotify 🚀"
    brew install --cask spotify
    echo "---------------------------------"

    # Stats
    echo "Installazione di Stats 🚀"
    brew install stats
    echo "---------------------------------"

    # Rectangle
    echo "Installazione di Rectangle 🚀"
    brew install --cask rectangle
    echo "---------------------------------"

    # Hiddenbar
    echo "Installazione di Hiddenbar 🚀"
    brew install --cask hiddenbar
    echo "---------------------------------"

    # Oh-My-Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh-My-Zsh è già installato"
        echo "---------------------------------"
    else
        echo "Installazione di Oh-My-Zsh 🚀"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Installazione di librerie Python globali (usando pip)
    PYTHON_PACKAGES=(
        virtualenv
        requests
        numpy
        pandas
    )

    for package in "${PYTHON_PACKAGES[@]}"; do
        pip3 show "$package" &>/dev/null
        if [ $? -eq 0 ]; then
            echo "$package è già installato"
            echo "---------------------------------"
        else
            pip3 install "$package"
        fi
    done
else
    echo "Installazione annullata."
    exit 1
fi

# Setup completato
echo "Setup completato! 🎉"
