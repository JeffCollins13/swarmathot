;----------------------------------------------------------------------------------------------
 ;; COMPETITION SUBMISSION FILE
;----------------------------------------------------------------------------------------------
 ;; Elizabeth E. Esterly
 ;; elizabeth@cs.unm.edu
 ;; The University of New Mexico
 ;; Swarmathon 5: Competition
 ;; version 1.0
 ;; Last Revision 01/13/2017
;----------------------------------------------------------------------------------------------
  ;;
  ;;Replace this comment with 
  ;;team 
  ;;mentor 
  ;;high school names
;---------------------------------------------------------------------------------------------- 
 
;------------------------------------------------------------------------------------
;::::::::::::::::::::!!!!!!!!!   REQUIRED CODE  !!!!!!!!!::::::::::::::::::::
;------------------------------------------------------------------------------------
 ;;Use the bitmap extension.
 extensions[bitmap]

  patches-own [
     baseColor
     ;;You may add additional patches-own variables below this comment.
     
     ;this means that there is a resource here
     rock   
     
     ;the cordinates of a resource within sanic's radius
     oldpX
     oldpY
     
     ;means a resource is within sanic's radius
     target
     
     ;a patch that had a resource on it but no longer does
     collect
    ]  
  
  globals [
    
    ;the coordinates of were the sanic left the spiral
    eoldx
    eoldy
    
    ;amount of steps taken by the sanic
    cSteps
    cMaxsteps
    
    ;representation of the sanic direction or heading
    savepdo
    
    ;show if the variable for sanic is true or false
    msavep
    msearching
    mreturning
    mhunting
    ;; number of rocks on screen
    numberOfRocks
  ]
  
  breed [sara robot]         ; the names of our robots 
  breed [becky robot]
  breed [halley robot]
  breed [sanic robot]
  breed [john robot]
  breed [tykiki robot]
  
  
  
  sara-own [ 
   
  ]
  becky-own[ 
   
  ]
  halley-own[ 
    H-returning
    H-searching
    
   
  ]
  sanic-own[ 
    ;if sanic is going back to base (base is 0, 0)
    returning  
    
    ;shows the amount of steps left until sanic has to turn right
    steps
    
    ;after sanic turns right shows the amount of times it will move forward 1
    maxsteps
    
    ;when sanic is looking for a rock
    searching
    
    ;where sanic left the spiral
    oldX
    oldY
    
    ;when sanic is going back to where it left the spiral
    saveP
    
    ;the direction sanic was in when it noticed a rock
    savepd
    
    ;when sanic reaches a wall
    restarting
   
   ;only when sanic is in the spiral
   hunting
   
  ]
  john-own[ 
    jrestarting
    jsearching
  ]
  tykiki-own[ 
    
  ]
  




 
;------------------------------------------------------------------------------------
;::::::::::::::::::::!!!!!!!!!   REQUIRED CODE  !!!!!!!!!::::::::::::::::::::
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;
 ;;    setup     ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
;;Write the setup procedure.
to setup
  file-config
   ;;You may add additional setup commands below this comment.
 
reset-ticks


;sets sanic's beginning direction
ask sanic[
set savepd 1
]




;this makes the patches that are resources set up everything that proves that it is one.
 ask patches[
set collect false


if pcolor = yellow[
  set rock true
]
set target false
if collect[
  
 set rock false


]
]
 
 
;spawns each robot
birth-sara
birth-becky
birth-halley
birth-sanic
birth-john
birth-tykiki





end

;------------------------------------------------------------------------------------
;;;;;;;;;;;;;
;;MAKE SARA;;
;;;;;;;;;;;;;
to birth-sara
  create-sara 1[
  set size 6
  set shape "robot"
  set color pink
  
  ]
  
end


 ;------------------------------------------------------------------------------------
;;;;;;;;;;;;;;
;;MAKE becky;;
;;;;;;;;;;;;;;
to birth-becky
  create-becky 1[
  set size 6
  set shape "robot"
  set color orange
  
  ]
  
end


;------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;
;;MAKE halley;;
;;;;;;;;;;;;;;;
to birth-halley
  create-halley 1[
  set size 6
  set shape "robot"
  set color sky
  set H-searching true
  set H-returning false
  set label "halley"
  ]
  
end


 ;------------------------------------------------------------------------------------
