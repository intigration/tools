FROM opensuse/leap:15.4


SHELL ["/bin/bash", "-c"]

RUN zypper refresh \
    && zypper install --no-confirm \
        dbus-1 \
        kmod \
        polkit \
        openssh \
        systemd-sysvinit \
        sudo \
    ;

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;

RUN systemctl enable sshd \
    && ln -s /lib/systemd/system/systemd-user-sessions.service /etc/systemd/system/multi-user.target.wants/systemd-user-sessions.service \
    && chgrp polkitd /usr/share/polkit-1/rules.d \
    ;

RUN set -e \
    && sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers \
    ;

RUN set -e \
    && groupadd vagrant \
    && useradd --create-home -s /bin/bash -G vagrant vagrant \
    && echo -n 'vagrant:vagrant' | chpasswd \
    && echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant \
    ;

RUN set -e \
    && mkdir -p /home/vagrant/.ssh \
    && chmod 700 /home/vagrant/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > /home/vagrant/.ssh/authorized_keys \
    && chmod 600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant:vagrant /home/vagrant/.ssh \
    ;


EXPOSE 22
CMD ["/sbin/init"]
