class Rails;
  def self.cache;
    @@cache ||= Cache.new
  end
end
