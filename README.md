# scheme_go

一个简单的Web项目，收集了一些网上公开的URL Scheme以及分享的快捷指令用于测试APP唤起。

在线页面：[Scheme Go](https://sg.crasowas.dev)

## 跳过开屏广告

本项目源于这篇文章：[0.5 秒直抵主页！苹果产品告别开屏广告，从此追剧看文无打扰](https://api.xiaoheihe.cn/v3/bbs/app/api/web/share?link_id=d9bf6fc9fbee)。

不得不说里面的方法有一定的可行性。首先要先**简单了解**一下URL Scheme是什么东西，它通常是下面这种形式：

```text
scheme://
```

是不是感觉这东西你天天见，很像`https://`形式，那还真有一点点区别，`https://`这种是标准的Scheme，而**URL Scheme本质指的是自定义Scheme**。

假如你现在打算开发一个iOS应用叫`ABC`，然后想支持其他应用或应用内部像URL一样跳转解析，这时你就可以自定义属于`ABC`应用的Scheme，简单点就叫`abc`，需要在`Info.plist`文件中注册URL Scheme：

```text
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>abc</string>
        </array>
    </dict>
</array>
```

当其他应用请求打开`abc://xxx`URL时，系统就会看看谁注册了这个`abc`Scheme，然后唤起注册的应用解析处理。所以它为什么能跳过开屏广告呢？

从前面的简单了解你也可以看出，这东西设计之初就不是直接给普通用户使用的，它是用于应用内部或不同应用之间的跳转，在分享/第三方支付/从一个应用内的广告点击跳转到另一个应用的商品详情等等场景广泛使用。

通过它唤起应用会走专门的回调方法处理，总不能用户分享/支付跳转过来先在这回调里给用户加载一个广告吧，所以绝大部分应用都只是在正常冷/热启动时加载开屏广告，这就是为什么这种方式唤起应用一般没开屏广告。

**但是话又说回来，这广告还不是想加就加，所以只能说有一定的可行性。**

## 完善APP数据

欢迎大家一起完善收录的APP数据👏，以下是常见的贡献方式：

1. 在项目下的[apps_data.json](https://github.com/crasowas/scheme_go/blob/main/apps_data.json)文件中追加新的APP数据，然后提PR。APP数据格式如下：

```json
{
  "appId": "应用id（必填）",
  "schemes": [
    {
      "scheme": "URL Scheme（必填）",
      "shortcut": "快捷指令分享链接（可选）",
      "desc": "额外描述，用于区分多个Scheme（可选）"
    }
  ]
}
```

如果有开发环境，建议修改后在项目根目录运行以下命令：

```shell
dart run ./scripts/generate_apps_json.dart
```

检查自动生成的`web/apps.json`文件中，新增的APP数据是否正确。
