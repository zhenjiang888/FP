---
layout: default
---

*黄金法则：如果你在任何一步看到了自己不认识的错误信息或不知道如何进行下一步，请随时联系助教！助教是你永远的朋友。*

# 说明：如何使用该文件？

你可以像往常一下在如下的 _ 处填写代码，就好像是在你的作业本上一样。如果你对自己有信心，那么可以直接提交此文件。

如果你想利用编译器对自己的代码进行检查，请**在正确路径下**打开 GHCi（如何打开 GHCi 请查看下方说明）。会给出如
下显示：
```
GHCi, version xxx: https://www.haskell.org/ghc/  :? for help
Prelude>
```

## 加载 hs 文件

输入 `:load HW2.hs` 并回车后显示则说明路径正确。
```
Prelude> :load HW2.hs
[1 of 1] Compiling HW2     (HW2.hs, interpreted)
```

> 若显示
> ```
> Prelude> :load HW2.hs
> 
> <no location info>: error: can't find file: HW2.hs
> Failed, no modules loaded.
> ```
> 则说明 ghci 打开路径存在问题，请查看**如何在正确路径下打开 GHCi**。

- 在加载成功后，若出现
  ```
  Prelude> :load HW2.hs 
  [1 of 1] Compiling HW2              ( HW2.hs, interpreted )

  HW2.hs:xx:x: error: xxxxxxxxx 
  ```
  说明代码编译错误。（注：模板中的 `_` 同样会导致编译错误，如果你对某个题没有思路，请将所有的 `_` 替换为 `undefined`）。
- 在加载成功后，若出现
  ```
  Prelude> :load HW2.hs 
  [1 of 1] Compiling HW2              ( HW2.hs, interpreted )
  Ok, one module loaded.
  *HW2>
  ```
  说明代码编译成功。

## 测试代码

输入你想测试的函数并回车，可以看到运算结果。你可以通过运行一些测试用例来检查自己的实现是否正确。例如
```
*HW2> and1 True True
True
```
类似地去测试其他用例和习题。

## 修改代码

在你修改代码后，保存，并输入 `:r` 可以重新加载该文件。
```
*HW2> :r
[1 of 1] Compiling HW2              ( HW2.hs, interpreted )
Ok, one module loaded.
```

## 退出 GHCi

在你完成所有作业后（或是 GHCi 出来你不理解的行为时），通过 `:q` 退出 GHCi。
```
*HW2> :q
Leaving GHCi.
```

# 如何在正确路径下打开 GHCi

## Windows 系统

### 1. 在正确的路径下打开 VSCode
   
  这里提供如下三种解决方案

  - 在保存该作业的**文件夹**下，右键“通过Code”打开。（Windows 11用户需要首先“显示更多选项”）
  - 打开VSCode，将保存该作业的**文件夹**拖拽至VSCode中。
  - 打开VSCode，File → Open Folder，选择保存该作业的**文件夹**。

   注意，如果打开后左侧文件目录显示的是文件夹的文件列表（称为*工作区*），说明操作正确。如果显示的是包含 `Open Folder` 在内的几个按钮，请**打开保存文件的文件夹**。

### 2. 打开 GHCi

  通过快捷键 Ctrl+\`（注意是Esc下方的按键），或是 View → Terminal 打开终端。终端中会显示你当前所在位置，如果和你保存作业文件的路径一致，说明是正确的。*不同命令行或不同配置可能导致显示方式不同。* 输入`ghci`回车打开 GHCi。例如，在我的电脑桌面下“HaskellHW”文件夹下打开后为：
  ```
  C:\Users\vbcpa\Desktop\HaskellHW>ghci
  GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
  Prelude>
  ```
