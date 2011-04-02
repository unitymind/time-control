require 'spec_helper'

describe Employee do
  subject { Employee.new }

  it { should belong_to :department }
end
