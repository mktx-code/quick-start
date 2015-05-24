#!/bin/bash
set-e
SSH_CONF=/etc/ssh/sshd_config
mv $SSH_CONF /etc/ssh/sshd_config.bak
touch $SSH_CONF
echo -e $YLW"Please select the new port for ssh (default is 22).\nIt should be a number that is 5 digits."$END
  read SSH_PORT
      if [[ $SSH_PORT -ge 1 || $SSH_PORT -le 99999 ]]; then
          echo -e "\nPort $SSH_PORT\n" > $SSH_CONF
      else
          echo -e $RED"THAT WAS NOT AN ACCEPTABLE PORT!!!! RE-RUN THE SCRIPT AND PUT SOMETHING SENSIBLE HERE BEFORE YOU LOCK YOURSELF OUT!!"$END
          exit 0
      fi
echo -e $YLW"Do you want to add an ssh key? (Y/no)"$END
  read HAVE_KEY
    if [[ $HAVE_KEY = no ]]; then
        sleep 1
    else
        echo -e $YLW"Please paste your public key (beginning with ssh-rsa)."$END
          read SSH_KEY
            if [[ -e /"$USER"/.ssh ]]; then
                echo -e "$SSH_KEY" > /$USER/.ssh/authorized_keys
                echo -e $YLW"Your public key:$END\n$BLUE$(echo -e "$SSH_KEY")"$END
                echo -e $YLW"Has been added to$END $GRN/$USER/.ssh/authorized_keys$END"
                sleep 3
                echo -e $YLW"Would you like to turn off password authentication? (Y/no)"$END
                  read SSH_PASS_AUTH
                    if [[ $SSH_PASS_AUTH = no ]]; then
                        sleep 1
                    else
                        echo -e "\nPasswordAuthentication no\n" >> $SSH_CONF
                        echo -e "\nPubKeyAuthentication yes\n" >> $SSH_CONF
                        echo -e "\nAuthorizedKeysFile $USER/.ssh/authorized_keys\n" >> $SSH_CONF
                    fi
                echo -e $YLW"Permit root login only by ssh key? (Y/no)"$END
                  read SSH_ROOT_LOGIN
                    if [[ $SSH_ROOT_LOGIN = no ]]; then
                        sleep 1
                    else  
                        echo -e "\nPermitRootLogin without-password\n" >> $SSH_CONF
                    fi
            else
                mkdir /$USER/.ssh/
                echo -e "$SSH_KEY" > /$USER/.ssh/authorized_keys
                echo -e $YLW"Your public key:$END\n$BLUE$(echo -e "$SSH_KEY")"$END
                echo -e $YLW"Has been added to$END $GRN/$USER/.ssh/authorized_keys$END"
                sleep 3
                echo -e $YLW"Would you like to turn off password authentication? (Y/no)"$END
                  read SSH_PASS_AUTH
                    if [[ $SSH_PASS_AUTH = no ]]; then
                        sleep 1
                    else
                        echo -e "\nPasswordAuthentication no\n" >> $SSH_CONF
                        echo -e "\nPubKeyAuthentication yes\n" >> $SSH_CONF
                        echo -e "\nAuthorizedKeysFile $USER/.ssh/authorized_keys\n" >> $SSH_CONF
                    fi
                echo -e $YLW"Permit root login only by ssh key? (Y/no)"$END
                  read SSH_ROOT_LOGIN
                    if [[ $SSH_ROOT_LOGIN = no ]]; then
                        sleep 1
                    else  
                        echo -e "\nPermitRootLogin without-password\n" >> $SSH_CONF
                    fi
            fi
    fi
echo -e "\nPasswordAuthentication no\n\nPermitRootLogin without-password\n\nStrictModes yes\n\nProtocol 2\n\nIgnoreRhosts yes\n\nGSSAPIAuthentication no\n\nChallengeResponseAuthentication no\n\nKerberosAuthentication no\n\nHostbasedAuthentication no\n\nX11Forwarding no\n\nPrintLastLog yes\n\nPermitEmptyPasswords no\n\nUsePriveledgeSeperation yes\n\nUseLogin no\n\nPermitUserEnvironment no\n\nUsePAM no\n\nAllowTcpForwarding no\n\nLoginGraceTime 300\n\nMaxStartups 2\n\nCiphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128\n" >> "$SSH_CONF"
mv $SSH_CONF /root/temp.sshconf
sed '/^$/d' /root/temp.sshconf > $SSH_CONF
rm -f /root/temp.sshconf
cat /etc/ssh/sshd_config
echo -e "\nPress enter."
  read
apt-get install ntp ntpdate sudo screen git haveged curl atop pwgen secure-delete lvm2 cryptsetup -y
service ntp stop
ntpdate 0.europe.pool.ntp.org
service ntp start
echo -e "\nhardstatus on\nhardstatus alwayslastline\n$(echo 'hardstatus string "%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y} %m/%d %C%a "')\n" >> /etc/screenrc
