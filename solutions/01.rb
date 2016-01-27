def multiplier(currency)
  case currency
  when :bgn then 1.0000
  when :usd then 1.7408
  when :eur then 1.9557
  when :gbp then 2.6415
  end
end

def convert_to_bgn(price, currency)
  (price * multiplier(currency)).round 2
end

def compare_prices(price_1, currency_1, price_2, currency_2)
  convert_to_bgn(price_1, currency_1) <=> convert_to_bgn(price_2, currency_2)
end
