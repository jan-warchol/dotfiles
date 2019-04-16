: "${INFRA_REPO_PATH:=$HOME/src/infrastructure}"  # default value

refresh_fzf_ssh_cache() {
  echo -n "Querying Chef server... "
  cd $INFRA_REPO_PATH
  (
    chef exec rake chef:list[prod-ecorp] | tail -n +3 | head -n -3 ;
    chef exec rake chef:list[prod-main] | tail -n +3 | head -n -3 ;
    chef exec rake chef:list[staging] | tail -n +3 | head -n -3 ;
    chef exec rake chef:list[_default] | tail -n +3 | head -n -3 ;
    chef exec rake chef:list[testing] | tail -n +3 | head -n -3 ;
    chef exec rake chef:list[qa] | tail -n +3 | head -n -3 ;
  ) | sed 's/^\*//g' | cut -d'|' -f1,2 |
  awk '{$1=$1;print}' |
  awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2- | sed 's/ | /\t/' \
  > $INFRA_REPO_PATH/.chef/server-fqdn-cache
  echo done.
}

fzf_codility_ssh() {
  cat $INFRA_REPO_PATH/.chef/server-fqdn-cache | cut -f2 |
  fzf --height 50% --prompt 'ssh ' |
  sed 's/^/ssh /'
}

fzf_codility_chef_node_name() {
  cat $INFRA_REPO_PATH/.chef/server-fqdn-cache | cut -f1 |
  fzf --height 50% --prompt 'chef node: ' --multi
}

refresh_fzf_rake_cache() {
  echo -n "Calculating rake tasks... "
  cd $INFRA_REPO_PATH
  chef exec rake -AT | cut -d'#' -f1 | sed 's/\s\+$//' \
  > $INFRA_REPO_PATH/.chef/rake-task-cache
  echo done.
}

fzf_codility_rake() {
  cat $INFRA_REPO_PATH/.chef/rake-task-cache |
  fzf --height 50% --prompt 'chef exec ' |
  sed 's/^/chef exec /'
}

fzf_cookbooks_and_recipes() {
  (
    ls $INFRA_REPO_PATH/cookbooks;
    ls $INFRA_REPO_PATH/vendor/cookbooks;
    find . -name recipes | xargs -n 1 ls | sort -u
  ) | fzf --height 50% --prompt 'cookbooks and recipes: '
}

