class Hash

  unless instance_methods.include? :only
    # same as select_with_keys without forcing `Symbol` usage
    #
    def only *ks
      ks = ks.compact.uniq
      select {|k,v| ks.include? k}
    end
  end

  unless instance_methods.include? :not
    # same as select_without_keys without forcing `Symbol` usage
    #
    def not *ks
      ks = ks.compact.uniq
      select {|k,v| !ks.include? k}
    end
  end

end
