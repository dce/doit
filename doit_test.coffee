assert = require 'assert'
doit = require './doit'

doit.add ["run"], [], (tasks) ->
  assert.deepEqual ["run"], tasks

doit.add ["run", "read"], [], (tasks) ->
  assert.deepEqual ["run", "read"], tasks

doit.did ["run"], ["run", "read"], {}, "today", (completions) ->
  assert.deepEqual { today: ["run"] }, completions

doit.did ["run", "read"], ["run", "read"], {}, "today", (completions) ->
  assert.deepEqual { today: ["run", "read"] }, completions

doit.did ["run", "foo"], ["run", "read"], {}, "today", (completions) ->
  assert.deepEqual { today: ["run"] }, completions
