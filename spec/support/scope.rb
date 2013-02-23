class Scope
  attr_accessor :table_name, :to_sql
  def initialize(table_name)
    @table_name = table_name
    @to_sql     = "select * from #{table_name}"
  end
end
