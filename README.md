# dotfiles

Backup das minhas configuracoes de terminal (Zsh + Oh My Zsh) no WSL.

## O que tem aqui

| Arquivo | Descricao |
|---------|-----------|
| `.zshrc` | Configuracao completa do Zsh (plugins, aliases, funcoes, env vars) |
| `starship.toml` | Tema powerline/agnoster do Starship |
| `install.sh` | Script automatico que instala e restaura tudo |

## O que e instalado

### Shell e Framework
- **Zsh** — shell padrao
- **Oh My Zsh** — framework de plugins e temas

### Plugins Zsh
| Plugin | O que faz |
|--------|-----------|
| `git` | ~150 aliases de git (gst, gco, gp, etc.) |
| `zsh-autosuggestions` | Sugere comandos baseado no historico |
| `zsh-syntax-highlighting` | Destaca comandos validos/invalidos enquanto digita |
| `zsh-autocomplete` | Autocomplete em tempo real estilo IDE |
| `you-should-use` | Avisa quando voce digita um comando que tem alias |

### Ferramentas CLI
| Ferramenta | Substitui | O que faz |
|------------|-----------|-----------|
| `eza` | `ls` | Listagem com icones, cores e git status |
| `zoxide` | `cd` | Navegacao inteligente — aprende seus diretorios |
| `starship` | prompt | Prompt rapido e bonito com info de git, node, etc. |

### Aliases personalizados
| Alias | Comando |
|-------|---------|
| `ls` | `eza --icons` |
| `ll` | `eza --icons -la` |
| `lt` | `eza --icons --tree --level=2` |
| `z <dir>` | zoxide — pula para o diretorio (ex: `z corrigia`) |
| `reload` | `source ~/.zshrc` |
| `killp <porta>` | Mata processos em uma porta |

---

## Restauracao em PC novo (passo a passo)

### 1. Instalar WSL (se ainda nao tiver)

No PowerShell do Windows (como admin):

```powershell
wsl --install
```

Reinicie o PC e configure usuario/senha do Ubuntu.

### 2. Instalar pre-requisitos

```bash
sudo apt update && sudo apt install -y git curl
```

### 3. Clonar este repositorio

```bash
git clone https://github.com/leonardowsr/dotfiles.git ~/dotfiles
```

### 4. Rodar o script de instalacao

```bash
cd ~/dotfiles
./install.sh
```

O script instala tudo automaticamente:
- Zsh + Oh My Zsh
- Todos os plugins
- eza, zoxide, Starship
- Copia o `.zshrc` (faz backup do existente)
- Define Zsh como shell padrao

### 5. Instalar Nerd Font (para icones)

No **PowerShell do Windows**:

```powershell
winget install Nerd-Fonts.JetBrainsMono
```

### 6. Configurar fonte no VSCode

Abra Settings (`Ctrl+,`) e adicione:

```json
"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font"
```

### 7. Abrir novo terminal

Feche e abra o terminal. Tudo pronto!

---

## Atualizando o backup

Quando modificar o `.zshrc`, atualize o backup:

```bash
cp ~/.zshrc ~/dotfiles/.zshrc
cd ~/dotfiles
git add -A && git commit -m "atualizar zshrc" && git push
```
