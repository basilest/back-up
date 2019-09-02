#-------------------------------- FOREGROUND TPUT COLOURS
    F_FG_RED="$(tput setaf 1)"
    F_FG_GREEN="$(tput setaf 2)"
    F_FG_YELLOW="$(tput setaf 3)"
    F_FG_BLUE="$(tput setaf 4)"
    F_FG_MAGENTA="$(tput setaf 5)"
    F_FG_CYAN="$(tput setaf 6)"
    F_FG_WHITE="$(tput setaf 7)"
    F_RESET="$(tput sgr0)"
    F_BOLD="$(tput bold)"
#________________________ <new settings for CHS on AWS>
# this sources chtf to manage different version of Terraform (ex. chtf  0.8.8)

# <OLD TFENV SETTING>: now tfenv comes packaged with brew:
#                if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
#                    source "/usr/local/share/chtf/chtf.sh"
#                fi
#</OLD SETTINGS>
#<NEW SETTINGS> tfenv
#tfenv use 0.8.8      # uncomment when you need
#</NEW SETTINGS> tfenv

# Source chtf   --- terraform versions changer
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi


awsenv () {
   local env=$1
   tfenv use 0.8.8      # uncomment when you need
   export AWS_PROFILE=development
   ssh-add ~/.ssh/chs-${env}.pem
   export AWS_ENVIRONMENT_TAG=${env}
}

awsenv1 () {
   local env=$1
   export AWS_PROFILE=live
   ssh-add ~/.ssh/ch-aws-live.pem
   export AWS_ENVIRONMENT_TAG=${env}
}

