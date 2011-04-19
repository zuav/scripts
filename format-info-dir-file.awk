#
# Formats dir file according to my taste.
#
# NB: N1, N2, etc comments are there for debug purpose, t.i. to connect
# match expressions with print statements.
#
#
BEGIN {

    DESCR_POS = 48;

    header_parsed       = 0;
    building_line       = 0;
    current_line_header = "";
    current_line_rest   = "";
}


# N1
/^$/ {

    # print "N1: " $0;
    if (!header_parsed) {
        print $0;
        next;
    }

    if (!building_line) {
        print $0;
        next;
    }

    print_current_line_and_clean();

    print $0;

    next;
}

# N2
/^\* Menu:/ {

    #print "N2: " $0;
    print $0;
    header_parsed = 1;

    next;
}

# N3
# $1 $2       $3         $4...
# *  cpp-3.4: (cpp-3.4). The GNU C preprocessor.
/^\* .+/ {

    #print "N3: " $0;

    if (!header_parsed) {
        print $0;
        next;
    }

    if (building_line) {
        print_current_line_and_clean();
    }

    restpos = 0;
    current_line_header = $1;
    for (i=2; i<=NF; ++i) {
        current_line_header = current_line_header " " $i;
        if (match($i, /\(.+\)\./)) {
            restpos = i + 1;
            break;
        }
    }

    for (i=restpos; i<=NF; ++i) {
        current_line_rest = current_line_rest " " $i;
    }

    building_line = 1;

    next;
}


#N4
# in two variants:
#  * Common options: (coreutils)Common options.
#  * msginit:        (gettext)msginit Invocation.   Create a fresh PO file.
# N5
/^[A-Z].+/ {

    #print "N5: " $0;

    if (!header_parsed) {
        print $0;
        next;
    }

    if (!building_line) {
        print $0;
        next;
    }

    print current_line;

    building_line = 0;
    current_line = "";

    print $0;

    next;
}

# N6
{
    # print "N6: " $0;

    if (!header_parsed) {
        print $0;
        next;
    }


    current_line_rest = current_line_rest " " trim_spaces($0);
}

END {
    print_current_line_and_clean();
}

function trim_spaces(str)
{
    sub(/^[ \t]+/, "", str);
    sub(/[ \t]+$/, "", str);
    return str;
}

function print_current_line_and_clean(    len, wsnum, i)
{
    len = length(current_line_header);
    wsnum = DESCR_POS - len;
    if (wsnum < 0) {
        wsnum = 1;
    }

    # print "len   = " len
    # print "wsnum = " wsnum

    printf "%s", current_line_header;
    for (i=0; i<wsnum; ++i) {
        printf "%s", " ";
    }

    printf "%s\n", current_line_rest;

    building_line       = 0;
    current_line_header = "";
    current_line_rest   = "";
}
