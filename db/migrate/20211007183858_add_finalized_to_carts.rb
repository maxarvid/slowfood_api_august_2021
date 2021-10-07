class AddFinalizedToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :finalized, :boolean, default: false
  end
end
