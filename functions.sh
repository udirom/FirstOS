function get-github-latest-release-path {
    echo $(wget -q https://github.com/$1/$2/releases -O - | egrep "$3" | head -n 1 | cut -d '"' -f 2)
}

function install-github-release-deb {
    local release_path=$(get-github-latest-release-path $1 $2 $3)
    local release_file=${release_path##*/}
    local temp_deb_folder=$(mktemp -d)
    local the_deb="$temp_deb_folder/pkg.deb"

    echo "Downloading https://github.com/$release_path"
    wget -O $the_deb "https://github.com/$release_path" &>/dev/null
    echo "Installing $release_file"
    sudo apt install $the_deb -y -qq &>/dev/null
    sudo rm -Rf $temp_deb_folder
}

function install-github-release-deb-if-missing {
# $1 - test commnad to check if missing
# $2 - github user
# $3 - github repo
# $4 - release file regex
if ! command -v $1 &> /dev/null
then
	install-github-release-deb $2 $3 $4
else
    echo "$1 already installed"
fi
}