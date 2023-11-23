# Active Directory���W���[���̃C���|�[�g
Import-Module ActiveDirectory

# OU���ċA�I�Ɏ擾���ĊK�w�\���ŕ\�����A�e�L�X�g�t�@�C���ɏo�͂���֐�
function Show-OuTree {
    param (
        [string]$ParentDistinguishedName,
        [int]$Depth = 0,
        [string]$OutputFile
    )

    # OU���擾
    $ous = Get-ADOrganizationalUnit -Filter * -SearchBase $ParentDistinguishedName -SearchScope OneLevel

    foreach ($ou in $ous) {
        # �C���f���g��ǉ�����OU���𕶎����
        $indent = ' ' * ($Depth * 4)
        $line = "${counter}${indent}- $($ou.Name)"

        # �t�@�C���֏o��
        $line | Out-File -Append -FilePath $OutputFile

        # �qOU��\�����A�t�@�C���֏o��
        Show-OuTree -ParentDistinguishedName $ou.DistinguishedName -Depth ($Depth + 1) -OutputFile $OutputFile
    }
}

# �o�͂���t�@�C���̃p�X
$outputFilePath = "C:\AD-OU-Tree.txt"

# �t�@�C�������ɑ��݂���ꍇ�͍폜
if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath
}

# ���[�gOU����J�n����Tree�\�����t�@�C���ɏo��
Show-OuTree -ParentDistinguishedName "DC=kbr1009,DC=local" -OutputFile $outputFilePath