;;;;;;;;;;;;;;
;;MAKE SANIC;;
;;;;;;;;;;;;;;


;makes sure all of sanic's variables are what they should be in the beginning

to birth-sanic
  create-sanic 1[
  set size 6
  set shape "robot"
  set color blue
  set searching true
  set returning false
  set maxsteps 0
  set steps 0
  set heading 90
  set restarting false
  set hunting true
  set saveP false
  set label "sanic"
  ]
  
end


 ;------------------------------------------------------------------------------------
;;;;;;;;;;;;;
;;MAKE JOHN;;
;;;;;;;;;;;;;
to birth-john
  create-john 1[
  set size 6
  set shape "robot"
  set color red
  
  ]
  
end


 ;------------------------------------------------------------------------------------
;;;;;;;;;;;;;
;;MAKE SARA;;
;;;;;;;;;;;;;
to birth-tykiki
  create-tykiki 1[
  set size 6
  set shape "robot"
  set color black
  
  ]
  
end


  
;------------------------------------------------------------------------------------
;::::::::::::::::::::!!!!!!!!!   REQUIRED CODE  !!!!!!!!!::::::::::::::::::::
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;    ROBOT CONTROL    ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
 ;;Write the robot-control procedure.
to robot-control
 
 ;makes simulation stop at 3600 ticks
  if ticks > 3599
  [stop]
 
 
 
 
 
 ;makes these variables show on the moniters in the interface tab, 
 ;if the number is 1 then the variable is true, if the number is 2 then the variable is false
 ask sanic[
if (savep = true)
[set msavep  1]
if searching = true
[set msearching  1]
if returning = true
[set mreturning  1]
if hunting = true
[set mhunting  1]
    if savep = false
[set msavep  2]
if searching = false
[set msearching  2]
if returning = false
[set mreturning 2]
if hunting = false
[set mhunting  2]
    
 ]





;makes sanic record its position when in the spiral
;maybe a little too secure ;)
  ask sanic[
      if searching and not returning and hunting and not savep [
      set oldX xcor
      set oldY ycor
     ]
   
  ;makes it go home when it is in the returning mode(when it has a rock)
  ;makes it run the basic procedure if it isn,t returning
     ifelse returning
     [s-go-home]
     [S-go-fast]
     ]

  
     ;sets the patches woth resource to a state where they can be collected, or where they cant if a resource was already collected from that patch
     ask patches[
if collect[
  
 set rock false
set target false

]
if pcolor = baseColor[
  set target false]
]



if(ticks > 3585) or (not any? patches with [pcolor = yellow] )
[ask turtles [back-to-base]]

;this is so that i can see where the robots have been
ask turtles[
  
  ifelse pen-down?
  [pen-down]
  [pen-up]
]


;;Halleyhallyhallyhallyhallyhalleyhalleyhalleyhalleyhalley

 ;;makes halley move in a random pattern
 ask halley 
 [
 if H-searching [lookforrocks]
 if H-returning [H-go-home]
  moveit
 ]
 
 
 
 
  ;;tick needs to come last in your robot-control procedure.
  ;------------------------------------------------------------------------------------
   tick 
end





;SANICSANICSANICSANICSANICSANICSANICSANICSANIC

;------------------------------------------------------------------------------------
;;;;;;;;;;;
;;get rocks;;
;;;;;;;;;;;
                  
                                             
   
 to S-get-rocks
   ask sanic[
   if hunting = false[
       set eoldx oldX
set eoldy oldY
   ]
if searching = true or hunting = false [
    if (any? patches with [rock = true] in-radius 2)[
  
 set hunting false
  
     
     ask one-of patches with [rock = true] in-radius 2[ 
      set target true 
     
     ]
      set oldpX ([pxcor] of one-of patches with [target = true] in-radius 2)
      set oldpY ([pycor] of one-of patches with [target = true] in-radius 2)      ;tries to get coordinates o a patch
  
  
  
   ifelse (any? sanic-on patches with [target = true]) [

 

 ask (patch oldpX oldpY) [
     
         set pcolor basecolor
         set target false
         set rock false
         set collect true]
 
         
         ask sanic [
           
           set shape "robot with rock"
           set searching false
           set returning true
           set hunting false
          
         ]
         
       
 
  
   ]
  
   [   
    
     facexy oldpX oldpY  
                                ;how do i get it to face the patch
     ]
   ]
]
   ]
    
   
    
       
                                         


       

