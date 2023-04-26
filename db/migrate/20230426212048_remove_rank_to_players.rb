class RemoveRankToPlayers < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :rank
  end
end
