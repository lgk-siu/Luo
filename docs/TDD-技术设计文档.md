# 📐 TDD - 技术设计文档

> **Cozy Farm Game Studio**
> **角色**: 🏗️ Technical Director (技术总监)
> **版本**: v2.0
> **日期**: 2026-07-29
> **前置文档**: PRD-产品需求文档.md (v2.0)
> **状态**: 待技术总监评估 v2.0 新系统可行性

---

## 📑 文档信息

| 项目 | 内容 |
|------|------|
| 开发引擎 | Godot 4.x |
| 编程语言 | GDScript |
| 版本控制 | Git |
| 美术工具 | Aseprite / Piskel |
| 目标平台 | PC (Windows/Mac/Linux) |
| 最低配置 | CPU 2GHz+, RAM 4GB+, GPU 支持OpenGL 3.0+ |

---

## 🏛️ 一、整体架构设计

### 1.1 系统分层架构

```
┌─────────────────────────────────────────────────────────┐
│                      游戏应用层                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │  场景管理    │ │  UI 系统    │ │  音频系统    │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      业务逻辑层                          │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Game Manager (Autoload)                          │    │
│  │  ├── Time System Module                          │    │
│  │  ├── Farm System Module                          │    │
│  │  ├── Item System Module                          │    │
│  │  ├── NPC System Module                           │    │
│  │  ├── Combat System Module                        │    │
│  │  └── Building System Module                      │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      数据访问层                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │  JSON Loader │ │  Save System │ │  Data Cache │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      数据持久层                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  │  JSON 配置  │ │  存档文件   │ │  日志文件   │        │
│  └─────────────┘ └─────────────┘ └─────────────┘        │
└─────────────────────────────────────────────────────────┘
```

### 1.2 模块依赖关系

```
基础模块 (无游戏逻辑依赖):
├── time_system.gd     ← 为所有模块提供时间事件
├── item_system.gd     ← 为所有模块提供物品接口
└── save_manager.gd    ← 为所有模块提供存档接口

业务模块 (依赖基础模块):
├── farm_system.gd     → time_system, item_system
├── npc_system.gd      → time_system, item_system
├── combat_system.gd   → time_system, item_system
└── building_system.gd → time_system, npc_system

约束:
├── 基础模块之间无循环依赖
├── 业务模块只能依赖基础模块
└── 禁止跨业务模块直接依赖，通过事件通信
```

---

## 🔧 二、Autoload 单例设计

### 2.1 单例清单（v2.0 扩展）

| 单例名称 | 脚本路径 | 加载顺序 | 优先级 | 职责 |
|----------|----------|----------|--------|------|
| GameManager | res://src/autoload/game_manager.gd | 1 | P0 | 游戏主控制器、场景切换 |
| SaveManager | res://src/autoload/save_manager.gd | 2 | P0 | 存档读写、自动保存 |
| DataLoader | res://src/autoload/data_loader.gd | 3 | P0 | JSON数据加载、缓存管理 |
| TimeManager | res://src/systems/time/time_manager.gd | 4 | P0 | 时间、季节、天气、天气祭坛管理 |
| ItemManager | res://src/systems/item/item_manager.gd | 5 | P0 | 物品、背包、商店、自动化设备管理 |
| FarmManager | res://src/systems/farm/farm_manager.gd | 6 | P0 | 农场、作物、温室、风水增益管理 |
| NPCManager | res://src/systems/npc/npc_manager.gd | 7 | P1 | NPC、对话、10心好感度、NPC联动 |
| CombatManager | res://src/systems/combat/combat_manager.gd | 8 | P1 | 战斗、怪物、100层矿洞、Boss AI |
| BuildingManager | res://src/systems/building/building_manager.gd | 9 | P1 | 建造、风水系统、社区中心、节日进化 |
| PetManager | res://src/systems/pet/pet_manager.gd | 10 | P1 | 宠物系统、技能树、主动技能 |
| AchievementManager | res://src/systems/achievement/achievement_manager.gd | 11 | P2 | 成就、挑战模式、速通计时、传说收集 |
| AudioManager | res://src/autoload/audio_manager.gd | 12 | P0 | 音乐、音效管理 |

### 2.2 单例职责详述

#### GameManager (游戏主管理器)

```gdscript
# game_manager.gd 核心接口
class_name GameManager
extends Node

# ===== 游戏状态枚举 =====
enum GameState { MENU, LOADING, PLAYING, PAUSED, SAVING }
enum SceneType { MAIN_MENU, FARM, TOWN, MINE, SHOP, EVENT }

# ===== 公共变量 =====
var current_state: GameState
var current_scene: SceneType
var player_data: Dictionary    # 玩家数据
var game_day: int = 1          # 游戏天数
var game_season: String = "spring"  # 当前季节
var game_year: int = 1         # 游戏年份
var is_first_day: bool = true

# ===== 核心信号 =====
signal game_state_changed(new_state: GameState)
signal scene_changed(new_scene: SceneType)
signal day_changed(new_day: int)
signal season_changed(new_season: String)

# ===== 核心方法 =====
func change_state(new_state: GameState) -> void
func change_scene(new_scene: SceneType) -> void
func start_new_day() -> void
func end_day() -> void
func load_game(slot: int = 0) -> bool
func save_game(slot: int = 0) -> bool
```

#### TimeManager (时间管理器)

```gdscript
# time_manager.gd 核心接口
class_name TimeManager
extends Node

# ===== 时间常量 =====
const SECONDS_PER_MINUTE: int = 60
const MINUTES_PER_HOUR: int = 60
const HOURS_PER_DAY: int = 24
const DAYS_PER_SEASON: int = 28
const TICK_RATE: float = 0.1  # 每个游戏日 = 实际14.4分钟

# ===== 公共变量 =====
var current_day: int = 1
var current_hour: int = 6       # 玩家6点起床
var current_minute: int = 0
var current_second: float = 0.0
var current_season: String = "spring"
var weather_today: String = "sunny"  # sunny, rain, storm, snow

# ===== 核心信号 =====
signal day_started(day: int, season: String, weather: String)
signal day_ended(day: int)
signal hour_changed(new_hour: int)
signal minute_changed(new_minute: int)
signal season_changed(new_season: String)
signal weather_changed(new_weather: String)

# ===== 核心方法 =====
func advance_time(seconds: float) -> void
func get_time_string() -> String  # "HH:MM"
func is_daytime() -> bool
func is_nighttime() -> bool
func get_season() -> String
func get_days_in_season() -> int
func calculate_weather() -> String
func get_weather_icon() -> String
```

