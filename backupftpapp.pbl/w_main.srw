forward
global type w_main from window
end type
type pb_confirmar from picturebutton within w_main
end type
type st_info from statictext within w_main
end type
type p_2 from picture within w_main
end type
type st_copyright from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type r_2 from rectangle within w_main
end type
end forward

global type w_main from window
integer width = 2839
integer height = 1096
boolean titlebar = true
string title = "BackupFtpApp"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
string icon = "AppIcon!"
boolean center = true
event ue_percent_download pbm_custom01
event ue_percent_upload pbm_custom02
pb_confirmar pb_confirmar
st_info st_info
p_2 p_2
st_copyright st_copyright
st_myversion st_myversion
st_platform st_platform
r_2 r_2
end type
global w_main w_main

type prototypes

end prototypes

type variables
Integer ii_FileLog
String is_mailLog, is_compressExtension
 
//Opciones Archivo Ini 
Integer ii_TotalDataBases
String is_ProgramMode // C/S (Cliente o Servidor)
String is_compress // S/N ( Si o NO a comprimir/descomprimir) 
String is_compressFormat //  Z/7/G/T (Zip, 7Zip, Gzip, Tar)
String is_ftp // S/N (Subir o Bajar de Servidor FTP) 
String is_ftp_FileMode //D/R (Download File o ReadFile)
String is_sendMail // S/N (Notificar por e-mail)
String is_RestoreOrBackup // S/N (Si o no a Copiar/restaurar Base de Datos)

Constant String is_ClientMode = "C"
Constant String is_ServerMode = "S"
Constant String is_DownloadFile = "D"
Constant String is_ReadFile = "R"
Constant String is_ZipFormat = "Z"
Constant String is_7zipFormat = "7"
Constant String is_GzipFormat = "G"
Constant String is_TarFormat = "T"

//Variables Ftp
String is_ftp_pass, is_ftp_user, is_ftp_server, is_localDir, is_remoteDir
Boolean ib_ftp_pasv, ib_ftp_ascii
Integer ii_ftp_port


end variables

forward prototypes
public subroutine wf_version ()
public subroutine wf_log (string as_msg)
public subroutine wf_backup_database (string as_filename, string as_database) throws n_ex
public subroutine wf_download (string as_filename) throws n_ex
public subroutine wf_compress (string as_filename, string as_compressfile) throws n_ex
public subroutine wf_connect_ftp (string as_server, string as_user, string as_pass) throws n_ex
public subroutine wf_extract (string as_compressfile) throws n_ex
public subroutine wf_disconnect_ftp ()
public subroutine wf_restore_database (string as_filename, string as_database) throws n_ex
public subroutine wf_upload (string as_filename) throws n_ex
public subroutine wf_closeapp ()
public subroutine wf_send_email (boolean ab_result) throws n_ex
public subroutine wf_server_process () throws n_ex
public subroutine wf_client_process () throws n_ex
end prototypes

event ue_percent_download;String ls_msg
Long ll_pos

ll_pos = wparam / lparam

ls_msg = "Descargando " + 	String(ll_pos, "#0%") + " completado."

st_info.text=ls_msg
Yield()


end event

event ue_percent_upload;String ls_msg
Long ll_pos

ll_pos = wparam / lparam

ls_msg = "Subiendo " + String(ll_pos, "#0%") + " completado."

st_info.text=ls_msg
Yield()

end event

public subroutine wf_version ();String ls_version, ls_platform
environment env
integer li_rtn

li_rtn = GetEnvironment(env)

IF li_rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

st_myversion.text=ls_version
st_platform.text=ls_platform

end subroutine

public subroutine wf_log (string as_msg);FileWrite(ii_FileLog, string(datetime(today(), now()), "dd-mm-yy hh:mm:ss")+": "+as_msg)
st_info.text=as_msg
is_mailLog=is_mailLog +"~r~n"+string(datetime(today(), now()), "dd-mm-yy hh:mm:ss")+": "+as_msg
end subroutine

