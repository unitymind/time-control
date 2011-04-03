require 'spec_helper'

describe Employee do
  subject { Employee.new }

  it { should belong_to :department }
  it { should have_many :time_events }
  it { should have_many :timesheet_by_days }
end