#### ItemManager (物品管理器)

```gdscript
# item_manager.gd 核心接口
class_name ItemManager
extends Node

# ===== 背包常量 =====
const INVENTORY_SIZE: int = 36  # 背包格子数
const STACK_MAX: int = 99       # 单格最大堆叠

# ===== 公共变量 =====
var inventory: Array = []       # 玩家背包 [{item_id, count}]
var gold: int = 50              # 玩家金币
var inventory_size: int = 36

# ===== 核心信号 =====
signal inventory_changed()
signal gold_changed(new_gold: int)
signal item_added(item_id: String, count: int)
signal item_removed(item_id: String, count: int)
signal inventory_full()

# ===== 核心方法 =====
func add_item(item_id: String, count: int = 1) -> bool
func remove_item(item_id: String, count: int = 1) -> bool
func has_item(item_id: String, count: int = 1) -> bool
func get_item_count(item_id: String) -> int
func get_item_data(item_id: String) -> Dictionary
func use_item(item_id: String) -> bool
func sell_item(item_id: String, count: int = 1) -> int
func buy_item(item_id: String, price: int) -> bool
```

#### SaveManager (存档管理器)

```gdscript
# save_manager.gd 核心接口
class_name SaveManager
extends Node

# ===== 存档常量 =====
const SAVE_DIR: String = "user://saves/"
const SLOT_COUNT: int = 3
const AUTO_SAVE_SLOT: int = 0

# ===== 公共变量 =====
var current_slot: int = 0
var last_save_time: Dictionary = {}

# ===== 核心信号 =====
signal save_completed(slot: int, success: bool)
signal load_completed(slot: int, success: bool)
signal auto_save_triggered()

# ===== 核心方法 =====
func save_game(slot: int = AUTO_SAVE_SLOT) -> bool
func load_game(slot: int) -> Dictionary
func auto_save() -> bool
func delete_save(slot: int) -> bool
func get_save_info(slot: int) -> Dictionary
func has_save(slot: int) -> bool
func export_save(slot: int, path: String) -> bool
func import_save(path: String) -> bool
```

---

## 📡 三、Signal 信号通信设计

### 3.1 核心信号流图

```
时间事件流:
┌─────────────┐     day_started()     ┌─────────────┐
│ TimeManager ├──────────────────────→│ GameManager │
└──────┬──────┘                       └──────┬──────┘
       │                                     │
       │ hour_changed()                      │ start_new_day()
       ▼                                     ▼
┌─────────────┐                       ┌─────────────┐
│ FarmManager │                       │ FarmManager │
└─────────────┘                       └─────────────┘

物品事件流:
┌─────────────┐     item_added()      ┌─────────────┐
│ ItemManager ├──────────────────────→│   UI Layer  │
└──────┬──────┘                       └─────────────┘
       │
       │ inventory_changed()
       ▼
┌─────────────┐
│ FarmManager │  (检查种子/工具)
└─────────────┘

金币事件流:
┌─────────────┐     gold_changed()    ┌─────────────┐
│ ItemManager ├──────────────────────→│   UI Layer  │
└──────┬──────┘                       └─────────────┘
       │
       │ buy_item() / sell_item()
       ▼
┌─────────────┐
│ Shop System │
└─────────────┘
```

### 3.2 信号定义规范

```gdscript
# ===== 系统间信号映射表 =====

# TimeManager → FarmManager
# 当新一天开始时，农场系统需要：
# 1. 检查所有作物生长状态
# 2. 自动浇水(雨天)
# 3. 恢复体力
func _on_day_started(day: int, season: String, weather: String):
    if weather == "rain":
        FarmManager.water_all_crops()
    FarmManager.grow_all_crops()
    FarmManager.restore_stamina()

# ItemManager → FarmManager
# 当物品变动时，农场系统需要检查可用工具/种子
func _on_inventory_changed():
    var has_seeds = ItemManager.has_item("wheat_seeds", 1)
    var has_hoe = ItemManager.has_item("hoe", 1)
    FarmManager.update_interactions(has_seeds, has_hoe)

# GameManager → 所有模块
# 当场景切换时，清理旧场景的事件监听
func _on_scene_changed(new_scene: SceneType):
    if new_scene == SceneType.FARM:
        FarmManager.enable()
        NPCManager.disable()
    elif new_scene == SceneType.TOWN:
        FarmManager.disable()
        NPCManager.enable()
```

### 3.3 事件总线设计

```gdscript
# event_bus.gd - 全局事件总线（可选，用于解耦）
class_name EventBus
extends Node

# ===== 通用事件 =====
signal custom_event(event_name: String, data: Dictionary)

# ===== 发布/订阅方法 =====
func emit(event_name: String, data: Dictionary = {}) -> void:
    custom_event.emit(event_name, data)

func subscribe(event_name: String, callback: Callable) -> void:
    # 简化版：直接连接信号
    pass

func unsubscribe(event_name: String, callback: Callable) -> void:
    pass
```

---

## 📂 四、数据加载机制

### 4.1 JSON 数据 Schema

