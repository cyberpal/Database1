
CREATE PROCEDURE [dbo].[Obtener_cupones] (
@usuario VARCHAR(20)
)
AS
SET NOCOUNT ON;

DECLARE @msg VARCHAR(max);
DECLARE @i INT = 1;
DECLARE @count INT;
DECLARE @url varchar(256);


BEGIN
	BEGIN TRY
		
		-- Limpiar tabla temporal
		TRUNCATE TABLE Configurations.dbo.Cupones_tmp;

BEGIN TRANSACTION;
		
		-- Obtener cupones a notificar.
		INSERT INTO Configurations.dbo.Cupones_tmp    
		   ([id_conciliacion]
           ,[id_transaccion]
           ,[numero_cuenta]
           ,[concepto]
           ,[importe]
           ,[e_mail]
           ,[nombre_comprador]
		   ,nombre_vendedor
           )
			SELECT id_conciliacion, id_transaccion, LocationIdentification, SaleConcept, Amount, CredentialEmailAddress, credentialholdername, 
			CONCAT(cta.denominacion2, ' ',cta.denominacion1)   
			FROM   CONCILIACION cln
			INNER JOIN Movimiento_Presentado_MP mmp ON mmp.id_movimiento_mp = cln.id_movimiento_mp
			INNER JOIN Medio_de_Pago mdp ON mmp.id_medio_pago = mdp.id_medio_pago
			INNER JOIN Transactions.dbo.transactions trn ON cln.id_transaccion = trn.Id 
			INNER JOIN Cuenta cta ON cta.id_cuenta = trn.LocationIdentification
			WHERE  cln.FLAG_NOTIFICADO = 0 and mdp.id_tipo_medio_pago = 3;



COMMIT TRANSACTION;

	    SELECT @count = count(*)
		FROM Configurations.dbo.Cupones_tmp;
		
		SET @url = (SELECT valor AS URL_WS_NOTIFICACION
		FROM dbo.Parametro 
		WHERE codigo = 'URL_WS_NOTIF_PUSH')


			-- Actualizar temporal de cupones
BEGIN TRANSACTION;
            
			WHILE @i <= @count
		    BEGIN

			UPDATE Configurations.dbo.Cupones_tmp 
			SET url = @url
			WHERE Id = @i;

			SET @i = @i + 1;
			
			END

COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT @msg = ERROR_MESSAGE();

		THROW 51000,
			@Msg,
			1;
	END CATCH;

	RETURN 1;
END;
