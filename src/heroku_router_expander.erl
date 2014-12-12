-module (heroku_router_expander).

-export([expand/1]).

expand({{_, _, _, _, <<"heroku">>, <<"router">>, _, _}=Headers, Fields}) ->
  RequestID = proplists:get_value(<<"request_id">>, Fields),
  iterate(Headers, RequestID, Fields, [
    merge(Headers, RequestID, [
      {<<"measure">>, <<"request">>},
      {<<"val">>, 1},
      {<<"tags">>, [
        <<"count">>,
        <<"router">>
      ]}
    ])
  ]);
expand(_) ->
  [].

iterate(_, _, [], Acc) ->
  Acc;
iterate(Headers, RequestID, [Field|Fields], Acc) ->
  case metric(Field) of
    undefined ->
      iterate(Headers, RequestID, Fields, Acc);
    ExpandedField ->
      Message = merge(Headers, RequestID, ExpandedField),
      iterate(Headers, RequestID, Fields, [Message|Acc])
  end.

merge(Headers, RequestID, Field) ->
  {Headers, [{<<"request_id">>, RequestID}|Field]}.

metric({<<"method">>, Method}) ->
  [
    {<<"measure">>, <<"method_", Method/binary>>},
    {<<"val">>, 1},
    {<<"units">>, <<"requests">>},
    {<<"tags">>, [
      Method,
      <<"count">>,
      <<"router">>
    ]}
  ];
metric({<<"status">>, StatusCode}) ->
  [
    {<<"measure">>, <<"status_code_", StatusCode/binary>>},
    {<<"val">>, 1},
    {<<"units">>, <<"requests">>},
    {<<"tags">>, [
      StatusCode,
      <<"count">>,
      <<"router">>
    ]}
  ];
metric({<<"queue">>, Queue}) ->
  [
    {<<"measure">>, <<"queue">>},
    {<<"val">>, Queue},
    {<<"units">>, <<"requests">>},
    {<<"tags">>, [
      <<"measure">>,
      <<"router">>
    ]}
  ];
metric({<<"connect">>, Connect}) ->
  [
    {<<"measure">>, <<"connect">>},
    {<<"val">>, strip_ms(Connect)},
    {<<"units">>, <<"ms">>},
    {<<"tags">>, [
      <<"measure">>,
      <<"router">>
    ]}
  ];
metric({<<"service">>, Service}) ->
  [
    {<<"measure">>, <<"service">>},
    {<<"val">>, strip_ms(Service)},
    {<<"units">>, <<"ms">>},
    {<<"tags">>, [
      <<"measure">>,
      <<"router">>
    ]}
  ];
metric({<<"wait">>, Wait}) ->
  [
    {<<"measure">>, <<"wait">>},
    {<<"val">>, strip_ms(Wait)},
    {<<"units">>, <<"ms">>},
    {<<"tags">>, [
      <<"measure">>,
      <<"router">>
    ]}
  ];
metric({<<"bytes">>, Bytes}) ->
  [
    {<<"measure">>, <<"bytes_out">>},
    {<<"val">>, Bytes},
    {<<"units">>, <<"bytes">>},
    {<<"tags">>, [
      <<"measure">>,
      <<"router">>
    ]}
  ];
metric(_) ->
  undefined.

strip_ms(<<Val:1/binary,"ms">>) ->
  Val;
strip_ms(<<Val:2/binary,"ms">>) ->
  Val;
strip_ms(<<Val:3/binary,"ms">>) ->
  Val;
strip_ms(<<Val:4/binary,"ms">>) ->
  Val;
strip_ms(<<Val:5/binary,"ms">>) ->
  Val;
strip_ms(<<Val:6/binary,"ms">>) ->
  Val;
strip_ms(<<Val:7/binary,"ms">>) ->
  Val;
strip_ms(<<Val:8/binary,"ms">>) ->
  Val;
strip_ms(<<Val:9/binary,"ms">>) ->
  Val;
strip_ms(_) ->
  <<>>.
