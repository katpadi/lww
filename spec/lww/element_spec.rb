# frozen_string_literal: true

RSpec.describe Lww::Element do

  let(:ts) { Lww.ts }
  subject(:element) { Lww::Element.new 'lelz', ts }

  describe '#initialize' do
    it 'initializes data and ts' do
      expect(element.data).to eq 'lelz'
      expect(element.ts).to eq ts
    end
  end
end
