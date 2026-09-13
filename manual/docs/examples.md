# 示例

[仓外消费源码](../../examples/basic.cj) 使用正式公开API，保存到应用的src/main.cj并按[构建说明](build.md)配置依赖。

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
