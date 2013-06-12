class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
	  t.string :password
	  t.string :fname
	  t.string :lname
      t.string :phnumber
      t.string :email
	  t.timestamps
    end
    add_index :people, :name
  end

  def self.down
    drop_table :people
  end
end
