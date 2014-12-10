-module(syslog_pipeline_heroku_expanders_util).

-export([extract/1]).

-define(I(Num), (Num =/= 47 andalso Num > 45 andalso Num < 58)).

extract({Header, Fields}) ->
  extract(Header, Fields, []).

extract(_, [], Acc) ->
  Acc;
extract(Header, [Field|Fields], Acc) ->
  case parse(Header, Field) of
    undefined ->
      extract(Header, Fields, Acc);
    Metric ->
      extract(Header, Fields, [Metric|Acc])
  end.

parse(Header, {<<"measure#", Key/binary>>, Value}) ->
  handle(Header, Key, Value, <<"measure">>);
parse(Header, {<<"count#", Key/binary>>, Value}) ->
  handle(Header, Key, Value, <<"count">>);
parse(Header, {<<"sample#", Key/binary>>, Value}) ->
  handle(Header, Key, Value, <<"sample">>);
parse(Header, {<<"event#", Key/binary>>, Value}) ->
  handle(Header, Key, Value, <<"event">>);
parse(_, _) ->
  undefined.

handle(Header, Key, Value, Type) ->
  case parse_value(Value) of
    undefined ->
      undefined;
    {Num, <<>>} ->
      {Header, [{<<"measure">>, Key}, {<<"val">>, Num}, {<<"tags">>, [Type]}]};
    {Num, Unit} ->
      {Header, [{<<"measure">>, Key}, {<<"val">>, Num}, {<<"tags">>, [Unit, Type]}]}
  end.

parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S), ?I(T), ?I(U), ?I(V), ?I(W), ?I(X) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S), ?I(T), ?I(U), ?I(V), ?I(W) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S), ?I(T), ?I(U), ?I(V) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S), ?I(T), ?I(U) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S), ?I(T) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R), ?I(S) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q), ?I(R) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P), ?I(Q) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O), ?I(P) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M), ?I(N), ?I(O) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,N,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I
(J), ?I(K), ?I(L), ?I(M), ?I(N) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M,N>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,M,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L), ?I(M) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L,M>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,L,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K), ?I(L) ->
  {<<A,B,C,D,E,F,G,H,I,J,K,L>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,K,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J), ?I(K) ->
  {<<A,B,C,D,E,F,G,H,I,J,K>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,J,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I), ?I(J) ->
  {<<A,B,C,D,E,F,G,H,I,J>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,I,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H), ?I(I) ->
  {<<A,B,C,D,E,F,G,H,I>>, Unit};
parse_value(<<A,B,C,D,E,F,G,H,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G), ?I(H) ->
  {<<A,B,C,D,E,F,G,H>>, Unit};
parse_value(<<A,B,C,D,E,F,G,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F), ?I(G) ->
  {<<A,B,C,D,E,F,G>>, Unit};
parse_value(<<A,B,C,D,E,F,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E), ?I(F) ->
  {<<A,B,C,D,E,F>>, Unit};
parse_value(<<A,B,C,D,E,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D), ?I(E) ->
  {<<A,B,C,D,E>>, Unit};
parse_value(<<A,B,C,D,Unit/binary>>) when ?I(A), ?I(B), ?I(C), ?I(D) ->
  {<<A,B,C,D>>, Unit};
parse_value(<<A,B,C,Unit/binary>>) when ?I(A), ?I(B), ?I(C) ->
  {<<A,B,C>>, Unit};
parse_value(<<A,B,Unit/binary>>) when ?I(A), ?I(B) ->
  {<<A,B>>, Unit};
parse_value(<<A,Unit/binary>>) when ?I(A) ->
  {<<A>>, Unit};
parse_value(_) ->
  undefined.