public subroutine wf_backup_database (string as_filename, string as_database) throws n_ex;String ls_sql, ls_msg

gf_conectar(as_database)

ls_sql="BACKUP DATABASE " + as_database + " TO DISK = '" + gs_appdir + as_filename + "' WITH FORMAT" 	

ls_msg="Haciendo Backup "+as_database

wf_log(ls_msg)

SQLCA.AutoCommit = TRUE
EXECUTE IMMEDIATE :ls_sql USING SQLCA;

IF SQLCA.SQLCode<>0 THEN
	 ls_msg="Error haciendo el backup."
	 gf_throw(PopulateError(1, ls_msg))
END IF
	
ls_msg="Backup Completado en "+ gs_appdir + as_filename
wf_log(ls_msg)

DISCONNECT USING SQLCA;

end subroutine

public subroutine wf_download (string as_filename) throws n_ex;Integer li_rtn
String ls_arc_remoto, ls_arch_local, ls_ext, ls_msg
Boolean lb_result, lb_SetDir, lb_exist

ls_msg = "Bajando archivo "+as_filename
wf_log(ls_msg)

IF isnull(ib_ftp_ascii) THEN ib_ftp_ascii=FALSE// por si no se le ha dado valor 

IF  isnull(as_filename) or as_filename = "" THEN
	ls_msg =  "Error, nombre de archivo en blanco."
	gf_throw(PopulateError(1, ls_msg))
END IF

IF ChangeDirectory(is_localDir) = 1 THEN
	ls_msg = "Directorio Local="+is_localDir
	wf_log(ls_msg)
ELSE
	ls_msg ="Error cambiando directorio local a "+is_localDir
	gf_throw(PopulateError(2, ls_msg))
END IF	
	
lb_SetDir=gn_ftp.of_Ftp_SetCurrentDirectory(is_remoteDir)

IF lb_SetDir=FALSE THEN
	ls_msg ="Error al cambiar directorio remoto a "+is_remoteDir
	gf_throw(PopulateError(3, ls_msg))
ELSE
	ls_msg ="Directorio remoto = "+is_remoteDir
	wf_log(ls_msg)
END IF	

ls_arch_local=is_localDir +as_filename
ls_arc_remoto =as_filename //is_remoteDir+as_filename
	
lb_exist = FileExists(ls_arch_local)

// Si el ARCHIVO LOCAL existe informo de que se sobrescribe
IF lb_exist THEN
	ls_msg ="Archivo "+ls_arch_local+" existe, se sobreescribe."
	wf_log(ls_msg)
END IF	

IF is_ftp_FileMode = is_DownloadFile THEN
	lb_result = gn_ftp.of_Ftp_GetFile(ls_arc_remoto, ls_arch_local, ib_ftp_ascii)
ELSE
	lb_result = gn_ftp.of_Ftp_ReadFile(ls_arc_remoto, ls_arch_local, Handle(w_main), 1023 + 1)
END IF	

IF  lb_result THEN
	ls_msg =  "Archivo "+ls_arch_local+" Descargado."
	wf_log(ls_msg)
ELSE
	gn_ftp.of_GetLastError()
	ls_msg = "Error FTP:"+gn_ftp.LastErrorMsg
	gf_throw(PopulateError(4, ls_msg))
END IF	


	



end subroutine

public subroutine wf_compress (string as_filename, string as_compressfile) throws n_ex;String ls_msg, ls_compresslevel="BEST", ls_format="ZIP"
boolean lb_exist, lb_delete, lb_result
n_cst_compressor ln_compressor

IF ChangeDirectory(gs_appdir) = 1 THEN
	ls_msg = "Directorio Actual="+is_localDir
	wf_log(ls_msg)
ELSE
	ls_msg ="Error cambiando Directorio Actual a "+gs_appdir
	gf_throw(PopulateError(1, ls_msg))
END IF	

lb_exist = FileExists(gs_appdir + as_compressFile)
	
