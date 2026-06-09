{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  name = "pi-coding-agent";

  env.GREET = "devenv";

  packages = with pkgs; [
    bashInteractive
    pi-coding-agent
    fd
    file
    neovim
    ncurses
    vim
  ];

  containers."pi" = {
    name = "pi";
    copyToRoot = [
      pkgs.vim
      pkgs.bashInteractive
      pkgs.pi-coding-agent
      pkgs.fd
      pkgs.file
      pkgs.neovim
      pkgs.ncurses
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
  scripts.pi-container.exec = ''
    echo "Building container and mounting current directory..."
    devenv container copy pi
    docker run -it --rm -v "$(pwd):/workspace" pi
  '';
}
