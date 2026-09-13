---
name: mapsdk-usage
description: Build, consume and validate mapsdk through its public Cangjie API.
---

# mapsdk usage

Read [API](../docs/api.md), [build](../docs/build.md) and [limits](../docs/limits.md) before edits. Confirm the exact dependency commit and compiler version. Use examples/basic.cj as an external consumer, not a replacement implementation.

坐标校验 → 球面距离/瓦片/Geohash → GeoJSON输出。纯函数无外部句柄。

Validate ordinary inputs, boundary inputs and errors through the same API. Run cjpm build and cjpm test, retain the actual exit status. Test package contents and a separate consumer after packaging changes. Never remove a failing regression or claim an untested platform.

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。
