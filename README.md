# 💾 BackupFtpApp

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-orange?style=flat-square&logo=sap&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-backup-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![FTP](https://img.shields.io/badge/transferencia-FTP-1F6FEB?style=flat-square&logo=files&logoColor=white)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

> Copias de seguridad de **SQL Server**, comprimidas, subidas por **FTP** y avisando por **correo**… todo desatendido y parametrizable desde un `.ini`. 🤖

---

## 📋 ¿Qué es esto?

**BackupFtpApp** es una aplicación pensada para **ejecutarse sola**: la programáis como
**tarea de Windows** a la hora que os interese y se encarga del resto. La idea típica es
tenerla en **dos sitios**:

- En el **servidor** → genera las copias de seguridad (y opcionalmente las sube a un FTP).
- En **otro equipo** → se las descarga del FTP y las **restaura**.

Está pensada para ser versátil: comprime en varios formatos, sube/baja por FTP (activo o
pasivo, ascii o binario), envía correos con el resultado e incluso lanza un `.bat` final
si lo necesitáis. Y lo bueno: **no se toca el código para cambiar su comportamiento**, todo
se controla desde un fichero **`.ini`**.

## ✨ Cómo funciona

Por dentro reúne unas cuantas piezas reutilizables, todas en PowerBuilder:

- **`n_cst_compressor`** — comprime y extrae copias en **Zip, 7Zip, Gzip o Tar**.
- **`n_cst_seguridad`** — descifra (AES) las contraseñas guardadas en el `.ini`. Aquí entra
  en juego el token: las claves sensibles **nunca van en claro** (ver más abajo).
- **`n_wininet` / `n_winsock`** — el músculo para la transferencia **FTP**.
- **`nvo_smtpclient`** — el envío de **correos** con el resultado (con adjuntos, TLS, etc.).
- **`gf_conectar`** — la conexión a **SQL Server**, fácilmente adaptable si necesitáis más
  opciones de cadena de conexión.

> 🔐 **Las contraseñas van cifradas.** El `LogPass`, el `Password` del correo y el del FTP
> se guardan **encriptados**. Para generarlos usáis el ejemplo hermano
> [**EncryptGenerator**](https://github.com/rasanfe/EncryptGenerator), que también os crea
> el `token` que va en la sección `[SETUP]`.

## ⚙️ Configuración: el archivo `.ini`

Todo se parametriza aquí. Estas son las secciones y sus claves:

### `[SETUP]`
| Clave | Descripción |
|-------|-------------|
| `Databases` | Nº de bases de datos a copiar/restaurar (1, 2, 3…). |
| `LogId` | Usuario para la conexión a SQL Server. |
| `LogPass` | Clave **encriptada** para la conexión a SQL Server. |
| `serverName` | Servidor SQL Server (para más opciones, retoca `gf_conectar(as_database)`). |
| `token` | Token generado con **EncryptGenerator** que guarda la clave de descifrado. Hay que usarlo para generar las claves encriptadas del correo y del FTP. |

### `[Database1]`, `[Database2]`… (una sección por base de datos)
| Clave | Descripción |
|-------|-------------|
| `Database` | Nombre de la base de datos. Ej.: `AdventureWorks2012`. |
| `filename` | Nombre del archivo generado. Ej.: `AW2012.bak`. |

### `[MAIL]` (opcional, para avisar por correo)
| Clave | Descripción |
|-------|-------------|
| `Server` | Servidor de correo. |
| `Userid` | Usuario de la cuenta de correo. |
| `Password` | Clave **encriptada** de la cuenta. |
| `email` | E-mail del destinatario. |
| `name` | Nombre del destinatario. |

### `[FTP]` (opcional, para subir/descargar copias)
| Clave | Descripción |
|-------|-------------|
| `Server` | Dirección FTP. |
| `Port` | Puerto (normalmente el `21`). |
| `Userid` | Usuario de la cuenta FTP. |
| `Password` | Clave **encriptada** de la cuenta FTP. |
| `InitialDirectory` | Directorio inicial; poned `//` si no hay que entrar en ninguno. |
| `Pasive` | Servidor pasivo (`Y`) o activo (`N`). |
| `Ascii` | Transferencia ascii (`Y`) o binaria (`N`). |

### `[OPTIONS]` (cómo se comporta el programa)
| Clave | Descripción |
|-------|-------------|
| `ProgramMode` | Cliente o Servidor (`C`/`S`). |
| `Compress` | Comprimir las copias / esperar que vengan comprimidas (`S`/`N`). |
| `CompressFormat` | Formato: Zip, 7Zip, Gzip, Tar (`Z`/`7`/`G`/`T`). |
| `Ftp` | Subir o bajar las copias a un servidor FTP (`S`/`N`). |
| `Ftp_FileMode` | Modo de transferencia (`R`/`D`). `R` usa `FileRead`/`FileWrite`; `D` usa `GetFile`/`PutFile`. |
| `SendMail` | Enviar e-mail con los resultados (`S`/`N`). |
| `RestoreOrBackup` | Hacer Copia o Restaurar (`S`/`N`). |
| `CMD` | Ruta de un `.bat` para ejecutar algún comando adicional al final. |

## 🛠️ Requisitos

- **PowerBuilder 2025**.
- **SQL Server** accesible (con permisos para hacer `BACKUP`/`RESTORE`).
- Un **servidor FTP** y/o una **cuenta de correo** si vais a usar esas opciones.
- El ejemplo **EncryptGenerator** para generar el `token` y las contraseñas cifradas.

## ▶️ Cómo probarlo

1. Clona el repo y abre `BackupFtpApp.pbsln` en el IDE (**en modo solución**: clonas y
   compila).
2. Genera con **EncryptGenerator** el `token` y las contraseñas cifradas, y rellena el
   `setup.ini` con tus datos (servidor SQL, bases de datos, FTP, correo, opciones…).
3. Lanza el ejecutable a mano para validar la configuración.
4. Cuando funcione, prográmalo como **tarea de Windows** a la hora deseada y olvídate. 🎉

## 🔗 Repo PowerBuilder

Tenéis el ejemplo publicado **en modo solución** aquí:
<https://github.com/rasanfe/BackupFtpApp>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
