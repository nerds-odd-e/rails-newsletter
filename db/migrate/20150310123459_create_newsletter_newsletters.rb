class CreateNewsletterNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletter_newsletters do |t|
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
