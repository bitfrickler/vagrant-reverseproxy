#AutoIt3Wrapper_Change2CUI=y

if $cmdline[0] = 0 then
    ConsoleWrite(@CRLF & "Usage: run.exe <command> <parameters>" & @CRLF)
    Exit
EndIf

Local $command = $cmdline[1]
Local $parameters = $cmdline[2]
Local $iPID = ShellExecute($command, $parameters, "", "", @SW_MINIMIZE)