-- Datos de prueba (ejecutar despues de 01_estructura.sql)
SET NAMES utf8mb4;
USE db_fixture_voley;

INSERT INTO equipos (nombre, descripcion) VALUES
 ('Halcones',  'Equipo de 6to A'),
 ('Titanes',   'Equipo de 6to B'),
 ('Panteras',  'Equipo de 5to A'),
 ('Dragones',  'Equipo de 5to B'),
 ('Águilas',   'Equipo de 4to A'),
 ('Tigres',    'Equipo de 4to B');

INSERT INTO jugadores (id_equipo, nombre, apellido, numero) VALUES
 (1,'Carlos','Mamani',1),(1,'Luis','Quispe',2),(1,'José','Flores',3),
 (2,'Mario','Condori',1),(2,'Diego','Choque',2),(2,'Pablo','Rojas',3),
 (3,'Ana','Vargas',1),(3,'Lucía','Gutiérrez',2),(3,'María','Poma',3),
 (4,'Sofía','Mendoza',1),(4,'Carla','Callisaya',2),(4,'Rosa','Ticona',3),
 (5,'Juan','Apaza',1),(5,'Pedro','Limachi',2),(5,'Raúl','Mamani',3),
 (6,'Elena','Quispe',1),(6,'Paola','Cruz',2),(6,'Nadia','Alanoca',3);

INSERT INTO torneos (nombre, fecha_inicio, fecha_fin, tabla_publicada, estado) VALUES
 ('Torneo Interno de Vóley 2026', '2026-11-02', '2026-11-30', 1, 'En curso');

INSERT INTO participantes (id_torneo, id_equipo) VALUES
 (1,1),(1,2),(1,3),(1,4),(1,5),(1,6);

INSERT INTO permisos (id_equipo, fecha, motivo) VALUES
 (3, '2026-11-09', 'Viaje por competencia deportiva'),
 (5, '2026-11-09', 'Actividad escolar'),
 (3, '2026-11-16', 'Problemas de salud de jugadoras');

-- fecha 3 queda programada, sin resultados
INSERT INTO partidos (id_torneo, jornada, fecha, hora, id_equipo_local, id_equipo_visitante, estado) VALUES
 (1,1,'2026-11-02','15:00',1,6,'Jugado'),
 (1,1,'2026-11-02','16:30',2,5,'Jugado'),
 (1,1,'2026-11-02','18:00',3,4,'Jugado'),
 (1,2,'2026-11-09','15:00',1,2,'Jugado'),
 (1,2,'2026-11-09','16:30',4,6,'Jugado'),
 (1,3,'2026-11-16','15:00',1,5,'Programado'),
 (1,3,'2026-11-16','16:30',2,4,'Programado');

INSERT INTO resultados (id_partido, sets_equipo_local, sets_equipo_visitante) VALUES
 (1,3,0),
 (2,3,2),
 (3,1,3),
 (4,3,1),
 (5,3,2);