#________________________ </new settings for CHS on AWS>
#______________________________________
function ch_g {
   local other_args=2   #if args must be forwarded, start from pos 2
   local pretty="       %h (%ad)  %<(30) %an [%s]"
   local cmd=$1
   if [[ "$1" == "-noc" || "$2" == "-noc" ]]  # no colors
   then
      local no_color=1
      other_args=3
      cmd=$2
   fi
   if [[ -z $no_color ]]
   then
       local col_start=${F_FG_GREEN}
       local col_end=${F_RESET}
       pretty="       %Cgreen%h%Creset %C(cyan)(%ad)%Creset  %<(30) %C(Yellow)%an%Creset [%C(magenta)%s%Creset]"
   fi

   other_args="${@:$other_args}"

   for i in $( find -L . -name '.git' ); do
       local d=$( dirname "${CH_CONTEXT_HOME}/${i#./}" )
       cd "${d}"
       local branch_name=$( git rev-parse --abbrev-ref HEAD )
       printf '_%.0s' {1..40}

       echo " $d (${col_start}${branch_name}${col_end})"
       if [[ $cmd == "s" ]]   # 'status'
       then
           git status --porcelain
       elif [[ $cmd == "d" ]] # 'diff'
       then
           git diff --color=always  ${other_args}
       elif [[ $cmd == "l" ]] # 'log'
       then
           git log --stat=200  ${other_args}
       elif [[ $cmd == "c" ]] # 'last commits'
       then
           git log -3 --date=short --pretty="${pretty}"  ${other_args}
       elif [[ $cmd == "b" ]] # 'branch'
       then
           git branch ${other_args}
       elif [[ $cmd == "pull" ]] # 'branch'
       then
           git pull ${other_args}
       elif [[ $cmd == "x" ]] # 'exec' any other command
       then
           git ${other_args}
           #git log --author basile --oneline
       fi
   done
   cd "${CH_CONTEXT_HOME}"
}
#______________________________________
function ch_cut {
    local release=$1
    echo "git co develop && g pull"
    echo "git branch -a | rg -i release"
    echo "git co -b release/1.${release}.0"
    echo "git tag -a -m 'cut for release/1.${release}.0' v1.${release}.0-rc1"
    echo "git push --set-upstream origin release/1.${release}.0"
    echo "git push --follow-tags origin release/1.${release}.0"
    echo "https://github.com/companieshouse/chl-perl/releases/tag/v1.${release}.0-rc1"
}
#______________________________________
function ch_k {
    cd $CH_CONTEXT_VAGRANT_DIR
    vagrant ssh chs-kafka -c "cd /vagrant/scripts; ./build_kafka.sh" -- -n
}
#______________________________________
function ch_u {

    local ubic_cmd=""
    if [[ $1 == "s" ]]   # 'start'
    then
          ubic_cmd="ubic start"
    elif [[ $1 == "r" ]] # 'restart'
    then
          ubic_cmd="ubic restart"
    elif [[ $1 == "st" ]] # 'status'
    then
          ubic_cmd="ubic status"
    fi
    if [[ ! -z ${ubic_cmd} ]]
    then
        local cmd=""
        local sep=""

        for i in ${CH_CONTEXT_SERVICES[@]}; do
            cmd="${cmd} ${sep} ${ubic_cmd} ${i}"
            sep="&&"
        done
        cd $CH_CONTEXT_VAGRANT_DIR
        echo $CH_CONTEXT_DEV -c "${cmd}"
        vagrant ssh $CH_CONTEXT_DEV -c "${cmd}"
    fi
}
#______________________________________
function ch_ssh_old {
    if [[ "$CH_CONTEXT_HOME" = "$CHL_HOME" ]]
    then
        cd $CH_CONTEXT_VAGRANT_DIR
        vagrant ssh $CH_CONTEXT_DEV
    else
        local host=""
        local pswd=""
        local options1=("envb.mongo" "test_xx"  "Quit")
        local envs_chs=("heather" "dugal" "duncan" "hamish" "kronos" "ernie" "joker" "scooter&angus" "bobo" "waldorf" "cookiemonster" "kermit" "bigbird" "statler" "rizzo" "elmo" "grover")
        select opt1 in "${options1[@]}"
        do
            case $opt1 in
                "envb.mongo")
                    host="web@envb.mongo.ch.gov.uk"
                    break ;;
                "test_xx")
                    local num=1
                    for i in ${envs_chs[@]}; do
                        printf '   %3s : %s\n' $num  ${i}
                        let "num += 1"
                    done
                    echo "test:"
                    read test_num
                    host="test$test_num@wswebdev2.orctel.internal"
                    break ;;
                "Quit") break ;;
                *) echo invalid option;;
            esac
        done
        if [[ ! -z "${host}" ]]
        then
            exp.ssh $host $pswd
        fi
    fi
}
#______________________________________
function ch_ssh {
    local env=$CH_CONTEXT_DEV
    if [[ "$CH_CONTEXT_HOME" = "$CHS_HOME" ]]
    then
        if [[ $1 == "m" ]]
        then
            env="chs-mongo"
        elif [[ $1 == "k" ]]
        then
            env="chs-kafka"
        else
            env="chs-dev"
        fi
    fi
    cd $CH_CONTEXT_VAGRANT_DIR
    pwd
    echo $env
    #vagrant ssh $env --
    vagrant ssh -c "bash" $env -- -t "export KAFKA_BROKER_ADDR=$(ifconfig en0 | grep -w inet |cut -d ' ' -f 2):29093 SERVER_PORT=8081;"
}
#______________________________________
function ch_curl {
    local url="http://release.ch.gov.uk/chs/develop/"
    if [[ ! -z "$2"  ]]
    then
        url="$2"
    fi
    echo "retrieving artifacts from $url"
    local cmd="while (<>) {if(/>($1"'[^<]*?\.zip)(.*)/i) {$l=$1; printf("%10s\t\t%s\n",$1,$l) if($2=~/(\d{1,2}-\w{3}-\d{2,4})/); }}'
    curl -s "${url}" | perl -e "${cmd} | sort -r -k 1.8 -k 1.4 -k 1.1"
}
##______________________________________
#function ch_j {
#    echo "${@}"
#    get_branch.sh -m "${@}"
#}
#______________________________________
function ch_ls {
  case $1 in
      -l|--list)
          cmd='if(/^\s*gitclone[^"]+"([^"\s]+)"/i) {print "$1\n";}'
          cat ${HOME}/SingleService/vagrant-chs-development-v2/setup.sh | perl -n -e "${cmd}" | sort
          ;;
      -b|--build)
          cmd='if(/^\s*(java|go)?build[^"]+"([^"\s]+)"/i) {print "$2\n";}'
          cat ${HOME}/SingleService/vagrant-chs-development-v2/scripts/build_chs.sh | perl -n -e "${cmd}" | sort
          ;;
       *)
           echo $0 "-l|--list / -b|--build"
          ;;
  esac
}
#______________________________________
function set_CH_context {
    CH_CONTEXT_HOME=$1
    if [[ "$CH_CONTEXT_HOME" = "$CHL_HOME" ]]
    then
        CH_CONTEXT_VAGRANT_DIR="${CH_CONTEXT_HOME}/ansible-chl"
        CH_CONTEXT_DEV="chl-dev"
        CH_CONTEXT_SERVICES=(chl)
    elif [[ "$CH_CONTEXT_HOME" = "$CHS_HOME" ]]
    then
        CH_CONTEXT_VAGRANT_DIR="${CH_CONTEXT_HOME}/vagrant-chs-development-v2"
        CH_CONTEXT_DEV="chs-dev"
        CH_CONTEXT_SERVICES=(chs)
    elif [[ "$CH_CONTEXT_HOME" = "$CH_AWS_HOME" ]]
    then
        CH_CONTEXT_VAGRANT_DIR=""
        CH_CONTEXT_DEV=""
        CH_CONTEXT_SERVICES=()
    fi
}
#______________________________________
function set_AWS_context {
    AWS_ENV_TYPE=$1
    if [[ $1 == "l" ]]
    then
        AWS_ENV_TYPE="live"
    elif [[ $1 == "s" ]]
    then
        AWS_ENV_TYPE="staging"
    elif [[ $1 == "i" ]]
    then
        AWS_ENV_TYPE="integration"
    fi
}
#______________________________________
function ch_v {
    cd $CH_CONTEXT_VAGRANT_DIR
    vagrant "${@}"
}
#______________________________________
function ch_d {

    local db_names=(bcd ewf xml chdata)
    cd chl-database
    if [[ -z $1  ]]
    then
        for db in ${db_names[@]}; do
            #refreshSchema.sh -s "${db}devsb/${db}devsb@web" -t $db        # note on WEB    I'm sb
            refreshSchema.sh -s "${db}devstb/${db}devstb@webdev" -t $db    # note on WEBDEV I'm stb
        done
    else
            #refreshSchema.sh -s "$1devsb/$1devsb@web" -t $1
            refreshSchema.sh -s "$1devstb/$1devstb@webdev" -t $1
    fi
}
#______________________________________
function ch_c {
    cd ${CHL_HOME}/chl-perl
}

