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

function ffh  { print -z $( fc -l 1 | awk '{$1=""}1' |fzf  ) }
function ffv  { vi -o $( fzf -m ) }
function ffga { git add $( git status -s | fzf -m | sed 's/^...//' ) }


function awsenv () {
   local env=$1
   export AWS_PROFILE=${env}
   ssh-add ~/.ssh/ch-aws-${env}.pem
   export AWS_ENVIRONMENT_TAG=${env}
}

function awsenv0 () {
   local env=$1
   tfenv use 0.8.8      # uncomment when you need
   export AWS_PROFILE=development
   ssh-add ~/.ssh/chs-${env}.pem
   export AWS_ENVIRONMENT_TAG=${env}
}
#______________________________________
# to rebuild virtual envs after brew crashed them
function rebuild_python_virt_envs () {
    local VENV=''
    echo 'lsvirtualenv'

    VENV='python.2.7.17.boto.boto3.ansible.2.7.9'
    echo 'deactivate'
    echo 'rmvirtualenv' "$VENV"
    echo 'mkvirtualenv' "$VENV"
    echo 'pip install boto'
    echo 'pip install boto3'
    echo 'pip install ansible==2.7.9'

    VENV='aws-cli-on.python.2.7.17'
    echo 'deactivate'
    echo 'rmvirtualenv' "$VENV"
    echo 'mkvirtualenv' "$VENV"
    echo 'pip3 install awscli --upgrade'
    echo 'pip3 install boto3'

    VENV='aws-cli-on.python.3'
    echo 'deactivate'
    echo 'rmvirtualenv' "$VENV"
    echo '/usr/local/bin/python3 --version'         # Python 3.7.6
    echo 'mkvirtualenv --python=/usr/local/bin/python3' "$VENV"
    echo 'pip3 install awscli --upgrade'
    echo 'pip3 install boto3'

}

