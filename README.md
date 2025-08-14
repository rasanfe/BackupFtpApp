# BackupFtpApp
Copias de Seguridad FTP en PowerBuilder y MSQLServer.

Básicamente es una aplicación pensada para que se ejecute automáticamente programando una tarea de Windows que la dispare a la hora que nos interese. Se puede programar en un servidor para que realice las copias de seguridad, y en otro ordenador para que se las descargue y las restaure.

He intentado poner unas cuantas opciones para que se versátil, todas se parametrizan en un archivo .ini

[SETUP]

Databases --> Para indicar el nº de bases de datos que vamos a Copiar/Restaurar (1,2,3...)

LogId--> Usuario, para la conexión SQLServer.

 LogPass--> Clave Encriptada para la conexión SQLServer.

serverName --> Servidor para la conexión SQLServer, para mas opciones se puede modificar la función gf_conectar(as_database).

token --> Token generado con el programa EncryptGenerator para almacenar la clave de desencriptación. Hay que usar ese programa para generar las claves encriptadas del correo electrónico y del servidor FTP.

[Database1] --> Por cada base de datos que queramos copiar/restaurar hay que crear una clave.

Database --> Nombre de la base de datos, ejemplo: AdventureWorks2012

filename --> Nombre del archivo generado, ejemplo: AW2012.bak

[MAIL] --> Configuración opcional si queremos enviar e-mails con los resultados.

Server --> Servidor e-mail 

Userid --> Usuario cuenta e-mail.

Password --> Clave  Encriptada cuenta e-mail.

email --> E-mail del Destinatario.

name --> Nombre del Destinatario.

[FTP] --> Configuración Opcional si queremos subir/descargar la copias de un servidor FTP.

Server --> Dirrección FTP

Port ---> Puerto (Normalmente el 21)

Userid --> Usuario cuenta FTP

Password --> Clave Encriptada cuenta FTP

InitialDirectory --> Directorio inicial FTP, poner // si no hay que entrar en ninguno.

Pasive --> Para indicar si es servidor es Pasivo(Y/N), de lo contrario es Activo.

Ascii --> Tipo transferencia Ascii (Y/N) de lo contrario es Binaria.


[OPTIONS] --> Opciones de Parametrización.

ProgramMode --> Como se comportará el programa: Cliente o Servidor (C/S)

Compress --> Si queremos comprimir las copias, o las que queramos restaurar están comprimidas (S/N).

CompressFormat --> Formato de Compresión  a elegir Zip, 7Zip, Gzip, Tar (Z/7/G/T)

Ftp --> Si queremos subir o bajar las copias de seguridad a un Servidor FTP (S/N)

Ftp_FileMode --> Modo en que se suben o bajan los Archivos. (R/D). R usa las funciones FileRead y FileWrite. Si elegimos D, se usan las funciones GetFile y PutFile.

SendMail --> Si queremos enviar un e-mail con los resultados (S/N)

RestoreOrBackup --> Si queremos que haga la Copia o Restaure (S/N)

CMD --> Se puede indicar la ruta de un archivo .bat para ejecutar algún comando adicional al final del todo.


Para estar al tanto de lo que publico puedes seguir mi blog:

https://rsrsystem.blogspot.com/
