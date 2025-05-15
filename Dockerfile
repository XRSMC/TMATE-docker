FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean

# Create non-root user
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Enable typing via web terminal
RUN echo "set -g tmate-allow-remote-control on" > /home/dockeruser/.tmate.conf

# Launch tmate and print web + ssh links
CMD ["/bin/bash", "-c", "\
tmate -S /tmp/tmate.sock new-session -d && \
tmate -S /tmp/tmate.sock wait tmate-ready && \
echo '[+] tmate web (browser) access:' && \
tmate -S /tmp/tmate.sock display -p '#{tmate_web}' && \
echo '[+] tmate ssh access (optional):' && \
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' && \
tail -f /dev/null"]
