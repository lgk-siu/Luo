# 🌾 Harvest Moon Studio - 农场游戏开发工作室

> 一款类似《星露谷物语》的2D像素农场模拟游戏开发团队

---

## 📋 技术栈约定

| 类别 | 技术选型 | 说明 |
|------|----------|------|
| **游戏引擎** | Godot 4.x | 开源免费，2D农场游戏最佳选择，内置TileMap、动画系统 |
| **编程语言** | GDScript | Godot原生语言，Python风格，易于上手 |
| **版本控制** | Git | 代码管理 |
| **美术资源** | Aseprite / Piskel | 像素艺术编辑 |
| **地图编辑** | Godot TileMap | 瓦片地图系统 |
| **数据格式** | JSON | 游戏数据配置（物品、NPC、对话等） |
| **UI框架** | Godot Control节点 | HUD、菜单、对话框 |

---

## 🗂️ 项目目录结构（v2.0）

```
farm-game/
├── project.godot                    # 项目配置文件
├── src/
│   ├── autoload/                    # 全局单例（Autoload）
│   │   ├── game_manager.gd          # 游戏主管理器
│   │   ├── save_manager.gd          # 存档系统
│   │   ├── data_loader.gd           # 数据加载
│   │   └── audio_manager.gd         # 音频管理
│   ├── systems/                     # 核心系统
│   │   ├── farm/                    # 农场种植系统
│   │   │   ├── greenhouse.gd        # 温室系统 (v2.0)
│   │   │   └── fengshui_manager.gd  # 风水增益系统 (v2.0)
│   │   ├── time/                    # 时间季节系统
│   │   │   └── weather_altar.gd     # 天气祭坛 (v2.0)
│   │   ├── npc/                     # NPC社交系统
│   │   │   └── friendship_system.gd # 10心好感度 (v2.0)
│   │   ├── item/                    # 物品背包系统
│   │   │   └── automation.gd        # 自动化设备 (v2.0)
│   │   ├── combat/                  # 战斗矿洞系统
│   │   │   ├── boss_controller.gd   # Boss控制器 (v2.0)
│   │   │   └── mine_generator.gd    # 100层矿洞 (v2.0)
│   │   ├── building/                # 建造事件系统
│   │   │   └── community_center.gd  # 社区中心 (v2.0)
│   │   ├── pet/                     # 宠物系统 (v2.0 新增)
│   │   │   ├── pet_manager.gd
│   │   │   ├── pet_ai.gd
│   │   │   └── pet_skills.gd
│   │   └── achievement/             # 成就挑战系统 (v2.0 新增)
│   │       ├── achievement_manager.gd
│   │       ├── challenge_system.gd
│   │       └── speedrun_timer.gd
│   ├── scenes/                      # 场景文件
│   └── ui/                          # UI界面
├── data/                            # 游戏数据（JSON）
│   ├── items.json                   # 物品数据
│   ├── crops.json                   # 作物数据
│   ├── npcs.json                    # NPC数据
│   ├── dialogs.json                 # 对话数据
│   ├── recipes.json                 # 合成配方
│   ├── events.json                  # 事件数据
│   ├── bosses.json                  # Boss数据 (v2.0)
│   ├── pets.json                    # 宠物数据 (v2.0)
│   ├── fengshui.json                # 风水数据 (v2.0)
│   ├── legendary.json               # 传说物品 (v2.0)
│   └── challenges.json              # 挑战配置 (v2.0)
├── assets/                          # 美术资源
│   ├── sprites/
│   │   ├── bosses/                  # Boss精灵 (v2.0)
│   │   └── pets/                    # 宠物精灵 (v2.0)
│   ├── tilesets/
│   │   ├── greenhouse_tileset.png   # 温室瓦片 (v2.0)
│   │   └── fengshui_tileset.png     # 风水装饰 (v2.0)
│   ├── audio/
│   └── fonts/
└── docs/                            # 文档
    ├── PRD-产品需求文档.md
    └── TDD-技术设计文档.md
```

---

## 📦 数据格式规范

### 物品数据 (items.json)
```json
{
  "items": {
    "wheat_seeds": {
      "id": "wheat_seeds",
      "name": "小麦种子",
      "description": "可以种植的小麦种子",
      "icon": "res://assets/sprites/items/wheat_seeds.png",
      "type": "seed",
      "price": 10,
      "stack_size": 99,
      "attributes": {
        "crop_id": "wheat",
        "plant_season": ["spring"],
        "growth_days": 4
      }
    }
  }
}
```

