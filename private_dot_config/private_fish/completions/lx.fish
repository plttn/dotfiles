complete -c lx -s L -l level -d 'Limit the depth of recursion' -r
complete -c lx -l classify -d 'Display file kind indicators [always, auto, never]' -r -f -a "always\t''
auto\t''
never\t''"
complete -c lx -s I -l ignore -l ignore-glob -d 'Glob patterns (pipe-separated) of files to hide' -r
complete -c lx -l symlinks -d 'How to handle symlinks [show, hide, follow]' -r -f -a "show\t''
hide\t''
follow\t''"
complete -c lx -s P -l prune -l prune-glob -d 'Glob patterns of directories to show but not recurse' -r
complete -c lx -s s -l sort -d 'Sort field [name, Name, size, extension, Extension, modified, changed, accessed, created, type, none, inode]' -r -f -a "name\t''
Name\t''
size\t''
extension\t''
Extension\t''
modified\t''
changed\t''
accessed\t''
created\t''
type\t''
none\t''
inode\t''"
complete -c lx -l group-dirs -d 'Group directories before or after other files [first, last, none]' -r -f -a "first\t''
last\t''
none\t''"
complete -c lx -s p -l personality -d 'Apply a named personality (columns + flags) 🌟 [ll, lll, la, tree, ...]' -r
complete -c lx -l columns -d 'Explicit column list (comma-separated)' -r
complete -c lx -l format -d 'Named column format [long, long2, long3, ...]' -r -f -a "long\t''
long2\t''
long3\t''"
complete -c lx -s t -l time -d 'Which timestamp field to display [modified, changed, accessed, created]' -r -f -a "modified\t''
changed\t''
accessed\t''
created\t''"
complete -c lx -l time-style -d 'How to format timestamps [default, iso, long-iso, full-iso, relative, +FORMAT]' -r
complete -c lx -l vcs -d 'VCS backend [auto, git, jj, none]' -r -f -a "auto\t''
git\t''
jj\t''
none\t''"
complete -c lx -l colour -l color -d 'When to use terminal colours [always, auto, never]' -r -f -a "always\t''
auto\t''
never\t''"
complete -c lx -l colour-scale -l color-scale -d 'Colour file sizes on a scale [16, 256, none]' -r -f -a "16\t''
256\t''
none\t''"
complete -c lx -l icons -d 'Display icons next to file names [always, auto, never]' -r -f -a "always\t''
auto\t''
never\t''"
complete -c lx -l theme -d 'Use a named colour theme' -r
complete -c lx -l hyperlink -d 'File names as clickable hyperlinks [always, auto, never]' -r -f -a "always\t''
auto\t''
never\t''"
complete -c lx -l quotes -d 'Quote file names containing spaces [always, auto, never]' -r -f -a "always\t''
auto\t''
never\t''"
complete -c lx -s w -l width -d 'Override terminal width' -r
complete -c lx -l dump-class -d 'Dump class definitions as TOML' -r
complete -c lx -l dump-format -d 'Dump format definitions as TOML' -r
complete -c lx -l dump-personality -d 'Dump personality definitions as TOML' -r
complete -c lx -l dump-theme -d 'Dump theme definitions as TOML' -r
complete -c lx -l dump-style -d 'Dump style definitions as TOML' -r
complete -c lx -l completions -d 'Generate shell completions [bash, zsh, fish, elvish, powershell]' -r -f -a "bash\t''
elvish\t''
fish\t''
powershell\t''
zsh\t''"
complete -c lx -s 1 -l oneline -d 'Display one entry per line'
complete -c lx -s l -l long -d 'Long view — repeat for more detail: -ll, -lll'
complete -c lx -s G -l grid -d 'Display entries as a grid (default)'
complete -c lx -s x -l across -d 'Sort the grid across, rather than downwards'
complete -c lx -s R -l recurse -d 'Recurse into directories'
complete -c lx -s T -l tree -d 'Recurse into directories as a tree'
complete -c lx -s C -l count -d 'Print item count to stderr (-CZ includes total size)'
complete -c lx -s b -l binary -d 'File sizes with binary prefixes (KiB, MiB)'
complete -c lx -s B -l bytes -d 'File sizes in bytes, without prefixes'
complete -c lx -s g -l group -d 'Show the group column'
complete -c lx -s n -l numeric -d 'Numeric user and group IDs'
complete -c lx -s h -l header -d 'Add a header row'
complete -c lx -s i -l inode -d 'Show inode numbers'
complete -c lx -s H -l links -d 'Show hard link counts'
complete -c lx -s S -l blocks -d 'Show file system block counts'
complete -c lx -s o -l octal -d 'Show permissions in octal format [aliases: --octal-permissions]'
complete -c lx -s O -l flags -d 'Show file flags (macOS/BSD chflags)'
complete -c lx -s Z -l total-size -d 'Show directory content sizes (recursive)'
complete -c lx -s @ -l extended -d 'Show extended attributes and sizes'
complete -c lx -s a -l all -d 'Show hidden and dot files (-aa for . and ..)'
complete -c lx -s d -l list-dirs -d 'List directories as regular files'
complete -c lx -s D -l only-dirs -d 'List only directories, not files'
complete -c lx -s f -l only-files -d 'List only regular files, not directories'
complete -c lx -s r -l reverse -d 'Reverse the sort order'
complete -c lx -s F -l dirs-first -d 'Directories first [short for --group-dirs=first]'
complete -c lx -s J -l dirs-last -d 'Directories last [short for --group-dirs=last]'
complete -c lx -s m -l modified -d 'Use the modified timestamp'
complete -c lx -s c -l changed -d 'Use the changed timestamp'
complete -c lx -s u -l accessed -d 'Use the accessed timestamp'
complete -c lx -s U -l created -d 'Use the created timestamp'
complete -c lx -l permissions -d 'Show the permissions field'
complete -c lx -l filesize -d 'Show the file size field'
complete -c lx -l user -d 'Show the user field'
complete -c lx -l no-permissions -d 'Suppress the permissions field'
complete -c lx -l no-filesize -d 'Suppress the file size field'
complete -c lx -l no-user -d 'Suppress the user field'
complete -c lx -l no-time -d 'Suppress the time field'
complete -c lx -l no-icons -d 'Suppress icons (alias for --icons=never)'
complete -c lx -l no-inode
complete -c lx -l no-group
complete -c lx -l no-links
complete -c lx -l no-blocks
complete -c lx -l no-octal
complete -c lx -l no-header
complete -c lx -l no-count
complete -c lx -l no-total-size
complete -c lx -l vcs-status -d 'Show per-file VCS status column'
complete -c lx -l vcs-ignore -d 'Hide VCS-ignored files and metadata directories'
complete -c lx -l vcs-repos -d 'Show per-directory VCS repo indicator'
complete -c lx -s A -l absolute -d 'Show absolute file paths'
complete -c lx -l show-config -d 'Show the active configuration and exit'
complete -c lx -l init-config -d 'Generate a default config file'
complete -c lx -l upgrade-config -d 'Upgrade a legacy config file'
complete -c lx -s ? -l help -d 'Print help information'
complete -c lx -s v -l version -d 'Print version information'
