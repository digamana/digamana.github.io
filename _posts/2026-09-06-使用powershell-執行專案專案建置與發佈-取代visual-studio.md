---
layout: post
title: '使用PowerShell 執行專案專案建置與發佈 取代Visual Studio '
date: 2026-09-06 12:30 +0800
---

# PS腳本範例CODE
```
# ====================== 多環境平行 Publish 腳本 (強化中文支援) ======================
# 主腳本編碼設定
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

#$projectPath = "C:\SVN_Release\trunk\trunk\APIServices\APIServices\APIServices.csproj"
$projectPath = Join-Path $PSScriptRoot "trunk\APIServices\APIServices\APIServices.csproj"

$environments = @(
    @{ Name = "Dev"; Config = "Dev"; OutputPath = "C:\SVN_Release\APIServices_Dev" }
    ,@{ Name = "Stage"; Config = "Stage"; OutputPath = "C:\SVN_Release\APIServices_Stage" }
)

# 確保資料夾存在，並記錄原本的最後修改時間
$folderOriginalTimes = @{}
foreach ($env in $environments) {
    if (-Not (Test-Path -Path $env.OutputPath)) {
        New-Item -ItemType Directory -Path $env.OutputPath -Force | Out-Null
    }
    $folderOriginalTimes[$env.OutputPath] = (Get-Item -Path $env.OutputPath).LastWriteTime
    Write-Host "已記錄 $($env.Name) 資料夾原始時間: $($folderOriginalTimes[$env.OutputPath])" -ForegroundColor DarkGray
}

function Invoke-PublishOnce {
    param(
        [string]$proj,
        [string]$config,
        [string]$outPath,
        [string]$name
    )

    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    chcp 65001 | Out-Null

    Write-Host "正在清理 $name 環境輸出目錄..." -ForegroundColor DarkYellow
    if (Test-Path -Path $outPath) {
        Get-ChildItem -Path $outPath -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "正在 Publish $name 環境..." -ForegroundColor Yellow
    $startTime = Get-Date
    dotnet publish $proj --configuration $config --output $outPath --verbosity minimal
    $duration = (Get-Date) - $startTime

    $fileCount = 0
    if (Test-Path -Path $outPath) {
        $fileCount = (Get-ChildItem -Path $outPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
    }

    $success = ($LASTEXITCODE -eq 0) -and ($fileCount -gt 0)

    return [PSCustomObject]@{
        Environment = $name
        Status      = if ($success) { "✅ 成功" } else { "❌ 失敗" }
        Duration    = "{0:mm\:ss}" -f $duration
        Path        = $outPath
        FileCount   = $fileCount
        ExitCode    = $LASTEXITCODE
        Success     = $success
    }
}

Write-Host "開始平行 Publish 多個環境..." -ForegroundColor Cyan
$jobs = @()

foreach ($env in $environments) {
    $job = Start-Job -ScriptBlock {
        param($proj, $config, $outPath, $name)

        $OutputEncoding = [System.Text.Encoding]::UTF8
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        chcp 65001 | Out-Null

        function Invoke-PublishOnce {
            param(
                [string]$proj,
                [string]$config,
                [string]$outPath,
                [string]$name
            )

            Write-Host "正在清理 $name 環境輸出目錄..." -ForegroundColor DarkYellow
            if (Test-Path -Path $outPath) {
                Get-ChildItem -Path $outPath -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }

            Write-Host "正在 Publish $name 環境..." -ForegroundColor Yellow
            $startTime = Get-Date
            dotnet publish $proj --configuration $config --output $outPath --verbosity minimal
            $duration = (Get-Date) - $startTime

            $fileCount = 0
            if (Test-Path -Path $outPath) {
                $fileCount = (Get-ChildItem -Path $outPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
            }

            $success = ($LASTEXITCODE -eq 0) -and ($fileCount -gt 0)

            return [PSCustomObject]@{
                Environment = $name
                Status      = if ($success) { "✅ 成功" } else { "❌ 失敗" }
                Duration    = "{0:mm\:ss}" -f $duration
                Path        = $outPath
                FileCount   = $fileCount
                ExitCode    = $LASTEXITCODE
                Success     = $success
            }
        }

        # 第一次發布
        $result = Invoke-PublishOnce -proj $proj -config $config -outPath $outPath -name $name

        # 若資料夾是空的，只再重試一次（避免遞迴）
        if (-not $result.Success -or $result.FileCount -eq 0) {
            Write-Host "[$name] 發布後資料夾為空或失敗，開始重試一次..." -ForegroundColor Magenta
            $result = Invoke-PublishOnce -proj $proj -config $config -outPath $outPath -name $name

            if ($result.Success) {
                $result.Status = "✅ 成功(重試後)"
            } else {
                $result.Status = "❌ 失敗(重試後仍失敗)"
            }
        }

        return $result
    } -ArgumentList $projectPath, $env.Config, $env.OutputPath, $env.Name

    $jobs += $job
}

Write-Host "等待所有 Publish 任務完成..." -ForegroundColor Gray
$jobs | Wait-Job | Out-Null
$results = $jobs | Receive-Job
$results | Format-Table -AutoSize -Property Environment, Status, Duration, FileCount, Path
$jobs | Remove-Job

# ========== 任務完成後檢查並還原空資料夾的最後修改時間 ==========
Write-Host "`n檢查發布結果並還原空資料夾時間..." -ForegroundColor Cyan
foreach ($env in $environments) {
    $outPath = $env.OutputPath
    if (Test-Path -Path $outPath) {
        $fileCount = (Get-ChildItem -Path $outPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
        if ($fileCount -eq 0) {
            if ($folderOriginalTimes.ContainsKey($outPath)) {
                $originalTime = $folderOriginalTimes[$outPath]
                (Get-Item -Path $outPath).LastWriteTime = $originalTime
                Write-Host "[$($env.Name)] 資料夾為空，已還原最後修改時間 → $originalTime" -ForegroundColor Yellow
            }
        } else {
            Write-Host "[$($env.Name)] 發布成功，共有 $fileCount 個檔案" -ForegroundColor Green
        }
    }
}

Write-Host "`n所有 Publish 任務已完成！" -ForegroundColor Green
```




# GIT版控

## Git切成特分支並Pull最新遠端分支的PS腳本範例

```
# ============================================
# 自動拉取最新 Source Code（安全衝突檢查版）
# ============================================

# 變數$ProjectPath路徑需要有 .git資料夾
$ProjectPath = "C:\GIT_Release\OSS2\APIServices"

if (-not (Test-Path $ProjectPath)) {
    Write-Host "錯誤：路徑不存在 → $ProjectPath" -ForegroundColor Red
    Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit 1
}

Set-Location $ProjectPath

# ----------------------------------------
# 1. 顯示目前所在分支
# ----------------------------------------
$currentBranch = git branch --show-current
Write-Host "專案路徑：$ProjectPath" -ForegroundColor Cyan
Write-Host "目前分支：$currentBranch" -ForegroundColor Cyan
Write-Host "----------------------------------------"

# ----------------------------------------
# 2. 詢問是否要切換分支
# ----------------------------------------
Write-Host "請輸入要切換的分支名稱（直接按 Enter 則維持目前分支）：" -ForegroundColor Yellow

### Dev Stage master
$targetBranch = 'Dev'  
#$targetBranch = 'Stage'  


# 3. 如果輸入空白 或 與目前分支相同 → 略過切換
if ([string]::IsNullOrWhiteSpace($targetBranch) -or $targetBranch -eq $currentBranch) {
    Write-Host "維持目前分支：$currentBranch" -ForegroundColor Green
}
else {
    Write-Host "正在切換到分支：$targetBranch ..." -ForegroundColor Yellow
    git switch $targetBranch 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ 切換分支失敗，請確認分支名稱是否正確" -ForegroundColor Red
        Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
        exit 1
    }

    Write-Host "✓ 已成功切換到分支：$(git branch --show-current)" -ForegroundColor Green
}

