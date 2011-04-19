BEGIN {

    ordnum = 1;
    dir = ARGV[1];
    ARGV[1] = "";

    if (ARGC > 2) {
        ordnum = ARGV[2];
        ARGV[2] = "";
    }
}

{
    oldname = $0;

    gsub(/\&/,  "\\\\&", oldname);
    gsub(/'/,  "\\'", oldname);
    gsub(/\(/, "\\(", oldname);
    gsub(/\)/, "\\)", oldname);
    gsub(/ /,  "\\ ", oldname);
    newname = oldname;
    gsub(/\.\//, "",    newname);
    gsub(/\//,   "-",   newname);
    newname = dir "/" sprintf("%03d-", ordnum) newname ;
    ordnum++;

    #print oldname;
    #print newname;

    system("cp " oldname " " newname);
}
