# 使用范围

地理计算、地图瓦片、Geohash 与 GeoJSON 的纯仓颉工具库。

坐标校验 → 球面距离/瓦片/Geohash → GeoJSON输出。纯函数无外部句柄。

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。
