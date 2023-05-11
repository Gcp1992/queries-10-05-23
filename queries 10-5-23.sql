--función sin parametro de entrada para devolver el precio máximo
create or replace function precio_maximo()
returns numeric
as $$
declare precio_max numeric;
begin
	select max(unit_price)
	into precio_max
	from products;
	return precio_max;
end;
$$ LANGUAGE plpgsql;
select precio_maximo();




--parametro de entrada
--Obtener el numero de ordenes por empleado

create or replace function nordenes_empleado(id numeric)
returns numeric
as $$
declare numero_ordenes numeric;
begin
	select count(order_id)
	into numero_ordenes
	from orders
	where employee_id = id;
	return numero_ordenes;
end;
$$ LANGUAGE plpgsql;
select nordenes_empleado(2);





--Obtener la venta de un empleado con un determinado producto

create or replace function ventas_empleado(empleado numeric, producto numeric)
returns numeric
as $$
declare numero_ventas numeric;
begin
	select sum(od.quantity) into numero_ventas from order_details as od
	join orders as o
	on o.order_id=od.order_id
	and o.employee_id = empleado
	and od.product_id = producto;
	return numero_ventas;
end;
$$ LANGUAGE plpgsql;
select * from ventas_empleado(4,1);




--Crear una funcion para devolver una tabla con producto_id, nombre, precio y 
--unidades en stock, debe obtener los productos terminados en n

create or replace function obtener_tabla_productos()
returns table(producto_id smallint, nombre varchar, precio real, unidades_stock smallint)
as $$
declare numero_ventas numeric;
begin
	return query
		select product_id,product_name,unit_price,units_in_stock from products
		where product_name like '%n';
end;
$$ LANGUAGE plpgsql;
select * from obtener_tabla_productos()




-- Creamos la función contador_ordenes_anio()
--QUE CUENTE LAS ORDENES POR AÑO devuelve una tabla con año y contador

CREATE OR REPLACE FUNCTION contador_ordenes_anio()
RETURNS TABLE (anio NUMERIC, contador BIGINT) AS $$
BEGIN
  RETURN QUERY 
    SELECT EXTRACT(YEAR FROM order_date) AS anio, COUNT(order_id) AS contador 
    FROM public.orders 
    GROUP BY EXTRACT(YEAR FROM order_date) 
    ORDER BY EXTRACT(YEAR FROM order_date);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM contador_ordenes_anio();



--3. Lo mismo que el ejemplo anterior pero con un parametro de entrada que sea el año

CREATE OR REPLACE FUNCTION contador_ordenes_anio(anio_param INTEGER)
RETURNS TABLE (anio NUMERIC, contador BIGINT) AS $$
BEGIN
  RETURN QUERY 
    SELECT EXTRACT(YEAR FROM order_date) AS anio, COUNT(order_id) AS contador 
    FROM public.orders 
    WHERE EXTRACT(YEAR FROM order_date) = anio_param 
    GROUP BY EXTRACT(YEAR FROM order_date) 
    ORDER BY EXTRACT(YEAR FROM order_date);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM contador_ordenes_anio(1998);





--4. PROCEDIMIENTO ALMACENADO PARA OBTENER PRECIO PROMEDIO Y SUMA DE 
--UNIDADES EN STOCK POR CATEGORIA

create or replace function obtener_promedio_suma()
returns table(categoria smallint,precio_promedio double precision, suma_unidades bigint)
as $$
declare numero_unidades numeric;
begin
	return query
		select category_id,avg(unit_price),sum(units_in_stock) from products
		group by category_id;
end;
$$ LANGUAGE plpgsql;
select * from obtener_promedio,suma();