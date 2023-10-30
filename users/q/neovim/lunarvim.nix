{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, makeWrapper
, curl
, fd
, fzf
, git
, gnumake
, gnused
, gnutar
, gzip
, neovim
, nodePackages
, ripgrep
, tree-sitter
, unzip
, nvimAlias ? false
, viAlias ? false
, vimAlias ? false
, globalConfig ? ""
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lunarvim";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "LunarVim";
    repo = "LunarVim";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
  };

  # Pull in the fix for Nerd Fonts until the next release
  patches = [(
    fetchpatch {
      url = "https://github.com/LunarVim/LunarVim/commit/d187cbd03fbc8bd1b59250869e0e325518bf8798.patch";
      sha256 = "sha256-ktkQ2GiIOhbVOMjy1u5Bf8dJP4SXHdG4j9OEFa9Fm7w=";
    }
  )];

  nativeBuildInputs = [
    gnused
    makeWrapper
  ];

  buildInputs = [
    curl
    fd
    fzf
    git
    gnumake
    gnutar
    gzip
    neovim
    nodePackages.neovim
    ripgrep
    tree-sitter
    unzip
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/base
    cp init.lua utils/installer/config.example.lua $out/base
    cp -r lua snapshots $out/base

    mkdir $out/bin
    cp utils/bin/lvim.template $out/bin/lvim
    chmod +x $out/bin/lvim

    # LunarVim automatically copies config.example.lua, but we need to make it writable.
    sed -i "2 i\\
            if [ ! -f \$HOME/.config/lvim/config.lua ]; then \\
              cp $out/base/config.example.lua \$HOME/.config/lvim/config.lua \\
              chmod +w \$HOME/.config/lvim/config.lua \\
            fi
    " $out/bin/lvim

    substituteInPlace $out/bin/lvim \
      --replace NVIM_APPNAME_VAR lvim \
      --replace RUNTIME_DIR_VAR \$HOME/.local/share/lvim \
      --replace CONFIG_DIR_VAR \$HOME/.config/lvim \
      --replace CACHE_DIR_VAR \$HOME/.cache/lvim \
      --replace BASE_DIR_VAR $out/base \
      --replace nvim ${neovim}/bin/nvim

    echo ${ lib.strings.escapeShellArg globalConfig } > $out/base/global.lua
    sed -i "/Log:set_level/idofile(\"$out/base/global.lua\")" $out/base/lua/lvim/config/init.lua

    for iconDir in utils/desktop/*/; do
      install -Dm444 $iconDir/lvim.svg -t $out/share/icons/hicolor/$(basename $iconDir)/apps
    done

    install -Dm444 utils/desktop/lvim.desktop -t $out/share/applications

    wrapProgram $out/bin/lvim --prefix PATH : ${ lib.makeBinPath finalAttrs.buildInputs }
  '' + lib.optionalString nvimAlias ''
    ln -s $out/bin/lvim $out/bin/nvim
  '' + lib.optionalString viAlias ''
    ln -s $out/bin/lvim $out/bin/vi
  '' + lib.optionalString vimAlias ''
    ln -s $out/bin/lvim $out/bin/vim
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "IDE layer for Neovim";
    homepage = "https://www.lunarvim.org/";
    changelog = "https://github.com/LunarVim/LunarVim/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prominentretail ];
    platforms = platforms.unix;
    mainProgram = "lvim";
  };
})

