# Boundaries

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。

Read [public API](../docs/api.md). Do not infer network, cryptographic certification or platform support from compilation.
