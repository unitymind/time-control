class CreateTimeEvents < ActiveRecord::Migration
  def self.up
    create_table :time_events do |t|
      t.references :employee, :null => false
      t.references :timesheet_by_day, :null => false
      t.datetime :event_time
      t.integer :event_type, :length => 1
    end

    add_index(:time_events, :employee_id)
    add_index(:time_events, :event_time)
  end

  def self.down
    drop_table :time_events
  end
end
