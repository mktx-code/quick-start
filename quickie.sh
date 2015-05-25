#!/bin/bash
BLUE="\033[0;34m"
RED="\033[0;31m"
END="\033[0m"
set -e
SSH_CONF=/etc/ssh/sshd_config
mv $SSH_CONF /etc/ssh/sshd_config.bak
touch $SSH_CONF
echo -e "$BLUE""Please select the new port for ssh (default is 22).\nIt should be a number that is 5 digits.""$END"
  echo -e "$RED"
  read SSH_PORT
  echo -e "$END"
      if [[ $SSH_PORT -ge 1 || $SSH_PORT -le 99999 ]]; then
          echo -e "\nPort $SSH_PORT\n" > $SSH_CONF
      else
          echo -e $RED"THAT WAS NOT AN ACCEPTABLE PORT!!!! RE-RUN THE SCRIPT AND PUT SOMETHING SENSIBLE HERE BEFORE YOU LOCK YOURSELF OUT!!"$END
          exit 0
      fi
echo -e "$BLUE""Do you want to add an ssh key? (Y/no)""$END"
  echo -e "$RED"
  read HAVE_KEY
  echo -e "$END"
    if [[ $HAVE_KEY = no ]]; then
        sleep 1
    else
        echo -e "$BLUE""Please paste your public key (beginning with ssh-rsa).""$END"
          echo -e "$RED"
          read SSH_KEY
          echo -e "$END"
            if [[ -e /"$USER"/.ssh ]]; then
                echo -e "\n$SSH_KEY" >> /$USER/.ssh/authorized_keys
            else
                mkdir /$USER/.ssh/
                echo -e "$SSH_KEY" > /$USER/.ssh/authorized_keys
            fi
    fi
echo -e "\nProtocol 2\n\nHostKey /etc/ssh/ssh_host_rsa_key\n\nHostKey /etc/ssh/ssh_host_dsa_key\n\nHostKey /etc/ssh/ssh_host_ecdsa_key\n\nHostKey /etc/ssh/ssh_host_ed25519_key\n\nUsePrivilegeSeparation yes\n\nKeyRegenerationInterval 3600\n\nServerKeyBits 1024\n\nSyslogFacility AUTH\n\nLogLevel INFO\n\nLoginGraceTime 120\n\nPermitRootLogin yes\n\nStrictModes yes\n\nRSAAuthentication yes\n\nPubkeyAuthentication yes\n\nAuthorizedKeysFile /root/.ssh/authorized_keys\n\nIgnoreRhosts yes\n\nRhostsRSAAuthentication no\n\nHostbasedAuthentication no\n\nPermitEmptyPasswords no\n\nChallengeResponseAuthentication no\n\nPasswordAuthentication no\n\nKerberosAuthentication no\n\nGSSAPIAuthentication no\n\nX11Forwarding yes\n\nX11DisplayOffset 10\n\nPrintMotd no\n\nPrintLastLog yes\n\nTCPKeepAlive yes\n\nAcceptEnv LANG LC_*\n\nSubsystem sftp /usr/lib/openssh/sftp-server\n\nCiphers aes256-ctr,aes256-cbc,aes128-ctr,aes128-cbc,3des-cbc\n\nUsePAM no" >> "$SSH_CONF""
mv $SSH_CONF /root/temp.sshconf
sed '/^$/d' /root/temp.sshconf > $SSH_CONF
rm -f /root/temp.sshconf
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/*
service ssh restart
echo -e "$RED"
cat /etc/ssh/sshd_config
echo -e "$END"
echo -e "$BLUE""\nPress enter.""$END"
  read
apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
apt-get install ntp ntpdate sudo screen git haveged curl atop pwgen secure-delete lvm2 cryptsetup -y
service ntp stop
ntpdate 0.europe.pool.ntp.org
service ntp start
echo -e "\nhardstatus on\nhardstatus alwayslastline\n$(echo 'hardstatus string "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y} %m/%d %C%a "')\n" >> /etc/screenrc
exit 0
