class RenameTable < ActiveRecord::Migration
  def change
    rename_table :newsletter_newsletters, :newsletter_mail_templates
  end
end
