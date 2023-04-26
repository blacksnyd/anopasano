class RemoveHistoryToPlayers < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :history
  end
end
