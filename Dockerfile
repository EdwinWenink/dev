FROM --platform=$BUILDPLATFORM ubuntu
MAINTAINER Edwin Wenink <edwinwenink@hotmail.com>

# Installing packages
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    gnupg \
    build-essential \
    stow \
    git \
    vim \
    curl \
    cmake \
    wget \
    sudo \
    ssh \
    #openssh-server \
    python-setuptools \
    python3-pip \
    python3.11 \
    python-is-python3 \
    less \
    ca-certificates \
    zip \
    unzip \
    tmux \
    zsh

RUN git clone https://github.com/EdwinWenink/vimfiles ~/.vim
RUN git clone https://github.com/EdwinWenink/.dotfiles ~/.dotfiles
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN cd ~/.dotfiles/ && stow tmux

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# RUN pip install pynvim

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ENV ZSH_THEME agnoster
COPY zshrc .zshrc

USER root
WORKDIR /root
VOLUME ["/home/devpc"]

EXPOSE 5173

# ENTRYPOINT /bin/sh
CMD ["zsh"]
