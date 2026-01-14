#!/bin/bash
# check-sync.sh
# Identifies translation status for all blog posts:
# - NEEDS TRANSLATION: English post has no translation for this language
# - NEEDS SYNC: Translation exists but is outdated
# - UP TO DATE: Translation exists and is current
#
# The key insight: we need to find when the translation CONTENT was last updated,
# not just when the file was touched (renames don't count).

set -e

BLOG_DIR="content/blog"

# Parse languages from config.toml (looks for [languages.XX] sections)
LANGUAGES=$(grep -E '^\[languages\.' config.toml 2>/dev/null | sed 's/\[languages\.\(.*\)\]/\1/' | tr '\n' ' ')
if [[ -z "$LANGUAGES" ]]; then
    echo "Error: No languages found in config.toml"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Find the commit where translation content was last meaningfully changed
# (excludes pure renames by checking if the file had actual diff content)
get_translation_baseline() {
    local en_file="$1"
    local trans_file="$2"

    # Get the last commit that touched the translation file
    local last_commit=$(git log -1 --format="%H" --follow -- "$trans_file" 2>/dev/null)

    if [[ -z "$last_commit" ]]; then
        echo ""
        return
    fi

    # Check if the translation file had actual content changes in that commit
    # (not just a rename) - count lines starting with + or - in the diff
    local diff_in_commit=$(git show "$last_commit" -- "$trans_file" 2>/dev/null | grep -c "^[-+]" || true)

    if [[ "$diff_in_commit" -gt 4 ]]; then
        # Had real content changes (more than just +++ and --- header lines)
        echo "$last_commit"
    else
        # Was likely just a rename, look further back
        git log --format="%H" --follow -- "$trans_file" | while read commit; do
            local changes=$(git show "$commit" -- "$trans_file" 2>/dev/null | grep -c "^[-+]" || true)
            if [[ "$changes" -gt 4 ]]; then
                echo "$commit"
                return
            fi
        done
    fi
}

echo "Checking translation status..."
echo "Languages: $LANGUAGES"
echo "=================================="
echo ""

needs_translation=0
needs_sync=0
up_to_date=0

# Build a pattern to skip translation files based on configured languages
is_translation_file() {
    local file="$1"
    for lang in $LANGUAGES; do
        [[ "$file" == *".${lang}.md" ]] && return 0
    done
    return 1
}

# Find all English posts (exclude translations and index files)
for en_file in "$BLOG_DIR"/*.md; do
    # Skip translation files and index files
    is_translation_file "$en_file" && continue
    [[ "$en_file" == *_index*.md ]] && continue

    basename=$(basename "$en_file" .md)

    for lang in $LANGUAGES; do
        trans_file="$BLOG_DIR/${basename}.${lang}.md"

        # Report if translation doesn't exist
        if [[ ! -f "$trans_file" ]]; then
            echo -e "${BLUE}[NEEDS TRANSLATION]${NC} $en_file → $lang"
            ((needs_translation++))
            continue
        fi

        # Find when translation content was last updated
        baseline_commit=$(get_translation_baseline "$en_file" "$trans_file")

        if [[ -z "$baseline_commit" ]]; then
            echo -e "${YELLOW}[UNKNOWN]${NC} $trans_file - could not determine baseline"
            continue
        fi

        # Check if English has changed since then
        diff_output=$(git diff "$baseline_commit"..HEAD -- "$en_file" 2>/dev/null || true)

        if [[ -n "$diff_output" ]]; then
            echo -e "${RED}[NEEDS SYNC]${NC} $trans_file"
            echo "  English changed since: $(git log -1 --format='%h %s' "$baseline_commit")"
            echo "  Changes:"
            git diff "$baseline_commit"..HEAD --stat -- "$en_file" | sed 's/^/    /'
            echo ""
            ((needs_sync++))
        else
            echo -e "${GREEN}[UP TO DATE]${NC} $trans_file"
            ((up_to_date++))
        fi
    done
done

echo ""
echo "=================================="
echo "Summary: $up_to_date up to date, $needs_sync need sync, $needs_translation need translation"

if [[ "$needs_sync" -gt 0 ]] || [[ "$needs_translation" -gt 0 ]]; then
    echo ""
    echo "Run '/sync-translations' to create missing translations and sync outdated ones."
    exit 1
fi

exit 0