function top_sort_cpu {
     ${HOME}/SUP/fes-administration-scripts/restart-apps-on-high-cpu-slaves/restart-apps-on-high-cpu-slaves.pl
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
    vagrant ssh $env --
    #vagrant ssh -c "bash" $env -- -t "export KAFKA_BROKER_ADDR=$(ifconfig en0 | grep -w inet |cut -d ' ' -f 2):29093 SERVER_PORT=8081;"
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
    elif [[ $2 == "rel" ]] # release CHL
    then
        ch_release "${@:3}"
    elif [[ $2 == "remcmd" ]] # release CMD
    then
        ch_legacySystems_cmd "${@:3}"
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
     local cmd=$(env | grep -i proxy | awk 'BEGIN{FS="="; l="export "} {l=l $1 "= "} END{print l}')
     eval "$cmd"
}
#______________________________________
function auto_help {
    local function_name="$1"
    local test_var="$2"
    cat ${HOME}/_shell.functions.sh | sed -n -E -e "/function[ \t]*${function_name}/,/^[ \t]*}[ \t]*$/ { s/.*${test_var}[ \t]*==[ \t]*\"([^\"]*).*/\1/ p;}"
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
    elif [[ $1 == "h" || $1 == "-h" || $1 == "--help" || $1 == "-help" ]]
    then
        ${as_dir}/auto_ssh.tcl -- -h
    else
        cd ${as_dir}
    fi
}
#______________________________________
#  START OF AWS BLOCK
#______________________________________
#______________________________________
function set_AWS_context {
    AWS_ENV_TYPE=$1
    AWS_LOCAL_DIR_CONFIG="${HOME}/SUP/AWS_CONFIGS"
    if [[ $1 == "l" ]]
    then
        AWS_ENV_TYPE="live"
        AWS_S3_DIR_RELEASE="ch-service-live-release.ch.gov.uk/"
        AWS_S3_DIR_CONFIG="ch-service-live-config.ch.gov.uk/live/"
        AWS_MONGO_PASS=m0ng0pr0dadm1n
    elif [[ $1 == "s" ]]
    then
        AWS_ENV_TYPE="staging"
        AWS_S3_DIR_RELEASE="ch-service-staging-release.ch.gov.uk/"
        AWS_S3_DIR_CONFIG="ch-service-staging-config.ch.gov.uk/staging/"
        AWS_MONGO_PASS=m0ng0adm1n
    elif [[ $1 == "b" ]]
    then
        AWS_ENV_TYPE="bulk-live"
        AWS_S3_DIR_RELEASE="ch-service-live-release.ch.gov.uk/"
        AWS_S3_DIR_CONFIG="ch-service-live-config.ch.gov.uk/bulk_live/"
    elif [[ $1 == "i" ]]
    then
        AWS_ENV_TYPE="integration"
        AWS_S3_DIR_RELEASE=""
        AWS_S3_DIR_CONFIG=""
    elif [[ $1 == "d" ]]
    then
        AWS_ENV_TYPE="development"
        AWS_S3_DIR_RELEASE="release.ch.gov.uk/"
        AWS_S3_DIR_CONFIG=""
    fi
    AWS_ENV_KEY="${HOME}/.ssh/ch-aws-${AWS_ENV_TYPE}.pem"
}
#______________________________________
function aws_boxes_ips {
    local box_name=${1}
    local start=${2}
    local end=${3}
    for s in `seq $start $end`
    do
      local box="mesos-${box_name}${s}.${AWS_ENV_TYPE}.aws.internal"
      local box_ip=$( nslookup ${box} | tail -2 | sed -n '/ddress/ {s/[^0-9\.]*//;h;}; $ {x;p;}' )
      echo "${box}|${box_ip}"
    done
}
#______________________________________
function aws_box_info {
    local start=${1:-1}
    #local end=${2:-`echo $start`}
    local end=${2:-18}
    aws_boxes_ips 'master' 1 3
    aws_boxes_ips 'slave'  $start $end
}
#______________________________________
function aws_ssh {
    #local slaves_info=($( aws_slave_info "${@:1}" | tr '|' '\n' ) )
    local boxes_info=($( aws_box_info "${@:1}" ) )
    select box in ${boxes_info[@]}
    do
        ip=$(echo $box | sed -e 's/[^|]*|//' )
        ssh -i ${AWS_ENV_KEY} -oStrictHostKeyChecking=no -oConnectTimeout=5 ec2-user@$ip
        break;
    done
}
#______________________________________
function aws_rcmd {
    local cmd="$1"
    local boxes_info=($( aws_box_info "${@:2}" ) )
    local col_start=${F_FG_GREEN}
    local col_end=${F_RESET}
    for box in ${boxes_info[@]}
    do
        ip=$(echo $box | sed -e 's/[^|]*|//' )
        echo "${col_start}-------------------------[$box]${col_end}"
        ssh -i ${AWS_ENV_KEY} -oStrictHostKeyChecking=no -oConnectTimeout=5 ec2-user@$ip "$cmd"
    done
}
#______________________________________
function aws_output_rcmd {
    local cmd_output="$1"
    local cmd="$2"
    local boxes_info=($( aws_box_info "${@:3}" ) )
    local col_start=${F_FG_GREEN}
    local col_end=${F_RESET}
    for box in ${boxes_info[@]}
    do
        ip=$(echo $box | sed -e 's/[^|]*|//' )
        echo "${col_start}-------------------------[$box]${col_end}"
        local output=$( ssh -i ${AWS_ENV_KEY} -o "StrictHostKeyChecking no" ec2-user@$ip "$cmd_output" )
        echo $output | top_sort_cpu
    done
}
#______________________________________
function aws_s3 {
    local dir=$AWS_S3_DIR_RELEASE
    local global_env="global_env"
    if [[ -z $1  || $1 == "release" ]]
    then
        :
    elif [[ $1 == "config" ]]
    then
        dir=$AWS_S3_DIR_CONFIG
    elif [[ $1 == "gup" ]]
    then
         aws --profile $AWS_ENV_TYPE s3 cp $global_env s3://$AWS_S3_DIR_CONFIG
    elif [[ $1 == "gdown" ]]
    then
        if [[ -f $global_env ]]
        then
            cp $global_env ${global_env}.bak
        fi
        aws --profile $AWS_ENV_TYPE s3 cp s3://${AWS_S3_DIR_CONFIG}$global_env ${global_env}.ori
        cp ${global_env}.ori $global_env
        if [[ $2 == "-e" ]]
        then
            vi $global_env
            vimdiff $global_env ${global_env}.ori
        fi
    fi

    if [[ $2 == "cp" ]]
    then
        echo "aws --profile $AWS_ENV_TYPE s3 cp ./ s3://$dir --exclude '*' --include '*.zip' --recursive"
    elif [[ $2 == "ls" ]]
    then
        if [[ -z $3 ]]
        then
            aws --profile $AWS_ENV_TYPE s3 ls s3://$dir
        else
            aws --profile $AWS_ENV_TYPE s3 ls s3://$dir | grep -i $3
        fi
        echo "aws --profile $AWS_ENV_TYPE s3 cp s3://$dir ."

    elif [[ $1 == "config" ]]
    then
        cd $AWS_LOCAL_DIR_CONFIG/$AWS_ENV_TYPE
        if [[ $2 == "pull" ]]
        then
            aws --profile $AWS_ENV_TYPE s3 cp s3://$AWS_S3_DIR_CONFIG . --recursive
            cd $AWS_ENV_TYPE
            git status
        elif [[ $2 == "push" ]]
        then
            local files_changed=$(git status --porcelain)
            echo "files changed:\n$files_changed"
            if [[ $files_changed ]]
            then
                echo  "push [y/n]? "
                read  ok_to_push
                if [[ "$ok_to_push" = "y" ]]
                then
                    for f in $( echo $files_changed| awk '{print $2}')
                    do
                        aws --profile $AWS_ENV_TYPE s3 cp $f s3://${AWS_S3_DIR_CONFIG}${f}
                    done
                fi
            fi
        fi
    fi
    echo "_______________________"
    echo "DIR_RELEASE=s3://$AWS_S3_DIR_RELEASE"
    echo "DIR_CONFIG=s3://$AWS_S3_DIR_CONFIG"
}
#______________________________________
function aws_restart_Mesos_Marathon {
    local ok=
    if [[ ${AWS_ENV_TYPE} != 'staging' ]]
    then
        for i in 1 2
        do
            echo "Restarting on ${AWS_ENV_TYPE} ??? Are you sure ???  [yes/-]  (remind $i of 2)"
            read  ok
            if [[ $ok != 'yes' ]]
            then
                return
            fi
        done
    fi
    for i in 1 2 3
    do
        ssh -i $AWS_ENV_KEY  ec2-user@mesos-master${i}.${AWS_ENV_TYPE}.aws.internal 'sudo stop mesos-master;sudo stop marathon;sudo start mesos-master;sudo start marathon'
    done
}
#______________________________________
function aws_marathon_rest_api_old {
    if [[ -z $1  || $1 == "ls" ]]
    then
        local perl_script='$s; $l=$ARGV[0]; %k=map{$_ => 1} (split (/ /,$ARGV[0])); while (<STDIN>) { (($l eq "ALL") && (print)) || (/"id"[^:]*:(.*)/ && (print "$s\n") && ($s=" $1")) || ($_ =~ /"([^"]+)"[^:]*:(.*)/ && (exists $k{$1}) && ($s.=" [$1] $2") ); } print "$s\n";'
        curl -X GET --netrc-file ${HOME}/_shell.curl.sh http://mesos-master1.${AWS_ENV_TYPE}.aws.internal:8080/v2/apps | jq '.' | perl -e "$perl_script" "$2" | sort | nl
    fi
}
#______________________________________
function aws_marathon_rest_api {
    ${HOME}/SUP/fes-administration-scripts/restart-app/restart-app.pl -e ${AWS_ENV_TYPE} "$@"
}
#______________________________________
function aws_trans_processing_find {
    echo "...querying MONGO for $3"
    ssh -i $AWS_ENV_KEY  $1  "$2" | sed -ne '/_id/ {s/[^:]*:// p;}' | sort > $3
}
#______________________________________
function aws_trans_processing {
  local MONGO_HOST=mongo-db1.${AWS_ENV_TYPE}.aws.internal:27017
  local SLAVE=ec2-user@mesos-slave2.${AWS_ENV_TYPE}.aws.internal

  local CMD="mongo  --host $MONGO_HOST --authenticationDatabase admin -u admin -p $AWS_MONGO_PASS --eval 'db=db.getSiblingDB(\"transactions\"); printjson(db.getCollection(\"transactions\").find({ \$and : [{\"data.filings\": { \$exists: true}},{ \$where : function() { return (this.data.filings[this._id + \"-1\"].status == \"processing\") }}] },{_id:1}).toArray())'"

  local SLEEP=20
  aws_trans_processing_find  "$SLAVE" "$CMD" stuck1
  echo "...sleeping for $SLEEP"
  sleep $SLEEP
  aws_trans_processing_find  "$SLAVE" "$CMD" stuck2

  comm -12 stuck1 stuck2
}
#______________________________________
function myaws {   # support aws  (aws alone is already the https://aws.amazon.com/cli/)
    set_AWS_context $1
    if [[ -z $2  ]]
    then
        auto_help myaws 2
        return
    elif [[ $2 == "ip" ]]
    then
        echo "______ [start[1]] [end[18]]"
        aws_box_info  "${@:3}" | nl -v 0 -n rn
    elif [[ $2 == "ssh" ]]
    then
        echo "______ [start[1]] [end[18]]"
        aws_ssh "${@:3}"
    elif [[ $2 == "s3" ]]
    then
        aws_s3 "${@:3}"
    elif [[ $2 == "cmd" ]]
    then
        aws_rcmd "${@:3}"
    elif [[ $2 == "cmdspace" ]]
    then
        aws_rcmd 'df -hT' "${@:3}"
    elif [[ $2 == "cmdcpu" ]]
    then
        aws_rcmd 'iostat -y -h -c' "${@:3}"
    elif [[ $2 == "cmdapps" ]]
    then
        aws_rcmd "ps -ef | grep executors | grep -v mesos-logrotate-logger | sed -n -e '/\/executors\// {s/.*\/executors\/\(.*\)\.[^-]*-[^-]*-[^-]*-[^-]*-[^/]*\/.*/\1/; p;}' | sort | nl" "${@:3}"
    elif [[ $2 == "cmddir" ]]
    then
        cmd='for L in $(ps -ef | grep executors | grep -v mesos-logrotate-logger | sed -n -e "s|.*\(/var/mesos/slaves/[^ ]*\) .*|\1|p;" ); do d=$(echo $L | sed -n -e "s|\(.*/runs/[^/]*/\).*|\1|p;"); f=$( echo $d | sed -n -e "/\/executors\// {s|.*/executors/\(.*\)\.[^-]*-[^-]*-[^-]*-[^-]*-[^/]*/.*|\1|; p;}"); printf "\n-----------$f:\n\n"; out=$(cd $d;'"$3"'); printf "$out\n"; done'

        aws_rcmd "$cmd"  "${@:4}"
    elif [[ $2 == "xxx" ]]
    then
        aws_output_rcmd "top -b -n 1 -c" "${@:3}"
    elif [[ $2 == "restartMM" ]]
    then
        aws_restart_Mesos_Marathon
    elif [[ $2 == "restartApps" ]]  # (Mesos) Marathon REST API
    then
        aws_marathon_rest_api "${@:3}"
    elif [[ $2 == "trans_processing" ]]  # find stuck 'processing' transactions
    then
        aws_trans_processing "${@:3}"
    fi
}
#______________________________________
#  END OF AWS BLOCK
#______________________________________
#______________________________________
#  START OF ONCALL BLOCK
#______________________________________
#______________________________________
# verify BRIS disk space is not full
function oncall_bris {
    local col_start=${F_FG_GREEN}
    local col_end=${F_RESET}
    local MAX=70

    local str=$( ssh -i $AWS_ENV_KEY centos@bris-domibus1.live.aws.internal 'sudo df -hT' )
    local avail_space=$( echo "$str" | sed -E -n -e 's/.*[ \t]([0-9]*)%[ \t]*\/$/\1/p')

    if [ "$avail_space" -gt "$MAX" ]
    then
        col_start=${F_FG_RED}
    fi

    echo "$str"
    echo "${col_start}avail space: ${avail_space}${col_end}"
}
#______________________________________
function oncall {
    set_AWS_context 'l'
    oncall_bris
}
#______________________________________
#  END OF ONCALL BLOCK
#______________________________________
#______________________________________
#  START OF LEGACY PROCEDURES
#______________________________________

