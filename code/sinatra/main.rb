configure do
  DB = Mongo::Connection.new.db('bom')
  records = DB.collection('records')
  set :records, records
end

get "/" do
  @pmin = options.records.find("predicted" => 1).map { |r| [r['date'], r['min']] }
  @amin = options.records.find("predicted" => 0).map { |r| [r['date'], r['min']] }
  @pmin = dates_to_utc(@pmin)
  @amin = dates_to_utc(@amin)
  @pmax = options.records.find("predicted" => 1).map { |r| [r['date'], r['max']] }
  @amax = options.records.find("predicted" => 0).map { |r| [r['date'], r['max']] }
  @pmax = dates_to_utc(@pmax)
  @amax = dates_to_utc(@amax)
  haml :index
end