end

;------------------------------------------------------------------------------------
;;;;;;;;;;;
;;GO HOME;;
;;;;;;;;;;;
 
 to S-go-home
    
   
  
  
  if shape = "robot with rock"[
  
   ifelse pxcor = 0 and pycor = 0 [
     set returning false
     set shape "robot"
     set saveP true
     facexy oldX oldY 
     ask sanic [
       

       S-savec
       ]
  
   ]
   [ if ( shape = "robot with rock")[
     facexy 0 0
     
      forward 1]
   
   ]
   
  ]
   
     
      
   
 end
 
 
 
;------------------------------------------------------------------------------------
;;;;;;;;;;;
;;GO FAST;;
;;;;;;;;;;;
 
 to S-go-fast
   set cSteps  steps
   set cMaxsteps  maxsteps 
    if restarting [
      set searching false 
      S-restart]
   if not can-move? 1 [
    ask sanic [
      set restarting true
     set steps 0
     set maxsteps 0
    ]
     ]
   
    if saveP [
      
      S-savec
      ]
   
  
  
   if searching[
     
     forward 1
    
  ifelse steps > 0 [
  
     
       if searching = true or hunting = false [S-get-rocks]
     if searching[
      
       if (hunting)[
       set steps steps - 1
       ]
     ]
   ]
  
   [
   right 90
   set maxSteps maxsteps + 2
   set steps maxsteps
   ifelse savepd = 4
   [set savepd 1]
   [set savepd savepd + 1]
   set savepdo savepd
   ]
  ]
   if hunting and savep and not returning [
            if (savepd = 1)[
           face patch (pxcor) (-50) 
         ]
         if (savepd = 2)[
           face patch (-50) (pycor) 
         ]
         if (savepd = 3)[
           face patch (pxcor) (50) 
         ]
         if (savepd = 4)[
           face patch (50) (pycor) 
         ]
   ]
   
   
 end
;------------------------------------------------------------------------------------
;;;;;;;;;;;
;;GO FAST;;
;;;;;;;;;;;




to S-restart


ifelse pxcor = 0 and pycor = 0 [
     set restarting false
     set shape "robot"
     set searching true
     
  
   ]
   [facexy 0 0
     fd 1]


end



to S-savec
  

   if (saveP = true)[
       ifelse (pxcor < eoldX + .5 and pxcor > eoldX - .5) and (pycor < eoldY + .5 and pycor > eoldY - .5)[
         
     set saveP false  
         if (savepd = 1)[
           face patch (pxcor) (-50) 
         ]
         if (savepd = 2)[
           face patch (-50) (pycor) 
         ]
         if (savepd = 3)[
           face patch (pxcor) (50) 
         ]
         if (savepd = 4)[
           face patch (50) (pycor) 
         ]
         
        
     set returning false 
      set searching true 
      set hunting true
                ;not sur about this part
     ]
     
     
     
     [
       if saveP[
       facexy eoldX eoldY
       if saveP[ forward 1]]]
      
      
      ]

end


























;johnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohnjohn




to J-move
  
  if jrestarting [J-restart]
  
  ifelse (ticks > 1999) [
    
    ]
   [ ask john[
      if [pcolor] of (patch-ahead 1) = red [
       right 90
      ] 
      ]
   ]
    
    
    if not can-move? 1 [
    ask sanic [
      set jrestarting true
    
    ]
     ]
   
   

    end


to J-restart


ifelse pxcor = 0 and pycor = 0 [
     set jrestarting false
     set shape "robot"
     set jsearching true
     
  
   ]
   [facexy 0 0
     fd 1]


end


;;halleyhalleyhalleyhalleyhalleyhalleyhalleyhalleyhalleyhalley

;;;;;;;;;;;
;;GO HOME;;
;;;;;;;;;;;

   to H-go-home
ifelse pcolor = green
[
  set shape "robot"
  set H-searching true
  set H-returning false 
]
[
  facexy 0 0
]

   end
;;;;;;;;;;
;;MOVEIT;;
;;;;;;;;;;

  to moveit
  
  right random angle
  left random angle
  if not can-move? 1 [facexy 0 0]
  fd 1
  
  end
;;;;;;;;;;;;;;;;
;;lookforrocks;;
;;;;;;;;;;;;;;;;