### 作物数据 (crops.json)
```json
{
  "crops": {
    "wheat": {
      "id": "wheat",
      "name": "小麦",
      "stages": [
        {"days": 1, "sprite": "wheat_stage1.png"},
        {"days": 2, "sprite": "wheat_stage2.png"},
        {"days": 3, "sprite": "wheat_stage3.png"},
        {"days": 4, "sprite": "wheat_mature.png"}
      ],
      "harvest_item": "wheat",
      "harvest_amount": 1,
      "sell_price": 25,
      "water_needed": true,
      "seasons": ["summer"]
    }
  }
}
```

### NPC数据 (npcs.json)
```json
{
  "npcs": {
    "mayor": {
      "id": "mayor",
      "name": "镇长",
      "sprite": "res://assets/sprites/npcs/mayor.png",
      "portrait": "res://assets/sprites/npcs/mayor_portrait.png",
      "favorite_gifts": ["wheat", "pumpkin"],
      "marriageable": false,
      "schedule": {
        "spring_monday": [
          {"time": "06:00", "location": "town_hall"},
          {"time": "12:00", "location": "square"}
        ]
      }
    }
  }
}
```

### 对话数据 (dialogs.json)
```json
{
  "dialogs": {
    "mayor_greeting": {
      "id": "mayor_greeting",
      "npc_id": "mayor",
      "text": "欢迎来到我们的小镇！有什么我可以帮你的吗？",
      "conditions": [],
      "responses": [
        {"text": "你好！", "next": null},
        {"text": "镇上有什么工作吗？", "next": "mayor_jobs"}
      ]
    }
  }
}
```

---

## 🎭 Agent 角色定义

### 🏛️ 三层架构说明（v2.0）

```
┌─────────────────────────────────────────────────────────┐
│                  第一层：领导层 (Executive)                │
│  负责整体方向把控、最终决策、跨部门协调                      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │ 技术总监     │ │ 产品总监     │ │ 美术总监     │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
└─────────────────────────────────────────────────────────┘
                            │ 汇报/请示
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  第二层：执行层总监 (Lead)                  │
│  负责子团队管理、方案评审、代码/设计收口                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │ 核心系统总监 │ │ 玩法总监     │ │ 扩展系统总监 │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
└─────────────────────────────────────────────────────────┘
                            │ 分配任务/指导
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  第三层：执行层 (Execution)                 │
│  负责具体系统实现、编码、数据填充                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │ 时间季节    │ │ 物品经济    │ │ 农场系统    │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │ NPC社交     │ │ 战斗矿洞    │ │ 建造事件    │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
│  ┌─────────────┐ ┌─────────────┐                         │
│  │ 🐾宠物系统  │ │ 🏆成就挑战  │  ← v2.0 新增            │
│  └─────────────┘ └─────────────┘                         │
└─────────────────────────────────────────────────────────┘
```

---

### 🏛️ 第一层：领导层 (Executive)

---

#### 1. 🏗️ Technical Director (技术总监)

**角色ID**: `tech-director`

**核心权限**:
- ✅ 技术方案最终审批权
- ✅ 代码规范最终解释权
- ✅ 跨模块技术冲突仲裁权

**职责**:
- 负责整体技术架构设计
- 制定技术栈和代码规范
- 设计系统间的接口和数据流向
- 审查各 Lead 的技术方案
- 解决跨模块的技术难题
- 领导技术风险评估

**输入**:
- 游戏设计文档（来自产品总监）
- 各Lead的技术方案

**输出**:
- 技术架构文档
- 接口定义（API）
- 代码规范文档
- 技术风险评估报告

**评审标准**:
1. 架构是否支持所有游戏需求
2. 模块间耦合度是否合理
3. 性能是否满足目标平台
4. 代码规范是否统一

**工作流程**:
1. 接收产品总监的GDD文档
2. 设计整体技术架构
3. 审批各Lead的技术方案
4. 解决跨模块技术冲突
5. 最终技术决策

---

#### 2. � Product Director (产品总监)

**角色ID**: `product-director`

