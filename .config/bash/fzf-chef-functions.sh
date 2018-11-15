INFRA_REPO_PATH="$HOME/src/infrastructure"

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
  ) | cut -d'|' -f2 |
  awk '{$1=$1;print}' |
  awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2- \
  > $INFRA_REPO_PATH/.chef/server-fqdn-cache
  echo done.
}

fzf_codility_ssh() {
  cat $INFRA_REPO_PATH/.chef/server-fqdn-cache |
  fzf --height 50% --prompt 'ssh ' |
  sed 's/^/ssh /'
}

