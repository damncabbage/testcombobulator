class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :email
      t.string :name
      t.string :url_base
      t.string :git
    end
  end
end
