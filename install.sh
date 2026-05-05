#!/bin/bash
set -e

echo "=== opencode-setup installer ==="

SKILLS=(
    "obra/superpowers@brainstorming"
    "juliusbrussee/caveman@caveman"
    "intellectronica/agent-skills@context7"
    "obra/superpowers@find-skills"
    "obra/superpowers@finishing-a-development-branch"
    "anthropics/skills@frontend-design"
    "dammyjay93/interface-design@interface-design"
    "forrestchang/andrej-karpathy-skills@karpathy-guidelines"
    "astro-han/karpathy-llm-wiki@karpathy-llm-wiki"
    "kepano/obsidian-skills@obsidian-cli"
    "kepano/obsidian-skills@obsidian-markdown"
    "obra/superpowers@root-cause-tracing"
    "obra/superpowers@skill-creator"
    "obra/superpowers@systematic-debugging"
    "obra/superpowers@test-driven-development"
    "obra/superpowers@using-git-worktrees"
    "vercel-labs/agent-skills@vercel-react-best-practices"
    "obra/superpowers@webapp-testing"
    "obra/superpowers@writing-plans"
)

install_skills() {
    echo "Installing skills..."
    for pkg in "${SKILLS[@]}"; do
        skill_name=$(echo "$pkg" | sed 's/.*@//')
        if [ -d "$HOME/.agents/skills/$skill_name" ]; then
            echo "  - $skill_name already installed, skipping"
        else
            echo "  - installing $pkg"
            npx skills add "$pkg" -g -y || echo "  - failed to install $pkg"
        fi
    done
}

install_custom_skills() {
    echo "Installing custom skills from GitHub..."

    # Skill 1: test-scenario-hygiene
    if [ -d "$HOME/.agents/skills/test-scenario-hygiene" ]; then
        echo "  - test-scenario-hygiene already installed, skipping"
    else
        echo "  - cloning majiayu000/claude-skill-registry"
        tmp_dir=$(mktemp -d)
        if git clone --depth 1 https://github.com/majiayu000/claude-skill-registry "$tmp_dir/claude-skill-registry" 2>/dev/null; then
            if [ -d "$tmp_dir/claude-skill-registry/skills/other/test-scenario-hygiene" ]; then
                mkdir -p "$HOME/.agents/skills/test-scenario-hygiene"
                cp -r "$tmp_dir/claude-skill-registry/skills/other/test-scenario-hygiene/"* "$HOME/.agents/skills/test-scenario-hygiene/"
                echo "  - test-scenario-hygiene installed"
            else
                echo "  - WARNING: test-scenario-hygiene folder not found in repo"
            fi
        else
            echo "  - WARNING: failed to clone majiayu000/claude-skill-registry"
        fi
        rm -rf "$tmp_dir"
    fi

    # Skill 2: creating-debug-tests-and-iterating
    if [ -d "$HOME/.agents/skills/creating-debug-tests-and-iterating" ]; then
        echo "  - creating-debug-tests-and-iterating already installed, skipping"
    else
        echo "  - cloning cbxm/ellipses"
        tmp_dir=$(mktemp -d)
        if git clone --depth 1 https://github.com/cbxm/ellipses "$tmp_dir/ellipses" 2>/dev/null; then
            if [ -d "$tmp_dir/ellipses/claude/.claude/profiles/amol/skills/creating-debug-tests-and-iterating" ]; then
                mkdir -p "$HOME/.agents/skills/creating-debug-tests-and-iterating"
                cp -r "$tmp_dir/ellipses/claude/.claude/profiles/amol/skills/creating-debug-tests-and-iterating/"* "$HOME/.agents/skills/creating-debug-tests-and-iterating/"
                echo "  - creating-debug-tests-and-iterating installed"
            else
                echo "  - WARNING: creating-debug-tests-and-iterating folder not found in repo"
            fi
        else
            echo "  - WARNING: failed to clone cbxm/ellipses"
        fi
        rm -rf "$tmp_dir"
    fi
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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_skills
install_custom_skills
install_mcp
merge_config
copy_mcp_config
install_agents_md

echo "=== Done! ==="
echo ""
read -p "Press Enter to exit..."