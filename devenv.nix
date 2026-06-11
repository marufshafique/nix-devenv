{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  nix2container = inputs.nix2container.packages.${pkgs.stdenv.system}.nix2container;
in
{
  name = "pi-coding-agent";

  env.GREET = "devenv";
  env.DEEPSEEK_API_KEY = config.secretspec.secrets.DEEPSEEK_API_KEY;
  env.ANTHROPIC_BASE_URL = config.secretspec.secrets.ANTHROPIC_BASE_URL;
  env.ANTHROPIC_MODEL = config.secretspec.secrets.ANTHROPIC_MODEL;
  env.ANTHROPIC_AUTH_TOKEN = config.secretspec.secrets.ANTHROPIC_AUTH_TOKEN;
  env.ANTHROPIC_DEFAULT_OPUS_MODEL = config.secretspec.secrets.ANTHROPIC_DEFAULT_OPUS_MODEL;
  env.ANTHROPIC_DEFAULT_SONNET_MODEL = config.secretspec.secrets.ANTHROPIC_DEFAULT_SONNET_MODEL;
  env.ANTHROPIC_DEFAULT_HAIKU_MODEL = config.secretspec.secrets.ANTHROPIC_DEFAULT_HAIKU_MODEL;
  env.CLAUDE_CODE_SUBAGENT_MODEL = config.secretspec.secrets.CLAUDE_CODE_SUBAGENT_MODEL;
  env.CLAUDE_CODE_EFFORT_LEVEL = config.secretspec.secrets.CLAUDE_CODE_EFFORT_LEVEL;

  packages = with pkgs; [
    bashInteractive
    pi-coding-agent
    fd
    file
    neovim
    ncurses
    vim
    claude-code
  ];

  containers."pi" = {
    name = "pi";
    fromImage = nix2container.pullImage {
      imageName = "docker.io/library/alpine";
      imageDigest = "sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11";
      sha256 = "sha256-qxpJA0RokrXxYIIh74d65Kfc3DL9NZG4UuNre7NiqTk=";
    };
    copyToRoot = [
      pkgs.vim
      pkgs.bashInteractive
      pkgs.pi-coding-agent
      pkgs.fd
      pkgs.file
      pkgs.neovim
      pkgs.ncurses
      pkgs.claude-code
    ];

    startupCommand = ''
      export TERM=xterm-256color
      export TERMINFO_DIRS="${pkgs.ncurses}/share/terminfo"
      echo "Welcome to the pi-workspace container!"
      echo "You can run 'hello' to see a greeting."
      echo "🤖 Pi Agent initialized with your custom model scope!"

      mkdir -p ~/.pi/agent
      cp ${./models.json} ~/.pi/agent/models.json

      exec bash
    '';
  };

  # Create a custom host shortcut command
  scripts.pi-build.exec = ''
    echo "Building container and mounting current directory..."
    devenv container copy pi
    docker run --network host -it --rm -v "$(pwd):/workspace" pi
  '';

  scripts.pi-run.exec = ''
    echo "Running container and mounting current directory..."
    docker run --network host -it --rm -v "$(pwd):/workspace" pi
  '';
}
