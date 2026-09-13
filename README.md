<p align="center">
 <img src="https://img.shields.io/badge/Cangjie-mapsdk-ff6b35?style=for-the-badge&labelColor=1a1a2e" alt="mapsdk" />
 <img src="https://img.shields.io/badge/version-0.2.0-blue?style=for-the-badge&labelColor=1a1a2e" alt="Version" />
 <img src="https://img.shields.io/badge/license-Apache%202.0-green?style=for-the-badge&labelColor=1a1a2e" alt="License" />
</p>

<div align="center">
<span style="font-weight:300;font-size:38px">mapsdk</span><br/>
<span style="font-weight:100;font-size:26px">地理计算、地图瓦片、Geohash 与 GeoJSON 的纯仓颉工具库</span>
<p align="center">
 <sub>地理距离 · Web Mercator 瓦片 · Geohash · GeoJSON</sub>
</p>
</div>

<p align="center">
 <a href="https://github.com/Celading/mapsdk">开源主仓</a> ·
 <a href="https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/manual/docs/build.md">接入指南</a>
</p>

> 当前文档对应版本：`0.2.0` · Cangjie `1.1.3`

## 快速开始

```toml
[dependencies]
"CjKu::mapsdk" = "0.2.0"
```

也可构建本组织分支源码：

```sh
git clone --branch publication/cjku-0.2.0 https://github.com/Celading/mapsdk.git
cd mapsdk
cjpm build
cjpm test
```

```cangjie
package consumer
import CjKu::mapsdk.*
main(): Int64 {
    let distance = haversineKm(31.0, 121.0, 31.1, 121.1)
    println(distance)
    println(geojsonPoint(31.0, 121.0, "上海"))
    return 0
}
```

[接入与打包](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/manual/docs/build.md) · [API](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/manual/docs/api.md) · [边界](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/manual/docs/limits.md) · [使用工作流](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/manual/skill/SKILL.md)

## 能力边界

球面距离不是椭球测量。GeoJSON仅写 Point / 单外环 Polygon；不解析、不验证自交/绕向、不处理洞和坐标系转换。数值输出沿用 Float64.toString 的精度。没有在线地理编码服务。

## License

见 [LICENSE](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/LICENSE) 与 [NOTICE](https://github.com/Celading/mapsdk/blob/publication/cjku-0.2.0/NOTICE)。本分支用于 CjKu 组织发行；不声明全平台认证。