#______________________________________
function ch_master {
    local master_var="MASTER_TEMPLATES"
    local config_file="${CHL_HOME}/chl-configs/vagrant/global_env"
    echo "__________________ checking $config_file:"
    grep $master_var $config_file
    if [[ ! -z "$1"  ]]
    then
        sed -i -e "s/$master_var=[0-9]*/$master_var=$1/" $config_file
    fi
    grep $master_var $config_file
}

#______________________________________
function ch_cic {
    local cic="CHL_SCRS_COMMUNITY_INTEREST"
    local config_file="${CHL_HOME}/chl-configs/vagrant/global_env"
    echo "__________________ checking $config_file:"
    grep $cic $config_file
    local cic_date=
    if [[ $1 == "0" ]];
    then
          cic_date='20990101'
        sed -i -e "s/$cic=[0-9]*/$cic=$1/" $config_file
    elif [[ $1 == "1" ]]
    then
          cic_date='20090101'
    fi
    if [[ ! -z "$cic_date"  ]]
    then
        sed -i -e "s/$cic=[0-9]*/$cic=$cic_date/" $config_file
    fi
    grep $cic $config_file
}

#______________________________________
function ch_e2e {

    exp.ssh $(awk "/$1/{print \$1}" ~/ssh.servers.txt)
}


