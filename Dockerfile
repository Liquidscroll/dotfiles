FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm bats shellcheck git jq sudo \
    && pacman -Scc --noconfirm

WORKDIR /dotfiles
COPY . /dotfiles

CMD ["bats", "tests"]
