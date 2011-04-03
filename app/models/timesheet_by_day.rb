class TimesheetByDay < ActiveRecord::Base
  belongs_to :employee
  has_many :time_events
end
