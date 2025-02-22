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
    open bookmarks.json | from json
}

export def search [] {
    # Prompt for a query string
    let query = (gum input --prompt " 🔍 Enter search query (title, URL, or tag): " --placeholder "e.g., Google, youtube")
    let bookmarks = (parse_bookmark)
    # Filter bookmarks where title, URL, or any tag contains the query (case-insensitive)
    let results = (
      $bookmarks |
      where {
          ($it.title | str downcase | str contains ($query | str downcase))
          or ($it.url | str downcase | str contains ($query | str downcase))
          or (if $it.tags {
                  $it.tags | any? { $it | str downcase | str contains ($query | str downcase) }
              } else { false })
      }
    )
    if ($results | length) == 0 {
        print "No bookmarks found matching the query."
    } else {
        print "🔎 Search Results:"
        format_output $results
    }
}

export def remove_bookmark [] {
    let bookmarks = (parse_bookmark)
    # Prepare a list of choices using title and URL
    let choices = ($bookmarks | each { echo "$($it.title) - $($it.url)" })
    let selection = (echo $choices | gum choose --prompt "Select a bookmark to remove")
    if ($selection | str length) == 0 {
        print "No bookmark selected."
        return
    }
    # Filter out the selected bookmark
    let updated = ($bookmarks | where { "$($it.title) - $($it.url)" != $selection })
    $updated | to json | save -f bookmarks.json
    print "✅ Bookmark removed successfully!"
}

# export def edit_bookmark [] {
#     let bookmarks = (parse_bookmark)
#     let choices = ($bookmarks | each { echo "$($it.title) - $($it.url)" })
#     let selection = (echo $choices | gum choose --prompt "Select a bookmark to edit")
#     if ($selection | str length) == 0 {
#         print "No bookmark selected."
#         return
#     }
#     # Locate the selected bookmark
#     let selected = ($bookmarks | where { "$($it.title) - $($it.url)" == $selection } | first)
#     # Ask for new values (empty input means to keep the current value)
#     let new_title = (gum input --prompt (format "Enter new title (leave blank to keep '{}'):" $selected.title) --placeholder $selected.title)
#     let new_url = (gum input --prompt (format "Enter new URL (leave blank to keep '{}'):" $selected.url) --placeholder $selected.url)
#     let new_tags_str = (gum input --prompt (format "Enter new tags (comma-separated, leave blank to keep current)") --placeholder ($selected.tags | str join ", "))
#     let updated_bookmark = {
#         title: (if ($new_title | str length) == 0 { $selected.title } else { $new_title }),
#         url: (if ($new_url | str length) == 0 { $selected.url } else { $new_url }),
#         tags: (if ($new_tags_str | str length) == 0 { $selected.tags } else { $new_tags_str | split row ", " }),
#         added: $selected.added
#     }
#     # Replace the old bookmark with the updated one
#     let updated_bookmarks = (
#       $bookmarks |
#       each { if ("$($it.title) - $($it.url)" == $selection) { $updated_bookmark } else { $it } }
#     )
#     $updated_bookmarks | to json | save -f bookmarks.json
#     print "✅ Bookmark updated successfully!"
# }

def format_output [bookmarks] {
    $bookmarks | each {
        echo "$($it.title) - $($it.url)"
    }
}