#### items.json 结构

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Item Database",
  "description": "所有物品配置数据",
  "type": "object",
  "properties": {
    "items": {
      "type": "object",
      "additionalProperties": {
        "$ref": "#/$defs/Item"
      }
    }
  },
  "$defs": {
    "Item": {
      "type": "object",
      "required": ["id", "name", "type"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "description": { "type": "string" },
        "icon": { "type": "string" },
        "type": {
          "type": "string",
          "enum": ["seed", "crop", "tool", "material", "consumable", "gift", "quest"]
        },
        "price": { "type": "integer", "minimum": 0 },
        "sell_price": { "type": "integer", "minimum": 0 },
        "stack_size": { "type": "integer", "minimum": 1, "maximum": 999 },
        "attributes": { "type": "object" }
      }
    }
  }
}
```

#### crops.json 结构

```json
{
  "$schema": "...",
  "title": "Crop Database",
  "type": "object",
  "properties": {
    "crops": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/Crop" }
    }
  },
  "$defs": {
    "Crop": {
      "type": "object",
      "required": ["id", "name", "stages", "harvest_item"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "stages": {
          "type": "array",
          "minItems": 4,
          "items": {
            "type": "object",
            "properties": {
              "days": { "type": "integer", "minimum": 1 },
              "sprite": { "type": "string" }
            }
          }
        },
        "harvest_item": { "type": "string" },
        "harvest_amount": { "type": "integer", "default": 1 },
        "sell_price": { "type": "integer", "minimum": 0 },
        "water_needed": { "type": "boolean", "default": true },
        "seasons": {
          "type": "array",
          "items": { "type": "string" }
        }
      }
    }
  }
}
```

#### bosses.json 结构（v2.0 新增）

```json
{
  "title": "Boss Database",
  "type": "object",
  "properties": {
    "bosses": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/Boss" }
    }
  },
  "$defs": {
    "Boss": {
      "type": "object",
      "required": ["id", "name", "hp", "attacks", "rewards"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "sprite": { "type": "string" },
        "hp": { "type": "integer", "minimum": 100 },
        "attack": { "type": "integer", "minimum": 1 },
        "appearance_floor": { "type": "integer", "minimum": 1, "maximum": 100 },
        "attacks": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "damage": { "type": "integer" },
              "cooldown": { "type": "number" },
              "description": { "type": "string" }
            }
          }
        },
        "rewards": {
          "type": "object",
          "properties": {
            "items": { "type": "array" },
            "gold": { "type": "integer" },
            "achievement_id": { "type": "string" }
          }
        },
        "phases": { "type": "integer", "default": 1 }
      }
    }
  }
}
```

#### pets.json 结构（v2.0 增强 - 含多宠物机制）

```json
{
  "title": "Pet Database",
  "type": "object",
  "properties": {
    "pets": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/Pet" }
    },
    "synergies": {
      "type": "array",
      "description": "多宠物协同效应配置",
      "items": {
        "type": "object",
        "properties": {
          "pet_combo": { "type": "array", "items": { "type": "string" } },
          "synergy_id": { "type": "string" },
          "synergy_name": { "type": "string" },
          "effect": { "type": "string" },
          "condition": { "type": "string", "description": "触发条件" }
        }
      }
    },
    "slot_config": {
      "type": "object",
      "description": "宠物槽位配置",
      "properties": {
        "initial_slots": { "type": "integer", "default": 1 },
        "max_slots": { "type": "integer", "default": 3 },
        "slot_unlock_cost": { "type": "integer" },
        "slot_unlock_condition": { "type": "string" }
      }
    }
  },
  "$defs": {
    "Pet": {
      "type": "object",
      "required": ["id", "name", "species", "skills"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "species": { "type": "string", "enum": ["dog", "cat", "parrot", "horse"] },
        "sprite": { "type": "string" },
        "base_skill": { "type": "string" },
        "suitable_scene": { "type": "string", "enum": ["farm", "greenhouse", "mine", "town"] },
        "skills": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "id": { "type": "string" },
              "name": { "type": "string" },
              "unlock_level": { "type": "integer" },
              "description": { "type": "string" },
              "cooldown": { "type": "number" }
            }
          }
        },
        "affection_max": { "type": "integer", "default": 1000 },
        "feed_interval": { "type": "number" },
        "preferred_food": { "type": "string", "description": "偏好食物，喂食可获得额外好感度" },
        "synergy_partners": { "type": "array", "items": { "type": "string" } }
      }
    }
  }
}
```

#### fengshui.json 结构（v2.0 增强 - 含相克机制）

```json
{
  "title": "Fengshui (风水) Database",
  "type": "object",
  "properties": {
    "combinations": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/Fengshui" }
    },
    "incompatibilities": {
      "type": "array",
      "description": "阵法相克规则表",
      "items": {
        "type": "object",
        "properties": {
          "attacker_id": { "type": "string" },
          "target_id": { "type": "string" },
          "penalty_type": { "type": "string", "enum": ["growth", "production", "drop_rate", "animal_mood"] },
          "penalty_value": { "type": "number" },
          "season_exception": { "type": "string", "description": "在该季节不触发冲突" }
        }
      }
    }
  },
  "$defs": {
    "Fengshui": {
      "type": "object",
      "required": ["id", "name", "items", "effect"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "description": { "type": "string" },
        "element": { "type": "string", "enum": ["water", "fire", "earth", "metal", "wood", "integration"], "description": "五行属性，用于相克判定" },
        "items": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "item_id": { "type": "string" },
              "count": { "type": "integer" }
            }
          }
        },
        "effect": { "type": "string" },
        "effect_type": { "type": "string", "enum": ["water", "harvest", "luck", "animal", "growth", "quality", "pest_control", "amplifier"] },
        "effect_value": { "type": "number", "description": "增益数值（%或绝对值）" },
        "radius": { "type": "integer", "default": 5 },
        "unlock_condition": { "type": "string" },
        "unlock_season": { "type": "string" },
        "tier": { "type": "integer", "default": 1, "description": "阵法等级：1=第一年, 2=第二年, 3=第三年" }
      }
    }
  }
}
```

#### legendary.json 结构（v2.0 新增）

```json
{
  "title": "Legendary Items Database",
  "type": "object",
  "properties": {
    "legendary": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/LegendaryItem" }
    }
  },
  "$defs": {
    "LegendaryItem": {
      "type": "object",
      "required": ["id", "name", "category", "source"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "category": { "type": "string", "enum": ["fish", "crop", "weapon"] },
        "description": { "type": "string" },
        "icon": { "type": "string" },
        "sell_price": { "type": "integer", "minimum": 1000 },
        "source": {
          "type": "object",
          "properties": {
            "type": { "type": "string", "enum": ["boss_drop", "fishing", "greenhouse", "mine_floor"] },
            "floor": { "type": "integer" },
            "weather_required": { "type": "string" },
            "season_required": { "type": "string" }
          }
        },
        "stats": { "type": "object" },
        "title": { "type": "string" },
        "unlock_achievement": { "type": "string" }
      }
    }
  }
}
```

#### challenges.json 结构（v2.0 新增）

```json
{
  "title": "Challenge Database",
  "type": "object",
  "properties": {
    "challenges": {
      "type": "object",
      "additionalProperties": { "$ref": "#/$defs/Challenge" }
    }
  },
  "$defs": {
    "Challenge": {
      "type": "object",
      "required": ["id", "name", "type", "conditions"],
      "properties": {
        "id": { "type": "string" },
        "name": { "type": "string" },
        "description": { "type": "string" },
        "type": { "type": "string", "enum": ["speedrun", "collection", "milestone"] },
        "conditions": {
          "type": "object",
          "properties": {
            "target_value": { "type": "integer" },
            "time_limit_days": { "type": "integer" },
            "required_items": { "type": "array" },
            "required_floors": { "type": "integer" }
          }
        },
        "rewards": {
          "type": "object",
          "properties": {
            "gold": { "type": "integer" },
            "items": { "type": "array" },
            "unlock": { "type": "string" }
          }
        },
        "difficulty": { "type": "string", "enum": ["easy", "medium", "hard", "legendary"] },
        "status": { "type": "string", "enum": ["locked", "available", "in_progress", "completed"] }
      }
    }
  }
}
```

### 4.2 DataLoader 实现

```gdscript
# data_loader.gd
class_name DataLoader
extends Node

