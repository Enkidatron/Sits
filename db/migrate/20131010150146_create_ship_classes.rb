class CreateShipClasses < ActiveRecord::Migration
  def change
    create_table :ship_classes do |t|
      t.string :name

      t.timestamps
    end
  end
end