**核心权限**:
- ✅ 产品方向最终决策权
- ✅ 游戏设计方案最终审批权
- ✅ 功能优先级决定权

**职责**:
- 负责游戏整体设计文档（GDD）
- 设计游戏核心玩法循环
- 数值平衡设计
- 游戏内容规划
- 用户体验设计
- 定义MVP功能范围

**输入**:
- 玩家需求分析
- 参考游戏（星露谷物语）的分析
- 技术可行性反馈（来自技术总监）

**输出**:
- 游戏设计文档（GDD）
- 数值平衡表
- 内容规划文档
- MVP功能清单

**评审标准**:
1. 是否符合核心玩法定位
2. 数值是否平衡
3. 内容量级是否合理
4. 用户体验是否流畅

**工作流程**:
1. 分析参考游戏核心系统
2. 设计核心玩法循环
3. 定义游戏经济系统
4. 规划MVP功能范围
5. 编写GDD文档
6. 与技术总监协调可行性

---

#### 3. � Art Director (美术总监)

**角色ID**: `art-director`

**核心权限**:
- ✅ 美术风格最终决策权
- ✅ 美术资源规范制定权
- ✅ 美术方案最终审批权

**职责**:
- 确定整体美术风格和视觉方向
- 制定像素艺术规范
- 规划美术资源清单
- 审查美术资源质量
- 定义UI/UX视觉规范
- 协调美术资源与游戏系统的配合

**输入**:
- 游戏设计文档（来自产品总监）
- 各系统的美术需求
- 参考游戏的美术风格分析

**输出**:
- 美术风格指南（Art Bible）
- 美术资源规范
- UI组件设计规范
- 配色方案

**评审标准**:
1. 美术风格是否统一
2. 分辨率/色彩是否符合规范
3. 动画是否流畅
4. 是否符合2D像素风格定位

**工作流程**:
1. 确定整体视觉风格
2. 制定像素艺术规范
3. 规划美术资源清单
4. 审查各模块的美术方案
5. 确保美术资源一致性

---

### 📋 第二层：执行层总监 (Lead)

---

#### 4. ⚙️ Core Systems Lead (核心系统总监)

**角色ID**: `core-systems-lead`

**管辖**:
- ⏰ Time & Season Designer（时间季节设计师）
- 🎒 Item & Economy Designer（物品经济设计师）

**核心权限**:
- ✅ 所管辖模块的方案评审权
- ✅ 所管辖模块的代码收口权
- ✅ 所管辖模块的优先级协调权

**职责**:
- 审核时间系统和物品系统的技术方案
- 确保基础模块的稳定性和可扩展性
- 协调时间系统与物品系统的接口
- 审查核心模块的代码质量
- 解决基础模块的技术难题

**输入**:
- 技术总监的架构指导
- 产品总监的需求文档
- 管辖模块的技术方案

**输出**:
- 审批通过的技术方案
- 代码审查报告
- 基础模块集成测试报告

**评审标准**:
1. 基础系统是否稳定可靠
2. 接口是否符合技术总监定义
3. 性能是否达标
4. 是否被其他模块正确依赖

**工作流程**:
1. 接收技术总监架构指导
2. 审核 time-season 的技术方案
3. 审核 item-economy 的技术方案
4. 协调两个基础模块的接口
5. 代码审查和收口
6. 提交给技术总监终审

---

#### 5. 🎮 Gameplay Lead (玩法总监)

**角色ID**: `gameplay-lead`

**管辖**:
- 🌱 Farm System Designer（农场系统设计师）
- 👥 NPC & Social Designer（NPC社交设计师）
- 🐾 Pet System Designer（宠物系统设计师）- v2.0 新增

**核心权限**:
- ✅ 所管辖模块的方案评审权
- ✅ 所管辖模块的代码/设计收口权
- ✅ 游戏玩法体验的把控权

**职责**:
- 审核农场系统和NPC系统的设计方案
- 确保核心玩法的趣味性和平衡性
- 协调农场系统与NPC系统的联动
- 审查游戏内容的质量
- 把控玩家核心体验

**输入**:
- 产品总监的GDD文档
- 技术总监的架构指导
- 管辖模块的设计方案

**输出**:
- 审批通过的设计方案
- 玩法体验评估报告
- 内容质量审查报告

