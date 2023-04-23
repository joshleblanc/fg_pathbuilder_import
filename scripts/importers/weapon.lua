--[[
  value looks like 
  {
        "name": "Staff",
        "qty": 1,
        "prof": "simple",
        "die": "d4",
        "pot": 0,
        "str": "",
        "mat": null,
        "display": "Staff",
        "runes": []
      }
]]
function import(node, value)
  Equipment.import(node, { value.display, value.qty })
end