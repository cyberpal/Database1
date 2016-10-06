    
CREATE PROCEDURE [dbo].[Facturacion_Main] (                
 @v_id_log_facturacion INT = NULL,                
 @v_id_ciclo_facturacion INT = NULL,                
 @v_tipo CHAR(3) = NULL,                
 @v_concepto CHAR(3) = NULL,                
 @v_subconcepto CHAR(3) = NULL,                
 @v_id_cuenta INT = NULL,                
 @v_anio INT = NULL,                
 @v_mes INT = NULL,                
 @v_vuelta_facturacion VARCHAR(15) = NULL,                
 @v_usuario_alta VARCHAR(20) = NULL,                
 @v_version INT = NULL,                
 @v_cuenta_aurus INT = NULL,                
 @fecha_finProceso DATETIME = NULL                   
)                            
AS                 
                
SET NOCOUNT ON;     
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;              
               
DECLARE @flag_calcular_compras INT;  
DECLARE @flag_calcular_dev INT;  
DECLARE @flag_actualizar INT;  
DECLARE @CodRet_Carga INT;  
DECLARE @CodRet_Proc INT  
  
  
  
BEGIN TRANSACTION  
  
BEGIN TRY  
              
TRUNCATE TABLE Configurations.dbo.Procesar_Facturacion_tmp;             
  
  
SET @CodRet_Carga=0;  
SET @CodRet_Proc=0;  
  
  
IF (@v_id_cuenta IS NULL OR @v_id_cuenta = 0 OR (NOT EXISTS (SELECT 1 FROM Configurations.dbo.Cuenta WHERE id_cuenta = @v_id_cuenta)) OR  
    @fecha_finProceso IS NULL OR  
    @v_id_log_facturacion IS NULL OR @v_id_log_facturacion = 0 OR                
    @v_id_ciclo_facturacion IS NULL OR @v_id_ciclo_facturacion = 0 OR                
 @v_tipo IS NULL OR @v_tipo = '' OR                
 @v_concepto IS NULL OR @v_concepto = '' OR                
 @v_subconcepto IS NULL OR @v_subconcepto = '' OR                
 @v_anio IS NULL OR @v_anio = 0 OR                
 @v_mes IS NULL OR (@v_mes NOT BETWEEN 1 AND 12) OR                
 @v_vuelta_facturacion IS NULL OR @v_vuelta_facturacion = '' OR                
 @v_usuario_alta IS NULL OR @v_usuario_alta = '' OR                
 @v_version IS NULL OR                
 @v_cuenta_aurus IS NULL OR @v_cuenta_aurus = '' )          
   
  BEGIN   
      SET @CodRet_Carga=0;  
  END  
  
ELSE    
    
  BEGIN  
  INSERT INTO [dbo].[Procesar_Facturacion_tmp] (    
    [id],  
                [LocationIdentification],  
    [LiquidationTimeStamp],  
    [LiquidationStatus],  
    [BillingStatus],  
    [BillingTimestamp],  
    [CreateTimestamp],  
    [FeeAmount],  
    [TaxAmount],  
    [OperationName]      
   )  
     
   SELECT   
    tx.id,  
    tx.LocationIdentification,  
    tx.LiquidationTimestamp,  
    tx.LiquidationStatus,  
    tx.BillingStatus,  
    tx.BillingTimestamp,  
    tx.CreateTimestamp,  
    tx.FeeAmount,  
    tx.TaxAmount,  
    tx.OperationName  
    FROM Transactions.dbo.transactions tx  
   WHERE  LTRIM(RTRIM(tx.OperationName)) IN ('Compra_offline', 'Compra_online')  
       AND tx.LiquidationTimestamp IS NOT NULL          
       AND tx.LiquidationStatus = -1          
       AND tx.BillingStatus <> -1          
       AND tx.BillingTimestamp IS NULL          
       AND tx.CreateTimestamp <= @fecha_finProceso          
       AND tx.LocationIdentification = @v_id_cuenta   
     
   UNION ALL  
     
   SELECT   
    tx.Id,  
    tx.LocationIdentification,  
    tx.LiquidationTimestamp,  
    tx.LiquidationStatus,  
    tx.BillingStatus,  
    tx.BillingTimestamp,  
    tx.CreateTimestamp,  
    tx.FeeAmount,  
    tx.TaxAmount,  
    tx.OperationName   
   FROM  
    Transactions.dbo.transactions tx  
   WHERE  LTRIM(RTRIM(tx.OperationName)) IN ('Devolucion')  
       AND tx.LiquidationTimestamp IS NOT NULL          
       AND tx.LiquidationStatus = -1     
       AND tx.BillingStatus <> -1          
       AND tx.BillingTimestamp IS NULL          
       AND tx.CreateTimestamp <= @fecha_finProceso          
       AND tx.LocationIdentification = @v_id_cuenta;  
         
 SET @CodRet_Carga=1;     
   
 END   
  
 COMMIT TRANSACTION;  
   
END TRY                
  
BEGIN CATCH  
  
 IF (@@TRANCOUNT > 0)  
                 
  ROLLBACK TRANSACTION;                 
  SET @CodRet_Carga=0;   
  RETURN @CodRet_Carga;  
  
END CATCH                
                
  
  
  
BEGIN TRY  
  
BEGIN TRANSACTION;    
    
  IF (@CodRet_Carga=1)  
    
  BEGIN  
     
   EXEC @flag_calcular_compras=Configurations.dbo.Facturacion_Calcular_Compras  
     @v_id_log_facturacion,  
     @v_id_ciclo_facturacion,                
     @v_tipo,               
                 @v_concepto,                
                 @v_subconcepto,                
                 @v_id_cuenta,                
     @v_anio,               
     @v_mes,                
     @v_vuelta_facturacion,                
     @v_usuario_alta,                
     @v_version,                
     @v_cuenta_aurus,                
     @fecha_finProceso;           
     
   EXEC @flag_calcular_dev=Configurations.dbo.Facturacion_Calcular_Dev  
     @v_id_log_facturacion,  
     @v_id_ciclo_facturacion,                
     @v_tipo,               
                 @v_concepto,                
                 @v_subconcepto,                
                 @v_id_cuenta,                
     @v_anio,               
     @v_mes,                
     @v_vuelta_facturacion,                
     @v_usuario_alta,                
     @v_version,                
     @v_cuenta_aurus,                
     @fecha_finProceso;           
       
   EXEC @flag_actualizar=Configurations.dbo.Facturacion_Actualizar_Procesados  
        @fecha_finProceso,  
     @v_id_cuenta;  
  
       
      
  END  
  
  IF (@flag_calcular_compras=1 and @flag_calcular_dev=1 and @flag_actualizar=1)  
     
   BEGIN  
     
       SET @CodRet_Proc=1;  
     
   END  
    
  ELSE  
     
   BEGIN  
     
       SET @CodRet_Proc=0;  
     
   END  
    
    
  COMMIT TRANSACTION;   
    
END TRY  
  
BEGIN CATCH   
               
  IF (@@TRANCOUNT > 0)  
                 
  ROLLBACK TRANSACTION;                 
  SET @CodRet_Proc=0;  
  RETURN @CodRet_Proc;   
  
END CATCH     
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;       
  
         
RETURN @CodRet_Proc; 
