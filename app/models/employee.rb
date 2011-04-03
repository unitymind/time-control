class Employee < ActiveRecord::Base
  belongs_to :department
  has_many :time_events
  has_many :timesheet_by_days

  validates_uniqueness_of :name
end