alias chs="ch ${CHS_HOME}"
alias chl="ch ${CHL_HOME}"
alias cha="ch ${CH_AWS_HOME}"
#______________________________________
function ch {
    set_CH_context $1
    cd "${CH_CONTEXT_HOME}"
    if [[ -z $2  ]]
    then
        return
    elif [[ $2 == "-h" ]]
    then
        echo -e "(k) kafka   (u) ubic [s/r]  (g) git [s/l/b/d -noc]  (ssh) connections (ls) list services\n"
    elif [[ $2 == "g" ]] # 'g' git
    then
        ch_g  "${@:3}"
    elif [[ $2 == "c" ]] # 'c'ode dir
    then
        ch_c
    elif [[ $2 == "d" ]] # 'd'atabase refresh
    then
        ch_d "${@:3}"
    elif [[ $2 == "k" ]] # 'k'afka: First thing to do: enter the kafka VM and run build.sh
    then
        ch_k
    elif [[ $2 == "u" ]] # 'ubic'
    then
        ch_u "${@:3}"
    elif [[ $2 == "ssh" ]] # 'ssh' to remotes
    then
        ch_ssh "${@:3}"
    elif [[ $2 == "curl" ]] # 'curl' for resources
    then
        ch_curl "${@:3}"
    #elif [[ $2 == "j" ]] # 'j' enkins
    #then
    #    ch_j "${@:3}"
    elif [[ $2 == "ls" ]] # 'list services'
    then
        ch_ls "${@:3}"
    elif [[ $2 == "v" ]] # 'v'agrant
    then
        ch_v "${@:3}"
    elif [[ $2 == "master" ]] # 'm'aster check & set
    then
        ch_master "${@:3}"
    elif [[ $2 == "cic" ]]
    then
        ch_cic "${@:3}"
    elif [[ $2 == "e2e" ]] # ssh to an e2e
    then
        ch_e2e "${@:3}"
    elif [[ $2 == "cut" ]] # cut a release
    then
        ch_cut "${@:3}"
    elif [[ $2 == "rel" ]] # cut a release
    then
        ch_release "${@:3}"
    fi
}

#______________________________________

function SQL_chips {
    local machine="$1"
    local sql_cmd=""
    local usage="db (machine) -lv ([last_value] [new value]) -x 'sql command'"
                #      $1     $2     $3          $4          $2    $3
    if [[ -z $1  ]]
    then
        echo -e "\n$usage"
        return
    fi
    #______________________
    if [[ $1 == "w" ]]
    then
        machine="WALDORFUNIX2"
    elif [[ $1 == "s" ]]
    then
        machine="STATLERUNIX2"
    fi
    #______________________
    if [[ $2 == "-lv" ]]
    then
        if [[ -z $3 ]]
        then
            sql_cmd="select * from REFERENCE_LAST_VALUE;"
        elif [[ -z $4 ]]
        then
            sql_cmd="select * from REFERENCE_LAST_VALUE where REFERENCE_PREFIX='$3';"
        else
            sql_cmd="update REFERENCE_LAST_VALUE set LAST_NUMBER_USED=$4 where REFERENCE_PREFIX='$3';\n commit;"
        fi

    #______________________
    elif [[ $2 == "-x" ]]
    then
        sql_cmd="$3"
    else
        echo -e "\n${usage}"
        return
    fi
    #______________________
    echo -e "connecting to [$machine]  \"${sql_cmd}\""
    echo -e "${sql_cmd}" | sqlplus -S $machine/$machine@CHIPS
}
#"SET PAGESIZE 0;\nSET WRAP OFF;\nselect incorporation_number, corporate_body_name  from  CORPORATE_BODY;"


