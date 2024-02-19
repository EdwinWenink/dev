FROM --platform=$BUILDPLATFORM ubuntu:latest
MAINTAINER Edwin Wenink <edwinwenink@hotmail.com>

# Refresh packages
RUN apt-get update -y

# Layer installing the essentials
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    locales \
    locales-all \
    gnupg \
    software-properties-common \
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
    unzip \
    htop

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

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update -y
RUN apt-get install terraform

# Install Terraform linter
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Personalized ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN rm ~/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN cd ~/.dotfiles/ && stow zsh

# Pre-commit config
COPY .pre-commit-config.yaml .pre-commit-config.yaml

USER root
WORKDIR /root/dev
VOLUME ["/root/dev"]

EXPOSE 8000

CMD ["zsh"]
