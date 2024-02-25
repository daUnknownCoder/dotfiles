function ChooseNvim
    set items default NeutronVim LazyVim NvChad AstroNvim Kickstart
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
    if test -z $config
        echo "Nothing selected"
        return 0
    else if test $config = "default"
        set config ""
    end
    set -gx NVIM_APPNAME $config
    nvim $argv
end
