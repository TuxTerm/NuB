open bookmarks.json | lines | where $it =~ '"url"' | parse -r '"url": "(?<url>[^"]+)", "add_date": "(?<add_date>\d+)", "last_modified": "(?<last_modified>\d+)", "title": "(?<title>.+)"' | each { 
    echo "Bookmark: $it.title"
    echo "URL: $it.url"
    echo "Added on: $it.add_date"
    echo "Last modified: $it.last_modified"
    echo ""
} 

# Initialize the TUI application
def init_app [] {
    echo "Welcome to the TUI Bookmark Manager!"
    echo "Press 'q' to quit."
}

# Main loop for user interaction
def main [] {
    init_app
    loop {
        let input = read
        if $input == 'q' {
            break
        }
        # Handle other user inputs here
    }
}

# Start the application
main