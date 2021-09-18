FROM skysider/pwndocker


WORKDIR /opt
RUN  git clone https://gitlab.com/qemu-project/qemu.git --depth=1 && cd qemu && git submodule init && git submodule update --recursive && ./configure && make
