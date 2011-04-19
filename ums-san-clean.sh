#!/bin/sh
mount /media/san-db/
rm -r /media/san-db/{mysql,tftp}
umount /media/san-db/

mount /media/imap-db/
rm -r /media/imap-db/{imapdata,mailboxes,sieve}
umount /media/imap-db/