Write-Host "----------------------------------------"

# ----------------------------------------
# 以下是原本的安全拉取邏輯
# ----------------------------------------

# 1. 先 fetch，不改動本地檔案
Write-Host "正在取得遠端最新資訊 (git fetch)..." -ForegroundColor Yellow
git fetch --quiet

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ git fetch 失敗，請檢查網路或權限" -ForegroundColor Red
    Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit 1
}

# 2. 檢查是否已經是最新
$behindCount = git rev-list --count "HEAD..@{u}" 2>$null
if ($behindCount -eq 0) {
    Write-Host "✓ 本地已經是最新版本，無需更新" -ForegroundColor Green
    Write-Host "完成時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit 0
}

Write-Host "遠端有 $behindCount 個新的 commit 需要更新" -ForegroundColor Cyan

# 3. 檢查本地是否有未提交的變更
$localChanges = git status --porcelain

if ($localChanges) {
    Write-Host "`n目前有未提交的變更：" -ForegroundColor Yellow
    git status --short
    Write-Host ""

    # 使用 git merge-tree 預先檢查是否會產生衝突（不實際修改檔案）
    $mergeBase = git merge-base HEAD "@{u}"
    $conflictCheck = git merge-tree $mergeBase HEAD "@{u}" 2>&1

    if ($conflictCheck -match "changed in both") {
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "✗ 偵測到會產生衝突！已取消更新" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "原因：本地有修改的檔案與遠端新版本有衝突" -ForegroundColor Yellow
        Write-Host "建議：" -ForegroundColor Yellow
        Write-Host "  1. 先手動處理或暫存本地修改 (git stash)" -ForegroundColor Yellow
        Write-Host "  2. 再重新執行此腳本" -ForegroundColor Yellow
        Write-Host "  3. 或手動解決衝突後再更新" -ForegroundColor Yellow
        Write-Host "完成時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
        Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
        exit 1
    }
    else {
        Write-Host "本地有修改，但與遠端變更沒有衝突，可以安全更新" -ForegroundColor Green
    }
}

