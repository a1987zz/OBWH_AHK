#Include classMemory.ahk

setbatchlines -1
Process, Wait, csgo.exe
csgo := new _ClassMemory("ahk_exe csgo.exe", "", hProcess)
if !IsObject(csgo)
{
if (hProcess = "")
msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
msgbox A_LastError %A_LastError%
ExitApp
}

base := csgo.getModuleBaseAddress("client.dll")

Pattern := [0x83, 0xF8, "??", 0x8B, 0x45, 0x08, 0x0F]

address := csgo.modulePatternScan("client.dll", Pattern*)
offsetwallhack := (address - base) + 2

F10::
t := !t

Data := t
Size := 1

VarSetCapacity(pBuffer, Size, 0)
NumPut(Data, pBuffer, "Uchar")

csgo.writeRaw(base + offsetwallhack, &pBuffer, Size)
return
