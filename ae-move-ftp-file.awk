#!/usr/bin/awk -f

BEGIN {

    pid = PROCINFO["pid"];
    print "pid is: " pid;
    # pidfile = "/var/run/ae-move-file.pid"
    # print pid > pidfile;
    # close(pidfile);
}

{
    print "got: "      $0;
    print "filename: " $9;
    src = $9;
    dest = "/var/spool/ftp/get/"
    cmd = "mv " src " " dest;
    system(cmd);
    system("logger -s -t ae-move-ftp-file -p user.info 'moved " src " to " dest "'");
}


# /STOR -/ {

#     print "got: " $0;

#     system("logger -s -t ae-move-ftp-file -p user.debug \"skipping failed STOR\"");
#     next;
# }

# /STOR .+/ {

#     print "got: " $0;

#     src = $2;
#     dest = "/var/spool/ftp/get/"
#     cmd = "mv " src " " dest;
#     system(cmd);
#     system("logger -s -t ae-move-ftp-file -p user.info 'moved " src " to " dest "'");
# }
