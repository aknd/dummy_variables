# DummyVariables

DummyVariables is a gem that generates dummy variables like 'if holiday then 1 else 0', 'if sunday then 1 else 0', etc. for each date.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dummy_variables'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dummy_variables

## Usage

```ruby
require "dummy_variables"
```

```ruby
cal = DummyVariables::Calendar.new("20140101", "20151231")
File.open("cal.csv", "w") { |file| file.write(cal.to_csv_str) }
```

    $ head cal.csv

```
date,sun,mon,tue,wed,thu,fri,sat
2014-01-01,0,0,0,1,0,0,0
2014-01-02,0,0,0,0,1,0,0
2014-01-03,0,0,0,0,0,1,0
2014-01-04,0,0,0,0,0,0,1
2014-01-05,1,0,0,0,0,0,0
2014-01-06,0,1,0,0,0,0,0
2014-01-07,0,0,1,0,0,0,0
2014-01-08,0,0,0,1,0,0,0
2014-01-09,0,0,0,0,1,0,0
```

```ruby
cal = DummyVariables::Calendar.new("20140101", "20151231", "%Y/%m/%d") # add date format

File.open("cal.csv", "w") do |file|
  file.write(
    cal.to_csv_str(
      [:sat, :sun], # select columns
      options: { # add options
        :write_headers => false,
        :force_quotes => true
      }
    )
  )
end
```

    $ head cal.csv

```
"2014/01/01","0","0"
"2014/01/02","0","0"
"2014/01/03","0","0"
"2014/01/04","1","0"
"2014/01/05","0","1"
"2014/01/06","0","0"
"2014/01/07","0","0"
"2014/01/08","0","0"
"2014/01/09","0","0"
"2014/01/10","0","0"
```

```
$ cat <<EOF > config_file.yml
holiday:
  dates:
    - 2014-01-01
    - 2014-01-13
    - 2014-02-11
    - 2014-03-21
    - 2014-04-29
    - 2014-05-03
    - 2014-05-04
    - 2014-05-05
    - 2014-05-06
    - 2014-07-21
    - 2014-09-15
    - 2014-09-23
    - 2014-10-13
    - 2014-11-03
    - 2014-11-23
    - 2014-11-24
    - 2014-12-23
    - 2015-01-01
    - 2015-01-12
    - 2015-02-11
    - 2015-03-21
    - 2015-04-29
    - 2015-05-03
    - 2015-05-04
    - 2015-05-05
    - 2015-05-06
    - 2015-07-20
    - 2015-09-21
    - 2015-09-22
    - 2015-09-23
    - 2015-10-12
    - 2015-11-03
    - 2015-11-23
    - 2015-12-23
break:
  dates:
    - 2014-01-02
    - 2014-01-03
    - 2014-08-13
    - 2014-08-14
    - 2014-08-15
    - 2014-12-29
    - 2014-12-30
    - 2014-12-31
    - 2015-01-02
    - 2015-08-13
    - 2015-08-14
    - 2015-12-29
    - 2015-12-30
    - 2015-12-31
EOF
```

```ruby
cal = DummyVariables::Calendar.new("20140101", "20151231", config_file: "config_file.yml")
File.open("cal.csv", "w") { |file| file.write(cal.to_csv_str) }
```

    $ head cal.csv

```
date,sun,mon,tue,wed,thu,fri,sat,holiday,break
2014-01-01,0,0,0,1,0,0,0,1,0
2014-01-02,0,0,0,0,1,0,0,0,1
2014-01-03,0,0,0,0,0,1,0,0,1
2014-01-04,0,0,0,0,0,0,1,0,0
2014-01-05,1,0,0,0,0,0,0,0,0
2014-01-06,0,1,0,0,0,0,0,0,0
2014-01-07,0,0,1,0,0,0,0,0,0
2014-01-08,0,0,0,1,0,0,0,0,0
2014-01-09,0,0,0,0,1,0,0,0,0
```

JSON format supported, in addition to YAML format.

You can also directly pass config data to DummyVariables::Calendar.new.

```ruby
config_data = {
  "holiday" => {
    "dates" => [
      "2014-01-01", "2014-01-13", "2014-02-11", "2014-03-21", "2014-04-29", "2014-05-03", "2014-05-04",
      "2014-05-05", "2014-05-06", "2014-07-21", "2014-09-15", "2014-09-23", "2014-10-13", "2014-11-03",
      "2014-11-23", "2014-11-24", "2014-12-23", "2015-01-01", "2015-01-12", "2015-02-11", "2015-03-21",
      "2015-04-29", "2015-05-03", "2015-05-04", "2015-05-05", "2015-05-06", "2015-07-20", "2015-09-21",
      "2015-09-22", "2015-09-23", "2015-10-12", "2015-11-03", "2015-11-23", "2015-12-23"
    ]
  },
  "break" => {
    "dates" => [
      "2014-01-02", "2014-01-03", "2014-08-13", "2014-08-14", "2014-08-15", "2014-12-29", "2014-12-30",
      "2014-12-31", "2015-01-02", "2015-08-13", "2015-08-14", "2015-12-29", "2015-12-30", "2015-12-31"
    ]
  }
}

cal = DummyVariables::Calendar.new("20140101", "20151231", config_data: config_data)
File.open("cal.csv", "w") { |file| file.write(cal.to_csv_str) }
```

    $ head cal.csv

```
date,sun,mon,tue,wed,thu,fri,sat,holiday,break
2014-01-01,0,0,0,1,0,0,0,1,0
2014-01-02,0,0,0,0,1,0,0,0,1
2014-01-03,0,0,0,0,0,1,0,0,1
2014-01-04,0,0,0,0,0,0,1,0,0
2014-01-05,1,0,0,0,0,0,0,0,0
2014-01-06,0,1,0,0,0,0,0,0,0
2014-01-07,0,0,1,0,0,0,0,0,0
2014-01-08,0,0,0,1,0,0,0,0,0
2014-01-09,0,0,0,0,1,0,0,0,0
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aknd/dummy_variables. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DummyVariables project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aknd/dummy_variables/blob/master/CODE_OF_CONDUCT.md).
