FROM ubuntu:22.04

# Install tmate and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tmate openssh-client curl ca-certificates && \
    apt-get clean

# Create a non-root user (optional)
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Write the start script
RUN echo '#!/bin/bash\n\
echo "[+] Starting tmate session..."\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait tmate-ready\n\
echo ""\n\
echo "[+] tmate session is ready:"\n\
echo "Web: $(tmate -S /tmp/tmate.sock display -p \"#{tmate_web}\")"\n\
echo "SSH: $(tmate -S /tmp/tmate.sock display -p \"#{tmate_ssh}\")"\n\
echo ""\n\
echo "[*] Container will stay alive. Use the SSH or web session to connect."\n\
tail -f /dev/null' > start.sh && chmod +x start.sh

CMD ["bash", "start.sh"]