# 4. 沒有衝突風險，執行實際更新
Write-Host "`n正在執行 git pull..." -ForegroundColor Yellow
git pull

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ 最新 Source Code 已成功拉取！" -ForegroundColor Green
} else {
    Write-Host "`n✗ 拉取失敗，請檢查上方錯誤訊息" -ForegroundColor Red
    Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit 1
}


#####################################

Write-Host "完成時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
Start-Sleep -Seconds 5
```



## 建置時自動將 Git 分支與 Commit 資訊寫入 DLL
用途:這樣才可以在程式發佈到正式環境的時候 顯示發佈當下是什麼分支布板的
      且底下範例客製成 若Master分支有打Tag就優先顯示Tat資訊


請將以下範例將檔名取為Directory.Build.props 然後放在跟 副檔名為sln同個路徑底下
```
<Project>
  <!-- 關閉 SDK 自動附加 commit hash 的行為 -->
  <PropertyGroup>
    <IncludeSourceRevisionInInformationalVersion>false</IncludeSourceRevisionInInformationalVersion>
  </PropertyGroup>

  <Target Name="SetVersionFromGit" BeforeTargets="GenerateAssemblyInfo;GetAssemblyVersion">

    <!-- 1. 取得當前分支名稱 -->
    <Exec Command="git rev-parse --abbrev-ref HEAD" ConsoleToMSBuild="true" IgnoreExitCode="true">
      <Output TaskParameter="ConsoleOutput" PropertyName="BranchName" />
    </Exec>

    <!-- 2. 取得最新 commit 的時間 (yyyyMMddHHmm) -->
    <Exec Command="git show -s --format=%25%25cd --date=format:%25%25Y%25%25m%25%25d%25%25H%25%25M HEAD"
          ConsoleToMSBuild="true"
          IgnoreExitCode="true">
      <Output TaskParameter="ConsoleOutput" PropertyName="CommitTime" />
    </Exec>

    <!-- 3. 取得最新 commit 的雜湊前 6 碼 -->
    <Exec Command="git rev-parse --short=6 HEAD" ConsoleToMSBuild="true" IgnoreExitCode="true">
      <Output TaskParameter="ConsoleOutput" PropertyName="ShortHash" />
    </Exec>

    <!-- 4. 清理並組合版號 -->
    <PropertyGroup>
      <_BranchName>$([System.String]::Copy('$(BranchName)').Trim())</_BranchName>
      <_CommitTime>$([System.String]::Copy('$(CommitTime)').Trim())</_CommitTime>
      <_ShortHash>$([System.String]::Copy('$(ShortHash)').Trim())</_ShortHash>

      <GitVersion Condition="'$(_BranchName)' != '' And '$(_CommitTime)' != '' And '$(_ShortHash)' != '' And !$(_CommitTime.Contains('fatal'))">
        $(_BranchName).$(_CommitTime).$(_ShortHash)
      </GitVersion>

      <GitVersion Condition="'$(GitVersion)' == ''">$(_BranchName).unknown</GitVersion>
      <GitVersion>$([System.String]::Copy('$(GitVersion)').Trim())</GitVersion>

      <Version>$(GitVersion)</Version>
      <InformationalVersion>$(GitVersion)</InformationalVersion>
      <AssemblyVersion>0.0.0.0</AssemblyVersion>
      <FileVersion>0.0.0.0</FileVersion>
    </PropertyGroup>
  </Target>
