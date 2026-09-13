package mapsdk
import std.unittest.*
import std.unittest.testmacro.*
func rejectsGeo(f: () -> Unit): Bool {
    try { f() } catch (e: IllegalArgumentException) { return true }
    return false
}
@Test
func coordinatesAndPrecisionAreValidated(): Unit {
    @Assert(rejectsGeo({ => let _ = haversineKm(91.0, 0.0, 0.0, 0.0) }))
    @Assert(rejectsGeo({ => let _ = tileX(Float64.Inf, 2) }))
    @Assert(rejectsGeo({ => let _ = geohashEncode(0.0, 0.0, -1) }))
    @Assert(rejectsGeo({ => let _ = geohashEncode(0.0, 0.0, 13) }))
    @Assert(rejectsGeo({ => let _ = geohashDecode("") }))
    @Assert(rejectsGeo({ => let _ = geojsonPoint(91.0, 0.0, "x") }))
}
@Test
func antipodalDistanceIsFinite(): Unit {
    let d = haversineKm(90.0, 180.0, -90.0, -180.0)
    @Assert(d > 20015.0 && d < 20016.0)
}
@Test
func polygonRequiresClosedFiniteRing(): Unit {
    let j = geojsonPolygon([(0.0, 0.0), (0.0, 1.0), (1.0, 0.0), (0.0, 0.0)], "triangle")
    @Assert(j.contains("\"Polygon\""))
    @Assert(rejectsGeo({ => let _ = geojsonPolygon([(0.0, 0.0)], "bad") }))
}
