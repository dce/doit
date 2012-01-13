assert = require 'assert'
doit = require './doit'

tasks = completions = null

set_tasks = (t) -> tasks = t
set_completions = (c) -> completions = c

doit.add ["run"], [], set_tasks
assert.deepEqual ["run"], tasks

doit.add ["run", "read"], [], set_tasks
assert.deepEqual ["run", "read"], tasks

doit.did ["run"], ["run", "read"], {}, "today", set_completions
assert.deepEqual { today: ["run"] }, completions

doit.did ["run", "read"], ["run", "read"], {}, "today", set_completions
assert.deepEqual { today: ["run", "read"] }, completions

doit.did ["run", "foo"], ["run", "read"], {}, "today", set_completions
assert.deepEqual { today: ["run"] }, completions
