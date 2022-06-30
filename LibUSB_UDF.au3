; #INDEX# =======================================================================================================================
; Title .........: LIBUSB UDF v1.0
; AutoIt Version : 3.3
; Language ......: English , Arabic
; Description ...: Improved USB library for AutoIt.
; Author(s) .....: Rabi3 Feggaa
; GitHub ........: https://github.com/R3Pro/AutoItUSB
; License .......: LGPL-2.1 License
;
; <https://github.com/libusb/libusb>
; ===============================================================================================================================
;~ #RequireAdmins
;~ $System32 = @WindowsDir&'/System32'

;~ MsgBox(0,FileExists('C:\Windows\System32\drivers\UsbDk.sys'),@WindowsDir)
#include "AutoItObject.au3"
#include "LibUSB_Constanst.au3"
FileInstall('msys-usb-1.0_32.dll',@ScriptDir&'/msys-usb-1.0_32.dll',1)
_AutoItObject_StartUp()
Global $hHandle = DllCallbackRegister("_Log_CallBack", "int", "Ptr;int;ptr")
#Region Global
	$LIBUSB_REQUEST_TYPE_STANDARD = 0
	$LIBUSB_REQUEST_TYPE_CLASS = 32
	$LIBUSB_REQUEST_TYPE_VENDOR = 64
	$LIBUSB_REQUEST_TYPE_RESERVED = 92
#EndRegion

Func USB($hContext = 0,$AutoInit = False)
    Local $oObj = _AutoItObject_Create()
	_AutoItObject_AddMethod($oObj, "Init", libusb_init)
;~ 	_AutoItObject_AddMethod($oObj, "Exit", libusb_exit)
	_AutoItObject_AddMethod($oObj, "Get_Version", libusb_get_version)
	_AutoItObject_AddMethod($oObj, "Set_Option", libusb_set_option)
	_AutoItObject_AddMethod($oObj, "Set_Debug", libusb_set_debug)
	_AutoItObject_AddMethod($oObj, "Set_Log_Cb", libusb_set_log_cb)
	_AutoItObject_AddMethod($oObj, "Get_Device_List", libusb_get_device_list)
	_AutoItObject_AddMethod($oObj, "Free_Device_List", libusb_free_device_list)
	_AutoItObject_AddMethod($oObj, "Open", libusb_open)
	_AutoItObject_AddMethod($oObj, "Open_By_Ids", libusb_open_device_with_vid_pid)
	_AutoItObject_AddMethod($oObj, "Find_VID_PID", libusb_find_device_by_ids)
	_AutoItObject_AddMethod($oObj, "Get_Device_Descriptor", libusb_get_device_descriptor)
	_AutoItObject_AddMethod($oObj, "Get_Active_Config_Descriptor", libusb_get_active_config_descriptor)
	_AutoItObject_AddMethod($oObj, "Get_Config_Descriptor", libusb_get_config_descriptor)
	_AutoItObject_AddMethod($oObj, "Get_Config_Descriptor_By_Value", libusb_get_config_descriptor_by_value)


	_AutoItObject_AddMethod($oObj, "Get_Bus_Number", libusb_get_bus_number)
	_AutoItObject_AddMethod($oObj, "Get_Port_Number", libusb_get_port_number)
	_AutoItObject_AddMethod($oObj, "Get_Device_Address", libusb_get_device_address)
	_AutoItObject_AddMethod($oObj, "Get_Device_Speed", libusb_get_device_speed)
	_AutoItObject_AddMethod($oObj, "Get_parent", libusb_get_parent)
	_AutoItObject_AddMethod($oObj, "Get_max_packet_size", libusb_get_max_packet_size)
	_AutoItObject_AddMethod($oObj, "Get_max_iso_packet_size", libusb_get_max_iso_packet_size)

	_AutoItObject_AddMethod($oObj, "Find_By_Array", __USB_Find_By_Array)
;~ 	_AutoItObject_AddDestructor($oObj, "_Dongle_Destructor")
        _AutoItObject_AddProperty($oObj, "DllSrc", $ELSCOPE_PRIVATE,@AutoItX64 ? "msys-usb-1.0_64.dll" : "msys-usb-1.0_32.dll")
	_AutoItObject_AddProperty($oObj, "DLL",$ELSCOPE_PRIVATE)
	_AutoItObject_AddProperty($oObj, "Context",$ELSCOPE_PRIVATE,$hContext)
	_AutoItObject_AddProperty($oObj, "device_descriptorTag",$ELSCOPE_PRIVATE,$_libusb_device_descriptorTag)
	_AutoItObject_AddProperty($oObj, "config_descriptorTag",$ELSCOPE_PRIVATE,$_libusb_config_descriptorTag)
	_AutoItObject_AddProperty($oObj, "Device",$ELSCOPE_PUBLIC,0)
	If $AutoInit Then $oObj.Init()
    Return $oObj
