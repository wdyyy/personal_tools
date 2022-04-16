#! /bin/bash
# FileName     : init_system
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2022-04-11 10:36
# Last Modified: 2022-04-16 18:04
# Modified By  : EastsunW
# -------------
# Description  :
# -------------

set -e

# -------------------- 设置镜像源 -------------------- #

echo "# -------------------- 设置阿里云的apt镜像源 -------------------- #"
echo "" | sudo tee /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

sudo apt autoremove -y
sudo apt update && sudo apt upgrade -y

# -------------------- 配置GIT -------------------- #

# 用户名
git config --global user.name EastsunW
# 邮箱
git config --global user.email eastsunw@foxmail.com
# 储存密码
git config --global credential.helper store

# -------------------- 安装ZSH和ohmyzsh -------------------- #

# sudo apt install -y zsh

if [ -e $HOME/.oh-my-zsh ]; then
    rm -rf $HOME/.oh-my-zsh
fi
echo "待会儿的选项会让你选择是否设置zsh为默认终端, 直接回车, 然后会进入zsh终端, 此时复制下面的脚本并运行:"
echo "echo \"source \${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\" >> \${ZDOTDIR:-\$HOME}/.zshrc"
echo "最后输入exit并按回车来继续本脚本的安装"
while true; do
    read -r -p "明白了没? [Y/n] " input
    case $input in
        y*|Y*|"")
            break
        ;;
        n*|N*)
            echo "必须明白, 不然就多看几次!"
            continue
        ;;
        *)
            echo "只能输入Y和N, 傻逼!"
        ;;
    esac
done

bash -c "$(wget -O- https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh \
    | sed 's|^REPO=.*|REPO=${REPO:-mirrors/oh-my-zsh}|g' \
    | sed 's|^REMOTE=.*|REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}|g')"

if [ -e ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    rm -rf ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
git clone https://gitee.com/gulei666/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "" > ${HOME}/.zshrc
echo "export ZSH=\"${HOME}/.oh-my-zsh\"" >> ${HOME}/.zshrc
echo "ZSH_THEME=\"sorin\"" >> ${HOME}/.zshrc
echo "DISABLE_MAGIC_FUNCTIONS=\"true\"" >> ${HOME}/.zshrc
echo "plugins=(git extract zsh-syntax-highlighting)" >> ${HOME}/.zshrc
echo "source $ZSH/oh-my-zsh.sh" >> ${HOME}/.zshrc
echo "# Paths" >> ${HOME}/.zshrc
echo "# export Rpath=\"/opt/R-3.6.3/bin\"" >> ${HOME}/.zshrc
echo "# export PATH=$PATH:$Rpath" >> ${HOME}/.zshrc
echo "# Alias" >> ${HOME}/.zshrc
echo "alias R=\"R -q\"" >> ${HOME}/.zshrc
echo "# >>> conda initialize >>>" >> ${HOME}/.zshrc
echo "# !! Contents within this block are managed by 'conda init' !!" >> ${HOME}/.zshrc
echo "__conda_setup=\"$('${HOME}/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)\"" >> ${HOME}/.zshrc
echo "if [ $? -eq 0 ]; then" >> ${HOME}/.zshrc
echo "    eval \"$__conda_setup\"" >> ${HOME}/.zshrc
echo "else" >> ${HOME}/.zshrc
echo "    if [ -f \"${HOME}/miniconda3/etc/profile.d/conda.sh\" ]; then" >> ${HOME}/.zshrc
echo "        . \"${HOME}/miniconda3/etc/profile.d/conda.sh\"" >> ${HOME}/.zshrc
echo "    else" >> ${HOME}/.zshrc
echo "        export PATH=\"${HOME}/miniconda3/bin:$PATH\"" >> ${HOME}/.zshrc
echo "    fi" >> ${HOME}/.zshrc
echo "fi" >> ${HOME}/.zshrc
echo "unset __conda_setup" >> ${HOME}/.zshrc

# -------------------- 安装CONDA -------------------- #

echo "# -------------------- 安装CONDA -------------------- #"
echo "待会儿的选项会安装CONDA, 安装完了后会问你要不要初始化CONDA, 选否, 然后运行下面的代码:"
echo "${HOME}/miniconda3/condabin/conda init zsh"
while true; do
    read -r -p "明白了没? [Y/n] " input
    case $input in
        y*|Y*|"")
            break
        ;;
        n*|N*)
            echo "必须明白, 不然就多看几次!"
            continue
        ;;
        *)
            echo "只能输入Y和N, 傻逼!"
        ;;
    esac
done
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${HOME}/install_conda.sh && bash ${HOME}/install_conda.sh

echo "auto_activate_base: false" >> ${HOME}/.condarc
echo "channels:" >> ${HOME}/.condarc
echo "  - defaults" >> ${HOME}/.condarc
echo "show_channel_urls: true" >> ${HOME}/.condarc
echo "channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda" >> ${HOME}/.condarc
echo "default_channels:" >> ${HOME}/.condarc
echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main" >> ${HOME}/.condarc
echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free" >> ${HOME}/.condarc
echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r" >> ${HOME}/.condarc
echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro" >> ${HOME}/.condarc
echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2" >> ${HOME}/.condarc
echo "custom_channels:" >> ${HOME}/.condarc
echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/" >> ${HOME}/.condarccloud
echo "  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ${HOME}/.condarc
echo "  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/" >> ${HOME}/.condarccloud
echo "  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ${HOME}/.condarc
echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/" >> ${HOME}/.condarccloud
echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/" >> ${HOME}/.condarccloud
echo "CONDA的镜像源已经设置为清华大学镜像源"
