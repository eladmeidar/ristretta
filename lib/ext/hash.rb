class Hash
  def contains?(other_hash)
    self.merge(other_hash) == self
  end
end