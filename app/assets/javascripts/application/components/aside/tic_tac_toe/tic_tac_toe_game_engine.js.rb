class TicTacToeGameEngine

  MAX_DEPTH = 4000 # Iterations

  attr_reader :winner, :result

  LINES = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ]

  def initialize
    @last_start_computer = true
    @result = [nil, nil]
    start_new_game
  end

  def start_new_game
    @last_start_computer = !@last_start_computer
    @player_turn         = @last_start_computer
    @winner              = nil
    @board_state         = Array.new(9)
  end

  def finished?
    !@winner.nil? || tie?(@board_state)
  end

  def tie?(board)
    board.all? { |cell| !cell.nil? }
  end

  def start?
    @board_state.all? { |cell| cell.nil? }
  end

  def my_first_move?
    @board_state.select { |cell| cell == :c }.length == 0
  end

  def player_turn?
    @player_turn
  end

  def computer_turn?
    !@player_turn
  end

  def player_move(move)
    if player_turn? && !finished? && @board_state[move].nil?
      make_move(move, :p)
    else
      nil
    end
  end

  def computer_move
    if computer_turn? && !finished?
      move = calculate_computer_move
      make_move(move, :c)
    else
      nil
    end
  end

  def make_move(move, who)
    if move
      @board_state[move] = who
      @winner = determine_winner(@board_state)
      @player_turn = !@player_turn
    end

    move
  end

  def determine_winner(board)
    LINES.each do |line|
      return :p if winning_line(board, line, :p)
      return :c if winning_line(board, line, :c)
    end

    nil
  end

  def winning_line(board, line, who)
    line.all? { |i| board[i] == who }
  end

  def calculate_computer_move
    move = if start?
      opening_move
    elsif my_first_move?
      reply1
    else
      start_minmax
    end

    move || @board_state.find_index {|s| s.nil? }
  end

  def opening_move
    @result = [1, 'win']

    r = `Math.random()`

    if r < 0.5
      4
    else
      case (r * 4.0).ceil
      when 1
        0
      when 2
        2
      when 3
        6
      else
        8
      end
    end
  end

  def reply1
    @result = [1, 'tie']

    [4, 8, 6, 2, 0].each do |i|
      return i if @board_state[i].nil?
    end
  end

  def start_minmax
    @iterations = 0
    @best_choice = nil
    score = minmax(@board_state, :c)

    @result = [
      @iterations,
      score == 0 ? 'tie' : (score > 0 ? 'win' : 'lose')
    ]

    @best_choice
  end

  # Everything below this line is based on:
  # https://github.com/markphelps/tictac
  # Copyright (c) 2015 Mark Phelps
  # MIT License
  def minmax(board, player)
    winner = determine_winner(board)

    if @iterations >= MAX_DEPTH || winner || tie?(board)
      score(winner)
    else
      @iterations += 1

      scores = {}

      board.each_with_index do |space, i|
        if space.nil?
          potential_board = board.dup
          potential_board[i] = player

          # Recurse
          scores[i] = minmax(potential_board, switch(player) )
        end
      end

      @best_choice, best_score = best_move(player, scores)

      best_score
    end
  end

  def best_move(piece, scores)
    if piece == :c
      scores.max_by { |_, v| v }
    else
      scores.min_by { |_, v| v }
    end
  end

  def score(winner)
    case winner
    when :c
       1
    when :p
      -1
    else
       0
    end
  end

  def switch(player)
    player == :p ? :c : :p
  end
end