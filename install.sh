#!/bin/bash

# 1. Copy folder ke /root
echo "[+] Copying folder to /root/cctvrb..."
mkdir -p /root/cctvrb
cp -r ./cctvrb/* /root/cctvrb/
chmod +x /root/cctvrb/cctvrb

# 2. Buat systemd service
echo "[+] Creating systemd service..."
cat <<EOF > /etc/systemd/system/cctvrb.service
[Unit]
Description=Start CCTV script on boot
After=network.target

[Service]
ExecStart=/root/cctvrb/cctvrb
WorkingDirectory=/root/cctvrb
StandardOutput=append:/var/log/cctvrb.log
StandardError=append:/var/log/cctvrb.log
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 3. Reload systemd, enable dan start
echo "[+] Enabling and starting service..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable cctvrb.service
systemctl start cctvrb.service

# 4. Selesai
echo "[✓] Done! Service installed and running."
systemctl status cctvrb.service --no-pager
