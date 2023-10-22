[Unit]
Description=etcd service
After=init-nerdctl.service
Requires=network-online.target

[Service]
Environment="PATH=/opt/bin:/opt/etcd/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
EnvironmentFile=/etc/etcd/config.env
ExecStartPre=-/opt/bin/nerdctl rm -f etcd
ExecStart=/opt/etcd/bin/etcd-wrapper
ExecStop=-/opt/bin/nerdctl stop etcd

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target