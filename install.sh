#!/usr/bin/env bash

PLATFORM="$(uname -s)"

if [[ "${PLATFORM}" != "Darwin" ]]; then
    echo "Not a supported operating system. Exiting..."
    exit 1
fi

# Install XCode Command Line Tools if missing
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select --print-path &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools already installed."
fi

# Install Homebrew
echo "Checking for Homebrew..."
if test ! "$(which brew)"; then
	echo "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Homebrew installed!"
else
	echo "$(brew --version) already installed."
fi

# Check brew doctor
brew doctor

# Terminal selection
echo "Select terminal (1: Alacritty, 2: Warp, default: Ghostty):"
read -r choice
case "$choice" in
  "1")
    SELECTED="alacritty"
    ;;
  "2")
    SELECTED="warp"
    ;;
  *)
    SELECTED="ghostty"
    ;;
esac
echo "Selected: $SELECTED"

# Define packages
FORMULAS=("bat" "fd" "fnm" "fzf" "hyperfine" "lazygit" "lazydocker" "opencode" "ripgrep" "tree" "uv" "zellij" "zoxide")
CASKS=("1password" "cursor" "docker-desktop" "google-chrome" "rectangle" "slack")
CASKS+=("$SELECTED")

# Install formulas
for formula in "${FORMULAS[@]}"; do
    brew install -v "$formula"
done

# Install casks
for cask in "${CASKS[@]}"; do
    brew install -v --cask "$cask"
done

# Install fzf autocompletion and key bindings
if command -v fzf &>/dev/null; then
	echo "Installing fzf autocomplete and key bindings..."
	"$(brew --prefix)"/opt/fzf/install
fi

# Ensure .oh-my-zsh is already installed
if [[ -z "${ZSH}" || ! -d "${ZSH}" ]]; then
	echo "Oh My Zsh not found. Installing..."
	sh -c "$(curl -sSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo "Oh My Zsh already installed."
fi

if [[ -z "${ZSH_CUSTOM}" ]]; then
	ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
fi

# Download zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
	echo "Installing zsh-autosuggestions plugin..."
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
else
	echo "zsh-autosuggestions plugin already installed."
fi

# Download zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
	echo "Installing zsh-syntax-highlighting plugin..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
	echo "zsh-syntax-highlighting plugin already installed."
fi

echo "zsh setup complete."

# Configure shells
configure_shell() {
  local shell=$1
  local rc_file=$2
  if [[ -f "$rc_file" ]]; then
    echo "# zoxide" >> "$rc_file"
    echo 'if command -v zoxide >/dev/null 2>&1; then' >> "$rc_file"
    echo '  export _ZO_DATA_DIR="${HOME}/.local/share/zoxide"' >> "$rc_file"
    echo "  eval \"\$(zoxide init $shell)\"" >> "$rc_file"
    echo 'fi' >> "$rc_file"
    echo "# fnm" >> "$rc_file"
    echo 'if command -v fnm &>/dev/null; then' >> "$rc_file"
    echo '  eval "$(fnm env --use-on-cd)"' >> "$rc_file"
    echo 'fi' >> "$rc_file"
  fi
}

configure_shell zsh "${HOME}/.zshrc"
configure_shell bash "${HOME}/.bashrc"

# Set aliases in .bash_aliases and source in rc files
if [[ ! -f "${HOME}/.bash_aliases" ]]; then
  touch "${HOME}/.bash_aliases"
fi
echo 'alias lg="lazygit"' >> "${HOME}/.bash_aliases"
echo 'alias ldock="lazydocker"' >> "${HOME}/.bash_aliases"
echo 'alias cat="bat"' >> "${HOME}/.bash_aliases"

# Ensure .bashrc sources .bash_aliases
if [[ -f "${HOME}/.bashrc" ]] && ! grep -q "source ~/.bash_aliases" "${HOME}/.bashrc"; then
  echo 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi' >> "${HOME}/.bashrc"
fi

# Ensure .zshrc sources .bash_aliases
if [[ -f "${HOME}/.zshrc" ]] && ! grep -q "source ~/.bash_aliases" "${HOME}/.zshrc"; then
  echo 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi' >> "${HOME}/.zshrc"
fi

echo "Environment ready! Open up ${SELECTED^} to get started!"
exit 0
