# Pi Coding Agent — devenv

Reproducible development environment for [pi-coding-agent](https://github.com/anomalyco/pi) using [devenv](https://devenv.sh). Ships as a container with DeepSeek models pre-configured.

## Prerequisites

| Tool | Linux | macOS |
|------|-------|-------|
| [Nix](https://determinate.systems/nix-installer/) | `sh <(curl -L https://install.determinate.systems/nix)` | same |
| [devenv](https://devenv.sh/getting-started/) | via Nix profile or nix run | same |
| [Docker](https://docs.docker.com/engine/install/) | native | [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/) |

> **macOS note:** Docker Desktop runs containers inside a Linux VM. This is automatic — no extra setup needed.

## Quick Start

### 1. Run the container

```bash
# Build, copy to Docker, and start
devenv container copy pi
docker run -it --rm -v "$(pwd):/workspace" pi

# Or use the shortcut script
devenv shell pi-container
```

### 2. Set your API key

```bash
export DEEPSEEK_API_KEY="sk-..."
```


The container mounts your current directory at `/workspace` so your project files are accessible.

## Container Details

| Setting | Value |
|---------|-------|
| Name | `pi` |
| Base | Nix-built image (minimal) |
| Shell | bash |
| Mount point | `/workspace` |

### Installed inside the container

| Package | Purpose |
|---------|---------|
| `pi-coding-agent` | The AI coding agent |

### Models (`models.json`)

Pre-configured with **DeepSeek**:

| Model | Context | Cost (in/out per 1M tokens) |
|-------|---------|---------------------------|
| `deepseek-v4-pro` | 1M | __ / __ |
| `deepseek-v4-flash` | 1M | __ / __ |

Both support reasoning/thinking. The API key is read from the `DEEPSEEK_API_KEY` environment variable.

To add more models, edit `models.json` — see the [pi models documentation](https://github.com/anomalyco/pi/blob/main/docs/models.md) for format details. The file is copied into the container at startup (no rebuild needed to change it — just restart the container).

## Commands

| Command | What it does |
|---------|-------------|
| `devenv shell` | Enter native shell with pi and tools |
| `devenv container copy pi` | Build image and load into Docker |
| `devenv shell pi-container` | Shortcut: build + run container with current directory mounted |
| `docker run -it --rm -v "$(pwd):/workspace" pi` | Run container manually (after `copy`) |

## Platform Notes

### Linux
Everything runs natively. Docker uses the host kernel directly — no VM overhead.

### macOS
- **Docker Desktop required** for containers (uses a lightweight Linux VM under the hood).
- Volume mounts work for paths under `/Users`, `/Volumes`, `/tmp`, and `/var/folders`. Keep your projects in your home directory.
- `devenv shell` works natively on macOS if you want to skip Docker entirely.

### Apple Silicon (M1/M2/M3/M4)
Docker Desktop automatically runs `aarch64` Linux containers. Nix packages in the container are built for `aarch64-linux` — no emulation, full native speed.

## Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `DEEPSEEK_API_KEY` | Yes | API key for DeepSeek models |
| `TERM` | Auto-set in container | Terminal type (`xterm-256color`) |


## Troubleshooting

**Container can't find models**
→ Ensure `DEEPSEEK_API_KEY` is exported in the shell where you run `docker run`. Use `docker run -e DEEPSEEK_API_KEY ...` to pass it explicitly:

**Volume mount shows empty directory on macOS**
→ Docker Desktop only allows mounts from certain paths. Move your project under `/Users/<you>/` if it's elsewhere.
