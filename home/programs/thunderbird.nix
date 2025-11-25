{ pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;

    profiles = {
      tre = {
        isDefault = true;

        settings = {
          # Включить отображение последних писем при старте
          "mail.start_page.override" = "about:blank";

          # Автозагрузка изображений отключена
          "mailnews.message_display.disable_remote_image" = true;

          # Настройка интерфейса и тем
          "mail.theme.color" = "#c792ea";
          "mail.folderpane.show" = true;

          # Поддержка Unified Inbox
          "mailnews.ui.threadpane.use_correspondents" = true;

          # Отключение подсказок и рекламы
          "mailnews.ui.interactive.version" = 1;
        };

        # Можно задать поисковые настройки (если используешь встроенный поиск)
        search = {
          force = true;
          default = "duckduckgo";
          order = [ "ddg" "nixos-wiki" ];
        };
      };
    };
  };
}