// Si el zip ya existe lo borro o da error ---------------------------------------------------------------------------
IF lb_exist=true THEN
	ls_msg="Archivo "+as_compressFile+" existe, se sobreescribe."
	wf_log(ls_msg)
	
	lb_delete=FileDelete(gs_appdir + as_compressFile)
	Sleep(2)
	
	if lb_delete=TRUE then
		ls_msg=as_compressFile+" Borrado con éxito."
		wf_log(ls_msg)
	else
		ls_msg="No se ha podido borrar "+as_compressFile+" se aborta proceso."
		gf_Throw(Populateerror(2, ls_msg))
	end if	
END IF	

ls_msg="Comprimiendo "+as_filename
wf_log(ls_msg)

ln_compressor =  CREATE n_cst_compressor
ln_compressor.of_compress(as_filename, gs_appdir + as_compressFile, gs_appdir, ls_compresslevel, ls_format)
Destroy ln_compressor

ls_msg=as_compressFile + " Generado con éxito."
wf_log(ls_msg)








end subroutine

public subroutine wf_connect_ftp (string as_server, string as_user, string as_pass) throws n_ex;String ls_msg
Boolean lb_sesion, lb_connect

ls_msg  = "Conectando con Servidor FTP "+as_server
wf_log(ls_msg)

lb_sesion=gn_ftp.of_internetopen()

IF lb_sesion=FALSE THEN
	ls_msg  = "Error al iniciar una sesión de FTP."
	gf_throw(PopulateError(1, ls_msg))
END IF

lb_connect=gn_ftp.of_Ftp_InternetConnect(as_server, as_user, as_pass, ii_ftp_port, ib_ftp_pasv)

IF lb_connect=FALSE THEN
	ls_msg  = "Error al conectarse al servidor FTP."
	gf_throw(PopulateError(1, ls_msg))
END IF

ls_msg  = "Conectado con éxito."
wf_log(ls_msg)




end subroutine

public subroutine wf_extract (string as_compressfile) throws n_ex;String ls_msg
Boolean lb_exist, lb_delete, lb_result
n_cst_compressor ln_compressor

IF ChangeDirectory(gs_appdir) = 1 THEN
	ls_msg = "Directorio Actual="+is_localDir
	wf_log(ls_msg)
ELSE
	ls_msg ="Error cambiando Directorio Actual a "+gs_appdir
	gf_throw(PopulateError(1, ls_msg))
END IF	

lb_exist = FileExists(gs_appdir + as_compressFile)

//Si el rar no existe aborto
IF lb_exist=FALSE THEN
	ls_msg="Archivo "+as_compressFile+" no existe."
	wf_log(ls_msg)
	gf_Throw(Populateerror(2, ls_msg))
END IF	

ls_msg="Descomprimiendo "+as_compressFile
wf_log(ls_msg)

ln_compressor =  CREATE n_cst_compressor
ln_compressor.of_extract(gs_appdir+ as_compressFile)
Destroy ln_compressor





	
	

		
end subroutine

public subroutine wf_disconnect_ftp ();String ls_msg

gn_ftp.of_sessionclose()
gn_ftp.of_internetclose()

ls_msg = "Cierre sesión FTP"
wf_log(ls_msg)

end subroutine

public subroutine wf_restore_database (string as_filename, string as_database) throws n_ex;String ls_sql, ls_msg
Boolean lb_exist

lb_exist = FileExists(as_filename)
	
// Si no existe el archivo de backup aborto
IF lb_exist=FALSE THEN
	 ls_msg="Archivo de backup "+as_filename+" no existe, no se puede reataurar la base de datos "+as_database+"."
	 gf_throw(PopulateError(1, ls_msg))
END IF	

gf_conectar("master")

ls_sql="RESTORE DATABASE " + as_database + " FROM DISK = '" + gs_appdir+as_filename + "'"

ls_msg="Restaurando "+as_database+" de backup "+ gs_appdir+as_filename
wf_log(ls_msg)

