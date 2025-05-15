FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean

# Create a non-root user (optional, safer)
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Create start script
RUN echo '#!/bin/bash
echo "[+] Starting tmate session..."
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready
echo ""
echo "[+] tmate session is ready:"
echo "Web: $(tmate -S /tmp/tmate.sock display -p "#{tmate_web}")"
echo "SSH: $(tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}")"
echo ""
echo "[*] Container will stay alive. Use the SSH or web session to connect."
tail -f /dev/null' > start.sh && chmod +x start.sh

# Start the tmate session
CMD ["bash", "start.sh"]
