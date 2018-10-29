INFRA_REPO_PATH="$HOME/src/infrastructure"

# TODO: add aliases like "database.staging.codility.net"

refresh_cache() {
  echo -n "Querying Chef server... "
  cd $INFRA_REPO_PATH
  (
    chef exec rake chef:list[prod-ecorp] | tail +3 | head -n -3 ;
    chef exec rake chef:list[prod-main] | tail +3 | head -n -3 ;
    chef exec rake chef:list[staging] | tail +3 | head -n -3 ;
    chef exec rake chef:list[_default] | tail +3 | head -n -3 ;
  ) | cut -d'|' -f2 > $INFRA_REPO_PATH/.chef/server-fqdn-cache
  echo done.
}

fzf_codility_ssh() {
  cat $INFRA_REPO_PATH/.chef/server-fqdn-cache |
  fzf --height 50% --prompt 'ssh ' |
  sed 's/^/ssh/'
}

