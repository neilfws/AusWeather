#!/usr/bin/ruby

require "rubygems"
require "open-uri"
require "json/pure"
require "mongo"
require "date"

db  = Mongo::Connection.new.db('bom')
col = db.collection('records')

def get_yesterday(url)
  begin
    record = {}
    data  = JSON.parse(open(url).read)
    ts    = data['observations']['header'].first['refresh_message']
    ts.gsub!("EST", "+10:00")
    temps = data['observations']['data'].map { |obs| [obs['local_date_time_full'], obs['air_temp']] }
    temps.reject! {|t| Date.today - Date.parse(t[0]) != 1}
    min = temps.min_by { |t| t[1] }
    max = temps.max_by { |t| t[1] }
    record = {'timestamp' => DateTime.parse(ts).to_s, 'date' => (Date.today - 1).to_s,
              'min' => min[1], 'max' => max[1], 'predicted' => 0, '_id' => DateTime.parse(ts).to_s}
    rescue Exception => e
      puts e
    ensure
      return record
  end
end

def get_predictions(url)
  begin
    temps  = []
    record = []
    ts     = DateTime.now.to_s
    open(url) do |f|
      f.each_line do |line|
        if line =~ /^Issued\s+at\s+/
          ts = line
          ts.gsub!("EST", "+10:00")
        end
        if line =~ /^City\s+Centre.*?\s+Min\s+(-\d+|\d+)\s+Max\s+(-\d+|\d+)/
          temps << [$1, $2]
        end
      end
    end
    temps.each_with_index do |t, i|
      record << {'timestamp' => DateTime.parse(ts).to_s, 'date' => (Date.today + i + 1).to_s,
        'min' => t[0].to_f, 'max' => t[1].to_f, 'predicted' => 1, '_id' => "#{DateTime.parse(ts).to_s}/#{i}"}
    end
    rescue Exception => e
      puts e
    ensure
      return record
  end
end

# save to db
observed  = get_yesterday("http://www.bom.gov.au/fwo/IDN60901/IDN60901.94768.json")
if observed.count == 6
  col.save(observed)
end

predicted = get_predictions("http://www.bom.gov.au/fwo/IDN10064.txt")
predicted.each do |p|
  if p.count == 6
    col.save(p)
  end
end
