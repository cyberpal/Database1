
CREATE PROCEDURE dbo.Batch_AltaCuentas_Parseo
AS
DECLARE @resultado_proceso BIT = 0;
DECLARE @id_proceso INT = 26;
DECLARE @id_log_proceso INT;
DECLARE @cant INT;
DECLARE @archivo_entrada  VARCHAR(100) = NULL;
DECLARE @id_nivel_detalle_global INT;
DECLARE @usuario VARCHAR(7) = 'bpbatch';


                                     
SET NOCOUNT ON;

    EXEC Configurations.dbo.Batch_Log_Iniciar_Proceso 
         @id_proceso,
         NULL,
         NULL,
         @Usuario,
         @id_log_proceso = @id_log_proceso OUTPUT,
         @id_nivel_detalle_global = @id_nivel_detalle_global OUTPUT;
		 
		 
	TRUNCATE TABLE Configurations.dbo.Info_archivo_alta_cuenta_Tmp;
	

BEGIN TRY
    BEGIN TRANSACTION;
    
    INSERT INTO Configurations.dbo.Info_archivo_alta_cuenta_Tmp
    SELECT da.id_detalle,--id detalle
	       REPLACE(aa.nombre_archivo,'.txt',''),--nombre archivo alta
		   RTRIM(SUBSTRING(da.detalle,1,20)),--codigo solicitante
           CAST(SUBSTRING(da.detalle,21,6)AS INT),--Nro solicitud
           RTRIM(SUBSTRING(da.detalle,27,1)),--tipo novedad
	       RTRIM(SUBSTRING(da.detalle,28,20)),--tipo cuenta 
           RTRIM(SUBSTRING(da.detalle,48,50)),--email
           RTRIM(SUBSTRING(da.detalle,98,50)),--nombre de fantasía
           RTRIM(SUBSTRING(da.detalle,148,50)),--razon social
           RTRIM(SUBSTRING(da.detalle,198,1)),--genero
           CAST(SUBSTRING(da.detalle,199,3)AS INT),--nacionalidad
           RTRIM(SUBSTRING(da.detalle,202,3)),--id tipo doc
           RTRIM(SUBSTRING(da.detalle,205,12)),--nro_doc
           CAST(SUBSTRING(da.detalle,217,8) AS DATETIME),--fechanac
           CAST(SUBSTRING(da.detalle,225,1) AS INT),--opcelu
           RTRIM(SUBSTRING(da.detalle,226,10)),--nro_celu
           RTRIM(SUBSTRING(da.detalle,236,10)),--nro_tel
           RTRIM(SUBSTRING(da.detalle,246,20)),--cond_iva
           RTRIM(SUBSTRING(da.detalle,266,20)),--cond_iibb
           RTRIM(SUBSTRING(da.detalle,286,4)),--actividad
           CAST(SUBSTRING(da.detalle,290,11) AS BIGINT),--CUIT
           RTRIM(SUBSTRING(da.detalle,301,30)),--callelegal
           RTRIM(SUBSTRING(da.detalle,331,10)),--nro_legal
           RTRIM(SUBSTRING(da.detalle,341,10)),--piso_legal
           RTRIM(SUBSTRING(da.detalle,351,10)),--depto_legal
           RTRIM(SUBSTRING(da.detalle,361,8)),--cod postal legal
           CAST(SUBSTRING(da.detalle,369,2) AS INT),--id prov legal
           RTRIM(SUBSTRING(da.detalle,371,4)),--loc_legal
           RTRIM(SUBSTRING(da.detalle,375,30)),--calle facturacion
           RTRIM(SUBSTRING(da.detalle,405,10)),--nro_dom_facturacion
           RTRIM(SUBSTRING(da.detalle,415,10)),--piso_fac
           RTRIM(SUBSTRING(da.detalle,425,10)),--depto_fac
           RTRIM(SUBSTRING(da.detalle,435,8)),--cod_post_fact
           CAST(SUBSTRING(da.detalle,443,2) AS INT),--id_prov_fac
           RTRIM(SUBSTRING(da.detalle,445,4)),--loc_fact
		   RTRIM(SUBSTRING(da.detalle,449,22)),--cbu
           RTRIM(SUBSTRING(da.detalle,471,20)),--tipo cashout
           CAST(SUBSTRING(da.detalle,491,10) AS INT),--cant_Mpos
           RTRIM(SUBSTRING(da.detalle,501,20)),--costo_Mpos
		   9,
		   'S'
    FROM Configurations.dbo.Detalle_archivo_alta_cuenta_tmp da 
    INNER JOIN Configurations.dbo.Archivo_Alta_Cuenta aa
	ON aa.id = da.id_archivo;
                   
				   
	SELECT @cant = COUNT(1) FROM Configurations.dbo.Detalle_archivo_alta_cuenta_tmp;

	
    COMMIT TRANSACTION;
	
	EXEC Configurations.dbo.Batch_Log_Finalizar_Proceso
         @id_log_proceso,
         @cant,
         @usuario;

    RETURN 1;

END TRY

BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;