[Unit]
Description=init nerdctl service
ConditionPathExists = !/opt/bin/init-configs.done
Requires=network-online.target

[Service]
Type=oneshot
RemainAfterExit=true

User=root
Group=root

Environment="PATH=/opt/bin:/opt/etcd/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
ExecStart=/opt/bin/init-nerdctl
ExecStartPost=/bin/touch /opt/bin/init-configs.done

[Install]
WantedBy=multi-user.target