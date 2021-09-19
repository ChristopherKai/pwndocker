FROM skysider/pwndocker
USER root
COPY entrypoint.sh /opt
WORKDIR /opt
RUN  apt-get update && apt-get install -y qemu-user  \
    qemu-user-static\
    binutils-aarch64-linux-gnu \
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
    git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install


EXPOSE 22
ENTRYPOINT [ "/opt/entrypoint.sh" ]