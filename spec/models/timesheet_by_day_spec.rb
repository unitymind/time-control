require 'spec_helper'

describe TimesheetByDay do
  subject { TimesheetByDay.new }

  it { should belong_to :employee }
  it { should have_many :time_events }
end
