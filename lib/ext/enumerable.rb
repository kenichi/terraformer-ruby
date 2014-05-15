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
    loop {push shift; break if block[]}
  end

  def rotate_until_first_equals obj
    rotate_until { at[0] == obj }
  end

end
