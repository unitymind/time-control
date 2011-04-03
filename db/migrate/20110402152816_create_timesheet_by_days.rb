class CreateTimesheetByDays < ActiveRecord::Migration
  def self.up
    create_table :timesheet_by_days do |t|
      t.references :employee, :null => false
      t.date :day
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :has_late
      t.integer :late_value, :default => 0
      t.integer :work_time, :default => 0
      t.boolean :no_work, :default => true
    end

    add_index(:timesheet_by_days, [:employee_id, :day], :unique => true)
  end

  def self.down
    drop_table(:timesheet_by_days)
  end
end
