module Enumerable

  def each_coordinate opts = {}, &block
    iter_coordinate :each, opts, &block
  end

  def map_coordinate opts = {}, &block
    iter_coordinate :map, opts, &block
  end
  alias_method :collect_coordinate, :map_coordinate

  def map_coordinate! opts = {}, &block
    iter_coordinate :map!, opts, &block
  end
  alias_method :collect_coordinate!, :map_coordinate!

  def iter_coordinate meth, opts = {}, &block
    opts[:recurse] = true if opts[:recurse].nil?

    if Array === self and Numeric === self[0]
      yield self
    else

      self.__send__ meth do |pair|
        raise IndexError unless Array === pair
        case pair[0]
        when Numeric
          yield pair
        when Array
          pair.iter_coordinate meth, opts, &block if opts[:recurse]
        else
          raise IndexError.new "#{pair[0]} is not a Numeric or Array type"
        end
      end
    end
  end

  def rotate_until &block
    return if block[]
    found = false
    length.times do
      push shift
      if block[]
        found = true
        break
      end
    end
    raise IndexError unless found
  end

  def rotate_until_first_equals obj
    rotate_until { at(0) == obj }
  end

  def polygonally_equal_to? obj
    raise ArgumentError unless Enumerable === obj
    return false if self.length != obj.length

    equal = true

    # clone so can pop/rotate
    me = self.clone
    obj = obj.clone

    # pop to drop the duplicate, polygon-closing, coordinate
    me.pop
    obj.pop

    begin
      obj.rotate_until_first_equals me[0]
      equal = me == obj
    rescue IndexError
      equal = false
    end

    equal
  end

end