function reset_proxy {
     env | grep -i proxy | awk 'BEGIN{FS="="; l="export "} {l=l $1 "= "} END{print l}'
}
#______________________________________
function as {
    local as_dir=${HOME}/auto_ssh
    if [[ -z $1  ]]
    then
        ${as_dir}/auto_ssh.sh
    elif [[ $1 == "p" ]]    # pre choice
    then
        ${as_dir}/auto_ssh.sh "${@:2}"
    elif [[ $1 == "k" ]]
    then
        vi ${as_dir}/known_hosts
    elif [[ $1 == "t" ]] # run the tcl script (forwarding any args)
    then
        ${as_dir}/auto_ssh.tcl -- "${@:2}"
    elif [[ $1 == "x" ]] # extract the password for the specified key
    then
        ${as_dir}/auto_ssh.tcl -- -env -x $2
    else
        cd ${as_dir}
    fi
}
#______________________________________
#  START OF AWS BLOCK
#______________________________________
function aws_slave_info {
    local start=${1:-1}
    local end=${2:-`echo $start`}
    echo "${HOME}/.ssh/ch-aws-${AWS_ENV_TYPE}.pem"
    for s in `seq $start $end`
    do
      local slave="mesos-slave${s}.${AWS_ENV_TYPE}.aws.internal"
      local slave_ip=$( nslookup ${slave} | sed -n '/ddress/ {s/[^0-9\.]*//;h;}; $ {x;p;}' )
      echo "${slave}|${slave_ip}"
    done
}
#______________________________________
function aws_ssh {
    #local slaves_info=($( aws_slave_info "${@:1}" | tr '|' '\n' ) )
    local slaves_info=($( aws_slave_info "${@:1}" ) )
    select slave in ${slaves_info[@]:1}
    do
        ip=$(echo $slave | sed -e 's/[^|]*|//' )
        ssh -i $slaves_info[1] -o "StrictHostKeyChecking no" ec2-user@$ip
        break;
    done
}
#______________________________________
function saws {   # support aws  (aws alone is already the https://aws.amazon.com/cli/)
    local help=
    set_AWS_context $1
    if [[ -z $1 ]]
    then
        help=1
    else
        if [[ $2 == "ip" ]]
        then
            aws_slave_info  "${@:3}" | nl -v 0 -n rn
        elif [[ $2 == "ssh" ]]
        then
            aws_ssh "${@:3}"
        else
        help=1
        fi
    fi
    if [[ $help ]]
    then
        echo "\tsaws [l,i,s] [ip,ssh] [start[1]] [end[start]]"
    fi
}

#______________________________________
#  END OF AWS BLOCK
#______________________________________

#______________________________________
#  START TMUX SCRIPTS
#______________________________________

#___________________
# array acting like a hash table fo envs
TMUX_RELEASE_ENVS=('ewffe:2 5 " as p 2 5 1 XXX1")'  # the starting space is to not log in the history
                   'ewfbe:2 2 " as p 2 5 2 XXX1")'
                   'xmlfe:2 3 " as p 2 7 1 XXX1")'
                   'xmlbe:1 2 " as p 2 7 2 XXX1")'
                   );