SQLCA.AutoCommit = TRUE
EXECUTE IMMEDIATE :ls_sql USING SQLCA;

IF SQLCA.SQLCode<>0 THEN
	 ls_msg="Error Restaurando "+gs_appdir+as_filename
	 gf_throw(PopulateError(1, ls_msg))
END IF
	
ls_msg="La Restauración se ha completado con éxito." 
wf_log(ls_msg)
	
DISCONNECT USING SQLCA;

end subroutine

public subroutine wf_upload (string as_filename) throws n_ex;integer li_rtn
string ls_arc_remoto, ls_arch_local, ls_ext, ls_msg
boolean lb_result, lb_SetDir, lb_exist

ls_msg = "Bajando archivo "+as_filename
wf_log(ls_msg)

IF isnull(ib_ftp_ascii) THEN ib_ftp_ascii=FALSE// por si no se le ha dado valor 


IF  isnull(as_filename) or as_filename = "" THEN
	ls_msg =  "Error, nombre de archivo en blanco."
	gf_throw(PopulateError(1, ls_msg))
END IF
	
IF ChangeDirectory(is_localDir) = 1 THEN
	ls_msg = "Directorio Local="+is_localDir
	wf_log(ls_msg)
ELSE
	ls_msg ="Error cambiando directorio local a "+is_localDir
	gf_throw(PopulateError(2, ls_msg))
END IF	
	
lb_SetDir=gn_ftp.of_Ftp_SetCurrentDirectory(is_remoteDir)

IF lb_SetDir=FALSE THEN
	ls_msg ="Error al cambiar directorio remoto a "+is_remoteDir
	gf_throw(PopulateError(3, ls_msg))
ELSE
	ls_msg ="Directorio remoto = "+is_remoteDir
	wf_log(ls_msg)
END IF
	
ls_arch_local=is_localDir+as_filename
ls_arc_remoto =as_filename //is_remoteDir+as_filename
	

lb_exist = FileExists(ls_arch_local)

// Si el ARCHIVO LOCAL no existe aborto
IF NOT lb_exist THEN
	ls_msg = "Archivo "+ls_arch_local+" no existe, no se puede subir."
	gf_throw(PopulateError(4, ls_msg))
END IF	

IF is_ftp_FileMode = is_DownloadFile THEN
	lb_result = gn_ftp.of_ftp_putfile(ls_arch_local, ls_arc_remoto, ib_ftp_ascii)
ELSE
	lb_result =gn_ftp.of_Ftp_WriteFile(ls_arc_remoto, ls_arch_local, Handle(w_main), 1023 + 2)
END IF

IF  lb_result THEN
	ls_msg =  "Archivo "+ls_arch_local+" Transferido correctamente en "+ls_arc_remoto
	wf_log(ls_msg)
ELSE
	gn_ftp.of_GetLastError()
	ls_msg = "Error FTP:"+gn_ftp.LastErrorMsg
	gf_throw(PopulateError(5, ls_msg))
END IF	



	
end subroutine

public subroutine wf_closeapp ();FileClose(ii_FileLog)
sleep(5)
Close(this)
end subroutine

public subroutine wf_send_email (boolean ab_result) throws n_ex;String ls_subject, ls_body, ls_Send_mail, ls_send_name, ls_resultado
String ls_adjuntos[]
String ls_result, ls_log, ls_textoError,  ls_textoExito, ls_textoModo
String ls_userid, ls_hostname
String is_Database

//Obtengo el Log para el Mail
ls_body = is_mailLog

ls_log ="Envío " +ls_subject+ " por Mail..."
wf_log(ls_log)

ls_userid = gn_ws.of_getuserid()
ls_hostname = gn_ws.of_gethostname()
ls_Send_mail=ProfileString(gs_inifile, "MAIL", "email", "")
ls_send_name=ProfileString(gs_inifile, "MAIL", "name", "")

IF ab_result = TRUE THEN
	ls_textoError = ""
	ls_textoExito = " con éxito."
