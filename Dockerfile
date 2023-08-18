FROM ubuntu:22.04
RUN apt-get update
RUN apt-get -y install gnupg curl patch bzip2 gawk g++ gcc autoconf automake bison libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make patch pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN useradd -d /home/hosting -u 1001 -g root -s /bin/bash hosting
USER hosting
WORKDIR /home/hosting
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

RUN curl -sSL https://get.rvm.io | bash -s stable 
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
RUN /bin/bash -l -c "echo 'source ~/.rvm/scripts/rvm' >> ~/.bashrc"
RUN echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> ~/.bashrc
RUN /bin/bash -l -c "source ~/.bashrc"
RUN /bin/bash -l -c echo $PATH
RUN echo ""
RUN /bin/bash -l -c "rvm install ruby-3.2.1 -C --with-openssl-dir=/opt/local/libexec/openssli11"