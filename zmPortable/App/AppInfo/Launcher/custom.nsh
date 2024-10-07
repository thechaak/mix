Var strCustomComputerName
Var strCustomLastComputerName
Var bolCustomFirstRunDone

${SegmentFile}

${Segment.OnInit}
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("DESKTOP", "$DESKTOP").r0'
	${registry::Read} "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName" $strCustomComputerName $0
!macroend

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\${AppID}Settings.ini" "FirstRun" "Done"
	${If} $0 != true
		ClearErrors
		MessageBox MB_ICONINFORMATION|MB_OK "Welcome to zmPortable! If Zoom prompts for an updated version, please cancel and update automatically via the PortableApps.com Platform or manually with the zmPortable installer. Zoom will store settings and logins on a per-PC basis. If you move between PCs, zmPortable will remember these for each PC and automatically use the correct one."
		StrCpy $bolCustomFirstRunDone true
	${EndIf}
	Delete "$EXEDIR\Data\Zoom.lnk"
	ReadINIStr $strCustomLastComputerName "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "LastComputerName"
	${If} $strCustomLastComputerName != $strCustomComputerName
		${If} ${FileExists} "$EXEDIR\Data\Roaming"
			RMDir /r "$EXEDIR\Data\Roaming-$strCustomLastComputerName"
			Rename "$EXEDIR\Data\Roaming" "$EXEDIR\Data\Roaming-$strCustomLastComputerName"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\Roaming-$strCustomComputerName"
			Rename "$EXEDIR\Data\Roaming-$strCustomComputerName" "$EXEDIR\Data\Roaming"
		${Else}
			CreateDirectory "$EXEDIR\Data\Roaming"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\Local"
			RMDir /r "$EXEDIR\Data\Local-$strCustomLastComputerName"
			Rename "$EXEDIR\Data\Local" "$EXEDIR\Data\Local-$strCustomLastComputerName"
			${If} ${FileExists} "$EXEDIR\Data\Local-$strCustomLastComputerName\plugin\webview2_x86\*.*"
				RMDir /r "$EXEDIR\Data\webview2_x86"
				Rename "$EXEDIR\Data\Local-$strCustomLastComputerName\plugin\webview2_x86" "$EXEDIR\Data\webview2_x86"
			${EndIf}
			${If} ${FileExists} "$EXEDIR\Data\Local-$strCustomLastComputerName\plugin\webview2_x64\*.*"
				RMDir /r "$EXEDIR\Data\webview2_x64"
				Rename "$EXEDIR\Data\Local-$strCustomLastComputerName\plugin\webview2_x64" "$EXEDIR\Data\webview2_x64"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\Local-$strCustomComputerName"
			Rename "$EXEDIR\Data\Local-$strCustomComputerName" "$EXEDIR\Data\Local"
		${Else}
			CreateDirectory "$EXEDIR\Data\Local"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\Roaming-$strCustomLastComputerName\data\Emojis\*.*"
			RMDir /r "$EXEDIR\Data\Roaming\data\Emojis"
			CreateDirectory "$EXEDIR\Data\Roaming"
			CreateDirectory "$EXEDIR\Data\Roaming\data"
			Rename "$EXEDIR\Data\Roaming-$strCustomLastComputerName\data\Emojis" "$EXEDIR\Data\Roaming\data\Emojis"
			Rename "$EXEDIR\Data\Roaming-$strCustomLastComputerName\data\emoji.json" "$EXEDIR\Data\Roaming\data\emoji.json"
			Rename "$EXEDIR\Data\Roaming-$strCustomLastComputerName\data\emoji.version" "$EXEDIR\Data\Roaming\data\emoji.version"
			Rename "$EXEDIR\Data\Roaming-$strCustomLastComputerName\data\emoji-categories.json" "$EXEDIR\Data\Roaming\data\emoji-categories.json"
		${EndIf}
		
		ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
		
		${If} $0 < 10000
			;Windows 7/8/8.1
			${If} $Bits = 64
				${If} ${FileExists} "$EXEDIR\Data\webview2_x64\*.*"
					CreateDirectory "$EXEDIR\Data\Local"
					CreateDirectory "$EXEDIR\Data\Local\plugin"
					RMDir /r "$EXEDIR\Data\Local\plugin\webview2_x64"
					Rename "$EXEDIR\Data\webview2_x64" "$EXEDIR\Data\Local\plugin\webview2_x64"
				${EndIf}
			${Else}
				${If} ${FileExists} "$EXEDIR\Data\webview2_x86\*.*"
					CreateDirectory "$EXEDIR\Data\Local"
					CreateDirectory "$EXEDIR\Data\Local\plugin"
					RMDir /r "$EXEDIR\Data\Local\plugin\webview2_x86"
					Rename "$EXEDIR\Data\webview2_x86" "$EXEDIR\Data\Local\plugin\webview2_x86"
				${EndIf}
			${EndIf}
		${EndIf}
	${EndIf}
	WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "LastComputerName" $strCustomComputerName
!macroend

${SegmentPost}
	${If} $bolCustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "FirstRun" "Done" "true"
	${EndIf}
!macroend