to lookforrocks
  ;; searching for rocks
ask neighbors[
  if pcolor = yellow[
    set numberOfRocks  (numberOfRocks - 1)
    set pcolor basecolor
    ask myself [
      set H-searching false
      set H-returning true
      set shape "robot with rock"
    ]
  ]
]
    end















































 ;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;
 ;; back-to-base ;;
 ;;;;;;;;;;;;;;;;;;
 
 to back-to-base
   
 ;1) If the patch color is green, we found the base.
 ifelse pcolor = green
   
 ;;2) Change the robot's shape to the one without the rock,
 ;;   and start searching again.
[
  set shape "robot"
  stop
]
                             
 ;;3) Else, we didn't find the base yet--face the base
 [facexy 0 0]
 
forward 1
 
 end








;;KEEP THE FOLLOWING CODE AT THE BOTTOM OF YOUR FILE.
;------------------------------------------------------------------------------------
;::::::::::::::::::::!!!!!!!!!   REQUIRED CODE  !!!!!!!!!::::::::::::::::::::
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;;;;;;
 ;;   file-config     ;; 
 ;;;;;;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
;;
 to file-config
  ca ;clear all
  cp ;clear patches
  bitmap:copy-to-pcolors bitmap:import "parkingLot.jpg" true
  reset-ticks ;keep track of simulation runtime
  make-rocks
  make-base
 end
 

;------------------------------------------------------------------------------------
to make-rocks
   ask patches [ set baseColor pcolor]
   
   if distribution = "cross" or distribution = "random + cross" or distribution = "large clusters + cross"
   or distribution = "clusters + cross" or distribution = "random + clusters + cross" 
   or distribution = "random + clusters + large clusters + cross"[make-cross]
   
   if distribution = "random" or distribution = "random + cross" or distribution = "random + clusters"
   or distribution = "random + large clusters" or distribution = "random + clusters + cross" 
   or distribution = "random + clusters + large clusters + cross" [make-random]
   
   if distribution = "clusters" or distribution = "clusters + cross" or distribution = "random + clusters"
   or distribution = "clusters + large clusters" or distribution = "random + clusters + cross" 
   or distribution = "random + clusters + large clusters + cross" [make-clusters]
   
   if distribution = "large clusters" or distribution = "large clusters + cross"
   or distribution = "random + large clusters"  or distribution = "clusters + large clusters" 
   or distribution = "random + clusters + large clusters + cross" [make-large-clusters]
   
end

;------------------------------------------------------------------------------------
;;Place rocks in a cross formation.
to make-cross
  ask patches [           
    ;;Set up the cross by taking the max coordinate value, doubling it, then only setting a rock if the
    ;;x or y coord is evenly divisible by that value. 
    ;;NOTE: This technique assumes a square layout.                  
    let doublemax max-pxcor * 2 
    if pxcor mod doublemax = 0 or pycor mod doublemax = 0 [ set pcolor yellow ]  
  ]                   
end

;------------------------------------------------------------------------------------
;;Place rocks randomly.
to make-random
   let targetPatches singleRocks
     while [targetPatches > 0][
       ask one-of patches[
         if pcolor != yellow[
           set pcolor yellow
           set targetPatches targetPatches - 1
         ]
       ]
     ]
end

;------------------------------------------------------------------------------------
;;Place rocks in clusters.
to make-clusters
   let targetClusters clusterRocks
     while [targetClusters > 0][
       ask one-of patches[
         if pcolor != yellow and [pcolor] of neighbors4 != yellow[
           set pcolor yellow
           ask neighbors4[ set pcolor yellow ]
           set targetClusters targetClusters - 1
         ]
       ]
     ]
end

;------------------------------------------------------------------------------------
;;Place rocks in large clusters.
to make-large-clusters
   let targetLargeClusters largeClusterRocks
   while [targetLargeClusters > 0][
     ask one-of patches[
       if pcolor != yellow and [pcolor] of patches in-radius 3 != yellow[
         set pcolor yellow
         ask patches in-radius 3 [set pcolor yellow]
         set targetLargeClusters targetLargeClusters - 1
       ]
     ]
     ]
end

;------------------------------------------------------------------------------------
;Make a base at the origin.
to make-base
  ask patches[
    if distancexy 0 0 = 0 [set pcolor green]
  ]
