function import(node, value, key)
  
  -- New character sheets get 150 sp by default, so remove that
  if key == "sp" then
    value = value - 150
  end
  
  CurrencyManager.addCharCurrency(node, key:upper(), value)
end