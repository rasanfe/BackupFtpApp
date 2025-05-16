forward
global type n_cst_compressor from nonvisualobject
end type
end forward

global type n_cst_compressor from nonvisualobject
end type
global n_cst_compressor n_cst_compressor

forward prototypes
public subroutine of_extract (string as_zipfile) throws n_ex
public subroutine of_compress (string as_file, string as_zipfile, string as_path, string as_compresslevel, string as_format) throws n_ex
end prototypes

public subroutine of_extract (string as_zipfile) throws n_ex;Integer li_resultCode
String ls_result
String ls_dir

ls_dir=getcurrentdirectory()
if right(ls_dir, 1)<>"\" then ls_dir=ls_dir+"\"

ExtractorObject extractorObject
extractorObject = CREATE ExtractorObject

li_resultCode = extractorObject.extract( as_zipfile, ls_dir)

CHOOSE CASE li_resultCode 
	CASE 1 	
		ls_result="Success"
	CASE -1
		ls_result="A general error occurred"
	CASE -2
		ls_result="The password entered is illegal"
	CASE -3
		ls_result="The operation is not supported for the source file format"
	CASE -4
		ls_result="The task thread is aborted"
	CASE -5
		ls_result="A task thread is currently running"
	CASE -6
		ls_result=" No password is entered. You must enter the password"
	CASE -7
		ls_result="The password is incorrect"
	CASE -8
		ls_result="Failed to get new memory when saving the decompressed file"
	CASE -9
		ls_result="Failed to read the compressed file"
	CASE -10
		ls_result="Unrecognized format or the encrypted file name option is used when compressing the document"
	CASE -11
		ls_result="Access denied when extracting the archive"
	CASE -12
		ls_result="The compressed file does not exist"
	CASE -13
		ls_result="The directory where the decompressed file will be saved does not exist"
	CASE -14
		ls_result="Failed to extract the compressed file"
END CHOOSE 

IF li_resultCode <> 1 THEN
	gf_throw(PopulateError(1, ls_result))
END IF


end subroutine

public subroutine of_compress (string as_file, string as_zipfile, string as_path, string as_compresslevel, string as_format) throws n_ex;string ls_pathname[]
Integer li_Result
String ls_result
ArchiveFormat compressFormat

//Creamos el Objeto Compresor
CompressorObject  compressorObject
CompressorObject = CREATE CompressorObject

//Nueva Forma de Comprimir en Pw2019
CHOOSE CASE as_compresslevel 
	CASE "STORE"
		compressorObject.level = CompressionLevelStore!
	CASE "FASTEST"
		compressorObject.level = CompressionLevelFastest!
	CASE "FAST"
		compressorObject.level = CompressionLevelFast!
	CASE "MAXIMUM"
		compressorObject.level = CompressionLevelMaximum!
	CASE "BEST"
		compressorObject.level = CompressionLevelBest!
	CASE ELSE
		compressorObject.level = CompressionLevelNormal!
END CHOOSE

CHOOSE CASE UPPER(as_format)
	CASE ".7ZIP"
		compressFormat = ArchiveFormat7ZIP!
	CASE ".GZIP"
		compressFormat = ArchiveFormatGZIP!
	CASE ".TAR"
		compressFormat = ArchiveFormatTAR!
	//CASE ".RAR"
	//	compressFormat = ArchiveFormatRAR!  //Only for ExtractorObject
	//CASE ".LZMA"
	//	compressFormat = ArchiveFormatLzma!  //Only for ExtractorObject
	//CASE ".LZMA86"
	//	compressFormat= ArchiveFormatLzma86!	 //Only for ExtractorObject	 
	CASE ELSE
		compressFormat = ArchiveFormatZIP!
END CHOOSE

compressorObject.password = ""
ls_pathname[1]=as_path+as_file
li_result=compressorObject.compress( ls_pathname[], as_ZIPfile,  compressFormat)

CHOOSE CASE li_result
	CASE 1		
		ls_result="Success"
	CASE -1
		ls_result="A general error occurred. If the CompressorObject object is used in asynchronous mode, this function will return the general error"
	CASE -2
		ls_result="The password entered is illegal"
	CASE -3
		ls_result="The operation is not supported for the source file format"
	CASE -4
		ls_result="The task thread is aborted"
	CASE -5
		ls_result="A task thread is currently running"
	CASE -6
		ls_result="The folder to be compressed does not exist"
	CASE -7
		ls_result="The folder to be compressed is empty"
	CASE -8
		ls_result="The compression format does not support multi-file compression"
	CASE -9
		ls_result="Failed to read file from the folder for compression"
	CASE -10
		ls_result=" The target path does not exist"
	CASE -11
		ls_result="More than one source file has the same file name"
	CASE -12
		ls_result="Invalid compressed file name or no compressed file name is specified in the 'dest' argument"
	CASE -13
		ls_result=" Failed to compress"
END CHOOSE

IF li_result <> 1 THEN
	gf_throw(PopulateError(1, ls_result))
END IF


end subroutine

on n_cst_compressor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_compressor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

