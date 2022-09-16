---
layout: default
---

# 如何安装 Stack

在安装好 ghcup 后，在命令行中通过以下命令安装 stack
```
ghcup install stack
```

考虑到国内的网络环境问题，同样需要为stack换源（[中科大](https://mirrors.ustc.edu.cn/help/stackage.html)或[清华](https://mirrors.tuna.tsinghua.edu.cn/help/stackage/)）：

## 换源

为了让 stack 生成相应的文件夹，首先
```
stack --resolver lts setup
```
国内的网这一步一定是会失败的，之后

- MacOS 下打开编辑`~/.stack/config.yaml`
- Windows 下编辑`%APPDATA%/stack/config.yaml`（打开方式为在资源管理器的地址栏输入`%APPDATA%/stack` 回车后打开其中的 `config.yaml` 文件），在末尾加入以下内容

```
setup-info-locations:
   - http://mirrors.ustc.edu.cn/stackage/stack-setup.yaml
urls:
  latest-snapshot: http://mirrors.ustc.edu.cn/stackage/snapshots.json
snapshot-location-base: http://mirrors.ustc.edu.cn/stackage/stackage-snapshots/

package-indices:
- download-prefix: https://mirrors.ustc.edu.cn/hackage/
  hackage-security:
    keyids:
    - 0a5c7ea47cd1b15f01f5f51a33adda7e655bc0f0b0615baa8e271f4c3351e21d
    - 1ea9ba32c526d1cc91ab5e5bd364ec5e9e8cb67179a471872f6e26f0ae773d42
    - 280b10153a522681163658cb49f632cde3f38d768b736ddbc901d99a1a772833
    - 2a96b1889dc221c17296fcc2bb34b908ca9734376f0f361660200935916ef201
    - 2c6c3627bd6c982990239487f1abd02e08a02e6cf16edb105a8012d444d870c3
    - 51f0161b906011b52c6613376b1ae937670da69322113a246a09f807c62f6921
    - 772e9f4c7db33d251d5c6e357199c819e569d130857dc225549b40845ff0890d
    - aa315286e6ad281ad61182235533c41e806e5a787e0b6d1e7eef3f09d137d2e9
    - fe331502606802feac15e514d9b9ea83fee8b6ffef71335479a2e68d84adc6b0
    key-threshold: 3 # number of keys required

    # ignore expiration date, see https://github.com/commercialhaskell/stack/pull/4614
    ignore-expiry: true
```

而后下载[文件](https://mirrors.ustc.edu.cn/stackage/stackage-content/stack/global-hints.yaml)移动到
- macOS 下 `~/.stack/pantry` 文件夹
- Windows 下 `%APPDATA%\stack\pantry` 文件夹
并**重命名该文件**为`global-hints-cache.yaml`。

## 安装 resolver

输入命令
```
stack --resolver lts setup
```
会提示下载 GHC，下载后会在下载 7z.dll 时出错。方法是手动下载[7-Zip](https://www.7-zip.org/)（注：这是个人最推荐的解压软件），安装后打开其安装目录（安装时留意一下，默认是`C:\Program Files\7-Zip`），复制`7z.exe`和`7z.dll`至 `%LOCALAPPDATA%/Programs/stack/x86_64-windows`（正常情况下应该会有一个名为`ghc-9.0.2.tar.xz`的文件，如果没有说明ghc下载不成功），而后重新运行上面的命令，直至完全成功。

## 测试 stack

创建一个新项目（用项目名代替下文的`<project-name>`，如`homework`，不要有中文！路径也不要有！）
```
stack new <project-name>
```
进入该文件夹
```
cd <project-name>
```
然后编译项目
```
stack build
```
如果成功编译了，则可以通过吃鸡腿饭庆祝一下。如果出现`commitBuffer: invalid argument (invalid character)`，请将作业项目移至一个**没有中文**的路径。其他情况，请联系助教。

完成作业时首先需要添加`random`库，方法是在项目中的`package.yaml`文件中修改依赖：
```
dependencies:
- base >= 4.7 && < 5
- random
```
否则会找不到相关的函数。

*以上教程参考[在Windows上安装Haskell](https://zhuanlan.zhihu.com/p/259393917)，想了解为什么这样操作，可以阅读此文章。*
