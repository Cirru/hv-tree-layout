
# Right-Heavy HV Tree

基于 Calcit 的树形布局实验。在线预览：http://repo.cirru.org/hv-tree-layout/ 。

浏览器交互通过 `:js-ffi` 中的 `js-ffi.browser` 接口访问 DOM、存储和定时器；布局数据仍由 Calcit 管理。

### 本地验证

使用者影响：需要精确配套正式 Calcit / `@calcit/procs` **0.30.1**、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。四个直接模块均使用正式 tag：Respo 0.16.126、Reel 0.6.42、Respo UI 0.8.1、js-ffi 0.2.6，传递 Router 0.8.38。升级后完整刷新；UI 0.8 可能改变 Demo 基础控件外观，三组布局样例、历史回放、原存档 key/格式与错误暂停保存行为不变。安装依赖后运行：

```bash
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit fix --workflow strict --verify
calcit calcit.cirru --check-only --ns app.main --ns app.comp.container --ns app.comp.expr --ns app.updater --ns app.config --ns app.schema --summary-only
calcit calcit.cirru test --require-match
calcit calcit.cirru analyze quality --baseline config/calcit-quality.cirru
calcit calcit.cirru js
yarn vite build
```

实时编译可另开终端运行 `calcit calcit.cirru js -w`，无需 concurrently。项目基于 [Calcit Workflow](https://github.com/mvc-works/calcit-workflow)，采用 MIT 许可证。

默认构建使用相对路径；`VITE_BASE_URL` 可以指定前端 CDN 路径。CI 的主分支资源位于 `https://cos-sh.tiye.me/Cirru/hv-tree-layout/`，PR 使用独立的 `pr/<number>/<run>/<attempt>/` 子目录，构建、上传和公开访问校验共用同一个前缀。配置 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 后，由正式 cos-upload-action 1.2.0 的内置能力检查 HTML 同域脚本/样式引用与上传内容，不再增加项目校验脚本；Action 使用该发布版本的不可变提交。

保留已测试 artifact 的传递、上传队列、过期 HEAD 检查和原 main push 服务器部署；COS 只处理前端 `dist`，原 `dist/*` 和目标目录不变。CI 保留严格依赖/工具链、canonical、全定义与公开定义检查、质量预算、附属测试和 JS 构建，并要求完整 `fix --workflow strict --verify` 通过且 diagnostics 为空。废弃调用由已有质量预算的零上限拦截，不另加重复检查脚本。

### 迁移影响与边界

本轮将三处布局样式 Map 合并改为 `.merge`，保持右侧覆盖顺序；原状态回归中的三处
Option 解包改为 `.unwrap`，测试名称、标签和全部断言不变。空 Reel 直接用公开
`typed/State` 构造器及已有 `Ref<State<Op,Store>>` 上下文初始化，七个字段与原
`new-reel` 完全相同，移除无法证明 Op 来源的强断言，不将已有开放记录强转为业务 Op。
保留 `hud!`、全部三组历史展示文本、存档行为和原质量预算，不创建新脚本或迁移框架。
Respo 的开放回调先检查 Enum，再转交原业务 dispatch；非 Enum 会明确报错。
`reload!` 仍执行原 HUD 提示，然后显式返回 Unit，不把宿主提示函数的未知返回值当作 Unit 证明。

存储 key 仍为 `hv-layout`，保存时机仍为 beforeunload 与每 60 秒；旧 Map 和已序列化 Store 均恢复为实际检查后的 Store。恢复失败会显示错误并暂停自动保存，不删除或覆盖原缓存；成功恢复后才解除暂停。存档字段和三组布局样例不变。

Reel 使用真实 `State<Op,Store>`，不把状态冒充 Map。公开 dispatch 继续接收旧匿名 Enum；`decode-op` 在业务边界按原三个操作显式转换，检查 content 和 cursor 后进入具名历史，Reel 控制操作仍走现有 Control 接口。`updater` 内部现在接收具名 `Op`，直接调用它的调试代码应使用 `Op` 构造器。状态更新只处理 `Store.states` 子树，不再把 Store 送给 Map 解码器。

类型预算只收紧：unsafe / 缺失类型 / 废弃调用均为 0；typeNotFull 15→2、schemaDynamic 17→2、unresolved 20→5。横/纵组件保留 `List<Dynamic>` 的原展示接口（String、嵌套 List，其余值转文本）；混合 key 状态、操作中的异构状态及存档入口也仍有真实开放边界，不宣称所有 Dynamic 都已消除。布局用的 `data/*.cirru` 是原样展示的历史代码文本，不是可执行的现行 Calcit 示例；本轮没有为更新文本而改变样例布局。

原 `hydrates-stored-content` 断言和 storage/unit 标签保留，只把调用处的匿名构造器适配为具名 Op；另外两项小型回归覆盖真实的状态子树错误和匿名操作适配错误，不新增测试框架、项目检查脚本或编译器改写规则。旧 0.28 候选工作树独立保留，当前分支从最新 main 复用其已审阅的源码变更后继续迁移。

此前 alpha.5 本地验收通过 193 个定义 strict、六个应用 namespace 的 23 个公开定义检查、三项附属测试、收紧后的质量预算及 CDN 构建。六组合成输入的横/纵输出与三组完整样例容器曾与原 0.27 生成代码等价（样式声明仅规范化排序）。这些是历史结果，不替代本轮正式模块图的 CI 和实际浏览器证据。存档正反例曾在内存宿主回放中验证，不冒称实际浏览器坏存档保留性或全部设备验收。本轮不改 Snapshot、测试或预算，不新增验证脚本、框架或编译器改写规则；远端依赖解析与 COS 内置上传校验以当前 PR CI 为准。
