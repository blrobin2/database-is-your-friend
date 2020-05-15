class CreateComments < ActiveRecord::Migration[6.0]
  def change
    # create_table :comments do |t|
    #   t.text :body, null: false
    #   t.references :commentable, polymorphic: true
    #   t.timestamps
    # end

    %i[author book].each do |parent|
      table_name = :"#{parent}_comments"

      create_table table_name do |t|
        t.references parent, null: false
        t.text :body, null: false
        t.timestamps
      end

      add_foreign_key table_name, parent.to_s.pluralize
    end
  end
end
