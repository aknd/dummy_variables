module DummyVariables
  class DataDate
    WDAYS = { "0" => "sun", "1" => "mon", "2" => "tue", "3" => "wed", "4" => "thu", "5" => "fri", "6" => "sat" }

    attr_reader :date

    def initialize(date, vars)
      @date = date
      @vars = WDAYS.values.inject({}) { |h, e| h[e] = 0; h }
      @vars[WDAYS[Date.parse(@date).wday.to_s]] = 1
      @vars.merge! vars
      @vars.keys.each { |k| self.class.send(:define_method, k) { @vars[k] } }
    end

    def to_hash(keys=nil)
      keys = keys.nil? ? @vars.keys : keys.map(&:to_s) & @vars.keys
      keys.insert(0, "date")
      keys.inject({}) { |h, e| h[e] = send(e); h }
    end
  end
end
