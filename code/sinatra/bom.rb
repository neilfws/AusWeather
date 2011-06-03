def dates_to_utc(data)
  data.map { |r|
    d    = r[0].split("-")
    d[1] = d[1].to_i - 1
    "[Date.UTC(#{d.join(",")}),#{r[1]}]"
  }
end
