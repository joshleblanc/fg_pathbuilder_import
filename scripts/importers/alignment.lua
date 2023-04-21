-- I did not check to see if the keys are right coming out of pathbuilder
-- just assuming

local map = {
  N = "Neutral",
  NG = "Neutral Good",
  NE = "Neutral Evil",
  CG = "Chaotic Good",
  LG = "Lawful Good",
  LE = "Lawful Evil",
  LN = "Lawful Neutral",
  CE = "Chaotic Evil",
  CN = "Chaotic Neutral",
}

function import(node, value)
  DB.setValue(node, "alignment", "string", map[value])
end