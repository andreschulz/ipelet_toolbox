
label = "Line arrangement from points"


----------------------------------------------------------------------
-- main function, starting when iplet is clicked in ipe
----------------------------------------------------------------------
function run(model)

local p = model:page()

local doc = model.doc
local sheets = doc:sheets()

local maxx=sheets:find("layout").framesize.x
local maxy=sheets:find("layout").framesize.y
local minx=sheets:find("layout").origin.x
local miny=sheets:find("layout").origin.y

local leftBoundary = ipe.Line(ipe.Vector(minx,miny),ipe.Vector(0,1))
local rightBoundary = ipe.Line(ipe.Vector(maxx,miny),ipe.Vector(0,1))
local upperBoundary = ipe.Line(ipe.Vector(minx,maxy),ipe.Vector(1,0))
local lowerBoundary = ipe.Line(ipe.Vector(minx,miny),ipe.Vector(1,0))

 if not p:hasSelection() then model.ui:explain("no selection") return end
 
-- collect all selected points (type "reference") on the page 
local selectedPoints = {}
for i, obj, sel, lay in p:objects() do
  if (sel and obj:type()=="reference") then
  	selectedPoints[#selectedPoints + 1] = obj:matrix()*obj:position()
  end
end
 
-- -- -- if less than 2 points were selected, then nothing is going to happen
if #selectedPoints < 2 then
    model:warning("You need to select at least 2 points")
    return
end


local lines = {}

for i=1,#selectedPoints-1 do
  for j=i+1,#selectedPoints do 

  local l = ipe.LineThrough(selectedPoints[i], selectedPoints[j])

  local upperpoint = l:intersects(upperBoundary)
  local lowerpoint = l:intersects(lowerBoundary)
  local rightpoint = l:intersects(rightBoundary)
  local leftpoint = l:intersects(leftBoundary)

  local p
  local q

  if (not leftpoint) then p=upperpoint
  elseif (not upperpoint) then p=leftpoint    
  elseif (upperpoint.x >= minx and upperpoint.x <= maxx) then p = upperpoint 
  elseif(rightpoint.y>= miny and rightpoint.y<= maxy) then  p = rightpoint
  else p = lowerpoint
  end

  if (not leftpoint) then q=lowerpoint
  elseif (not upperpoint) then q=rightpoint
  elseif (leftpoint.y >= miny and leftpoint.y <= maxy) then q = leftpoint 
  elseif(lowerpoint.x>= minx and lowerpoint.x<= maxx) then  q = lowerpoint
  else q = rightpoint
  end

  lines[#lines+1] = ipe.Path(model.attributes, { { type="curve", closed=false, { type="segment",  p, q} }}, false)

  end
end

local group = ipe.Group(lines)
model:creation("create line arrangement", group)

return 

end
