# LWW

Implements a 'Last Write Wins' CRDT where merge takes the element with highest timestamp.

> An alternative LWW-based approach,6 which we call LWW-element-Set (see Figure 12), attaches a timestamp to each element (rather than to the whole set, as in Figure 8). Consider add-set A and remove-set R, each containing (element,timestamp) pairs. To add (resp. remove) an element e, add the pair (e, now()), where now was specified earlier, to A (resp. to R). Merging two replicas takes the union of their add-sets and remove-sets. An element e is in the set if it is in A, and it is not in R with a higher timestamp:

Formula for lookup:
```
lookup(e) = ∃ t, ∀ t 0 > t: (e,t) ∈ A ∧ (e,t0) / ∈ R)
```

Since it is based on LWW, this data type is convergent.
## Limitations
Bias is towards preserving adds only.

## Installation

Install it locally:

```
gem build lww.gemspec
gem install lww-0.1.0.gem
```

Then use it in irb:
```
>> require 'lwww'
>> lww = Lww::ElementSet.new
>> lww.add "Hello"
 => #<Set: {#<struct Lww::Element data="Hello", ts=1617333851839483>}>
```
## Usage
To initialize an ElementSet:
```
lww = Lww::ElementSet.new
```
To add:
```
lww.add "foo"
lww.add "bar"
```
To remove:
```
lww.remove "foo"
```
To merge:
```
lww.merge
```
To absorb:
```
lww2 = Lww::ElementSet.new
lww2.add "foo_from_another_set"
lww.absorb! lww2
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katpadi/lww. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lww project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/katpadi/lww/blob/master/CODE_OF_CONDUCT.md).
