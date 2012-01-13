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

add = (tasks, task_list, callback) ->
  for task in tasks
    if !task?
      puts "Please enter a task"
    else if task in task_list
      puts "Task already in list: #{task}"
    else
      task_list.push(task)
      success = true

  callback tasks if success

did = (tasks, task_list, completions, date, callback) ->
  completions[date] ?= []

  for task in tasks
    if task not in task_list
      puts "Not a valid task: #{task}"
    else if task in completions[date]
      puts "Task already completed: #{task}"
    else
      completions[date].push(task)
      success = true

  callback completions if success

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

exports.did = did
exports.add = add

if process.mainModule.filename.match(/doit.coffee/)
  file = "#{process.env.HOME}/.doit"

  if "yesterday" in process.argv
    process.argv.pop()
    date = date_string offset: 1
  else
    date = date_string()

  [command, tasks...] = process.argv[2..]

  load_tasks file, (task_list, completions, notes) ->
    switch command
      when "add"
        add tasks, task_list, (tasks) ->
          save_and_print task_list, completions, notes, date, file
      when "did"
        did tasks, task_list, completions, date, (completions) ->
          save_and_print task_list, completions, notes, date, file
      when "note"
        note tasks, notes, date, (notes) ->
          save_and_print task_list, completions, notes, date, file
      when "chart"
        chart task_list, completions, notes, date
      else
        print task_list, completions, notes, date
