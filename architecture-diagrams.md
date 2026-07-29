# 🌾 Harvest Moon Studio 架构图表

## 1. 三层组织架构图（新版）

```mermaid
graph TB
    subgraph "🌾 Harvest Moon Studio"
        direction TB
        
        subgraph "🏛️ 第一层：领导层 (Executive)"
            direction LR
            TD["🏗️ Technical Director<br/>技术总监<br/>技术方案终审"]
            PD["🎯 Product Director<br/>产品总监<br/>产品方向决策"]
            AD["🎨 Art Director<br/>美术总监<br/>美术风格终审"]
        end
        
        subgraph "📋 第二层：执行层总监 (Lead)"
            direction LR
            CSL["⚙️ Core Systems Lead<br/>核心系统总监<br/>管辖: time-season, item-economy"]
            GL["🎮 Gameplay Lead<br/>玩法总监<br/>管辖: farm-system, npc-social"]
            ASL["⚡ Advanced Systems Lead<br/>扩展系统总监<br/>管辖: combat-dungeon, building-event"]
        end
        
        subgraph "🚀 第三层：执行层 (Execution)"
            direction TB
            subgraph "基础模块"
                TM["⏰ Time & Season<br/>时间季节设计师"]
                IE["🎒 Item & Economy<br/>物品经济设计师"]
            end
            subgraph "玩法模块"
                FS["🌱 Farm System<br/>农场系统设计师"]
                NS["👥 NPC & Social<br/>NPC社交设计师"]
            end
            subgraph "扩展模块"
                CD["⚔️ Combat & Dungeon<br/>战斗矿洞设计师"]
                BE["🏠 Building & Event<br/>建造事件设计师"]
            end
        end
    end
    
    TD -->|"技术审批"| CSL
    TD -->|"技术审批"| GL
    TD -->|"技术审批"| ASL
    
    PD -->|"产品指导"| GL
    PD -->|"产品指导"| ASL
    
    AD -->|"美术规范"| GL
    AD -->|"美术规范"| ASL
    
    CSL -->|"评审指导"| TM
    CSL -->|"评审指导"| IE
    
    GL -->|"评审指导"| FS
    GL -->|"评审指导"| NS
    
    ASL -->|"评审指导"| CD
    ASL -->|"评审指导"| BE

    style TD fill:#c0392b,color:#fff
    style PD fill:#2980b9,color:#fff
    style AD fill:#8e44ad,color:#fff
    style CSL fill:#e67e22,color:#fff
    style GL fill:#27ae60,color:#fff
    style ASL fill:#16a085,color:#fff
    style TM fill:#f39c12,color:#fff
    style IE fill:#f39c12,color:#fff
    style FS fill:#2ecc71,color:#fff
    style NS fill:#2ecc71,color:#fff
    style CD fill:#e74c3c,color:#fff
    style BE fill:#e74c3c,color:#fff
```

## 2. 三级评审流程图（新增）

```mermaid
flowchart TB
    subgraph "执行层 (Execution)"
        direction TB
        EA["🚀 执行层 Agent<br/>提交方案/代码"]
    end
    
    subgraph "Lead 评审"
        direction TB
        LR["📋 Lead 评审关卡<br/>方案/代码审查"]
    end
    
    subgraph "Executive 终审"
        direction TB
        EX["🏛️ EXEC 评审关卡<br/>领导层联合审批"]
    end
    
    EA -->|"1. 提交产出"| LR
    LR -->|"2. Lead 审批通过"| EX
    EX -->|"3. 最终决策通过"| OUTPUT(["✅ 进入下一阶段"])
    
    LR -.->|"❌ 驳回/需修改"| EA
    EX -.->|"❌ 驳回/需修改"| LR
    
    subgraph "评审标准"
        direction LR
        S1["✅ 功能完整性"]
        S2["✅ 代码质量"]
        S3["✅ 接口规范"]
        S4["✅ 性能表现"]
    end
    
    style EA fill:#3498db,color:#fff
    style LR fill:#f39c12,color:#fff
    style EX fill:#e74c3c,color:#fff
    style OUTPUT fill:#27ae60,color:#fff
    style S1 fill:#ecf0f1
    style S2 fill:#ecf0f1
    style S3 fill:#ecf0f1
    style S4 fill:#ecf0f1
```

