package consumer
import CjKu::mapsdk.*
main(): Int64 {
    let distance = haversineKm(31.0, 121.0, 31.1, 121.1)
    println(distance)
    println(geojsonPoint(31.0, 121.0, "上海"))
    return 0
}
