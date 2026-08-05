<p align="center">
  <img src="IMG-20250705-WA0016.jpg" width="120" />
</p>

<h1 align="center">👻 Ghost - opencode-style Multi-Agent Termux Assistant</h1>

<p align="center">
  <b>Pure Bash</b> · <b>Agent team</b> · <b>Termux</b> · <b>Ethical hacking</b>
</p>

---

## 🧠 What changed (v5.0)

Ghost was rebuilt to work **like opencode**: a multi-agent assistant for Termux.

- **PURE BASH** — only needs `bash`, `curl` or `wget`, and `jq`. No Python, no Node.
- **Real agents** — backed by a running `opencode serve` server (maps 1:1 to opencode's
  agents) or by any standalone OpenAI-compatible provider. The agent team:
  - `build` *(primary)* — full access: install / configure / run
  - `plan` *(primary, read-only)* — numbered plans, never executes
  - `general` *(subagent)* — multi-step tasks
  - `explore` *(subagent, read-only)* — recon / exploration
  - `scout` — research (CVEs, exploit-db, docs)
  - hidden `title` / `summary` / `compaction` agents run automatically
- **🤝 Team collaboration (on by default)** — agents help each other instead of giving
  duplicate answers:
  - **Handoff** — any agent can reply `HANDOFF: <agent> <sub-task>` to delegate part of
    the job to a teammate (explore for recon, scout for research, plan for strategy).
    The teammate's result is fed back so the agent can continue.
  - **Auto-failover** — if an agent's backend is down or errors, the next working
    backend takes over automatically (`[failover: … → … took over]`). Works with a
    single provider, and even better with several.
  - **`/team <task>`** — plan agent makes the plan first, then build executes it with
    the plan in hand.
- **Multiple providers** — connect several backends and run a full agent team over
  them: `/config` saves each provider as a profile (`~/.config/ghost/providers/`),
  `/assign` maps any agent to any profile, `/profiles` lists everything. No `/assign`
  needed — failover uses every saved profile automatically.
- **Ollama** — choice `7` in `/config` auto-installs Ollama in Termux, starts the
  server, and offers to pull a phone-sized model (`llama3.2:1b`).
- **Agent routing** — tasks are auto-routed to the best agent. Force one with `@agent`.
- **TAB** switches primary agent (build ↔ plan), like opencode's Tab.
- **Works without opencode too** — falls back to any OpenAI-compatible provider
  (OpenRouter, Groq, OpenAI, etc.) with your own key.

---

## 🚀 Backend

**No opencode needed.** Ghost works standalone on the phone with any provider key.
On first run it walks you through picking a provider:

```
ghost
  └─ Pick a provider: Gemini (free) / Groq (free) / OpenRouter (free models) /
                      OpenAI / Anthropic / DeepSeek / Ollama (no key) / custom
```

Paste your key once — it's saved to `~/.config/ghost/config` (chmod 600), and a copy
is saved as a **profile** in `~/.config/ghost/providers/` so you can switch or use it
as a teammate later. Free tiers: **Gemini, Groq, OpenRouter** all give free keys in
minutes.

### 🤝 Multi-provider team

Connect several providers and Ghost becomes a real team — every saved profile is a
standby backend and agents fail over to each other automatically:

```
/config        → add each provider (Gemini, Groq, OpenRouter, Ollama, …)
/assign        → pin an agent to a profile (e.g. explore → Ollama, local & free)
/profiles      → list saved providers + assignments
/team <task>   → plan first, then build with the plan; agents delegate to each other
/status        → shows the active backend + team assignments
```

No `/assign` required: failover automatically tries the agent's own backend, then
every saved profile, then the global backend.

### Optionally: use a desktop running opencode

If a PC on your LAN runs `opencode serve`, Ghost can drive opencode's *real* agents
(build/plan/general/explore) through its HTTP API:

```bash
opencode serve --port 4096 --hostname 0.0.0.0   # on desktop
ghost -> /config -> opencode server -> http://<PC-IP>:4096
```

Ghost auto-detects the opencode server first, and falls back to your standalone
provider if it's not reachable.

---

## 📦 Installation

```bash
pkg install curl jq -y
wget https://raw.githubusercontent.com/Frost-bit-star/ghost/main/ghost/usr/bin/ghost -O $PREFIX/bin/ghost
chmod +x $PREFIX/bin/ghost
ghost        # first run: pick a provider + paste key
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
/team set up a full port scan     → plan agent plans, build executes, teammates help
TAB                               → switch build ↔ plan
/agents  /agent <name>  /config  /assign  /profiles  /status  /help  /clear  exit
```

Ghost shows every command and asks **y/n before executing**. If a command fails,
the review agent reads the real output and proposes a fix. Agents ask numbered
questions when they need info, and delegate sub-tasks to each other via handoff.

### Update

```bash
ghost -> type: update     # fetches the latest version and restarts
```

---

## ⚠️ Disclaimer

For educational use and **authorized penetration testing only**. Only scan or test
systems you own or have written permission to assess. The developer is not
responsible for misuse.

Stay connected:
- 👉 https://github.com/Frost-bit-star
- 👉 https://youtube.com/@Mr_termux-r2l
