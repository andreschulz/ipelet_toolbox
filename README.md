# ipelet_toolbox
Collection of Ipelets for small tasks

To install move the .lua file(s) into the ipelets directory of your installation before starting ipe, 
see Section 8.6, "Customizing Ipe", of the ipe manual. Then the ipelets can be accessed under the Ipelets menu.
You can see the ipelets path in Show configuration in ipe's Help menu. 

## Line through 2 points 
This ipelet needs a selection of two marks or a single segment. It adds a line (bounded by the drawing canvas) through the 2 marks/the 2 endpoints of the segment.

Filename: `line2points.lua`

## Line arrangement from points
This ipelet needs a selection of at least two marks. For every pair of marks from the selection it draws a line (bounded by the drawing canvas) through the 2 marks.
All lines will be grouped.

Filename: `linearrangement.lua`