# Bash 3 has no hashes and Bash 4 / Zsh are bit different so hacking here
function tmux_getEnv_info {
    setopt KSH_ARRAYS BASH_REMATCH
    local regex="$1: *([0-9]*) *([0-9]*) *"'"([^"]*)"'
    if [[ "${TMUX_RELEASE_ENVS[*]}" =~ $regex ]]
    then
        TMUX_RELEASE_ENV=("${BASH_REMATCH[@]:1}")
    fi
    unsetopt KSH_ARRAYS BASH_REMATCH
}
#___________________
function tmux_split_panel {   # split a basePanel (default 0) in N equal cols (default)
    local N=$1                #                               or N row
    local basePanel=${2:-0}
    local splitType=${3:-"h"}
    if [ "$N" -gt "1" ]
    then
        for i in $(seq $N 2); do
            tmux selectp -t $basePanel
            local size=$((100/i))
            tmux splitw -${splitType} -p $size
        done
    fi
}
#___________________
function tmux_double_split {   # split a basePanel both vertically and horizontally
    local rows=$1
    local cols=$2
    local basePanel=${3:-0}
    if [ "$cols" -gt "1" ]
    then
        tmux_split_panel $cols $basePanel
    fi
    if [ "$rows" -gt "1" ]
    then
        for i in $(seq 1 $cols); do
            tmux_split_panel $rows $basePanel "v"
            basePanel=$((basePanel+rows))
        done
    fi
}
#___________________
function tmux_get_panel_num {
#         1     2                      COLS
#      ---0-----5----10---------------------
#   1  |    1|    2|    3|    4|    5|    6|
#      ---1-----6----11---------------------   The sequantial x='9'
#   2  |    7|    8|    9|   10|   11|   12|   is in the panel --11--
#      ---2-----7----12---------------------                   |   9|
#   .. |     |     |     |     |     |     |                   ------
#      ---3-----8---------------------------
#  ROWS|     |     |     |     |     |     |
#      ---4-----9---------------------------

    local ROWS=$1
    local COLS=$2
    local x=$3

    local row=$(( (x-1)/COLS + 1))
    local col=$(( (x-1)%COLS + 1))

    TMUX_PANEL_NUM=$(( (ROWS * (col - 1)) + row - 1 ))
}
#___________________
function tmux_sendPanel_cmd {
    local panel=$1
    local cmd="$2"
    local i=$3
    cmd="${cmd/XXX1/$i}"
    tmux selectp -t $panel
    tmux send-keys "$cmd" C-m
}
#___________________
function tmux_sendAllPanels_cmd {
    local ROWS=$1
    local COLS=$2
    local cmd=$3
    local basePanel=${4:-0}
    local TOT=$(( COLS * ROWS ))    # tot Panels
    for i in $(seq 1 $TOT); do
        tmux_get_panel_num $ROWS $COLS $i
        local panel=$(( basePanel + TMUX_PANEL_NUM ))
        tmux_sendPanel_cmd $panel "$cmd" $i
    done
}
#___________________
function tmux_create_env_panels {
    local env=$1
    local action=$2

    tmux_getEnv_info $env
    local ROWS=${TMUX_RELEASE_ENV[1]}
    local COLS=${TMUX_RELEASE_ENV[2]}
    local cmd=${3:-${TMUX_RELEASE_ENV[3]}}  # use $3 as cmd if specified

    if [[ $action == "create" ]]
    then
        tmux new-window -n "$env"      # 1. create window
        tmux_double_split $ROWS $COLS  # 2. create panels

    elif [[ $action == "send" ]]
    then
        tmux select-window -t "$env"                # 1. select the window
        tmux_sendAllPanels_cmd $ROWS $COLS "$cmd"  # 2. send cmd to all panels
    fi
}
function ch_release {
    if [[ $1 == "ewf" ]]
    then
        if [[ $2 == "all" || $2 == "fe" ]]
        then
            tmux_create_env_panels "ewffe" $3 "$4"
        fi
        if [[ $2 == "all" || $2 == "be" ]]
        then
            tmux_create_env_panels "ewfbe" $3 "$4"
        fi
    elif [[ $1 == "xml" ]]
    then
        if [[ $2 == "all" || $2 == "fe" ]]
        then
            tmux_create_env_panels "xmlfe" $3 "$4"
        fi
        if [[ $2 == "all" || $2 == "be" ]]
        then
            tmux_create_env_panels "xmlbe" $3 "$4"
        fi
    else
        echo "\tch_release [ewf,xml] [fe,be,all] [create,send] [cmd]"
    fi
}
#______________________________________
#  END TMUX SCRIPTS
#______________________________________
