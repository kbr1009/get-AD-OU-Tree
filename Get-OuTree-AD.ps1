# Active Directoryモジュールのインポート
Import-Module ActiveDirectory

# OUを再帰的に取得して階層構造で表示し、テキストファイルに出力する関数
function Show-OuTree {
    param (
        [string]$ParentDistinguishedName,
        [int]$Depth = 0,
        [string]$OutputFile
    )

    # OUを取得
    $ous = Get-ADOrganizationalUnit -Filter * -SearchBase $ParentDistinguishedName -SearchScope OneLevel

    foreach ($ou in $ous) {
        # インデントを追加してOU名を文字列に
        $indent = ' ' * ($Depth * 4)
        $line = "${counter}${indent}- $($ou.Name)"

        # ファイルへ出力
        $line | Out-File -Append -FilePath $OutputFile

        # 子OUを表示し、ファイルへ出力
        Show-OuTree -ParentDistinguishedName $ou.DistinguishedName -Depth ($Depth + 1) -OutputFile $OutputFile
    }
}

# 出力するファイルのパス
$outputFilePath = "C:\AD-OU-Tree.txt"

# ファイルが既に存在する場合は削除
if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath
}

# ルートOUから開始してTree構造をファイルに出力
Show-OuTree -ParentDistinguishedName "DC=kbr1009,DC=local" -OutputFile $outputFilePath