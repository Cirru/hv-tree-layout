
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

默认构建使用相对路径；`VITE_BASE_URL` 可以指定前端 CDN 路径。CI 的主分支资源位于 `https://cos-sh.tiye.me/Cirru/hv-tree-layout/`，PR 使用独立的 `pr/<number>/<run>/<attempt>/` 子目录，构建、上传和公开访问校验共用同一个前缀。配置 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 后，由正式 cos-upload-action 1.2.0 的内置能力检查 HTML 同域脚本/样式引用与上传内容，不再增加项目校验脚本；Action 使用该发布版本的不可变提交。

保留已测试 artifact 的传递、上传队列、过期 HEAD 检查和原 main push 服务器部署；COS 只处理前端 `dist`，原 `dist/*` 和目标目录不变。CI 不再要求固定迁移期 `fix strict` workflow，仍保留严格依赖/工具链、canonical、类型、全部公开定义、废弃调用、原质量基线、原附带业务测试和 JS 构建。Calcit/procs 本轮仍为 0.27.0；完整 0.28 类型迁移候选单独保留，不能用这个部署 PR 代表类型升级已完成。
