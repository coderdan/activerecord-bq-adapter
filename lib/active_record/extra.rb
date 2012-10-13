require 'active_record/extra/bq'

module ActiveRecord
  class Base
    extend ActiveRecord::Extra::BQ
  end
end
