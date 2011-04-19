BEGIN {

    required_mime = ARGV[1];
    ARGV[1] = "";
    mime_type = "";
    icon_file = "";
}

/^[a-z]+\/.+/ {

    mime_type = $1;
}

/icon_filename=/ {

    if (mime_type == required_mime) {
        split($0, v, "=");
        print "mime_type     = " mime_type;
        print "icon filename = " v[2];
        print "";
    }

    mime_type = "";
    icon_file = "";
}

/^\n/ {

    mime_type = "";
    icon_file = "";
}
