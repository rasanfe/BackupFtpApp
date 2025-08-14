forward
global type n_cst_seguridad from nonvisualobject
end type
end forward

global type n_cst_seguridad from nonvisualobject
end type
global n_cst_seguridad n_cst_seguridad

forward prototypes
public function string of_encrypt (string as_source)
public function string of_decrypt (string as_source)
private subroutine of_get_token (ref string as_key, ref string as_iv)
end prototypes

public function string of_encrypt (string as_source);/*********************************************************************
Object:			n_cst_seguridad
Function:			of_encrypt( /*string as_source */)
Access:			public
Description:		Encrypts and Encode a string
Arguments:		string as_surce
Return:			string ls_encoded
......................................................................
History:
Date			Who	Ramón San Félix
29-12-2022	reb	Initial version.
19-04-2023 reb		Modifico para poder hacer la misma encriptación en la API
*********************************************************************/

coderobject ln_coderobject
crypterobject ln_crypterobject
String ls_encoded
String ls_encrypted
String ls_key, ls_IV
Blob lblb_data, lblb_key, lblb_iv, lblb_Encrypted
Encoding lEncoding = EncodingUTF8!

If trim(as_source)="" then return ""

//Obtenemos las Claves del Archivo INI
of_get_token(REF ls_key, REF ls_IV)

//1- Encryp as_source 
lblb_data = Blob(as_source, lEncoding)
lblb_key  = Blob(ls_key, lEncoding)
lblb_iv    = Blob(ls_IV, lEncoding)

ln_crypterobject = Create crypterobject	
lblb_Encrypted = ln_crypterobject.SymmetricEncrypt(AES!, lblb_data, lblb_key, OperationModeCBC!, lblb_iv, PKCSPadding! )
destroy ln_crypterobject
	
//2- Encode ls_encrypted
ln_coderobject = Create coderobject
ls_encoded = ln_coderobject.Base64URLEncode(lblb_Encrypted)
destroy ln_coderobject


RETURN ls_encoded

end function

public function string of_decrypt (string as_source);/*********************************************************************
Object:			n_cst_seguridad
Function:			of_decrypt
Access:			public
Description:		decode and decrypt a string
Arguments:		string as_source
Return:			string
......................................................................
History:
Date			Who	Ramón San Félix Ramón
29-12-2022	reb	Initial version.
19-04-2023 reb		Modifico para poder hacer la misma encriptación en la API
*********************************************************************/

coderobject ln_coderobject
crypterobject ln_crypterobject
String ls_decode
String ls_decrypted
String ls_key, ls_IV
Encoding lEncoding = EncodingUTF8!
Blob lblb_data, lblb_key, lblb_iv, lblb_Decrypted

If trim(as_source)="" then return ""

//Obtenemos las Claves del Archivo INI
of_get_token(REF ls_key, REF ls_IV)

//1- Decode as_source
ln_coderobject = Create coderobject
lblb_data = ln_coderobject.Base64URLDecode(as_source)
destroy ln_coderobject

//2- Decryp ls_decode 
lblb_key  = Blob(ls_key, lEncoding)
lblb_iv    = Blob(ls_IV, lEncoding)

ln_crypterobject = Create crypterobject
lblb_Decrypted = ln_crypterobject.SymmetricDecrypt(AES!, lblb_data, lblb_key, OperationModeCBC!, lblb_iv, PKCSPadding!)
destroy ln_crypterobject

ls_decrypted = String(lblb_Decrypted, lEncoding)

RETURN ls_decrypted
end function

private subroutine of_get_token (ref string as_key, ref string as_iv);//Funcion para recuperar Clave y Vector de iniciación de archivo INI. La información está almacenada encriptada en un json. {"key":"clave", "IV":"vector"}
coderobject ln_coderobject
crypterobject ln_crypterobject
String ls_key, ls_IV, ls_token, ls_json
Blob  lb_json_decoded, lb_json_decrypted, lblb_key, lblb_iv
Encoding lEncoding = EncodingUTF8!
JsonParser lnv_JsonParser
Long ll_RootObject, ll_item

//Leemos el Token del Archivo INI
ls_token =ProfileString(gs_inifile, "SETUP", "token", "")

ls_key =  "EncriptadorRSR"
ls_key = ls_key + fill("*", 16 - len(ls_key))

ls_IV = "IV25042023"
ls_IV = ls_IV + fill("0", 16 - len(ls_IV))

//1- Decode as_source
ln_coderobject = Create coderobject
lb_json_decoded = ln_coderobject.Base64URLDecode(ls_token)
destroy ln_coderobject

//2- Decryp ls_decode 
ln_crypterobject = Create crypterobject

lblb_key  = Blob(ls_key, lEncoding)
lblb_iv    = Blob(ls_IV, lEncoding)
	
lb_json_decrypted= ln_crypterobject.SymmetricDecrypt(AES!, lb_json_decoded, lblb_key, OperationModeCBC!, lblb_iv, PKCSPadding!)
	
ls_json = String(lb_json_decrypted, lEncoding)

destroy ln_crypterobject

//3-Parseamos el Json Recibido en el Token.
lnv_JsonParser = Create JsonParser

lnv_JsonParser.LoadString(ls_Json)
ll_RootObject = lnv_JsonParser.GetRootItem()

as_key = lnv_JsonParser.GetItemString(ll_RootObject, "key")
as_IV =lnv_JsonParser.GetItemString(ll_RootObject, "IV")

//Retorno por Referencia Key y IV con tamaños corregidos.
as_key = as_key + fill("*", 16 - len(as_key))
as_IV = as_IV + fill("0", 16 - len(as_IV))

destroy lnv_JsonParser

end subroutine

on n_cst_seguridad.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_seguridad.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

