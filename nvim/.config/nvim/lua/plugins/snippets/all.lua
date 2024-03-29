local ls = require "luasnip"
local s = ls.snippet
-- local t = ls.text_node

-- local i = ls.insert_node
-- local c = ls.choice_node
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local events = require "luasnip.util.events"
-- local types = require "luasnip.util.types"
local f = ls.function_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require "luasnip.extras.expand_conditions"

local function bash(_, snip)
  local file = io.popen(snip.trigger, "r")
  local res = {}
  if file == nil then return end
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

local snippets = {
  s({ trig = "date", name = "Current date", dscr = "Insert the current date" }, {
    p(os.date, "%Y-%m-%d"),
  }),

  s({ trig = "pwd" }, { f(bash, {}) }),
}

return snippets
