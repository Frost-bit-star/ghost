<p align="center">
  <img src="IMG-20250705-WA0016.jpg" width="120" />
</p>

<h1 align="center">👻 Ghost - opencode-style Multi-Agent Termux Assistant</h1>

<p align="center">
  <b>Pure Bash</b> · <b>opencode agents</b> · <b>Termux</b> · <b>Ethical hacking</b>
</p>

---

## 🧠 What changed (v5.0)

Ghost was rebuilt to work **like opencode**: a multi-agent assistant for Termux.

- **PURE BASH** — only needs `bash`, `curl` or `wget`, and `jq`. No Python, no Node.
- **Real opencode agents** — the backend is a running `opencode serve` server, and Ghost
  maps 1:1 to the same agents opencode uses:
  - `build` *(primary)* — full access: install / configure / run
  - `plan` *(primary, read-only)* — numbered plans, never executes
  - `general` *(subagent)* — multi-step tasks
  - `explore` *(subagent, read-only)* — recon / exploration
  - `scout` — research (CVEs, exploit-db, docs) via `general`
  - hidden `title` / `summary` / `compaction` agents run automatically
- **Agent routing** — tasks are auto-routed to the best agent. Force one with `@agent`.
- **TAB** switches primary agent (build ↔ plan), like opencode's Tab.
- **Works without opencode too** — falls back to any OpenAI-compatible provider
  (OpenRouter, Groq, OpenAI, etc.) with your own key.

---

## 🚀 Backend

### Option A (recommended): opencode server

Run this on a desktop/PC:

```bash
opencode serve --port 4096 --hostname 0.0.0.0
```

Then in Termux, set the URL (first run asks, or edit `~/.config/ghost/config`):

```bash
ghost
/config   # choose "opencode server", enter http://<PC-IP>:4096
```

Ghost then talks to opencode's real HTTP API (`/session`, `/session/:id/message`)
using its actual agents and the credentials opencode already has.

### Option B: your own OpenAI-compatible provider

```bash
ghost
/config   # choose provider, paste API URL + key + model
```

---

## 📦 Installation

```bash
pkg install curl jq -y
wget https://raw.githubusercontent.com/Frost-bit-star/ghost/main/ghost/usr/bin/ghost -O $PREFIX/bin/ghost
chmod +x $PREFIX/bin/ghost
ghost
```

Or build the deb:

```bash
./build-deb.sh   # produces debs/ghost.deb
```

---

## 💡 Usage

```
what is my ip                     → routed automatically
@explore list what is installed   → force the explore agent
@plan how should i scan a network → force the plan agent (read-only)
@scout searchsploit apache 2.4    → research + commands
TAB                               → switch build ↔ plan
/agents  /agent <name>  /config  /status  /help  /clear  exit
```

Ghost shows every command and asks **y/n before executing**. If a command fails,
the general agent proposes a fix.

---

## ⚠️ Disclaimer

For educational use and **authorized penetration testing only**. Only scan or test
systems you own or have written permission to assess. The developer is not
responsible for misuse.

Stay connected:
- 👉 https://github.com/Frost-bit-star
- 👉 https://youtube.com/@Mr_termux-r2l
