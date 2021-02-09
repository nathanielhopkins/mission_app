class AddCheersToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cheers, :integer, default: 12
  end
end
