BEGIN {

    dir      = ARGV[1];
    startnum = ARGV[2];
    ARGV[1]  = "";
    ARGV[2]  = "";
}

{
    oldname = $0;
    gsub(/\&/,  "\\\\&", oldname);
    gsub(/'/,  "\\'", oldname);
    gsub(/\(/, "\\(", oldname);
    gsub(/\)/, "\\)", oldname);
    gsub(/ /,  "\\ ", oldname);

    split(oldname, a, "-");

    num = a[1] + startnum;

    newname = dir "/" num "-" a[2] ;

    print oldname "\t\t\t\t\t" newname;

    #system("cp " oldname " " newname);
}
