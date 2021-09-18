FROM skysider/pwndocker


WORKDIR /opt
RUN  apt-get install -y qemu-user && rm -rf /var/lib/apt/lists/*
