class CreateRemotePages < ActiveRecord::Migration
  def change
    create_table :remote_pages do |t|
      t.text :html_content
      t.string :url

      t.timestamps null: false
    end
  end
end
