breed [people person]

people-own [
  mood-x ; X-axis mood score for each agent from 0 to 10 (valence)
  mood-y ; Y-axis mood score for each agent from 0 to 10 (arousal)
  speed ; Speed based on mood
  empathy-level

]

globals [
  positive-influence ; Define the positive mood influence value of the environment (nature)
  negative-influence ; Define the negative mood influence value of the environment (city)
  happy
  sad
  angry
  relaxed
]

to setup
  Clear-all
  ;this sets the patches to green and grey
  ask patches with [pxcor > 0] [
    set pcolor grey]
  ask patches with [pxcor < 0] [
    set pcolor green]

  set positive-influence positive ; Adjust the positive influence value
  set negative-influence negative ; Adjust the negative influence value

  create-people num-people [
    setxy random-xcor random-ycor
    set mood-x random-float 10 ; Assign random mood scores on the X-axis
    set mood-y random-float 10 ; Assign random mood scores on the Y-axis
    set speed mood-y * speedboost ; Adjust speed based on mood
    set empathy-level random-float 10; Randomly assign empathy level
    set shape "person"
    update-color

    set happy people with [mood-x > 5 and mood-y > 5]
    set sad people with [mood-x <= 5 and mood-y <= 5]
    set angry people with [mood-x <= 5 and mood-y > 5]
    set relaxed people with [mood-x <= 5 and mood-y <= 5]

  ]
  reset-ticks
end

to go
  move-people
  update-mood
  update-color
  update-speed
  tick
end

to update-speed
  ask people [
    set speed mood-y * speedboost
  ]
end

to move-people
  ask people [
    rt random 360
    fd speed ; Move forward based on speed
  ]
end

to update-mood
  ask people [
    ; Check the color of the patch the agent is on
    let current-patch-color [pcolor] of patch-here

    ; Define the mood influence based on patch color
    let mood-influence 0
    ifelse current-patch-color = green [
      set mood-influence positive-influence ; Adjust the positive influence value
    ] [
      set mood-influence negative-influence ; Adjust the negative influence value
    ]




    ; Check for interactions with other agents within the aura radius
    let interaction-partners people in-radius aura



    ; If there are interaction partners, calculate the average mood of agents within the aura
    if any? interaction-partners [
      let average-mood-x mean [mood-x] of interaction-partners
      let average-mood-y mean [mood-y] of interaction-partners

      ; Calculate the mood update based on the mood difference and empathy level
      let mood-difference-x average-mood-x - mood-x
      let mood-difference-y average-mood-y - mood-y

      let mood-update-x mood-difference-x * (empathy-level * (abs(mood-difference-x) / 2)) * social-influence
      let mood-update-y mood-difference-y * (empathy-level * (abs(mood-difference-y) / 2)) * social-influence

      ; Update mood-x and mood-y while ensuring they remain within a certain range
      set mood-x mood-x + mood-update-x
      set mood-y mood-y + mood-update-y

      if mood-x > 10 [ set mood-x 10 ]
      if mood-x < 0.1 [ set mood-x 0.1 ]
      if mood-y > 10 [ set mood-y 10 ]
      if mood-y < 0.1 [ set mood-y 0.1 ]
    ]
    set mood-x mood-x + mood-influence
    set mood-y mood-y - mood-influence
  ]
  set happy people with [mood-x > 5 and mood-y > 5]
    set sad people with [mood-x <= 5 and mood-y <= 5]
    set angry people with [mood-x <= 5 and mood-y > 5]
    set relaxed people with [mood-x <= 5 and mood-y <= 5]
end

