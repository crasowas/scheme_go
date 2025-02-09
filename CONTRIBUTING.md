# Contributing

感谢您对本项目的兴趣！欢迎您的贡献。

## 代码规范

- 请遵循项目的代码风格。
- 确保代码通过所有测试。

## 代码提交

在提交您的改动之前，请先运行以下命令：

```shell
sh ./scripts/pre_push.sh
```

确保未遇到错误后再提交。

## 完善App数据

通过运行以下命令快速往[apps_data.json](./apps_data.json)中添加预填充数据：

```shell
dart run ./scripts/add_app_data.dart <app_name> [country]
```

这一步主要帮助您快速获取App的id，其余字段还需要手动填充。

添加完成后，运行以下命令生成[apps.json](./web/apps.json)：

```shell
dart run ./scripts/generate_apps_json.dart --pretty
```

检查添加的App数据是正确，如果无误则可以考虑提交PR。