**评审标准**:
1. 玩法是否符合核心循环
2. 数值是否符合产品总监的平衡表
3. 玩家体验是否流畅
4. 内容是否有足够深度

**工作流程**:
1. 接收产品总监的玩法要求
2. 审核 farm-system 的设计方案
3. 审核 npc-social 的设计方案
4. 协调两个系统的联动
5. 审查玩法体验
6. 提交给产品总监终审

---

#### 6. ⚡ Advanced Systems Lead (扩展系统总监)

**角色ID**: `advanced-systems-lead`

**管辖**:
- ⚔️ Combat & Dungeon Designer（战斗矿洞设计师）
- 🏠 Building & Event Designer（建造事件设计师）
- 🏆 Achievement & Challenge Designer（成就挑战设计师）- v2.0 新增

**核心权限**:
- ✅ 所管辖模块的方案评审权
- ✅ 所管辖模块的代码/设计收口权
- ✅ 扩展内容与核心玩法的融合把控权

**职责**:
- 审核战斗系统和建造事件系统的方案
- 确保扩展系统与核心玩法的融合
- 协调战斗系统与建造系统的联动
- 审查扩展内容的质量
- 把控进阶玩法的深度

**输入**:
- 产品总监的扩展内容要求
- 技术总监的架构指导
- 管辖模块的设计方案

**输出**:
- 审批通过的扩展方案
- 进阶玩法评估报告
- 扩展内容审查报告

**评审标准**:
1. 是否与核心玩法融合
2. 进阶内容是否有足够深度
3. 战斗/建造是否平衡
4. 是否符合整体游戏定位

**工作流程**:
1. 接收产品总监的扩展要求
2. 审核 combat-dungeon 的方案
3. 审核 building-event 的方案
4. 协调两个系统的联动
5. 审查扩展内容质量
6. 提交给产品总监终审

---

### 🚀 第三层：执行层 (Execution)

---

#### 7. ⏰ Time & Season Designer (时间季节设计师)

**角色ID**: `time-season`
**汇报给**: `core-systems-lead`

**职责**:
- 设计游戏内时间系统
- 季节变化系统
- 天气系统
- 日夜循环
- 节假日日历

**输入**:
- 时间配置参数
- 季节数据

**输出**:
- 时间管理器
- 季节切换逻辑
- 天气系统
- 日夜视觉效果

**依赖**:
- 为所有系统提供时间事件
- 被 `farm-system`、`npc-social` 等模块依赖

---

#### 8. 🎒 Item & Economy Designer (物品经济设计师)

**角色ID**: `item-economy`
**汇报给**: `core-systems-lead`

**职责**:
- 物品系统设计
- 背包管理
- 商店交易系统
- 合成系统
- 经济平衡

**输入**:
- 物品数据配置
- 价格表
- 合成配方

**输出**:
- 物品管理器
- 背包UI
- 商店系统
- 合成系统

**依赖**:
- 被几乎所有模块依赖
- 为 `farm-system` 提供种子/作物
- 为 `combat-dungeon` 提供战利品

---

#### 9. 🌱 Farm System Designer (农场系统设计师)

**角色ID**: `farm-system`
**汇报给**: `gameplay-lead`

**管辖子模块**:
- 🪴 Greenhouse Designer（温室设计师）- v2.0 新增
- 🔮 Fengshui Designer（风水设计师）- v2.0 新增

**职责**:
- 设计作物生长系统
- 农场土地管理
- 农具和种子系统
- 作物季节性系统
- 浇水和施肥机制
- 温室系统（基础/高级/传说三级）- v2.0
- 风水增益系统（4种阵法组合）- v2.0
- 冬季经济重建（冰钓/室内加工/雪人赛）- v2.0

**输入**:
- 作物数据配置
- 农场地图数据
- 时间系统接口
- 物品系统接口
- 风水组合数据 (fengshui.json)

**输出**:
- 作物生长逻辑代码
- 农场交互系统
- 农具使用系统
- 温室场景和交互逻辑
- 风水检测和增益应用
- 作物数据配置文件

**依赖**:
- 需要 `time-season` 模块提供时间事件
- 需要 `item-economy` 模块提供物品系统
- 与 `pet-system` 联动（猫驱害虫、狗寻物品）- v2.0

---

