# frozen_string_literal: true

module Lww
  class ElementSet

  attr_reader :adds, :removals
    def initialize
      @adds = Set.new
      @removals = Set.new
    end

    def add(value, ts = Lww.ts)
      @adds << Element.new(value, ts)
    end

    def remove(value, ts = Lww.ts)
      @removals << Element.new(value, ts)
    end

    def contains?(value)
      merged.include? value
    end

    def merge
      merged_elements = @adds.select do |add_element|
        !@removals.find do |remove_element|
          remove_element.data == add_element.data && remove_element.ts > add_element.ts
        end
      end.map(&:data)

      Set.new(merged_elements)
    end
    alias_method :merged, :merge

    def absorb!(other_element_set)
      @adds.merge other_element_set.adds
      @removals.merge other_element_set.removals
    end
  end
end
