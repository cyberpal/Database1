CREATE PROCEDURE [dbo].[Batch_VueltaFacturacion_Main] (          
	@Usuario VARCHAR(20)
	
	   
)

AS 
	/*Flags de proceso*/
	DECLARE @Flag_OK_validaciones INT;
	DECLARE @Flag_OK_validaciones_NOOK INT;
	DECLARE @Flag_OK_log_proceso INT;
	DECLARE @Flag_OK_While INT;
	DECLARE @Flag_OK_While1 INT;
	DECLARE @Flag_OK_While2 INT;
	DECLARE @Flag_OK_LogPaso INT;
		
	/*Log de proceso*/
	DECLARE @id_proceso INT;
	DECLARE @id_log_proceso INT;
	DECLARE @id_log_paso INT;
	
	/*Variables de retorno*/
	DECLARE @Msg VARCHAR(80);
	DECLARE @Msg_procesamiento VARCHAR(60);
	DECLARE @RetCode INT;
	
	/*Variables locales*/
	DECLARE @v_cta_i INT;
	DECLARE @v_cta_count INT;
	DECLARE @v_Cuenta INT;
	DECLARE @v_id_item_facturacion INT;
	DECLARE @v_Maximo_NumeroDeCarga INT;
	DECLARE @v_diferencia_ajuste [decimal](18, 2);
	DECLARE @v_idTipoOrigenMovimiento INT;
	DECLARE @v_idTipoMovimiento INT;
	DECLARE @v_vuelta_Facturacion VARCHAR(20);
	DECLARE @v_cantidad_procesados INT;
	DECLARE @v_cantidad_nofacturados INT;
	DECLARE @v_importe_procesados [decimal](18, 2);
	DECLARE @v_importe_nofacturados [decimal](18, 2);
	DECLARE @v_importe_total_registros [decimal](18, 2);
	DECLARE @v_id_log_vuelta_facturacion INT;
	DECLARE @v_identificador_carga_dwh INT;
	DECLARE @v_impuestos_reales [decimal](18, 2);
	DECLARE @v_tipo_comprobante CHAR(1);
	DECLARE @v_numero_comprobante INT;
	DECLARE @v_fecha_comprobante datetime;
	DECLARE @v_punto_venta char(1);
	DECLARE @count_mascara int




