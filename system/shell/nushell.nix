{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.nushell = {
    enable = true;
    extraConfig = ''
       def log [...args] {
         let msg = ($args | str join " ")
         let ts = (date now | format date "%H:%M")
         let date = (date now | format date "%Y-%m-%d")
         let line = $"($ts) ($msg)\n"
         $line | save --append $"($env.HOME)/nixos/log-($date).md"
       }
       let carapace_completer = {|spans|
       carapace $spans.0 nushell ...$spans | from json
       }
       $env.config = {
        show_banner: false,
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
       } 
       '';
    shellAliases = {
      sshx = "env TERM=xterm ssh";
    };
  };  
}