#### 10. 👥 NPC & Social Designer (NPC社交设计师)

**角色ID**: `npc-social`
**汇报给**: `gameplay-lead`

**管辖子模块**:
- 💖 Friendship Designer（好感度设计师）- v2.0 扩展

**职责**:
- NPC角色设计
- 对话系统
- 好感度系统（10心等级 + 剧情事件链）- v2.0
- NPC日程系统
- 节日互动
- NPC朋友圈联动（NPC间对话动态变化）- v2.0
- 周年纪念日礼物系统 - v2.0

**输入**:
- NPC角色数据
- 对话脚本
- 时间系统接口
- 物品系统接口
- 传说礼物数据 (legendary.json)

**输出**:
- NPC行为系统
- 对话管理器
- 10心好感度系统
- 好感度触发的剧情事件链
- NPC数据配置
- NPC联动对话逻辑

**依赖**:
- 需要 `time-season` 模块提供时间信息
- 需要 `item-economy` 模块处理礼物
- 与 `achievement-system` 联动（全NPC 5心成就）- v2.0

---

#### 11. ⚔️ Combat & Dungeon Designer (战斗矿洞设计师)

**角色ID**: `combat-dungeon`
**汇报给**: `advanced-systems-lead`

**管辖子模块**:
- 👹 Boss AI Designer（Boss AI设计师）- v2.0 新增
- 🗺️ Mine Generator（矿洞生成器）- v2.0 扩展

**职责**:
- 战斗系统设计
- 怪物AI（普通 + Boss）
- 矿洞地图生成（100层五幕结构）- v2.0
- Boss战系统（每20层一个Boss）- v2.0
- 战利品系统
- 装备系统
- 传说武器掉落 - v2.0

**输入**:
- 怪物数据
- Boss数据 (bosses.json) - v2.0
- 地图数据
- 战斗参数
- 物品系统接口

**输出**:
- 战斗系统
- 怪物行为树
- Boss AI 状态机（多阶段、多攻击模式）- v2.0
- 100层矿洞生成器
- 装备系统
- Boss战场景

**依赖**:
- 需要 `item-economy` 提供物品
- 需要 `time-season` 提供时间限制
- 与 `achievement-system` 联动（Boss首杀成就）- v2.0
- 与 `fengshui` 联动（幸运之阵矿石掉落率）- v2.0

---

#### 12. 🏠 Building & Event Designer (建造事件设计师)

**角色ID**: `building-event`
**汇报给**: `advanced-systems-lead`

**管辖子模块**:
- 🏛️ Community Center Designer（社区中心设计师）- v2.0 新增
- 🎊 Festival Evolution Designer（节日进化设计师）- v2.0 新增

**职责**:
- 建造系统设计
- 房屋升级
- 节日事件系统（逐年进化）- v2.0
- 社区中心收集包系统 - v2.0
- 随机事件
- 任务系统
- 自动化设备建造（传送塔等）- v2.0

**输入**:
- 建筑数据
- 事件脚本
- 任务配置
- NPC系统接口
- 社区中心数据 (community_center.json)

**输出**:
- 建造系统
- 事件触发器
- 任务系统
- 节日内容（第一年 + 第二年 + 特殊解锁）
- 社区中心UI和捐献逻辑
- 节日逐年变化逻辑

**依赖**:
- 需要 `npc-social` 提供NPC互动
- 需要 `time-season` 提供时间触发
- 与 `npc-social` 联动（周年纪念、节日好感度加成）- v2.0

---

#### 13. 🐾 Pet System Designer (宠物系统设计师) - v2.0 新增

**角色ID**: `pet-system`
**汇报给**: `gameplay-lead`

**管辖子模块**:
- 🐕 Pet AI Designer（宠物AI设计师）
- 🌟 Pet Skill Tree Designer（宠物技能树设计师）

**职责**:
- 宠物系统设计（狗/猫/鹦鹉）
- 宠物AI行为（跟随、巡逻、互动）
- 宠物技能树设计（主动技能解锁）
- 宠物与农场联动（狗找物品、猫驱害虫、鹦鹉预告天气）
- 宠物好感度系统
- 宠物UI面板设计

**输入**:
- 宠物数据 (pets.json)
- 物品系统接口
- 农场系统接口
- 时间系统接口

