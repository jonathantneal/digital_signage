require 'spec_helper'

describe Slide do
  it { should belong_to :department }
  it { should have_many(:slots).dependent(:destroy) }
  it { should have_many(:schedules).dependent(:destroy) }
  it { should have_many(:signs) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :interval }
  it { should validate_presence_of :department_id }

end