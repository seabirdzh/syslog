%%%=============================================================================
%%% Copyright 2016-2017, Tobias Schlager <schlagert@github.com>
%%%
%%% Permission to use, copy, modify, and/or distribute this software for any
%%% purpose with or without fee is hereby granted, provided that the above
%%% copyright notice and this permission notice appear in all copies.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
%%%=============================================================================

-module(syslog_monitor_tests).

-include_lib("eunit/include/eunit.hrl").

%%%=============================================================================
%%% TESTS
%%%=============================================================================

monitor_test() ->
    process_flag(trap_exit, true),

    ok = start(sasl),
    ok = start(syslog),

    ?assert(has_hander(syslog_error_h, error_logger)),
    gen_event:delete_handler(error_logger, syslog_error_h, []),
    timer:sleep(500),
    ?assert(has_hander(syslog_error_h, error_logger)),

    application:stop(syslog),
    application:stop(sasl).

%%%=============================================================================
%%% internal functions
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @private
%%------------------------------------------------------------------------------
start(App) -> start(App, application:start(App)).
start(_, ok) -> ok;
start(App, {error, {already_started, App}}) -> ok.

%%------------------------------------------------------------------------------
%% @private
%%------------------------------------------------------------------------------
has_hander(Handler, Manager) ->
    lists:member(Handler, gen_event:which_handlers(Manager)).
