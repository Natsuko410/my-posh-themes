#!/bin/bash
# ==============================================================================
# 	Author: Miromashi
# 	Github: https://github.com/Miromashi
# ==============================================================================

getVersion() {
	result=$(curl --silent https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest)
	version=${result##*/tag/}
	version=${version%%'">'*}

	echo $version
}

version=$(getVersion)

theme="my-clean-detailed"

#Define the theme to install, if no theme given then use the custom theme in .posh-themes
if [ ! -z $1 ]; then
	if [ ! -z $2 ]; then
		themeExist=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/$version/themes/$1.omp.json)

		if [ $themeExist -eq 200 ]; then
			theme=$1
		else
			echo "Theme $1 not found"
			exit 1
		fi
	else
		if [ -f ~/my-posh-themes/.posh-themes/$1.omp.json ]; then
			theme=$1
		else
			echo "Theme $1 not found"
			exit 1
		fi
	fi
fi

which oh-my-posh >/dev/null

if [ $? -eq 1 ]; then
	#Choose what kind of installation the user want to use
	echo "Do you want to install oh-my-posh with homebrew ? (y/n)"
	read homebrew

	if [ "$homebrew" == "y" ]; then
		echo "Installing oh-my-posh with homebrew"

		if brew ls --versions myformula 2>/dev/null; then
			# The package is installed which mean we can install oh-my-posh
			brew tap jandedobbeleer/oh-my-posh
			brew install oh-my-posh
		else
			# The package is not installed
			echo "Homebrew is not installed, installing it now to use this option"
			exit 1
		fi
	else
		echo "Installing oh-my-posh from the official repository"
		echo "Downloading Oh my posh"

		sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
		sudo chmod +x /usr/local/bin/oh-my-posh

		echo "Download Official Oh my posh themes"

		mkdir ~/.poshthemes
		wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
		unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
		chmod u+rw ~/.poshthemes/*.json
		rm ~/.poshthemes/themes.zip

	fi

else
	echo "Oh my posh is already installed"
fi

shell=""
while [[ $shell == "" ]]; do
	echo "What kind of shell do you want to use ?"
	echo "1) bash"
	echo "2) zsh"
	read shell_input
	case $shell_input in
	1)
		shell="bash"
		;;
	2)
		shell="zsh"
		;;
	*)
		clear
		;;
	esac
done

#! TEST TO DELETE !!!!!!!!!!!!!!
shell="test"
shellrc=$shell"rc"
result=$(grep -i "oh-my-posh --init --shell" ~/.$shellrc)

#if not install in the .$shellrc file
if [ -z $result ] 2>/dev/null; then
	if [ -z $2 ]; then
		path="$theme.omp.json"
		echo "TEST"
		echo $path
		echo "initializing oh-my-posh for $shell with themes $theme"
		echo """eval "$(oh-my-posh --init --shell $shell --config $path)"""" >>~/.$shellrc
	else
		echo "initializing oh-my-posh for $shell with the official themes $theme"
		echo """eval "$(oh-my-posh --init --shell $shell --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/$version/themes/$theme.omp.json)"""" >>~/.$shellrc

	fi

	echo "You can now reload / open a new terminal"
else
	# do nothing
	echo "oh-my-posh is already installed in your $shellrc"
fi
