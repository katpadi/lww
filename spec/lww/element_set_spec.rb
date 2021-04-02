# frozen_string_literal: true

RSpec.describe Lww::ElementSet do

  subject(:lww_set) { Lww::ElementSet.new }

  describe '#add' do
    it 'adds element to adds (add-set)' do
      lww_set.add 'foo'
      lww_set.add 'bar'

      expect(lww_set.adds.size).to eql 2
      expect(lww_set.removals.size).to eql 0
      expect(lww_set.adds.to_a.map(&:data)). to contain_exactly 'foo', 'bar'
    end

    context 'when adding dup value & ts pair' do
      it 'ensures idempotency' do
        ts = Lww.ts
        lww_set.add 'foo', ts
        lww_set.add 'foo', ts
        expect(lww_set.adds.size).to eql 1
      end
    end

    context 'when adding dup value but different ts' do
      it 'adds element to adds (add-set)' do
        lww_set.add 'foo', Lww.ts
        lww_set.add 'bar', Lww.ts
        lww_set.add 'foo', Lww.ts
        expect(lww_set.adds.size).to eql 3
      end
    end
  end

  describe '#remove' do
    it 'adds element to removals (remove-set)' do
      lww_set.add 'foo'
      lww_set.add 'bar'
      lww_set.add 'foobar'

      lww_set.remove 'bar'

      expect(lww_set.removals.size).to eql 1
      expect(lww_set.adds.size).to eql 3
      expect(lww_set.removals.to_a.map(&:data)). to contain_exactly 'bar'
    end
  end

  describe '#contains?' do
    context 'when an element is in the merged set' do
      it 'returns true' do
        lww_set.add 'A'
        lww_set.add 'B'
        lww_set.add 'C'

        expect(lww_set.contains?('B')).to be_truthy
      end
    end

    context 'when an element is not in the merged set' do
      it 'returns false' do
        lww_set.add 'A'
        lww_set.add 'B'
        lww_set.add 'C'

        expect(lww_set.contains?('Z')).to be_falsey
      end
    end
  end

  # An element is a member of the LWW-Element-Set if it is in the add set,
  # and either not in the remove set, or in the remove set but with an
  # earlier timestamp than the latest timestamp in the add set.
  describe '#merge' do
    it 'returns a Set' do
      lww_set.add 'A'
      new_lww_set = lww_set.merge

      expect(new_lww_set).to be_a(Set)
    end

    it 'merges adds(add-set) and removals(remove-set) sets' do
      lww_set.add 'A'
      lww_set.add 'B'
      lww_set.add 'C'

      lww_set.remove 'A'

      expect(lww_set.merge.to_a). to contain_exactly 'B', 'C'
    end

    context 'when an element with a lower timestamp is removed' do
      it 'retains the element in the merge result' do
        ts = Lww.ts
        lww_set.add 'A', Lww.ts
        lww_set.add 'B', Lww.ts
        lww_set.remove 'A', ts
        lww_set.add 'C', Lww.ts

        expect(lww_set.merge.to_a). to contain_exactly 'A', 'B', 'C'
      end

      context 'when add and remove have the same timestamp' do
        it 'has bias towards add' do
          ts = Lww.ts
          lww_set.add 'A', ts
          lww_set.add 'C', Lww.ts
          lww_set.remove 'A', ts

          expect(lww_set.merge.to_a). to contain_exactly 'A', 'C'
        end
      end
    end
  end

  describe '#absorb!' do
    let(:lww_set2) { lww_set2 = Lww::ElementSet.new }

    before do
      lww_set.add 'foo'
      lww_set.add 'bar'
      lww_set.remove 'noop'
      lww_set2.add 'baz'
      lww_set2.remove 'xyzzy'
      lww_set.absorb! lww_set2
    end

    it 'returns correct # of elements' do
      expect(lww_set.adds.size).to eql 3
      expect(lww_set.removals.size).to eql 2
    end

    it 'changes adds and removals of absorber ElementSet' do
      expect(lww_set.adds.size).to eql 3
      expect(lww_set.removals.size).to eql 2

      expect(lww_set.adds.to_a.map(&:data)). to contain_exactly 'foo', 'bar', 'baz'
      expect(lww_set.removals.to_a.map(&:data)). to contain_exactly 'noop', 'xyzzy'
    end

    it 'does not change adds and removals of absorbed ElementSet' do
      expect(lww_set2.adds.to_a.map(&:data)). to contain_exactly 'baz'
      expect(lww_set2.removals.to_a.map(&:data)). to contain_exactly 'xyzzy'
    end
  end
end

