# DOIT


**DOIT** is a simple command line utility for tracking daily goals. Put a symlink called `doit` to `doit.coffee` and use it like this:

    > doit

    (use `doit add <task>` to add a task)

    > doit add exercise

      _ exercise

    > doit add "practice piano"

      _ exercise
      _ practice piano

    > doit did exercise

      ✓ exercise
      _ practice piano

    > doit yesterday

      Mon Mar 14 2011

      _ exercise
      _ practice piano

    > doit did "practice piano" yesterday

      Mon Mar 14 2011

      _ exercise
      ✓ practice piano

    > doit note "super productive day"

      ✓ exercise
      _ practice piano

      NOTE: super productive day

     > doit chart

                  | exer | prac
       -----------+------+------
       Wed Mar 09 |      |
       Thu Mar 10 |      |
       Fri Mar 11 |      |
       Sat Mar 12 |      |
       Sun Mar 13 |      |
       Mon Mar 14 |      | ■■■■
       Tue Mar 16 | ■■■■ |       super productive day

    > doit add read

      ✓ exercise
      _ practice piano
      _ read

      NOTE: super productive day

    > doit did read "practice piano"

      ✓ exercise
      ✓ practice piano
      ✓ read

      NOTE: super productive day

    > doit chart

                 | exer | prac | read
      -----------+------+------+------
      Wed Mar 09 |      |      |
      Thu Mar 10 |      |      |
      Fri Mar 11 |      |      |
      Sat Mar 12 |      |      |
      Sun Mar 13 |      |      |
      Mon Mar 14 |      | ■■■■ |
      Tue Mar 16 | ■■■■ | ■■■■ | ■■■■  super productive day

    > cat ~/.doit
    {
      "tasks": [
        "exercise",
        "practice piano",
        "read"
      ],
      "completions": {
        "Tue Mar 15 2011": [
          "exercise"
        ],
        "Mon Mar 14 2011": [
          "exercise",
          "practice piano",
          "read"
        ]
      },
      "notes": {
        "Tue Mar 15 2011": "super productive day"
      }
    }

## Tech Details

**DOIT** is written entirely in [CoffeeScript][cfs] -- you'll need that installed in order to run the program. All your data is stored as JSON in a file called `.doit` in your home directory. Move it into [Dropbox][drb] and create a symlink in your homedir and you can **DOIT** anywhere.

  [cfs]: http://jashkenas.github.com/coffee-script
  [drb]: http://www.dropbox.com
