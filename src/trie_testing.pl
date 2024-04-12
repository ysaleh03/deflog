% trie data structure will have:
%   the current key (character)
%   a list of children (trie, next character)
%   a list of values associated with that key

% the root (top-level node) is actually a list of tries, sort of like children
% This is needed because words like "Green" and "Blue" do not have a common prefix whatsoever
% and the empty character ('') would have to be added to the start of every word for us just to have
% a root node, instead of just children, so we have decided to have the root be a list of tries instead

% trie_insert general signature
% trie_insert(+Tries, +ListOfCodes, +Value, -NewTries)
%   -  when passing list of tries (ie. root)
% trie_insert(+Trie, +ListOfCodes, +Value, -NewTrie)
%   -  when passing trie() node (ie. trie(97, [], []))

% root is a list of tries (we always use the root to add to the tree), Key already in root.
% This function definition is when the Key matches one of the keys in the list of tries.
% We then recursively call trie_insert on that trie until we reach the word we want.
trie_insert(Tries, [KF|KR], V, NewTries) :-
  member(trie(KF,_,_), Tries),

  append(C1, [ModChild|C2], Tries),
  trie_insert(ModChild, [KF|KR], V, UpdatedChild),
  append(C1, [UpdatedChild|C2], NewTries).


% root is a list of tries (we always use the root to add to the tree), Key not in root yet.
% This function definition is when the Key does not match one of the keys in the list of trie.
% We create a new trie node and recursively call this function on it until we create the 
% desired entry. Finally, we add this new node into the list tries.
trie_insert(Tries, [KF|KR], V, NewTries) :-
  is_list(Tries),
  \+ member(trie(KF,_,_), Tries),

  trie_insert(trie(KF,[],[]), [KF|KR], V, NewTrie),
  append(Tries, [NewTrie], NewTries).

% we reach where we want to insert
% this function is called when we reach the final letter of the word, and we update the
% list of values of the current word with new values (note this list can be empty)
trie_insert(trie(K, Children, Vals), [KF], V, trie(K, Children, NewVals)) :-
  K = KF,
  append(Vals, [V], NewVals).


% This function is similar to the trie_insert function that updates a node that already exists in the list of tries,
% it does this by checking if the next character of the word is a child of the current node, and calls this function 
% recursively on that child node, until we complete the word.
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  member(trie(KS,_,_), Children),

  append(C1, [ModChild|C2], Children),
  trie_insert(ModChild, [KS|KR], V, UpdatedChild),
  append(C1, [UpdatedChild|C2], NewChildren).

% This function is similar to the trie_insert function that inserts a node that does not exist in the list of tries,
% it does this by checking if the next character of the word is not a child of the current node, creates a new node,
% and calls this function recursively until we complete the word.
trie_insert(trie(K, Children, Vals), [KF|[KS|KR]], V, trie(K, NewChildren, Vals)) :-
  K = KF,
  \+ member(trie(KS,_,_), Children),

  trie_insert(trie(KS,[],[]), [KS|KR], V, NewTrie),
  append(Children, [NewTrie], NewChildren).

% two functions below are used for reading the csv file into a brand new trie root
read_csv_and_insert(File, Final_tries) :-
  csv_read_file(File, Rows), % built-in csv_read_file
  insert_csv_rows(Rows, [], Final_tries). % where '[]' is the new trie structure

insert_csv_rows([], Trie, Trie).
insert_csv_rows([Row|Rest_rows], Original_tries, Final_tries) :-
  Row = row(UKey, _, Value), % gets the row of csv file
  %string_lower(UKey, Key), 
  Key = UKey,
  string_codes(Key, Char_list_key), % changes string to string codes ASCII / numeric codes
  trie_insert(Original_tries, Char_list_key, Value, Intermediate_Tries), % calls Oleg's trie_insert function
  insert_csv_rows(Rest_rows, Intermediate_Tries, Final_tries). % recursively inserts rest of rows

% FOR DEBUGGING
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
