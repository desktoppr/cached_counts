class Scope
  attr_accessor :model_name, :to_sql
  def initialize(model_name)
    @model_name = model_name
    @to_sql     = 'sql'
  end
end
