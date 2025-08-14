forward
global type n_wininet from nonvisualobject
end type
type filetime from structure within n_wininet
end type
type win32_find_data from structure within n_wininet
end type
type systemtime from structure within n_wininet
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type win32_find_data from structure
	unsignedlong		dwfileattributes
	filetime		ftcreationtime
	filetime		ftlastaccesstime
	filetime		ftlastwritetime
	unsignedlong		nfilesizehigh
	unsignedlong		nfilesizelow
	unsignedlong		dwreserved0
	unsignedlong		dwreserved1
	character		cfilename[260]
	character		calternatefilename[14]
end type

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

global type n_wininet from nonvisualobject autoinstantiate
event ue_internetopen ( )
end type

type prototypes
// Windows Functions

Function ulong GetLastError ( &
	) Library "kernel32.dll"

Function ulong FormatMessage( &
	ulong dwFlags, &
	longptr lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function longptr GetModuleHandle( &
	string lpModuleName &
	) Library "kernel32.dll" Alias For "GetModuleHandleW"

Function boolean FileTimeToSystemTime ( &
	Ref FILETIME lpFileTime, &
	Ref SYSTEMTIME lpSystemTime &
	) Library "kernel32.dll" Alias For "FileTimeToSystemTime"

Function longptr CreateFile ( &
	string lpFileName, &
	ulong dwDesiredAccess, &
	ulong dwShareMode, &
	longptr lpSecurityAttributes, &
	ulong dwCreationDisposition, &
	ulong dwFlagsAndAttributes, &
	longptr hTemplateFile &
	) Library "kernel32.dll" Alias For "CreateFileW"

Function boolean CloseHandle ( &
	longptr hObject &
	) Library "kernel32.dll"

Function boolean ReadFile ( &
	longptr hFile, &
	Ref Blob lpBuffer, &
	ulong nNumberOfBytesToRead, &
	Ref ulong lpNumberOfBytesRead, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function boolean WriteFile ( &
	longptr hFile, &
	blob lpBuffer, &
	ulong nNumberOfBytesToWrite, &
	Ref ulong lpNumberOfBytesWritten, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

// WinInet Common Functions

Function long InternetOpen ( &
	string lpszAgent, &
	ulong dwAccessType, &
	string lpszProxyName, &
	string lpszProxyBypass, &
	ulong dwFlags &
	) Library "wininet.dll" Alias For "InternetOpenW"

Function boolean InternetCloseHandle ( &
	longptr hInternet &
	) Library "wininet.dll"

Function ulong InternetConnect ( &
	longptr hInternet, &
	string lpszServerName, &
	ulong nServerPort, &
	string lpszUsername, &
	string lpszPassword, &
	ulong dwService, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "InternetConnectW"

Function boolean InternetGetLastResponseInfo ( &
	Ref ulong lpdwError, &
	Ref string lpszBuffer, &
	Ref ulong lpdwBufferLength &
	) Library "wininet.dll" Alias For "InternetGetLastResponseInfoW"

Function boolean InternetFindNextFile ( &
	longptr hFind, &
	Ref WIN32_FIND_DATA lpvFindData &
	) Library "wininet.dll" Alias For "InternetFindNextFileW"

Function boolean InternetReadFile ( &
	longptr hFile, &
	Ref blob lpBuffer, &
	ulong dwNumberOfBytesToRead, &
	Ref ulong lpdwNumberOfBytesRead &
	) Library "wininet.dll" Alias For "InternetReadFile"

Function boolean InternetWriteFile ( &
	longptr hFile, &
	blob lpBuffer, &
	ulong dwNumberOfBytesToWrite, &
	Ref ulong lpdwNumberOfBytesWritten &
	) Library "wininet.dll" Alias For "InternetWriteFile"

Function boolean InternetSetOption ( &
	longptr hInternet, &
	ulong dwOption, &
	string lpBuffer, &
	ulong dwBufferLength &
	) Library "wininet.dll" Alias For "InternetSetOptionW"

// WinINet HTTP Functions

Function longptr httpOpenRequest ( &
	longptr hConnect, &
	string lpszVerb, &
	string lpszObjectName, &
	string lpszVersion, &
	string lpszReferer, &
	ulong lplpszAcceptTypes, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "HttpOpenRequestW"

Function boolean HttpSendRequest ( &
	longptr hRequest, &
	string lpszHeaders, &
	ulong dwHeadersLength, &
	ulong lpOptional, &
	ulong dwOptionalLength &
	) Library "wininet.dll" Alias For "HttpSendRequestW"

Function boolean HttpQueryInfo ( &
	longptr hRequest, &
	ulong dwInfoLevel, &
	Ref string lpvBuffer, &
	Ref ulong lpdwBufferLength, &
	Ref ulong lpdwIndex &
	) Library "wininet.dll" Alias For "HttpQueryInfoW"

// WinINet FTP Functions

Function boolean FtpCommand ( &
	longptr hConnect, &
	boolean fExpectResponse, &
	ulong dwFlags, &
	string lpszCommand, &
	ulong dwContext, &
	ref ulong phFtpCommand &
	) Library "wininet.dll" Alias For "FtpCommandW"

Function boolean FtpCreateDirectory ( &
	longptr hConnect, &
	string lpszDirectory &
	) Library "wininet.dll" Alias For "FtpCreateDirectoryW"

Function boolean FtpDeleteFile ( &
	longptr hConnect, &
	string lpszFileName &
	) Library "wininet.dll" Alias For "FtpDeleteFileW"

Function ulong FtpFindFirstFile ( &
	longptr hConnect, &
	string lpszSearchFile, &
	Ref WIN32_FIND_DATA lpFindFileData, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "FtpFindFirstFileW"

Function boolean FtpGetCurrentDirectory ( &
	longptr hConnect, &
	Ref string lpszCurrentDirectory, &
	Ref ulong lpdwCurrentDirectory &
	) Library "wininet.dll" Alias For "FtpGetCurrentDirectoryW"

Function boolean FtpGetFile ( &
	longptr hConnect, &
	string lpszRemoteFile, &
	string lpszNewFile, &
	boolean fFailIfExists, &
	ulong dwFlagsAndAttributes, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "FtpGetFileW"

Function long FtpGetFileSize ( &
	longptr hFile, &
	Ref ulong lpdwFileSizeHigh &
	) Library "wininet.dll" Alias For "FtpGetFileSize"

Function ulong FtpOpenFile ( &
	longptr hConnect, &
	string lpszFileName, &
	ulong dwAccess, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "FtpOpenFileW"

Function boolean FtpPutFile ( &
	longptr hConnect, &
	string lpszLocalFile, &
	string lpszNewRemoteFile, &
	ulong dwFlags, &
	ulong dwContext &
	) Library "wininet.dll" Alias For "FtpPutFileW"

Function boolean FtpRemoveDirectory ( &
	longptr hConnect, &
	string lpszDirectory &
	) Library "wininet.dll" Alias For "FtpRemoveDirectoryW"

Function boolean FtpRenameFile ( &
	longptr hConnect, &
	string lpszExisting, &
	string lpszNew &
	) Library "wininet.dll" Alias For "FtpRenameFileW"

Function boolean FtpSetCurrentDirectory ( &
	longptr hConnect, &
	string lpszDirectory &
	) Library "wininet.dll" Alias For "FtpSetCurrentDirectoryW"

end prototypes

type variables
// Internet handles
longptr il_internet
longptr il_session
longptr il_request

// Error Information
string LastErrorMsg
ulong LastErrorNbr

Boolean ib_StopAction

// constants for CreateFile API function
Constant ULong INVALID_HANDLE_VALUE = -1
Constant ULong GENERIC_READ		= 2147483648
Constant ULong GENERIC_WRITE		= 1073741824
Constant ULong FILE_SHARE_READ	= 1
Constant ULong FILE_SHARE_WRITE	= 2
Constant ULong CREATE_NEW			= 1
Constant ULong CREATE_ALWAYS		= 2
Constant ULong OPEN_EXISTING		= 3
Constant ULong OPEN_ALWAYS			= 4
Constant ULong TRUNCATE_EXISTING = 5

// Internet API error returns
Constant ulong INTERNET_ERROR_BASE				= 12000
Constant ulong ERROR_INTERNET_EXTENDED_ERROR	= (INTERNET_ERROR_BASE + 3)

// FTP transfer flags
Constant uint FTP_TRANSFER_TYPE_ASCII	= 1
Constant uint FTP_TRANSFER_TYPE_BINARY	= 2

// Internet flags
Constant ulong INTERNET_FLAG_RELOAD				= 2147483648
Constant ulong INTERNET_FLAG_NO_CACHE_WRITE	= 67108864
Constant ulong INTERNET_FLAG_RAW_DATA			= 1073741824
Constant ulong INTERNET_FLAG_PASSIVE			= 134217728
Constant ulong INTERNET_FLAG_SECURE				= 8388608

// InternetOpen
Constant ulong INTERNET_OPEN_TYPE_DIRECT								= 1
Constant ulong INTERNET_OPEN_TYPE_PREOPTIONS							= 0
Constant ulong INTERNET_OPEN_TYPE_PREOPTIONS_WITH_NO_AUTOPROXY	= 4
Constant ulong INTERNET_OPEN_TYPE_PROXY								= 3

Constant ulong INTERNET_FLAG_ASYNC			= 268435456	// 0x10000000
Constant ulong INTERNET_FLAG_FROM_CACHE	= 16777216	// 0x01000000
Constant ulong INTERNET_FLAG_OFFLINE		= INTERNET_FLAG_FROM_CACHE

// InternetConnect
Constant ulong INTERNET_DEFAULT_FTP_PORT		= 21
Constant ulong INTERNET_DEFAULT_GOPHER_PORT	= 70
Constant ulong INTERNET_DEFAULT_HTTP_PORT		= 80
Constant ulong INTERNET_DEFAULT_HTTPS_PORT	= 443
Constant ulong INTERNET_DEFAULT_SOCKS_PORT	= 1080
Constant ulong INTERNET_INVALID_PORT_NUMBER	= 0

Constant ulong INTERNET_SERVICE_FTP		= 1
Constant ulong INTERNET_SERVICE_GOPHER	= 2
Constant ulong INTERNET_SERVICE_HTTP	= 3

// HttpOpenRequest
Constant ulong INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP	= 32768	// 0x00008000
Constant ulong INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS	= 16384	// 0x00004000
Constant ulong INTERNET_FLAG_IGNORE_CERT_DATE_INVALID	= 8192	// 0x00002000
Constant ulong INTERNET_FLAG_IGNORE_CERT_CN_INVALID	= 4096	// 0x00001000

end variables

forward prototypes
public function boolean of_internetopen ()
public subroutine of_sessionclose ()
public subroutine of_internetclose ()
public subroutine of_requestclose ()
public function boolean of_writefile (string as_filename, blob ablob_filedata)
public function unsignedlong of_readfile (string as_filename, ref blob ablob_filedata)
public function datetime of_filedatetimetopb (filetime astr_filetime)
public function boolean of_http_openrequest (string as_verb, string as_object, boolean ab_secure)
public function boolean of_http_sendrequestget (ref blob ablob_buffer)
public function boolean of_httpget (string as_server, string as_file, ref blob ablob_buffer, boolean ab_secure)
public function boolean of_ftp_command (string as_command, ref string as_response)
public function boolean of_ftp_createdirectory (string as_directory)
public function boolean of_ftp_deletefile (string as_filename)
public function boolean of_ftp_internetconnect (string as_servername, string as_userid, string as_password)
public function boolean of_ftp_internetconnect (string as_servername)
public function boolean of_ftp_internetconnect (string as_servername, string as_userid, string as_password, unsignedinteger aui_port, boolean ab_passive)
public function integer of_ftp_directory (ref s_ftpdirlist astr_dirlist[])
public function boolean of_ftp_directoryexists (string as_dirname)
public function boolean of_ftp_fileexists (string as_filename)
public function boolean of_ftp_getcurrentdirectory (ref string as_directory)
public function boolean of_ftp_getfile (string as_source, string as_target, boolean ab_ascii)
public function boolean of_ftp_putfile (string as_source, string as_target, boolean ab_ascii)
public function boolean of_ftp_removedirectory (string as_directory)
public function boolean of_ftp_renamefile (string as_filename, string as_newname)
public function boolean of_ftp_setcurrentdirectory (string as_directory)
public function boolean of_ftp_readfile (string as_source, string as_target, long al_window, long al_event)
public function boolean of_ftp_readfile (string as_source, string as_target)
public function boolean of_ftp_readstring (string as_filename, ref string as_content)
public function boolean of_ftp_writefile (string as_source, string as_target, long al_window, long al_event)
public function boolean of_ftp_writefile (string as_source, string as_target)
public function boolean of_ftp_writestring (string as_filename, string as_content)
public function boolean of_internetsetoption (unsignedlong aul_option, string as_value)
public function boolean of_getlasterror ()
public function boolean of_ftp_internetconnect (string as_servername, unsignedinteger aui_port, boolean ab_passive)
public function boolean of_checkbit (long al_number, unsignedinteger ai_bit)
public subroutine of_stopaction ()
public function boolean of_http_internetconnect (string as_servername, unsignedlong aul_port)
public function boolean of_internetclosehandle (ref longptr al_handle)
end prototypes

event ue_internetopen();// initialize the internet dll

If Not this.of_InternetOpen() Then
	MessageBox(this.ClassName(), LastErrorMsg, StopSign!)
End If

end event

public function boolean of_internetopen ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_InternetOpen
//
// PURPOSE:    Initializes an application's use of the WinINet functions.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_null

SetNull(ls_null)

il_internet = InternetOpen(this.ClassName(), INTERNET_OPEN_TYPE_PREOPTIONS, &
							ls_null, ls_null, 0)

If IsNull(il_internet) Or il_internet = 0 Then
	Return of_GetLastError()
End If

Return True

end function

public subroutine of_sessionclose ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_SessionClose
//
// PURPOSE:    This function disconnects the current session.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If il_session > 0 Then
	this.of_InternetCloseHandle(il_session)
End If

end subroutine

public subroutine of_internetclose ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_InternetClose
//
// PURPOSE:    This function disconnects from the internet.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If il_internet > 0 Then
	this.of_InternetCloseHandle(il_internet)
End If

end subroutine

public subroutine of_requestclose ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_RequestClose
//
// PURPOSE:    This function disconnects the current request.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If il_request > 0 Then
	this.of_InternetCloseHandle(il_request)
End If

end subroutine

public function boolean of_writefile (string as_filename, blob ablob_filedata);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_WriteFile
//
// PURPOSE:    This function writes data to a file on disk.
//
// ARGUMENTS:  as_filename		- The name of the file
//					ablob_filedata	- The blob data of the file
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_Length, lul_Written
Boolean lb_rtn
Longptr ll_hFile

// open file for write
ll_hFile = CreateFile(as_filename, GENERIC_WRITE, &
					FILE_SHARE_WRITE, 0, CREATE_ALWAYS, 0, 0)
If ll_hFile = INVALID_HANDLE_VALUE Then
	Return of_GetLastError()
End If

// get data length
lul_Length = Len(ablob_filedata)

// write file to disk
lb_rtn = WriteFile(ll_hFile, ablob_filedata, &
					lul_Length, lul_Written, 0)

// close the file
CloseHandle(ll_hFile)

Return True

end function

public function unsignedlong of_readfile (string as_filename, ref blob ablob_filedata);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_ReadFile
//
// PURPOSE:    This function reads a file from disk.
//
// ARGUMENTS:  as_filename		- Name of the file
//					ablob_contents	- File contents (by ref)
//
// RETURN:		>0		= Number of bytes read
//					-1		= Error occurred
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_bytes, lul_length
Boolean lb_result
Longptr ll_hFile

// open file for read
ll_hFile = CreateFile(as_filename, GENERIC_READ, &
					FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
If ll_hFile = INVALID_HANDLE_VALUE Then
	Return -1
End If

// get file length
lul_length = FileLength(as_filename)

// allocate buffer (will be double needed due to Unicode)
ablob_filedata = Blob(Space(lul_length))

// read the entire file contents in one shot
lb_result = ReadFile(ll_hFile, ablob_filedata, &
					lul_length, lul_bytes, 0)

// remove extra spaces at the end of the buffer
ablob_filedata = BlobMid(ablob_filedata, 1, lul_length)

// close the file
CloseHandle(ll_hFile)

Return lul_bytes

end function

public function datetime of_filedatetimetopb (filetime astr_filetime);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_FileDateTimeToPB
//
// PURPOSE:    This function converts a file datetime to a PB datetime.
//
// ARGUMENTS:  astr_filetime	- filetime structure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

DateTime ldt_filedate
SYSTEMTIME lstr_systime
String ls_time
Date ld_fdate
Time lt_ftime

SetNull(ldt_filedate)

If Not FileTimeToSystemTime(astr_FileTime, &
			lstr_systime) Then Return ldt_filedate

ld_fdate = Date(lstr_systime.wYear, &
					lstr_systime.wMonth, lstr_systime.wDay)

ls_time = String(lstr_systime.wHour) + ":" + &
			 String(lstr_systime.wMinute) + ":" + &
			 String(lstr_systime.wSecond)

lt_ftime = Time(ls_Time)

ldt_filedate = DateTime(ld_fdate, lt_ftime)

Return ldt_filedate

end function

public function boolean of_http_openrequest (string as_verb, string as_object, boolean ab_secure);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Http_OpenRequest
//
// PURPOSE:    Creates an HTTP request handle.
//
// ARGUMENTS:  as_verb		- HTTP verb to use in the request.
//					as_object	- Name of the target object of the specified verb.
//					ab_secure	- Whether HTTPS protocol is being used.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_null
ULong lul_dwFlags

SetNull(ls_null)

lul_dwFlags = INTERNET_FLAG_RELOAD
If ab_secure Then
	lul_dwFlags += INTERNET_FLAG_SECURE
End If

il_request = HttpOpenRequest(il_session, as_verb, as_object, &
							"HTTP/1.0", ls_null, 0, lul_dwFlags, 0)

If IsNull(il_request) Or il_request = 0 Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_http_sendrequestget (ref blob ablob_buffer);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Http_SendRequestGet
//
// PURPOSE:    Sends the current HttpGet request and returns the file contents.
//
// ARGUMENTS:  ablob_buffer - The contents of the file.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_bufsize, lul_bytesread
Boolean lb_rtn, lb_loop
Blob lblob_buffer
String ls_null

lul_bufsize = 2048
lb_loop = True

SetNull(ls_null)
ablob_buffer = Blob("")

lb_rtn = HttpSendRequest(il_request, ls_null, 0, 0, 0)

If lb_rtn Then
	do while lb_loop
		lblob_buffer = Blob(Space(lul_bufsize))
		lb_loop = InternetReadFile(il_request, lblob_buffer, &
							lul_bufsize, lul_bytesread)
		If lul_bytesread = 0 Then
			lb_loop = False
		Else
			ablob_buffer += BlobMid(lblob_buffer, 1, lul_bytesread)
		End If
	loop
	Return True
End If

Return of_GetLastError()

end function

public function boolean of_httpget (string as_server, string as_file, ref blob ablob_buffer, boolean ab_secure);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_HttpGet
//
// PURPOSE:    Combines all the functions needed to perform HTTP GET.
//
// ARGUMENTS:  as_server		- The host name of an Internet server.
//					as_file			- Name of the target file.
//					ablob_buffer	- Buffer to return the file contents.
//					ab_secure		- Whether HTTPS protocol should be used.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If ab_secure Then
	If Not this.of_Http_InternetConnect(as_server, &
						INTERNET_DEFAULT_HTTPS_PORT) Then
		Return of_GetLastError()
	End If
Else
	If Not this.of_Http_InternetConnect(as_server, &
						INTERNET_DEFAULT_HTTP_PORT) Then
		Return of_GetLastError()
	End If
End If

If Not this.of_Http_OpenRequest("GET", as_file, ab_secure) Then
	this.of_SessionClose()
	Return of_GetLastError()
End If

If Not this.of_Http_SendRequestGet(ablob_buffer) Then
	this.of_RequestClose()
	this.of_SessionClose()
	Return of_GetLastError()
End If

this.of_RequestClose()
this.of_SessionClose()

Return True

end function

public function boolean of_ftp_command (string as_command, ref string as_response);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_Command
//
// PURPOSE:    The FtpCommand function sends commands directly to an FTP server.
//
// ARGUMENTS:  as_command	- The command to execute
//					as_response	- Server response string ( by ref )
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_ftphandle, lul_errorcode, lul_bufSize

If FtpCommand(il_session, False, FTP_TRANSFER_TYPE_ASCII, &
			as_command, 0, lul_ftphandle) Then
	// get response buffer size
	InternetGetLastResponseInfo(lul_errorcode, as_response, lul_bufSize)
	If lul_bufSize > 0 Then
		// get response
		as_response = Space(lul_bufSize + 1)
		InternetGetLastResponseInfo(lul_errorcode, &
						as_response, lul_bufSize)
	End If
Else
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_createdirectory (string as_directory);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_CreateDirectory
//
// PURPOSE:    Creates a new directory on the FTP server.
//
// ARGUMENTS:  as_directory	- The directory to create
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If Not FtpCreateDirectory(il_session, as_directory) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_deletefile (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_DeleteFile
//
// PURPOSE:    Deletes a file stored on the FTP server.
//
// ARGUMENTS:  as_directory	- The directory to create
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If Not FtpDeleteFile(il_session, as_filename) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_internetconnect (string as_servername, string as_userid, string as_password);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_InternetConnect
//
// PURPOSE:    Opens an FTP session for a given site.
//
// ARGUMENTS:  as_servername	- The name of the remote server
//					as_userid		- The userid to login with
//					as_password		- The password to login with
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Return of_ftp_InternetConnect(as_servername, as_userid, as_password, &
						INTERNET_DEFAULT_FTP_PORT, False)

end function

public function boolean of_ftp_internetconnect (string as_servername);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_InternetConnect
//
// PURPOSE:    Opens an FTP session for a given site.
//
// ARGUMENTS:  as_servername	- The name of the remote server
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_null

SetNull(ls_null)

Return of_ftp_InternetConnect(as_servername, ls_null, ls_null, &
						INTERNET_DEFAULT_FTP_PORT, False)

end function

public function boolean of_ftp_internetconnect (string as_servername, string as_userid, string as_password, unsignedinteger aui_port, boolean ab_passive);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_InternetConnect
//
// PURPOSE:    Opens an FTP session for a given site.
//
// ARGUMENTS:  as_servername	- The name of the remote server
//					as_userid		- The userid to login with
//					as_password		- The password to login with
//					aui_port			- The port to connect to
//					ab_passive		- Whether passive semantics should be used
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_flags
UInt lui_port

lui_port = aui_port
If lui_port = 0 Then
	lui_port = INTERNET_DEFAULT_FTP_PORT
End If

If ab_passive Then
	lul_flags = INTERNET_FLAG_PASSIVE
End If

il_session = InternetConnect(il_internet, as_servername, &
						lui_port, as_userid, as_password, &
						INTERNET_SERVICE_FTP, lul_flags, 0)

If IsNull(il_session) Or il_session = 0 Then
	Return of_GetLastError()
End If

Return True

end function

public function integer of_ftp_directory (ref s_ftpdirlist astr_dirlist[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_Directory
//
// PURPOSE:    This function returns a structure containing a list of files
//					and subdirectories on the FTP server.
//
// ARGUMENTS:  astr_dirlist	- By ref structure of files/dirs
//
// RETURN:		Number of directory entries found
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

WIN32_FIND_DATA lstr_FindData
ulong		lul_hFind
String	ls_null
Integer	li_file
Boolean	lb_morefiles = True

SetNull(ls_null)

lul_hFind = FtpFindFirstFile(il_session, ls_null, lstr_FindData, &
					INTERNET_FLAG_RAW_DATA + &
					INTERNET_FLAG_NO_CACHE_WRITE + &
					INTERNET_FLAG_RELOAD, 0)

If lul_hFind = 0 Then Return 0

DO WHILE lb_morefiles
	li_file = li_file + 1
	// get file name
	astr_dirlist[li_file].s_FileName = String(lstr_FindData.cfilename)
	astr_dirlist[li_file].s_AltFileName = String(lstr_FindData.calternatefilename)
	If Trim(astr_dirlist[li_file].s_AltFileName) = "" Then
		astr_dirlist[li_file].s_AltFileName = astr_dirlist[li_file].s_FileName
	End If
	// determine if this is a subdirectory
	astr_dirlist[li_file].b_subdir = of_checkbit(lstr_FindData.dwFileAttributes, 5)
	// get file date/time
	astr_dirlist[li_file].dt_CreationTime = &
		this.of_FileDateTimeToPB(lstr_FindData.ftCreationTime)
	astr_dirlist[li_file].dt_LastAccessTime = &
		this.of_FileDateTimeToPB(lstr_FindData.ftLastAccessTime)
	astr_dirlist[li_file].dt_LastWriteTime = &
		this.of_FileDateTimeToPB(lstr_FindData.ftLastWriteTime)
	// get file size
	astr_dirlist[li_file].db_FileSize = (lstr_FindData.nFileSizeHigh * (2.0 ^ 32)) + &
						lstr_FindData.nFileSizeLow
	// get file attributes
	astr_dirlist[li_file].ul_Attributes = lstr_FindData.dwFileAttributes
	// find next file
	lb_morefiles = InternetFindNextFile(lul_hFind, lstr_FindData)
LOOP

// close out directory handle
InternetCloseHandle(lul_hFind)

Return UpperBound(astr_dirlist[])

end function

public function boolean of_ftp_directoryexists (string as_dirname);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_DirectoryExists
//
// PURPOSE:    This function searches for a directory in the current working
//					directory on the FTP server to see if it exists.
//
// ARGUMENTS:  as_filename	- The name of the file
//
// RETURN:		True=Exists, False=Not Found
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

WIN32_FIND_DATA lstr_FindData
Constant ulong FILE_ATTRIBUTE_DIRECTORY = 16
ulong		lul_hFind
Boolean	lb_rtn

lul_hFind = FtpFindFirstFile(il_session, as_dirname, lstr_FindData, &
					INTERNET_FLAG_RAW_DATA + &
					INTERNET_FLAG_NO_CACHE_WRITE + &
					INTERNET_FLAG_RELOAD, 0)

If IsNull(lul_hFind) Or lul_hFind = 0 Then
	lb_rtn = False
Else
	// If the requested directory is the first one - we're done
	If lstr_FindData.dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY Then
		lb_rtn = True
	Else
		lb_rtn =  False
	End If
End If

// close out directory handle
InternetCloseHandle(lul_hFind)

Return lb_rtn

end function

public function boolean of_ftp_fileexists (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_FileExists
//
// PURPOSE:    This function searches for a file in the current working
//					directory on the FTP server to see if it exists.
//
// ARGUMENTS:  as_filename	- The name of the file
//
// RETURN:		True=Exists, False=Not Found
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

WIN32_FIND_DATA lstr_FindData
ulong		lul_hFind
Boolean	lb_rtn

lul_hFind = FtpFindFirstFile(il_session, as_filename, lstr_FindData, &
					INTERNET_FLAG_RAW_DATA + &
					INTERNET_FLAG_NO_CACHE_WRITE + &
					INTERNET_FLAG_RELOAD, 0)

If IsNull(lul_hFind) Or lul_hFind = 0 Then
	lb_rtn = False
Else
	// If the requested file is the first one - we're done
	If lstr_FindData.cfilename = as_filename Then
		lb_rtn = True
	Else
		lb_rtn =  False
	End If
End If

// close out directory handle
InternetCloseHandle(lul_hFind)

Return lb_rtn

end function

public function boolean of_ftp_getcurrentdirectory (ref string as_directory);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_GetCurrentDirectory
//
// PURPOSE:    Retrieves the current directory for the specified FTP session.
//
// ARGUMENTS:  as_directory	- The directory name ( by ref )
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_buflen

lul_buflen = 256

as_directory = Space(lul_buflen)

If Not FtpGetCurrentDirectory(il_session, as_directory, lul_buflen) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_getfile (string as_source, string as_target, boolean ab_ascii);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_GetFile
//
// PURPOSE:    Retrieves a file from the FTP server and stores it under the
//					specified file name, creating a new local file in the process.
//
// ARGUMENTS:  as_source	- The filename on the server
//					as_target	- The local filename
//					ab_ascii		- Use ASCII or Binary transfer
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Ulong lul_mode

// delete local file if it exists
If FileExists(as_target) Then
	FileDelete(as_target)
End If

// set transfer mode
If ab_ascii Then
	lul_mode = FTP_TRANSFER_TYPE_ASCII
Else
	lul_mode = FTP_TRANSFER_TYPE_BINARY
End If

If Not FtpGetFile(il_session, as_source, as_target, FALSE, 0, lul_mode, 0) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_putfile (string as_source, string as_target, boolean ab_ascii);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_PutFile
//
// PURPOSE:    Stores a file on the FTP server.
//
// ARGUMENTS:  as_source	- The local filename
//					as_target	- The filename on the server
//					ab_ascii		- Use ASCII or Binary transfer
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Ulong lul_mode

If ab_ascii Then
	lul_mode = FTP_TRANSFER_TYPE_ASCII
Else
	lul_mode = FTP_TRANSFER_TYPE_BINARY
End If

If Not FtpPutFile(il_session, as_source, as_target, lul_mode, 0) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_removedirectory (string as_directory);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_RemoveDirectory
//
// PURPOSE:    Removes the specified directory on the FTP server.
//
// ARGUMENTS:  as_directory	- The directory name
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If Not FtpRemoveDirectory(il_session, as_directory) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_renamefile (string as_filename, string as_newname);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_RenameFile
//
// PURPOSE:    Renames a file stored on the FTP server.
//
// ARGUMENTS:  as_filename	- The file being renamed
//					as_newname	- The new name for the file
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If Not FtpRenameFile(il_session, as_filename, as_newname) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_setcurrentdirectory (string as_directory);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_SetCurrentDirectory
//
// PURPOSE:    Changes to a different working directory on the FTP server.
//
// ARGUMENTS:  as_directory	- the directory to change to
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// 07/30/2013	RolandS		Added 'Not' to If statement
// -----------------------------------------------------------------------------

If Not FtpSetCurrentDirectory(il_session, as_directory) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_readfile (string as_source, string as_target, long al_window, long al_event);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_ReadFile
//
// PURPOSE:    This function reads a remote file and writes it locally. If a
//					window handle is passed, a percent done string is sent.
//					The al_event arg is 1023 + the pbm_custom## number.
//
// ARGUMENTS:  as_source	- The local filename
//					as_target	- The filename on the server
//					al_window	- Handle of the window
//					al_event		- Event number
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// 02/24/2014	RolandS		Added StopAction
// -----------------------------------------------------------------------------

Integer li_fnum
Boolean lb_loop
Long ll_sizelow
ULong lul_hFile, lul_bytesread, lul_bufsize
ULong lul_sizehigh, lul_totalread
Blob lblob_buffer

lul_bufsize = 2048
lb_loop = True
ib_StopAction = False

// open the remote file
lul_hFile = FtpOpenFile(il_session, as_source, &
					GENERIC_READ, FTP_TRANSFER_TYPE_BINARY, 0)
If lul_hFile > 0 Then
	// get the file size
	ll_SizeLow = FtpGetFileSize(lul_hFile, lul_SizeHigh)
	// open the local file
	li_fnum = FileOpen(as_target, StreamMode!, &
						Write!, LockReadWrite!, Replace!)
	do while lb_loop
		If ib_StopAction Then
			Exit
		End If
		lblob_buffer = Blob(Space(lul_bufsize))
		lb_loop = InternetReadFile(lul_hFile, lblob_buffer, &
							lul_bufsize, lul_bytesread)
		If lul_bytesread = 0 Then
			lb_loop = False
		Else
			If al_window > 0 Then
				lul_totalread += lul_bytesread
				Send(al_window, al_event, lul_totalread, ll_SizeLow)
			End If
			FileWrite(li_fnum, BlobMid(lblob_buffer, 1, lul_bytesread))
		End If
	loop
	InternetCloseHandle(lul_hFile)
	FileClose(li_fnum)
Else
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_readfile (string as_source, string as_target);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_ReadFile
//
// PURPOSE:    This function reads a remote file and writes it locally.
//
// ARGUMENTS:  as_source	- The local filename
//					as_target	- The filename on the server
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Return of_ftp_ReadFile(as_source, as_target, 0, 0)

end function

public function boolean of_ftp_readstring (string as_filename, ref string as_content);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_ReadString
//
// PURPOSE:    This function reads a remote file and returns it to
//					a string variable.
//
// ARGUMENTS:  as_filename	- The remote filename
//					as_content	- File contents ( by ref )
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Boolean lb_loop
ULong lul_hFile, lul_bytesread, lul_bufsize
Blob lblob_buffer
String ls_content

lul_bufsize = 2048
lb_loop = True
as_content = ""

// open the remote file
lul_hFile = FtpOpenFile(il_session, as_filename, &
					GENERIC_READ, FTP_TRANSFER_TYPE_ASCII, 0)
If lul_hFile > 0 Then
	do while lb_loop
		lblob_buffer = Blob(Space(lul_bufsize))
		lb_loop = InternetReadFile(lul_hFile, lblob_buffer, &
							lul_bufsize, lul_bytesread)
		If lul_bytesread = 0 Then
			lb_loop = False
		Else
			ls_content += String(BlobMid(lblob_buffer, 1, lul_bytesread), EncodingAnsi!)
		End If
	loop
	InternetCloseHandle(lul_hFile)
	as_content = ls_content
Else
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_writefile (string as_source, string as_target, long al_window, long al_event);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_WriteFile
//
// PURPOSE:    This function reads a local file and writes it remotely. If a
//					window handle is passed, a percent done string is sent.
//					The al_event arg is 1023 + the pbm_custom## number.
//
// ARGUMENTS:  as_source	- The local filename
//					as_target	- The filename on the server
//					al_window	- Handle of the window
//					al_event		- Event number
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// 02/24/2014	RolandS		Added StopAction
// -----------------------------------------------------------------------------

ULong lul_bufsize, lul_hFile
ULong lul_totalread, lul_bytesread, lul_byteswritten
Long ll_filesize
Longptr ll_LocalFile
Blob lblob_buffer
Boolean lb_loop

lul_bufsize = 2048
lb_loop = True
ib_StopAction = False

// open the local file
ll_LocalFile = CreateFile(as_source, GENERIC_READ, &
					FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
If ll_LocalFile > 0 Then
	// get the file size
	ll_filesize = FileLength(as_source)
	// open the remote file
	lul_hFile = FtpOpenFile(il_session, as_target, &
						GENERIC_WRITE, FTP_TRANSFER_TYPE_BINARY, 0)
	do while lb_loop
		If ib_StopAction Then
			Exit
		End If
		lblob_buffer = Blob(Space(lul_bufsize))
		lb_loop = ReadFile(ll_LocalFile, lblob_buffer, &
							lul_bufsize, lul_bytesread, 0)
		If lul_bytesread = 0 Then
			lb_loop = False
		Else
			If al_window > 0 Then
				lul_totalread += lul_bytesread
				Send(al_window, al_event, lul_totalread, ll_filesize)
			End If
			lb_loop = InternetWriteFile(lul_hFile, lblob_buffer, &
								lul_bytesread, lul_byteswritten)
		End If
	loop
	CloseHandle(ll_LocalFile)
	InternetCloseHandle(lul_hFile)
Else
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_ftp_writefile (string as_source, string as_target);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_WriteFile
//
// PURPOSE:    This function reads a local file and writes it remotely.
//
// ARGUMENTS:  as_source	- The local filename
//					as_target	- The filename on the server
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

Return of_ftp_WriteFile(as_source, as_target, 0, 0)

end function

public function boolean of_ftp_writestring (string as_filename, string as_content);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_WriteString
//
// PURPOSE:    This function writes a string to a file on the remote server.
//
// ARGUMENTS:  as_filename - The filename on the server
//					as_content	- The content of the file
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_buffer
ULong lul_bufsize, lul_hFile, lul_byteswritten
Long ll_pos, ll_max
Blob lblob_buffer
Boolean lb_rtn

lul_bufsize = 2048

// open the remote file
lul_hFile = FtpOpenFile(il_session, as_filename, &
					GENERIC_WRITE, FTP_TRANSFER_TYPE_ASCII, 0)
If lul_hFile > 0 Then
	ll_max = Len(as_content)
	For ll_pos = 1 To ll_max Step 2048
		ls_buffer = Mid(as_content, ll_pos, lul_bufsize)
		lblob_buffer = Blob(ls_buffer, EncodingAnsi!)
		lb_rtn = InternetWriteFile(lul_hFile, lblob_buffer, &
								Len(lblob_buffer), lul_byteswritten)
		If lb_rtn = False Then Exit
	Next
	InternetCloseHandle(lul_hFile)
Else
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_internetsetoption (unsignedlong aul_option, string as_value);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_InternetSetOption
//
// PURPOSE:    Sets an Internet option.
//
// ARGUMENTS:  aul_option	- The option to set
//					as_value		- The value to use
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If InternetSetOption(il_session, aul_option, as_value, Len(as_value)) Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_getlasterror ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_GetLastError
//
// PURPOSE:    This function gets the last error number and
//					returns descriptive error text.
//
// RETURN:		Always returns False so can be used on Return in calling function
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// 02/26/2014	RolandS		Changed to get error messages from wininet module.
// 04/24/2015	RolandS		Changed to get extended error information
// -----------------------------------------------------------------------------

Constant ULong ERROR_SUCCESS = 0
Constant ULong LANG_NEUTRAL = 0
Constant ULong FORMAT_MESSAGE_FROM_HMODULE = 2048
ULong lul_ErrorCode, lul_ExtError, lul_BufSize
String ls_Buffer

lul_ErrorCode = GetLastError()

choose case lul_ErrorCode
	case ERROR_SUCCESS
		ls_Buffer = "No error returned"
	case 12003
		// get response buffer size
		InternetGetLastResponseInfo(lul_ExtError, ls_Buffer, lul_BufSize)
		If lul_BufSize > 0 Then
			// get response
			ls_Buffer = Space(lul_BufSize + 1)
			InternetGetLastResponseInfo(lul_ExtError, &
							ls_Buffer, lul_BufSize)
		End If
	case 12038
		ls_Buffer = "Undefined WinINet Error"
	case else
		ls_Buffer = Space(255)
		FormatMessage(FORMAT_MESSAGE_FROM_HMODULE, GetModuleHandle("wininet.dll"), &
						lul_ErrorCode, LANG_NEUTRAL, ls_Buffer, Len(ls_Buffer), 0)
end choose

// save the error information
LastErrorMsg = Trim(ls_Buffer)
LastErrorNbr = lul_ErrorCode

If LastErrorNbr = ERROR_SUCCESS Then
	Return True
End If

Return False

end function

public function boolean of_ftp_internetconnect (string as_servername, unsignedinteger aui_port, boolean ab_passive);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Ftp_InternetConnect
//
// PURPOSE:    Opens an FTP session for a given site.
//
// ARGUMENTS:  as_servername	- The name of the remote server
//					aui_port			- The port to connect to
//					ab_passive		- Whether passive semantics should be used
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_null
ULong lul_flags
UInt lui_port

SetNull(ls_null)

lui_port = aui_port
If lui_port = 0 Then
	lui_port = INTERNET_DEFAULT_FTP_PORT
End If

If ab_passive Then
	lul_flags = INTERNET_FLAG_PASSIVE
End If

il_session = InternetConnect(il_internet, as_servername, &
						lui_port, ls_null, ls_null, &
						INTERNET_SERVICE_FTP, lul_flags, 0)

If IsNull(il_session) Or il_session = 0 Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_checkbit (long al_number, unsignedinteger ai_bit);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Checkbit
//
// PURPOSE:    This function determines if a certain bit is on or off within
//					the number.
//
// ARGUMENTS:  al_number	- Number to check bits
//             ai_bit		- Bit number ( starting at 1 )
//
// RETURN:		True = On, False = Off
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/22/2005	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If Int(Mod(al_number / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False

end function

public subroutine of_stopaction ();// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_StopAction
//
// PURPOSE:    This function causes of_Ftp_ReadFile and of_Ftp_WriteFile
//					to stop processing the current file.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 02/24/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ib_StopAction = True

end subroutine

public function boolean of_http_internetconnect (string as_servername, unsignedlong aul_port);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_Http_InternetConnect
//
// PURPOSE:    Opens an HTTP session for a given site.
//
// ARGUMENTS:  as_servername	- The host name of an Internet server.
//					aul_port			- The port to use for the connection.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

String ls_userid, ls_passwd

il_session = InternetConnect(il_internet, as_servername, aul_port, &
						ls_userid, ls_passwd, INTERNET_SERVICE_HTTP, 0, 0)

If IsNull(il_session) Or il_session = 0 Then
	Return of_GetLastError()
End If

Return True

end function

public function boolean of_internetclosehandle (ref longptr al_handle);// -----------------------------------------------------------------------------
// SCRIPT:     n_wininet.of_InternetCloseHandle
//
// PURPOSE:    Closes a single Internet handle.
//
// ARGUMENTS:  aul_handle	- Handle to be closed.
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/22/2009	RolandS		Initial Coding
// -----------------------------------------------------------------------------

If InternetCloseHandle(al_handle) Then
	al_handle = 0
	Return True
End If

Return of_GetLastError()

end function

on n_wininet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_wininet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// initialize the internet dll
this.Post Event ue_InternetOpen()

end event

event destructor;// close out the internet dll

this.of_RequestClose()
this.of_SessionClose()
this.of_InternetClose()

end event

