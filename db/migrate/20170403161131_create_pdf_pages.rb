class CreatePdfPages < ActiveRecord::Migration[5.0]
  def change
    create_table :pdf_pages do |t|
      t.integer :page
      t.string :path
      t.references :pdf, foreign_key: true

      t.timestamps
    end
  end
end
