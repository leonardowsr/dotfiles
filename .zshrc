# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""  # Desativado — usando Starship

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)

# zsh-autocomplete: mostrar só histórico (estilo PowerShell PredictiveIntelliSense)
zstyle ':autocomplete:*' default-context history-incremental-search-backward
zstyle ':autocomplete:*' min-input 1
source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

atualizar-hml() {
  local originalBranch="develop"

  echo "➡️  Mudando para a branch homolog..."
  git switch homolog || return 1

  echo "⬇️  Atualizando homolog (git pull)..."
  git pull || {
    git switch "$originalBranch"
    return 1
  }

  echo "🔁  Rebaseando homolog com develop..."
  git rebase develop || {
    echo "❌ Rebase falhou. Resolva os conflitos antes de continuar."
    return 1
  }

  echo "🚀  Enviando alterações para origin/homolog..."
  git push origin homolog --force-with-lease || {
    git switch "$originalBranch"
    return 1
  }

  echo "↩️  Voltando para a branch develop..."
  git switch "$originalBranch"

  echo "✅ homolog atualizada e você está de volta em develop!"
}
# Android SDK (Windows via WSL)
export ANDROID_HOME=/mnt/c/Users/leona/AppData/Local/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# Java (Windows JDK via WSL)
export JAVA_HOME="/mnt/c/Program Files/Microsoft/jdk-17.0.17.10-hotspot"
export PATH=$PATH:$JAVA_HOME/bin

# --- Atalhos do trabalho ---
run() {
  case "$1" in
    shell)
      cd ~/projetos/bigdata/web-shell && pnpm dev
      ;;
    ponto)
      cd ~/projetos/bigdata/api-ponto && uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
      ;;
    *)
      echo "Uso: run [shell|ponto]"
      ;;
  esac
}

# Git commit com format + lint - usage: gci "mensagem"
unalias gc 2>/dev/null
gc() {
  [[ -z "$1" ]] && echo "Uso: gc \"mensagem do commit\"" && return 1
  npm run format || return 1
  npm run lint || return 1
  npm run lint:fix || return 1
  git add .
  git commit -m "$1"
}

# Biome fix nos arquivos alterados
bfix() {
  git diff --name-only HEAD | xargs -I {} npx biome check --write {}
}

# Abre emulador Android (via Windows)
emu() {
  cmd.exe /C "start /B %LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe -avd Pixel_7" 2>/dev/null &
}

# --- Corrigia shortcuts ---
cai() {
  local root="$HOME/corrigia"
  local native="$root/apps/native"
  local server="$root/apps/server"

  case "$1" in
    dev)
      cd "$native" && pnpm start
      ;;
    build)
      cd "$native" && pnpm install && pnpm prebuild:clean && pnpm android
      ;;
    prebuild)
      cd "$native" && pnpm prebuild:clean
      ;;
    android)
      cd "$native" && pnpm android
      ;;
    install)
      cd "$native" && pnpm install
      ;;
    server)
      cd "$server" && pnpm dev
      ;;
    emu)
      cmd.exe /C "start /B %LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe -avd Pixel_7" 2>/dev/null &
      ;;
    studio)
      cmd.exe /C "start /B %LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe -avd Pixel_7" 2>/dev/null &
      cd "$native" && pnpm start
      ;;
    clean)
      cd "$native" && rm -rf android && pnpm prebuild:clean && pnpm android
      ;;
    tunnel)
      cd "$native" && pnpm start -- --tunnel
      ;;
    logs)
      adb logcat '*:S' ReactNative:V ReactNativeJS:V expo:V
      ;;
    db)
      cd "$server" && pnpm exec prisma studio
      ;;
    all)
      cd "$server" && pnpm dev &
      cd "$native" && pnpm start
      ;;
    device)
      cd "$native"
      local device=$(adb devices | grep -E '^\S+\s+device$' | grep -v emulator | awk '{print $1}' | head -1)
      if [[ -z "$device" ]]; then
        echo "Nenhum device USB encontrado. Conecte o celular com depuracao USB."
        return 1
      fi
      echo "Device: $device"
      echo "Buildando e instalando..."
      cd "$native/android" && ./gradlew app:assembleDebug -PreactNativeArchitectures=arm64-v8a || { echo "Build falhou!"; return 1; }
      adb -s "$device" install -r "$native/android/app/build/outputs/apk/debug/app-debug.apk" || { echo "Instalacao falhou!"; return 1; }
      echo "App instalado! Iniciando Metro..."
      cd "$native" && npx expo start --dev-client
      ;;
    *)
      echo "\033[35mCorrigia CLI\033[0m"
      echo ""
      echo "  \033[36mcai dev\033[0m        Inicia o Expo (metro bundler)"
      echo "  \033[36mcai build\033[0m      Install + prebuild + run android"
      echo "  \033[36mcai prebuild\033[0m   Prebuild clean (gera android/)"
      echo "  \033[36mcai android\033[0m    Roda no emulador/device"
      echo "  \033[36mcai install\033[0m    pnpm install em apps/native"
      echo "  \033[36mcai server\033[0m     Inicia o servidor Fastify"
      echo "  \033[36mcai emu\033[0m        Abre o emulador Pixel_7"
      echo "  \033[36mcai studio\033[0m     Emulador + Expo juntos"
      echo "  \033[36mcai clean\033[0m      Remove android/ + rebuild completo"
      echo "  \033[36mcai tunnel\033[0m     Expo com tunnel (ngrok)"
      echo "  \033[36mcai device\033[0m     Build + instala no celular USB + Metro"
      echo "  \033[36mcai logs\033[0m       Logs do celular (React Native + Expo)"
      echo "  \033[36mcai db\033[0m         Abre Prisma Studio (visualizar banco)"
      echo "  \033[36mcai all\033[0m        Server + Metro juntos"
      echo ""
      ;;
  esac
}

# Skip armeabi-v7a to avoid long path issues
export ORG_GRADLE_PROJECT_reactNativeArchitectures="arm64-v8a,x86_64"

# Kill processes by port(s) - usage: killp 3000 3001 8081
killp() {
  for port in "$@"; do
    local pids=$(lsof -ti :"$port" 2>/dev/null)
    if [[ -n "$pids" ]]; then
      echo "$pids" | xargs kill -9
      echo "Porta $port: processo(s) encerrado(s)"
    else
      echo "Porta $port: nenhum processo encontrado"
    fi
  done
}

# Recarregar zshrc
alias reload="source ~/.zshrc"

# --- Ferramentas modernas ---

# eza (substitui ls)
alias ls="eza --icons"
alias ll="eza --icons -la"
alias lt="eza --icons --tree --level=2"

# zoxide (cd inteligente)
eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"
