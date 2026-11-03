function __basecamp_append --description 'Append a bullet to a section of today\'s Basecamp daily note'
    set -l section $argv[1]
    set -l text (string join ' ' -- $argv[2..-1])
    if test -z "$text"
        echo "usage: did|thought <text>" >&2
        return 1
    end

    set -l vault ~/Obsidian/Basecamp
    set -q BASECAMP_VAULT; and set vault $BASECAMP_VAULT
    set -l note $vault/calendar/(date +%F).md

    if not test -f $note
        printf '## Log\n- \n\n## Captured\n- \n' >$note
    end

    set -l tmp (mktemp)
    awk -v sec="## $section" -v line="- $text" '
        function blanks() { for (i = 0; i < nb; i++) print ""; nb = 0 }
        $0 == sec { insec = 1; print; next }
        insec && /^## / { if (!done) { print line; done = 1 } blanks(); insec = 0; print; next }
        insec && /^[ \t]*$/ { nb++; next }
        insec { blanks(); if (!done && $0 ~ /^-[ \t]*$/) { print line; done = 1; next } print; next }
        { print }
        END {
            if (insec && !done) { print line; done = 1 }
            blanks()
            if (!done) { print ""; print sec; print line }
        }
    ' $note >$tmp
    or begin
        rm -f $tmp
        return 1
    end

    # Write in place rather than mv, so the note keeps its inode and creation date
    cat $tmp >$note
    rm -f $tmp
    echo "→ $section: $text"
end
