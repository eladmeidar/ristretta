class Hash
  def contains?(other_hash)
    self.merge(other_hash) == self
  end

  def symbolize_keys!
    new_hash = {}
    self.each_pair do |key, v|
      new_hash[key.to_sym] = v
    end
    new_hash
  end
end