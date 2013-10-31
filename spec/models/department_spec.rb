require 'spec_helper'

describe Department do
  it { should have_many(:signs).dependent(:destroy) }
  it { should have_many(:slides).dependent(:destroy) }
  it { should have_many(:department_users).dependent(:destroy) }
  it { should have_many(:users) }

  it { should validate_presence_of :title }

end