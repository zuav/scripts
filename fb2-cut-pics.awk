#!/usr/bin/gawk -f

BEGIN {

    file_name = "";
    in_binary = 0;
    pic_data  = "";
}

# <binary id="_89.jpg" content-type="image/jpeg">
#/<binary id=.*content-type="image\/jpeg"> / {
/<binary id=/ {

    in_binary = 1;

    split($2, a, "=");
    file_name = a[2];
    print "file name: " file_name;

    next;
}

/<\/binary>/ {

    print pic_data > file_name ".txt"
#    print pic_data | "/usr/bin/base64 -d - > " file_name;

    file_name = "";
    in_binary = 0;
    pic_data  = "";

    next;
}

{
    if (in_binary) {
        pic_data = pic_data $0;
    }

    next;
}
