class Employee < ActiveRecord::Base
  belongs_to :department
  has_many :time_events
  has_many :timesheet_by_days

  validates_uniqueness_of :name

  scope :by_department, lambda { |department_id| where(:department_id => department_id) }
end
