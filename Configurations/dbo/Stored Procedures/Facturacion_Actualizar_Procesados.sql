  
CREATE PROCEDURE [dbo].[Facturacion_Actualizar_Procesados] (              
 @fecha_finProceso DATETIME = NULL,              
 @v_id_cuenta INT = NULL             
              
)                          
AS               

DECLARE @CodRet INT
              
SET NOCOUNT ON;  

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;              
	           
BEGIN TRANSACTION              
              
BEGIN TRY              
   
BEGIN

		 UPDATE transactions.dbo.transactions              
		 SET              
		  BillingTimestamp = GETDATE(),              
		  BillingStatus = -1,              
		  SyncStatus = 0               
		 WHERE LiquidationStatus = -1              
		  AND LiquidationTimestamp IS NOT NULL              
		  AND BillingStatus <> -1              
		  AND BillingTimestamp IS NULL              
		  AND CreateTimestamp <= @fecha_finProceso             
		  AND LocationIdentification = @v_id_cuenta
		  AND id in (select id from Configurations.dbo.Procesar_Facturacion_tmp) 
       
END              
      
              
COMMIT TRANSACTION;  

SET @CodRet=1;
         
END TRY              

BEGIN CATCH              
	
	IF (@@TRANCOUNT > 0)
	              
	 ROLLBACK TRANSACTION;               
	 SET @CodRet=0;
	 RETURN @CodRet;     

END CATCH              
              
      
              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;              
              
RETURN @CodRet; 
