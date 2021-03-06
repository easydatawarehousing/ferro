---
lang:     EN
page:     tic-tac-toe
title:    TicTacToe
subtitle: Let's play a game
aside:    tictactoe
---

The TicTacToe component defines a new-game button, the scores and
the actual game board.

~~~ ruby
class TicTacToe < Ferro::Component::Base

  def cascade
    add_child :title,    Ferro::Element::Text, size: 4, content: 'Tic Tac Toe'
    add_child :new_game, NewGameButton, content: 'New game', disabled: true
    add_child :board,    Board
    add_child :score,    Score

    score.show
    board.start_new_game
  end
end

class NewGameButton < Ferro::Form::Button
  def clicked
    disable
    parent.board.start_new_game
  end
end
~~~

__Show game results__  
The \'Player wins\' line may be omitted since the
computer is unbeatable. At least at this game.

~~~ ruby
class Score < Ferro::Element::Block

  def cascade
    add_child :games,    Ferro::Element::Text
    add_child :player,   Ferro::Element::Text
    add_child :computer, Ferro::Element::Text
    add_child :draws,    Ferro::Element::Text
    add_child :result,   Ferro::Element::Text, class: 'result'

    @total = @player = @computer = @draws = 0
  end

  def show
    games.set_text    "Games played: #{@total}"
    player.set_text   "Player wins: #{@player}"
    computer.set_text "Computer wins: #{@computer}"
    draws.set_text    "Draws: #{@draws}"
  end

  def add_win(who)
    @total += 1

    if who == :p
      @player += 1
      result.set_text 'Player won!'
    elsif who == :c
      @computer += 1
      result.set_text 'Computer won!'
    else
      @draws += 1
      result.set_text 'Draw!'
    end

    show
  end
end
~~~

__The game board__  
Note that the logic for calculating the computers move
is in a separate (non Ferro) class: TicTacToeGameEngine
sourcecode can be found [here](https://github.com/easydatawarehousing/ferro/blob/master/app/assets/javascripts/application/components/aside/tic_tac_toe/tic_tac_toe_game_engine.js.rb).

~~~ ruby
class Board < Ferro::Element::Block

  def cascade
    9.times do |i|
      add_child "c#{i}", Cell, content: ' ', index: i
    end

    @game = TicTacToeGameEngine.new
  end

  def start_new_game
    if @game.start? || @game.finished?
      clear_board
      @game.start_new_game
      computer_move if @game.computer_turn?
    end
  end

  def player_move(index)
    move = @game.player_move(index)

    if move
      @children["c#{move}"].update_state :player, true
      finish_game
      computer_move
    end
  end

  def computer_move
    move = @game.computer_move

    if move
      @children["c#{move}"].update_state :computer, true

      parent.score.result.set_text(
        "Iterations: #{@game.result[0]} (#{@game.result[1]})"
      )

      finish_game
    end
  end

  def finish_game
    if @game.finished?
      parent.score.add_win(@game.winner)
      parent.new_game.enable
    end
  end

  def clear_board
    @children.each do |_, cell|
      cell.update_state :player, false
      cell.update_state :computer, false
    end

    parent.score.result.set_text ''
  end
end
~~~

__Board cells__  
Cells are defined as buttons. Every button has 2 states added to show
if the player or the computer owns the cell.

~~~ ruby
class Cell < Ferro::Form::Button
  def before_create
    @index = option_replace :index
  end

  def after_create
    add_state :player
    add_state :computer
  end

  def clicked
    parent.player_move @index
  end
end
~~~
