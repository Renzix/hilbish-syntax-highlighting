-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local colors = require "lunacolors"

local syntax = {}

function syntax.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local sh_keywords = { "cd", "exit", "doc", "guide", "cdr", "for", "if" }

function syntax.is_cmd(str)
  if hilbish.which(str) ~= nil then
    return true
  end

  -- i dont know how to see what stuff is buildin keywords so lets just use a
  -- raw table idk
  if syntax.contains(sh_keywords, str) then
     return true
   end
  return false
end

-- this could prob be 10x better with iterators
function syntax.is_sh_str(str)
  local current_quote = nil
  local instr = ""
  local ret = {}
  -- for each char in str
  for i = 1, #str do
    local ch = str:sub(i,i)
    local prev = str:sub(i-1,i-1)
    -- store string if currently inside a quote
    if current_quote ~= nil then
      instr = instr .. ch
    end
    if (ch == "'" or ch == '"') and  prev ~= "\\" then
      if current_quote == ch then
        -- if you find ending quote insert the currently generated string into
        -- the ret table
        current_quote = nil
        table.insert(ret,instr)
        instr = ""
      elseif current_quote == nil then
        -- if you find beginning quote then start storing the characters
        current_quote = ch
        instr = instr .. ch
      end
    end
  end
  return ret
end

function syntax.sh(str)
  -- return green if first word is valid, else return red for said word
  local first_word = str:gmatch("(.-) ")() or str
  local b, f = str:find(first_word)
  -- either replace it with green or red
  if syntax.is_cmd(first_word) then
    str = colors.format("{green}" .. first_word .. "{white}" .. str:sub(f+1))
  else
    str = colors.format("{red}" .. first_word .. "{white}" .. str:sub(f+1))
  end
  -- strings should be yellow
  -- skip first word
  local after_first_word = str:match("( .*)")
  if after_first_word == nil then
    return str
  end
  -- loop through all strings and make them yellow

  for _, match in ipairs(syntax.is_sh_str(after_first_word)) do
    local findnext = syntax.findall(match)
    local val = findnext(str)
    while val ~= nil do
      if match ~= nil then
        str = colors.format(str:sub(0, val.b-1) .. "{yellow}" .. match .. "{white}" .. str:sub(val.f+1))
      end
      val = findnext(str)
    end
  end

  return str
end

function syntax.findall(match)
  local b = 0
  local f = -1
  return function(str)
    b, f = string.find(str, match, f+1)
    if b == nil then
      return nil
    end
    return {b=b, f=f}
  end
end

local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false",
                      "for", "function", "if","in", "local", "nil", "not", "or",
                      "repeat","return","then","true", "until","while"}
function syntax.lua(str)
  for _, keyword in ipairs(lua_keywords) do
    local findnext = syntax.findall(keyword)
    local val = findnext(str)
    while val ~= nil do
      if keyword ~= nil then
        str = colors.format(str:sub(0, val.b-1) .. "{magenta}" .. keyword .. "{white}" .. str:sub(val.f+1))
      end
      val = findnext(str)
    end
  end

  return str
end

return syntax
