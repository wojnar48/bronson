require 'active_support/inflector'
require_relative 'db_connection'
require_relative 'searchable'

class SQLObject extend Searchable
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

    data = DBConnection.execute(query)
    parse_all(data)
  end

  def self.parse_all(results)
    objects = []

    results.each do |row|
      attrs = {}
      attrs = symbolize_keys(row)
      objects << new(attrs)
    end

    objects
  end

  def self.find(id)
    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id}
      LIMIT
        1
    SQL

    attrs = DBConnection.execute(query)
    return if attrs.empty?
    attrs = symbolize_keys(attrs.first)
    new(attrs)
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
    self.class.columns.map do |attribute|
      send(attribute)
    end
  end

  def insert
    table_name = self.class.table_name
    col_names = self.class.columns.join(", ")
    q_marks = (["?"] * self.class.columns.length).join(", ")
    col_values = attribute_values

    DBConnection.execute(<<-SQL, *col_values)
      INSERT INTO
        #{table_name} (#{col_names})
      VALUES
        (#{q_marks})
    SQL

    inserted_id = DBConnection.last_insert_row_id
    self.id = inserted_id
  end

  def update
    table_name = self.class.table_name
    col_names = self.class.columns.map { |col_name| "#{col_name} = ?" }
    col_names = col_names.join(",")
    col_values = attribute_values
    record_id = self.id

    DBConnection.execute(<<-SQL, *col_values, record_id)
      UPDATE
        #{table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL

    inserted_id = DBConnection.last_insert_row_id
    self.id = inserted_id
  end

  def save
    self.attributes.empty? ? insert : update
  end

  def self.symbolize_keys(hash)
    new_hash = {}

    hash.each do |key, value|
      new_hash[key.to_sym] = value
    end

    new_hash
  end
end
