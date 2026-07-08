## Version Control

I may use Jujutsu (jj) instead of or alongside Git.

- Before running any version control command, check whether a `.jj` directory exists in the repo root.
- If `.jj` is present, NEVER run `git` commands directly (no `git add`, `git commit`, `git checkout`, `git branch`, `git merge`, `git rebase`, etc.) — even though `.jj` repos often have a colocated `.git` directory, using git commands directly can create conflicting state between jj's and git's tracking.
- Instead, use the equivalent `jj` commands (e.g. `jj commit`, `jj new`, `jj git push`, `jj bookmark`, etc.).
- If you're unsure whether a jj command exists for what you need, ask before falling back to git.
