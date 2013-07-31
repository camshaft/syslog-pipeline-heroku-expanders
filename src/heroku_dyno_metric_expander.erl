-module (heroku_dyno_metric_expander).

-export([expand/1]).

expand({{Priority, Version, Timestamp, Hostname, <<"heroku">> = AppName, <<"web.",_>> = Dyno, MessageID, Message}, Fields}) ->
  HostnameDyno = <<Hostname/binary, ".", Dyno/binary>>,
  [{{Priority, Version, Timestamp, HostnameDyno, AppName, Dyno, MessageID, Message}, [{tags, [Hostname]}|Fields]}];
expand(_) ->
  [].
