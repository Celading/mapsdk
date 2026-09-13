# mapsdk

地理计算、地图瓦片、Geohash 与 GeoJSON 的纯仓颉工具库。

Version 0.2.0 · Cangjie 1.1.3 · Apache-2.0

## 快速开始

```sh
git clone https://github.com/Celading/mapsdk.git
cd mapsdk
cjpm build
cjpm test
```

```cangjie
package consumer
import mapsdk.*
main(): Int64 {
    let distance = haversineKm(31.0, 121.0, 31.1, 121.1)
    println(distance)
    println(geojsonPoint(31.0, 121.0, "上海"))
    return 0
}
```

[接入与打包](manual/docs/build.md) · [API](manual/docs/api.md) · [边界](manual/docs/limits.md) · [使用工作流](manual/skill/SKILL.md)

## 能力边界

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。

## License

见 [LICENSE](LICENSE) 与 [NOTICE](NOTICE)。当前为源码发行，未声明中心仓上架或全平台认证。
