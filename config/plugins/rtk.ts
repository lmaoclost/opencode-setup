import { Plugin } from "@opencode/plugin"
import { spawnSync } from "node:child_process"

// RTK OpenCode plugin — rewrites commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// Thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

// Ported from the V1 plugin API to V2 (Plugin.define + ctx.tool.hook).

export default Plugin.define({
  id: "rtk.rewrite",
  async setup(ctx) {
    if (!checkRtk()) {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    await ctx.tool.hook("execute.before", (event) => {
      const tool = String(event.tool ?? "").toLowerCase()
      if (tool !== "bash" && tool !== "shell") return

      const input = event.input as { command?: unknown } | undefined
      const command = input?.command
      if (typeof command !== "string" || !command) return

      try {
        // rtk >= 0.44 prints the rewrite to stdout when supported and exits
        // nonzero either way, so stdout — not the exit code — decides.
        const result = spawnSync("rtk", ["rewrite", command], {
          encoding: "utf8",
          timeout: 5_000,
        })
        const rewritten = result.stdout?.trim()
        if (result.error || !rewritten || rewritten === command) return
        input.command = rewritten
      } catch {
        // rtk missing or failed — pass through unchanged
      }
    })
  },
})

function checkRtk(): boolean {
  try {
    const result = spawnSync("rtk", ["--version"], { encoding: "utf8", timeout: 5_000 })
    return !result.error && (result.status === 0 || result.stdout.startsWith("rtk "))
  } catch {
    return false
  }
}