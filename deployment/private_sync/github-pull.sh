git --git-dir="${1}.git/" --work-tree="${1}" fetch --all
git --git-dir="${1}.git/" --work-tree="${1}" reset --hard origin/master

