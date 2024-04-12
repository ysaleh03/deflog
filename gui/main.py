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

        self.definitionHeader = tk.Label(self.definitionFrame, height=1, text="Word Definition:")
        #self.definitionHeader.insert("20.0", "Word Definition:")
        self.definitionHeader.grid(sticky=(tk.N,tk.W,tk.E))
        self.definitionText = tk.Text(self.definitionFrame,state="disabled")
        self.definitionText.grid(sticky=(tk.N,tk.W,tk.E,tk.S))

        self.definitionFrame.grid()
        ### END DEFINITION FRAME

        ### SEARCH FRAME
        self.searchFrame = tk.Frame(self)

        self.searchQuery = tk.StringVar()
        self.searchQuery.trace_add("write", self.updateQuery)
        self.searchInput = tk.Entry(self.searchFrame, textvariable=self.searchQuery)
        self.searchInput.grid(column=0, row=0)
        self.searchInput.bind("<KeyPress>", lambda e: self.queryDictionary() if self.focus_get() == self.searchInput and e.keysym == 'Return' else ())

        self.searchButton = tk.Button(self.searchFrame, text="Search", command=self.queryDictionary)
        self.searchButton.grid(column=1, row=0)

        self.searchList = []
        self.searchListVar = tk.StringVar(value=self.searchList)
        self.searchOptions = tk.Listbox(self.searchFrame, listvariable=self.searchListVar)
        self.searchOptions.grid(row=1)
        self.searchOptions.bind("<Double-1>", lambda e: self.queryDictionary(self.searchList[self.searchOptions.curselection()[0]]))
        self.searchOptions.bind("<KeyPress>", lambda e: self.queryDictionary(self.searchList[self.searchOptions.curselection()[0]]) if self.focus_get() == self.searchOptions  and e.keysym == 'Return' else ())

        # NOTE: use self.searchListVar.set(self.searchList) to update the ListBox variables after changing self.searchList

        self.searchFrame.grid()
        ### END SEARCH FRAME

        ### QUIT BUTTON
        self.quitButton = tk.Button(self, text="Quit", command = self.quit)
        self.quitButton.grid(sticky=(tk.S, tk.W, tk.E))
        ### END QUIT BUTTON

    # queries for possible autofill options and updates the listbox with possible options
    def updateQuery(self, *args):
        #print(args)
        # query PL with the query of the user to get possible autofill options
        if (self.searchQuery.get() == ""):
            self.searchList = []
            self.searchListVar.set(self.searchList)
            return
        # updates the listbox with the possible options
        #result = pl_thread.query("get_possibs(\"" + self.searchQuery.get() + "\", X).")
        result = pl_thread.query("find_preds('" + self.searchQuery.get() + "', _, X).")

        if (not result):
            self.searchList = []
            self.searchListVar.set(self.searchList)
            return
        self.searchList = []
        for item in result[0]['X']:
            self.searchList.append(item)
        self.searchListVar.set(self.searchList)

    # reads whatever is in the search text entry and updates the definition text with whatever it finds
    def queryDictionary(self, nsearch="", *args):
        #print(args)
        if (self.searchQuery.get() == "" and nsearch == ""):
            print("No Entry")
        # read the search input and fetch the definition from PL
        word = ""
        result = ""
        if (nsearch == ""):
            word = self.searchQuery.get()
        else:
            word = nsearch
        #result = pl_thread.query("get_definition(\"" + word + "\", X).")
        #print("query: " + self.lookup_bind + "find_word(T,'" + word + "',X).")
        #result = pl_thread.query(self.lookup_bind + "find_word(T,'" + word + "',X).")
        result = pl_thread.query("find_word('" + word + "',X).")

        #print("Result:")
        #print(result[0]['X'])
        # update the definition box with the fetched definition
        out = word
        if(result == False):
            return
        #for t in result:
        #    out += "\n" + word + " : " + t['X']
        for t in result[0]['X']:
            out += "\n" + word + " : " + t
        self.definitionText['state'] = 'normal'
        self.definitionText.delete(1.0, self.definitionText.index('end'))
        self.definitionText.insert('end', out)
        self.definitionText['state'] = 'disabled'

with PrologMQI(prolog_path_args=["--stack-limit=16g"]) as mqi:
    with mqi.create_thread() as pl_thread:
        # load the PL code
        #pl_thread.query("[\"../src/frontend-testing\"]")
        #pl_thread.query("[\"../src/actual_work_2\"]")

        #pl_thread.query("[\"../src/trie_testing.pl\"]")
        #pl_thread.query("read_csv_and_insert('../data/english_dictionary_2.csv', T), nb_setval(dictionary, T).")
        pl_thread.query("[\"../src/dict.pl\"]")
        app = Application()
        app.master.title("Dictionary")
        app.mainloop()
