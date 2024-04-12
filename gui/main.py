import tkinter as tk
from swiplserver import PrologMQI, PrologThread
import json
# starter app format courtesy of https://tkdocs.com/shipman/index-2.html

class Application(tk.Frame):
    def __init__(self, master=None):
        tk.Frame.__init__(self,master)
        self.grid()
        self.createWidgets()
    
    def createWidgets(self):
        ### DEFINITION FRAME
        self.definitionFrame = tk.Frame(self)

        # self.definitionHeader is a Label displayed at the top of the program
        self.definitionHeader = tk.Label(self.definitionFrame, height=1, text="Word Definition:")
        self.definitionHeader.grid(sticky=(tk.N,tk.W,tk.E))
        # self.definitionText is a Text box that displays the definitions of a specific word. We set it to disabled so the user cannot write to it
        # when we do write to it, we briefly enable it, have the program write to it, and then disable it again.
        self.definitionText = tk.Text(self.definitionFrame,state="disabled")
        self.definitionText.grid(sticky=(tk.N,tk.W,tk.E,tk.S))

        self.definitionFrame.grid()
        ### END DEFINITION FRAME

        ### SEARCH FRAME
        self.searchFrame = tk.Frame(self)

        # self.searchQuery is a tk variable that keeps track of what we store in the Input/Search field
        self.searchQuery = tk.StringVar()
        self.searchQuery.trace_add("write", self.updateQuery)
        # self.searchInput is an input field where the user can type the search term they desire. Type updates the ListBox (more below)
        self.searchInput = tk.Entry(self.searchFrame, textvariable=self.searchQuery)
        self.searchInput.grid(column=0, row=0)
        # this bind is used for detecting when the entry field is in focus, and if they Return/Enter key has been clicked. It then performs the same action as clicking self.searchButton would do.
        self.searchInput.bind("<KeyPress>", lambda e: self.queryDictionary() if self.focus_get() == self.searchInput and e.keysym == 'Return' else ())

        # self.searchButton is used for querying the prolog server to get the definition(s) for the text in self.searchInput
        self.searchButton = tk.Button(self.searchFrame, text="Search", command=self.queryDictionary)
        self.searchButton.grid(column=1, row=0)

        # the self.searchList is a list that is updated with autocompleted terms that will be displayed in self.searchOptions
        self.searchList = []
        # self.searchListVar is a tk var bound to self.searchList
        self.searchListVar = tk.StringVar(value=self.searchList)
        # self.searchOptions is a List view that contains all the autocompleted terms in the dictionary that are available for the user to search up, given some prefix typed in self.searchInput
        self.searchOptions = tk.Listbox(self.searchFrame, listvariable=self.searchListVar)
        self.searchOptions.grid(row=1)
        # the first bind is setup so that when the user double clicks on an item in the list, we query the PL server for the definition of the word that was clicked on
        self.searchOptions.bind("<Double-1>", lambda e: self.queryDictionary(self.searchList[self.searchOptions.curselection()[0]]))
        # the second bind is setup so that when the user is navigating through the list (ie, with arrow keys), and thus has the list in focus, and clicks Return/Enter, the term is searched for (like <Double-1> bind above)
        self.searchOptions.bind("<KeyPress>", lambda e: self.queryDictionary(self.searchList[self.searchOptions.curselection()[0]]) if self.focus_get() == self.searchOptions  and e.keysym == 'Return' else ())

        self.searchFrame.grid()
        ### END SEARCH FRAME

        ### QUIT BUTTON
        self.quitButton = tk.Button(self, text="Quit", command = self.quit)
        self.quitButton.grid(sticky=(tk.S, tk.W, tk.E))
        ### END QUIT BUTTON

    # queries for possible autofill options and updates the listbox with possible options
    def updateQuery(self, *args):
        # if the user has not entered anything, clear self.searchList
        if (self.searchQuery.get() == ""):
            self.searchList = []
            self.searchListVar.set(self.searchList)
            return
        # query PL with the query of the user to get possible autofill options
        result = pl_thread.query("find_preds('" + self.searchQuery.get() + "', _, X).")

        # if there does not exist a word that has the prefix specified in self.searchQuery, then we just want to clear self.searchList and return
        if (not result):
            self.searchList = []
            self.searchListVar.set(self.searchList)
            return

        # updates the listbox with the possible options (stored in result[0]['X'])
        self.searchList = []
        for item in result[0]['X']:
            self.searchList.append(item)
        self.searchListVar.set(self.searchList)

    # reads whatever is in the search text entry and updates the definition text with whatever it finds
    # the nsearch variable is only specified when we search for something using self.searchOptions either via Return or double click.
    # if nsearch variable is passed in, we treat that as the word to search for.
    # otherwise, we just read from self.searchQuery
    def queryDictionary(self, nsearch="", *args):
        # read the search input and fetch the definition from PL
        word = ""
        # here we check and see whether we want to query using nsearch or the variable stored in self.searchQuery
        if (nsearch == ""):
            word = self.searchQuery.get()
        else:
            word = nsearch
        # query the PL server to get the definition(s) of the word
        result = pl_thread.query("find_word('" + word + "',X).")

        # update the definition box with the fetched definition
        out = word
        # if the word doesn't exist, just exit
        if(not result):
            return
        # we iterate through all definitions of the word (stored in result[0]['X'])
        for t in result[0]['X']:
            out += "\n" + word + " : " + t
        
        # This is required in order to clear the self.definitionText previous entry, and write the new entry and ensure the user cannot write to it afterwards
        # note, text selection and copy/paste is still possible.
        self.definitionText['state'] = 'normal'
        self.definitionText.delete(1.0, self.definitionText.index('end'))
        self.definitionText.insert('end', out)
        self.definitionText['state'] = 'disabled'

# start by running the server and create an mqi thread to interface with the PL server
with PrologMQI(prolog_path_args=["--stack-limit=16g"]) as mqi:
    with mqi.create_thread() as pl_thread:
        # load the PL mqi and initialize the Trie
        pl_thread.query("[\"../src/dict.pl\"]")
        # launch the application
        app = Application()
        app.master.title("Dictionary")
        app.mainloop()
