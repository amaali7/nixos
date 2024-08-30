{ channels,... }:

final: prev: {
    lunarvim = prev.lunarvim // {
      buildPhase = ''
        runHook preBuild

        mkdir -p share/lvim
        cp init.lua utils/installer/config.example.lua share/lvim
        cp -r lua snapshots share/lvim

        mkdir bin
        cp utils/bin/lvim.template bin/lvim
        chmod +x bin/lvim

        # LunarVim automatically copies config.example.lua, but we need to make it writable.
        sed -i "2 i\\
                if [ ! -f \$HOME/.config/lvim/config.lua ]; then \\
                  cp $out/share/lvim/config.example.lua \$HOME/.config/lvim/config.lua \\
                  chmod +w \$HOME/.config/lvim/config.lua \\
                fi
        " bin/lvim

        substituteInPlace bin/lvim \
          --replace NVIM_APPNAME_VAR lvim \
          --replace RUNTIME_DIR_VAR \$HOME/.local/share/lvim \
          --replace CONFIG_DIR_VAR \$HOME/.config/lvim \
          --replace CACHE_DIR_VAR \$HOME/.cache/lvim \
          --replace BASE_DIR_VAR $out/share/lvim \
            --replace nvim ${prev.neovide}/bin/neovide -- 

        # Allow language servers to be overridden by appending instead of prepending
        # the mason.nvim path.
        echo "lvim.builtin.mason.PATH = \"append\"" > share/lvim/global.lua
        echo ${ prev.lib.strings.escapeShellArg finalAttrs.globalConfig } >> share/lvim/global.lua
        sed -i "s/add_to_path()/add_to_path(true)/" share/lvim/lua/lvim/core/mason.lua
        sed -i "/Log:set_level/idofile(\"$out/share/lvim/global.lua\")" share/lvim/lua/lvim/config/init.lua

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r bin share $out

        for iconDir in utils/desktop/*/; do
          install -Dm444 $iconDir/lvim.svg -t $out/share/icons/hicolor/$(basename $iconDir)/apps
        done

        install -Dm444 utils/desktop/lvim.desktop -t $out/share/applications

        wrapProgram $out/bin/lvim --prefix PATH : ${ prev.lib.makeBinPath finalAttrs.runtimeDeps } \
          --prefix LD_LIBRARY_PATH : ${prev.stdenv.cc.cc.lib} \
          --prefix CC : ${prev.stdenv.cc.targetPrefix}cc
      '' + prev.lib.optionalString finalAttrs.nvimAlias ''
        ln -s $out/bin/lvim $out/bin/nvim
      '' + prev.lib.optionalString finalAttrs.viAlias ''
        ln -s $out/bin/lvim $out/bin/vi
      '' + prev.lib.optionalString finalAttrs.vimAlias ''
        ln -s $out/bin/lvim $out/bin/vim
      '' + ''
        runHook postInstall
      '';
    };
}
