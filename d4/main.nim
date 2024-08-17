import strscans
import std/strformat
import std/strutils
import std/sequtils
import std/tables
import std/algorithm

type
    Guard = tuple[total: int, minutes: array[0..59, int]]

proc readSchedule() =
    let f = open("./i.txt")
    defer: f.close()

    var line: string
    var norm_lines: seq[string] = @[]

    while f.read_line(line):
        var y, d, M, h, m: int
        var rest: string
        if scanf(line, "[$i-$i-$i $i:$i] $*", y, M, d, h, m, rest):
            norm_lines.insert(fmt"{y:04}-{M:02}-{d:02} {h:02}:{m:02} {rest}")

    norm_lines.sort()

    var guards = initTable[int, Guard]()
    var c_gid, ss: int

    for line in norm_lines:
        var y, d, M, h, m, gid: int
        if scanf(line, "$i-$i-$i $i:$i Guard #$i", y, M, d, h, m, gid):
            ss = -1
            c_gid = gid
            if not guards.hasKey(gid):
                var minutes: array[0..59, int]
                guards[gid] = (0, minutes)
        if scanf(line, "$i-$i-$i $i:$i falls", y, M, d, h, m):
            ss = parseInt(fmt"{h}{m}")
        if scanf(line, "$i-$i-$i $i:$i wakes", y, M, d, h, m):
            if ss >= 0:
                var cs = parseInt(fmt("{h}{m}"))
                for i in ss..cs:
                    guards[c_gid].total += 1
                    guards[c_gid].minutes[i] += 1
                ss = -1

    var top_m, top_max, top_g, top_single_g, top_single_m, top_single_max: int
    for key, val in guards:
        var mm = minmax(val.minutes)
        if val.total > top_max:
            top_max = val.total
            top_g = key
            top_m = maxIndex(val.minutes)
        if mm[1] > top_single_max:
            top_single_max = mm[1]
            top_single_m = maxIndex(val.minutes)-1
            top_single_g = key

    echo top_g*top_m, " ", top_single_g*top_single_m

readSchedule()