function get_connection_param_value {
    echo $1| grep -w $2 | awk '{print $2}'
}
#______________________________________
function ch_legacySystems_cmd {
    local tag=$1
    local system=$2
    local sub_sys=$3
    local start_num=$4
    local end_num=$5
    local cmd=$6

    if [[ "$end_num" = "-" ]]
    then
        local info=$(get_connection_info.pl $tag $system $sub_sys 1)
        end_num=$(get_connection_param_value $info 'tot_instances')
    fi

    if [[ "$cmd" = "cronout" ]]
    then
        cmd='STR="sb"; crontab -l | sed -e "s/^/#$STR/" > crontab.bk; crontab crontab.bk;'
    elif [[ "$cmd" = "cronin" ]]
    then
        cmd='STR="sb"; crontab -l | sed -e "s/^#$STR//" > crontab.bk; crontab crontab.bk;'
    fi
        echo "$end_num $tag $system $sub_sys $start_num $end_num $cmd"

    for i in $( seq $start_num $end_num)
    do
        local info=$(get_connection_info.pl $tag $system $sub_sys $i)
        local pass_k=$(get_connection_param_value $info 'password_key')
        if [[ ! -z "${pass_k}" ]]
        then
            local pass=$(as x $pass_k | tail -1)
            local host=$(get_connection_param_value $info 'host')
            local user=$(get_connection_param_value $info 'user')
            echo "-----------[$i]--------- $user@$host [$cmd]"
            sshpass -p $pass ssh -oStrictHostKeyChecking=no  $user@$host "$cmd"
        fi
    done
}
#______________________________________
function ch_tux_send {
    local tag=$1              #ex. live
    local system=$2           #ex. ewf
    local start_num=$3        #ex. 1
    local end_num=$4          #ex. -  (for all)
    local remote_cmd=$5       #ex. 35 (for shuttle 35)
    local xml_params=$6       #ex. SC059189  (company num to substitute in template)
    local xml_template="$TUX_SHUTTLES_DIR/shuttle$remote_cmd.template.xml"

    local remote_dir='uddir'
    local remote_temp_file="$remote_dir/xml_temp_tux_msg.xml"
    local xml_content=$( cat "$xml_template" | sed "s/\"/\\\\\"/g; s/COMP_NUM/$xml_params/" )
    local cmd="echo \"$xml_content\" > $remote_temp_file ; source .bash_profile; appdir/xmltuxc shuttle$remote_cmd $remote_temp_file"

    ch_legacySystems_cmd $1 $2 'tux' $3 $4 "$cmd"
}
#______________________________________
#  END OF LEGACY PROCEDURES
#______________________________________
#______________________________________
#  START TMUX SCRIPTS
#______________________________________