# ===== 数据缓存 =====
var _cache: Dictionary = {}

# ===== 核心方法 =====
func load_json_file(path: String) -> Dictionary:
    """加载并解析JSON文件"""
    if _cache.has(path):
        return _cache[path]
    
    var file = FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("Failed to open file: %s" % path)
        return {}
    
    var content = file.get_as_text()
    file.close()
    
    var data = JSON.parse_string(content)
    if data == null:
        push_error("Failed to parse JSON: %s" % path)
        return {}
    
    _cache[path] = data
    return data

func get_item_data(item_id: String) -> Dictionary:
    """获取物品配置"""
    var items_data = load_json_file("res://data/items.json")
    return items_data.get("items", {}).get(item_id, {})

func get_crop_data(crop_id: String) -> Dictionary:
    """获取作物配置"""
    var crops_data = load_json_file("res://data/crops.json")
    return crops_data.get("crops", {}).get(crop_id, {})

func get_npc_data(npc_id: String) -> Dictionary:
    """获取NPC配置"""
    var npcs_data = load_json_file("res://data/npcs.json")
    return npcs_data.get("npcs", {}).get(npc_id, {})

func clear_cache() -> void:
    """清空缓存"""
    _cache.clear()

func reload_data(path: String = "") -> void:
    """重新加载数据"""
    if path == "":
        clear_cache()
    else:
        _cache.erase(path)
```

---

## 💾 五、存档系统设计

### 5.1 存档数据结构（v2.0 扩展）

```json
{
  "save_version": "2.0.1",
  "timestamp": "2026-07-29T14:30:00",
  "game_data": {
    "player": {
      "name": "Farmer",
      "gold": 25000,
      "total_earned": 45000,
      "stamina": 270,
      "max_stamina": 270,
      "health": 100,
      "max_health": 100
    },
    "time": {
      "day": 15,
      "season": "summer",
      "year": 1,
      "hour": 14,
      "minute": 30,
      "weather": "sunny"
    },
    "inventory": [
      {"item_id": "wheat", "count": 25},
      {"item_id": "parsnip", "count": 12}
    ],
    "farm": {
      "tiles": [
        {"x": 0, "y": 0, "state": "tilled", "crop_id": null, "watered": false, "growth_stage": 0},
        {"x": 1, "y": 0, "state": "tilled", "crop_id": "parsnip", "watered": true, "growth_stage": 2}
      ],
      "fengshui_active": ["water_array"],
      "fengshui_conflicts": []
    },
    "npcs": {
      "mayor": {"friendship": 450, "gifts_this_week": ["pumpkin"], "relationship_type": "mayor"},
      "blacksmith": {"friendship": 320, "relationship_with_mayor": "jealous"}
    },
    "pets": {
      "active_slots": ["dog_01", "cat_01"],
      "max_slots": 2,
      "dog_01": {"affection": 850, "skills_unlocked": ["auto_pickup"]},
      "cat_01": {"affection": 520, "skills_unlocked": ["night_vision"]}
    },
    "automation": {
      "devices": [
        {"id": "sprinkler_01", "type": "iridium_sprinkler", "fuel_type": "coal", "fuel_remaining": 7}
      ],
      "total_fuel_used": 150
    },
    "flags": {
      "tutorial_completed": true,
      "first_day_completed": true
    },
    "future_data": {
      "year_3_unlocked": false,
      "new_land_discovered": false,
      "career_choices": [],
      "ending_flags": {
        "farm_type": null,
        "spouse_npc": null,
        "mine_deepest_floor": 0,
        "total_collections": 0
      }
    },
    "ending_data": {
      "triggered_ending": null,
      "eligible_endings": [],
      "key_decisions": [],
      "farm_metrics": {
        "style": null,
        "total_value": 0,
        "automation_count": 0
      },
      "social_metrics": {
        "married_to": null,
        "max_friendship": 0
      },
      "combat_metrics": {
        "deepest_floor": 0,
        "bosses_killed": []
      },
      "speedrun_time": null,
      "collector_score": 0
    }
  }
}
```

### 5.2 存档实现

```gdscript
# save_manager.gd 核心方法实现
class_name SaveManager
extends Node

const SAVE_DIR: String = "user://saves/"
const AUTO_SAVE_INTERVAL: float = 300.0  # 5分钟自动保存

var _auto_save_timer: float = 0.0

func _ready() -> void:
    # 确保存档目录存在
    DirAccess.make_dir_recursive_absolute(SAVE_DIR)
    # 启动自动保存计时
    process.set_physics_process(true)

func _process(delta: float) -> void:
    _auto_save_timer += delta
    if _auto_save_timer >= AUTO_SAVE_INTERVAL:
        auto_save()
        _auto_save_timer = 0.0

func save_game(slot: int = 0) -> bool:
    """保存游戏到指定槽位"""
    var save_data = _collect_save_data()
    var path = _get_save_path(slot)
    
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_error("Cannot write to save file: %s" % path)
        return false
    
    file.store_string(JSON.stringify(save_data, "\t"))
    file.close()
    
    save_completed.emit(slot, true)
    return true

