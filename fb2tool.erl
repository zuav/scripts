#!/usr/bin/env escript

main([Cmd|Files]) ->
    command(Cmd, Files);

main([]) ->
    print_usage().

print_usage() ->
    Str =
        "Usage: fb2tool.erl COMMAND File1 File2 ...~n"
        "~n"
        "Where COMMAND is one of:~n"
        "  help     -- print this help message and exit;~n"
        "  get-pics -- get all pictures from the specified file(s)~n"
        "              and save them in the current directory.~n",
    io:format(Str).

command("get-pics", L) ->
    get_pics(L);
command("help", _) ->
    print_usage();
command(Cmd, _) ->
    io:format("fb2tool: error: unknown command: ~s~n", [Cmd]).


get_pics(L) ->
    io:format("get_pics called with arg: ~p~n", [L]).
