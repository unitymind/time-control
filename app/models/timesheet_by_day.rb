class TimesheetByDay < ActiveRecord::Base
  belongs_to :employee
  has_many :time_events

  scope :in_period, lambda { |period| where(:day => period ).order('day') }
  scope :by_employee, lambda { |employee_id| where(:employee_id => employee_id) }
  scope :by_department, lambda { |department_id|
    where(:employee_id => Employee.where(:department_id => department_id).select('id').all.map { |m| m.id })
  }
  scope :late, where(:has_late => true).group(:day)
  scope :work, where(:no_work => false).group(:day)
end