func load_game(slot: int) -> Dictionary:
    """从指定槽位加载游戏"""
    var path = _get_save_path(slot)
    
    if not FileAccess.file_exists(path):
        push_error("Save file not found: %s" % path)
        return {}
    
    var file = FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("Cannot read save file: %s" % path)
        return {}
    
    var data = JSON.parse_string(file.get_as_text())
    file.close()
    
    load_completed.emit(slot, true)
    return data

func auto_save() -> bool:
    """自动保存"""
    auto_save_triggered.emit()
    return save_game(0)

func _collect_save_data() -> Dictionary:
    """收集当前游戏状态用于存档"""
    return {
        "save_version": "1.0.0",
        "timestamp": Time.get_datetime_string_from_system(),
        "game_data": {
            "player": {
                "name": GameManager.player_data.get("name", "Farmer"),
                "gold": ItemManager.gold,
                "stamina": FarmManager.current_stamina,
                "max_stamina": FarmManager.max_stamina
            },
            "time": {
                "day": TimeManager.current_day,
                "season": TimeManager.current_season,
                "year": GameManager.game_year,
                "hour": TimeManager.current_hour,
                "minute": TimeManager.current_minute,
                "weather": TimeManager.weather_today
            },
            "inventory": ItemManager.inventory,
            "farm": {
                "tiles": FarmManager.get_tile_data()
            },
            "npcs": NPCManager.get_npc_data(),
            "flags": GameManager.player_data.get("flags", {})
        }
    }

func _get_save_path(slot: int) -> String:
    """获取存档文件路径"""
    return "%ssave_%d.json" % [SAVE_DIR, slot]
```

---

## 🎨 六、场景树结构

### 6.1 主场景结构

```
Main (Node)
├── GameUI (CanvasLayer)
│   ├── HUD (Control)
│   │   ├── TimeDisplay (Label)
│   │   ├── GoldDisplay (Label)
│   │   ├── StaminaBar (ProgressBar)
│   │   └── WeatherIcon (TextureRect)
│   ├── InventoryPanel (Panel)
│   │   └── InventoryGrid (GridContainer)
│   ├── DialogBox (Panel)
│   │   └── DialogText (Label)
│   └── MainMenu (Control)
│       ├── NewGameButton
│       ├── ContinueButton
│       └── SettingsButton
├── World (Node2D)
│   ├── Player (CharacterBody2D)
│   │   ├── Sprite2D
│   │   ├── CollisionShape2D
│   │   └── StateMachine (AnimationPlayer)
│   ├── FarmTileMap (TileMap)
│   ├── CropContainer (Node2D)
│   └── NPCContainer (Node2D)
└── Managers (Node)
    └── (Autoload singletons attached here)
```

### 6.2 农场场景结构

```
FarmScene (Node2D)
├── Background (ParallaxBackground)
│   ├── SkyLayer (Parallax2D)
│   └── DistantHills (Parallax2D)
├── Ground (TileMap)
│   └── GroundTiles (TileSet)
├── FarmLand (TileMap)
│   └── FarmTiles (TileSet)
├── Crops (Node2D)
│   ├── Crop_001 (Area2D)
│   │   ├── CropSprite (Sprite2D)
│   │   └── GrowthAnimation (AnimationPlayer)
│   └── Crop_002 ...
├── Buildings (Node2D)
│   ├── House (Area2D)
│   ├── Silo (Area2D)
│   └── Well (Area2D)
├── Decoration (Node2D)
│   ├── Trees (Sprite2D)
│   └── Flowers (Sprite2D)
├── CollisionMap (StaticBody2D)
└── SpawnPoints (Marker2D)
    ├── FarmEntrance
    └── HouseDoor
```

### 6.3 角色状态机

```gdscript
# player_state_machine.gd
class_name PlayerStateMachine
extends AnimationPlayer

# ===== 状态枚举 =====
enum State { IDLE, WALKING, WORKING, PLANTING, WATERING, HARVESTING }

var current_state: State = State.IDLE
var state_timer: float = 0.0

# ===== 状态转换 =====
func change_state(new_state: State) -> void:
    if current_state == new_state:
        return
    
    _exit_state(current_state)
    current_state = new_state
    _enter_state(new_state)

func _enter_state(state: State) -> void:
    match state:
        State.IDLE:
            play("idle")
        State.WALKING:
            play("walk")
        State.PLANTING:
            play("plant")
            state_timer = 0.5
        State.WATERING:
            play("water")
            state_timer = 0.5
        State.HARVESTING:
            play("harvest")
            state_timer = 0.3

func _exit_state(state: State) -> void:
    # 清理状态
    pass
