module Searchable
  def where(params)
    table_name = self.table_name
    where_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")

    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    data = DBConnection.execute(query, params.values)
    self.parse_all(data)
  end
end
