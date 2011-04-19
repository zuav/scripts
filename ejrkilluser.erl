%%%
%%% EJabberd Kill User Tool
%%%
%%% This utility can list connected users and close connection for specified user
%%%

-module(ejrkilluser).
-export([start/0,
         start/1,
         sessions_list/1,
         sessions_list/0,
         kill_users/2,
         kill_sessions/0,
         kill_sessions/1,
         kill_sessions/3
        ]).

-include_lib("stdlib/include/qlc.hrl").

start() ->
    print_usage(),
    halt(1).

start([]) ->
    print_usage(),
    halt(1);
start([sessions, Node]) ->
    Rc = sessions_list(Node),
    halt(Rc);
start([kill, Node, Name]) ->
    Rc = kill_users(Node, Name),
    halt(Rc);
start(L) ->
    io:format("error: bad arguments: ~p~n", [L]),
    halt(2).

print_usage() ->
    io:format("Usage: ejrkilluser [command node [options]]~n"
              "~n"
              "Available commands:~n"
              "  sessions        show connected users~n"
              "  kill N1...Nk    close all sessions of the users N1,..Nk~n"
              "~n"
              "Example:~n"
              "  ejrkilluser sessions ejabberd@jabber.domain.org~n"
              "  ejrkilluser kill ejabberd@jabber.domain.org bilbo frodo gandalf~n").


sessions_list(Node) ->
    Res = rpc:call(Node, ejrkilluser, sessions_list, []),
    handle_results(Res).

sessions_list() ->
    Res = get_table(session),
    case Res of
        {atomic, L} ->
            print_session(L)
    end,
    Res.

kill_users(Node, Name) ->
%    Res = rpc:call(Node, ejrkilluser, kill_users, [lists:map(fun(X) -> atom_to_list(X) end, Names)]),
    Res = rpc:call(Node, ejrkilluser, kill_sessions, [atom_to_list(Name)]),
    handle_results(Res).

-record(session, {sid, usr, us, priority}).


kill_sessions(_, _, _) ->
    ok.

%% kill_sessions(_) ->
%%     ok.

kill_sessions() ->
    ok.

kill_sessions(Name) ->
    Pat = #session{sid = '_', usr = {Name, '_', '_'}, _ = '_'},
    mnesia:transaction(fun() ->
                               L = mnesia:match_object(Pat),
                               case length(L) of
                                   0 ->
                                       mnesia:abort("user " ++Name++ " not found");
                                   _ ->
                                       close_user_sessions(L)
                               end
                       end).



%% kill_users([Name|T]) ->
%%     Pat = #session{sid = '_', usr = {Name, '_', '_'}, _ = '_'},
%%     mnesia:transaction(fun() ->
%%                                L = mnesia:match_object(Pat),
%%                                case length(L) of
%%                                    0 ->
%%                                        mnesia:abort("user " ++Name++ " not found");
%%                                    _ ->
%%                                        close_user_sessions(L)
%%                                end
%%                        end),

%%     kill_users(T);
%% kill_users([]) ->
%%     ok.


close_user_sessions([H|T]) ->
    {_, Pid} = H#session.sid,
    gen_fsm:send_event(Pid, closed),
    close_user_sessions(T);
close_user_sessions([]) ->
    ok.


get_table(Table) ->
    Q = qlc:q([X || X <- mnesia:table(Table)]),
    F = fun() -> qlc:e(Q) end,
    mnesia:transaction(F).

print_session([H|T])  ->
    io:format("~p~n", [H]),
    print_session(T);
print_session([]) ->
    io:format("~n").

handle_results(Res) ->
    case Res of
        ok ->
            io:format("ok~n"),
            Rc = 0;
        {atomic, _ } ->
            io:format("ok~n"),
            Rc = 0;
        {aborted, Reason} ->
            io:format("error: ~p~n", [Reason]),
            Rc = 2;
        {badrpc, Reason} ->
            io:format("error: badrpc: ~p~n", [Reason]),
            Rc = 3;
        Strange ->
            io:format("error: unexpected results: ~p~n", [Strange]),
            Rc = 4
    end,
    Rc.

