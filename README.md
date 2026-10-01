
# Right-Heavy HV Tree

基于 Calcit 的树形布局实验。在线预览：http://repo.cirru.org/hv-tree-layout/ 。

浏览器交互通过 `:js-ffi` 中的 `js-ffi.browser` 接口访问 DOM、存储和定时器；布局数据仍由 Calcit 管理。

### 本地验证

需要 Calcit 0.27.0、Caps 以及 Node.js 24。安装依赖后运行：

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --check-only
calcit calcit.cirru analyze check-public --ns app.main --ns app.comp.container --ns app.comp.expr --ns app.updater --ns app.config --ns app.schema --summary-only
calcit calcit.cirru test --require-match
calcit calcit.cirru js
yarn vite build
```

`calcit -w` 可用于本地交互调试。项目基于 [Calcit Workflow](https://github.com/mvc-works/calcit-workflow)，采用 MIT 许可证。

默认构建使用相对路径；`VITE_BASE_URL` 可以指定前端 CDN 路径。CI 的主分支资源位于 `https://cos-sh.tiye.me/Cirru/hv-tree-layout/`，PR 使用独立的 `pr/<number>/` 子目录。配置 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 后，由 cos-upload-action 自身验证上传结果，无额外校验脚本。原有服务器部署仍只在 main push 时执行，`dist/*` 和目标目录保持不变。
