% this is in prolog
% TODO:
% - Function that takes a string, searches trie for subtree starting.
% - Function that takes a word,   searches trie for its definition. 

:- [trie_testing].

find_word(Trie, String, Definition) :- 
  string_codes(String, Chars), find_word_helper(Trie, Chars, Definition).


find_word_helper([trie(K, _, Def)|Tries], [Char], Definition) :- 
  K = Char -> Def = Definition; find_word_helper(Tries, [Char], Definition). 

find_word_helper([trie(K, Children, _)|Tries], [Char|Chars], Definition) :- 
  K = Char -> find_word_helper(Children, Chars, Definition);
  find_word_helper(Tries, [Char|Chars], Definition).
