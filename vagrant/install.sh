#!/bin/bash

# prepare /opt
mkdir /opt
mkdir /opt/bin

# extract the jre
mkdir /opt/java
cat openjdk.tar.xz | xz -d | tar x -C /opt/java/
rm openjdk.tar.xz
ln -s /opt/java/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /opt/bin/java 

# setup btrbck
mkdir /opt/btrbck
mv btrbck.jar /opt/btrbck

# add btrbck launcher
cat > /opt/bin/btrbck <<EOF
#!/bin/bash
/opt/bin/java -jar /opt/btrbck/btrbck.jar \$@
EOF
chmod 755 /opt/bin/btrbck

# setup disk
if [ ! -e /dev/sdb1 ]; then
  parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 1 -1
  mkfs.btrfs /dev/sdb1
fi

# add systemd unit to mount the /data partition
cat > /etc/systemd/system/data.mount <<EOF
[Unit]
Description=Mount for data disk
Before=docker.service

[Mount]
What=/dev/sdb1
Where=/data
Type=btrfs

[Install]
WantedBy=multi-user.target 
EOF
systemctl enable data.mount
systemctl start data.mount


# setup btrbck repo
if [ ! -e /data/.backup ]; then
  btrbck -r /data create -a
fi

# automatically trigger backup
cat > /etc/systemd/system/backup.service <<EOF
[Unit]
Description=perform a btrbck process on /data
After=data.mount

[Service]
Type=simple
ExecStart=/opt/bin/btrbck -r /data process -sudoRemoteBtrbck
EOF

cat > /etc/systemd/system/backup.timer <<EOF
[Unit]
Description=timer triggering a btrbck process on /data

[Timer]
OnCalendar=*-*-* *:*:00

[Install]
WantedBy=multi-user.target
EOF

systemctl enable backup.timer
