function import(node, value, key)
  DB.setValue(node, key, "string", value)
  return value
end