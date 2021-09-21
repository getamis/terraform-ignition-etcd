[Unit]
Description=Mount ${data_path}
Before=local-fs.target

[Mount]
What=${device_name}
Where=${data_path}
Type=ext4
DirectoryMode=0700

[Install]
WantedBy=local-fs.target