ELSE
	ls_textoError = "Error "
	ls_textoExito = "."
END IF	

IF is_ProgramMode="C" THEN
	ls_textoModo = "Restauración"
ELSE
	ls_textoModo = "Copia de Seguridad"
END IF

ls_subject=ls_textoError+ls_textoModo+" Base de Datos"+ls_textoExito
ls_body="Usuario: "+ls_userid+"~r~n"+"Puesto: "+ls_hostname+ "~r~n"+ "Log:"+"~r~n"+ls_body
	
gf_system_mail(ls_subject, ls_body, ls_send_name, ls_Send_mail)

ls_log ="Mensaje Enviado a "+ls_Send_mail+ " !"
wf_log(ls_log)



end subroutine

public subroutine wf_server_process () throws n_ex;String ls_iniSection, ls_fileName, ls_CompressFileName, ls_dataBase
Integer li_Database

IF is_RestoreOrBackup="S" THEN
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		wf_backup_database(ls_fileName, ls_dataBase)
	NEXT
END IF

IF is_compress="S" THEN 
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		ls_CompressFileName = gf_getfilenamewithoutextension(ls_fileName)+is_compressExtension
		wf_compress(ls_fileName, ls_CompressFileName)
	NEXT
END IF

IF is_ftp ="S"  THEN 
	wf_connect_ftp(is_ftp_server, is_ftp_user, is_ftp_pass)
	sleep(1)
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		if is_compress="S" then 
			ls_CompressFileName = gf_getfilenamewithoutextension(ls_fileName)+is_compressExtension
			wf_upload(ls_CompressFileName)
		else
			wf_upload(ls_fileName)
		end if	
	NEXT
	wf_disconnect_ftp()
END IF
end subroutine

public subroutine wf_client_process () throws n_ex;String ls_iniSection, ls_fileName, ls_CompressFileName, ls_dataBase
Integer li_Database

IF is_ftp ="S" THEN
	wf_connect_ftp(is_ftp_server, is_ftp_user, is_ftp_pass)
	sleep(1)
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		if is_compress="S" then 
			ls_CompressFileName = gf_getfilenamewithoutextension(ls_fileName)+is_compressExtension
			wf_download(ls_CompressFileName)
		else
			wf_download(ls_fileName)
		end if	
	NEXT
	wf_disconnect_ftp()
END IF

IF is_compress="S" THEN 
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_CompressFileName = gf_getfilenamewithoutextension(ls_fileName)+is_compressExtension
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		wf_extract(ls_CompressFileName)
	NEXT
END IF	

IF is_RestoreOrBackup="S" THEN
	FOR li_Database = 1 TO ii_TotalDataBases
		ls_iniSection = "Database"+string(li_Database)
		ls_fileName = ProfileString(gs_inifile, ls_iniSection, "filename", "")
		ls_dataBase = ProfileString(gs_inifile, ls_iniSection, "Database", "")
		wf_restore_database(ls_fileName, ls_dataBase)
	NEXT
END IF	
end subroutine

on w_main.create
this.pb_confirmar=create pb_confirmar
this.st_info=create st_info
this.p_2=create p_2
this.st_copyright=create st_copyright
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.r_2=create r_2
this.Control[]={this.pb_confirmar,&
this.st_info,&
this.p_2,&
this.st_copyright,&
this.st_myversion,&
this.st_platform,&
this.r_2}
end on

on w_main.destroy
destroy(this.pb_confirmar)
destroy(this.st_info)
destroy(this.p_2)
destroy(this.st_copyright)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.r_2)
end on

event open;String ls_log

is_localDir=gs_appdir
wf_version()

ii_FileLog = FileOpen(gs_appdir+"log.txt", LineMode!, Write!, LockWrite!, Append!)

//[SETUP]
ii_TotalDataBases = ProfileInt(gs_inifile, "SETUP", "Databases ", 0)

IF ii_TotalDataBases = 0 THEN
	ls_log= "No hay Bases de Datos Configuradas."
	wf_log(ls_log)
	wf_closeApp()
	RETURN