#___________________
# array acting like a hash table fo envs
TMUX_RELEASE_ENVS=('ewffe:2 5 " as p 2 6 1 XXX1")'  # the starting space is to not log in the history
                   'ewfbe:2 2 " as p 2 6 2 XXX1")'
                   'xmlfe:2 3 " as p 2 8 1 XXX1")'
                   'xmlbe:1 2 " as p 2 8 2 XXX1")'
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
        tmux select-window -t "$env"               # 1. select the window
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
#______________________________________
#  START EDIT BANNERS
#______________________________________

function update_banner {
    local address_part1="$1"
    local address_part2="$2"
    local tot=$3
    local pswd="$4"
    local path="$5"
    local file="$6"
    local local=${file}.$(/bin/date | /usr/bin/sed -e 's/ /./g') # not overwrite another eventual file
    echo "$pswd"
    /usr/bin/scp "${address_part1}1${address_part2}:$path$file" "$local"
    vi $file
    #for i in $(seq 1 $tot); do /usr/bin/scp
    for i in $(/usr/bin/seq $tot); do echo "\"$local\" ${address_part1}${i}${address_part2}:$path$file"; done
}

function banner_chd {
    update_banner 'chd3live@chdweb' 'v4.orctel.internal' 4 $(as x chd | tail -1) 'htdocs/chd3/templates/en/stdchd/' 'login.tmpl'
}
function banner_ewf {
    update_banner 'ewflive@ewfweb' 'v4.orctel.internal' 10 $(as x ewf | tail -1) 'htdocs/efiling/static/banner/en/' 'ef_welcome_banner.txt'
}
#______________________________________
#  END EDIT BANNERS
#______________________________________

