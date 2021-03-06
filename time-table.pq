// A collection a useful tools for building Microsoft Power BI queries.
//
// Author: Kim Burgess <kim@acaprojects.com>
// Repo:   https://github.com/acaprojects/m-tools

/**
 * Create a table of common time deliniations across a 24 hour period for
 * slicing time based data sets in interesting ways.
 *
 * :: () -> Table
 */
let CreateTimeTable = () as table =>
    let
        MinutesInDay = 60 * 24,

        MinuteList = List.Times(#time(0, 0, 0), MinutesInDay, #duration(0,0,1,0)),

        Seed = M[ChainOperations]({
            {Table.FromList, Splitter.SplitByNothing(), {"Time"}},
            {Table.TransformColumnTypes, {{"Time", type time}}}
        })(MinuteList),

        BuildTable = M[AddColumns]({
            // Time components
            {"Hour Number", each Time.Hour([Time]), Int64.Type},
            {"Minute", each Time.Minute([Time]), Int64.Type},

            // Quantizations with the day (floor)
            {"Hour", each Time.StartOfHour([Time]), type time},
            {"Quarter Hour",
                each if [Minute] < 15 then [Hour]
                    else if [Minute] < 30 then Value.Add([Hour], #duration(0,0,15, 0))
                    else if [Minute] < 45 then Value.Add([Hour], #duration(0,0,30, 0))
                    else Value.Add([Hour], #duration(0,0,45, 0)),
                type time
            },
            {"Period of Day",
                each if [Hour Number] >= 0 and [Hour Number] < 4 then "After Midnight"
                    else if [Hour Number] >= 4 and [Hour Number] < 8 then "Early Morning"
                    else if [Hour Number] >= 8 and [Hour Number] < 12 then "Late Morning"
                    else if [Hour Number] >= 12 and [Hour Number] < 16 then "Afternoon"
                    else if [Hour Number] >= 16 and [Hour Number] < 20 then "Evening"
                    else "Late Night",
                type text
            },
            {"Period Sort",
                each if [Hour Number] >= 0 and [Hour Number] < 4 then 0
                    else if [Hour Number] >= 4 and [Hour Number] < 8 then 1
                    else if [Hour Number] >= 8 and [Hour Number] < 12 then 2
                    else if [Hour Number] >= 12 and [Hour Number] < 16 then 3
                    else if [Hour Number] >= 16 and [Hour Number] < 20 then 4
                    else 5,
                Int64.Type
            },

            // Ceiling quantizations for duration windows
            {"Next Hour",
                each Value.Add([Hour], #duration(0,1,0, 0)),
                type time
            },
            {"Next Quarter Hour",
                each Value.Add([Quarter Hour], #duration(0,0,15, 0)),
                type time
            }
        }),

        Table = BuildTable(Seed)
    in
        Table
in
    CreateTimeTable
