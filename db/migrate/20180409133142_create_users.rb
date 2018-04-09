class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :fastName
      t.string :lastName
      t.string :email
      t.string :phone
      t.string :aboutMe

      t.timestamps
    end
  end
end