to update-color
  ask people [
   ifelse mood-x >= 3.75 and mood-x <= 6.25 and mood-y >= 3.75 and mood-y <= 6.25 [ ; first set the neutral color
      set color white]
    ; else: every other emotion
    [ ifelse mood-x >= 7.5 [; for excitement, happy, content, relaxed
      ifelse mood-y >= 7.5 [ ; excitement
        set color yellow]
        [ifelse mood-y >= 5 [ ; happy
        set color 47]
        [ifelse mood-y >= 2.5 [ ; content
          set color 128]
          [set color magenta] ; relaxed
      ]]]
      [ifelse mood-x >= 5 [ ; for pride, pleased, calm, drowsy
        ifelse mood-y >= 7.5 [ ; pride
        set color 29]
        [ifelse mood-y >= 5 [ ; pleased
        set color 49]
        [ifelse mood-y >= 2.5 [ ; calm
          set color 137]
          [set color pink] ; drowsy
      ]]]
        [ifelse mood-x >= 2.5 [ ; for fear, nervous, bored, fatigued
          ifelse mood-y >= 7.5 [ ; fear
        set color orange]
        [ifelse mood-y >= 5 [ ; nervous
        set color 28]
        [ifelse mood-y >= 2.5 [ ; bored
          set color 87]
          [set color violet] ; fatigue
      ]]]
          ; for anger, frustration, sad, depressed
          [ifelse mood-y >= 7.5 [ ; anger
        set color red]
        [ifelse mood-y >= 5 [ ; frustration
        set color 23]
        [ifelse mood-y >= 2.5 [ ; sad
          set color sky]
          [set color blue] ; depressed
        ]]]
    ]]]
        ]
end



to-report count-people-with-mood [min-mood-x max-mood-x min-mood-y max-mood-y]
  ; this function counts the people with following min and max mood
  report count turtles with [mood-x >= min-mood-x and mood-x <= max-mood-x and mood-y >= min-mood-y and mood-y <= max-mood-y]
end
@#$#@#$#@
GRAPHICS-WINDOW
193
10
708
526
-1
-1
15.364
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
11
17
77
50
NIL
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

PLOT
737
11
1210
324
My plot
moodscore
amount
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"angry" 1.0 0 -2674135 true "" "plot count people with [mood-x <= 5 and mood-y > 5]"
"sad" 1.0 0 -13791810 true "" "plot count people with [mood-x <= 5 and mood-y <= 5]\n\n\n"
"happy" 1.0 0 -1184463 true "" "plot count people with [mood-x > 5 and mood-y > 5]"
"relaxed" 1.0 0 -2064490 true "" "plot count people with [mood-x > 5 and mood-y <= 5]"

CHOOSER
10
63
148
108
num-people
num-people
10 25 50 100
3

CHOOSER
10
118
148
163
aura
aura
0.25 0.5 1 1.5 2
0

MONITOR
882
352
978
397
fear
count people with  [mood-x >= 2.5 and mood-x <= 5 and mood-y >= 7.5 and mood-y <= 10]
17
1
11

MONITOR
790
353
870
398
anger
count people with  [mood-x >= 7.5 and mood-x <= 10 and mood-y >= 0 and mood-y <= 0.25]
17
1
11

MONITOR
791
406
871
451
frustration
count people with  [mood-x >= 0 and mood-x <= 2.5 and mood-y >= 5 and mood-y <= 7.5]
17
1
11

SLIDER
9
175
181
208
speedboost
speedboost
1
3
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
87
16
150
49
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
9
266
181
299
positive
positive
0
1
0.0
0.00002
1
NIL
HORIZONTAL

SLIDER
10
308
182
341
negative
negative
-1
0
0.0
0.00001
1
NIL
HORIZONTAL

MONITOR
881
406
945
451
nervous
count people with  [mood-x >= 2.5 and mood-x <= 5 and mood-y >= 5 and mood-y <= 7.5]
17
1
11

MONITOR
796
502
853
547
sad
count people with  [mood-x >= 0 and mood-x <= 2.5 and mood-y >= 2.5 and mood-y <= 5]
17
1
11

MONITOR
865
502
922
547
bored
count people with  [mood-x >= 2.5 and mood-x <= 5 and mood-y >= 2.5 and mood-y <= 5]
17
1
11

MONITOR
796
553
874
598
depressed
count people with  [mood-x >= 0 and mood-x <= 2.5 and mood-y >= 0 and mood-y <= 2.5]
17
1
11

