alias a='alias'
a ll='ls -al -G'
a h='fc -l 1'
#a hf='$(fc -l 1 | awk "{$1=\"\"}1" | fzf )'
#a hf='$(fc -l 1 | fzf ")'
#a ff='fd | fzf'
a g='git'
a dk='docker'
a dki='docker image'
a dkc='docker container'
a ap="cd ${HOME}/back-up/APPUNTI"
a s="cd ${HOME}/SUP/AWS_CONFIGS/s"
a l="cd ${HOME}/SUP/AWS_CONFIGS/l"
a sx="cd ${HOME}/SUP/AWS_CONFIGS/sx"
a lx="cd ${HOME}/SUP/AWS_CONFIGS/lx"
a con="cd ${HOME}/SUP/CONCOURSE/ci-pipelines"
a gl="~/bin/gl.sh"

a vi=vim
a ns=nslookup

a fuck_her='printf 914.46'

#---------- auto ssh start
#alias as='${HOME}/auto_ssh/auto_ssh.sh'
#alias ask='vi ${HOME}/auto_ssh/known_hosts'
#alias ast='${HOME}/auto_ssh/auto_ssh.tcl'
#alias asx='${HOME}/auto_ssh/auto_ssh.tcl -- -env -x'
alias fes='cd ${HOME}/bin/fes'
alias sd='as p 6 2'
#---------- auto ssh end


#---------- JAVA start
export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
#export JAVA_9_HOME=$(/usr/libexec/java_home -v9)

alias java7='export JAVA_HOME=$JAVA_7_HOME'
alias java8='export JAVA_HOME=$JAVA_8_HOME'
#alias java9='export JAVA_HOME=$JAVA_9_HOME'

export JAVA_HOME=$JAVA_8_HOME  # default java8
#---------- JAVA end
a /Library/Developer/CommandLineTools/usr/bin/

# old before new Mac
#     a tl='tmux new-session -s mymain -n start -d; tmux source-file ~/tmux.script.start.chl.conf ; tmux attach'
#     a ts='tmux new-session -s mymain -n start -d; tmux source-file ~/tmux.script.start.chs.conf ; tmux attach'
#     a m='sshfs sbasile@wswebdev1.orctel.internal: ~/REMOTE_DEV1/'
#     a ncdu="du -akx | sort -nr | head -100 | awk '{print $2}' | xargs du -hs 2>/dev/null"
#     a ga="cd ~/SingleService/go/src/github.com/companieshouse/pa-kafka-poc"
#     a gr="cd ~/SingleService/go/src/github.com/companieshouse/resource-change-publisher"
#------------- CHIPS ALIAS
#     a chipst="sed -i -e 's/\(displayTimeoutPopupWindow();\)/return; \1/' /Users/sbasile/CHIPS-SHARE/bea12/user_projects/domains/chips-domain/autodeploy/chips_ear/chips_web/js/session-common.js"
