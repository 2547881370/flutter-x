
## 自动路由注册说明

> 注意,本项目进行自动路由注册的文件是在`lib/router/route_map.dart`进行注册的,自动生成的路由表文件是`lib/router/route_map.gr.dart`.

* 使用[watch]实时动态刷新路由表
```
flutter packages pub run build_runner watch
```
* 生成一次路由表
```
flutter packages pub run build_runner build
```
* 清除路由表
```
flutter packages pub run build_runner clean
```

## 更新插件版本

```
flutter packages upgrade
flutter pub outdated
flutter pub upgrade --major-versions
```

---

