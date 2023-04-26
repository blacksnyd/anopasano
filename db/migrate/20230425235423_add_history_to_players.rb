class AddHistoryToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :history, :text
  end
end
