class Cache < Hash
  # A regular hash will raise a KeyError when we try to fetch a key that does
  # not exist
  def fetch(*args)
    super rescue nil
  end

  def write(key, value)
    self[key] = value
  end
end
