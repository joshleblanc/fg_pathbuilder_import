local SIZES = {
  [-2] = "Fine",
  [-1] = "Diminutive",
  [0] = "Tiny",
  [1] = "Small",
  [2] = "Medium",
  [3] = "Large",
  [4] = "Huge",
  [5] = "Gargantuan",
  [6] = "Colossal"
}

function import(node, value)
  DB.setValue(node, "size", "string", SIZES[value])
  return value
end