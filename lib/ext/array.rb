class Array

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
