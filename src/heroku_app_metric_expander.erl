-module (heroku_app_metric_expander).

-export([expand/1]).

expand({{_, _, _, _, <<"app">>, <<"web.", _>>, _, _}, _} = Message) ->
  syslog_pipeline_heroku_expanders_util:extract(Message);
expand(_) ->
  [].
