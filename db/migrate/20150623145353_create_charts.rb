class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :name
      t.text :description
      t.integer :user_id
    end
    create_table :slices do |t|
      t.string :name
      t.integer :chart_id
      t.integer :percent
    end

  end
end
