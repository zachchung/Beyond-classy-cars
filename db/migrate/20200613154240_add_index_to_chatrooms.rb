class AddIndexToChatrooms < ActiveRecord::Migration[6.0]
  def change
    add_column :chatrooms, :index, :integer
  end
end