## 3. 模块依赖关系图

```mermaid
graph TD
    subgraph "基础层 (Foundation) - 汇报给 Core Systems Lead"
        TM["⏰ Time & Season System<br/>时间季节系统"]
        IE["🎒 Item & Economy System<br/>物品经济系统"]
    end
    
    subgraph "中间层 (Gameplay) - 汇报给 Gameplay Lead"
        FS["🌱 Farm System<br/>农场种植系统"]
        NS["👥 NPC & Social System<br/>NPC社交系统"]
    end
    
    subgraph "进阶层 (Advanced) - 汇报给 Advanced Systems Lead"
        BE["🏠 Building & Event System<br/>建造事件系统"]
        CD["⚔️ Combat & Dungeon System<br/>战斗矿洞系统"]
    end
    
    TM --> FS
    TM --> NS
    TM --> BE
    TM --> CD
    
    IE --> FS
    IE --> NS
    IE --> CD
    
    NS --> BE
    
    style TM fill:#f39c12,color:#fff
    style IE fill:#f39c12,color:#fff
    style FS fill:#27ae60,color:#fff
    style NS fill:#27ae60,color:#fff
    style BE fill:#9b59b6,color:#fff
    style CD fill:#e74c3c,color:#fff
```

## 4. Agent 协作流程图（含评审关卡）

```mermaid
flowchart LR
    subgraph "Phase 1: 设计阶段"
        direction TB
        PD["🎯 Product Director<br/>输出GDD文档"]
        AD["🎨 Art Director<br/>输出美术指南"]
        TD["🏗️ Technical Director<br/>输出技术架构"]
        EXEC1["🏛️ EXEC 评审"]
    end
    
    subgraph "Phase 2: 方案设计"
        direction TB
        CSL["⚙️ Core Systems Lead<br/>审核基础模块方案"]
        LR1["📋 LEAD 评审"]
        GL["🎮 Gameplay Lead<br/>审核玩法模块方案"]
        LR2["📋 LEAD 评审"]
        ASL["⚡ Advanced Systems Lead<br/>审核扩展模块方案"]
        LR3["📋 LEAD 评审"]
    end
    
    subgraph "Phase 3: 编码实现"
        direction TB
        TM["⏰ Time & Season"]
        IE["🎒 Item & Economy"]
        FS["🌱 Farm System"]
        NS["👥 NPC & Social"]
        CD["⚔️ Combat & Dungeon"]
        BE["🏠 Building & Event"]
    end
    
    subgraph "Phase 4: 集成打磨"
        direction TB
        CSL2["⚙️ 基础模块集成"]
        GL2["🎮 玩法模块集成"]
        ASL2["⚡ 扩展模块集成"]
        TD2["🏗️ 最终集成审查"]
        EXEC2["🏛️ EXEC 验收"]
    end
    
    PD --> AD
    AD --> TD
    TD --> EXEC1
    EXEC1 --> CSL
    CSL --> LR1
    LR1 --> GL
    GL --> LR2
    LR2 --> ASL
    ASL --> LR3
    
    LR3 --> TM & IE
    TM & IE --> FS & NS
    FS & NS --> CD & BE
    
    TM & IE --> CSL2
    FS & NS --> GL2
    CD & BE --> ASL2
    
    CSL2 & GL2 & ASL2 --> TD2
    TD2 --> EXEC2
    
    style PD fill:#2980b9,color:#fff
    style AD fill:#8e44ad,color:#fff
    style TD fill:#c0392b,color:#fff
    style EXEC1 fill:#c0392b,color:#fff
    style CSL fill:#e67e22,color:#fff
    style GL fill:#27ae60,color:#fff
    style ASL fill:#16a085,color:#fff
    style LR1 fill:#f39c12,color:#fff
    style LR2 fill:#f39c12,color:#fff
    style LR3 fill:#f39c12,color:#fff
    style TM fill:#f39c12,color:#fff
    style IE fill:#f39c12,color:#fff
    style FS fill:#2ecc71,color:#fff
    style NS fill:#2ecc71,color:#fff
    style CD fill:#e74c3c,color:#fff
    style BE fill:#e74c3c,color:#fff
    style TD2 fill:#c0392b,color:#fff
    style EXEC2 fill:#c0392b,color:#fff
```