EndFunc   ;==>_DongleObject

Func DeviceObject($hDll,$dev_handle)
		Local $oObj = _AutoItObject_Create()
		_AutoItObject_AddMethod($oObj, "Close", libusb_close)
		_AutoItObject_AddMethod($oObj, "Reset", libusb_reset_device)
		_AutoItObject_AddMethod($oObj, "Kernel_Driver_Active", libusb_kernel_driver_active)

		_AutoItObject_AddMethod($oObj, "Claim_Interface", libusb_claim_interface)
		_AutoItObject_AddMethod($oObj, "Release_Interface", libusb_release_interface)
		_AutoItObject_AddMethod($oObj, "Wrap_Sys_Device", libusb_wrap_sys_device)
		_AutoItObject_AddMethod($oObj, "Get_Device", libusb_get_device)
		_AutoItObject_AddMethod($oObj, "Set_Configuration", libusb_set_configuration)
		_AutoItObject_AddMethod($oObj, "Control_Transfer", libusb_control_transfer)
		_AutoItObject_AddMethod($oObj, "bulk_transfer", libusb_bulk_transfer)
		_AutoItObject_AddMethod($oObj, "interrupt_transfer", libusb_interrupt_transfer)
		_AutoItObject_AddMethod($oObj, "Get_Configuration", libusb_get_configuration)
		_AutoItObject_AddMethod($oObj, "Get_descriptor", libusb_get_descriptor)
		_AutoItObject_AddMethod($oObj, "get_string_descriptor", libusb_get_string_descriptor)

		_AutoItObject_AddMethod($oObj, "set_interface_alt_setting", libusb_set_interface_alt_setting)
		_AutoItObject_AddMethod($oObj, "libusb_clear_halt", libusb_clear_halt)
		_AutoItObject_AddMethod($oObj, "libusb_alloc_streams", libusb_alloc_streams)
		_AutoItObject_AddMethod($oObj, "libusb_free_streams", libusb_free_streams)
		_AutoItObject_AddMethod($oObj, "libusb_dev_mem_alloc", libusb_dev_mem_alloc)
		_AutoItObject_AddMethod($oObj, "libusb_dev_mem_free", libusb_dev_mem_free)
		_AutoItObject_AddMethod($oObj, "libusb_detach_kernel_driver", libusb_detach_kernel_driver)
		_AutoItObject_AddMethod($oObj, "libusb_attach_kernel_driver", libusb_attach_kernel_driver)
		_AutoItObject_AddMethod($oObj, "Set_auto_detach_kernel_driver", libusb_set_auto_detach_kernel_driver)

		; Extra Methods
		_AutoItObject_AddMethod($oObj, "ReadBinary", __USB_BinRead)
		_AutoItObject_AddMethod($oObj, "WriteBinary", __USB_BinWrite)
		_AutoItObject_AddMethod($oObj, "WriteFile", __USB_FileWrite)
		_AutoItObject_AddMethod($oObj, "ReadString", __USB_StrRead)
		_AutoItObject_AddMethod($oObj, "WriteString", __USB_StrWrite)
		_AutoItObject_AddMethod($oObj, "ReadStruct", __USB_StructRead)
		_AutoItObject_AddMethod($oObj, "WriteStruct", __USB_StructWrite)

		_AutoItObject_AddMethod($oObj, "WriteRead", __USB_WriteRead)
;~ 		_AutoItObject_AddMethod($oObj, "WriteStruct", __USB_StructWrite)

		_AutoItObject_AddProperty($oObj, "ENDPOINT_OUT",$ELSCOPE_PUBLIC,0)
		_AutoItObject_AddProperty($oObj, "ENDPOINT_IN",$ELSCOPE_PUBLIC,0)

		_AutoItObject_AddProperty($oObj, "dev_handle",$ELSCOPE_PRIVATE,$dev_handle)
		_AutoItObject_AddProperty($oObj, "DLL",$ELSCOPE_PRIVATE,$hDll)
		Return $oObj
	EndFunc

