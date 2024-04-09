read_csv_and_insert(File, Trie) :-
    trie_new(Trie),
    csv_read_file(File, Rows),
    read_csv_rows(Rows, Trie),
    % writeln(UpdatedTrie). % Removed printing here

read_csv_rows([], Trie, Trie).
read_csv_rows([Row|Rest], Trie) :-
    Row = row(Key, _, Value), % Assuming you want to use the first and third values
    insert_into_trie(Key, Value, Trie),
    read_csv_rows(Rest, Trie).

insert_into_trie(Key, Value, Trie) :-
    write(trie_gen(Trie, Key, The_value)),
    ( trie_gen(Trie, Key, The_value) ->
      append(The_value, [Value], Result),
      trie_update(Trie, Key, Result)
    ; \+ trie_gen(Trie, Key) ->
      trie_insert(Trie, Key, [Value])
    ).

print_trie(Trie) :-
    print_trie(Trie, "").

print_trie(Trie, Prefix) :-
    trie_gen(Trie, Word, Data),
    atom_concat(Prefix, Word, FullWord),
    format('~s: ~w~n', [FullWord, Data]),
    trie_get(Trie, Word, SubTrie),
    print_trie(SubTrie, FullWord),
    false. % Force backtracking for multiple solutions
print_trie(_, _).


% Usage: read_csv_and_insert('english_dictionary_2.csv', Trie), print_trie(Trie).
