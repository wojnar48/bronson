require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.downcase.tableize if @table_name.nil?
    @table_name
  end

  def self.all
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