```

---

## 🗂️ 七、项目文件结构

### 7.1 目录组织（v2.0 扩展）

```
farm-game/
├── project.godot                          # Godot 项目配置
│
├── src/
│   ├── autoload/                          # Autoload 单例
│   │   ├── game_manager.gd               # 游戏主管理器
│   │   ├── save_manager.gd                # 存档管理器
│   │   ├── data_loader.gd                # 数据加载器
│   │   ├── audio_manager.gd               # 音频管理器
│   │   └── event_bus.gd                   # 事件总线
│   │
│   ├── systems/                           # 游戏系统
│   │   ├── time/
│   │   │   ├── time_manager.gd            # 时间管理器
│   │   │   ├── weather_system.gd           # 天气系统
│   │   │   └── weather_altar.gd            # 天气祭坛 (v2.0)
│   │   ├── farm/
│   │   │   ├── farm_manager.gd            # 农场管理器
│   │   │   ├── crop_grower.gd             # 作物生长
│   │   │   ├── farm_tile.gd               # 农场地块
│   │   │   ├── tool_handler.gd            # 工具处理
│   │   │   ├── greenhouse.gd              # 温室系统 (v2.0)
│   │   │   └── fengshui_manager.gd        # 风水系统 (v2.0)
│   │   ├── item/
│   │   │   ├── item_manager.gd            # 物品管理器
│   │   │   ├── inventory.gd               # 背包系统
│   │   │   ├── shop_system.gd             # 商店系统
│   │   │   ├── crafting_system.gd         # 合成系统
│   │   │   └── automation.gd              # 自动化设备 (v2.0)
│   │   ├── npc/
│   │   │   ├── npc_manager.gd             # NPC管理器
│   │   │   ├── npc_character.gd           # NPC角色
│   │   │   ├── dialog_system.gd           # 对话系统
│   │   │   └── friendship_system.gd       # 好感度系统 (10心 v2.0)
│   │   ├── combat/
│   │   │   ├── combat_manager.gd          # 战斗管理器
│   │   │   ├── monster_ai.gd              # 怪物AI
│   │   │   ├── mine_generator.gd          # 矿洞生成 (100层 v2.0)
│   │   │   ├── boss_controller.gd         # Boss控制器 (v2.0)
│   │   │   └── loot_system.gd             # 战利品系统
│   │   ├── building/
│   │   │   ├── building_manager.gd        # 建造管理器
│   │   │   ├── event_system.gd            # 事件系统
│   │   │   ├── quest_system.gd            # 任务系统
│   │   │   └── community_center.gd        # 社区中心 (v2.0)
│   │   ├── pet/                           # 宠物系统 (v2.0 P1)
│   │   │   ├── pet_manager.gd             # 宠物管理器
│   │   │   ├── pet_ai.gd                  # 宠物AI
│   │   │   └── pet_skills.gd              # 宠物技能树
│   │   └── achievement/                   # 成就系统 (v2.0 P2)
│   │       ├── achievement_manager.gd     # 成就管理器
│   │       ├── challenge_system.gd        # 挑战模式
│   │       └── speedrun_timer.gd          # 速通计时器
│   │
│   ├── scenes/                            # 场景文件
│   │   ├── main.tscn                      # 主场景
│   │   ├── farm/
│   │   │   └── farm_scene.tscn            # 农场场景
│   │   ├── town/
│   │   │   └── town_scene.tscn            # 城镇场景
│   │   ├── mine/
│   │   │   └── mine_scene.tscn            # 矿洞场景
│   │   ├── shop/
│   │   │   └── shop_scene.tscn            # 商店场景
│   │   └── greenhouse/                    # 温室场景 (v2.0)
│   │       └── greenhouse_scene.tscn
│   │
│   └── ui/                                # UI脚本
│       ├── hud.gd                         # HUD界面
│       ├── inventory_ui.gd                # 背包界面
│       ├── dialog_ui.gd                   # 对话界面
│       ├── shop_ui.gd                     # 商店界面
│       ├── main_menu.gd                   # 主菜单
│       ├── pet_ui.gd                      # 宠物面板 (v2.0)
│       ├── achievement_ui.gd              # 成就面板 (v2.0)
│       └── fengshui_ui.gd                 # 风水编辑 (v2.0)
│
├── data/                                  # 游戏数据
│   ├── items.json                         # 物品配置
│   ├── crops.json                         # 作物配置
│   ├── npcs.json                          # NPC配置
│   ├── dialogs.json                       # 对话配置
│   ├── recipes.json                       # 合成配方
│   ├── events.json                        # 事件配置
│   ├── bosses.json                        # Boss数据 (v2.0)
│   ├── pets.json                          # 宠物数据 (v2.0)
│   ├── fengshui.json                      # 风水组合+相克规则 (v2.0)
│   ├── legendary.json                     # 传说物品 (v2.0)
│   ├── challenges.json                    # 挑战配置 (v2.0)
│   ├── endings.json                       # 多结局配置 (v2.1 预留)
│   ├── crops_v3.json                      # 第三年作物 (v3.0 预留)
│   ├── npcs_v3.json                       # 第三年NPC (v3.0 预留)
│   ├── bosses_v3.json                     # 第三年Boss (v3.0 预留)
│   └── events_v3.json                     # 第三年事件 (v3.0 预留)
│
├── assets/                                # 美术资源
│   ├── sprites/                           # 精灵图
│   │   ├── characters/                    # 角色精灵
│   │   ├── crops/                         # 作物精灵
│   │   ├── items/                         # 物品图标
│   │   ├── npcs/                          # NPC精灵
│   │   ├── bosses/                        # Boss精灵 (v2.0)
│   │   └── pets/                          # 宠物精灵 (v2.0)
│   ├── tilesets/                          # 瓦片集
│   │   ├── farm_tileset.png               # 农场瓦片
│   │   ├── town_tileset.png               # 城镇瓦片
│   │   ├── mine_tileset.png               # 矿洞瓦片
│   │   ├── greenhouse_tileset.png         # 温室瓦片 (v2.0)
│   │   └── fengshui_tileset.png           # 风水装饰 (v2.0)
│   ├── audio/                             # 音频
│   │   ├── music/                         # 背景音乐
│   │   └── sfx/                           # 音效
│   └── fonts/                             # 字体
│
└── docs/                                  # 文档
    ├── PRD-产品需求文档.md
    └── TDD-技术设计文档.md
```
### 7.2 project.godot Autoload 配置

```ini
[autoload]

GameManager="*res://src/autoload/game_manager.gd"
SaveManager="*res://src/autoload/save_manager.gd"
DataLoader="*res://src/autoload/data_loader.gd"
TimeManager="*res://src/systems/time/time_manager.gd"
ItemManager="*res://src/systems/item/item_manager.gd"
FarmManager="*res://src/systems/farm/farm_manager.gd"
NPCManager="*res://src/systems/npc/npc_manager.gd"
CombatManager="*res://src/systems/combat/combat_manager.gd"
BuildingManager="*res://src/systems/building/building_manager.gd"
PetManager="*res://src/systems/pet/pet_manager.gd"
AchievementManager="*res://src/systems/achievement/achievement_manager.gd"
AudioManager="*res://src/autoload/audio_manager.gd"
```

---

## 📐 八、代码规范

### 8.1 GDScript 命名规范

```gdscript
# ===== 命名规则 =====

# 类名: PascalCase
class_name FarmManager
class_name CropGrower
class_name SaveManager

# 变量名: snake_case (私有) / PascalCase (公共)
var current_day: int = 0
var _internal_counter: int = 0
const MAX_INVENTORY_SIZE: int = 36

