#!/bin/bash

# Initialize swww
swww init

# Directory containing the wallpapers
WALLPAPER_DIR="$HOME/wallpaper"

# Directory to save the generated color scheme files
TEMPLATE_DIR="$HOME/.config/wal/templates"

# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Use swww to change the wallpaper
swww img $WALLPAPER \
    --transition-bezier .43,1.19,1,.4 \
    --transition-fps=60 \
    --transition-type=wave \
    --transition-duration=2.0 \
    --transition-pos "$( hyprctl cursorpos )"

# Use pywal to generate a color scheme from the wallpaper
wal -i "$WALLPAPER"

# Extract colors from the generated colorscheme
source "$HOME/.cache/wal/colors.sh"

# Function to generate a color configuration file
generate_config() {
    local filename=$1
    shift
    local content=$@

    # Replace color variables with actual color values
    for color in {0..15}; do
        local var="color${color}"
        content=${content//\{$var.strip\}/${!var}}
    done
    content=${content//\{background.strip\}/$background}
    content=${content//\{foreground.strip\}/$foreground}
    content=${content//\{cursor.strip\}/$cursor}

    # Write the content to the file
    echo -e "$content" > "$TEMPLATE_DIR/$filename"
}

# Content of the configuration files
HYPR_CONF='
$background = rgb({background.strip})
$foreground = rgb({foreground.strip})
$color0 = rgb({color0.strip})
$color1 = rgb({color1.strip})
$color2 = rgb({color2.strip})
$color3 = rgb({color3.strip})
$color4 = rgb({color4.strip})
$color5 = rgb({color5.strip})
$color6 = rgb({color6.strip})
$color7 = rgb({color7.strip})
$color8 = rgb({color8.strip})
$color9 = rgb({color9.strip})
$color10 = rgb({color10.strip})
$color11 = rgb({color11.strip})
$color12 = rgb({color12.strip})
$color13 = rgb({color13.strip})
$color14 = rgb({color14.strip})
$color15 = rgb({color15.strip})
'

ROFI_CONF='
* {{
    background: rgba(0,0,1,0.5);
    foreground: #FFFFFF;
    color0:     {color0};
    color1:     {color1};
    color2:     {color2};
    color3:     {color3};
    color4:     {color4};
    color5:     {color5};
    color6:     {color6};
    color7:     {color7};
    color8:     {color8};
    color9:     {color9};
    color10:    {color10};
    color11:    {color11};
    color12:    {color12};
    color13:    {color13};
    color14:    {color14};
    color15:    {color15};
}}
'

WAYBAR_CONF='
@define-color foreground {foreground};
@define-color background {background};
@define-color cursor {cursor};

@define-color color0 {color0};
@define-color color1 {color1};
@define-color color2 {color2};
@define-color color3 {color3};
@define-color color4 {color4};
@define-color color5 {color5};
@define-color color6 {color6};
@define-color color7 {color7};
@define-color color8 {color8};
@define-color color9 {color9};
@define-color color10 {color10};
@define-color color11 {color11};
@define-color color12 {color12};
@define-color color13 {color13};
@define-color color14 {color14};
@define-color color15 {color15};
'

WLOGOUT_CONF='
@define-color foreground {foreground};
@define-color background {background};
@define-color cursor {cursor};

@define-color color0 {color0};
@define-color color1 {color1};
@define-color color2 {color2};
@define-color color3 {color3};
@define-color color4 {color4};
@define-color color5 {color5};
@define-color color6 {color6};
@define-color color7 {color7};
@define-color color8 {color8};
@define-color color9 {color9};
@define-color color10 {color10};
@define-color color11 {color11};
@define-color color12 {color12};
@define-color color13 {color13};
@define-color color14 {color14};
@define-color color15 {color15};
'

# Generate the configuration files
generate_config "colors-hyprland.conf" "$HYPR_CONF"
generate_config "colors-rofi-pywal.rasi" "$ROFI_CONF"
generate_config "colors-waybar.css" "$WAYBAR_CONF"
generate_config "colors-wlogout.css" "$WLOGOUT_CONF"