#Region Globle Function
	Func libusb_init($This,$bNewhContext = False)
		$This.DLL = _AutoItObject_DllOpen($This.DllSrc)
		If IsObj($This.DLL) Then
			Local $sParamType = ($bNewhContext) ? "ptr*" : "ptr"
			$aCall = $This.DLL.libusb_init("int", $sParamType, 0)
			If @error Then Return SetError(1, ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "), False)
			Sleep(500)
			$This.Context = Ptr($aCall[1])
			Return $aCall[0]
		Else
			Return False
		EndIf
	EndFunc

	Func libusb_get_version($This,$Full = False)
		$aCall = $This.DLL.libusb_get_version("ptr")
		If @error Then Return SetError(1, 0, False)
		Local $libusb_version = _AutoItObject_DllStructCreate("ushort major;ushort minor;ushort micro;ushort nano;",Ptr($aCall[0]))
		Return $Full ? $libusb_version.major&'.'&$libusb_version.minor&'.'&$libusb_version.micro&'.'&$libusb_version.nano : $libusb_version
	EndFunc

	Func libusb_set_option($This,$option)
		$aCall = $This.DLL.libusb_set_option("int","ptr",$This.Context,'int',$option)
		Return $aCall
	EndFunc

	Func libusb_set_debug($This,$level)
		$aCall = $This.DLL.libusb_set_debug("none", "ptr", $This.Context,'int',$level)
;~ 		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall
	EndFunc
	Func libusb_set_log_cb($This,$mode)
		$aCall = $This.DLL.libusb_set_log_cb("none", "ptr", $This.Context,'ptr',DllCallbackGetPtr($hHandle),'int',$mode)
		If @error Or Not $aCall[2] = 0 Then Return SetError(1, 0, 0)
		Return True
	EndFunc
	Func _Log_CallBack($Context,$level,$str)
;~ 		$StrLog = DllStructCreate('char[256]',$str)
;~ 		ConsoleWrite(@CRLF&DllStructGetData($StrLog,1))
	EndFunc
	Func libusb_has_capability($This,$capability)
	;~ 	int LIBUSB_CALL libusb_has_capability(uint32_t capability);
		$aCall = $This.DLL.libusb_set_log_cb("int",'int',$capability)
		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall[1]
	EndFunc

	Func libusb_setlocale($This,$locale)
	;~ 	int LIBUSB_CALL libusb_setlocale(const char *locale);
		$aCall = $This.DLL.libusb_setlocale("int",'STR*',$locale)
		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall[1]
	EndFunc
	Func libusb_get_device_list($This)
		$aCall = $This.DLL.libusb_get_device_list("int", "ptr", $This.Context, "ptr*", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Local $tlibusb_device_list = DllStructCreate("ptr[" & $aCall[0] & "]", $aCall[2])
		Local $ahDevicesList[$aCall[0] + 1]

		$ahDevicesList[0] = $aCall[2] ;store libusb_device pointer
		For $i = 1 To $aCall[0]
			$ahDevicesList[$i] = DllStructGetData($tlibusb_device_list, 1, $i)
		Next

		Return $ahDevicesList
	EndFunc   ;==>_libusb_get_device_list

	Func libusb_find_device_by_ids($This,$VID,$PID)
		$aCall = $This.DLL.libusb_get_device_list("int", "ptr", $This.Context, "ptr*", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Local $tlibusb_device_list = DllStructCreate("ptr[" & $aCall[0] & "]", $aCall[2])
		Local $ahDevicesList[$aCall[0] + 1]
		$ahDevicesList[0] = $aCall[2] ;store libusb_device pointer
		For $i = 1 To $aCall[0]
			$ahDevicesList[$i] = DllStructGetData($tlibusb_device_list, 1, $i)
			Local $device_descriptor = $This.get_device_descriptor($ahDevicesList[$i])
			If $VID = $device_descriptor.idVendor And $PID = $device_descriptor.idProduct Then
				$This.Device = $ahDevicesList[$i]
				Return True
			EndIf
		Next
		Return False
	EndFunc   ;==>_libusb_get_device_list

	Func libusb_free_device_list($This, ByRef $ahDevicesList, $iUnref_Devices = 1)
		If Not IsArray($ahDevicesList) Or Not UBound($ahDevicesList) Then Return SetError(1, 0, 0)
		Local $hDeviceList = (UBound($ahDevicesList, 2) = 4) ? $ahDevicesList[0][0] : $ahDevicesList[0]
		If Not $hDeviceList Then Return SetError(1, 0, 0)
		$aCall = $This.DLL.libusb_free_device_list("none", "libusb_free_device_list", "ptr", $hDeviceList, "int",$iUnref_Devices)
		If @error Then Return SetError(1, 0, 0)
		Return 1
	EndFunc   ;==>_libusb_free_device_list

#EndRegion

#Region device

	Func libusb_get_active_config_descriptor($This,$hDevice)
		$aCall = $This.Dll.libusb_get_active_config_descriptor("int","ptr",$hDevice,"ptr*",0)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		ConsoleWrite(@CRLF&'get_active_config_descriptor '&$aCall[0]&' -> '&$hDevice)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		$config_descriptor = _AutoItObject_DllStructCreate($_libusb_config_descriptorTag,$aCall[2])
		Return $config_descriptor
	EndFunc

	Func libusb_get_config_descriptor($This,$hDevice,$config_index)
		$aCall = $This.Dll.libusb_get_config_descriptor("int","ptr",$hDevice,'BYTE',$config_index,"ptr*",0)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		$config_descriptor = _AutoItObject_DllStructCreate($_libusb_config_descriptorTag,$aCall[2])
		Return $config_descriptor
	EndFunc

	Func libusb_get_config_descriptor_by_value($This,$hDevice,$bConfigurationValue)
		$aCall = $This.Dll.libusb_get_config_descriptor_by_value("int","ptr",$hDevice,'BYTE',$bConfigurationValue,"ptr*",0)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		$config_descriptor = _AutoItObject_DllStructCreate($_libusb_config_descriptorTag,$aCall[2])
		Return $config_descriptor
	EndFunc


	Func libusb_open($This,$hDevice)
		Local $libusb_device_handle_Struct = DllStructCreate("PTR dev_handle")
		$aCall = $This.DLL.libusb_open("int","ptr",$hDevice,"ptr",DllStructGetPtr($libusb_device_handle_Struct))
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return DeviceObject($This.DLL,DllStructGetData($libusb_device_handle_Struct,1))
	EndFunc

	Func libusb_open_device_with_vid_pid($This,$ctx,$vendor_id,$product_id)
		$aCall = $This.DLL.libusb_open_device_with_vid_pid("ptr","ptr",$ctx,"USHORT",$vendor_id,"USHORT",$product_id)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return DeviceObject($This.DLL,$aCall[0])
	EndFunc

	Func libusb_get_device_descriptor($This,$hDevice)
		Local $device_descriptor = _AutoItObject_DllStructCreate($_libusb_device_descriptorTag)
		$aCall = $This.Dll.libusb_get_device_descriptor("int","ptr",$hDevice,"ptr",$device_descriptor())
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $device_descriptor
	EndFunc

	Func libusb_get_bus_number($This,$hDevice)
		$aCall = $This.Dll.libusb_get_bus_number("int","ptr",$hDevice)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_port_number($This,$hDevice)
		$aCall = $This.Dll.libusb_get_port_number("int","ptr",$hDevice)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_device_address($This,$hDevice)
		$aCall = $This.Dll.libusb_get_device_address("int","ptr",$hDevice)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_device_speed($This,$hDevice)
		$aCall = $This.Dll.libusb_get_device_speed("int","ptr",$hDevice)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_parent($This,$hDevice)
		$aCall = $This.Dll.libusb_get_parent("ptr","ptr",$hDevice)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_max_packet_size($This,$hDevice,$endpoint)
		$aCall = $This.Dll.libusb_get_max_packet_size("int","ptr",$hDevice,"str",$endpoint)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_max_iso_packet_size($This,$hDevice,$endpoint)
		$aCall = $This.Dll.libusb_get_max_iso_packet_size("int","ptr",$hDevice,"str",$endpoint)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc



#EndRegion
#Region dev_handle
	Func libusb_close($This)
		$aCall = $This.Dll.libusb_close("none","ptr",$This.dev_handle)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_reset_device($This)
		$aCall = $This.Dll.libusb_reset_device("int","ptr",$This.dev_handle)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_kernel_driver_active($This,$interface_number)
		$aCall = $This.DLL.libusb_kernel_driver_active("int","ptr",$This.dev_handle,'int',$interface_number)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_wrap_sys_device($This,$hContext,$sys_dev)
		$aCall = $This.DLL.libusb_wrap_sys_device("int","ptr",$hContext,'int*',$sys_dev,'ptr',$This.dev_handle)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_device($This)
		$aCall = $This.DLL.libusb_get_device("ptr",'ptr',$This.dev_handle)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_get_descriptor($This,$desc_type,$desc_index)
		$length = 4
		$sData = DllStructCreate("byte data["&$length&"]")
		$aCall = $This.Control_Transfer(0x80,0x06,BitOR(BitShift($desc_type, -8),$desc_index),0,DllStructGetPtr($sData),$length,1000)
		Sleep(1000)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		Return $sData.data
	EndFunc

	Func libusb_get_string_descriptor($This,$desc_index,$langid = 0)
		$length = 64
		$sData = DllStructCreate("byte data["&$length&"]")
		$aCall = $This.Control_Transfer(0x80,0x06,BitOR(BitShift(0x03 , -8),$desc_index),$langid,DllStructGetPtr($sData),$length,1000)
		Sleep(1000)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		Return $sData.data
	EndFunc

	Func libusb_get_configuration($This)
		$sConfig = DllStructCreate("int config")
		$aCall = $This.Dll.libusb_get_configuration("int","ptr",$This.dev_handle,"ptr",DllStructGetPtr($sConfig))
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $sConfig.config
	EndFunc

	Func libusb_control_transfer($This,$request_type,$bRequest,$wValue,$wIndex,$data,$wLength,$timeout)
		$aCall = $This.DLL.libusb_control_transfer("int","ptr",$This.dev_handle,"BYTE",$request_type, _
		"BYTE",$bRequest, _
		"USHORT",$wValue, _
		"USHORT",$wIndex, _
		"PTR",$data, _
		"USHORT",$wLength, _
		"UINT",$timeout)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_bulk_transfer($This,$endpoint,$data,$length,$timeout)
		$sActual = DllStructCreate("int actual")

		$aCall = $This.DLL.libusb_bulk_transfer("int","ptr",$This.dev_handle,"BYTE",$endpoint, _
		"PTR",$data, _
		"int",$length, _
		"ptr",DllStructGetPtr($sActual), _
		"UINT",$timeout)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_interrupt_transfer($This,$endpoint,$data,$length,$actual_length,$timeout)
		$aCall = $This.DLL.libusb_interrupt_transfer("int","ptr",$This.dev_handle,"BYTE",$endpoint, _
		"PTR",$data, _
		"USHORT",$length, _
		"int",$actual_length, _
		"UINT",$timeout)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_set_configuration($This,$configuration = 0)
		$aCall = $This.DLL.libusb_set_configuration("int",'ptr',$This.dev_handle ,'int',$configuration)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_claim_interface($This,$interface_number)
		$aCall = $This.DLL.libusb_claim_interface("int","ptr",$This.dev_handle,'int',$interface_number)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_release_interface($This,$interface_number)
		$aCall = $This.DLL.libusb_release_interface("int","ptr",$This.dev_handle,'int',$interface_number)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_set_interface_alt_setting($This,$interface_number,$alternate_setting)
		$aCall = $This.DLL.libusb_set_interface_alt_setting("int","ptr",$This.dev_handle,'int',$interface_number,'int',$alternate_setting)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_clear_halt($This,$endpoint)
		$aCall = $This.DLL.libusb_clear_halt("int","ptr",$This.dev_handle,'int',$endpoint)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

;~ 	 ****************************************
	Func libusb_alloc_streams($This,$num_streams,$endpoints,$num_endpoints)
		$aCall = $This.DLL.libusb_alloc_streams("int","ptr",$This.dev_handle,'int',$num_streams,'str*',$endpoints,'int',$num_endpoints)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_free_streams($This,$endpoints,$num_endpoints)
		$aCall = $This.DLL.libusb_free_streams("int","ptr",$This.dev_handle,'str*',$endpoints,'int',$num_endpoints)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_dev_mem_alloc($This,$length)
		$aCall = $This.DLL.libusb_dev_mem_alloc("str","ptr",$This.dev_handle,'int',$length)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_dev_mem_free($This,$buffer,$length)
		$aCall = $This.DLL.libusb_dev_mem_alloc("int","ptr",$This.dev_handle,'str*',$buffer,'int',$length)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_detach_kernel_driver($This,$interface_number)
		$aCall = $This.DLL.libusb_detach_kernel_driver("int","ptr",$This.dev_handle,'int',$interface_number)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_attach_kernel_driver($This,$interface_number)
		$aCall = $This.DLL.libusb_attach_kernel_driver("int","ptr",$This.dev_handle,'int',$interface_number)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_set_auto_detach_kernel_driver($This,$enable = 1)
		$aCall = $This.DLL.libusb_set_auto_detach_kernel_driver("int","ptr",$This.dev_handle,'int',$enable)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc



#EndRegion

#Region Extra Extra Methods

	Func __USB_BinWrite($This,$BinData,$iTimeout = 0)
		$toWrite = DllStructCreate("Byte Data")
		$toWrite.Data = $BinData
		$count = $This.bulk_transfer($This.ENDPOINT_OUT, DllStructGetPtr($toWrite) , DllStructGetSize($toWrite) , $iTimeout)
		If @error Then Return SetError($count,0,False)
		Return True
	EndFunc

	Func __USB_BinRead($This, Const $iMaxLength = 1, Const $iTimeout = 1)
		$toRead = DllStructCreate("Byte Data["&$iMaxLength&"]")

		$count = $This.bulk_transfer($This.ENDPOINT_IN,DllStructGetPtr($toRead),DllStructGetSize($toRead),$iTimeout)
		If @error Then Return SetError($count,0,False)
		Return $toRead.Data
	EndFunc

	Func __USB_StrWrite($This, $sData,$iTimeout = 0)
		Local $iWritten = $This.WriteBinary(StringToBinary($sData, 1),$iTimeout)
		If @error Then Return SetError(@error, @extended, $iWritten)
		Return $iWritten
	EndFunc

	Func __USB_StrRead($This, Const $iTimeout = 1, Const $iMaxLength = 0, Const $sSeparator = "", Const $iFlag = 1)

	EndFunc

	Func __USB_FileWrite($This,$hSrc,$Start,$Length,$Max = 4096)

	EndFunc

	Func __USB_StructWrite($This, $Struct)

	EndFunc

	Func __USB_StructRead($This, $Struct, Const $iTimeout = 1)

	EndFunc

	Func __USB_WriteRead($This,$bData,$MaxData = 512,$TimeOut = 1000)
		If $This.WriteBinary($bData) Then
			Return $This.ReadBinary($MaxData)
		EndIf
	EndFunc

	Func __USB_Find_By_Array($This,$Array)
		If IsArray($Array) Then
			For $i = 0 To UBound($Array) -1
				$List = $USB.get_device_list
				For $x = 0 To UBound($List) -1
				$device_descriptor = $USB.get_device_descriptor($List[$x])
					If $Array[$i][0] = $device_descriptor.idVendor And $Array[$i][1] = $device_descriptor.idProduct Then
						$This.Device = $List[$x]
						Return True
					EndIf
				Next
			Next
		EndIf

		Return False
	EndFunc

#EndRegion

Func _libusb_error($Error)
	Return $Error = 0 ? True : SetError($Error,0,False)
EndFunc
Func _libusb_error_msg($Error)
	Local $Error_Msg
	Switch $Error
		Case -1
			; Input/output error
			$Error_Msg = "LIBUSB_ERROR_IO"
		Case -2
			; Invalid parameter
			$Error_Msg = "LIBUSB_ERROR_INVALID_PARAM"
		Case -3
			; Access denied (insufficient permissions)
			$Error_Msg = "LIBUSB_ERROR_ACCESS"
		Case -4
			; No such device (it may have been disconnected)
			$Error_Msg = "LIBUSB_ERROR_NO_DEVICE"
		Case -5
			; Entity not found
			$Error_Msg = "LIBUSB_ERROR_NOT_FOUND"
		Case -6
			; Resource busy
			$Error_Msg = "LIBUSB_ERROR_BUSY"
		Case -7
			; Operation timed out
			$Error_Msg = "LIBUSB_ERROR_TIMEOUT"
		Case -8
			; Overflow
			$Error_Msg = "LIBUSB_ERROR_OVERFLOW"
		Case -9
			; Pipe error
			$Error_Msg = "LIBUSB_ERROR_PIPE"
		Case -10
			; System call interrupted (perhaps due to signal)
			$Error_Msg = "LIBUSB_ERROR_INTERRUPTED"
		Case -11
			; Insufficient memory
			$Error_Msg = "LIBUSB_ERROR_NO_MEM"
		Case -12
			; Operation not supported or unimplemented on this platform
			$Error_Msg = "LIBUSB_ERROR_NOT_SUPPORTED"

		Case -99
			;   NB: Remember to update LIBUSB_ERROR_COUNT below as well as the
			;	message strings in strerror.c when adding new error codes here.

			;Other error
			$Error_Msg = "LIBUSB_ERROR_OTHER"
	EndSwitch
	Return $Error_Msg
EndFunc

