' ================================================================================================== 
' ================================================================================================== 
' "System Uptime", by Harold "Waldo" Grunenwald (waldo@ge.com, harold.grunenwald@gmail.com) 
' Gives a target system's uptime 
' Version 1.01 
' Changes: Initial Values for Days, Hours, and Minutes.  Changed spacing. 
' Level of Fun Writing This:  High 
' ================================================================================================== 
' Usage:  Run script from the command line with a servername as an argument.  If no argument is 
'            provided, script assumes localhost. 
'    "cscript system_uptime.vbs servername" 
' 
' some code from http://www.microsoft.com/technet/scriptcenter/resources/qanda/aug05/hey0802.mspx 
' ================================================================================================== 
' ================================================================================================== 
 
 
' Inital Values 
uptimeDays    = 0 
uptimeHrs    = 0 
uptimeMin    = 0 
 
 
' ===Establish target machine(s)=== 
If Wscript.Arguments.Count = 0 Then 
    Wscript.Echo vbCrLf & "No argument provided.  Running against localhost" 
    strComputer = "localhost" 
Else strComputer = WScript.Arguments(0) 
End If 
 
fnUptime(strComputer) 
 
 
' ===Really the only way to get the uptime=== 
Function fnUptime(strComputer) 
    Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2") 
    Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem") 
    For Each objOS in colOperatingSystems 
        dtmBootup = objOS.LastBootUpTime 
        dtmLastBootupTime = WMIDateStringToDate(dtmBootup) 
        dtmSystemUptime = DateDiff("n", dtmLastBootUpTime, Now)        'uptime in minutes 
    Next 
     
    timeConversion(dtmSystemUptime)        'convert to days, hours, & minutes 
End Function 
 
 
' ===Convert the WMI date string to Minutes=== 
' Microsoft date cleanup code, bless 'em for doing it 
 
' TODO: 
' Fix this function on Win2k machines 
' Type Coercion (on CDate) 
' http://www.microsoft.com/technet/scriptcenter/guide/sas_vbs_eves.mspx?mfr=true 
Function WMIDateStringToDate(dtmBootup) 
    WMIDateStringToDate = CDate(Mid(dtmBootup, 5, 2) & "/" & _ 
        Mid(dtmBootup, 7, 2) & "/" & Left(dtmBootup, 4) _ 
            & " " & Mid (dtmBootup, 9, 2) & ":" & _ 
                Mid(dtmBootup, 11, 2) & ":" & Mid(dtmBootup,13, 2)) 
End Function 
 
 
' ===Convert the time in Minutes to Days, Hours, & Minutes=== 
Function timeConversion(dtmSystemUptime) 
' Set some variables 
    uptimeMin = dtmSystemUptime 
 
' Convert to hours 
    if uptimeMin >= 60 then 
        uptimeHrs = Int(uptimeMin / 60)    'convert to integer 
        uptimeMin = (uptimeMin mod 60)        'final value for minutes 
    end if 
 
' Convert to Days 
    if uptimeHrs >= 24 then 
        uptimeDays = Int(uptimeHrs / 24)    'convert to integer 
        uptimeHrs = (uptimeHrs mod 24)        'final value for hours 
    end if 
 
 
' ===Output=== 
    wscript.echo 
    wscript.echo strComputer & " has been up for " & dtmSystemUptime & " minutes, which comes out to:" 
    wscript.echo uptimeDays & " Days" 
    wscript.echo uptimeHrs & " Hours" 
    wscript.echo uptimeMin & " Minutes" & vbCrLf 
End Function