BEGIN          
	
	SET NOCOUNT ON;          
	              
    BEGIN TRANSACTION 
	
	BEGIN TRY
	
			PRINT 'Comienzo del Proceso Vuelta Facturacion...'

			SELECT @id_proceso=lpo.id_proceso
			FROM Configurations.dbo.Proceso lpo
			WHERE lpo.nombre like 'Vuelta de Facturaci%' 

			SET @Flag_OK_validaciones_NOOK=0
			
			
			-- 1. Iniciar Log  Proceso
			EXEC @id_log_proceso = Configurations.dbo.Iniciar_Log_Proceso 
				 @id_proceso, 
				 NULL, 
				 NULL, 
				 @Usuario;   

				
		    --2. Primer paso: validar acciones que permiten comenzar vuelta de facturacion
		
		IF (@id_log_proceso is not null)
				
				--3. Validaciones necesarias para comienzo de proceso
				EXEC @Flag_OK_validaciones=Configurations.dbo.Batch_VueltaFacturacion_Validaciones
					 @Usuario,
					 @Msg OUTPUT;
					 
		
				
				--4. Si ingresa x aqui, es x fallo alguna de las validaciones del paso previo.
				IF (@Flag_OK_validaciones=0 or @Msg<>'Exito')

						BEGIN
								--4.1. Finalizacion con log proceso, en caso de fallo en validaciones
							EXEC @Flag_OK_log_proceso=Configurations.dbo.Finalizar_Log_Proceso  
								 @id_log_proceso,  
								 0,  
								 @Usuario;

							SET @Flag_OK_validaciones_NOOK=1;
							
							PRINT @Msg;

						END
		
		        ELSE
						BEGIN
					 			 --4.2. Comienzo del proceso general
								 								 
								 EXEC  @id_log_paso=Configurations.dbo.Iniciar_Log_Paso_Proceso 
									   @id_log_proceso,
									   1,
									   'Procesar ANAFACTU',
									   null,
									   @Usuario;
								
								--5. Obtener el maximo numero de carga, utilizado para casos no facturados
								 SELECT @v_Maximo_NumeroDeCarga=max(vfMax.id_vuelta_facturacion)
										FROM configurations.dbo.Vuelta_Facturacion vfMax
									   
								 PRINT 'Carga de datos iniciales...'

								 --6. Carga de la tabla temporal
								 EXEC  @v_cta_count=Configurations.dbo.Batch_VueltaFacturacion_ObtenerRegistros
									   @Usuario,
									   @id_log_paso,
									   @v_Maximo_NumeroDeCarga;
						END		

	END TRY        
  
	BEGIN CATCH  
		
			IF (@@TRANCOUNT > 0)  
			ROLLBACK TRANSACTION;  
			RETURN 0;
			    
    END CATCH
	
	COMMIT TRANSACTION

								
					IF (@v_cta_count<>0 or @Flag_OK_validaciones_NOOK<>1)
														
															
								PRINT 'Procesamiento...'													 	 				 
																						
								SET @v_cta_i = 1; 
					   
								WHILE (@v_cta_i <= @v_cta_count)  
											
									BEGIN
											
											BEGIN TRY

											BEGIN TRANSACTION

											-- Asumir error
											SET @Flag_OK_While = 0;

											SELECT
												@v_Cuenta = tmp.id_cuenta,  
												@v_id_item_facturacion = tmp.id_item_facturacion,  
												@v_diferencia_ajuste = tmp.diferencia_ajuste,
												@v_vuelta_Facturacion=tmp.vuelta_facturacion,
												@v_id_log_vuelta_facturacion=tmp.id_log_vuelta_facturacion,
												@v_identificador_carga_dwh=tmp.identificador_carga_dwh,
												@v_impuestos_reales=tmp.impuestos_reales,
												@v_tipo_comprobante=tmp.tipo_comprobante,
												@v_numero_comprobante=tmp.nro_comprobante,
												@v_fecha_comprobante=tmp.fecha_comprobante,
												@v_punto_venta=tmp.mascara
												FROM Configurations.dbo.Item_Facturacion_tmp tmp 
												WHERE tmp.i = @v_cta_i;
												
																										
												
												IF (@v_vuelta_Facturacion='Procesado')
													
													BEGIN
															
																																																			
														EXEC @Flag_OK_While = Configurations.dbo.Batch_VueltaFacturacion_CalcularAjuste 
															 @v_Cuenta,  
															 @v_diferencia_ajuste,  
															 @Usuario;
													
														IF (@Flag_OK_While=1 and @v_diferencia_ajuste<>0)

															BEGIN
																														
																	SET @v_idTipoMovimiento = (SELECT tpo.id_tipo FROM configurations.dbo.Tipo tpo WHERE tpo.codigo = 'MOV_CRED' AND tpo.id_grupo_tipo = 16 AND @v_diferencia_ajuste > 0
																				UNION ALL
																								SELECT tpo.id_tipo FROM configurations.dbo.Tipo tpo WHERE tpo.codigo = 'MOV_DEB' AND tpo.id_grupo_tipo = 16 AND @v_diferencia_ajuste < 0);
									
																	SET @v_idTipoOrigenMovimiento = (SELECT tpo.id_tipo FROM configurations.dbo.Tipo tpo WHERE tpo.codigo = 'ORIG_PROCESO' AND tpo.id_grupo_tipo = 17);
														
																																									
																										
																	EXECUTE @Flag_OK_While1=Configurations.dbo.Actualizar_Cuenta_Virtual 
																			@v_diferencia_ajuste, 
																			null, 
																			@v_diferencia_ajuste, 
																			null, 
																			null,
																			null,
																			@v_Cuenta,
																			@Usuario, 
																			@v_idTipoMovimiento, 
																			@v_idTipoOrigenMovimiento, 
																			@id_log_proceso;
																END
									                  END

																
												EXECUTE @Flag_OK_While2=Configurations.dbo.Batch_VueltaFacturacion_Actualizar
														@Usuario,
														@id_log_paso,
														@v_Cuenta,
														@v_vuelta_Facturacion,
														@v_identificador_carga_dwh,
														@v_impuestos_reales,
														@v_tipo_comprobante,
														@v_numero_comprobante,
														@v_fecha_comprobante,
														@v_id_item_facturacion,
														@v_punto_venta;
													
													
											COMMIT TRANSACTION;

											END TRY

											BEGIN CATCH
																									
													SET @Msg_procesamiento='Se ha producido un fallo en el procesamiento de la cuenta'
													PRINT @Msg_procesamiento;
													PRINT @v_Cuenta;
											
											END CATCH
											
											
											-- Incrementar contador
												SET @v_cta_i += 1; 
											
											END
																		
								IF (@Flag_OK_validaciones_NOOK<>1)
																		
													BEGIN TRY

													BEGIN TRANSACTION
											
													PRINT 'Reporte final de datos...'
																		
													SELECT @v_cantidad_procesados=isnull(COUNT(tmp.id_cuenta),0) from Configurations.dbo.Item_Facturacion tmp where tmp.vuelta_facturacion=LTRIM(RTRIM('Procesado')) and tmp.id_log_vuelta_facturacion=@id_log_paso
													SELECT @v_cantidad_nofacturados=isnull(COUNT(tmp.id_cuenta),0) from Configurations.dbo.Item_Facturacion tmp where tmp.vuelta_facturacion=LTRIM(RTRIM('No Facturado')) and tmp.id_log_vuelta_facturacion=@id_log_paso
													SELECT @v_importe_procesados=isnull(SUM(tmp.suma_cargos),0) from Configurations.dbo.Item_Facturacion tmp where tmp.vuelta_facturacion=LTRIM(RTRIM('Procesado')) and tmp.id_log_vuelta_facturacion=@id_log_paso
													SELECT @v_importe_nofacturados=isnull(SUM(tmp.suma_cargos),0) from Configurations.dbo.Item_Facturacion tmp where tmp.vuelta_facturacion=LTRIM(RTRIM('No Facturado')) and tmp.id_log_vuelta_facturacion=@id_log_paso
													SELECT @v_importe_total_registros=isnull(@v_importe_procesados+@v_importe_nofacturados,0)

													BEGIN

													EXEC  @Flag_OK_LogPaso=Configurations.dbo.Finalizar_Log_Paso_Proceso
															@id_log_paso,
															null,
															1,
															null,
															@v_cta_count,
															@v_importe_total_registros,
															@v_cantidad_procesados,
															@v_importe_procesados,
															@v_cantidad_nofacturados,
															@v_importe_nofacturados,
															null,
															null,
															@Usuario;
													END
									
											
													BEGIN
					
															 EXEC @Flag_OK_log_proceso=Configurations.dbo.Finalizar_Log_Proceso  
															 @id_log_proceso,  
															 0,  
															 @Usuario;
													END
									
													COMMIT TRANSACTION;

													END TRY

													BEGIN CATCH
															SET @Flag_OK_While = 0;
															SET @Msg_procesamiento='Se ha producido un fallo reporte final'
															PRINT @Msg_procesamiento
													END CATCH
									
													PRINT 'Fin del Proceso Vuelta Facturacion...'	
													
													RETURN 1;  
								             
								  									 
END

