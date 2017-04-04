class CreatePdfs < ActiveRecord::Migration[5.0]
  def change
    create_table :pdfs do |t|
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
