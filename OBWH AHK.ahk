#NoEnv
F10::
t := !t

Data := t
Size = 1

VarSetCapacity(Buf, Size, 0)
NumPut(Data, Buf, "UInt")

PROCESS_VM_WRITE = 0x20
PROCESS_VM_OPERATION = 0x8

Process, Exist, csgo.exe

If(!ErrorLevel) {
  MsgBox, Process not found.
}

PID := ErrorLevel

base := GetDllBase("client.dll", ErrorLevel)
Address := base + 1877480

hProcess := DllCall("OpenProcess", "UInt", PROCESS_VM_WRITE | PROCESS_VM_OPERATION
                                 , "Int",  False
                                 , "UInt", PID)
If(!hProcess) {
   MsgBox, Failed to open process.
}

Ret := DllCall("WriteProcessMemory", "UInt", hProcess
                                   , "UInt", Address
                                   , "UInt", &Buf
                                   , "UInt", Size
                                   , "UInt", 0)

DllCall("CloseHandle", "UInt", hProcess)

If(!Ret) {
  MsgBox, Failed to write.
}
return


GetDllBase(DllName, PID = 0)
{
   TH32CS_SNAPMODULE := 0x00000008
    INVALID_HANDLE_VALUE = -1
    VarSetCapacity(me32, 548, 0)
    NumPut(548, me32, "Uint")
    snapMod := DllCall("CreateToolhelp32Snapshot", "Uint", TH32CS_SNAPMODULE
                                                 , "Uint", PID)
    If (snapMod = INVALID_HANDLE_VALUE) {
        Return 0
    }
    If (DllCall("Module32First", "Uint", snapMod, "Uint", &me32)){
        while(DllCall("Module32Next", "Uint", snapMod, "UInt", &me32)) {
            If !DllCall("lstrcmpi", "Str", DllName, "UInt", &me32 + 32) {
                DllCall("CloseHandle", "UInt", snapMod)
                Return NumGet(&me32 + 20)
            }
        }
    }
    DllCall("CloseHandle", "Uint", snapMod)
    Return 0
}