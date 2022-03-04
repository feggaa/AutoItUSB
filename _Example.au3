#include "LibUSB_UDF.au3"


Global $SAM_VID = 1256, $SAM_PID = 26720

$USB = USB()

$List = $USB.get_device_list
$i = 6

#Region Example 1
For $i = 0 To UBound($List) -1
$device_descriptor = $USB.get_device_descriptor($List[$i])
		ConsoleWrite(@CRLF&'------------------------- Device ['&$i&']----------------------------'&@CRLF)
		ConsoleWrite('----------> bLength :'&$device_descriptor.bLength & _
					@CRLF&'----------> bDescriptorType : '&$device_descriptor.bDescriptorType & _
					@CRLF&'----------> bcdUSB : '&$device_descriptor.bcdUSB & _
					@CRLF&'----------> bDeviceClass : '&$device_descriptor.bDeviceClass & _
					@CRLF&'----------> bDeviceSubClass : '&$device_descriptor.bDeviceSubClass & _
					@CRLF&'----------> bDeviceProtocol : '&$device_descriptor.bDeviceProtocol & _
					@CRLF&'----------> bMaxPacketSize : '&$device_descriptor.bMaxPacketSize & _
					@CRLF&'----------> idVendor : '&$device_descriptor.idVendor & _
					@CRLF&'----------> idProduct : '&$device_descriptor.idProduct & _
					@CRLF&'----------> bcdDevice : '&$device_descriptor.bcdDevice & _
					@CRLF&'----------> iManufacturer : '&$device_descriptor.iManufacturer & _
					@CRLF&'----------> iProduct : '&$device_descriptor.iProduct & _
					@CRLF&'----------> iSerialNumber : '&$device_descriptor.iSerialNumber & _
					@CRLF&'----------> bNumConfigurations : '&$device_descriptor.bNumConfigurations & _
					@CRLF&'----------> busNumber : '&$USB.get_bus_number($List[$i]))
		ConsoleWrite(@CRLF&'-----------------------------------------------------'&@CRLF)
Next
#EndRegion

#Region Example 2
For $i = 0 To UBound($List) -1
$device_descriptor = $USB.get_device_descriptor($List[$i])
	If $SAM_VID = $device_descriptor.idVendor And $SAM_PID = $device_descriptor.idProduct Then

		ConsoleWrite('bLength :'&@CRLF&$device_descriptor.bLength & _
					@CRLF&'bDescriptorType : '&$device_descriptor.bDescriptorType & _
					@CRLF&'bcdUSB : '&$device_descriptor.bcdUSB & _
					@CRLF&'bDeviceClass : '&$device_descriptor.bDeviceClass & _
					@CRLF&'bDeviceSubClass : '&$device_descriptor.bDeviceSubClass & _
					@CRLF&'bDeviceProtocol : '&$device_descriptor.bDeviceProtocol & _
					@CRLF&'bMaxPacketSize : '&$device_descriptor.bMaxPacketSize & _
					@CRLF&'idVendor : '&$device_descriptor.idVendor & _
					@CRLF&'idProduct : '&$device_descriptor.idProduct & _
					@CRLF&'bcdDevice : '&$device_descriptor.bcdDevice & _
					@CRLF&'iManufacturer : '&$device_descriptor.iManufacturer & _
					@CRLF&'iProduct : '&$device_descriptor.iProduct & _
					@CRLF&'iSerialNumber : '&$device_descriptor.iSerialNumber & _
					@CRLF&'bNumConfigurations : '&$device_descriptor.bNumConfigurations & _
					@CRLF&'busNumber : '&$USB.get_bus_number($List[$i]))

		$dev_handle = $USB.open($List[$i])

		$Test = $dev_handle.kernel_driver_active(1)


		$Result = $dev_handle.claim_interface(1) ;  <==== There is a problem here

			MsgBox(0,$Result,VarGetType($Result))


		ExitLoop
	EndIf
Next
#EndRegion