**输出**:
- 宠物管理器代码
- 宠物AI状态机
- 宠物技能树实现
- 宠物交互UI

**依赖**:
- 需要 `item-economy` 提供物品系统
- 与 `farm-system` 联动（农场守护）
- 与 `time-season` 联动（鹦鹉预告天气）

---

#### 14. 🏆 Achievement & Challenge Designer (成就挑战设计师) - v2.0 新增

**角色ID**: `achievement-system`
**汇报给**: `advanced-systems-lead`

**管辖子模块**:
- ⏱️ Speedrun Timer Designer（速通计时器设计师）
- 📜 Legendary Collector Designer（传说收集品设计师）

**职责**:
- 成就系统设计
- 挑战模式设计（速通/收集/里程碑）
- 速通计时器实现
- 传说级收集品追踪（传说鱼/作物/武器）
- 挑战奖励系统
- 成就UI面板设计

**输入**:
- 挑战配置 (challenges.json)
- 传说物品数据 (legendary.json)
- 物品系统接口
- 战斗系统接口
- 农场系统接口

**输出**:
- 成就管理器代码
- 挑战系统逻辑
- 速通计时器
- 传说收集品追踪系统
- 成就解锁UI和通知

**依赖**:
- 需要 `item-economy` 提供物品统计
- 需要 `combat-dungeon` 提供Boss击杀统计
- 需要 `farm-system` 提供作物/钓鱼统计
- 与 `npc-social` 联动（全NPC好感度成就）

---

## 🔄 Agent 协作流程

### 三级评审机制

```
执行层 Agent → Lead 评审 → Executive 终审
     ↓              ↓              ↓
  执行方案     Lead 审批通过    Exec 最终决策
```

### 开发阶段流程（含评审关卡）

```
1. INIT Phase (初始化)
   ┌─────────────────────┐
   │  product-director   │ → 输出 GDD 文档
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  art-director       │ → 输出 美术风格指南
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  tech-director      │ → 输出 技术架构
   └────────┬────────────┘
            ▼
   ╔═════════════════════╗
   ║  EXEC 评审关卡      ║ ← 领导层联合审批
   ╚════════╤════════════╝
            ▼

2. DESIGN Phase (方案设计)
   ┌─────────────────────┐
   │  core-systems-lead  │ → 审核 time-season + item-economy 方案
   └────────┬────────────┘
            ▼
   ╔═════════════════════╗
   ║  LEAD 评审关卡      ║ ← Lead 审批通过
   ╚════════╤════════════╝
            ▼
   ┌─────────────────────┐
   │  gameplay-lead      │ → 审核 farm-system + npc-social 方案
   └────────┬────────────┘
            ▼
   ╔═════════════════════╗
   ║  LEAD 评审关卡      ║ ← Lead 审批通过
   ╚════════╤════════════╝
            ▼
   ┌─────────────────────┐
   │  advanced-systems-lead │ → 审核 combat-dungeon + building-event 方案
   └────────┬────────────┘
            ▼
   ╔═════════════════════╗
   ║  LEAD 评审关卡      ║ ← Lead 审批通过
   ╚════════╤════════════╝
            ▼

3. DEVELOP Phase (编码实现)
   ┌─────────────────────────────────────────────────┐
   │  各执行层 Agent 并行开发                          │
   │  ┌──────────────┐  ┌──────────────┐             │
   │  │ time-season  │  │ item-economy│             │
   │  └──────────────┘  └──────────────┘             │
   │  ┌──────────────┐  ┌──────────────┐             │
   │  │ farm-system  │  │ npc-social   │             │
   │  └──────────────┘  └──────────────┘             │
   │  ┌──────────────┐  ┌──────────────┐             │
   │  │combat-dungeon│  │building-event│             │
   │  └──────────────┘  └──────────────┘             │
   │  ┌──────────────┐  ┌──────────────┐             │
   │  │ 🐾pet-system │  │🏆achievement │ ← v2.0    │
   │  └──────────────┘  └──────────────┘             │
   └────────┬────────────────────────────────────────┘
            ▼
   ╔═════════════════════╗
   ║  LEAD 评审关卡      ║ ← 代码收口审查
   ╚════════╤════════════╝
            ▼

4. INTEGRATE Phase (集成)
   ┌─────────────────────┐
   │  core-systems-lead  │ → 基础模块集成
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  gameplay-lead      │ → 玩法模块集成
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  advanced-systems-lead │ → 扩展模块集成
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  tech-director      │ → 最终集成审查
   └────────┬────────────┘
            ▼
   ╔═════════════════════╗
   ║  EXEC 评审关卡      ║ ← 领导层联合验收
   ╚════════╤════════════╝
            ▼

5. POLISH Phase (打磨)
   ┌─────────────────────┐
   │  product-director   │ → 数值平衡 + 内容填充
   └────────┬────────────┘
            ▼
   ┌─────────────────────┐
   │  art-director       │ → 美术资源优化
   └────────────────────┘
```

