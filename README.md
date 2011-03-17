# DOIT


**DOIT** is a simple command line utility for tracking daily goals. Use it like this:

    > doit

    (use `doit add <task>` to add a task)

    > doit add exercise

      _ exercise

    > doit add "practice piano"

      _ exercise
      _ practice piano

    > doit did exercise

      X exercise
      _ practice piano

    > doit yesterday

      Mon Mar 14 2011

      _ exercise
      _ practice piano

    > doit did "practice piano" yesterday

      Mon Mar 14 2011

      _ exercise
      X practice piano

    > cat ~/.doit
    {
      "tasks": [
        "exercise",
        "practice piano"
      ],
      "completions": {
        "Tue Mar 15 2011": [
          "exercise"
        ],
        "Mon Mar 14 2011": [
          "practice piano"
        ]
      }
    }

## Tech Details

**DOIT** is written entirely in [CoffeeScript][cfs] -- you'll need that installed in order to run the program. All your data is stored as JSON in a file called `.doit` in your home directory. Move it into [Dropbox][drb] and create a symlink in your homedir and you can **DOIT** anywhere.

  [cfs]: http://jashkenas.github.com/coffee-script
  [drb]: http://www.dropbox.com
