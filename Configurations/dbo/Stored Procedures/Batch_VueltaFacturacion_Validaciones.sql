CREATE PROCEDURE [dbo].[Batch_VueltaFacturacion_Validaciones] (          
	@Usuario VARCHAR(20),
	@Msg VARCHAR(80) OUTPUT
	
  
)

AS 
	
	DECLARE @RetCode INT;
	DECLARE @CantidadRegistros_Vuelta INT;
	DECLARE @CantidadRegistros_Pendientes INT;
	DECLARE @Maximo_NumeroDeCarga INT

	 
BEGIN          
	
	SET NOCOUNT ON;          
	              
    BEGIN TRANSACTION 
	
	BEGIN TRY 
	
		SELECT @CantidadRegistros_Vuelta=COUNT(Nro_Item) 
		FROM Configurations.dbo.Vuelta_facturacion
		
		IF (@CantidadRegistros_Vuelta<=0)
			
			BEGIN  
				SET  @RetCode=0;
				SET  @Msg='No existen registros en la tabla vuelta de facturacion - AURUS'
			END  
		
		ELSE    
				
				SELECT @CantidadRegistros_Pendientes=count(id_cuenta) 
					   FROM configurations.dbo.Item_Facturacion tif
					   WHERE tif.vuelta_facturacion = 'Pendiente'
				     	AND   tif.id_log_vuelta_facturacion  IS NULL
						AND   tif.identificador_carga_dwh IS NULL
				
				IF(@CantidadRegistros_Pendientes=0)
					BEGIN
						 SET  @RetCode = 0; 
						 SET  @Msg='No existen registros en estado pendiente en la tabla item facturacion'
					END
				
				ELSE
					
					BEGIN
						
						SELECT @Maximo_NumeroDeCarga=MAX(t.premaximo)FROM
						(SELECT m.maximo AS premaximo
						FROM (SELECT MAX(Id_Vuelta_Facturacion) AS maximo
						FROM configurations.dbo.Vuelta_Facturacion) m
						WHERE m.maximo IN 
						(SELECT identificador_carga_dwh FROM configurations.dbo.Item_Facturacion)
						UNION ALL
						SELECT -1 AS premaximo) t

						IF (@Maximo_NumeroDeCarga<>-1)

							BEGIN
								SET  @RetCode = 0; 
								SET  @Msg='Se ha detectado que el maximo id de carga ha sido procesado'
							END
						ELSE
							BEGIN
								SET  @RetCode = 1;
								SET  @Msg='Exito'
							END
				  END
	END TRY        
  
		BEGIN CATCH  
		
			IF (@@TRANCOUNT > 0)  
				ROLLBACK TRANSACTION;  
			RETURN @RetCode;
			RETURN @Msg;
			
		
		END CATCH
	
	COMMIT TRANSACTION
	
	RETURN @RetCode;
	RETURN @Msg;
	
             
END

