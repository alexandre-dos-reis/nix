#!/usr/bin/env bun

import { $ } from "bun";
import type { WindowInfo } from "./types";
import { parseArgs } from "util";

const {
  values: { class: classInput, workspace: workspaceInput },
} = parseArgs({
  args: Bun.argv,
  options: {
    workspace: {
      type: "string",
    },
    class: {
      type: "string",
    },
  },
  strict: true,
  allowPositionals: true,
});

if (!classInput || !workspaceInput) {
  console.log("Some arguments are missing...");
  process.exit(1);
}

const clients = (
  JSON.parse(await $`hyprctl clients -j`.text()) as Array<WindowInfo>
).filter((c) => c.class === classInput);

const commands = clients.map(
  (c) => `dispatch movetoworkspace ${workspaceInput}, address:${c.address}`,
);

await $`hyprctl --batch "${commands.join(" ; ")} ; dispatch workspace ${workspaceInput}"`;
