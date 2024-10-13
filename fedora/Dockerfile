FROM fedora:38

ENV ASDF_DIR=/root/.asdf
ENV PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

RUN dnf install -y git \
                   curl \
                   make \
                   gcc \
                   vim \
                   openssl-devel \
                   zlib-devel \
                   libffi-devel \
                   readline-devel \
                   libyaml-devel \
                   ninja-build \
                   cmake \
                   unzip \
                   gettext \
                   glibc-gconv-extra \
                   tmux \
                   && dnf groupinstall -y "Development Tools" "Development Libraries"

# asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1 && \
    echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc && \
    echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
RUN asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && \
    asdf plugin add golang https://github.com/kennyp/asdf-golang.git && \
    asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
RUN asdf install nodejs latest && \
    asdf global nodejs latest && \
    asdf install ruby latest && \
    asdf global ruby latest && \
    asdf install golang latest && \
    asdf global golang latest && \
    asdf install rust latest && \
    asdf global rust latest

# neoVim
WORKDIR /root/neovim
RUN git clone https://github.com/neovim/neovim.git . && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install

CMD ["/bin/bash"]
