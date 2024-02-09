FROM --platform=$BUILDPLATFORM ubuntu:latest
MAINTAINER Edwin Wenink <edwinwenink@hotmail.com>

# Refresh packages
RUN apt-get update -y

# Layer installing the essentials
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    locales \
    locales-all \
    gnupg \
    build-essential \
    curl \
    wget \
    sudo \
    ssh \
    cmake \
    git \
    less \
    ca-certificates \
    zip \
    unzip

# Personalized installs: Python 3.11 with deps for PostgresQL
# Editor: Zsh + Tmux + Vim
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    stow \
    vim \
    #openssh-server \
    python-setuptools \
    python3-pip \
    python3.11 \
    python3.11-dev \
    python-is-python3 \
    tmux \
    zsh \
    libpq-dev

# Set locale
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Set our installed version as the default Python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Download personal dotfiles
RUN git clone https://github.com/EdwinWenink/vimfiles ~/.vim
RUN git clone https://github.com/EdwinWenink/.dotfiles ~/.dotfiles
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN cd ~/.dotfiles/ && stow tmux

# Configure Git
RUN git config --global user.name "Edwin Wenink"
RUN git config --global user.email "edwinwenink@hotmail.com"
RUN git config --global credential.helper 'store --file /root/dev/.my-credentials'

# Install Vim plugins
RUN vim +PlugInstall +qall

# Install Python requirements with pip
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Personalized ZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ENV ZSH_THEME agnoster
# Or: RUN cd ~/.dotfiles/ && stow zsh
COPY zshrc .zshrc

USER root
WORKDIR /root/dev
VOLUME ["/root/dev"]

EXPOSE 5173

# ENTRYPOINT /bin/sh
CMD ["zsh"]
