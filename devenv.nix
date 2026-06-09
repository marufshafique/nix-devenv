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
  ];

  containers."pi" = {
    name = "pi";
    copyToRoot = [
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
  scripts.run-pi-container.exec = ''
    echo "Building container and mounting current directory..."
    IMAGE_TAG=$(devenv container shell pi-workspace)
    docker run -it --rm -v "$(pwd):/workspace" $IMAGE_TAG
  '';

  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    echo $SHELL
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';
}