## 5. 数据流向图

```mermaid
graph TB
    subgraph "数据源"
        JSON["📁 JSON 配置文件<br/>items.json<br/>crops.json<br/>npcs.json<br/>dialogs.json"]
    end
    
    subgraph "核心管理器 (Autoload)"
        GM["🎮 Game Manager<br/>游戏主管理器"]
        SM["💾 Save Manager<br/>存档管理器"]
    end
    
    subgraph "系统模块"
        TM["⏰ Time Manager"]
        FS["🌱 Farm System"]
        NS["👥 NPC System"]
        IS["🎒 Item System"]
        CD["⚔️ Combat System"]
    end
    
    subgraph "UI 层"
        HUD["📊 HUD 界面"]
        INV["🎒 背包界面"]
        DLG["💬 对话框"]
        SHOP["🏪 商店界面"]
    end
    
    JSON --> GM
    GM --> TM
    GM --> FS
    GM --> NS
    GM --> IS
    GM --> CD
    
    TM --> FS
    TM --> NS
    TM --> CD
    
    IS --> FS
    IS --> NS
    IS --> CD
    
    FS --> HUD
    NS --> DLG
    IS --> INV
    IS --> SHOP
    
    GM --> SM
    SM --> GM

    style JSON fill:#ecf0f1
    style GM fill:#e74c3c,color:#fff
    style SM fill:#e74c3c,color:#fff
    style TM fill:#f39c12,color:#fff
    style FS fill:#27ae60,color:#fff
    style NS fill:#27ae60,color:#fff
    style IS fill:#f39c12,color:#fff
    style CD fill:#e67e22,color:#fff
    style HUD fill:#3498db,color:#fff
    style INV fill:#3498db,color:#fff
    style DLG fill:#3498db,color:#fff
    style SHOP fill:#3498db,color:#fff
```

## 6. 角色能力矩阵图

