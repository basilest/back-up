stty start undef stop undef     #  In most terminals, Vim cannot distinguish between Enter and its combinations with Ctrl or Shift
                                #  The terminal's flow control commands may interfere with Ctrl-S and Ctrl-Q
export TOPIC="PA_STREAMING_1"

export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth

source ${HOME}/_shell.aliases.sh
source ${HOME}/_shell.exports.sh
source ${HOME}/_shell.functions.sh

#______________________________________
cb () {
  echo $(echo "obase=$2; ibase=$1; print $3" | bc)
}

#______________________________________
gl.ori() {
    local NUM_COMMITS=""
    local ALSO_PATCH=""
    if [[ !( -z $1 ) ]]
    then
        NUM_COMMITS="-$1"
    fi
    if [[ !( -z $2 ) ]]
    then
        ALSO_PATCH="-p"
    fi
    CMD="git log $NUM_COMMITS --stat=200 $ALSO_PATCH"
    echo ${CMD}
    ${CMD}
}
export SVN_BRANCH='Scrum_Dev' # CHIPS_Post_June

#______________________________________
c() {
    local SHARE_DIR="${HOME}/CHIPS-SHARE"
    local DIR=${SHARE_DIR}
    local DIRS=(
            "0=${SHARE_DIR}/${SVN_BRANCH}"
            "1=${SHARE_DIR}/bea12"
            "b=${SHARE_DIR}/${SVN_BRANCH}/Source/Java/J2eeAppServer/build/developers"
            "j=${SHARE_DIR}/${SVN_BRANCH}/Source/Java/J2eeAppServer/"
            "p=${SHARE_DIR}/${SVN_BRANCH}/Source/Java/J2eeAppServer/build/resources"
            "s=${SHARE_DIR}/${SVN_BRANCH}/Source/"
         )

    for dir in "${DIRS[@]}" ; do
        local KEY="${dir%%=*}"
        local VALUE="${dir##*=}"
        if [[ -z $1 ]]
        then
            printf "\t%s\t:\t%s.\n" "$KEY" "$VALUE"
        elif [[ $1 == $KEY ]]
        then
             DIR=$VALUE
             break;
        fi
    done
    cd $DIR
}
#______________________________________
d() {
    local SHARE_DIR="${HOME}/CHIPS-SHARE"
    local DIR=${SHARE_DIR}
    local DIRS=(
            "0=${SHARE_DIR}/chips"
            "1=${SHARE_DIR}/bea12"
            "b=${SHARE_DIR}/chips/build/developers"
            "p=${SHARE_DIR}/chips/build/resources"
         )

    for dir in "${DIRS[@]}" ; do
        local KEY="${dir%%=*}"
        local VALUE="${dir##*=}"
        if [[ -z $1 ]]
        then
            printf "\t%s\t:\t%s.\n" "$KEY" "$VALUE"
        elif [[ $1 == $KEY ]]
        then
             DIR=$VALUE
             break;
        fi
    done
    cd $DIR
}
#______________________________________
function send_panels_tmux_cmd {
    local i=0
    local DIRS_ARRAY=(logs scripts code)
    local CMD="$2"

   for dir in ${DIRS_ARRAY[@]}; do
       if [[ ! -z $3 ]]
       then
           CMD="${dir} ; banner ${dir} ; ls -lt"
       fi
       tmux send-keys -t mymain:e2e$1.$i "${CMD}" C-m
           ((i++))
   done

}
#______________________________________
function e2 {
    local SERVER=""
    local CHIPS_USER=""

    if [[ $1 == "w" ]]  # WALDORF
    then
        SERVER="chpdev-sl7";
        CHIPS_USER="CHIPSe2e4";
    elif [[ $1 == "s" ]] # STATLER
    then
        SERVER="chpdev-pl7";
        CHIPS_USER="wldev10";
    fi

    if [[ -z $SERVER ]]
    then
        echo "unable to execute ssh on server $SERVER"
    else
        if [[ -z $2 ]]
        then
             ssh "$USER@$SERVER"
        else
              #tmux select-pane -R
              tmux new-window -n "e2e$1"
              #tmux select-pane -R
              tmux split-window -h
              tmux split-window -v

              send_panels_tmux_cmd $1 "stty -echo"
              sleep 1
              send_panels_tmux_cmd $1 "ssh $USER@$SERVER"
              sleep 1
              send_panels_tmux_cmd $1 "sudo su - ${CHIPS_USER}"
              send_panels_tmux_cmd $1 "come45"
              sleep 1
              send_panels_tmux_cmd $1 0 2
              send_panels_tmux_cmd $1 "stty echo"

              #tmux select-pane -R
          fi
    fi
}

#______________________________________
L() {
  links -https-proxy ${PROXY_PATH} -http-proxy ${PROXY_PATH} $1
}



#______________________________________
#
