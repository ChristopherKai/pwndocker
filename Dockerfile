FROM skysider/pwndocker
USER root
COPY entrypoint.sh /opt
WORKDIR /opt
RUN  apt-get update && apt-get install -y qemu-user  \
    qemu-user-static\
    # for aarch64 with debug symbol
    binutils-common=2.34-6ubuntu1.1\
    binutils-aarch64-linux-gnu\
    binutils-aarch64-linux-gnu-dbg \
    # aarch64 
    gcc-aarch64-linux-gnu\
    g++-aarch64-linux-gnu\
    libc6-dbg-arm64-cross\
    # for arm
    binutils-arm-linux-gnueabi-dbg \
    binutils-arm-linux-gnueabi\
    # mips 32 little ending
    gcc-mipsel-linux-gnu \
    g++-mipsel-linux-gnu \
    # mips 32 bit ending 
    gcc-mips-linux-gnu \ 
    g++-mips-linux-gnu \
    # mips 64 bit little ending
    gcc-mips64el-linux-gnuabi64\
    g++-mips64el-linux-gnuabi64 \
    # mips 64 bit big ending
    gcc-mips64-linux-gnuabi64\
    g++-mips64-linux-gnuabi64\ 
    && rm -rf /var/lib/apt/lists/*

RUN sed -i "s|#PermitRootLogin yes|PermitRootLogin yes|g"  /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && chmod +x /opt/entrypoint.sh &&\
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    # config pwndbg 
    locale-gen en_US.UTF-8 && \
    printf "set context-code-lines 5\nset context-sections regs disasm code ghidra stack  expressions" >>/root/.gdbinit && \
    printf "\nexport LC_ALL=en_US.UTF-8\nexport PYTHONIOENCODING=UTF-8" >> /etc/profile &&\
    # coolpwn
    git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python3 setup.py install && cd - &&\
    # mytool
    git clone https://github.com/ChristopherKai/mytools.git && ln /opt/mytools/gentemplate/gentemplate.py /usr/local/bin/gentemplate &&\
    pip3 uninstall pwntools -y &&\
    pip3  --no-cache-dir  install formatStringExploiter pwntools==4.7.0beta0

# web misc tools
RUN git clone https://github.com/Rup0rt/pcapfix.git && cd pcapfix && make && make install && cd -\
    && git clone https://github.com/brendan-rius/c-jwt-cracker.git && cd c-jwt-cracker && make \
    && git clone https://github.com/offensive-security/exploit-database.git && ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit 
    

EXPOSE 22
ENTRYPOINT [ "/opt/entrypoint.sh" ]