#include "AutoItObject.au3"
#include "LibUSB_Constanst.au3"

_AutoItObject_StartUp()

Func USB($hContext = 0)
    Local $oObj = _AutoItObject_Create()
	_AutoItObject_AddMethod($oObj, "Init", libusb_init)
	_AutoItObject_AddMethod($oObj, "Exit", libusb_exit)
	_AutoItObject_AddMethod($oObj, "Set_Debug", libusb_set_debug)
	_AutoItObject_AddMethod($oObj, "Set_Log_Cb", libusb_set_log_cb)
	_AutoItObject_AddMethod($oObj, "Get_Device_List", libusb_get_device_list)
	_AutoItObject_AddMethod($oObj, "Free_Device_List", libusb_free_device_list)
	_AutoItObject_AddMethod($oObj, "Open", libusb_open)
	_AutoItObject_AddMethod($oObj, "open_By_Ids", libusb_open_device_with_vid_pid)
	_AutoItObject_AddMethod($oObj, "Find_By_Ids", libusb_find_device_by_ids)
	_AutoItObject_AddMethod($oObj, "Get_Device_Descriptor", libusb_get_device_descriptor)
	_AutoItObject_AddMethod($oObj, "Get_Bus_Number", libusb_get_bus_number)
	_AutoItObject_AddMethod($oObj, "Get_Port_Number", libusb_get_port_number)
	_AutoItObject_AddMethod($oObj, "Get_Device_Address", libusb_get_device_address)
	_AutoItObject_AddMethod($oObj, "Get_Device_Speed", libusb_get_device_speed)
	_AutoItObject_AddMethod($oObj, "Get_parent", libusb_get_parent)
	_AutoItObject_AddMethod($oObj, "Get_max_packet_size", libusb_get_max_packet_size)
	_AutoItObject_AddMethod($oObj, "Get_max_iso_packet_size", libusb_get_max_iso_packet_size)
;~ 	_AutoItObject_AddDestructor($oObj, "")
    _AutoItObject_AddProperty($oObj, "DllSrc", $ELSCOPE_PRIVATE,@AutoItX64 ? "libusb-1.0_X64.dll" : "iLibUSB_32.dll")
	_AutoItObject_AddProperty($oObj, "DLL",$ELSCOPE_PRIVATE)
	_AutoItObject_AddProperty($oObj, "Context",$ELSCOPE_PRIVATE,$hContext)
	_AutoItObject_AddProperty($oObj, "device_descriptorTag",$ELSCOPE_PRIVATE,$_libusb_device_descriptorTag)
;~ 	$USB.init()
    Return $oObj
EndFunc   ;==>_DongleObject

#Region Globle Function
	Func libusb_init($This,$bNewhContext = False)
		$This.DLL = _AutoItObject_DllOpen($This.DllSrc)
		If IsObj($This.DLL) Then
			Local $sParamType = ($bNewhContext) ? "ptr*" : "ptr"
			$aCall = $This.DLL.libusb_init("int", $sParamType, 0)
			If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
			Return $aCall[1]
		Else
			Return False
		EndIf
	EndFunc
	Func libusb_exit($This)
		$aCall = $This.DLL.libusb_exit("none", "ptr", $This.Context)
		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall[1]
	EndFunc
	Func libusb_set_debug($This,$level)
		$aCall = $This.DLL.libusb_set_debug("none", "ptr", $This.Context,'int',$level)
		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall[1]
	EndFunc
	Func libusb_set_log_cb($This,$level)
	;~ 	void LIBUSB_CALL libusb_set_log_cb(libusb_context *ctx, libusb_log_cb cb, int mode);
		$aCall = $This.DLL.libusb_set_log_cb("none", "ptr", $This.Context,'int',$level)
		If @error Or Not $aCall[0] = 0 Then Return SetError(1, 0, 0)
		Return $aCall[1]
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
			Local $device_descriptor = $USB.get_device_descriptor($ahDevicesList[$i])
			If $VID = $device_descriptor.idVendor And $PID = $device_descriptor.idProduct Then Return $ahDevicesList[$i]
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
		_AutoItObject_AddMethod($oObj, "libusb_set_interface_alt_setting", libusb_set_interface_alt_setting)
		_AutoItObject_AddMethod($oObj, "libusb_clear_halt", libusb_clear_halt)
		_AutoItObject_AddMethod($oObj, "libusb_alloc_streams", libusb_alloc_streams)
		_AutoItObject_AddMethod($oObj, "libusb_free_streams", libusb_free_streams)
		_AutoItObject_AddMethod($oObj, "libusb_dev_mem_alloc", libusb_dev_mem_alloc)
		_AutoItObject_AddMethod($oObj, "libusb_dev_mem_free", libusb_dev_mem_free)
		_AutoItObject_AddMethod($oObj, "libusb_detach_kernel_driver", libusb_detach_kernel_driver)
		_AutoItObject_AddMethod($oObj, "libusb_attach_kernel_driver", libusb_attach_kernel_driver)
		_AutoItObject_AddMethod($oObj, "libusb_set_auto_detach_kernel_driver", libusb_set_auto_detach_kernel_driver)



		_AutoItObject_AddProperty($oObj, "dev_handle",$ELSCOPE_PRIVATE,$dev_handle)
		_AutoItObject_AddProperty($oObj, "DLL",$ELSCOPE_PRIVATE,$hDll)
		Return $oObj
	EndFunc
	Func libusb_open($This,$hDevice)
		Local $libusb_device_handle_Struct = DllStructCreate("PTR")
		$aCall = $This.DLL.libusb_open("int","ptr",$hDevice,"ptr",DllStructGetPtr($libusb_device_handle_Struct))
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
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
	Func libusb_close($This,$hDevice)
		$aCall = $This.Dll.libusb_close("none","ptr",$This.dev_handle)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
	EndFunc

	Func libusb_reset_device($This,$hDevice)
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

	Func libusb_set_configuration($This,$configuration)
		$aCall = $This.DLL.libusb_set_configuration("int",'ptr',$This.dev_handle,'int',$configuration)
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

	Func libusb_set_auto_detach_kernel_driver($This,$enable = True)
		$aCall = $This.DLL.libusb_set_auto_detach_kernel_driver("int","ptr",$This.dev_handle,'int',$enable)
		If Not IsArray($aCall) Then Return SetError(1, 0, 0)
		If $aCall[0] < 0 Then
			ConsoleWrite(@CRLF&"LIBUSB ERROR ["&$aCall[0]&"] : "&_libusb_error_msg($aCall[0]))
			Return _libusb_error($aCall[0])
		EndIf
		Return $aCall[0]
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