MONITOR
882
552
939
597
fatique
count people with  [mood-x >= 2.5 and mood-x <= 5 and mood-y >= 0 and mood-y <= 2.5]
17
1
11

MONITOR
1025
550
1083
595
drowsy
count people with  [mood-x >= 5 and mood-x <= 7.5 and mood-y >= 0 and mood-y <= 2.5]
17
1
11

MONITOR
1093
550
1152
595
relaxed
count people with  [mood-x >= 7.5 and mood-x <= 10 and mood-y >= 0 and mood-y <= 2.5]
17
1
11

MONITOR
1025
498
1082
543
calm
count people with  [mood-x >= 5 and mood-x <= 7.5 and mood-y >= 2.5 and mood-y <= 5]
17
1
11

MONITOR
1093
496
1153
541
content
count people with  [mood-x >= 7.5 and mood-x <= 10 and mood-y >= 2.5 and mood-y <= 5]
17
1
11

MONITOR
1090
404
1147
449
Happy
count people with  [mood-x >= 7.5 and mood-x <= 10 and mood-y >= 5 and mood-y <= 7.5]
17
1
11

MONITOR
1021
405
1078
450
Pride
count people with  [mood-x >= 5 and mood-x <= 7.5 and mood-y >= 7.5 and mood-y <= 10]
17
1
11

MONITOR
1066
353
1147
398
excitement
count people with  [mood-x >= 7.5 and mood-x <= 10 and mood-y >= 7.5 and mood-y <= 10]
17
1
11

MONITOR
1001
354
1061
399
pleased
count people with  [mood-x >= 5 and mood-x <= 7.5 and mood-y >= 5 and mood-y <= 7.5]
17
1
11

MONITOR
953
448
1010
493
neutral
count people with  [mood-x >= 3.75 and mood-x <= 6.25 and mood-y >= 3.75 and mood-y <= 6.25]
17
1
11

TEXTBOX
794
610
1163
638
--------------------------------------------------------->\n0\t                                     Valence (x-axis)\t\t                                        10
11
0.0
1

TEXTBOX
753
347
884
613
^\n| 10\n|\n|\n|\n|A\n|R\n|O\n|U\n|S\n|A\n|L\n|\n|\n|\n|\n|\n|\n|0
11
0.0
1

TEXTBOX
798
464
1148
482
-------------------------                     --------------------->
11
0.0
1

TEXTBOX
987
356
1137
608
^\n|\n|\n|\n|\n|\n\n\n\n\n|\n|\n|\n|\n|\n|\n|\n|\n
11
0.0
1

SLIDER
11
370
183
403
social-influence
social-influence
1
2
1.0
0.01
1
NIL
HORIZONTAL

@#$#@#$#@
### WHAT IS IT?
The model is a simulation of how the mood of a group of agents changes based on factors like interpersonal interaction or the surrounding environment. The model is trying to model how the mood of the agents change over time and tries to explain which factors are espaccially influential.The model also includes empathy levels for each agent, which can influence how they are affected by the patches and other agents' emotions.

### HOW IT WORKS
The agents move around randomly in the environment based on their **speed, which is influenced by their mood**. When an agent encounters a patch, its **mood is affected based on the color of the patch** (green = positive) (grey = negative). The empathy level of each agent can also affect how they are **influenced by other agents' emotions**. Agents can interact with each other within a certain radius (Aura), and their mood can be influenced by these interactions.


### HOW TO USE IT

* **num-people:**
the num-people chooser lets you choose how many agents you want to have in the environment, you can choose between [100, 50, 25, 10]. The more people you have the more interactions will happen.

* **aura:**
The aura chooser changes how big the radius around each agent is on which it is influenced by other people. The lowest setting of 0.25 makes the most sense if we look at external-validity of our model.

* **speedboost:**
The Speedboost slider changes the speedbost the agents get based on the positiveness of their mood. E.g. A happy agent moves *speedboosts time faster than a less happy agent.

* **positive:**
The positive slider changes the amount of positive influence the green environment (park) has on the agents. A higher value stands for a more positive influence when the agent is on a patch which represents the park (green)

