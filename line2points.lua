
label = "Line through 2 points"


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
  if (sel and obj:type()=="path") then
    local shape = obj:shape()
    if (#shape == 1 and shape[1].type == "curve" and #shape[1] == 1
      and shape[1][1].type == "segment")
    then 
        selectedPoints[#selectedPoints + 1] = obj:matrix()*shape[1][1][1]
        selectedPoints[#selectedPoints + 1] = obj:matrix()*shape[1][1][2]
    end
  end
end
 
-- -- if no 2 points were selected, then nothing is going to happen
if #selectedPoints ~= 2 then
    model:warning("You need to select 2 points or a segment")
    return
end

local l = ipe.LineThrough(selectedPoints[1], selectedPoints[2])

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

local seg = { type="segment",  p, q}
local sb = { type="curve", closed=false, seg }
local obj = ipe.Path(model.attributes, { sb }, false)


model:creation("create line through two points", obj)

return 

end