end
;------------------------------------------------------------------------------------
@#$#@#$#@
GRAPHICS-WINDOW
235
13
750
549
50
50
5.0
1
10
1
1
1
0
0
0
1
-50
50
-50
50
1
1
1
ticks
5.0

BUTTON
14
10
81
44
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
89
11
207
45
robot-control
robot-control
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
15
60
129
105
rocks remaining
count patches with [pcolor = yellow]
17
1
11

CHOOSER
15
323
232
368
distribution
distribution
"cross" "random" "clusters" "large clusters" "random + cross" "clusters + cross" "clusters + large clusters" "large clusters + cross" "random + clusters" "random + large clusters" "random + clusters + cross" "random + clusters + large clusters + cross"
6

SLIDER
17
199
189
232
singleRocks
singleRocks
0
100
10
5
1
NIL
HORIZONTAL

SLIDER
17
237
189
270
clusterRocks
clusterRocks
0
50
0
5
1
NIL
HORIZONTAL

SLIDER
17
278
189
311
largeClusterRocks
largeClusterRocks
0
20
14
1
1
NIL
HORIZONTAL

SWITCH
34
157
151
190
pen-down?
pen-down?
0
1
-1000

MONITOR
36
429
93
474
eoldx
eoldx
17
1
11

MONITOR
45
515
102
560
eoldy
eoldy
17
1
11

MONITOR
109
394
166
439
steps
csteps
17
1
11

MONITOR
167
500
239
545
NIL
cmaxsteps
17
1
11

MONITOR
80
609
140
654
savepdx
savepdo
17
1
11

MONITOR
230
602
287
647
savep
msavep
17
1
11

MONITOR
352
618
418
663
searching
msearching
17
1
11

MONITOR
483
625
547
670
returning
mreturning
17
1
11

MONITOR
594
616
651
661
hunting
mhunting
17
1
11

SLIDER
830
93
1002
126
Angle
Angle
0
90
40
5
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

robot
true
1
Polygon -16777216 true false 75 60 105 15 135 15 90 75 75 60
Polygon -16777216 true false 225 60 195 15 165 15 210 75 225 60
Rectangle -16777216 true false 30 105 75 165
Rectangle -16777216 true false 30 210 75 270
Rectangle -16777216 true false 75 120 225 255
Rectangle -16777216 true false 225 210 270 270
Rectangle -16777216 true false 225 105 270 165
Rectangle -16777216 true false 90 120 210 195
Rectangle -2674135 true true 120 120 180 240
Rectangle -16777216 true false 195 225 210 240
Rectangle -16777216 true false 120 60 180 90
Rectangle -16777216 true false 135 90 165 120
Polygon -2674135 true true 180 75 210 90 210 105 180 90 180 75
Polygon -2674135 true true 120 75 90 90 90 105 120 90 120 75
Rectangle -7500403 true false 75 105 225 120
Line -2674135 true 90 120 90 240
Line -2674135 true 210 120 210 240
Line -2674135 true 135 90 165 90
Line -16777216 false 75 165 225 165
Line -16777216 false 75 180 225 180
Rectangle -7500403 true false 75 240 225 255

robot with rock
true
1
Rectangle -1184463 true false 120 0 180 45
Polygon -16777216 true false 75 60 105 15 135 15 90 75 75 60
Polygon -16777216 true false 225 60 195 15 165 15 210 75 225 60
Rectangle -16777216 true false 30 105 75 165
Rectangle -16777216 true false 30 210 75 270
Rectangle -16777216 true false 75 120 225 255
Rectangle -16777216 true false 225 210 270 270
Rectangle -16777216 true false 225 105 270 165
Rectangle -16777216 true false 90 120 210 195
Rectangle -2674135 true true 120 120 180 240
Rectangle -16777216 true false 120 60 180 90
Rectangle -16777216 true false 135 90 165 120
Polygon -2674135 true true 180 75 210 90 210 105 180 90 180 75
Polygon -2674135 true true 120 75 90 90 90 105 120 90 120 75
Rectangle -7500403 true false 75 105 225 120
Line -2674135 true 75 240 225 240
Line -2674135 true 90 120 90 240
Line -2674135 true 210 120 210 240
Line -2674135 true 135 90 165 90
Line -16777216 false 75 165 225 165
Line -16777216 false 75 180 225 180
Rectangle -7500403 true false 75 240 225 255

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
