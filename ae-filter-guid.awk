BEGIN {

    found   = 0;
    guidstr = "Guid: " guid_val;
}

$0 ~ guid_val {

    found = 1;
    next;
}

/Digest: / {
    if (found) {
        print $2;
        exit(0);
    }
}
