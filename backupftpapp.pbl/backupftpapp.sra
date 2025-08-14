//objectcomments Generated Application Object
forward
global type backupftpapp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String gs_appdir

//Objetos de Topwiz
n_winsock gn_ws
n_wininet gn_ftp

//30-01-2017 Añado Gestion Documental
String gs_inifile="setup.ini"

String gs_LogId, gs_LogPass, gs_serverName


//Para manejar la Seguridad de la App
n_cst_seguridad gn_seg

end variables

global type backupftpapp from application
string appname = "backupftpapp"
integer highdpimode = 0
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 25.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "icono.ico"
string appruntimeversion = "25.0.0.3711"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
end type
global backupftpapp backupftpapp

type prototypes
//Funcion para tomar el directorio de la aplicacion
FUNCTION	uLong	GetModuleFileName ( uLong lhModule, ref string sFileName, ulong nSize )  LIBRARY "Kernel32.dll" ALIAS FOR "GetModuleFileNameW"
end prototypes

on backupftpapp.create
appname="backupftpapp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on backupftpapp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event systemerror;string ls_error

ls_error = ":ERROR: " + string(error.number) + "   " + error.text +char(13)
ls_error +=":------------------------------------------------------------------------"+char(13)
ls_error +=":Ventana/Menu: " + error.windowmenu +char(13)
ls_error +=":Objeto      : " + error.object+char(13)
ls_error +=":Evento      : " + error.objectevent+char(13)
ls_error +=":Nº de Linea : " + String(error.line)
	
messagebox("Error Sistema", ls_error, stopsign!)
halt close;
end event

event open;//obtener direcorio aplicacion
string ls_Path
unsignedlong lul_handle

ls_Path = space(1024)
SetNull(lul_handle)
GetModuleFilename(lul_handle, ls_Path, len(ls_Path))

if right(UPPER(ls_path), 7)="225.EXE" or right(UPPER(ls_path), 7)="X64.EXE" then
	ls_path=GetCurrentDirectory()+"\backupftpapp.exe"
end if


gs_appdir=left(ls_path, len(ls_path) - 16)
gs_inifile = gs_appdir+"setup.ini" 

 //Para manejar la Seguridad de la App
gn_Seg = CREATE n_cst_seguridad

//Creamos y inicialimaos el Objeto Winsock de Topwiz
gn_ws = Create n_winsock

// Initialize Winsock
If Not gn_ws.of_Startup() Then
	MessageBox("gn_ws.of_Startup() Failed",	gn_ws.of_GetLastError(), Exclamation!)
	Return
End If


open(w_main)


end event

event close;Destroy gn_ws

end event

