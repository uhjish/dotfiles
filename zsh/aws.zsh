_homebrew-installed() {
    type brew &> /dev/null
}

_awscli-homebrew-installed() {
    brew list awscli &> /dev/null
}

export AWS_HOME=~/.aws

function agp {
    echo $AWS_DEFAULT_PROFILE
}

function asp {
    local rprompt=${RPROMPT/<aws:$(agp)>/}

    export AWS_DEFAULT_PROFILE=$1
    export AWS_PROFILE=$1

    export RPROMPT="<aws:$AWS_DEFAULT_PROFILE>$rprompt"
}

function aws_profiles {
    reply=($(grep profile $AWS_HOME/config|sed -e 's/.*profile \([a-zA-Z0-9_-]*\).*/\1/'))
}

# compctl -K aws_profiles asp
source /usr/local/share/zsh/site-functions/_aws

if _homebrew-installed && _awscli-homebrew-installed ; then
    _aws_zsh_completer_path=$(brew --prefix awscli)/libexec/bin/aws_zsh_completer.sh
else
    _aws_zsh_completer_path=$(which aws_zsh_completer.sh)
fi

[ -x $_aws_zsh_completer_path ] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path

function sync_dir () {
    DIR=$1
    BUCKET=$2

    CMD="s3cmd sync '$DIR' --reduced-redundancy --preserve --continue-put --human-readable-sizes --progress --skip-existing '$BUCKET'"

    echo "Executing command:\n\t$CMD"
    eval $CMD
}

function sync_file () {
    FILE=$1
    BUCKET=$2
    PREFIX=${3:-backups}

    CMD="s3cmd put '$DIR' --reduced-redundancy --preserve --progress '$BUCKET/$PREFIX'"

    echo "Executing command:\n\t$CMD"
    eval $CMD
}

function sync_photos() {
    sync_dir "/Users/auser/Dropbox/Camera Uploads" "s3://a_personal/PhotoBackup/"
}
