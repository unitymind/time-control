require 'spec_helper'

describe TimeEvent do
  subject { TimeEvent.new }

  it { should belong_to :employee }
  it { should belong_to :timesheet_by_day }
end
