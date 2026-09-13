# mapsdk workflow

Read [API](../../docs/api.md) and [limits](../../docs/limits.md). Start with [the consumer example](../../docs/examples.md).

`haversineKm(lat1, lon1, lat2, lon2)` 返回球面距离（km）；经纬度分别校验 ±90/±180，非有限值拒绝，对跖点舍入夹取。

`tileX(lon, zoom)` / `tileY(lat, zoom)` 返回 0..2^zoom-1 的瓦片下标，zoom 为 0..30。X 对有限越界经度夹取；Y 要求纬度在 ±85.0511 内。`tileClampGuard` 返回纬度是否在此域内。

`geohashEncode(lat, lon, precision)` / `geohashDecode(hash)` 支持 1..12 字符；解码返回 (latLo, latHi, lonLo, lonHi)。非法字符拒绝，区间中点归低半区（保留原有边界约定）。

`geojsonPoint(lat, lon, name)` 与 `geojsonPolygon(ring, name)` 输出 Feature。ring 为 (lat,lon) 数组，至少4点且首尾相同，输出次序为 [lon,lat]。`escapeJson` 返回不含外围引号的转义字符串。非法输入抛 IllegalArgumentException。

Make a focused change, retain existing boundary tests, add a matching regression and run cjpm build / cjpm test. Record actual output and exit codes; do not reuse old passing logs for a new revision.
