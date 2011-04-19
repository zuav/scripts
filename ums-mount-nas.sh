#!/bin/sh
mount ithilien:/src/nas/mysql     /var/lib/ums/var/db/mysql
mount ithilien:/src/nas/mailboxes /var/spool/ums/mailboxes
mount ithilien:/src/nas/imapdata  /var/spool/ums/imapdata
mount ithilien:/src/nas/sieve     /var/spool/ums/sieve
mount ithilien:/src/nas/tftp      /var/lib/ums/tftpboot
