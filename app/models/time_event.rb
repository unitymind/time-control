class TimeEvent < ActiveRecord::Base
  IN = 0
  OUT = 1

  belongs_to :employee
  belongs_to :timesheet_by_day
end
