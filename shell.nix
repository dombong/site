# Pin nixpkgs to a specific commit for reproducibility
let
  # Use a stable nixpkgs release (This uses 23.11 as of May 2024)
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-25.05.tar.gz";
    # Optional: Add a SHA256 hash for better security
    # sha256 = "0000000000000000000000000000000000000000000000000000";
  };
  pkgs = import nixpkgs { };

in pkgs.mkShell {
  buildInputs = with pkgs; [
    # Ruby and Bundler
    ruby
    bundler

    # Additional useful tools
    git
    gnumake

    # Libraries that might be needed for some Ruby gems
    zlib
    libiconv
    libxml2
    libxslt
    pkg-config
    openssl
  ];

  shellHook = ''
    export GEM_HOME=$PWD/.gems
    export PATH=$GEM_HOME/bin:$PATH
    export BUNDLE_PATH=$GEM_HOME

    # Ensure bundler installs gems in the project directory
    bundle config set --local path '.gems'

    echo "Ruby $(ruby --version) and Bundler $(bundle --version) are available."
    echo "To set up your Jekyll site, run: bundle install"
    echo "To serve your site locally, run: bundle exec jekyll serve"
  '';
}
