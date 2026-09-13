package CjKu::mapsdk

import std.math.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
func jdnStyleGoldenBeijingToShanghai(): Unit {
    let d = haversineKm(39.9042, 116.4074, 31.2304, 121.4737)
    @Assert(abs(d - 1068.0) < 5.0)
}

@Test
func zeroDistance(): Unit {
    @Assert(abs(haversineKm(31.0, 121.0, 31.0, 121.0)) < 1.0e-9)
}

@Test
func slippyTileGolden(): Unit {
    // origin maps to the middle tile at any zoom
    @Assert(tileX(0.0, 1) == 1 && tileY(0.0, 1) == 1)
    @Assert(tileX(0.0, 3) == 4 && tileY(0.0, 3) == 4)
    // antimeridian clamps
    @Assert(tileX(179.9, 2) == 3)
    @Assert(tileX(-179.9, 2) == 0)
}

@Test
func geohashWikipediaGolden(): Unit {
    @Assert(geohashEncode(42.6, -5.6, 5) == "ezs42")
}

@Test
func geohashDecodeBoundsContainInput(): Unit {
    let (la, lb, lo, ob) = geohashDecode("ezs42")
    @Assert(la <= 42.6 && 42.6 <= lb)
    @Assert(lo <= -5.6 && -5.6 <= ob)
}

@Test
func geojsonEscapesStrings(): Unit {
    let j = geojsonPoint(31.0, 121.0, "a\"b")
    @Assert(j.contains("a\\\"b"))
}

@Test
func tileYRejectsPolesInsteadOfHanging(): Unit {
    // M1: |lat| >= 90 used to hang forever; now an explicit domain error
    var threw = false
    try { let _ = tileY(-90.0, 4) } catch (e: IllegalArgumentException) { threw = true }
    @Assert(threw)
    var threw2 = false
    try { let _ = tileY(90.0, 4) } catch (e: IllegalArgumentException) { threw2 = true }
    @Assert(threw2)
    // in-range latitudes keep working
    @Assert(tileY(-85.0, 4) >= 0)
    @Assert(tileY(85.0, 4) >= 0)
    var zoomThrew = false
    try { let _ = tileY(0.0, 40) } catch (e: IllegalArgumentException) { zoomThrew = true }
    @Assert(zoomThrew)
}
