class AddEmailToSign < ActiveRecord::Migration
  def change
    add_column :signs, :email, :string
    add_column :signs, :email_sent, :datetime
  end
end
