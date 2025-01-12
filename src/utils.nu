# FILE: /tui-bookmark-manager/tui-bookmark-manager/src/utils.nu
def parse_bookmarks [input] {
    open $input | lines | where $it =~ '<A HREF="' | parse -r '<A HREF="(?<url>[^"]+)" ADD_DATE="(?<add_date>\d+)" LAST_MODIFIED="(?<last_modified>\d+)".*>(?<title>.+)</A>'
}

def save_bookmarks [bookmarks output_file] {
    $bookmarks | to json | save $output_file
}

def load_bookmarks [input_file] {
    open $input_file | from json
}

def format_output [bookmarks] {
    $bookmarks | each { 
        echo "$($it.title) - $($it.url)"
    }
}