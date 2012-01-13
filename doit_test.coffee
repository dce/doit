assert = require 'assert'
doit = require './doit'

doit.did "run", ["run", "read"], {}, "today", (completions) ->
  assert.deepEqual { today: ["run"] }, completions