</Project>
```


## 先Git做Pull最新，再發布到本地指定路徑的PS1
```
# ============================================
# 自動拉取最新 Source Code → 再 Publish（完整版）
# Git相對路徑：OSS2\APIServices
# 專案相對路徑：OSS2\APIServices\APIServices\APIServices.csproj
# ============================================

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

# ----------------------------------------
# 路徑（相對腳本所在目錄）
# ----------------------------------------
$scriptRoot   = $PSScriptRoot
$gitRoot      = Join-Path $scriptRoot "OSS2\APIServices"
$projectCsproj = Join-Path $scriptRoot "OSS2\APIServices\APIServices\APIServices.csproj"

# 要切換的分支（可改 Stage / master）
$targetBranch = "Dev"
# $targetBranch = "Stage"
# $targetBranch = "master"

$environments = @(
    @{ Name = "Dev"; Config = "Dev"; OutputPath = "C:\GIT_Release\APIServices_Dev" }
)

function Exit-WithPause {
    param([int]$Code = 1)
    Write-Host "`n視窗將在 5 秒後自動關閉..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit $Code
}

# ----------------------------------------
# 檢查路徑
# ----------------------------------------
if (-not (Test-Path $gitRoot)) {
    Write-Host "錯誤：Git 路徑不存在 → $gitRoot" -ForegroundColor Red
    Exit-WithPause
}
if (-not (Test-Path $projectCsproj)) {
    Write-Host "錯誤：csproj 不存在 → $projectCsproj" -ForegroundColor Red
    Exit-WithPause
}

Set-Location $gitRoot
Write-Host "Git 路徑：$gitRoot" -ForegroundColor Cyan
Write-Host "專案檔：$projectCsproj" -ForegroundColor Cyan
Write-Host "----------------------------------------"

# ----------------------------------------
# 1. 目前分支
# ----------------------------------------
$currentBranch = (git branch --show-current 2>$null)
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
    Write-Host "✗ 無法取得目前分支（可能不是 git 目錄或 detached HEAD）" -ForegroundColor Red
    git status
    Exit-WithPause
}
Write-Host "目前分支：$currentBranch" -ForegroundColor Cyan
Write-Host "目標分支：$targetBranch" -ForegroundColor Cyan
Write-Host "----------------------------------------"

# ----------------------------------------
# 2. 先 fetch，再切換分支
# ----------------------------------------
Write-Host "正在 git fetch..." -ForegroundColor Yellow
git fetch --all --prune
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ git fetch 失敗，請檢查網路或權限" -ForegroundColor Red
    Exit-WithPause
}

if ($currentBranch -eq $targetBranch) {
    Write-Host "✓ 已在目標分支：$targetBranch" -ForegroundColor Green
}
else {
    # 本地是否有未提交變更
    $localChanges = git status --porcelain
    if ($localChanges) {
        Write-Host "⚠ 目前有未提交的變更：" -ForegroundColor Yellow
        git status --short
        Write-Host "切換分支可能失敗或帶著變更過去，建議先 commit 或 stash" -ForegroundColor Yellow
    }

    Write-Host "正在切換到分支：$targetBranch ..." -ForegroundColor Yellow

    # 本地已有該分支
    $localExists = git show-ref --verify --quiet "refs/heads/$targetBranch"
    if ($LASTEXITCODE -eq 0) {
        git switch $targetBranch
    }
    else {
        # 遠端有 origin/目標分支 → 建立並追蹤
        $remoteExists = git show-ref --verify --quiet "refs/remotes/origin/$targetBranch"
        if ($LASTEXITCODE -eq 0) {
            git switch -c $targetBranch --track "origin/$targetBranch"
        }
        else {
            Write-Host "✗ 本地與遠端都找不到分支：$targetBranch" -ForegroundColor Red
            Write-Host "可用分支如下：" -ForegroundColor Yellow
            git branch -a
            Exit-WithPause
        }
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ 切換分支失敗" -ForegroundColor Red
        git status
        Exit-WithPause
    }

    $currentBranch = git branch --show-current
    Write-Host "✓ 已切換到分支：$currentBranch" -ForegroundColor Green
}
Write-Host "----------------------------------------"

# ----------------------------------------
# 3. 拉取最新
# ----------------------------------------
Write-Host "正在檢查是否需要更新..." -ForegroundColor Yellow

# 設定 upstream（若尚未設定）
git rev-parse --abbrev-ref "@{u}" 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "尚未設定 upstream，嘗試追蹤 origin/$currentBranch ..." -ForegroundColor Yellow
    git branch --set-upstream-to="origin/$currentBranch" $currentBranch 2>$null
}

