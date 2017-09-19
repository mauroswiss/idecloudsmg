#                                                                   ____                                                               
#  .--.--.                                                        ,'  , `.                                                     ,--,    
# /  /    '.                 ,--,                              ,-+-,.' _ |               ,---,  ,--,                         ,--.'|    
#|  :  /`. /          .---.,--.'|                           ,-+-. ;   , ||             ,---.'|,--.'|                         |  | :    
#;  |  |--`          /. ./||  |,      .--.--.    .--.--.   ,--.'|'   |  ;|             |   | :|  |,                          :  : '    
#|  :  ;_         .-'-. ' |`--'_     /  /    '  /  /    ' |   |  ,', |  ':  ,---.      |   | |`--'_       ,---.     ,--.--.  |  ' |    
# \  \    `.     /___/ \: |,' ,'|   |  :  /`./ |  :  /`./ |   | /  | |  || /     \   ,--.__| |,' ,'|     /     \   /       \ '  | |    
#  `----.   \ .-'.. '   ' .'  | |   |  :  ;_   |  :  ;_   '   | :  | :  |,/    /  | /   ,'   |'  | |    /    / '  .--.  .-. ||  | :    
#  __ \  \  |/___/ \:     '|  | :    \  \    `. \  \    `.;   . |  ; |--'.    ' / |.   '  /  ||  | :   .    ' /    \__\/: . .'  : |__  
# /  /`--'  /.   \  ' .\   '  : |__   `----.   \ `----.   \   : |  | ,   '   ;   /|'   ; |:  |'  : |__ '   ; :__   ," .--.; ||  | '.'| 
#'--'.     /  \   \   ' \ ||  | '.'| /  /`--'  //  /`--'  /   : '  |/    '   |  / ||   | '/  '|  | '.'|'   | '.'| /  /  ,.  |;  :    ; 
#  `--'---'    \   \  |--" ;  :    ;'--'.     /'--'.     /;   | |`-'     |   :    ||   :    :|;  :    ;|   :    :;  :   .'   \  ,   /  
#               \   \ |    |  ,   /   `--'---'   `--'---' |   ;/          \   \  /  \   \  /  |  ,   /  \   \  / |  ,     .-./---`-'   
#                '---"      ---`-'                        '---'            `----'    `----'    ---`-'    `----'   `--`---'          


# Pull base image.
FROM ubuntu:latest
MAINTAINER Mauro Novillo <maurohernan.novillo@swissmedical.com.ar>

RRUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev tmux python-setuptools zsh wget git-core htop vim
RUN chsh -s /usr/bin/zsh root


# ------------------------------------------------------------------------------
# Install NPM 
# ------------------------------------------------------------------------------
# Install Node.js
RUN apt-get install -y nodejs-legacy nodejs npm   
# ------------------------------------------------------------------------------

# Install NVM
RUN git clone https://github.com/creationix/nvm.git /.nvm
RUN echo ". /.nvm/nvm.sh" >> /etc/bash.bashrc
RUN /bin/bash -c '. /.nvm/nvm.sh && \
    nvm install v0.12.6 && \
    nvm use v0.12.6 && \
    nvm alias default v0.12.6'

# ------------------------------------------------------------------------------
# Install Cloud9SDK
RUN git clone https://github.com/c9/core/ /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh

ADD conf/standalone.js /c9sdk/configs/

ADD conf/master/standalone.js /c9sdk/settings/

ADD conf/plugins/c9.vfs.standalone/standalone.js /c9sdk/plugins/c9.vfs.standalone/

RUN sed -i -e "s/127.0.0.1/0.0.0.0/g" /c9sdk/configs/standalone.js

# ------------------------------------------------------------------------------
# Install Meteor, PhantomJS and forever
RUN curl https://install.meteor.com/ | sh
RUN npm install -g phantomjs-prebuilt forever

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# ------------------------------------------------------------------------------
#Start
CMD ["sh", "-c", "forever /c9sdk/server.js ${C9_PARAMS} --auth ${C9_USER}:${C9_PASSWORD} --listen ${IP} -w /workspace"]
