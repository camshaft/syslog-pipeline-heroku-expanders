-module (heroku_error_expander).

-export([expand/1]).

expand({{_, _, _, _, <<"heroku">>, <<"router">>, _, _}=Headers, Fields}) ->
  Code = proplists:get_value(<<"code">>, Fields),
  handle(Code, Headers, Fields);
expand(_) ->
  [].

% App Crashed
% https://devcenter.heroku.com/articles/error-codes#h10-app-crashed
handle(<<"H10">>, _Headers, _Fields) ->
  [];
% Backlog too deep
% https://devcenter.heroku.com/articles/error-codes#h11-backlog-too-deep
handle(<<"H12">>, _Headers, _Fields) ->
  [];
% Connection closed without response
% https://devcenter.heroku.com/articles/error-codes#h13-connection-closed-without-response
handle(<<"H13">>, _Headers, _Fields) ->
  [];
% No web processes running
% https://devcenter.heroku.com/articles/error-codes#h14-no-web-processes-running
handle(<<"H14">>, _Headers, _Fields) ->
  [];
handle(<<"H15">>, _Headers, _Fields) ->
  [];
handle(<<"H16">>, _Headers, _Fields) ->
  [];
handle(<<"H17">>, _Headers, _Fields) ->
  [];
handle(<<"H18">>, _Headers, _Fields) ->
  [];
handle(<<"H19">>, _Headers, _Fields) ->
  [];
handle(<<"H20">>, _Headers, _Fields) ->
  [];
handle(<<"H21">>, _Headers, _Fields) ->
  [];
handle(<<"H22">>, _Headers, _Fields) ->
  [];
handle(<<"H80">>, _Headers, _Fields) ->
  [];
handle(<<"H99">>, _Headers, _Fields) ->
  [];
handle(<<"R10">>, _Headers, _Fields) ->
  [];
handle(<<"R11">>, _Headers, _Fields) ->
  [];
handle(<<"R13">>, _Headers, _Fields) ->
  [];
handle(<<"R14">>, _Headers, _Fields) ->
  [];
handle(<<"R15">>, _Headers, _Fields) ->
  [];
handle(<<"R16">>, _Headers, _Fields) ->
  [];
handle(<<"L10">>, _Headers, _Fields) ->
  [];
handle(<<"L11">>, _Headers, _Fields) ->
  [];
handle(_, _Headers, _Fields) ->
  [].
