require 'spec_helper'

describe Department do
  subject { Department.new }

  it { should have_many(:employees) }
end
