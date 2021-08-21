local meta = require 'game/game_meta' -- Metatable da tabela new_game

new_game = {} -- Tabela para criação de novos jogos, normalmente chamada como new_game()

setmetatable(new_game, meta) -- Setar a metatable no new_game

--[[

information = {
    [game] = {
        jogadores = {
            [1] = {name = "Gustavo", score = 0, char = "x"},
            [2] = {name = "Angels", score = 0, char = "o"},
        }
    }
}

]]--