class CreateArchitects < ActiveRecord::Migration
  def self.up
    create_table :architects do |t|
      t.string :first_name, :last_name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :architects
  end
end
