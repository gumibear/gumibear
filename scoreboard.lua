love.state = require 'vendor/gamestate'
require 'vendor/json'

Scoreboard = {}

local HEADING_OFFSET = 30
local LINE_OFFSET = 20
local LINE_LIMIT = 400

local default_score = {
  1000,500,200,7,6,5,4,3,2,1
}

function comparescore(tbl, player_score)
  for i,v in ipairs(tbl) do
    if player_score > v then
      table.insert(tbl, i, player_score)
      table.remove(tbl, 11)
      break
    end
  end

  return tbl
end

function Scoreboard:enter(game, score)
  Scoreboard.x = love.window.getWidth() * 0.2
  Scoreboard.y = love.window.getHeight() * 0.1
  Scoreboard.width = love.window.getWidth() * 0.6
  Scoreboard.height = love.window.getHeight() * 0.8

  if love.filesystem.exists("score.txt") == false then
      love.filesystem.write("score.txt", json.encode(default_score))
  end

  top_scores = json.decode(love.filesystem.read("score.txt"))

  love.filesystem.write("score.txt", json.encode(comparescore(top_scores, score)));

  if DEBUG_MODE then
    table.foreach(top_scores, function(_index)
      print ("pos", _index, top_scores[_index])
    end)
  end

end

function Scoreboard:update(dt)

end

function Scoreboard:draw()
  love.graphics.setColor(56,57,59)
  love.graphics.rectangle("fill", Scoreboard.x, Scoreboard.y, Scoreboard.width, Scoreboard.height)
  love.graphics.setColor(255,255,255)
  love.graphics.printf("#### Game Over ####", love.window.getWidth() * 0.25, Scoreboard.y + HEADING_OFFSET, LINE_LIMIT, "center", 0, 1, 1.5)
  love.graphics.printf("Press \"Space\" to start again   ||   Press \"Esc\" to exit the game", love.window.getWidth() * 0.25, Scoreboard.y + HEADING_OFFSET * 2, LINE_LIMIT, "center")
  love.graphics.printf("** Top 10 Scores **", love.window.getWidth() * 0.25, Scoreboard.y + HEADING_OFFSET * 5, LINE_LIMIT, "center")

  local width = string.len(top_scores[1]) + 2
  table.foreach(top_scores, function(_index)
      local text= string.format("%" .. width-1 .. "s","#" .._index) .. "   ----   " .. string.format("%-" .. width .. "s",top_scores[_index])
      love.graphics.print(text, center(text), Scoreboard.y + (HEADING_OFFSET * 5.5) + (LINE_OFFSET * _index))
  end)
end

function center(text,number_limit)
    return (love.window.getWidth()*0.9/2)-(text:len())/2
end

function Scoreboard:keyreleased(key)

  if key == ' ' then
    love.state.switch(game)
  elseif key == "escape" then
    love.event.quit()
  end

end

