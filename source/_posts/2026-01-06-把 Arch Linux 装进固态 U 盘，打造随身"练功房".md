---
title: 把 Arch Linux 装进固态 U 盘，打造随身"练功房"
date: 2026-01-06 22:30:00
tags: [Arch Linux, Hyprland, USB, STM32, Neovim, Linux]
categories: [折腾记录]
description: 手头有一个努米诺固态 U 盘，突发奇想把 Arch Linux 装进去，打造一个完全独立的、随插随用的 x86 开发环境。使用 archinstall 快速安装，配置 Hyprland 平铺窗口管理器，解决断网、中文显示、蓝牙连接等坑，为 STM32 开发做准备，决定强制自己使用 Neovim + GCC + Makefile + OpenOCD 的纯终端流。
---

> **摘要**：手头有一个努米诺固态 U 盘，突发奇想把 Arch Linux 装进去，打造一个完全独立的、随插即用的 x86 开发环境。这不仅是为了 STM32 开发，更是为了逼自己一把——脱离 IDE 的舒适区，在 Hyprland 的平铺世界里修炼内功。使用 archinstall 快速安装，配置 Hyprland 窗口管理器，解决各种坑（断网、中文方块、蓝牙假死），并决定强制自己使用 **Neovim + GCC + Makefile + OpenOCD** 的纯终端流。

---

## 🛠️ 准备与安装：从 archinstall 开始

比起以前照着 Wiki 敲命令，这次直接使用了官方的 `archinstall` 脚本，确实省心，但针对 U 盘系统，有两个关键点不能错：

1.  **分区**：选了 ext4（求稳）。
2.  **引导 (Grub)**：脚本跑完后，不能直接重启！必须进入 `chroot` 环境，手动修复引导，加上 `--removable` 参数。
    ```bash
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck
    ```
    *（不做这一步，这 U 盘换台电脑就认不出来了。）*

## 🚧 装修毛坯房：Hyprland 的初体验

重启进入系统，迎接我的是经典的"Wc，啥也没有？"时刻。
Hyprland 默认真的就是一个黑屏加光标。没有 Docker，没有菜单，连壁纸都没有。

### 1. 基础生存操作
* **开终端**：`Win + Q`
* **开菜单**：`Win + R` (原本选了 hyprlauncher 报错，后来改成了 wofi)
* **退出**：`Win + M`

### 2. 补全家具
archinstall 给了个极简环境，不得不手动"进货"：
```bash
sudo pacman -S waybar dunst hyprpaper
```

然后在 `~/.config/hypr/hyprland.conf` 里加上 `exec-once` 让它们开机自启。

## 💥 踩坑与填坑 (Troubleshooting)

今天的重头戏其实是修 Bug，Arch 诚不欺我，果然是折腾出来的。

### 1. 断网与镜像源报错

刚进去一片红字的 `Could not resolve host`。
**解法**：终端输入 `nmtui`，图形化连接 WiFi。简单粗暴。

### 2. 中文变方块 (□□□)

打开 Firefox 一看，中文全是豆腐块。
**解法**：补装中文字体。

```bash
sudo pacman -S wqy-zenhei
```

### 3. 蓝牙假死

这是最灵异的。Blueman 显示连接成功，但键盘鼠标动不了。
**原因**：Linux 没有信任 HID 设备。
**解法**：使用 `bluetoothctl` 手术刀操作。

```bash
[bluetooth]# scan on
[bluetooth]# trust XX:XX:XX:XX:XX:XX  <-- 关键一步！
[bluetooth]# connect XX:XX:XX:XX:XX:XX
```

手动信任之后，设备秒连。

### 4. 局域网加速

为了装软件快点，利用了旁边的 Mac。在 Mac 上开启 Clash 的 "Allow LAN"，然后在 Arch 里临时挂代理：

```bash
export http_proxy=http://192.168.x.x:7890
```

速度起飞。

## 🧘‍♂️ 思考：关于工具的选择

我有性能强大的 M4 Mac，但我意识到：

* **Mac (ARM)**：是我的"指挥部"，负责日常、文档、娱乐。
* **Arch U盘 (x86)**：是我的"精神时光屋"。

在这个 U 盘系统里，我做了一个决定：**不安装 VS Code，不装 IDE。**
接下来的 STM32 开发，我将强制自己使用 **Neovim + GCC + Makefile + OpenOCD** 的纯终端流。

既然是折腾，那就贯彻到底。
