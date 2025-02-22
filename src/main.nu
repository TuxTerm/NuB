# FILE: src/main.nu
use /home/ireon/Documents/Project/NuB/modules/utils.nu [add_bookmark, parse_bookmark, search, remove_bookmark]

let term_width = 132 

figlet -f smslant "Welcome to NuB" | gum style --border rounded --width $term_width --padding="1 1" --align center --foreground 121 --border-foreground 121


# Create a mapping for actions.
let options = [
    { display: (gum style --border rounded --width 20 --padding "1 2" "Add Bookmark") value: "Add" },
    { display: (gum style --border rounded --width 20 --padding "1 2" "Search Bookmark") value: "Search" },
    { display: (gum style --border rounded --width 20 --padding "1 2" "Remove Bookmark") value: "Remove" },
    { display: (gum style --border rounded --width 20 --padding "1 2" "Edit Bookmark") value: "Edit" },
    { display: (gum style --border rounded --width 20 --padding "1 2" "View Bookmarks") value: "View" }
]

# Extract the styled display options.
let styled_options = $options | get display

# Let the user choose.
let selected_styled = (gum choose --cursor "" --header="" --cursor.foreground="121" --item.foreground="#B098D0" ...$styled_options)

# Find the raw value that corresponds to the selected styled option.
let action = ($options | where display == $selected_styled | get value)

if $action == ["Add"] {
    add_bookmark
} else if $action == ["Search"] {
    search
} else if $action == ["Remove"] {
    remove_bookmark
} else if $action == ["Edit"] {
    edit_bookmark
} else if $action == ["View"] {
    let bookmarks = (parse_bookmark)
    format_output $bookmarks
} else {
    print "🚫 Invalid action selected."
}