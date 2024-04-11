:- use_module(library(apply)).
:- table read_csv_and_insert/2.

read_csv_and_insert(File, Trie) :-
    trie_new(Trie),
    csv_read_file(File, Rows),
    read_csv_rows(Rows, Trie).
    % writeln(UpdatedTrie). % Removed printing here

read_csv_rows([], Trie).
read_csv_rows([Row|Rest], Trie) :-
    Row = row(Key, _, Value), % Assuming you want to use the first and third values
    insert_into_trie(Key, Value, Trie),
    read_csv_rows(Rest, Trie).

insert_into_trie(Key, Value, Trie) :-
  %write(trie_gen(Trie, Key, The_value)),
  %string_lower(UKey, Key), 
    ( trie_gen(Trie, Key, The_value) ->
      append(The_value, [Value], Result),
      trie_update(Trie, Key, Result)
    ; \+ trie_gen(Trie, Key) ->
      trie_insert(Trie, Key, [Value])
    ).

%print_trie(Trie) :-
%    print_trie(Trie, "").

%print_trie(Trie, Prefix) :-
%    trie_gen(Trie, Word, Data),
%    string_concat(Prefix, Word, FullWord),
%    %format('~s: ~w~n', [FullWord, Data]),
%    %trie_get(Trie, Word, SubTrie),
%    write(Data),
%    print_trie(SubTrie, FullWord),
%    false. % Force backtracking for multiple solutions
%print_trie(_, _).

get_all_sequences(Str, Strs) :-
  string_chars('abcdefghijklmnopqrstuvwxyz', Chrs),
  maplist(string_concat(Str), Chrs, Strs).

print_trie(Trie, Prefix) :-
  trie_gen(Trie, Prefix, V),
  write(V),
  get_all_sequences(Prefix, Prefixes),
  concurrent_maplist(print_trie(Trie), Prefixes),
  false.
print_trie(Trie,Prefix) :- 
  \+ trie_gen(Trie, Prefix, _),
  string_length(Prefix, N),
  N < 4,
  get_all_sequences(Prefix, Prefixes),
  concurrent_maplist(print_trie(Trie), Prefixes),
  false.
print_trie(_,Prefix).



% Usage: read_csv_and_insert('english_dictionary_2.csv', Trie), print_trie(Trie).
