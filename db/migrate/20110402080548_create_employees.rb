class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name, :null => false
      t.references :department
    end

    add_index(:employees, :department_id)
  end

  def self.down
    drop_table :employees
  end
end
