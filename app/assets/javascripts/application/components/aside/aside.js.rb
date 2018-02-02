# require 'application/ferro/components/ferro'

class Aside < FerroElementAside

  def cascade
    add_child :demo,      Demo
    add_child :log,       EventLog
    add_child :todo,      Todo
    add_child :tictactoe, TicTacToe
    
    add_state :hidden
  end
end