# 函数名: snake_case
func get_item_data(item_id: String) -> Dictionary
func _calculate_growth_stage() -> int

# 信号: snake_case + 过去式
signal day_started(day: int)
signal item_added(item_id: String, count: int)
signal inventory_changed()

# 枚举: PascalCase 类型 + snake_case 值
enum State { IDLE, WALKING, WORKING }
enum Season { SPRING, SUMMER, AUTUMN, WINTER }

# 文件命名: snake_case.gd
# farm_manager.gd
# crop_grower.gd
# time_manager.gd
```

### 8.2 代码结构规范

```gdscript
# 推荐的代码组织顺序：

# 1. 文件头注释
## @file farm_manager.gd
## @author Farm System Agent
## @date 2026-07-29
## @description 农场系统管理器，负责作物生长、土地管理

# 2. 类定义
class_name FarmManager
extends Node

# 3. 枚举定义
enum FarmState { IDLE, PLOWED, PLANTED, WATERED }

# 4. 常量
const TILE_SIZE: int = 32
const MAX_TILES_X: int = 12
const MAX_TILES_Y: int = 12

# 5. 信号
signal crop_planted(crop_id: String, x: int, y: int)
signal crop_harvested(crop_id: String, amount: int)
signal farm_tilled(x: int, y: int)

# 6. 公共变量
var current_stamina: float = 270.0
var max_stamina: float = 270.0
var is_farm_active: bool = true

# 7. 私有变量
var _tiles: Array = []
var _is_initialized: bool = false

# 8. 生命周期函数
func _ready() -> void:
    _initialize_farm()

func _process(delta: float) -> void:
    _update_crops(delta)

# 9. 公共方法
func plant_crop(x: int, y: int, seed_id: String) -> bool:
    # 实现...
    pass

# 10. 私有方法
func _initialize_farm() -> void:
    # 实现...
    pass

# 11. 信号回调
func _on_time_day_started(day: int, season: String, weather: String) -> void:
    # 实现...
    pass
```

---

## ⚠️ 九、性能优化要点

### 9.1 性能预算

| 指标 | 目标值 | 说明 |
|------|--------|------|
| 目标帧率 | 60 FPS | 稳定运行 |
| 单次帧耗时 | <16ms | CPU时间 |
| 内存占用 | <200MB | 稳定状态 |
| 存档写入 | <200ms | 自动保存 |
| 场景切换 | <1s | 包含加载 |

### 9.2 优化策略

```gdscript
# 1. 对象池模式 - 复用频繁创建的对象
# 适用于: 作物精灵、粒子特效、伤害数字

# 2. 信号批量处理 - 减少信号发射频率
# 适用于: 物品变化、时间更新

# 3. 懒加载 - 场景内容按需加载
# 适用于: 地图区域、NPC数据

# 4. 数据缓存 - 避免重复读取
# 适用于: JSON配置、计算结果

# 5. 物理分层 - 简化不需要物理的对象
# 适用于: 装饰性元素、静态场景

# 性能示例：
# 不要这样：
func _process(delta):
    for crop in all_crops:
        crop.update_growth()

# 优化为：
func _process(delta):
    if _growth_timer > GROWTH_INTERVAL:  # 每10秒检查一次
        _growth_timer = 0
        _update_all_crops()
```

---

## 📋 十、测试策略

### 10.1 单元测试

```gdscript
# 测试文件结构:
# tests/unit/
# ├── test_item_manager.gd
# ├── test_farm_manager.gd
# ├── test_time_manager.gd
# └── test_save_manager.gd

# 测试示例:
class_name TestItemManager
extends GUTest

func test_add_item():
    var result = ItemManager.add_item("wheat", 5)
    assert_true(result)
    assert_eq(ItemManager.get_item_count("wheat"), 5)

func test_sell_item():
    ItemManager.add_item("wheat", 10)
    var gold_before = ItemManager.gold
    ItemManager.sell_item("wheat", 5)
    assert_gt(ItemManager.gold, gold_before)
    assert_eq(ItemManager.get_item_count("wheat"), 5)
```

### 10.2 测试覆盖要求

| 模块 | 覆盖率要求 | 测试重点 |
|------|-----------|----------|
| time_system | >80% | 时间计算、季节切换、天气生成 |
| item_system | >80% | 背包操作、经济逻辑、边界条件 |
| farm_system | >70% | 作物生长、地块管理、体力消耗 |
| npc_system | >70% | 对话逻辑、好感度计算 |
| save_system | >90% | 存档完整性、兼容性 |

---

## 📎 附录

### A. 技术选型验证

| 技术 | 版本 | 验证状态 |
|------|------|----------|
| Godot | 4.2+ | ✅ 官方稳定版 |
| GDScript | 4.x | ✅ 引擎原生支持 |
| Git | 2.x | ✅ 行业标准 |

### B. 开发工具链

| 工具 | 用途 | 说明 |
|------|------|------|
| VS Code | 代码编辑 | + Godot插件 |
| Aseprite | 像素艺术 | 角色/物品/作物 |
| Tiled | 地图编辑 | 可选，导出为Godot格式 |
| GitKraken | Git管理 | 可视化版本控制 |

### C. 参考资源

- [Godot 4.x GDScript Reference](https://docs.godotengine.org/zh-cn/4.x/tutorials/script/gdscript.html)
- [Godot Autoload Tutorial](https://docs.godotengine.org/zh-cn/4.x/tutorials/script/autoload.html)
- [Godot Signals Tutorial](https://docs.godotengine.org/zh-cn/4.x/tutorials/script/signals.html)

---

## 📎 附录 D：开发实施建议（技术渐进策略）

> 本附录记录技术实施层面的渐进式开发策略，确保复杂系统分阶段交付，降低早期版本风险。
> 核心原则：**先简后繁、先核心后扩展、验证后迭代**。

### D.1 总体分阶段交付规划

| 系统 | Phase 1 (MVP) | Phase 2 (v2.0 完整版) | 风险评估 |
|------|---------------|----------------------|----------|
| **Boss AI** | 简单状态机（2-3 种攻击模式） | 多阶段 AI、特殊机制、环境交互 | 🔴 高 |
| **自动化路径** | 矩形范围收获 / 固定路线 | A* 动态路径规划 | 🟡 中 |
| **鹦鹉对话** | 预录制 NPC 语音片段随机播放 | 语义理解 + 动态对话生成 | 🟡 中 |
| **NPC 朋友圈** | 固定关系预设（3 组关系对） | 动态事件触发 + 连锁反应 | 🟡 中 |
| **风水相克** | 同区域冲突检测 | 季节例外 + 跨区域共存 | 🟢 低 |
| **存档系统** | 预留字段结构 | 数据迁移工具 | 🟢 低 |

### D.2 各系统详细实施建议

#### D.2.1 Boss AI 分阶段实现（🔴 高风险）

**Phase 1 - 简单模式（必做）**:
```gdscript
# boss_controller.gd - Phase 1 实现
class_name BossController
extends CharacterBody2D

