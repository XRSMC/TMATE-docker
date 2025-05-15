FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Enable typing in the browser (remote control)
RUN echo "set -g tmate-allow-remote-control on" > /home/dockeruser/.tmate.conf

# Start tmate session, print web + SSH links
CMD ["/bin/bash", "-c", "\
tmate -S /tmp/tmate.sock new-session -d && \
tmate -S /tmp/tmate.sock wait tmate-ready && \
echo '[+] Web (browser) access:' && \
tmate -S /tmp/tmate.sock display -p '#{tmate_web}' && \
echo '[+] SSH access (optional):' && \
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' && \
tail -f /dev/null"]
