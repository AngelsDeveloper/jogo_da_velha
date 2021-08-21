local information = require 'information' -- Para salvar as informações de cada instância de jogo.
local methods = require 'game/game_methods' -- Para salvar os métodos de manipulação das informações

local meta = {} -- Criação da tabela meta

function meta.__call() -- Caso chame o new_game(), essa função será chamada
    local _game = {} -- Faz uma nova instância

    information[_game] = { -- Cria as informações da instância
        players = {},
        boards = {},
    } 

    setmetatable(_game, {
        __index = methods -- Indexa os métodos de manipulação de informação na instância
    })

    io.write("[new_game]: true", "\n")

    return _game -- Retorna a instância criada
end

return meta -- Retornando a referência da tabela meta