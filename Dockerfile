FROM ubuntu:22.04

# Install ttyd and dependencies
RUN apt-get update && \
    apt-get install -y wget curl build-essential cmake git libjson-c-dev libwebsockets-dev libssl-dev zlib1g-dev && \
    git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    apt-get remove -y build-essential cmake git && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Expose port 6080 for Railway
EXPOSE 6080

# Start ttyd on port 6080 with bash shell
CMD ["ttyd", "-p", "6080", "bash"]
