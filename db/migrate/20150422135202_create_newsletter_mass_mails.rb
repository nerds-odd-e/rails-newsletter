class CreateNewsletterMassMails < ActiveRecord::Migration
  def change
    create_table :newsletter_mass_mails do |t|
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
