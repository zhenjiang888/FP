---
layout: default
---

*黄金法则：如果你在任何一步看到了自己不认识的错误信息或不知道如何进行下一步，请随时联系助教！助教是你永远的朋友。*

# 第 3 次作业使用指南

这次作业需要你安装一些外部包（package）。如你安装 Haskell 环境时所见，Haskell 有 Cabal 和 Stack 两个主要包管理器。本指南提供两个包管理器的换源方式以及基本使用方法，以及如何获知 `random` 包的文档。课上请大家使用 Stack 管理此项目，实际作业中使用任意一者均可。在作业提交上，你可以选择：
- 提交一个 Cabal 项目（压缩包）
- 提交一个 Stack 项目（压缩包）
- 提交单个源文件

仅有这次作业可能需要你创建一个 Cabal 或 Stack 项目，但是包管理器是绝大多数编程语言通用的概念，你可以在这里作出第一次尝试。之后的作业大体都可以在单个 `.hs` 文件中完成。编译一个不依赖外部包的 `.hs` 文件可参考[直接使用 GHC 编译](#ghc)部分。

## 目录

<!-- no toc -->
- [Cabal vs Stack](#history)
- [使用 Cabal](#cabal)
  - [Cabal 换源](#cabal-source)
  - [Cabal 项目设置](#cabal-project)
- [使用 Stack](#stack)
  - [Stack 换源](#stack-source)
  - [Stack 改用 GHCup 管理 GHC](#stack-ghc)
  - [Stack 项目配置](#stack-project)
- [获取 Hackage 上包的文档](#hackage)
- [直接使用 GHC 编译](#ghc)

## Cabal vs Stack {#history}

Cabal 是 Haskell 较早出现的包管理器。它定义了 Haskell 包的标准格式，并以 Hackage 作为公开发布包的平台。但其旧版本设计简陋，会造成项目依赖的包版本混乱（Cabal Hell），不能满足日渐复杂的软件工程需求。

Stack 为解决 Cabal 旧版本的问题而出现。Stack 在其 Stackage 平台上维护了一些快照，每个快照选取了 GHC 和每个包的一个版本，使得它们的版本之间相互兼容。Stack 工作在 Cabal 的基础之上，会自动生成 Cabal 包的配置文件。在 Cabal 存在旧版本问题的时代，Stack 是主流的选择。

当今 Cabal 的新版本已不存在旧版本的问题。相比于 Stack 工作在 Cabal 上的两层结构，直接配置 Cabal 相对简单，生成的额外文件更少，对新时代的初学者相对友好。

## 使用 Cabal {#cabal}

> Cabal 创建项目似乎要求已安装 Git 已安装。[Git](https://git-scm.com/downloads) 是一个常用的版本管理工具，可以考虑自行安装。也可以考虑先使用 Stack。

### Cabal 换源 {#cabal-source}

请确保你已经安装了 Cabal。在命令行运行 `cabal --version`，应当得到类似如下的结果：
```
$ cabal --version
cabal-install version 3.12.1.0
```

**换源：** 首先在命令行中输入 `cabal user-config init`，它会为你创建一个配置文件，并告诉你其所在路径。默认情况下，
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

保存后，在命令行中运行 `cabal update`，更新本地的包数据库。

### Cabal 项目设置 {#cabal-project}

使用 `cabal init guess` 在当前文件夹的 `guess` 子文件夹下建立一个名为 guess 的项目。（可以将 `guess` 修改为任意你想要的项目名称。）Cabal 会提出一系列项目设置的问题，如果不想深究，可以全部回车使用默认设置。
```
$ cabal init guess
What does the package build:
   1) Library
 * 2) Executable
   3) Library and Executable
   4) Test suite
Your choice? [default: Executable]
...
```

回答完全部问题后，`guess` 子文件夹下会包含这样一些文件：
```
.
├── CHANGELOG.md
├── LICENSE
├── guess.cabal
└── app
  └── Main.hs
```
其中，`guess.cabal` 是我们的包的描述文件，`app/Main.hs` 是程序主文件。`CHANGELOG.md` 和 `LICENSE` 分别声明项目版本变更情况和版权信息，这两个文件与编译无关。

为了安装 Hackage 上的包，以 `random` 为例，在 `guess.cabal` 中找到 `executable guess` 下如下的部分：
```yaml
    -- Other library packages from which modules are imported.
    build-depends:    base ^>=4.21.0.0
```
这个设置项决定了我们的程序会依赖哪些包，默认依赖标准库 `base`。GHC 的版本与 `base` 的版本相关，你的 `guess.cabal` 中对 `base` 的版本要求可能不完全一样，使用自动给出的版本即可。我们将这部分改为：
```yaml
    -- Other library packages from which modules are imported.
    build-depends:
      base ^>=4.21.0.0,
      random
```
这就向 Cabal 声明了对 `random` 的依赖（不限版本）。

接下来，你需要修改 `Main.hs`，完成作业。完成后，**在 guess 文件夹下**输入 `cabal build` 编译你的程序，会产生类似如下的输出（不包含报错）：
```
$ cabal build
Resolving dependencies...
Build profile: -w ghc-9.12.2 -O1
In order, the following will be built (use -v for more details):
 - guess-0.1.0.0 (exe:guess) (first run)
Configuring executable 'guess' for guess-0.1.0.0...
Preprocessing executable 'guess' for guess-0.1.0.0...
Building executable 'guess' for guess-0.1.0.0...
[1 of 1] Compiling Main             ( app\Main.hs, dist-newstyle\build\x86_64-windows\ghc-9.12.2\guess-0.1.0.0\x\guess\build\guess\guess-tmp\Main.o )
[2 of 2] Linking dist-newstyle\build\x86_64-windows\ghc-9.12.2\guess-0.1.0.0\x\guess\build\guess\guess.exe
```
如果编译无误，使用 `cabal run` 运行：
```
$ cabal run
...
```
当然，你也可以使用 `cabal run` 一步编译运行。

可以注意到，Cabal 将编译结果放在 `guess/dist-newstyle` 下。为了减轻网络负担，在力所能及的情况下，提交作业时可以考虑不打包这个文件夹。

## 使用 Stack {#use-stack}

### Stack 换源 {#stack-source}

请确保你已经安装了 Stack。在命令行运行 `stack --version`，应当得到类似如下的结果：
```
$ stack --version
Version 3.3.1, Git revision 62d1bdf099c8c30634208f76cb4444f9896e4336 x86_64 hpack-0.37.0
```
注意：下面部分**要求你的 Stack 版本至少是 3.1.1**。如果你按照[往年的教程](https://higher-order.fun/cn/2023/08/27/InstallHaskell.html)换源安装了较早版本，请将 `C:\ghcup\config.yaml` 或 `~/.ghcup/config.yaml` 如下部分中的 `0.0.7` 改为 `latest`，然后再安装 GHC、Stack、Cabal、HLS 最新的 Recommended 版本。
```
url-source:
  OwnSource: https://mirrors.ustc.edu.cn/ghcup/ghcup-metadata/ghcup-0.0.7.yaml
```

确保 Stack 版本合适后，编辑下述文件：
- macOS 下的 `~/.stack/config.yaml`
- Windows 下的 `%APPDATA%\stack\config.yaml`
  - 打开方式为在资源管理器的地址栏输入 `%APPDATA%\stack` 回车后打开其中的 `config.yaml` 文件
  - 或者，`%APPDATA%` 通常指代 `C:\Users\<你的用户名>\AppData\Roaming`

> 如果该文件不存在，可以考虑尝试运行 Stack 来初始化这个文件，例如：
> ```
> $ stack path --global-config
> C:\Users\<你的用户名>\AppData\Roaming\stack\config.yaml
> ```

在末尾加入以下内容：
```yaml
setup-info-locations:
  - http://mirrors.ustc.edu.cn/stackage/stack-setup.yaml
urls:
  latest-snapshot: http://mirrors.ustc.edu.cn/stackage/snapshots.json
snapshot-location-base: http://mirrors.ustc.edu.cn/stackage/stackage-snapshots/
global-hints-location:
  url: https://mirrors.ustc.edu.cn/stackage/stackage-content/stack/global-hints.yaml

package-index:
  download-prefix: https://mirrors.ustc.edu.cn/hackage/
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

### Stack 改用 GHCup 管理 GHC {#stack-ghc}

Stack 会维护各包和 GHC 之间的版本兼容性，因此它自带了 GHC 版本管理的功能。GHCup 出现后，后者方便了 Haskell 各组件安装，我们可以让 Stack 改用我们已安装的 GHCup 来管理 GHC 的版本，而避免在自己的系统上出现两套互不干涉的 GHC。

在如下位置创建一个新文件（可能需要自己创建其中的 `hooks` 文件夹）：
- macOS 下的 `~/.stack/hooks/ghc-install.sh`
- Windows 下的 `%APPDATA%\stack\hooks\ghc-install.sh`

写入如下内容（即[此文件](https://raw.githubusercontent.com/haskell/ghcup-hs/master/scripts/hooks/stack/ghc-install.sh)的内容）：
```sh
#!/bin/sh

# !! KEEP THIS SCRIPT POSIX COMPLIANT !!

# see https://docs.haskellstack.org/en/stable/configure/customisation_scripts/#ghc-installation-customisation
# for documentation about hooks

set -eu

case $HOOK_GHC_TYPE in
    bindist)
        ghc_path=$(ghcup whereis ghc "$HOOK_GHC_VERSION" || { ghcup install ghc "$HOOK_GHC_VERSION" >/dev/null && ghcup whereis ghc "$HOOK_GHC_VERSION" ; }) || { >&2 echo "Installing $HOOK_GHC_VERSION via ghcup failed" ; exit 3 ;}
        printf "%s" "${ghc_path}"
        ;;
    git)
        # TODO: should be somewhat possible
        >&2 echo "Hook doesn't support installing from source"
        exit 1
        ;;
    *)
        >&2 echo "Unsupported GHC installation type: $HOOK_GHC_TYPE"
        exit 2
        ;;
esac
```

对于 macOS，还需要将此文件设置为可执行。可在命令行输入如下命令：（Windows 无需此步）
```
chmod +x ~/.stack/hooks/ghc-install.sh
```

### Stack 项目配置 {#stack-project}

使用 `stack new guess` 在当前文件夹的 `guess` 子文件夹下建立一个名为 guess 的项目。（可以将 `guess` 修改为任意你想要的项目名称。）
```
$ stack new guess
Downloading template new-template to create project guess in directory guess/...
...
```

完成后，`guess` 子文件夹下会包含这样一些文件：
```
.
├── CHANGELOG.md
├── LICENSE
├── README.md
├── Setup.hs
├── app
│ └── Main.hs
├── guess.cabal
├── package.yaml
├── src
│ └── Lib.hs
├── stack.yaml
├── stack.yaml.lock
└── test
  └── Spec.hs
```
其中，`package.yaml` 是我们的包的描述文件。`app/Main.hs` 是程序主文件。我们主要只关心这两个文件。对其余文件：
- `src/Lib.hs` 和 `test/Spec.hs` 分别是我们的包作为库的主文件和测试的主文件
- `guess.cabal` 是 Stack 自动生成的 Cabal 配置文件
- `stack.yaml` 是项目中 Stack 的其余配置
- `stack.yaml.lock` 是锁文件，对 Stack 构建此包依赖的资源版本作出固定
- `CHANGELOG.md`、`LICENSE` 分别声明项目版本变更情况和版权信息，`README.md` 向包的用户给出包的简要说明，这三个文件与编译无关

为了安装外部包，以 `random` 为例，在 `project.yaml` 中找到如下部分：
```yaml
dependencies:
- base >= 4.7 && < 5
```
这个设置项决定了我们的程序会依赖哪些包，默认依赖标准库 base。Stack 快照的版本与 `base` 的版本相关，你的 `package.yaml` 中对 `base` 的版本要求可能不完全一样，使用自动给出的版本即可。我们将这部分改为：
```yaml
dependencies:
- base >= 4.7 && < 5
- random
```
这就向 Stack 声明了对 `random` 的依赖（不限版本）。

接下来，你需要修改 `Main.hs`，完成作业。完成后，**在 guess 文件夹下**输入 `stack build` 编译你的程序，会产生类似如下的输出（不包含报错）：
- 注意：如果你没有安装 Stack 默认快照对应的 GHC 版本（相当可能），Stack 会先自行安装 GHC，这可能要花一段时间，安装完成后会自动编译你的程序。如果你按照上面的步骤配置 Stack 使用 GHCup 管理 GHC，Stack 安装的 GHC 之后将能在 GHCup 中观察到。

```
$ stack build
guess-0.1.0.0: unregistering (local file changes: CHANGELOG.md README.md app\Main.hs guess.cabal package.yaml
src\Lib.hs)
guess> configure (lib + exe)
Configuring guess-0.1.0.0...
guess> build (lib + exe) with ghc-9.10.2
Preprocessing library for guess-0.1.0.0...
Building library for guess-0.1.0.0...
[1 of 2] Compiling Lib
[2 of 2] Compiling Paths_guess
Preprocessing executable 'guess-exe' for guess-0.1.0.0...
Building executable 'guess-exe' for guess-0.1.0.0...
[1 of 2] Compiling Main
[2 of 2] Compiling Paths_guess
[3 of 3] Linking .stack-work\\dist\\56bb250d\\build\\guess-exe\\guess-exe.exe
guess> copy/register
Installing library in ...\guess\.stack-work\install\f4b56854\lib\x86_64-windows-ghc-9.10.2-cea6\guess-0.1.0.0-K8BQNxavfpLFdprvmYKD9l
Installing executable guess-exe in ...\guess\.stack-work\install\f4b56854\bin
Registering library for guess-0.1.0.0...
```
如果编译无误，使用 `stack run` 运行：
```
$ stack run
...
```
当然，你也可以使用 `stack run` 一步编译运行。

可以注意到，Stack 将编译结果放在 `guess/.stack-work` 下。为了减轻网络负担，在力所能及的情况下，提交作业时可以考虑不打包这个文件夹。

## 获取 Hackage 上包的文档 {#hackage}

注意：深入了解 `random` 包不是这次作业的重点。这个包的设计方式涉及很多如何用纯函数式语言表达副作用的知识，在学完本课程 Haskell 部分后它的部分设计可能才会对你来说更能理解。

[Hoogle（hoogle.haskell.org）](https://hoogle.haskell.org) 是一个 Haskell 包内容的搜索引擎。你可以在搜索框中输入包名、模块名、函数名或类型（包括具体类型，如 `a -> a -> a`）来搜索相关内容。

在 Hoogle 中搜索 `random`，第一个结果应是 `package random`，表示是 `random` 包。点击访问后，你会到达 [`random` 在 Hackage 上的页面](https://hackage.haskell.org/package/random)。这里，你通常能读到一个包粗略的介绍。

如果想要了解各模块具体信息，滚动到下方 Modules 处。这里，我们可能希望点击访问 `System.Random` 模块对应的页面，了解该模块的更详细介绍以及提供的所有定义。这页很长，你可以妥善使用浏览器的搜索功能寻找你想了解的函数。（或者直接在 Hoogle 中搜索函数名！）

提示：此次作业，你可能想使用 `System.Random.randomIO` 旁边的一个函数。其他实现方法当然也欢迎。

## 直接使用 GHC 编译 {#ghc}

之前的作业的文档教过你如何使用 GHCi 加载你的程序中的定义。如果你希望将带 `main` 的程序编译为可执行文件（如 Windows 下的 `.exe`）而又不想创建 Cabal 或者 Stack 项目，可以参考此部分。

首先，请保证**正确路径下**有你想要编译的文件。*如果你不知道什么是正确的路径，请参考上一次作业的帮助文档。*假如你想要编译 `HWn.hs`，且你的命令行已经和该文件在同一路径下，使用如下命令编译程序：
```
$ ghc HWn.hs
Loaded package environment from ...
[1 of 1] Compiling Main             ( HWn.hs, HWn.o )
Linking HWn.exe ...
```
如果没有错误，当前路径下会出现 `HWn.exe`（Windows）或 `HWn`（macOS）。你可以通过如下的方式执行该程序：
- Windows: `.\HWn.exe`
- macOS: `./HWn`

## 使用 Cabal 全局安装（不可取）

这个方法会将包全局安装，能够让你的 `ghc` 命令直接看到你要安装的 `random`，而不需要使用 `cabal build` 或 `stack build` 进行编译。使用这个方法仅可以省去创建一个文件夹，但其副作用不方便复原。在执行过程中 Cabal 会主动提示这样做的害处。**你不应该使用这个方法。**

首先，若有需要，参照上面给出的步骤[为 Cabal 换源](#cabal-source)。然后，运行 `cabal install --lib random` 来安装 random 包。会有类似于如下的输出：
```
$ cabal install --lib random
Resolving dependencies...
Build profile: -w ghc-9.2.8 -O1
In order, the following will be built (use -v for more details):
 - splitmix-0.1.0.4 (lib) (requires download & build)
 - random-1.2.1.1 (lib) (requires download & build)
Downloading  splitmix-0.1.0.4
Downloaded   splitmix-0.1.0.4
...
```

接下来，你就可以用[直接使用 GHC 编译](#ghc)处的方法直接调用 `ghc` 编译你的使用 `random` 包中的模块的 `.hs` 文件了。
