# FILE: /tui-bookmark-manager/tui-bookmark-manager/src/utils.nu
def add_bookmark [] {
    # Input for Title
    let title = (gum input --prompt " 📄 Enter Bookmark Title: " --placeholder "Any Name")

    # Input for URL
    let url = (gum input --prompt " 🔗 Enter Bookmark URL: " --placeholder "https://example.com")

    # Input for Tags
    let tags = (gum input --prompt " 🏷️ Enter Tags (comma-separated): " --placeholder "linux, cli, tools" | split row ",")

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
