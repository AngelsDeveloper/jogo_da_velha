local information = require 'information' -- Para salvar as informações de cada instância de jogo.
local inputs = require 'game/game_inputs'

local methods = {} -- Para salvar os métodos utilizados pelo game.

--------------------------------------------------------------------
--                            GRAPHICS                            --
--------------------------------------------------------------------

function methods:jump_lines(lines)
    lines = lines or 1

    for i = 1, lines do
        io.write("\n")
    end

    return true
end

function methods:opening_game()
    io.write("\t    ","=-=-=-=-=-=-=-=-=-=-=-=-=","\n")
    io.write("\t    ","=       TIC TAC TOE     =","\n")
    io.write("\t    ","=-=-=-=-=-=-=-=-=-=-=-=-=","\n")
end

--------------------------------------------------------------------
--                              BOARD                             --
--------------------------------------------------------------------

function methods:create_board()
    local boards = information[self].boards
    local _board = {{"⦁", "⦁", "⦁"}, {"⦁", "⦁", "⦁"}, {"⦁", "⦁", "⦁"}}

    local index = #boards + 1

    boards[index] = _board

    io.write("[create_board]: ","Tabuleiro criado com sucesso, ID: ", tostring(index), "\n")

    return index
end

function methods:print_board(index)
    local board = information[self].boards[index]

    if not board then
        io.write("[print_board]: ","Não existe nenhum tabuleiro no index: ", tostring(index), "\n")
        return false
    end

    io.write("\t\t\t","A B C","\n") 
    io.write("\t\t\t", "🠗 🠗 🠗", "\n")
	
	for height = 1, 3 do
        io.write("\t\t    ")
        io.write(height," ➞ ")
        print(table.concat(board[height], " "))
	end

    return true
end

function methods:set_position_board(index_board, index_player, height, width)
    local board = information[self].boards[index_board]
    local players = information[self].players
    
    if #players == 0 or not players[index_player] then
        io.write("[print_board]: ", "Erro no players, tente novamente, player: ", tostring(index_player), "\n") 
        return false
    end

    local player = players[index_player]
    
    if not board or not board[height][width] then
        io.write("[print_board]: ","Erro no tabuleiro, tente novamente, board: ", tostring(index_board), "\n")
        return false
    end

    if board[height][width] ~= "⦁" then
        io.write("[print_board]: ", "Esse espaço já está sendo ocupado", "\n")
        return false
    end

    io.write("[print_board]: ",string.format("Tabuleiro modificado com sucesso, altura: %s linha: %s", height, width), "\n")
    
    board[height][width] = player.char

    return true
end

function methods:verify_board()
   --asdasd
   --asdasd
   --asdasd
   --asdasd
end

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

--[[
    

    boards = 
    {
             X  X  X
        Y = {x, x, x}
        Y = {x, x, x}
        Y = {x, x, x}
    }

]]

--------------------------------------------------------------------
--                             PLAYERS                            --
--------------------------------------------------------------------

function methods:create_players() -- Método para criação dos jogadores
    local players = information[self].players -- Referência a informação dos Players da tabela informação.

    if #players == 0 then -- Verifica se existe elementos (players) dentro da tabela players (ref)

        for index = 1, 2 do -- Faz todo processo de criação de um Player, setando o nome como o próprio Index por padrão.
            players[index] = {} -- Criação da tabela do Player
            players[index].name = tostring(index) -- Criação do nome como o próprio Index (em string)
            players[index].score = 0 -- Criação do score com o valor por padrão 0
            if index == 1 then
                players[index].char = "x"
            else
                players[index].char = "o"
            end
        end

        return true -- Retorna true, para saber que a criação foi realizada com sucesso.

    else
        io.write("Já existem jogadores dentro desse game.")
        return false -- Retorna false, já que existem players dentro do game.
    end
end

