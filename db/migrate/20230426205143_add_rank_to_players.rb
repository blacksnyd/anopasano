class AddRankToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :rank, :string
  end
end
