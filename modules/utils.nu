# FILE: /tui-bookmark-manager/tui-bookmark-manager/src/utils.nu
export def add_bookmark [] {
    # Input for Title
    let title = (gum input --prompt " 📄 Enter Bookmark Title: " --placeholder "Any Name")

    # Input for URL
    let url = (gum input --prompt " 🔗 Enter Bookmark URL: " --placeholder "https://example.com")

    # Input for Tags
    let tags = (gum input --prompt " 🏷️ Enter Tags (comma-separated): " --placeholder "linux, cli, tools" | split row ", ")

    # Prepare the bookmark entry
    let new_bookmark = {
      title: $title,
      url: $url,
      tags: $tags,
      added: (date now | format date "%d-%m-%Y")
    }

    # Save to JSON (Preserve existing data)
    if (not ($"bookmarks.json" | path exists)) {
      [$new_bookmark] | to json | save bookmarks.json
    } else {
      let updated = (open bookmarks.json | append $new_bookmark)
      $updated | to json | save -f bookmarks.json
    }

    print "✅ Bookmark added successfully!"
}

export def parse_bookmark [] {
    open bookmarks.json 
}

export def search [] {
   # Input for Tags
   let tags = (gum input --prompt " 🏷️ Enter Tags to search for (comma-separated): " --placeholder "linux, cli, tools" | split row ", ")

}

def edit_bookmarks [input_file] {
    open $input_file | from json
}

def format_output [bookmarks] {
    $bookmarks | each {
        echo "$($it.title) - $($it.url)"
    }
}