function methods:get_name_players() -- Método para pegar o nome de todos jogadores
    local players = information[self].players -- Referência a informação dos Players da tabela informação.
    local ret = {} -- Conteúdo que vai ser retornado

    if #players == 0 then -- Verifica se existe elementos (players) dentro da tabela players (ref)
        return false -- Retorna false, já que não existe players dentro do game.
    end

    for index,tb in pairs(players) do -- Faz um laço de repetição na tabela players, pegando as informações dos jogadores (index/tabela)
        ret[index] = tb.name -- Seta a chave como index do player, e o name como valor.
    end

    return ret
end

function methods:get_score_players()
    local players = information[self].players -- Referência a informação dos Players da tabela informação.
    local ret = {} -- Conteúdo que vai ser retornado

    if #players == 0 then -- Verifica se existe elementos (players) dentro da tabela players (ref)
        return false -- Retorna false, já que não existe players dentro do game.
    end

    for index, tb in pairs(players) do -- Faz um laço de repetição na tabela players, pegando as informações dos jogadores (index/tabela)
        ret[index] = tb.score -- Seta a chave como index do player, e o score como valor.
    end

    return ret
end

function methods:get_players() -- Método para pegar todas informações dos jogadores.
    local players = information[self].players -- Referência a informação dos Players da tabela informação.
    local ret = {} -- Conteúdo que vai ser retornado

    if #players == 0 then
        return false
    end

    -- Objetivo é "dumpar" a tabela dos jogadores para o retorno.
    for index,tb in pairs(players) do -- Faz um laço de repetição na tabela players, pegando as informações dos jogadores (index/tabela)
        ret[index] = {} -- Cria uma tabela representando o jogador
        for key,value in pairs(tb) do -- Faz um laço dentro da tabela dos jogadores
            ret[index][key] = value -- Seta todos valores que tem dentro da tabela do jogador
        end
    end

    return ret -- Retorna a tabela dos jogadores "dumpada"
end

--------------------------------------------------------------------
--                              PLAYER                            --
--------------------------------------------------------------------

function methods:get_name_player(index) -- Método para pegar o nome do jogador de acordo com o index do mesmo.
    local player = information[self].players[index]

    if not player then
        return false
    end

    return player.name
end

function methods:get_score_player(index) -- Método para pegar o score do jogador de acordo com o index do mesmo.
    local player = information[self].players[index]

    if not player then
        return false
    end

    return player.score
end

--------------------------------------------------------------------
--                              INPUTS                            --
--------------------------------------------------------------------

function methods:input_name_players() -- Método para setagem do nome dos jogadores
    local players = information[self].players -- Referência a informação dos Players da tabela informação.

    if #players == 0 then
        return false
    end

    io.write("[set_name_players]: ","Minimo 3 caracteres para cada jogador.", "\n\n")

    for index = 1, 2 do -- Faz um laço de repetição para representar os jogadores, 1 e 2.
        repeat
            io.write(string.format("[set_name_players]: Escreva o nome do %s jogador: ", tostring(index)))
            players[index].name = io.read() -- Pede um Input para o Terminal dos Jogadores, para setagem do name.
        until players[index].name and #players[index].name >= 3 -- Verificação se o name foi setado corretamente e verificando o tamanho da string.
    end

    return true
end

function methods:input_position_board(index_player)
    local players = information[self].players
    local position = {
        arg = nil,
        first = nil, 
        second = nil
    }
    if #players == 0 or not players[index_player] then
        io.write("[print_board]: ", "Erro no players, tente novamente, player: ", tostring(index_player), "\n")
        return false
    end
    repeat
        repeat
            io.write("[input_local_board]: Exemplo de como deve ser: A1", "\n")
            io.write(string.format("[input_local_board]: Jogador %s qual posição você quer preencher?: ", tostring(index_player)))
            position.arg = io.read() -- Pede um Input para o Terminal dos Jogadores, para setagem do name.
        until position.arg and #position.arg == 2 -- Verificação se o name foi setado corretamente e verificando o tamanho da string.

        position.first = position.arg:sub(1, 1)
        position.second = position.arg:sub(2, 2)

        if inputs.first[position.first] and inputs.second[position.second] then
            break
        end
    until false

    return inputs.first[position.first], inputs.second[position.second]
end

return methods -- Retorna a referência da tabela dos métodos.