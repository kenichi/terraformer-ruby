class Array

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

  def slice_exists? slice
    start = slice.first
    len = slice.size
    each_with_index do |e, i|
      return true if e == start && self[i,len] == slice
    end
    false
  end

  def to_c
    Terraformer::Coordinate.from_array self
  end

end