```mermaid
graph radar
    subgraph "领导层能力"
        direction LR
        TD["🏗️ 技术总监<br/>技术架构: ★★★★★<br/>代码质量: ★★★★★<br/>系统集成: ★★★★★<br/>游戏设计: ★★☆☆☆"]
        PD["🎯 产品总监<br/>产品方向: ★★★★★<br/>数值平衡: ★★★★★<br/>内容规划: ★★★★★<br/>技术实现: ★★☆☆☆"]
        AD["🎨 美术总监<br/>美术风格: ★★★★★<br/>视觉规范: ★★★★★<br/>资源规划: ★★★★★<br/>代码实现: ★☆☆☆☆"]
    end
    
    subgraph "Lead 层能力"
        direction LR
        CSL["⚙️ 核心系统总监<br/>系统评审: ★★★★★<br/>代码收口: ★★★★★<br/>基础架构: ★★★★★<br/>玩法设计: ★★☆☆☆"]
        GL["🎮 玩法总监<br/>玩法评审: ★★★★★<br/>体验把控: ★★★★★<br/>内容深度: ★★★★★<br/>代码实现: ★★★☆☆"]
        ASL["⚡ 扩展系统总监<br/>扩展评审: ★★★★★<br/>系统融合: ★★★★★<br/>进阶深度: ★★★★★<br/>代码实现: ★★★☆☆"]
    end
    
    subgraph "执行层能力"
        direction LR
        TM["⏰ Time & Season<br/>系统设计: ★★★★☆<br/>GDScript: ★★★★☆<br/>文档: ★★★★☆"]
        IE["🎒 Item & Economy<br/>系统设计: ★★★★☆<br/>GDScript: ★★★★☆<br/>数据结构: ★★★★★"]
        FS["🌱 Farm System<br/>游戏逻辑: ★★★★★<br/>GDScript: ★★★★☆<br/>数据驱动: ★★★★☆"]
        NS["👥 NPC & Social<br/>对话系统: ★★★★★<br/>行为AI: ★★★★☆<br/>情感设计: ★★★★★"]
        CD["⚔️ Combat & Dungeon<br/>战斗系统: ★★★★★<br/>AI行为树: ★★★★★<br/>地图生成: ★★★★☆"]
        BE["🏠 Building & Event<br/>事件系统: ★★★★★<br/>触发逻辑: ★★★★☆<br/>内容创作: ★★★★★"]
    end

    style TD fill:#c0392b,color:#fff
    style PD fill:#2980b9,color:#fff
    style AD fill:#8e44ad,color:#fff
    style CSL fill:#e67e22,color:#fff
    style GL fill:#27ae60,color:#fff
    style ASL fill:#16a085,color:#fff
    style TM fill:#f39c12,color:#fff
    style IE fill:#f39c12,color:#fff
    style FS fill:#2ecc71,color:#fff
    style NS fill:#2ecc71,color:#fff
    style CD fill:#e74c3c,color:#fff
    style BE fill:#e74c3c,color:#fff
```

## 7. 游戏核心循环图

```mermaid
graph LR
    subgraph "核心游戏循环"
        direction TB
        START(["🌅 新的一天"]) -->|时间流逝| FARMING(["🌱 农场劳作<br/>种植/浇水/收获"])
        FARMING -->|产出| INVENTORY(["🎒 收集物品<br/>作物/材料/战利品"])
        INVENTORY -->|出售/使用| ECONOMY(["💰 经济循环<br/>买卖/合成/升级"])
        ECONOMY -->|购买| UPGRADE(["🔨 升级扩展<br/>工具/建筑/农场"])
        UPGRADE -->|解锁| EXPLORE(["🗺️ 探索冒险<br/>矿洞/NPC/事件"])
        EXPLORE -->|互动| SOCIAL(["👥 社交系统<br/>NPC/节日/好感度"])
        SOCIAL -->|结束| END(["🌙 结束一天<br/>保存/睡眠"])
        END -->|新一天| START
    end
    
    subgraph "辅助系统"
        TIME["⏰ 时间季节"]
        WEATHER["☁️ 天气系统"]
        SAVE["💾 存档系统"]
    end
    
    TIME -.->|"影响"| START
    WEATHER -.->|"影响"| FARMING
    SAVE -.->|"记录"| END

    style START fill:#27ae60,color:#fff
    style FARMING fill:#27ae60,color:#fff
    style INVENTORY fill:#f39c12,color:#fff
    style ECONOMY fill:#f39c12,color:#fff
    style UPGRADE fill:#9b59b6,color:#fff
    style EXPLORE fill:#e67e22,color:#fff
    style SOCIAL fill:#3498db,color:#fff
    style END fill:#3498db,color:#fff
    style TIME fill:#ecf0f1
    style WEATHER fill:#ecf0f1
    style SAVE fill:#ecf0f1
```

## 使用说明

1. 在支持 Mermaid 的 Markdown 查看器中打开此文件（如 GitHub、VS Code + Mermaid 插件）
2. 查看 **图1** 理解三层组织架构
3. 查看 **图2** 理解三级评审流程
4. 查看 **图3** 理解模块依赖关系
5. 查看 **图4** 理解完整的协作流程（含评审关卡）
6. 参考其他图表作为开发参考
