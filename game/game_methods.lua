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

--[[

information = {
    [game] = {
        jogadores = {
            [1] = {name = "Gustavo", score = 0, char = "x"},
            [2] = {name = "Angels", score = 0, char = "o"},
        }
        tabuleiros = {
            [1] = {
                {"⦁", "⦁", "⦁"}, 
                {"⦁", "⦁", "⦁"}, 
                {"⦁", "⦁", "⦁"}
            },
            [2] = {
                {"⦁", "⦁", "⦁"}, 
                {"⦁", "⦁", "⦁"}, 
                {"⦁", "⦁", "⦁"}
            }
        }
    }
}

]]--

function methods:check_draw_board(index_board)
    local boards = information[self].boards
    local players = information[self].players
    local lines = {
        [1] = false,
        [2] = false,
        [3] = false
    }

    if #players == 0 and #boards == 0 then
        io.write("[check_draw_board]: Não existe players/boards no seu game.")
        return false
    end

    local board = boards[index_board]

    if not board then
        io.write("[check_draw_board]: Não existe o board index: ", tostring(index_board))
        return false
    end

    --[[ 
        Esse for inteiro, vai servir para acessar cada posição do board
        se alguma ainda tiver vazia, então não deu velha.
    ]]

    for line = 1, 3 do 
        for column = 1, 3 do
            if board[line][column] == "⦁" then
                return false
            end
        end
    end

    return true
end

function methods:check_win_board(index_board)
    local boards = information[self].boards
    local players = information[self].players

    if #players == 0 and #boards == 0 then
        io.write("[check_win_board]: Não existe players/boards no seu game.")
        return false
    end

    local board = boards[index_board]

    if not board then
        io.write("[check_win_board]: Não existe o board index: ", tostring(index_board))
        return false
    end

    for p = 1, 2 do -- Players
        for i = 1, 3 do
            if board[i][1] == players[p].char and board[i][2] == players[p].char and board[i][3] == players[p].char then -- VERIFICAÇÂO VERTICAL

                local player_index = self:get_player_with_char(board[i][1]) -- Pegar o Jogador de acordo com o caracter
                players[player_index].score = players[player_index].score + 1 -- Incrementar o Score do Jogador que venceu
                return true, player_index -- Retornar true, o index do Player de acordo com o caracter

            elseif board[1][i] == players[p].char and board[2][i] == players[p].char and board[3][i] == players[p].char then -- VERIFICAÇÂO HORIZONTAL

                local player_index = self:get_player_with_char(board[1][i]) -- Pegar o Jogador de acordo com o caracter
                players[player_index].score = players[player_index].score + 1 -- Incrementar o Score do Jogador que venceu
                return true, player_index -- Retornar true, o index do Player de acordo com o caracter
            
            end
        end

        if board[1][1] == players[p].char and board[2][2] == players[p].char and board[3][3] == players[p].char then -- VERIFICAÇÂO CRUZADA
            
            local player_index = self:get_player_with_char(board[1][1]) -- Pegar o Jogador de acordo com o caracter
            players[player_index].score = players[player_index].score + 1 -- Incrementar o Score do Jogador que venceu
            return true, player_index -- Retornar true, o index do Player de acordo com o caracter

        elseif board[1][3] == players[p].char and board[2][2] == players[p].char and board[3][1] == players[p].char then -- VERIFICAÇÂO CRUZADA

            local player_index = self:get_player_with_char(board[1][3]) -- Pegar o Jogador de acordo com o caracter
            players[player_index].score = players[player_index].score + 1 -- Incrementar o Score do Jogador que venceu
            return true, player_index -- Retornar true, o index do Player de acordo com o caracter
            
        end
    end
    
    return false
end

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
        io.write("[set_position_board]: ", "Erro no players, tente novamente, player: ", tostring(index_player), "\n") 
        return false
    end

    local player = players[index_player]
    
    if not board or not board[height][width] then
        io.write("[set_position_board]: ","Erro no tabuleiro, tente novamente, board: ", tostring(index_board), "\n")
        return false
    end

    if board[height][width] ~= "⦁" then
        io.write("[set_position_board]: ", "Esse espaço já está sendo ocupado", "\n")
        return false
    end

    io.write("[set_position_board]: ",string.format("Tabuleiro modificado com sucesso, altura: %s linha: %s", height, width), "\n")
    
    board[height][width] = player.char

    return true
end

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
    local players = information[self].players

    if #players == 0 then
        io.write("[get_name_player]: Não existe players no seu game.")
        return false
    end

    local player = players[index]

    if not player then
        io.write("[get_name_player]: Não existe um player no index: ", tostring(index))
        return false
    end

    return player.name
end

function methods:get_score_player(index) -- Método para pegar o score do jogador de acordo com o index do mesmo.
    local players = information[self].players

    if #players == 0 then
        io.write("[get_score_player]: Não existe players no seu game.")
        return false
    end

    local player = players[index]

    if not player then
        io.write("[get_score_player]: Não existe um player no index: ", tostring(index))
        return false
    end

    return player.score
end

function methods:get_player_with_char(char)
    local players = information[self].players

    if #players == 0 then
        io.write("[get_player_with_char]: Não existe players no seu game.")
        return false
    end

    for i = 1, 2 do
        if players[i].char == char then
            return i
        end
    end

    return false
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
        io.write("[input_local_board]: ", "Erro no players, tente novamente, player: ", tostring(index_player), "\n")
        return false
    end
    repeat
        repeat
            io.write("[input_local_board]: Opções: (A1, A2, A3) - (B1, B2, B3) - (C1, C2, C3)", "\n")
            io.write(string.format("[input_local_board]: %s qual posição você quer preencher?: ", self:get_name_player(index_player)))
            position.arg = io.read() -- Pede um Input para o Terminal dos Jogadores, para setagem do name.
        until position.arg and #position.arg == 2 -- Verificação se o name foi setado corretamente e verificando o tamanho da string.

        position.first = position.arg:sub(1, 1)
        position.second = position.arg:sub(2, 2)

        if inputs.second[position.second] and inputs.first[position.first]then
            break
        end
    until false

    return inputs.second[position.second], inputs.first[position.first]
end

return methods -- Retorna a referência da tabela dos métodos.