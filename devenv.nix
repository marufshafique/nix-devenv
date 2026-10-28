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
    claude-code
  ];

  # services.postgres = {
  #   enable = true;
  #   package = pkgs.postgresql_16;
  #   listen_addresses = "127.0.0.1";
  #   port = 5432;
  #   createDatabase = true;
  #   initialDatabases = [
  #     { name = "devdb"; }
  #     { name = "bunker"; }
  #   ];
  #   initialScript = ''
  #     CREATE USER postgres WITH SUPERUSER PASSWORD 'password';
  #     GRANT ALL PRIVILEGES ON DATABASE devdb TO postgres;
  #     GRANT ALL PRIVILEGES ON DATABASE bunker TO postgres;
  #     CREATE DATABASE bunker;
  #   '';
  # };

  # containers."pi" = {
  #   name = "pi";
  #   copyToRoot = [
  #     pkgs.vim
  #     pkgs.bashInteractive
  #     pkgs.pi-coding-agent
  #     pkgs.fd
  #     pkgs.file
  #     pkgs.neovim
  #     pkgs.ncurses
  #   ];
  #
  #   startupCommand = ''
  #     export TERM=xterm-256color
  #     export TERMINFO_DIRS="${pkgs.ncurses}/share/terminfo"
  #     echo "Welcome to the pi-workspace container!"
  #     echo "You can run 'hello' to see a greeting."
  #     echo "🤖 Pi Agent initialized with your custom model scope!"
  #
  #     mkdir -p ~/.pi/agent
  #     cp ${./models.json} ~/.pi/agent/models.json
  #
  #     exec bash
  #   '';
  # };

  # Create a custom host shortcut command
  scripts.pi-build.exec = ''
    echo "Building container and mounting current directory..."
    devenv container copy pi
    docker run -it --rm -v "$(pwd):/workspace" pi
  '';

  scripts.pi-run.exec = ''
    echo "Running container and mounting current directory..."
    docker run -it --rm -v "$(pwd):/workspace" pi
  '';
}
