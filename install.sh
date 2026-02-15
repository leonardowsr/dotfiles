#!/bin/bash
set -e

echo "========================================="
echo "  Dotfiles - Restauracao automatica"
echo "  github.com/leonardowsr/dotfiles"
echo "========================================="
echo ""

# --- 1. Zsh ---
echo "[1/7] Instalando Zsh..."
if ! command -v zsh &>/dev/null; then
  sudo apt update && sudo apt install -y zsh
else
  echo "  -> Zsh ja instalado"
fi

# --- 2. Oh My Zsh ---
echo "[2/7] Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "  -> Oh My Zsh ja instalado"
fi

# --- 3. Plugins customizados do Zsh ---
echo "[3/7] Instalando plugins Zsh..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
  ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo "  -> Clonando $plugin..."
    git clone "${plugins[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
  else
    echo "  -> $plugin ja instalado"
  fi
done

# --- 4. Ferramentas CLI modernas ---
echo "[4/7] Instalando ferramentas CLI..."

# eza
if ! command -v eza &>/dev/null; then
  echo "  -> Instalando eza..."
  sudo apt install -y eza
else
  echo "  -> eza ja instalado"
fi

# zoxide
if ! command -v zoxide &>/dev/null; then
  echo "  -> Instalando zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  echo "  -> zoxide ja instalado"
fi

# Starship
if ! command -v starship &>/dev/null; then
  echo "  -> Instalando Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "  -> Starship ja instalado"
fi

# --- 5. Copiar .zshrc ---
echo "[5/7] Copiando .zshrc..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
  echo "  -> Backup salvo em ~/.zshrc.bak"
fi
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo "  -> .zshrc copiado"

# Copiar starship.toml
if [ -f "$SCRIPT_DIR/starship.toml" ]; then
  mkdir -p "$HOME/.config"
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
  echo "  -> starship.toml copiado"
fi

# --- 6. Definir Zsh como shell padrao ---
echo "[6/7] Definindo Zsh como shell padrao..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
  echo "  -> Shell alterado para Zsh"
else
  echo "  -> Zsh ja e o shell padrao"
fi

# --- 7. Nerd Font (lembrete) ---
echo "[7/7] Fonte Nerd Font..."
echo ""
echo "  IMPORTANTE: Instale uma Nerd Font no Windows para icones:"
echo ""
echo "  No PowerShell do Windows, rode:"
echo "    winget install Nerd-Fonts.JetBrainsMono"
echo ""
echo "  Depois configure no VSCode (settings.json):"
echo '    "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font"'
echo ""

echo "========================================="
echo "  Tudo instalado! Abra um novo terminal"
echo "  ou rode: source ~/.zshrc"
echo "========================================="
