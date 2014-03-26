require 'spec_helper'

describe Survey do
  it { should have_many :questions }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(47) }
end

