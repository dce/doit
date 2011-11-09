#!/usr/bin/env coffee

util = require 'util'
fs = require 'fs'
path = require 'path'

puts = (output) -> util.puts output

pad = (output) ->
  puts ""
  output()
  puts ""

date_string = (opts = {}) ->
  date = if opts.init then new Date(opts.init) else new Date
  date.setDate date.getDate() - (opts.offset || 0)
  date.toDateString()

load_tasks = (file, callback) ->
  report_problem = (error) ->
    puts "There was a problem reading your .doit file: '#{error}'"

  path.exists file, (exists) ->
    if exists
      fs.readFile file, (error, data) ->
        if error
          report_problem error
        else
          try
            parsed = JSON.parse data
            parsed.tasks ?= []
            parsed.completions ?= {}
            parsed.notes ?= {}

            callback parsed.tasks, parsed.completions, parsed.notes
          catch error
            report_problem error
    else
      callback [], {}, {}

add = (task, tasks, callback) ->
  if !task?
    puts "Please enter a task"
  else if task in tasks
    puts "Task already in list"
  else
    tasks.push(task)
    callback tasks

did = (task, tasks, completions, date, callback) ->
  completions[date] ?= []

  if task not in tasks
    puts "Not a valid task"
  else if task in completions[date]
    puts "Task already completed"
  else
    completions[date].push(task)
    callback completions

note = (note, notes, date, callback) ->
  notes[date] = note
  callback notes

save = (tasks, completions, notes, file, callback) ->
  data = tasks: tasks, completions: completions, notes: notes
  fs.writeFile file, JSON.stringify(data, undefined, 2), (err) ->
    if err
      puts err
    else
      callback()

print = (tasks, completions, notes, date) ->
  pad ->
    if tasks.length == 0
      puts "(use `doit add <task>` to add a task)"
    else
      unless date == date_string()
        puts "  #{date}\n"
      for task in tasks.sort()
        puts "  #{ if task in (completions[date] || []) then "X" else "_" } #{task}"
      if notes[date]?
        puts ""
        puts "  NOTE: #{notes[date]}"

save_and_print = (tasks, completions, notes, date, file) ->
  save tasks, completions, notes, file, ->
    print tasks, completions, notes, date

chart = (tasks, completions, notes, date) ->
  task_line = (label, note..., str) ->
    puts "  #{label}#{ tasks.sort().map(str).join '' } #{note}"

  pad ->
    task_line "           ", (task) -> "| #{task}    "[0..5] + " "
    task_line "-----------", -> "+------"

    for i in [6..0]
      curdate = date_string init: date, offset: i
      task_line "#{curdate[0..-6]} ", notes[curdate], (task) ->
        "| #{ if task in (completions[curdate] || []) then "XXXX" else "    " } "

file = "#{process.env.HOME}/.doit"

date = date_string offset: (1 if "yesterday" in process.argv)

[command, task] = process.argv[2..3]

load_tasks file, (tasks, completions, notes) ->
  switch command
    when "add"
      add task, tasks, (tasks) ->
        save_and_print tasks, completions, notes, date, file
    when "did"
      did task, tasks, completions, date, (completions) ->
        save_and_print tasks, completions, notes, date, file
    when "note"
      note task, notes, date, (notes) ->
        save_and_print tasks, completions, notes, date, file
    when "chart"
      chart tasks, completions, notes, date
    else
      print tasks, completions, notes, date
