#################################### CORP PROXY ###################################
#PROXY_SERVER=corporate-proxy-server-here
#PROXY_PORT=8888
#PROXY_SERVER=wsproxy.internal.ch       old. Changed on 2020.06.04
PROXY_SERVER=websenseproxy.internal.ch
PROXY_PORT=8080
#PROXY_USERNAME=proxy_account
#PROXY_PASSWORD=proxy_password
PROXY_USERNAME=
PROXY_PASSWORD=
PROXY_PATH="$PROXY_SERVER:$PROXY_PORT"
#PROXY=$PROXY_USERNAME:$PROXY_PASSWORD@$PROXY_PATH
PROXY="$PROXY_PATH"
#export http_proxy=http://${PROXY_SERVER}:${PROXY_PORT}
#export https_proxy=http://${PROXY_SERVER}:${PROXY_PORT}
#export HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT}
#export HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT}
## RSYNC
export rsync_proxy=$PROXY
export RSYNC_PROXY=$PROXY
## HTTP and HTTPS
export http_proxy=http://$PROXY
export HTTP_PROXY=http://$PROXY
export https_proxy=http://$PROXY
export HTTPS_PROXY=http://$PROXY
export no_proxy=localhost,chs-dev,chs-kafka,chs-mongo,chs-logs,chs-metrics,chs-dev.internal,*.chs-dev.internal,*.aws.chdev.org
export NO_PROXY=${no_proxy}



export PATH=".:/usr/local/bin:/Users/sbasile/bin:$PATH:/usr/local/sbin:/Users/sbasile/GRADLE/gradle-2.14/bin:~/Development"
#echo "----------1---------------- $PATH"
export GREP_OPTIONS='--exclude *\.svn* --color=auto'
export MYCOL="30BK_31R_32G_33Y_34BL_35MG_36CY_37W"
export EDITOR=vim
export CDPATH=".:${HOME}:${CHS_HOME}"

#_______________________________ <CHIPS>
export USERNAME=$(id -un)
export MACHINENAME=$(hostname | sed -e 's/\..*//')
export COMPUTERNAME=${MACHINENAME}
export BEA_HOME="/Users/${USERNAME}/CHIPS-SHARE/bea12"
export MW_HOME="/Users/${USERNAME}/CHIPS-SHARE/bea12"
export WL_HOME="/Users/${USERNAME}/CHIPS-SHARE/bea12/wlserver_12.1"
export LSCOLORS=Exfxcxdxbxegedabagacad


#_______________________________ <CHS>
export CHS_HOME=$HOME/SingleService
export CH_AWS_HOME=$HOME/CH_AWS
export AWS_PAGER=""    # to avoid default pager (less on linux) for aws-cli-v2 (breaking change with v1)
export GOPATH=$CHS_HOME/go
export PATH=$PATH:$GOPATH/bin
#echo "----------4---------------- $PATH"

#_______________________________ <CHS-MAVEN>
export MAVEN_REPOSITORY_SCHEME=http
export MAVEN_REPOSITORY_HOST=repository.aws.chdev.org
export MAVEN_REPOSITORY_PORT=8081
export MAVEN_REPOSITORY_PATH=/artifactory
export MAVEN_REPOSITORY_URL=${MAVEN_REPOSITORY_SCHEME}://${MAVEN_REPOSITORY_HOST}:${MAVEN_REPOSITORY_PORT}${MAVEN_REPOSITORY_PATH}
#_______________________________ </CHS-MAVEN>
export MY_CH_API=$(cat ${HOME}/.ssh/my-api.txt)
#_______________________________ </CH_KEY_API>


#SETTINGS for GO
export GO_BIN="$HOME/go"           # I define this where I copy the GO_SOURCE/bin binaries
export GO_SOURCE="$HOME/go.src"    # I define this to where I clone the GO source repo
export PATH="$PATH:$GO_BIN:$GO_SOURCE/bin"
#echo "----------2---------------- $PATH"

#SETTINGS for GROOVY
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export PATH="$PATH:$GROOVY_HOME/bin"

#SETTINGS for PERLBREW
export PATH="$PATH:${HOME}/perl5/perlbrew/bin"
#echo "----------3---------------- $PATH"

##################################################################################


           # OLD ORACLE CLIENT 11.2
           # export ORACLE_HOME=/usr/lib/oracle/11.2/client64
           # export LD_LIBRARY_PATH=$ORACLE_HOME
           # export DYLD_LIBRARY_PATH=$ORACLE_HOME
           # export PATH=$ORACLE_HOME:$ORACLE_HOME/instantclient_12_1:$PATH
           # export NLS_NAMES=AMERICAN_AMERICA.UTF8
           # export TNS_ADMIN=$ORACLE_HOME

# OLD ORACLE CLIENT 12.2
export ORACLE_HOME=${HOME}/ORACLE_CLIENT_12_2/instantclient_12_2
export LD_LIBRARY_PATH=$ORACLE_HOME
export DYLD_LIBRARY_PATH=$ORACLE_HOME
export PATH=$ORACLE_HOME:$PATH
#echo "----------5---------------- $PATH"
export NLS_NAMES=AMERICAN_AMERICA.UTF8
export TNS_ADMIN=$ORACLE_HOME

