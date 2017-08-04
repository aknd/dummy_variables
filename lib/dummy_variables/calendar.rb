require "date"
require "csv"
require "yaml"
require "json"
require "deep_merge"
require "dummy_variables/data_date"

module DummyVariables
  class Calendar
    attr_reader :dates

    def initialize(start_date, end_date, date_format="%Y-%m-%d", config_data: {}, config_file: "")
      custom_dates = config_file.to_s.empty? ? {} : load_config_file(config_file)
      custom_dates.deep_merge! config_data if config_data.is_a?(Hash)
      @dates = (Date.parse(start_date)..Date.parse(end_date)).map do |date|
        vars = {}
        custom_dates.each do |k, v|
          next unless v.key? "dates"
          vars[k] = v["dates"].map { |d| d.is_a?(Date) ? d : Date.parse(d) }.include?(date) ? 1 : 0
        end
        DummyVariables::DataDate.new(date.strftime(date_format), vars)
      end
    end

    def to_csv_str(columns=nil, encoding: "Shift_JIS", options: {})
      options[:headers] = @dates.size == 0 ? [] : @dates[0].to_hash(columns).keys
      options[:write_headers] = true unless options.key?(:write_headers)
      CSV.generate(options) { |csv|
        @dates.each { |data_date| csv << data_date.to_hash(columns).values }
      }.encode(encoding, invalid: :replace, undef: :replace)
    end

    private

    def load_config_file(config_file)
      begin
        case File.extname(config_file)
        when ".yml", ".yaml"
          YAML.load_file(config_file)
        when ".json"
          File.open(config_file) { |file| JSON.load(file) }
        else
          raise "configuration file needs to be formatted as JSON or YAML"
        end
      rescue => e
        p e.message; {}
      end
    end
  end
end
