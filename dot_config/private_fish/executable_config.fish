# Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
   set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Replace ls with eza
function ls; eza -1 -h -l --icons -a --no-user --group-directories-first -F $argv; end # preferred listing
function la; eza -1 -a --color=always --group-directories-first --icons $argv; end  # all files and dirs
function ll; eza -l --color=always --group-directories-first --icons $argv; end  # long format
function lt; eza -aT --color=always --group-directories-first --icons $argv; end # tree listing
function l.; eza -a | grep -E '^\.'; end                                     # show only dotfiles
# function ip; ip -color; end

function v; sudo nvim $argv; end

# Replace some more things with better alternatives
if not test -x /usr/bin/yay
    if test -x /usr/bin/paru
        function yay; paru $argv; end
    end
end

# Common use
function grubup; sudo update-grub; end
function fixpacman; sudo rm /var/lib/pacman/db.lck; end
function tarnow; tar -acf $argv; end
function untar; tar -xvf $argv; end
function psmem; ps auxf | sort -nr -k 4; end
function psmem10; ps auxf | sort -nr -k 4 | head -10; end

# function upd='/usr/bin/garuda-update'
function .. ; cd .. ; end 
function ... ; cd ../.. ; end 
function .... ; cd ../../.. ; end 
function ..... ; cd ../../../.. ; end 
function ...... ; cd ../../../../.. ; end 

# Hardware Info
function hw ; hwinfo --short ; end                          
# Sort installed packages according to size in MB
function big ; expac -H M '%m\t%n' | sort -h | nl ; end     
# List amount of -git packages
function gitpkg ; pacman -Q | grep -i "\-git" | wc -l ; end 

# Get fastest mirrors
function mirror ; sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist ; end 
function mirrord ; sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist ; end 
function mirrors ; sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist ; end 
function mirrora ; sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist ; end 

# Help people new to Arch
function tb ; nc termbin.com 9999 $argv ; end 

function install ; sudo pacman -S $argv; end 
function update ; sudo pacman -S $argv; end 
function remove ; sudo pacman -Rdd $argv; end 
function search ; pacman -Ss $argv; end 
function sync ; sudo pacman -Syyy; end 
function upgrade ; sudo pacman -Syyyu $argv; end 

function please
    switch $argv[1]
        case 'install'
            install $argv[2..-1]
        case 'update'
            update $argv[2..-1]
        case 'remove'
            remove $argv[2..-1]
        case 'search'
            search $argv[2..-1]
        case 'sync'
            sync
        case 'upgrade'
            upgrade
        case '*'
            echo "Unknown command '$argv[1]'. Please use 'install', 'remove', 'search', 'sync', 'update' or 'upgrade'."
    end
end

# Cleanup orphaned packages
function cleanup ; sudo pacman -Rns (pacman -Qtdq) ; end 

# Get the error messages from journalctl
function jctl ; journalctl -p 3 -xb $argv ; end 

# Recent installed packages
function insdpkgs ; expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl $argv ; end 

# Aliases
set -U fish_user_paths $fish_user_paths ~/.local/bin ~/.cargo/bin 

# Function
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

# Key binding
bind \ca 'nvims\n'

fish_add_path /home/daUnknownCoder/.spicetify
set -g tide_git_icon  
set -U __done_min_cmd_duration 5000  # default: 5000 ms

starship init fish | source
zoxide init fish | source
# function fish_title
#   if git rev-parse --is-inside-work-tree >/dev/null 2>&1
#     git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/'
#   else
#     set -x WARP_DISABLE_AUTO_TITLE "false"
#   end
# end

if status is-interactive
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end

function google; web-search google; end
function youtube; web-search youtube; end
function github; web-search github; end
function aur; web-search aur; end

