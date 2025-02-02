{ lib, pkgs, config, inputs, namespace, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.apps.i3status;
in {
  options.${namespace}.apps.i3status = { enable = mkEnableOption "I3STATUS"; };

  config = mkIf cfg.enable {
    programs.i3status-rust = {
      enable = true;
      bars.bottom = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            label = "Root ";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
            command = ./scripts/disk;
          }
          {
            block = "disk_space";
            path = "/home/ai3wm/";
            label = "Home ";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
            command = ./scripts/disk;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "memory";
            label = "";
            format_mem = " $icon $mem_used_percents ";
            format_swap = " $icon $swap_used_percents ";
            command = ./scripts/memory;
            interval = 2;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "cpu";
            label = " ";
            command = ./scripts/cpu_usage;
            interval = 2;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "bandwidth";
            command = ./scripts/bandwidth2;
            interval = 1;
            format = " $icon $1m ";
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "battery";
            command = ./scripts/battery2;
            interval = 30;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "pavucontrol";
            command = "pavucontrol";
          }
          {
            block = "volume-pulseaudio";
            command = ./scripts/volume;
            instance = "Master";
            interval = 1;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "keybindings";
            full_text = "";
            command = ./scripts/keyhint;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "ppd_menu";
            full_text = "";
            command = ./scripts/power-profiles;
            color = "#407437";
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }
          {
            block = "ppd-status";
            command = ./scripts/ppd-status;
            interval = 5;
          }
          {
            block = "simple-2";
            full_text = "|";
            color = "#807dfe";
          }

          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          }
          {
            block = "shutdown_menu";
            full_text = "";
            command = ./scripts/powermenu;
          }
          {
            block = "simple-2";
            full_text = "]";
            color = "#807dfe";
          }
        ];
        settings = {
          theme = {
            theme = "solarized-dark";
            overrides = {
              idle_bg = "#123456";
              idle_fg = "#abcdef";
            };
          };
        };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
