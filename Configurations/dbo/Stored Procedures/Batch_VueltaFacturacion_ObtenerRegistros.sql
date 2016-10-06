/****** Object:  StoredProcedure [dbo].[Batch_VueltaFacturacion_ObtenerRegistros]    Script Date: 31/07/2015 11:48:04 ******/

CREATE PROCEDURE [dbo].[Batch_VueltaFacturacion_ObtenerRegistros] (    
		@Usuario VARCHAR(20),
		@id_log_paso INT,
		@Maximo_NumeroDeCarga INT
		

)

AS  
		DECLARE @rows INT;  
		DECLARE @I INT;        
		

BEGIN            
 SET NOCOUNT ON;      
      
 BEGIN TRY      
  TRUNCATE TABLE Configurations.dbo.Item_Facturacion_tmp;      
        
  BEGIN TRANSACTION;      
       
		INSERT INTO [dbo].[Item_Facturacion_tmp] (
			[I],
			[id_item_facturacion],
			[id_cuenta],
			[cuenta_aurus],
			[suma_cargos],
			[suma_impuestos],
			[diferencia_ajuste],
			[vuelta_facturacion],
			[id_log_vuelta_facturacion],
			[identificador_carga_dwh],
			[impuestos_reales],
			[tipo_comprobante],
			[nro_comprobante],
			[fecha_comprobante],
			[Mascara],
			[fecha_alta],
			[usuario_alta]
			)
		SELECT ROW_NUMBER() OVER (
				ORDER BY id_cuenta
				) AS I,
			f.[id_item_facturacion],
			f.[id_cuenta],
			f.[cuenta_aurus],
			f.[suma_cargos],
			f.[suma_impuestos],
			f.[diferencia_ajuste],
			f.[vuelta_facturacion],
			f.[id_log_vuelta_facturacion],
			f.[id_vuelta_facturacion],
			f.[Importe_pesos_iva],
			f.[tipo_comprobante],
			f.[nro_comprobante],
			f.[fecha_comprobante],
			f.[Mascara],
			f.[fecha_alta],
			f.[usuario_alta]			
		FROM (
			SELECT
				tif.id_item_facturacion,
				tif.id_cuenta,
				tif.cuenta_aurus,
				isnull(tif.suma_cargos,0) AS suma_cargos,
				isnull(tif.suma_impuestos,0) AS suma_impuestos,
				isnull((tif.suma_impuestos - vf.Importe_pesos_iva),0) AS diferencia_ajuste,
				'Procesado' AS vuelta_facturacion,
				@id_log_paso AS id_log_vuelta_facturacion,
				vf.id_vuelta_facturacion,
				isnull(vf.Importe_pesos_iva,0) AS Importe_pesos_iva,
				vf.Tipo_comprobante,
				vf.Nro_comprobante,
				vf.Fecha_comprobante,
				vf.Mascara,
				tif.fecha_alta,
				tif.usuario_alta				
			FROM configurations.dbo.Item_Facturacion tif
			INNER JOIN configurations.dbo.Vuelta_Facturacion vf
				ON tif.cuenta_aurus = convert(int,vf.Nro_cliente_ext)
				and tif.tipo_comprobante=vf.Tipo_comprobante
				and tif.suma_cargos_aurus=case when tif.tipo_comprobante='F' then cast(vf.Importe_pesos as numeric(12,2)) else cast(isnull(vf.Importe_pesos,0)*-1 as decimal(12,2)) END
			WHERE tif.vuelta_facturacion = 'Pendiente'
				AND tif.id_log_vuelta_facturacion IS NULL
				AND tif.identificador_carga_dwh IS NULL
				AND vf.Mascara<=3
				AND vf.id_vuelta_facturacion = (
					SELECT max(vfMax.id_vuelta_facturacion)
					FROM configurations.dbo.Vuelta_Facturacion vfMax
					)
	
			UNION ALL
	/*
			SELECT 
			    tif.id_item_facturacion,
				tif.id_cuenta,
				NULL AS cuenta_aurus,
				NULL AS suma_cargos,
				NULL AS suma_impuestos,
				NULL AS diferencia_ajuste,
				'No Facturado' AS vuelta_facturacion,
				@id_log_paso AS id_log_vuelta_facturacion,
				@Maximo_NumeroDeCarga AS id_vuelta_facturacion,
				NULL AS Importe_pesos_iva,
				NULL AS tipo_comprobante,
				NULL AS Nro_comprobante,
				NULL AS Fecha_comprobante,
				NULL AS Mascara,
				tif.fecha_alta,
				tif.usuario_alta
			FROM configurations.dbo.Item_Facturacion tif
			LEFT JOIN configurations.dbo.Vuelta_Facturacion vf
				ON tif.cuenta_aurus = convert(int,vf.Nro_cliente_ext)
			WHERE tif.vuelta_facturacion = 'Pendiente'
				AND vf.Nro_cliente_ext IS NULL
				AND tif.id_log_vuelta_facturacion IS NULL
				AND tif.identificador_carga_dwh IS NULL
			) f;
			*/


			SELECT 
			    tif.id_item_facturacion,
				tif.id_cuenta,
				NULL AS cuenta_aurus,
				NULL AS suma_cargos,
				NULL AS suma_impuestos,
				NULL AS diferencia_ajuste,
				'No Facturado' AS vuelta_facturacion,
				@id_log_paso AS id_log_vuelta_facturacion,
				@Maximo_NumeroDeCarga AS id_vuelta_facturacion,
				NULL AS Importe_pesos_iva,
				NULL AS tipo_comprobante,
				NULL AS Nro_comprobante,
				NULL AS Fecha_comprobante,
				NULL AS Mascara,
				tif.fecha_alta,
				tif.usuario_alta
			FROM configurations.dbo.Item_Facturacion tif
			where not exists (
			select 1
			from configurations.dbo.Vuelta_Facturacion vf
				where tif.cuenta_aurus = convert(int,vf.Nro_cliente_ext)
				and tif.tipo_comprobante=vf.Tipo_comprobante
				and tif.suma_cargos_aurus=case when tif.tipo_comprobante='F' then cast(vf.Importe_pesos as numeric(12,2)) 
				else cast(isnull(vf.Importe_pesos,0)*-1 as decimal(12,2)) END)
				AND  tif.vuelta_facturacion = 'Pendiente'
				AND tif.id_log_vuelta_facturacion IS NULL
				AND tif.identificador_carga_dwh IS NULL
			) f;

    
  
 SET @rows = @@ROWCOUNT;  
	  COMMIT TRANSACTION;      
      RETURN @rows;  
 END TRY          
      
 BEGIN CATCH          
   ROLLBACK TRANSACTION;            
   RETURN 0;  
 END CATCH          

END

