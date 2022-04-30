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

function syntax.is_cmd(str)
  if hilbish.which(str) ~= nil then
    return true
  end

  -- i dont know how to see what stuff is buildin keywords so lets just use a
  -- raw table idk
  local keywords = { "cd", "exit", "doc", "guide", "cdr" }
  if syntax.contains(keywords, str) then
     return true
   end
  return false
end

function syntax.is_sh_str(str)
  return str:gmatch('[^\\](".-[^\\]")')
end

function syntax.sh(str)
  -- return green if first word is valid, else return red for said word
  local first_word = str:gmatch("(.-) ")() or str
  local _, f = str:find(first_word)
  -- either replace it with green or red
  if syntax.is_cmd(first_word) then
    str = colors.format("{green}" .. first_word .. "{white}" .. str:sub(f+1))
  else
    str = colors.format("{red}" .. first_word .. "{white}" .. str:sub(f+1))
  end
  -- strings should be yellow?
  -- skip first word
  local after_first_word = str:match("( .*)")
  if after_first_word == nil then
    return str
  end
  for match in syntax.is_sh_str(after_first_word) do
    local b, f = str:find(match)
    if match ~= nil then
      str = colors.format(str:sub(0, b-1) .. "{yellow}" .. match .. "{white}" .. str:sub(f+1))
    end
  end

  return str
end

return syntax