$behindCount = git rev-list --count "HEAD..@{u}" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠ 無法比較遠端（可能沒有 upstream），改直接 git pull" -ForegroundColor Yellow
    git pull
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ git pull 失敗" -ForegroundColor Red
        Exit-WithPause
    }
}
elseif ([int]$behindCount -eq 0) {
    Write-Host "✓ 本地已是最新，無需 pull" -ForegroundColor Green
}
else {
    Write-Host "遠端有 $behindCount 個新 commit" -ForegroundColor Cyan

    $localChanges = git status --porcelain
    if ($localChanges) {
        Write-Host "目前有未提交變更：" -ForegroundColor Yellow
        git status --short
        $mergeBase = git merge-base HEAD "@{u}" 2>$null
        if ($LASTEXITCODE -eq 0) {
            $conflictCheck = git merge-tree $mergeBase HEAD "@{u}" 2>&1 | Out-String
            if ($conflictCheck -match "changed in both") {
                Write-Host "✗ 預估會衝突，已取消 pull。請先 stash/commit 後再執行" -ForegroundColor Red
                Exit-WithPause
            }
            Write-Host "預估無衝突，繼續 pull" -ForegroundColor Green
        }
    }

    Write-Host "正在 git pull..." -ForegroundColor Yellow
    git pull
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ git pull 失敗" -ForegroundColor Red
        Exit-WithPause
    }
    Write-Host "✓ pull 完成" -ForegroundColor Green
}

Write-Host "----------------------------------------"
Write-Host "Pull 完成，開始 Publish..." -ForegroundColor Cyan
Write-Host "----------------------------------------"

# ----------------------------------------
# 4. Publish
# ----------------------------------------
$folderOriginalTimes = @{}
foreach ($env in $environments) {
    if (-not (Test-Path $env.OutputPath)) {
        New-Item -ItemType Directory -Path $env.OutputPath -Force | Out-Null
    }
    $folderOriginalTimes[$env.OutputPath] = (Get-Item $env.OutputPath).LastWriteTime
}

$jobs = @()
foreach ($env in $environments) {
    $job = Start-Job -ScriptBlock {
        param($proj, $config, $outPath, $name)

        function Invoke-PublishOnce {
            param($proj, $config, $outPath, $name)
            if (Test-Path $outPath) {
                Get-ChildItem $outPath -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }
            $startTime = Get-Date
            dotnet publish $proj --configuration $config --output $outPath --verbosity minimal
            $exitCode = $LASTEXITCODE
            $duration = (Get-Date) - $startTime
            $fileCount = 0
            if (Test-Path $outPath) {
                $fileCount = @(Get-ChildItem $outPath -Recurse -File -ErrorAction SilentlyContinue).Count
            }
            $success = ($exitCode -eq 0) -and ($fileCount -gt 0)
            return [PSCustomObject]@{
                Environment = $name
                Status      = if ($success) { "成功" } else { "失敗" }
                Duration    = "{0:mm\:ss}" -f $duration
                Path        = $outPath
                FileCount   = $fileCount
                ExitCode    = $exitCode
                Success     = $success
            }
        }

        $result = Invoke-PublishOnce -proj $proj -config $config -outPath $outPath -name $name
        if (-not $result.Success) {
            $result = Invoke-PublishOnce -proj $proj -config $config -outPath $outPath -name $name
            $result.Status = if ($result.Success) { "成功(重試後)" } else { "失敗(重試後)" }
        }
        return $result
    } -ArgumentList $projectCsproj, $env.Config, $env.OutputPath, $env.Name

    $jobs += $job
}

Write-Host "等待 Publish 完成..." -ForegroundColor Gray
$jobs | Wait-Job | Out-Null
$results = $jobs | Receive-Job
$results | Format-Table -AutoSize Environment, Status, Duration, FileCount, Path
$jobs | Remove-Job

foreach ($env in $environments) {
    $outPath = $env.OutputPath
    if (Test-Path $outPath) {
        $fileCount = @(Get-ChildItem $outPath -Recurse -File -ErrorAction SilentlyContinue).Count
        if ($fileCount -eq 0 -and $folderOriginalTimes.ContainsKey($outPath)) {
            (Get-Item $outPath).LastWriteTime = $folderOriginalTimes[$outPath]
            Write-Host "[$($env.Name)] 輸出為空，已還原資料夾時間" -ForegroundColor Yellow
        }
        else {
            Write-Host "[$($env.Name)] 檔案數：$fileCount" -ForegroundColor Green
        }
    }
}

Write-Host "`n全部完成！$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Green
Exit-WithPause -Code 0
```