END IF	

//[FTP]
is_ftp_user = ProfileString(gs_inifile, "FTP", "Userid", "")
is_ftp_pass =  gn_seg.of_decrypt( ProfileString(gs_inifile, "FTP", "Password", ""))
is_ftp_server = ProfileString(gs_inifile, "FTP", "Server", "") 
ii_ftp_port = ProfileInt(gs_inifile, "FTP", "Port", 21) 
is_remoteDir=ProfileString(gs_inifile, "FTP", "InitialDirectory", "//")
ib_ftp_pasv=gf_iif(ProfileString(gs_inifile, "FTP", "Pasive", "N")="N", FALSE, TRUE)
ib_ftp_ascii=gf_iif(ProfileString(gs_inifile, "FTP", "Ascii", "N")="N", FALSE, TRUE)

//[OPTIONS]
is_ProgramMode= upper(ProfileString(gs_inifile, "OPTIONS", "ProgramMode", "S"))   //S=Servidor  C=Cliente
is_compress= upper(ProfileString(gs_inifile, "OPTIONS", "Compress", "S"))  //S o N para comprimir/descomprimir
is_compressFormat= upper(ProfileString(gs_inifile, "OPTIONS", "CompressFormat", "Z"))  //Zip por defecto, o Rar

Choose Case is_compressFormat 
	Case is_7zipFormat
		is_compressExtension = ".7zip"
	Case is_GzipFormat
		is_compressExtension = ".gzip"
	Case is_TarFormat
		is_compressExtension = ".tar"
	Case else	
		is_compressExtension = ".zip"
End Choose

is_ftp_FileMode= upper(ProfileString(gs_inifile, "OPTIONS", "Ftp_FileMode", "D")) //Download por defecto
is_ftp= upper(ProfileString(gs_inifile, "OPTIONS", "Ftp", "S"))
is_RestoreOrBackup=upper(ProfileString(gs_inifile, "OPTIONS", "RestoreOrBackup", "S"))
is_sendMail=upper(ProfileString(gs_inifile, "OPTIONS", "SendMail", "S"))

Timer(1)








end event

event closequery;
end event

event timer;Timer(0)
pb_confirmar.triggerevent(clicked!)


end event

type pb_confirmar from picturebutton within w_main
boolean visible = false
integer x = 1211
integer y = 748
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
string text = "Confirmar"
boolean originalsize = true
vtextalign vtextalign = vcenter!
long textcolor = 16777215
long backcolor = 33521664
end type

event clicked;String ls_comando, ls_log


//************************************************************************************
// PROGRAMA BACKUP / RESTORE
//	SE PUEDE CONFIGRAR EN MODO CLIENTE O SERVIDOR PARA CREAR Y SUBIR BACKUP O BAJAR Y RESTAURAR.
//************************************************************************************

Try
	IF 	is_ProgramMode = is_ServerMode THEN
		wf_server_process()
	ELSE
		wf_client_process()
	END IF
	
	ls_comando=upper(ProfileString(gs_inifile, "OPTIONS", "CMD", ""))

	IF ls_comando <> "" THEN
		ls_log = "Ejecutando Comando: "+ls_comando
		wf_log(ls_log)
		run(ls_comando, Minimized!) 
	END IF
	
	IF is_sendMail="S" THEN wf_send_email(TRUE)
	
Catch(n_ex ln_ex)
	ls_log = ln_ex.of_get_error()
	wf_log(ls_log)
	IF is_sendMail="S" THEN wf_send_email(FALSE)
End Try

wf_closeApp()

end event

type st_info from statictext within w_main
integer x = 55
integer y = 516
integer width = 2738
integer height = 84
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 33160918
string text = "Desconectado"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_2 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type st_copyright from statictext within w_main
integer x = 1518
integer y = 916
integer width = 1289
integer height = 52
integer textsize = -7
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 2249
integer y = 56
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 2249
integer y = 144
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 2821
integer height = 260
end type

