# -*- awk -*-
#
BEGIN {

    leading_blanks = 0;
}

# skip mode variable like this: -*- Outline -*-
/-\*- .* -\*-/ {

    next;
}

# 1-level title
# * Title -> ---+ Title
/^\* / {

    leading_blanks = 0;
    sub(/^\* /, "---+ ");
    print;
    next;
}

# 2-level title
# ** Title -> ---++ Title
/^\*\* / {

    leading_blanks = 0;
    sub(/^\*\* /, "---++ ");
    print;
    next;
}

# 3-level title
# *** Title -> ---+++ Title
/^\*\*\* / {

    leading_blanks = 0;
    sub(/^\*\*\* /, "---+++ ");
    print;
    next;
}

# 4-level title
# **** Title -> ---++++ Title
/^\*\*\*\* / {

    leading_blanks = 0;
    sub(/^\*\*\*\* /, "---++++ ");
    print;
    next;
}

# 5-level title
# ***** Title -> ---+++++ Title
/^\*\*\*\*\* / {

    leading_blanks = 0;
    sub(/^\*\*\*\*\* /, "---+++++ ");
    print;
    next;
}

# bulleted list topic start
/^[ ]+-/ {

    leading_blanks = 3;
    sub(/-/, "*");
    sub(/^[ ]*/, "");
    printf "%*s%s\n", leading_blanks, " ", $0;
    next;
}

# bulleted list topic continuation
/^[ ]+/ {

    sub(/^[ ]*/, "");
    printf "%*s%s\n", leading_blanks+2, " ", $0;
    next;
}

# emtpy line
/^[ \t]*$/ {

    printf "\n";
    next;
}

{
    leading_blanks = 0;
    print;
}
