class AddNameToNewsLetterMailTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :newsletter_mail_templates, :name, :string
  end
end
