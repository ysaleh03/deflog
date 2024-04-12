% main dictionary program

:- [trie_testing].
:- read_csv_and_insert('../data/english_dictionary_2.csv', Trie), nb_setval(trie, Trie).

% searches the trie for a matching node
% base case for final node
find_trie_node([trie(K, Children, Def)|Tries], [Char], [C|Word], Definition, Trie) :-
  (K = Char -> C = K, Definition = Def, Trie = trie(K, Children, Def), Word = [];
  find_trie_node(Tries, [Char], [C|Word], Definition, Trie)).

% searches the trie for a matching node
find_trie_node([trie(K, Children, _)|Tries], [Char|Chars], [C|Word], Definition, TOut) :-
  length(Chars, H),
  H > 0,
  (K = Char -> C = K,
              find_trie_node(Children, Chars, Word, Definition, TOut);
  find_trie_node(Tries, [Char|Chars], [C|Word], Definition, TOut)).

% returns a list of words starting from a given trie node
% base case for final node
trie_to_words(trie(K, [], Def), Out) :-
  length(Def, L),
  L > 0,
  Out = [[K]].

% returns a list of words starting from a given trie node
trie_to_words(trie(K, Children, Def), Out) :-
  length(Children, C),
  C > 0,
  maplist(trie_to_words, Children, Outppp),
  foldl(append, Outppp, [], Outpp),
  maplist(append([K]), Outpp, Outp),
  length(Def, L),
  (L > 0 -> Out = [[K]|Outp];
  Out = Outp).

% given a word string, returns its definition if found in the trie
find_word(UString, Definition) :- 
  UString = String,
  string_codes(String, Chars),
  nb_getval(trie, Trie),
  find_trie_node(Trie, Chars, _, Definition, _). 

% given some prefix, returns all possible words in the trie 
find_preds(UString, Word, Out) :-
  UString = String,
  string_codes(String, Chars),
  nb_getval(trie, Trie),
  find_trie_node(Trie, Chars, FWord, _, TOut),
  length(I, 1),
  append(Word, I, FWord),
  trie_to_words(TOut, BOut),
  maplist(append(Word), BOut, COut),
  maplist(string_codes, Out, COut).

