# Use Ubuntu as base
FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean

# Create non-root user for tmate session (optional)
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Create a startup script to auto-launch tmate
RUN echo '#!/bin/bash\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait tmate-ready\n\
tmate -S /tmp/tmate.sock display -p "Web: https://tmate.io/tmux/%26" > /tmp/link.txt\n\
tmate -S /tmp/tmate.sock display -p "SSH: %s" >> /tmp/link.txt\n\
cat /tmp/link.txt\n\
tail -f /dev/null' > start.sh && chmod +x start.sh

CMD ["bash", "start.sh"]
