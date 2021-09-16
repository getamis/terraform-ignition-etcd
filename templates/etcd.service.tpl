[Unit]
Description=etcd service
Wants=network-online.target network.target
After=network-online.target

[Service]
EnvironmentFile=/etc/etcd/config.env
ExecStartPre=-/usr/bin/podman rm -f etcd
ExecStart=/usr/local/bin/etcd-wrapper.sh
ExecStop=-/usr/bin/podman stop etcd

Restart=on-failure
RestartSec=10s
TimeoutStartSec=0
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target