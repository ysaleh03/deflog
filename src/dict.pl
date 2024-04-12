% this is in prolog
% TODO:
% - Function that takes a string, searches trie for subtree starting.
% - Function that takes a word,   searches trie for its definition. 

:- [trie_testing].

:- read_csv_and_insert('../data/english_dictionary_2.csv', Trie), nb_setval(trie, Trie).

find_trie_node([trie(K, Children, Def)|Tries], [Char], [C|Word], Definition, Trie) :-
  (K = Char -> C = K, Def = Definition, trie(K, Children, Def) = Trie, Word = [];
  find_trie_node(Tries, [Char], [C|Word], Definition, Trie)).

find_trie_node([trie(K, Children, _)|Tries], [Char|Chars], [C|Word], Definition, TOut) :-
  length(Chars, H),
  H > 0,
  (K = Char -> C = K,
              find_trie_node(Children, Chars, Word, Definition, TOut);
  find_trie_node(Tries, [Char|Chars], [C|Word], Definition, TOut)).

trie_to_words(trie(K, [], Def), Out) :-
  length(Def, L),
  (L > 0 -> Out = [[K]];
  Out = [[]]).

trie_to_words(trie(K, Children, Def), Out) :-
  length(Children, C),
  C > 0,
  convlist(trie_to_words, Children, Outppp),
  foldl(append, Outppp, [[]], Outpp),
  maplist(append([K]), Outpp, Outp),
  length(Def, L),
  (L > 0 -> Out = [[K]|Outp];
  Out = Outp).

find_word(String, Definition) :- 
  string_codes(String, Chars),
  nb_getval(trie, Trie),
  find_trie_node(Trie, Chars, _, Definition, _). 

find_preds(String, Word, Out) :-
  string_codes(String, Chars),
  nb_getval(trie, Trie),
  find_trie_node(Trie, Chars, FWord, _, TOut),
  length(I, 1),
  append(Word, I, FWord),
  trie_to_words(TOut, BOut),
  maplist(append(Word), BOut, COut),
  maplist(string_codes, Out, COut).

% find_word_helper([trie(K, _, Def)|Tries], [Char], Definition) :- 
%  K = Char -> Def = Definition;
%  find_word_helper(Tries, [Char], Definition). 

%find_word_helper([trie(K, Children, _)|Tries], [Char|Chars], Definition) :- 
%  K = Char -> find_word_helper(Children, Chars, Definition);
%  find_word_helper(Tries, [Char|Chars], Definition).
