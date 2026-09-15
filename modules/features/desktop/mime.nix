{ ... }: {

  flake.modules.homeManager.mime =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      writerMimeTypes = [
        "application/msword"
        "application/rtf"
        "application/vnd.ms-word"
        "application/vnd.ms-word.document.macroEnabled.12"
        "application/vnd.ms-word.template.macroEnabled.12"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.oasis.opendocument.text-flat-xml"
        "application/vnd.oasis.opendocument.text-master"
        "application/vnd.oasis.opendocument.text-master-template"
        "application/vnd.oasis.opendocument.text-template"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
        "text/rtf"
      ];
      calcMimeTypes = [
        "application/csv"
        "application/excel"
        "application/msexcel"
        "application/tab-separated-values"
        "application/vnd.ms-excel"
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "application/vnd.ms-excel.template.macroEnabled.12"
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.oasis.opendocument.spreadsheet-flat-xml"
        "application/vnd.oasis.opendocument.spreadsheet-template"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
        "text/comma-separated-values"
        "text/csv"
        "text/tab-separated-values"
        "text/x-comma-separated-values"
        "text/x-csv"
      ];
      impressMimeTypes = [
        "application/mspowerpoint"
        "application/vnd.ms-powerpoint"
        "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
        "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
        "application/vnd.ms-powerpoint.template.macroEnabled.12"
        "application/vnd.oasis.opendocument.presentation"
        "application/vnd.oasis.opendocument.presentation-flat-xml"
        "application/vnd.oasis.opendocument.presentation-template"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.openxmlformats-officedocument.presentationml.slide"
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
        "application/vnd.openxmlformats-officedocument.presentationml.template"
      ];
    in
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "librewolf.desktop" ];
          "x-scheme-handler/http" = [ "librewolf.desktop" ];
          "x-scheme-handler/https" = [ "librewolf.desktop" ];
          "x-scheme-handler/codex" = [ "chatgpt.desktop" ];
          "inode/directory" = [ "thunar.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
          "application/x-zerosize" = [ "org.xfce.mousepad.desktop" ];
          "text/plain" = [ "org.xfce.mousepad.desktop" ];
          "text/markdown" = [ "org.xfce.mousepad.desktop" ];
          "text/x-typst" = [ "org.xfce.mousepad.desktop" ];
          "text/x-log" = [ "org.xfce.mousepad.desktop" ];
          "application/json" = [ "org.xfce.mousepad.desktop" ];
          "application/xml" = [ "org.xfce.mousepad.desktop" ];
          "application/x-typst" = [ "org.xfce.mousepad.desktop" ];
        }
        // lib.genAttrs writerMimeTypes (_: [ "writer.desktop" ])
        // lib.genAttrs calcMimeTypes (_: [ "calc.desktop" ])
        // lib.genAttrs impressMimeTypes (_: [ "impress.desktop" ]);
      };

    };
}
