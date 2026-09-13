package CjKu::mapsdk

import std.collection.ArrayList
import std.collection.HashMap
import std.math.*

const PI: Float64 = 3.14159265358979
const EARTH_R_KM: Float64 = 6371.0088

func requireCoordinate(lat: Float64, lon: Float64): Unit {
    if (!(lat >= -90.0 && lat <= 90.0 && lon >= -180.0 && lon <= 180.0)) {
        throw IllegalArgumentException("coordinates require latitude [-90,90] and longitude [-180,180]")
    }
}

func rad(d: Float64): Float64 {
    return d * PI / 180.0
}

// Great-circle distance in kilometers (haversine).
public func haversineKm(lat1: Float64, lon1: Float64,
    lat2: Float64, lon2: Float64): Float64 {
    requireCoordinate(lat1, lon1)
    requireCoordinate(lat2, lon2)
    let dLat = rad(lat2 - lat1)
    let dLon = rad(lon2 - lon1)
    let a = sin(dLat / 2.0) * sin(dLat / 2.0) +
        cos(rad(lat1)) * cos(rad(lat2)) * sin(dLon / 2.0) * sin(dLon / 2.0)
    let bounded = if (a < 0.0) { 0.0 } else if (a > 1.0) { 1.0 } else { a }
    return 2.0 * EARTH_R_KM * asin(sqrt(bounded))
}

// ---- slippy tiles ----

public func tileX(lon: Float64, zoom: Int64): Int64 {
    if (lon != lon || lon == Float64.Inf || lon == -Float64.Inf) {
        throw IllegalArgumentException("tileX: longitude must be finite")
    }
    if (zoom < 0 || zoom > 30) {
        throw IllegalArgumentException("tileX: zoom must be within 0..30")
    }
    let n = 1 << zoom
    var x = Float64ToInt64((lon + 180.0) / 360.0 * Float64(n))
    if (x < 0) { x = 0 }
    if (x >= n) { x = n - 1 }
    return x
}

public func tileY(lat: Float64, zoom: Int64): Int64 {
    // M1: Web Mercator is undefined at the poles — the old code HUNG forever
    // on |lat| >= 90 (tan/cos cancellation -> log(0) -> Int64(+inf) loop).
    // Explicit domain guard instead of a silent hang.
    if (!tileClampGuard(lat)) {
        throw IllegalArgumentException("tileY: latitude outside Web Mercator range [-85.0511, 85.0511]")
    }
    if (zoom < 0 || zoom > 30) {
        throw IllegalArgumentException("tileY: zoom must be within 0..30")
    }
    let n = 1 << zoom
    let r = rad(lat)
    var y = Float64ToInt64((1.0 - log(tan(r) + 1.0 / cos(r)) / PI) / 2.0 * Float64(n))
    if (y < 0) { y = 0 }
    if (y >= n) { y = n - 1 }
    return y
}

func Float64ToInt64(v: Float64): Int64 {
    // M2/M3: O(1) conversion with finite-range clamp. The old counting loop
    // was O(value) (tileX(-1e9) took seconds) and HUNG on non-finite input.
    if (v != v) { return 0 }
    if (v >= 9.0e18) { return Int64.Max }
    if (v <= -9.0e18) { return Int64.Min }
    return Int64(v)
}

public func tileClampGuard(lat: Float64): Bool {
    return lat >= -85.0511 && lat <= 85.0511
}

// ---- geohash (base32, even bits = longitude) ----

let B32_RUNES: Array<Rune> = "0123456789bcdefghjkmnpqrstuvwxyz".toRuneArray()

public func geohashEncode(lat: Float64, lon: Float64, precision: Int64): String {
    requireCoordinate(lat, lon)
    if (precision < 1 || precision > 12) {
        throw IllegalArgumentException("geohash precision must be within 1..12")
    }
    var latLo = -90.0
    var latHi = 90.0
    var lonLo = -180.0
    var lonHi = 180.0
    var isLon = true
    var bit = 0
    var chIdx = 0
    let sb = StringBuilder()
    var chars: Int64 = 0
    while (chars < precision) {
        if (isLon) {
            let mid = (lonLo + lonHi) / 2.0
            if (lon > mid) {
                chIdx = chIdx * 2 + 1
                lonLo = mid
            } else {
                chIdx = chIdx * 2
                lonHi = mid
            }
        } else {
            let mid = (latLo + latHi) / 2.0
            if (lat > mid) {
                chIdx = chIdx * 2 + 1
                latLo = mid
            } else {
                chIdx = chIdx * 2
                latHi = mid
            }
        }
        isLon = !isLon
        bit += 1
        if (bit == 5) {
            sb.append(B32_RUNES[chIdx])
            bit = 0
            chIdx = 0
            chars += 1
        }
    }
    return sb.toString()
}

