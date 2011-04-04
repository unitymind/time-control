class TimesheetByDayAddIndexOnDay < ActiveRecord::Migration
  def self.up
    add_index(:timesheet_by_days, :day)
  end

  def self.down
    remove_index(:timesheet_by_days, :column => :day)
  end
end
