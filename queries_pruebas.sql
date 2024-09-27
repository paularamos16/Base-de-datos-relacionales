-- 1) Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), 
-- respeta las claves primarias, foráneas y tipos de datos.


-- Se creó el ERD de la base de datos y se obtuvo el siguiente código para crear las tablas:



CREATE TABLE IF NOT EXISTS public.peliculas
(
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    anno integer NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.tags
(
    id integer NOT NULL,
    tag character varying(32) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.peliculas_tags
(
    peliculas_id integer NOT NULL,
    tags_id integer NOT NULL,
    PRIMARY KEY (peliculas_id, tags_id)
);

ALTER TABLE IF EXISTS public.peliculas_tags
    ADD FOREIGN KEY (peliculas_id)
    REFERENCES public.peliculas (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.peliculas_tags
    ADD FOREIGN KEY (tags_id)
    REFERENCES public.tags (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;




-- 2) Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
-- segunda película debe tener dos tags asociados.


insert into peliculas (id, nombre, anno) values 
	(1, 'Duna', 2021),
	(2, 'Mad Max', 2015),
	(3, 'Blade Runner 2049', 2017),
	(4, 'Alien El regureso', 1986),
	(5, 'Los juegos del hambre', 2023);


insert into tags (id, tag) values 
	(1, 'Ciencia Ficción'),
	(2, 'Acción'),
	(3, 'Fantasía'),
	(4, 'Terror'),
	(5, 'Distópica');


insert into peliculas_tags (peliculas_id, tags_id) values 
	(1, 1),
	(1, 2),
	(1, 5),
	(2, 2),
	(2, 5);
	




-- 3) Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.

select peliculas.nombre, count(peliculas_tags.tags_id) as cantidad_tags from peliculas
full join peliculas_tags
on peliculas.id = peliculas_tags.peliculas_id
group by nombre
order by cantidad_tags desc;


-- 4) Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.

-- Se creó el ERD de la base de datos y se obtuvo el siguiente código para crear las tablas:



CREATE TABLE IF NOT EXISTS public.preguntas
(
    id integer NOT NULL,
    pregunta character varying(255) NOT NULL,
    respuesta_correcta character varying NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.usuarios
(
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    edad integer NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.respuestas
(
    id integer NOT NULL,
    respuesta character varying(255) NOT NULL,
    preguntas_id integer NOT NULL,
    usuarios_id integer NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.respuestas
    ADD FOREIGN KEY (preguntas_id)
    REFERENCES public.preguntas (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.respuestas
    ADD FOREIGN KEY (usuarios_id)
    REFERENCES public.usuarios (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;





--5) Agrega 5 registros a la tabla preguntas, de los cuales: (1 punto)
-- a. 1. La primera pregunta debe ser contestada correctamente por dos usuarios distintos
-- b. 2. La pregunta 2 debe ser contestada correctamente por un usuario.
-- c. 3. Los otros dos registros deben ser respuestas incorrectas.


insert into preguntas (id, pregunta, respuesta_correcta) values
	(1, '¿Cuál es la raíz cuadrada de 9?', '3'),
	(2, '¿Quién descubrió América', 'Cristobal Colón'),
	(3, '¿Qué figura contiene la bandera de Chile', 'Estrella'),
	(4, '¿Cuánto es 3 + 7 ?', '10'),
	(5, '¿Cuántas caras tiene un cubo?', '6');


insert into usuarios (id, nombre, edad) values
	(1, 'Claudio Torres', 19),
	(2, 'María Díaz', 24),
	(3, 'Otomelo Crepúsculo', 74),
	(4, 'Juan Pérez', 33),
	(5, 'Rinna Rhona', 45);


-- a. 1. La primera pregunta debe ser contestada correctamente por dos usuarios distintos
insert into respuestas (id, respuesta, usuarios_id, preguntas_id) values
	(1, '3', 1, 1),
	(2, '3', 2, 1);



-- b. 2. La pregunta 2 debe ser contestada correctamente por un usuario.
insert into respuestas (id, respuesta, usuarios_id, preguntas_id) values
	(3, 'Cristobal Colón', 3, 2);


-- c. 3. Los otros dos registros deben ser respuestas incorrectas.
insert into respuestas (id, respuesta, usuarios_id, preguntas_id) values
	(4, '9', 4, 4),
	(5, '8', 5, 5);



--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).


SELECT usuarios.nombre, COUNT(respuestas.id) AS respuestas_correctas
	FROM usuarios
	JOIN respuestas 
		ON usuarios.id = respuestas.usuarios_id
	JOIN preguntas 
		ON respuestas.preguntas_id = preguntas.id
	WHERE respuestas.respuesta = preguntas.respuesta_correcta
	GROUP BY usuarios.nombre
	ORDER BY respuestas_correctas DESC;



-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.


SELECT preguntas.pregunta, COUNT(respuestas.id) AS respuestas_correctas
	FROM preguntas
	JOIN respuestas 
		ON preguntas.id = respuestas.preguntas_id
		WHERE respuestas.respuesta = preguntas.respuesta_correcta
		GROUP BY preguntas.pregunta;


--8.  Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación.


-- Se elimina la respuestas_usuarios_id_fkey
ALTER TABLE respuestas 
	DROP CONSTRAINT respuestas_usuarios_id_fkey;



-- Se agrega delete cascade
ALTER TABLE respuestas
  ADD CONSTRAINT borrado_cascada_fk FOREIGN KEY (usuarios_id)
      REFERENCES usuarios (id)
      ON DELETE CASCADE;

-- Se elimina el usuario 1
DELETE FROM usuarios WHERE id = 1;


select * from usuarios;



--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
alter table usuarios add constraint evaluar_edad check ( edad > 18);



-- 10. Altera la tabla existente de usuarios agregando el campo email con la restricción de único.
alter table usuarios add column email varchar(255) unique;





