require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    return @columns unless @columns.nil?

    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        1
    SQL

    columns = DBConnection.execute2(query)
    @columns = columns.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method(col) { @attributes[col] }


      define_method("#{col}=".to_sym) do |val|
        @attributes ||= {}
        @attributes[col] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.downcase.tableize if @table_name.nil?
    @table_name
  end

  def self.all
    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
    SQL

    data = DBConnection.execute(<<-SQL)
    parse_all(data)
  end

  def self.parse_all(results)
  end

  def self.find(id)
  end

  def initialize(params = {})
    params.each do |param, val|
      if self.class.columns.include?(param)
        self.send("#{param}=", val)
      else
        raise "unknown attribute '#{param}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
  end

  def insert
  end

  def update
  end

  def save
  end

  def self.symbolize_keys(hash)
  end
end
