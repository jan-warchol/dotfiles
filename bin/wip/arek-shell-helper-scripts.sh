INFRA_REPO_DIR="/home/arkadiusz/codility/infrastructure"

run_fabric() {
  curr_dir=$(pwd)
  fab_dir="/home/arkadiusz/codility/codility/deployment"
  cd $fab_dir
  ./fab $@
  cd $curr_dir
}

find_name_or_ip() {
  curr_dir=$(pwd)
  cd $INFRA_REPO_DIR
  chef exec rake chef:find_name_or_ip[$1]
  cd $curr_dir
}

cb_upload() {
  chef exec rake chef:upload:cookbook[$1]
}

find_instance_by_id() {
  knife search "instance_id:$1" -i
}

check_if_id_name_or_ip() {
  if [[ $1 ]];then
    if [[ $1 =~ i-.* ]]; then
      echo "Looking for instance id $1"
      find_instance_by_id $1
    else
      echo "Looking for name/ip $1"
      find_name_or_ip $1
    fi
  else
    echo "Missing argument!"
    echo "Provide instance name, AWS id or IP"
  fi
}

alias c='chef exec'
alias g='git'
alias C='cd ~/codility/codility'
alias I="cd $INFRA_REPO_DIR"
alias staging='chef exec rake chef:list[staging]'
alias event='chef exec rake chef:list[event]'
alias prod-main='chef exec rake chef:list[prod-main]'
alias prod-ecorp='chef exec rake chef:list[prod-ecorp]'
alias testing='chef exec rake chef:list[testing]'
alias _default='chef exec rake chef:list[_default]'
alias terraform="~/codility/infrastructure/scripts/terraform.sh"
alias f='run_fabric'
alias i='check_if_id_name_or_ip'
alias salt='ssh master.load-test-eu.codility.net'
alias get_minion_reports='ssh master.load-test-eu.codility.net "sudo /root/get_screenshots.sh"; echo "Downloading to local workstation";scp arek.chedoszko@master.load-test-eu.codility.net:/home/arek.chedoszko/*_report_*.tgz /home/arkadiusz/minion_serenity_reports/'
alias grokdebug='docker run --add-host="1.1.1.10.in-addr.arpa:10.1.1.1" --network="no-internet" --rm -d --name grokd fdrouet/grokdebug:runme' 
