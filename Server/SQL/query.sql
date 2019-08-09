--NOTE INSERT PERSONAS CON UN TELEFONO
--al crear un usuario necesita como minimo un telefono
--el telefono tiene una coleccion que se debe porder modificar a la hora de insertar
CREATE OR REPLACE FUNCTION fn_insertar_usuarios(_dni VARCHAR(15), _nombre VARCHAR(20), _apelledo VARCHAR(20), _correo VARCHAR(20), _clave VARCHAR(20), _numero VARCHAR(20), _id_tipo_telefono integer)
RETURNS VOID AS
$BODY$
BEGIN

    INSERT INTO usuarios(DNI_usuario, nombre, apellido, correo, clave)
    VALUES(_dni, _nombre, _apelledo, _correo, _clave);

    INSERT INTO telefonos(numero, DNI_usuario)
    VALUES (_numero, _dni);

    UPDATE telefonos
    SET id_tipo_telefono = _id_tipo_telefono
    WHERE numero = _numero;

END;
$BODY$
LANGUAGE 'plpgsql';

SELECT fn_insertar_usuarios('8989', 'Charlotte','APELLIDOS', 'CORREO', 'CLAVE', '8971',1);

--NOTE CREAR UNA ORDEN
--Debe asignarse a un usuario
--El usuario no puede tener una orden activa
CREATE OR REPLACE FUNCTION fn_crear_orden(_detalle VARCHAR(300), _dni_usuario VARCHAR(15))
RETURNS VOID AS
$BODY$
    DECLARE
        _id_orden integer;
BEGIN
    IF NOT EXISTS (SELECT activo 
                  FROM ordenes_usuarios
                  WHERE dni_usuario = _dni_usuario 
                  AND activo = true)                                                        
    THEN
        INSERT INTO ordenes (detalle)
        VALUES (_detalle);
        
        _id_orden = MAX (ID_orden) FROM ordenes;
        
        INSERT INTO ordenes_usuarios (ID_orden, dni_usuario)
        VALUES(_id_orden, _dni_usuario);

    END IF;

END;
$BODY$
LANGUAGE'plpgsql';

SELECT fn_crear_orden('ORDEN 1 DE CHARLOTTE', '8989');

    UPDATE ordenes_usuarios
    SET activo = false 
    WHERE id_orden = 17;

SELECT * from ordenes_usuarios;
SELECT * from usuarios;


--NOTE  INGRESAR ACTIVIDADES EN LA ORDEN
--debe existir la orden
CREATE OR REPLACE FUNCTION fn_orden_actividades(_id_orden integer, _id_actividad integer, _cantidad integer)
RETURNS VOID AS
$BODY$
    -- DECLARE
    --     _id_orden integer;
BEGIN
IF((SELECT activo
    FROM ordenes_usuarios
    WHERE id_orden = _id_orden
    AND activo = true) 
AND
    (SELECT activo
     FROM actividades
     WHERE ID_actividad = _id_actividad 
     AND activo = true))
        THEN
            -- _id_orden = id_orden FROM ordenes_usuarios WHERE activo = true and dni_usuario = _dni_usuario;
            INSERT INTO ordenes_actividades(id_orden, id_actividad, cantidad)
            VALUES (_id_orden, _id_actividad, _cantidad);
END IF;

END;
$BODY$
LANGUAGE 'plpgsql';

SELECT fn_orden_actividades(20, 1, 5);

SELECT * from ordenes_usuarios
SELECT * from ordenes_actividades
SELECT * from actividades
SELECT * from actividades

--NOTE ACTUALIZAR ACTIVIDAD DE LA ORDEN

--NOTE ELIMINAR ACTIVIDAD DE LA ORDEN
--no debe haber pasado la fecha

--NOTE INGRESAR COMIDAS A LA ORDEN
--debe existir la orden 
--si ya existe la comida se debe actualizar la cantidad

--TODO FUNCIONES DE ALQUILER

--NOTE INGRESAR UN ALQUILER
--debe existir la orden activa
--debe exister la habitacion 
--la habitacion debe estar disponible


SELECT fn_nuevo_orden_alquiler('02-03', '8989', '09/1/2019');

SELECT id_orden FROM ordenes_usuarios WHERE dni_usuario = '8989'

SELECT activo, id_codigo_habitacion
FROM habitacion
WHERE id_codigo_habitacion = '02-01'
    AND activo = false;

INSERT INTO alquileres (fecha_fin, id_codigo_habitacion) 
    VALUES ('09/1/2019', '02-01' );

DELETE from alquileres WHERE id_alquiler = 1;

SELECT * from ordenes;
SELECT * from ordenes_alquileres;
SELECT * from ordenes_actividades;
SELECT * from alquileres;
SELECT * FROM habitacion
SELECT * from ordenes_usuarios

    UPDATE habitacion
    SET activo = true
    WHERE id_codigo_habitacion = '02-03'

SELECT MAX (id_alquiler) FROM alquileres;


--TODO PAGO DE LA ORDEN
--suma de los totales de comida, habitacion y actividad vinculada a la orden del usuario