public func geohashDecode(hash: String): (Float64, Float64, Float64, Float64) {
    if (hash.size < 1 || hash.size > 12) {
        throw IllegalArgumentException("geohash length must be within 1..12")
    }
    var latLo = -90.0
    var latHi = 90.0
    var lonLo = -180.0
    var lonHi = 180.0
    var isLon = true
    for (r in hash.toRuneArray()) {
        let s = runeStr(r)
        var idx: Int64 = -1
        var i: Int64 = 0
        while (i < 32) {
            if (runeStr(B32_RUNES[i]) == s) { idx = i; break }
            i += 1
        }
        if (idx < 0) {
            // M3: invalid characters used to be silently skipped, returning
            // a wrong cell; explicit refusal instead
            throw IllegalArgumentException("geohashDecode: invalid character in hash")
        }
        var bit: Int64 = 4
        while (bit >= 0) {
            let set = (idx >> bit) & 1
            if (isLon) {
                let mid = (lonLo + lonHi) / 2.0
                if (set == 1) { lonLo = mid } else { lonHi = mid }
            } else {
                let mid = (latLo + latHi) / 2.0
                if (set == 1) { latLo = mid } else { latHi = mid }
            }
            isLon = !isLon
            bit -= 1
        }
    }
    return (latLo, latHi, lonLo, lonHi)
}

func runeStr(r: Rune): String {
    let sb = StringBuilder()
    sb.append(r)
    return sb.toString()
}

// ---- GeoJSON (minimal) ----

public func geojsonPoint(lat: Float64, lon: Float64, name: String): String {
    requireCoordinate(lat, lon)
    // M4: NaN/Inf coordinates would render as non-JSON (inf/nan literals)
    if (lat != lat || lon != lon || lat == Float64.Inf || lon == Float64.Inf ||
        lat == -Float64.Inf || lon == -Float64.Inf) {
        throw IllegalArgumentException("geojsonPoint: coordinates must be finite")
    }
    let sb = StringBuilder()
    sb.append("{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[")
    sb.append(numStr(lon))
    sb.append(",")
    sb.append(numStr(lat))
    sb.append("]},\"properties\":{\"name\":\"")
    sb.append(escapeJson(name))
    sb.append("\"}}")
    return sb.toString()
}

public func escapeJson(s: String): String {
    let hexd = "0123456789abcdef"
    let out = ArrayList<UInt8>()
    for (b in s.toArray()) {
        if (b == 34 || b == 92) {
            out.add(92)
            out.add(b)
        } else if (b < 32) {
            // M4: control characters need FOUR hex digits — the old two-digit
            // form (\u0a) is not valid JSON
            out.add(92)
            out.add(117)
            out.add(48) // '0'
            out.add(48) // '0'
            out.add(hexd[Int64((b >> 4) & 0xF)])
            out.add(hexd[Int64(b & 0xF)])
        } else {
            out.add(b)
        }
    }
    return String.fromUtf8(out.toArray())
}

func numStr(v: Float64): String {
    return v.toString()
}

// A Polygon Feature with one closed exterior ring; pairs are (latitude, longitude).
// Winding, self-intersection and holes remain the caller's geometry responsibility.
public func geojsonPolygon(ring: Array<(Float64, Float64)>, name: String): String {
    if (ring.size < 4 || ring[0] != ring[ring.size - 1]) {
        throw IllegalArgumentException("polygon exterior ring requires at least four positions and closure")
    }
    let sb = StringBuilder()
    sb.append("{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[")
    var first = true
    for ((lat, lon) in ring) {
        requireCoordinate(lat, lon)
        if (!first) { sb.append(",") }
        first = false
        sb.append("[" + numStr(lon) + "," + numStr(lat) + "]")
    }
    sb.append("]]},\"properties\":{\"name\":\"" + escapeJson(name) + "\"}}")
    return sb.toString()
}
