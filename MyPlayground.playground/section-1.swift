import SKTUtils

let pt1 = CGPoint(x: 10, y: 20)
let pt2 = CGPoint(x: -5, y: 0)
let pt3 = pt1 + pt2
let pt4 = pt3 * 100

println("Point has length \(pt4.length())")

let pt5 = pt4.normalized()
let dist = pt1.distanceTo(pt2)