##
# Your previous /Users/sbasile/.bash_profile file was backed up as /Users/sbasile/.bash_profile.macports-saved_2015-05-01_at_13:44:01
##

# MacPorts Installer addition on 2015-05-01_at_13:44:01: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
#echo "----------6---------------- $PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#_______________________________ <VAGRANT>

#TUX_SERVER=catwoman
#TUX_SERVER=elmo
#TUX_SERVER=gonzo
#TUX_SERVER=fozzie
#TUX_SERVER=gonzo <--- was ok on 23 Feb 2018
#TUX_SERVER=kermit   # change 1/KKK
TUX_SERVER=waldorf
#TUX_SERVER=statler

#export CHL_HOME="${HOME}/dev/CHLegacy"   # where I want to checkout the codebase
#export CHL_HOME="${CHS_HOME}"
export CHL_HOME="${HOME}/CHL"

export CHL_EWF_DATABASE=ewfdevstb          # my personal EWF DB
export CHL_XMLGW_DATABASE=xmldevstb        # my personal XML DB
#export CHL_BCD_DATABASE=bcddevsb         # my personal BCD DB

export CHL_E2E_NGSRV_HOST="tux.$TUX_SERVER.orctel.internal"  # my scrum E2E tux instance
export CHL_E2E_NGSRV_BASE_PORT=4050

export CHL_E2E_BARCODE_URL=http://enva.ch.gov.uk:9001    # my scrum E2E barcode instance


#________________________ <new settings for CHL>

export CHL_BCD_DATABASE=bcddevstb         # my personal BCD DB
#export CHL_CHD_DATABASE=gonzochd
#export CHL_CHD_DATABASE=statlerchd
#export CHL_CHD_DATABASE=waldorfchd
#export CHL_CHD_DATABASE=fozziechd
#export CHL_CHD_DATABASE=kermitchd    # change 2/KKK
export CHL_CHD_DATABASE=waldorfchd
export CHL_CHCC_DATABASE=chccdevstb
export CHL_CHDATA_DATABASE=chdatadevstb

#CAPDEVSTB1
#CAPDEVSTB2

#________________________ </new settings for CHL>



# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
PATH=" /usr/local/Cellar/python/3.7.5/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
#echo "----------7---------------- $PATH"

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
#echo "----------8---------------- $PATH"


#------------- MODULE WHICH CANNOT UPDATE MAC ONES:
# <module-XXX>  is keg-only, which means it was not symlinked into /usr/local
# because macOS already provides this software and installing another version in
# parallel can cause all kinds of trouble.
# following settings make the more up-to-dated version found first
#------------- SET FOR CURL
PATH="/usr/local/opt/curl/bin:$PATH"

#------------- SET FOR OPENSSL-libressl
#PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
PATH="/usr/local/opt/openssl/bin:$PATH"

#------------- SET FOR AWS CLI (installed locally with pip3 install awscli --upgrade --user
#PATH="$PATH:${HOME}/Library/Python/3.7/bin"
#PATH="/usr/local/opt/python/libexec/bin:$PATH"




#echo "----------8---------------- $PATH"
PATH="${HOME}/auto_ssh":$PATH

export PATH


#export AUTO_SSH_CONFIG_MP=U2FsdGVkX19en7cv1Mv/0E1xaFgM4lvLt1Hg+o69Le8=       openssl 1.1.0
export AUTO_SSH_CONFIG_MP=U2FsdGVkX194+LgmFDgz+0l1ttFDdfzCl6XYyyG/U4w=

#______________________________________ PYTHON SETTINGS (virtualenv / virtualenvwrapper )
#source /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/PYTHON_ENVS
#workon aws-cli-on.python.3

export CURL_HJ='"Content-Type: text/xml"'
export CURL_HX='"Content-Type: application/json"'


# TUX STUFF
export FESS_REPO_DIR="${HOME}/SUP/fes-administration-scripts"
export TUX_SHUTTLES_DIR="${FESS_REPO_DIR}/TUX_STUFF/shuttles"

# slack curl
export FESS_SLACK_TOKEN=$(cat "$HOME/.slack/FESS_SLACK_WEBHOOK")
export FESS_SLACK_WEBHOOK=$(cat "$HOME/.slack/FESS_SLACK_TOKEN")

#GITHUB / SETTINGS for ACCESSING PUBLIC API ON GITHUB (a token avoids passwords need)
export HOMEBREW_GITHUB_API_TOKEN=$(cat ${HOME}/GIT_CREDENTIALS/GIT_TOKEN_RW.REPO_RW.HOOKS)


# RUST (PACKAGE MANAGER: CARGO)
export PATH="$HOME/.cargo/bin:$PATH"

export FESS_AUTH_MESOS_TOKEN='c2Jhc2lsZTpDb21lbnQuMTIz'      # get this value as: $(printf 'user:password' | base64)

export GROOVY_HOME=/usr/local/opt/groovy/libexec    # as advised by brew upgrade