* **negative:**
The negative Slider is the counterversion to the positive influence slider, it determines the amount of negative influence the agent gets when located on a grey patch (is in the city)

* **social influence** 
The social influence slider determines the empathy level of each agent and how much an interaction influences the other agent.

* **To use** the model you adjust the sliders and choose how many people you want to have in the environment and click on run and you can observe the count of each mood and a plot on mood development to the right of the environment.

### THINGS TO NOTICE

* **negative slider:**
The negative slider goes from -1 to 0 therfore the higher the negative influence, the more left the slider is. This is counterintuitive but is due to the value of the negative influence, because the value should be negatively influencing the mood.
* **Tick-speed:**
It makes sense to adjust the tick speed to be a bit slower than normal, in order to see the interactions between the agents properly.
* Pay attention to the **mood scores** of each agent and how they change based
on the environment and interactions with other agents.
* Observe how the agents move around in the environment and how their
**speed** is influenced by their mood.
* Notice how the **empathy level** of each agent can affect how they are
influenced by other agents' emotions.

### THINGS TO TRY

* Move the sliders in the Interface tab to see how changing the speed
boost, empathy level, and positive influence affects the behavior of the
agents.
* Switch the emotion of an agent to see how it changes its behavior and
interactions with other agents.
* Try moving an agent to a different patch to see how its mood changes
based on the color of the patch.

##### Here are some intersting settings to try and compare to each other:
* Amount of people : 50, Aura : 0.25, Speed boost: 1, Positive: 0, Negative: 0
* Amount of people : 50, Aura : 0.25, Speed boost: 1, Positive: 0.2, Negative: 0
* Amount of people : 50, Aura : 0.25, Speed boost: 1, Positive: 0, Negative: -0.2
* Amount of people : 50, Aura : 0.25, Speed boost: 1, Positive: 0.2, Negative: -0.2

### EXTENDING THE MODEL

To extend the model you could add more moods or add more environments which would reflect the natural world more. E.g. A festive activity which inluences excitement. In addition a nice addition would be weather to influence the mood of the agents. A very complex addition could be the implementation of adaptive agents in the model, this would show if the agents adapt to their surroundings or based on the interactions to avoid a certain kind of people for example.


### RELATED MODELS

There are many related models in the NetLogo Models Library and elsewhere that explore similar themes of agent behavior and interaction. Some examples include "Social Foraging" by Cameron and Tarnita (2017), "Multi-Agent Simulation of Swarm Behavior" by Hager et al. (2014), and "A Model of Cooperative and Competitive Interaction among Animals" by Boyer
et al. (2013).


### CREDITS AND REFERENCES

GitHub repository: https://github.com/kaispeidel/Moodchanges-NetLogo-MAS-Project.git
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
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="environment, social" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>[mood-x] of turtle 0</metric>
    <metric>[mood-y] of turtle 0</metric>
    <enumeratedValueSet variable="aura">
      <value value="0.25"/>
    </enumeratedValueSet>
    <steppedValueSet variable="positive" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="speedboost">
      <value value="1.4"/>
    </enumeratedValueSet>
    <steppedValueSet variable="negative" first="0" step="0.1" last="1"/>
    <steppedValueSet variable="social-influence" first="1" step="0.1" last="2"/>
    <enumeratedValueSet variable="num-people">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>[mood-x] of turtle 0</metric>
    <metric>[mood-y] of turtle 0</metric>
    <enumeratedValueSet variable="aura">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="positive">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speedboost">
      <value value="1.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="negative">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="social-influence" first="1" step="0.1" last="2"/>
    <enumeratedValueSet variable="num-people">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="environment, social, speed" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>[mood-x] of turtle 0</metric>
    <metric>[mood-y] of turtle 0</metric>
    <enumeratedValueSet variable="aura">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="positive">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speedboost">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="negative">
      <value value="0"/>
      <value value="-0.5"/>
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-influence">
      <value value="1"/>
      <value value="1.5"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-people">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
