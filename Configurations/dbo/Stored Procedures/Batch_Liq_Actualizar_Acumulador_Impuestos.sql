
CREATE PROCEDURE [dbo].[Batch_Liq_Actualizar_Acumulador_Impuestos] (
 @IdImpuesto INT
 ,@IdCuenta INT
 ,@FechaDesde DATETIME
 ,@FechaHasta DATETIME
 ,@Monto DECIMAL(12, 2)
 ,@MontoCalculadoRetencion DECIMAL(12, 2)
 ,@EstadoTope INT
 ,@ImporteRetencion DECIMAL(12, 2) OUTPUT
 ,@CantidadTX INT OUTPUT
 )
AS
DECLARE @ret_code INT;
DECLARE @cantidad_tx INT = 1;
DECLARE @importe_retencion DECIMAL(12, 2) = 0;

BEGIN
 SET NOCOUNT ON;

 BEGIN TRY
  --test
  PRINT '[Batch_Liq_Actualizar_Acumulador_Impuestos]';
  PRINT '@IdImpuesto = ' + ISNULL(CAST(@IdImpuesto AS VARCHAR(20)), 'NULL');
  PRINT '@IdCuenta = ' + ISNULL(CAST(@IdCuenta AS VARCHAR(20)), 'NULL');
  PRINT '@FechaDesde = ' + ISNULL(CAST(@FechaDesde AS VARCHAR(20)), 'NULL');
  PRINT '@FechaHasta = ' + ISNULL(CAST(@FechaHasta AS VARCHAR(20)), 'NULL');
  PRINT '@Monto = ' + ISNULL(CAST(@Monto AS VARCHAR(20)), 'NULL');
  PRINT '@MontoCalculadoRetencion = ' + ISNULL(CAST(@MontoCalculadoRetencion AS VARCHAR(20)), 'NULL');
  PRINT '@EstadoTope = ' + ISNULL(CAST(@EstadoTope AS VARCHAR(20)), 'NULL');
  PRINT '@ImporteRetencion = ' + ISNULL(CAST(@ImporteRetencion AS VARCHAR(20)), 'NULL');
  PRINT '@CantidadTX = ' + ISNULL(CAST(@CantidadTX AS VARCHAR(20)), 'NULL');

  MERGE Configurations.dbo.Acumulador_Impuesto AS destino
  USING (
   SELECT @IdImpuesto
    ,@IdCuenta
    ,@FechaDesde
    ,@FechaHasta
    ,@cantidad_tx
    ,@Monto
    ,@MontoCalculadoRetencion
    ,@EstadoTope
   ) AS origen(id_impuesto, id_cuenta, fecha_desde, fecha_hasta, cantidad_tx, monto, monto_calculado_retencion, estado_tope)
   ON (
     origen.id_impuesto = destino.id_impuesto
     AND origen.id_cuenta = destino.id_cuenta
     AND origen.fecha_desde = destino.fecha_desde
     AND origen.fecha_hasta = destino.fecha_hasta
     )
  WHEN MATCHED
   THEN
    UPDATE
    SET destino.cantidad_tx = destino.cantidad_tx + 1
     ,destino.importe_total_tx = destino.importe_total_tx + origen.monto
     ,destino.importe_retencion = destino.importe_retencion + origen.monto_calculado_retencion
     ,destino.flag_supera_tope = IIF(origen.estado_tope = 0, 0, 1)
     ,@importe_retencion = destino.importe_retencion + origen.monto_calculado_retencion
     ,@cantidad_tx = destino.cantidad_tx + 1
  WHEN NOT MATCHED
   THEN
    INSERT (
     id_impuesto
     ,id_cuenta
     ,fecha_desde
     ,fecha_hasta
     ,cantidad_tx
     ,importe_total_tx
     ,importe_retencion
     ,flag_supera_tope
     )
    VALUES (
     origen.id_impuesto
     ,origen.id_cuenta
     ,origen.fecha_desde
     ,origen.fecha_hasta
     ,origen.cantidad_tx
     ,origen.monto
     ,origen.monto_calculado_retencion
     ,IIF(origen.estado_tope = 0, 0, 1)
     );

  SET @ImporteRetencion = @importe_retencion;
  SET @CantidadTX = @cantidad_tx;
  SET @ret_code = 1;
 END TRY

 BEGIN CATCH
  PRINT ERROR_MESSAGE();

  SET @ret_code = 0;
 END CATCH

 RETURN @ret_code;
END
