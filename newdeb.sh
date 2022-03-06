#!/bin/bash

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_info()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }



prepare_server(){
    sudo apt update
    sudo apt upgrade -y
    sudo apt install git zsh vim curl wget fonts-powerline software-properties-common apt-transport-https ca-certificates -y
}

install_ohmyzsh(){
    #oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zdharma/fast-syntax-highlighting.git ~ZSH_CUSTOM/plugins/fast-syntax-highlighting
    
    #Fuzzy Finder
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
}

#vscode
install_vscode(){
    echo_info " ** Installing VSCode ** "
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code -y
}

#golang
install_golang() {
    echo_info " ** Installing GoLang ** "
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install golang-go -y
}

install_docker_ce() {
    echo_info " ** Installing Docker ** "
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" 
    sudo apt-get update
    sudo apt-get install docker-ce -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
}

install_dockercompose() {
    echo_info " ** Installing Docker Compose ** "
    if [[ -z $(which docker) ]]; then
        echo "Need To install Docker first "
    fi
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
    sudo chmod +x /usr/local/bin/docker-compose 
    sudo docker-compose --version 
}

install_typora() {
    echo_info " ** Installing Typora ** "
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    sudo add-apt-repository 'deb https://typora.io/linux ./'
    sudo apt-get update
    sudo apt-get install typora -y
}

install_node() {
    echo_info " ** Installing NodeJS 12 and npm node package manager ** "
    cd ;
    sudo apt install gcc g++ make -y
    mkdir ~/.npm-global
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
    sudo -v
    sudo apt update
    sudo apt install -y nodejs
    npm config set prefix "$HOME/.npm-global"
    echo "export PATH=$HOME/.npm-global/bin:$PATH" | tee -a $HOME/.profile
    source $HOME/.profile
    npm install npm@latest -g
}

#chrome
install_chrome(){
    echo_info " ** Installing Google Chrome ** "
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
}

while :
do    
echo ""
echo ""
echo_note "New DEB Instalation :"
echo ""
echo "[1] Prepare Server"
echo "[2] Install OH-MY-ZSH"
echo "[3] Install VSCode"
echo "[4] Install golang"
echo "[5] Install docker"
echo "[6] Install docker-compose"
echo "[7] Install Typora"
echo "[8] Install NodeJS"
echo "[9] Install Google Chrome"
echo "[18] Run All"
echo "[19] Exit"
echo ""
read choice

case $choice in
    1)
        prepare_server
        ;;
    2)
        install_ohmyzsh
	;;
    3)
        install_vscode
        ;;
    4)
        install_golang
        ;;
    5)
	install_docker_ce
        ;;
    6)
	install_dockercompose
        ;;
    7)
        install_typora
        ;;
    8)
        install_node
        ;;
    9)
	install_chrome
        ;;
    18)
        echo "Run All"
        prepare_server
        install_ohmyzsh
        install_vscode
        install_golang
	install_docker_ce
	install_dockercompose
        install_typora
        install_node
	install_chrome
        ;;
    19)
        exit
        ;;

esac
done
