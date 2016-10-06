  
CREATE PROCEDURE [dbo].[Facturacion_Calcular_Dev] (              
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

DECLARE @v_cantidad_registros INT;               
DECLARE @v_suma_cargos DECIMAL(12,2);              
DECLARE @suma_cargos_aurus DECIMAL(12,2)            
DECLARE @v_suma_impuestos DECIMAL(12,2);
DECLARE @v_suma_cargos_dev DECIMAL(12,2);              
DECLARE @suma_cargos_aurus_dev DECIMAL(12,2)            
DECLARE @v_suma_impuestos_dev DECIMAL(12,2);        
DECLARE @v_tax_amount DECIMAL(12,2);
DECLARE @v_id_item_facturacion INT;              
DECLARE @v_fecha_actual DATETIME;      
DECLARE @fecha_minima DATETIME;              
DECLARE @CodRet INT


BEGIN TRANSACTION
            
BEGIN TRY  
          
   BEGIN
	   
		 SELECT              
				  @v_id_item_facturacion = ISNULL(MAX(ifo.id_item_facturacion), 0) + 1,              
				  @v_fecha_actual = GETDATE()              
				  FROM Configurations.dbo.Item_Facturacion ifo;              
     
		 SELECT               
				  @v_suma_cargos = SUM(ISNULL(pf.FeeAmount, 0)),              
				  @v_suma_impuestos = SUM(ISNULL(pf.TaxAmount, 0)),            
				  @suma_cargos_aurus = SUM(case when pf.TaxAmount = 0 then cast(isnull(pf.FeeAmount,0)/1.21 as decimal(12,2)) else pf.FeeAmount end),
				  @v_cantidad_registros=count(I)    
				  FROM Configurations.dbo.Procesar_Facturacion_tmp pf
				  WHERE LTRIM(RTRIM(pf.OperationName)) IN ('Devolucion')
				  AND pf.LocationIdentification = @v_id_cuenta;      
	 
		 SELECT  @fecha_minima = MIN(CreateTimestamp)                      
				 FROM Configurations.dbo.Procesar_Facturacion_tmp pf 
				 WHERE LTRIM(RTRIM(pf.OperationName)) IN ('Devolucion') 
				 AND pf.LocationIdentification=@v_id_cuenta       
        
    END
	        
 IF (@v_suma_cargos > 0 and @v_cantidad_registros>0)              
    
	BEGIN
	             
		  INSERT INTO [dbo].[Item_Facturacion] (              
			[id_item_facturacion],              
			[id_log_facturacion],              
			[id_ciclo_facturacion],              
			[tipo],              
			[concepto],              
			[subconcepto],              
			[id_cuenta],              
			[anio],              
			[mes],              
			[suma_cargos],              
			[suma_impuestos],              
			[vuelta_facturacion],
			[tipo_comprobante],                 
			[fecha_alta],              
			[usuario_alta],              
			[version],              
			[cuenta_aurus],            
			[suma_cargos_aurus],      
			[fecha_desde_proceso],      
			[fecha_hasta_proceso]                
		   ) VALUES (              
			@v_id_item_facturacion,              
			@v_id_log_facturacion,              
			@v_id_ciclo_facturacion,              
			@v_tipo,              
			@v_concepto,              
			@v_subconcepto,              
			@v_id_cuenta,              
			@v_anio,              
			@v_mes,              
			@v_suma_cargos,              
			@v_suma_impuestos,              
			@v_vuelta_facturacion, 
			'C',             
			@v_fecha_actual,            
			@v_usuario_alta,              
			@v_version,              
			@v_cuenta_aurus,            
			@suma_cargos_aurus,      
			@fecha_minima,      
			@fecha_finProceso               
		   );              
              
		   --Detalle del Item              
		   INSERT INTO [dbo].[Detalle_Facturacion] (              
			[id_item_facturacion],              
			[id_transaccion],              
			[fecha_alta],              
			[usuario_alta],              
			[version]              
		   )              
		   SELECT              
			@v_id_item_facturacion,              
			txs.Id,              
			@v_fecha_actual,              
			@v_usuario_alta,              
			@v_version              
		   FROM Configurations.dbo.Procesar_Facturacion_tmp txs              
		   WHERE LTRIM(RTRIM(txs.OperationName)) IN ('Devolucion')
			 AND txs.LiquidationStatus = -1              
			 AND txs.LiquidationTimestamp IS NOT NULL              
			 AND txs.BillingStatus <> -1              
			 AND txs.BillingTimestamp IS NULL              
			 AND txs.CreateTimestamp <= @fecha_finProceso              
			 AND txs.LocationIdentification = @v_id_cuenta;              
  
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
