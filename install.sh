#!/bin/bash
set -e

echo "=== opencode-setup installer ==="

SKILLS=(
    "obra/superpowers@brainstorming"
    "juliusbrussee/caveman@caveman"
    "upstash/context7@context7-mcp"
    "vercel-labs/skills@find-skills"
    "obra/superpowers@finishing-a-development-branch"
    "anthropics/skills@frontend-design"
    "mattpocock/skills@grill-with-docs"
    "dammyjay93/interface-design@interface-design"
    "forrestchang/andrej-karpathy-skills@karpathy-guidelines"
    "astro-han/karpathy-llm-wiki@karpathy-llm-wiki"
    "kepano/obsidian-skills@obsidian-cli"
    "kepano/obsidian-skills@obsidian-markdown"
    "neolabhq/context-engineering-kit@root-cause-tracing"
    "anthropics/skills@skill-creator"
    "obra/superpowers@systematic-debugging"
    "obra/superpowers@test-driven-development"
    "obra/superpowers@using-git-worktrees"
    "vercel-labs/agent-skills@vercel-react-best-practices"
    "anthropics/skills@webapp-testing"
    "obra/superpowers@writing-plans"
    "mvanhorn/last30days-skill@last30days"
)

get_skills_dir() {
    if [[ "$HOME" == /home/* ]]; then
        # Git Bash on Windows - use USERPROFILE
        if [ -n "$USERPROFILE" ]; then
            echo "$USERPROFILE/.agents/skills"
        else
            echo "C:/Users/$USER/.agents/skills"
        fi
    else
        echo "$HOME/.agents/skills"
    fi
}

install_skills() {
    echo "Installing skills..."
    SKILLS_DIR=$(get_skills_dir)
    for pkg in "${SKILLS[@]}"; do
        skill_name=$(echo "$pkg" | sed 's/.*@//')
        if [ -d "$SKILLS_DIR/$skill_name" ]; then
            echo "  - $skill_name already installed, skipping"
        else
            echo "  - installing $pkg"
            npx skills add "$pkg" -g -y || echo "  - failed to install $pkg"
        fi
    done
}

install_custom_skills() {
    echo "Installing custom skills from registry..."

    # creating-debug-tests-and-iterating
    npx skills add cbxm/ellipses@creating-debug-tests-and-iterating -g -y || echo "  - failed to install creating-debug-tests-and-iterating"
}

install_mcp() {
    echo "Installing MCPs..."
    if command -v npm &> /dev/null; then
        if [ -d "$HOME/.config/opencode" ]; then
            cd "$HOME/.config/opencode"
            if [ -f "package.json" ]; then
                if [ -d "node_modules/@playwright/mcp" ]; then
                    echo "  - playwright MCP already installed, skipping"
                else
                    echo "  - running npm install"
                    npm install
                fi
            else
                echo "  - no package.json, skipping MCP install"
            fi
        else
            echo "  - opencode config not found, skipping MCP install"
        fi
    else
        echo "  - npm not found, skipping MCP install"
    fi
}

merge_config() {
    echo "Merging opencode.json..."
    CONFIG_DIR="$HOME/.config/opencode"
    CONFIG_FILE="$CONFIG_DIR/opencode.json"

    mkdir -p "$CONFIG_DIR"

    if [ -f "$CONFIG_FILE" ]; then
        echo "  - existing config found, merging..."
        # Simple merge: add missing keys from template to existing
        # This is a basic implementation - for complex merges, use jq
        if command -v jq &> /dev/null; then
            tmp=$(mktemp)
            jq -s '.[0] * .[1]' "$CONFIG_FILE" "$SCRIPT_DIR/config/opencode.json" > "$tmp"
            mv "$tmp" "$CONFIG_FILE"
            echo "  - config merged"
        else
            echo "  - jq not found, copying template (backup existing first)"
            cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
            cp "$SCRIPT_DIR/config/opencode.json" "$CONFIG_FILE"
            echo "  - template copied (backup at $CONFIG_FILE.backup)"
        fi
    else
        echo "  - no existing config, copying template"
        cp "$SCRIPT_DIR/config/opencode.json" "$CONFIG_FILE"
    fi
}

copy_mcp_config() {
    echo "Copying MCP config..."
    CONFIG_DIR="$HOME/.config/opencode"
    mkdir -p "$CONFIG_DIR"

    if [ -f "$CONFIG_DIR/playwright-mcp-brave.json" ]; then
        echo "  - playwright-mcp-brave.json already exists, skipping"
    else
        cp "$SCRIPT_DIR/mcp/playwright-mcp-brave.json" "$CONFIG_DIR/"
        echo "  - copied playwright-mcp-brave.json"
    fi
}

install_agents_md() {
    echo "Installing AGENTS.md..."
    CONFIG_DIR="$HOME/.config/opencode"
    mkdir -p "$CONFIG_DIR"

    if [ -f "$CONFIG_DIR/AGENTS.md" ]; then
        echo "  - AGENTS.md exists, backing up and replacing"
        cp "$CONFIG_DIR/AGENTS.md" "$CONFIG_DIR/AGENTS.md.backup"
    fi
    cp "$SCRIPT_DIR/AGENTS.md" "$CONFIG_DIR/"
    echo "  - AGENTS.md installed"
}

install_rtk() {
    echo "Installing RTK..."
    if command -v rtk &> /dev/null; then
        echo "  - rtk already installed: $(rtk --version 2>&1)"
    else
        OS_TYPE=$(uname -s)
        if [[ "$OS_TYPE" == "Darwin" ]]; then
            echo "  - installing via Homebrew..."
            brew install rtk 2>/dev/null || {
                echo "  - Homebrew failed, trying cargo..."
                cargo install --git https://github.com/rtk-ai/rtk
            }
        elif [[ "$OS_TYPE" == "Linux" ]]; then
            echo "  - installing via script..."
            curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
        else
            echo "  - Windows detected, downloading release..."
            RTK_VERSION=$(curl -s https://api.github.com/repos/rtk-ai/rtk/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
            RTK_URL="https://github.com/rtk-ai/rtk/releases/download/${RTK_VERSION}/rtk-x86_64-pc-windows-msvc.zip"
            TEMP_ZIP="/tmp/rtk.zip"
            curl -fsSL "$RTK_URL" -o "$TEMP_ZIP"
            unzip -o "$TEMP_ZIP" -d "$HOME/.local/bin"
            rm -f "$TEMP_ZIP"
            if [ -f "$HOME/.local/bin/rtk.exe" ]; then
                echo "  - RTK installed to $HOME/.local/bin"
            else
                echo "  - RTK install failed, try: cargo install --git https://github.com/rtk-ai/rtk"
            fi
        fi
    fi
}

install_rtk_plugin() {
    echo "Installing RTK OpenCode plugin..."
    CONFIG_DIR="$HOME/.config/opencode"
    mkdir -p "$CONFIG_DIR/plugins"

    if [ -f "$CONFIG_DIR/plugins/rtk.ts" ]; then
        echo "  - plugin already installed, skipping"
    else
        cp "$SCRIPT_DIR/config/plugins/rtk.ts" "$CONFIG_DIR/plugins/rtk.ts"
        echo "  - plugin installed"
    fi
}

install_rtk_package() {
    echo "Installing RTK plugin dependencies..."
    CONFIG_DIR="$HOME/.config/opencode"

    if [ -d "$CONFIG_DIR" ]; then
        cd "$CONFIG_DIR"
        if [ -f "package.json" ]; then
            if grep -q "@opencode-ai/plugin" "package.json"; then
                echo "  - @opencode-ai/plugin already in package.json, skipping"
            else
                echo "  - adding @opencode-ai/plugin to package.json"
                if command -v jq &> /dev/null; then
                    tmp=$(mktemp)
                    jq '.dependencies["@opencode-ai/plugin"] = "^1.14.18"' package.json > "$tmp"
                    mv "$tmp" package.json
                else
                    echo "  - jq not found, manual edit needed in package.json"
                fi
            fi
        else
            echo "  - no package.json, copying from template..."
            cp "$SCRIPT_DIR/config/package.json" package.json
        fi
        if [ -d "node_modules" ]; then
            echo "  - node_modules exists, run npm install manually to update"
        else
            if command -v npm &> /dev/null; then
                echo "  - running npm install..."
                npm install
            fi
        fi
    fi
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_skills
install_custom_skills
install_mcp
install_rtk
install_rtk_plugin
install_rtk_package
merge_config
copy_mcp_config
install_agents_md

echo "=== Done! ==="
echo ""
read -p "Press Enter to exit..."