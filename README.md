# Deflog
## Jenilee Chen, Youssef Saleh, Oleg Yurchenko

### What is the problem?
Where would humanity be without dictionaries? Since writing first started, humans have been writing repositories of word definitions, and this is nothing if not a continuation of that grand tradition.

Using Prolog, we want to create a lightweight dictionary client with autocomplete suggestions. The main goals we want to achieve are:

1. **Intuitive User Interface:** Since our project is made for non-technical users, we want the UI to be intuitive and easy to use out of the box.
2. **Quick Lookup:** We want searching to be as fast as possible. Using a trie would allow us to search for words in O(log n) time, which is ideal.
3. **Simple Implementation:** We implemented a simple GUI that allows users to type in a word, select from live autocomplete suggestions and get the definition.

### What is something extra?
Live autocomplete suggestions for users as they type words in.
Easy-to-use Python GUI.

### What did we learn from doing this?
Most of the learning involved was on how to build and traverse a trie.
Coming up with Prolog functions, specifically, to query the trie and rebuild words from the found nodes was the largest challenge because it involved a lot of algorithmic thinking and tinkering with our code.

### Work division
Jenilee worked on reading a dictionary from a csv format and inserting it into the trie.

Oleg worked on the GUI and reading returned information from the Prolog program.

Youssef worked on querying the trie for definitions and suggested words.

[Link to UBC Wiki entry](https://wiki.ubc.ca/Course:CPSC312-2024/Deflog)
