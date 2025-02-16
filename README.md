# Scheme Go

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/crasowas/scheme_go/deploy.yml)](https://github.com/crasowas/scheme_go/actions/workflows/deploy.yml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

一个简单的Web项目，收集了一些网上公开的URL Schemes以及分享的快捷指令用于测试App唤起。

## 快速开始

在线页面：[Scheme Go](https://sg.crasowas.dev)。
> **建议使用Safari浏览器打开**。原因有两个：一是iOS自带的浏览器对URL Schemes支持比较好，二是精力有限主要在Safari浏览器测试。

### 测试App唤起

在线页面中，App下方的每个URL Scheme都可以被点击，如果能唤起App，会弹框提示`在“xxx”中打开？`，唤起失败会提示`Safari浏览器打不开该网页，因为网址无效。`。

如果已安装App，但还是唤起失败，可能URL Scheme有误或已失效，欢迎反馈。

### 添加快捷指令

点击页面中的【**Shortcut**】可以快速添加用于唤起App的快捷指令。

如果需要将唤起App的快捷指令添加到桌面，可以先点击【**App图标**】下载App图标（每周会自动更新一次App图标），然后点击【**Shortcut**】添加快捷指令，最后添加到主屏幕时通过【**选取文件**】选取下载的App图标用于自定义图标。

更多详情请看：[简化用于唤起App快捷指令的添加流程](https://api.xiaoheihe.cn/v3/bbs/app/api/web/share?link_id=fe256fd640b3)。

## 跳过开屏广告

本项目源于这篇文章：[0.5 秒直抵主页！苹果产品告别开屏广告，从此追剧看文无打扰](https://api.xiaoheihe.cn/v3/bbs/app/api/web/share?link_id=d9bf6fc9fbee)。

不得不说里面的方法有一定的可行性。首先，我们需要简单了解一下URL Scheme是什么。它通常是下面这种形式：

```text
scheme://
```

是不是觉得这种格式很常见，看起来很像`https://`？其实还是有一些区别：`https://`是标准的Scheme，而URL Scheme既包括标准的Scheme，也包括App自定义的Scheme（例如`myapp://`）。

假如现在打算开发一个iOS App叫`ABC`，然后想支持其他App或App内部跳转，这时就可以自定义属于`ABC`的Scheme，简单点就叫`abc`，需要在`Info.plist`文件中注册URL Scheme：

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

当其他App请求打开`abc://xxx`URL时，系统就会看看谁注册了这个`abc`Scheme，然后唤起注册的App解析处理。所以它为什么能跳过开屏广告呢？

从前面的简单了解也可以看出，这东西设计之初就不是直接给普通用户使用的，它是用于App内部或不同App之间的跳转，在分享/第三方支付/从一个App内的广告点击跳转到另一个App的商品详情等等场景广泛使用。

通过它唤起App会走专门的回调方法处理，总不能用户分享/支付跳转过来先在这回调里给用户加载一个广告吧，所以绝大部分App都只是在正常冷/热启动时加载开屏广告，这就是为什么这种方式唤起App一般没开屏广告。

**但是话又说回来，这广告还不是想加就加，所以只能说有一定的可行性。**

## 完善App数据

提交入口：[Submit App Data](https://github.com/crasowas/scheme_go/issues/new?template=submit-app-data.md)。

关键要填的就两个数据，一是App名称，二是URL Scheme。如果不确定URL Scheme也可以提交，只是根据App名称不一定能找到。

## 贡献指南

欢迎为该项目做出贡献，详情请看：[CONTRIBUTING.md](./CONTRIBUTING.md)。
