# doit

**doit** is a simple command line utility for managing daily goals. Simply run `doit` to see your tasks, `doit add <task>` to add a task, and `doit did <task>` to mark something completed. The list resets every day (though all your old data is still available).

## Tech Details

**doit** is written entirely in [CoffeeScript][cfs] -- you'll need that installed in order to run the program. All your data is stored as JSON in a file called `.doit` in your home directory.

  [cfs]: http://jashkenas.github.com/coffee-script/
