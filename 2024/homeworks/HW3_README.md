---
layout: default
---

*黄金法则：如果你在任何一步看到了自己不认识的错误信息或不知道如何进行下一步，请随时联系助教！助教是你永远的朋友。*

# 第 3 次作业使用指南

本文档可能给出了一些你在完成第三次作业时遇到的问题。注意，虽然课上请大家使用 stack 管理此项目，但是本次作业不推荐大家使用以避免不必要的复杂。

## cabal换源

请确保你已经安装了 cabal，通过在命令行运行`cabal --version`查看，应当得到如下的结果：
```
$ cabal --version
cabal-install version 3.6.2.0
```

**换源：** 首先在命令行中输入 `cabal user-config init`，他会为你创建一个配置文件，并告诉你其所在路径。默认情况下，
- Windows：`C:\cabal\config`
- macOS：`~/.cabal/config`

编辑此文件，找到下面的部分：
```
repository hackage.haskell.org
  url: http://hackage.haskell.org/
  -- secure: True
  -- root-keys:
  -- keys-threshold: 3
```

将其**替换为**：
```
repository mirrors.ustc.edu.cn
  url: https://mirrors.ustc.edu.cn/hackage/
  secure: True
```

保存后，在命令行中运行`cabal update`，而后运行 `cabal install --lib random` 来安装 random 包。会有类似于如下的输出：
```
$cabal install --lib random
Resolving dependencies...
Build profile: -w ghc-9.2.8 -O1
In order, the following will be built (use -v for more details):
 - splitmix-0.1.0.4 (lib) (requires download & build)
 - random-1.2.1.1 (lib) (requires download & build)
Downloading  splitmix-0.1.0.4
Downloaded   splitmix-0.1.0.4
...
```

## 编译程序并执行

在你完成本次作业之前，推荐你尝试编译运行一下课上的 Hello world 程序示例。你可以**正确的路径下**使用如下命令编译程序（*如果你不知道什么是正确的路径，请参考上一次作业的帮助文档*）：
```
$ ghc HW3.hs
Loaded package environment from C:\Users\vbcpa\AppData\Roaming\ghc\x86_64-mingw32-9.2.8\environments\default
[1 of 1] Compiling Main             ( HW3.hs, HW3.o )
Linking HW3.exe ...
```

你可以通过如下的方式执行该程序：
- Windows: `.\HW3.exe`
- macOS: `./HW3`