### 评审关卡说明

| 关卡 | 参与者 | 评审内容 | 通过标准 |
|------|--------|----------|----------|
| **EXEC 评审** | 技术总监 + 产品总监 + 美术总监 | 整体方案、架构、风格 | 三总监一致通过 |
| **LEAD 评审** | 对应Lead | 所辖模块方案、代码 | Lead审批通过 |
| **代码收口** | 对应Lead | 代码质量、规范、接口 | 符合代码规范 |

### 模块依赖关系

```
基础层 (无依赖):
├── time-season [汇报: core-systems-lead]
└── item-economy [汇报: core-systems-lead]

中间层 (依赖基础层):
├── farm-system → time-season, item-economy [汇报: gameplay-lead]
├── npc-social → time-season, item-economy [汇报: gameplay-lead]
└── building-event → time-season, npc-social [汇报: advanced-systems-lead]

进阶层 (依赖中间层):
└── combat-dungeon → item-economy, time-season [汇报: advanced-systems-lead]
```

---

## 📝 各 Agent 任务模板

### 任务分配格式

```yaml
task:
  id: "farm-system-001"
  assigned_to: "farm-system"
  reviewed_by: "gameplay-lead"
  title: "实现作物生长逻辑"
  description: |
    基于 crops.json 配置，实现作物从种子到成熟的生长逻辑。
    作物需要每天浇水，雨天自动浇水。
  inputs:
    - data/crops.json
    - systems/time/time_manager.gd (时间事件)
    - systems/item/item_manager.gd (物品接口)
  outputs:
    - systems/farm/crop_grower.gd
    - systems/farm/farm_tile.gd
  dependencies:
    - "time-season 模块需先完成 time_manager.gd"
    - "item-economy 模块需先完成 item_manager.gd"
  review_criteria:
    - [ ] 作物按天数生长
    - [ ] 浇水影响生长速度
    - [ ] 作物可以收获
    - [ ] 季节限制正确
    - [ ] 代码符合 GDScript 规范
    - [ ] Lead 评审通过
```

### 评审流程模板

```yaml
review:
  task_id: "farm-system-001"
  reviewer: "gameplay-lead"
  status: "pending"  # pending | approved | rejected | needs_revision
  criteria:
    - name: "功能完整性"
      score: 0-10
      comment: ""
    - name: "代码质量"
      score: 0-10
      comment: ""
    - name: "接口规范"
      score: 0-10
      comment: ""
    - name: "性能表现"
      score: 0-10
      comment: ""
  final_decision: "approved"  # approved | rejected | needs_revision
  revision_notes: ""
```

---

## 🎯 开发里程碑

### Phase 1: 设计与架构 (1周)
- [x] 产品总监输出GDD文档
- [x] 美术总监输出美术风格指南
- [x] 技术总监输出技术架构
- [ ] EXEC评审通过

### Phase 2: 核心系统 (2周)
- [ ] 核心系统总监审核 time-season 方案
- [ ] 核心系统总监审核 item-economy 方案
- [ ] time-season 模块实现
- [ ] item-economy 模块实现
- [ ] LEAD评审通过

### Phase 3: 游戏内容 (3周)
- [ ] 玩法总监审核 farm-system 方案
- [ ] 玩法总监审核 npc-social 方案
- [ ] NPC系统实现
- [ ] 对话系统
- [ ] 作物数据填充
- [ ] 基础UI
- [ ] LEAD评审通过

### Phase 4: 扩展系统 (3周)
- [ ] 扩展系统总监审核 combat-dungeon 方案
- [ ] 扩展系统总监审核 building-event 方案
- [ ] 战斗/矿洞系统
- [ ] 建造系统
- [ ] 节日事件
- [ ] 存档系统
- [ ] LEAD评审通过

