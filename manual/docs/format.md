# 数据与错误

`haversineKm(lat1, lon1, lat2, lon2)` 返回球面距离（km）；经纬度分别校验 ±90/±180，非有限值拒绝，对跖点舍入夹取。

`tileX(lon, zoom)` / `tileY(lat, zoom)` 返回 0..2^zoom-1 的瓦片下标，zoom 为 0..30。X 对有限越界经度夹取；Y 要求纬度在 ±85.0511 内。`tileClampGuard` 返回纬度是否在此域内。

`geohashEncode(lat, lon, precision)` / `geohashDecode(hash)` 支持 1..12 字符；解码返回 (latLo, latHi, lonLo, lonHi)。非法字符拒绝，区间中点归低半区（保留原有边界约定）。

`geojsonPoint(lat, lon, name)` 与 `geojsonPolygon(ring, name)` 输出 Feature。ring 为 (lat,lon) 数组，至少4点且首尾相同，输出次序为 [lon,lat]。`escapeJson` 返回不含外围引号的转义字符串。非法输入抛 IllegalArgumentException。

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。
