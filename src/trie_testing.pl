% trie data structure will have:
%   the current key (character)
%   a list of children (trie, next character)
%   a list of values associated with that key


% root is a list of tries (we always use the root to add to the tree), Key already in root
trie_insert(Tries, [KF|KR], V, NewTries) :-
  member(trie(KF,_,_), Tries),

  append(C1, [ModChild|C2], Tries),
  trie_insert(ModChild, [KF|KR], V, UpdatedChild),
  append(C1, [UpdatedChild|C2], NewTries).


% root is a list of tries (we always use the root to add to the tree), Key not in root yet
trie_insert(Tries, [KF|KR], V, NewTries) :-
  is_list(Tries),
  \+ member(trie(KF,_,_), Tries),

  trie_insert(trie(KF,[],[]), [KF|KR], V, NewTrie),
  append(Tries, [NewTrie], NewTries).

% we reach where we want to insert
trie_insert(trie(K, Children, Vals), [KF|KR], V, trie(K, Children, NewVals)) :-
  K = KF,
  length(KR, L),
  L = 0,
  
  append(Vals, [V], NewVals).


% The current value is equal to the key, length of the key is > 1, and next of key is a child of current node
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  length(KR, L),
  L > 0,
  member(trie(KS,_,_), Children),

  append(C1, [ModChild|C2], Children),
  trie_insert(ModChild, [KS|KR], V, UpdatedChild),
  append(C1, [UpdatedChild|C2], NewChildren).

% The current value is equal to the key, length of the key is > 1, and the next of key is not a child of current node
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  length(KR, L),
  L > 0,
  \+ member(trie(KS,_,_), Children),

  trie_insert(trie(KS,[],[]), [KS|KR], V, NewTrie),
  append(Children, [NewTrie], NewChildren).

% the current value is equal to the key, length of the key is = 1, and the next of the key is a child of current node
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  length(KR, L),
  L = 0,
  member(trie(KS,_,_), Children),

  append(C1, [ModChild|C2], Children),
  trie_insert(ModChild, [KS|KR], V, UpdatedChild),
  append(C1, [UpdatedChild|C2], NewChildren).

% the current value is equal to the key, length of the key is = 1, and the next of the key is not a child of current node
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  length(KR, L),
  L = 0,
  \+ member(trie(KS,_,_), Children),

  trie_insert(trie(KS,[],[]), [KS|KR], V, NewTrie),
  append(Children, [NewTrie], NewChildren).

read_csv_and_insert(File, Final_tries) :-
  csv_read_file(File, Rows),
  insert_csv_rows(Rows, [], Final_tries). % where '[]' is the new trie structure

insert_csv_rows([], Trie, Trie).
insert_csv_rows([Row|Rest_rows], Original_tries, Final_tries) :-
  Row = row(Key, _, Value),
  string_codes(Key, Char_list_key),
  trie_insert(Original_tries, Char_list_key, Value, Intermediate_Tries),
  insert_csv_rows(Rest_rows, Intermediate_Tries, Final_tries).

print_tries(L, _) :-
  is_list(L),
  length(L, N),
  N = 0.

print_tries([trie(Key,Children,Values)|Rest], Layer) :-
  char_code(C, Key),
  maplist(write, Layer),
  write(C),
  write("\n"),
  maplist(write, Layer),
  write(Values),
  write("\n"),

  print_tries(Children, [" "|Layer]),
  print_tries(Rest, Layer).

print_root([trie(K, _, _)]) :-
  write(K).

print_root([trie(K, _, _)|Rest]) :-
  write(K),
  write(","),
  print_root(Rest).

