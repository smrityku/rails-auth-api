class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :role, default: 0, null: false
      t.string :otp
      t.datetime :otp_sent_at

      t.timestamps
    end
  end
end
