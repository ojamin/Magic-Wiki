class AddGeneratedToWikiItem < ActiveRecord::Migration
  def self.up
    add_column :wiki_items, :generated, :text
  end

  def self.down
    remove_column :wiki_items, :generated
  end
end
