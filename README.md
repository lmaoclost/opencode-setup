# opencode-setup

Install script for my opencode config, skills, and MCPs.

## What it installs

- **23 skills** from the skills ecosystem + **2 custom skills** bundled in repo
- **Playwright MCP** for browser automation
- **RTK** (Rust Token Killer) for CLI output compression
- **opencode.json** config (merged with existing)
- **AGENTS.md** instructions

## Usage

```bash
# Clone the repo
git clone https://github.com/lmaoclost/opencode-setup.git
cd opencode-setup

# Run the installer
chmod +x install.sh
./install.sh
```

## Requirements

- Node.js & npm
- npx (comes with npm)

## Configuration

After install, edit `~/.config/opencode/opencode.json` to add your API keys:
- `CONTEXT7_API_KEY` for context7 MCP

For Playwright MCP, edit `~/.config/opencode/playwright-mcp-brave.json` and set your browser path.
