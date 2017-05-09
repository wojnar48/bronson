require 'active_support/inflector'
require_relative 'sql_object'

class AssocOptions
  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  attr_accessor :primary_key, :foreign_key, :class_name

  def initialize(name, options = {})
    defaults = {
      primary_key: :id,
      foreign_key: (name + '_id').to_sym,
      class_name: name.camelcase
    }

    defaults.merge!(options)
    @primary_key = defaults[:primary_key]
    @foreign_key = defaults[:foreign_key]
    @class_name = defaults[:class_name]
  end
end

class HasManyOptions < AssocOptions
  attr_accessor :primary_key, :foreign_key, :class_name

  def initialize(many_assoc, owner, options = {})
    defaults = {
      primary_key: :id,
      foreign_key: (owner.downcase + '_id').to_sym,
      class_name: many_assoc.singularize.camelcase
    }

    defaults.merge!(options)
    @primary_key = defaults[:primary_key]
    @foreign_key = defaults[:foreign_key]
    @class_name = defaults[:class_name]
  end
end
