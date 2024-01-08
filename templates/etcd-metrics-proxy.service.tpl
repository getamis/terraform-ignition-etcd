[Unit]
Description=etcd-metrics-proxy service
Requires=network-online.target

[Service]
Environment="PATH=/opt/bin:/opt/etcd/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
EnvironmentFile=/etc/etcd/config.env
ExecStartPre=-/usr/bin/docker rm -f etcd-metrics-proxy
ExecStart=/opt/etcd/bin/etcd-metrics-proxy-wrapper
ExecStop=-/usr/bin/docker stop etcd-metrics-proxy

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target