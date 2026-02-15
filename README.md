# LovrabetSDK for iOS/Swift

强大且灵活的 [Lovrabet](https://lovrabet.com) 数据平台 iOS SDK，支持多种认证模式。

[![Release](https://img.shields.io/github/v/release/lovrabet-ai/lovrabet-swift-sdk?style=flat-square)](https://github.com/lovrabet-ai/lovrabet-swift-sdk/releases)
[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B%20%7C%20macOS%2012%2B%20%7C%20tvOS%2015%2B%20%7C%20watchOS%208%2B-blue?style=flat-square)]()
[![Swift](https://img.shields.io/badge/swift-5.9%2B-orange?style=flat-square)]()

## 特性

- **三种认证模式** — OpenAPI（AccessKey）、OpenAPI（Token）、WebAPI（Cookie）
- **Swift 原生** — 使用 async/await、CryptoKit 等现代 Swift 特性
- **完整 CRUD** — 基于 `createClient()` 的现代化设计
- **高级查询** — 支持 filter、aggregate 等复杂查询
- **SQL 查询** — 支持自定义 SQL 执行
- **多环境支持** — 轻松切换生产、测试环境
- **类型安全** — 利用 Swift 泛型提供完整的类型支持

## 系统要求

| 平台       | 最低版本  |
| ---------- | --------- |
| iOS        | 15.0+     |
| macOS      | 12.0+     |
| tvOS       | 15.0+     |
| watchOS    | 8.0+      |
| Swift      | 5.9+      |
| Xcode      | 15.0+     |

## 安装

### Swift Package Manager（推荐）

#### 方式一：在 `Package.swift` 中添加

```swift
dependencies: [
    .package(url: "https://github.com/lovrabet-ai/lovrabet-swift-sdk.git", from: "1.0.0")
]
```

在 target 中引用：

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "LovrabetSDK", package: "lovrabet-swift-sdk")
    ]
)
```

#### 方式二：通过 Xcode 添加

1. 打开 Xcode 项目
2. 菜单 **File → Add Package Dependencies...**
3. 输入仓库 URL：`https://github.com/lovrabet-ai/lovrabet-swift-sdk.git`
4. 选择版本规则（推荐 "Up to Next Major Version"）
5. 点击 **Add Package**

## 快速开始

### 服务端使用（AccessKey 认证）

```swift
import LovrabetSDK

// 创建客户端
let client = try createClient(ClientConfig(
    appCode: "your-app-code",
    accessKey: "your-access-key",
    models: [
        ModelConfig(tableName: "users", datasetCode: "abc123def456", alias: "users"),
        ModelConfig(tableName: "posts", datasetCode: "ghi789jkl012", alias: "posts"),
    ]
))

// 查询数据
let users: ListResponse<MyUser> = try await client.models("users").getList()

// 创建数据
let newUser: MyUser = try await client.models("users").create(data: [
    "name": "John Doe",
    "email": "john@example.com",
])

// 高级过滤
let result: ListResponse<MyUser> = try await client.models("users").filter(
    params: FilterParams(
        where: WhereCondition(
            and: [
                WhereCondition(fields: ["age": ["$gte": 18]]),
                WhereCondition(fields: ["status": ["$eq": "active"]]),
            ]
        ),
        select: ["id", "name", "age"],
        orderBy: [["name": .asc]],
        currentPage: 1,
        pageSize: 20
    )
)
```

### 客户端使用（Token 认证）

**服务端生成 Token：**

```swift
let result = generateOpenApiToken(GenerateTokenParams(
    appCode: "your-app-code",
    datasetCode: "your-dataset-id",
    accessKey: accessKey
))
// 将 result.token 和 result.timestamp 传给客户端
```

**客户端使用 Token：**

```swift
let client = try createClient(ClientConfig(
    appCode: "your-app-code",
    token: token,
    timestamp: timestamp,
    models: [
        ModelConfig(tableName: "users", datasetCode: "abc123def456", alias: "users"),
    ]
))
```

### 执行自定义 SQL

```swift
let data: SqlExecuteResult<MyRow> = try await client.sql.execute(
    sqlCode: "your-sql-code",
    params: ["userId": "123"]
)

if data.execSuccess, let results = data.execResult {
    for row in results {
        print(row)
    }
}
```

### 安全执行

```swift
let result = await safe {
    try await client.models("users").filter(
        params: FilterParams(
            where: WhereCondition(fields: ["status": ["$eq": "active"]])
        )
    )
}

if let error = result.error {
    print("查询失败: \(error.message)")
} else {
    print("查询结果: \(result.data!)")
}
```

## 支持的查询操作符

| 操作符       | 说明       | 示例                                        |
| ------------ | ---------- | ------------------------------------------- |
| `$eq`        | 等于       | `["status": ["$eq": "active"]]`             |
| `$ne`        | 不等于     | `["status": ["$ne": "deleted"]]`            |
| `$gte`       | 大于等于   | `["age": ["$gte": 18]]`                     |
| `$lte`       | 小于等于   | `["age": ["$lte": 65]]`                     |
| `$in`        | 在集合内   | `["country": ["$in": ["CN", "US"]]]`        |
| `$contain`   | 包含       | `["name": ["$contain": "test"]]`            |
| `$startWith` | 以...开头  | `["name": ["$startWith": "Mr."]]`           |
| `$endWith`   | 以...结尾  | `["email": ["$endWith": "@example.com"]]`   |

## 认证模式选择

| 场景                | 认证方式     | 说明                     |
| ------------------- | ------------ | ------------------------ |
| 服务端 / Extension  | `accessKey`  | 后端服务、App Extension  |
| 客户端（未登录）    | `token`      | 公开数据访问             |
| 客户端（已登录）    | Cookie       | 已认证用户               |

## 文档

完整的 API 文档和更多示例，请访问 [Lovrabet 开发者文档](https://docs.lovrabet.com)。

## 版本历史

查看 [Releases](https://github.com/lovrabet-ai/lovrabet-swift-sdk/releases) 获取版本变更记录。

## 其他平台 SDK

- **TypeScript/JavaScript**: `npm install @lovrabet/sdk`
- **Android/Kotlin**: [lovrabet-android-sdk](https://github.com/lovrabet-ai/lovrabet-android-sdk)

## 许可证

本 SDK 为 **专有软件**（Proprietary），详见 [LICENSE](LICENSE) 文件。

使用本 SDK 即表示您同意 Lovrabet 的服务条款。

## 支持

- 问题反馈：[GitHub Issues](https://github.com/lovrabet-ai/lovrabet-swift-sdk/issues)
- 邮件支持：support@lovrabet.com
