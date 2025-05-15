FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean

# Create user
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Enable remote control in web terminal
RUN echo "set -g tmate-allow-remote-control on" > /home/dockeruser/.tmate.conf

# Launch tmate in foreground so web session is interactive
CMD ["tmate", "-F"]