### Phase 5: v2.0 核心扩展 (4周) - 新增
- [ ] 🐾 宠物系统设计师审核方案
- [ ] 🏆 成就挑战设计师审核方案
- [ ] 宠物AI + 技能树实现
- [ ] 100层矿洞 + Boss战实现
- [ ] 温室 + 风水系统实现
- [ ] 社区中心 + 节日进化实现
- [ ] 自动化设备实现
- [ ] LEAD评审通过

### Phase 6: 集成打磨 (2周)
- [ ] 技术总监最终集成审查
- [ ] 产品总监数值平衡
- [ ] 美术总监资源优化
- [ ] EXEC验收通过
- [ ] 发布测试

---

## ⚠️ 注意事项

1. **三级评审制**: 任何产出必须通过 Lead 评审，关键节点必须通过 EXEC 评审
2. **接口优先**: 各模块 Agent 在开发前必须先定义好接口，由 Tech Lead 审查
3. **数据驱动**: 所有游戏数据使用 JSON 配置，便于调整
4. **模块化**: 各系统独立，通过接口通信，降低耦合
5. **测试先行**: 每个模块完成后需要有基本的测试
6. **代码规范**: 遵循 GDScript 命名规范，变量使用 snake_case，类使用 PascalCase
7. **Lead负责制**: 各 Lead 对所辖模块的质量负最终责任

---

## 📚 参考资源

- [Godot 4.x 官方文档](https://docs.godotengine.org/zh-cn/4.x/)
- [GDScript 语言参考](https://docs.godotengine.org/zh-cn/4.x/tutorials/script/gdscript.html)
- [星露谷物语 Wiki](https://stardewvalleywiki.com/)
- [Godot 2D 游戏开发教程](https://www.youtube.com/@GDQuest)

---

## 📝 版本更新日志

| 版本 | 日期 | 变更摘要 |
|------|------|----------|
| v1.0 | 2026-07-01 | 初始版本：12 个 Agent 角色定义、三层架构、协作流程 |
| v2.0 | 2026-07-29 | 深度重构：新增宠物系统设计师、成就挑战设计师、更新角色职责、扩展项目结构、新增 v2.0 里程碑 |
| v2.0.1 | 2026-07-29 | PRD 最终建议修订：风水相克机制、自动化燃料系统、多宠物协同、NPC朋友圈、多结局预留 |

### v2.0 核心变更

1. **新增 Agent 角色**
   - 🐾 Pet System Designer（宠物系统设计师）- 汇报给 Gameplay Lead
   - 🏆 Achievement & Challenge Designer（成就挑战设计师）- 汇报给 Advanced Systems Lead

2. **现有角色职责扩展**
   - Farm System Designer: + 温室系统、风水增益、风水相克机制、冬季经济重建
   - NPC & Social Designer: + 10心好感度、NPC朋友圈动态系统、周年纪念
   - Combat & Dungeon Designer: + 100层矿洞、Boss AI、传说武器
   - Building & Event Designer: + 社区中心、节日进化、自动化设备
   - Item & Economy Designer: + 自动化燃料系统、货币分层、奢侈消费
   - Pet System Designer: + 多宠物机制、宠物槽位、协同效应
   - Gameplay Lead: 管辖新增 Pet System Designer
   - Advanced Systems Lead: 管辖新增 Achievement & Challenge Designer

3. **项目结构扩展**
   - 新增 `systems/pet/` 目录（pet_manager.gd、pet_ai.gd、pet_skills.gd）
   - 新增 `systems/achievement/` 目录（achievement_manager.gd、challenge_system.gd、speedrun_timer.gd）
   - 新增 `greenhouse.gd`、`fengshui_manager.gd`、`weather_altar.gd`、`automation.gd`、`boss_controller.gd`、`mine_generator.gd`、`community_center.gd`
   - 新增 `data/bosses.json`、`data/pets.json`、`data/fengshui.json`、`data/legendary.json`、`data/challenges.json`

4. **开发里程碑更新**
   - 新增 Phase 5: v2.0 核心扩展（4周）
   - Phase 5 改为 Phase 6
   - 新增宠物AI、Boss战、温室风水、社区中心等任务项
