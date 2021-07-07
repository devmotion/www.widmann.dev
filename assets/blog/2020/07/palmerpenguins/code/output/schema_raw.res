Tables.Schema:
 :studyName                     String
 Symbol("Sample Number")        Int64
 :Species                       String
 :Region                        String
 :Island                        String
 :Stage                         String
 Symbol("Individual ID")        String
 Symbol("Clutch Completion")    Bool
 Symbol("Date Egg")             Dates.Date
 Symbol("Culmen Length (mm)")   Union{Missing, Float64}
 Symbol("Culmen Depth (mm)")    Union{Missing, Float64}
 Symbol("Flipper Length (mm)")  Union{Missing, Int64}
 Symbol("Body Mass (g)")        Union{Missing, Int64}
 :Sex                           Union{Missing, String}
 Symbol("Delta 15 N (o/oo)")    Union{Missing, Float64}
 Symbol("Delta 13 C (o/oo)")    Union{Missing, Float64}
 :Comments                      Union{Missing, String}