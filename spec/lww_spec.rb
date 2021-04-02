# frozen_string_literal: true

RSpec.describe Lww do
  it 'has a version number' do
    expect(Lww::VERSION).not_to be nil
  end

  it 'generates 16-digit timestamp' do
    expect(Lww.ts.to_s.size).to eq 16
  end
end