# 简单状态机：巡逻 → 追击 → 攻击 → 冷却
enum State { PATROL, CHASE, ATTACK, COOLDOWN }

var current_state: State = State.PATROL
var attack_patterns: Array = ["charge", "slam", "projectile"]  # 3种攻击

# Phase 1 仅实现 2-3 种攻击
# 后续版本扩展为多阶段 AI（HP < 50% 切换模式）
# 性能验证：单 Boss AI 占用 < 1ms 帧时间
```

**Phase 2 - 完整版（v2.0）**:
- 多阶段 AI（HP 阈值触发模式切换）
- 环境交互（触发机关、破坏地形）
- 特殊机制（召唤小怪、治疗、狂暴化）
- Boss 之间联动（如三头龙三部位独立 AI）

**风险缓解**: 先用 20 层 Boss（巨岩史莱姆）验证 AI 框架，再扩展到 100 层 Boss。

---

#### D.2.2 自动化设备路径规划（🟡 中风险）

**Phase 1 - 矩形范围模式（必做）**:
```gdscript
# automation.gd - Phase 1 实现
# 简单矩形范围收获，无需路径规划
func harvest_in_rect(rect: Rect2i) -> int:
    var harvested_count = 0
    for crop in get_crops_in_rect(rect):
        if crop.is_mature():
            crop.harvest()
            harvested_count += 1
    return harvested_count
```

**Phase 2 - A* 动态路径（v2.0 完整版）**:
```gdscript
# Phase 2 实现 - A* 路径规划
# 性能要求：12×12 农场景观下路径计算 < 50ms
func plan_path(target_pos: Vector2i) -> Array:
    # 使用 A* 算法在农场地块网格上规划路径
    # 需提前验证性能，避免阻塞主线程
    # 建议使用异步计算或分帧处理
    pass
```

**风险缓解**: Phase 1 可覆盖 90% 使用场景，Phase 2 仅对超级农场（24×24）有性能需求。

---

#### D.2.3 鹦鹉对话模仿（🟡 中风险）

**Phase 1 - 预录制片段随机播放（必做）**:
```gdscript
# parrot_ai.gd - Phase 1 实现
class_name ParrotAI
extends Node

# 使用预录制的 NPC 语音片段，而非实时生成
var dialog_clips: Dictionary = {
    "mayor": ["欢迎...", "小镇...", "节日..."],
    "blacksmith": ["金属...", "武器...", "打造..."],
    // ...
}

func mimic_npc(npc_id: String) -> String:
    var clips = dialog_clips.get(npc_id, [])
    if clips.size() > 0:
        return clips.pick_random()  # 随机选择一个预录制片段
    return "..."
```

**Phase 2 - 语义理解（v2.1+ 规划）**:
- 根据 NPC 当前对话内容提取关键词
- 组合生成模仿语句
- 需 NLP 相关库支持，复杂度高

**风险缓解**: Phase 1 已能实现"鹦鹉模仿"的核心体验，玩家可感知鹦鹉在"说话"。

---

#### D.2.4 NPC 朋友圈动态（🟡 中风险）

**Phase 1 - 固定关系预设（必做）**:
```gdscript
# npc_relationship_system.gd - Phase 1 实现
# 预定义 NPC 关系网络
var relationship_pairs: Array = [
    { "a": "shopkeeper", "b": "blacksmith", "type": "business_partner" },
    { "a": "doctor", "b": "poet", "type": "close_friends" },
    { "a": "fisher", "b": "mayor", "type": "stakeholder" },
]

# Phase 1 仅触发固定事件
func check_relationship_event(npc_a: String, npc_b: String) -> EventData:
    var pair = find_pair(npc_a, npc_b)
    if pair:
        return trigger_fixed_event(pair, friendship_data)
    return null
```

**Phase 2 - 动态事件（v2.0 完整版）**:
- 根据好感度差值触发吃醋事件
- 多 NPC 联动任务链
- 社交传播（A 告诉 B 秘密）
- 团体活动触发

**风险缓解**: Phase 1 的固定关系已提供 NPC 联动的核心价值，不会让玩家感到"空洞"。

---

### D.3 存档字段预留（已完成 ✅）

存档结构中的 `future_data` 和 `ending_data` 字段已在 v2.0 设计中预留，**避免后期数据迁移痛苦**：

```json
{
  "future_data": {
    "year_3_unlocked": false,
    "new_land_discovered": false,
    "career_choices": [],
    "ending_flags": { ... }
  },
  "ending_data": {
    "triggered_ending": null,
    "eligible_endings": [],
    "key_decisions": [],
    ...
  }
}
```

**迁移策略**: v2.1/v3.0 新字段需提供 `SaveMigration` 工具类，自动从旧版本存档迁移数据。

---

### D.4 分阶段验收标准

| 阶段 | 验收标准 | 时间节点 |
|------|----------|----------|
| **Phase 1 验收** | Boss AI 有 2-3 种攻击、自动化支持矩形收获、鹦鹉能模仿 NPC 语音、NPC 有固定关系联动 | MVP 发布前 |
| **Phase 2 验收** | Boss AI 多阶段、自动化 A* 路径、鹦鹉动态对话、NPC 全动态事件 | v2.0 正式发布 |
| **Phase 3+ 验收** | 第三年内容、多结局系统、副业系统 | v2.1/v3.0 规划 |

---

**文档状态**: ✅ 已批准  
**批准人**: 🏗️ Technical Director  
**下一步**: 各系统Lead基于此文档开始方案设计
