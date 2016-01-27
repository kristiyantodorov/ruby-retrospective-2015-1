def convert_to_bgn(value, currency)
  multiplier = if currency == :bgn
                 1
                 elsif currency == :usd
                 1.7408
                 elsif currency == :gbp
                 2.6415
                 elsif currency == :eur
                 1.9557
               end
  (multiplier * value).round(2)
end

def compare_prices(value_1, currency_1, value_2, currency_2)
  convert_to_bgn(value_1, currency_1) <=> convert_to_bgn(value_2, currency_2)
end
