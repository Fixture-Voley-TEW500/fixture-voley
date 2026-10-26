-- Base de datos: fixture y tabla de posiciones de voley
SET NAMES utf8mb4;
DROP DATABASE IF EXISTS db_fixture_voley;
CREATE DATABASE db_fixture_voley
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_fixture_voley;

CREATE TABLE usuarios (
  id_usuario  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(100)  NOT NULL,
  usuario     VARCHAR(50)   NOT NULL,
  password    VARCHAR(255)  NOT NULL,
  estado      TINYINT(1)    NOT NULL DEFAULT 1,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuarios_usuario (usuario)
) ENGINE=InnoDB;

CREATE TABLE equipos (
  id_equipo    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(100)  NOT NULL,
  descripcion  VARCHAR(255)  NULL,
  estado       TINYINT(1)    NOT NULL DEFAULT 1,
  PRIMARY KEY (id_equipo),
  UNIQUE KEY uq_equipos_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE jugadores (
  id_jugador  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_equipo   INT UNSIGNED  NOT NULL,
  nombre      VARCHAR(80)   NOT NULL,
  apellido    VARCHAR(80)   NOT NULL,
  numero      TINYINT UNSIGNED NOT NULL,
  estado      TINYINT(1)    NOT NULL DEFAULT 1,
  PRIMARY KEY (id_jugador),
  UNIQUE KEY uq_jugadores_equipo_numero (id_equipo, numero),
  CONSTRAINT fk_jugadores_equipo
    FOREIGN KEY (id_equipo) REFERENCES equipos (id_equipo)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE permisos (
  id_permiso  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_equipo   INT UNSIGNED  NOT NULL,
  fecha       DATE          NOT NULL,
  motivo      VARCHAR(255)  NOT NULL,
  estado      TINYINT(1)    NOT NULL DEFAULT 1,
  PRIMARY KEY (id_permiso),
  UNIQUE KEY uq_permisos_equipo_fecha (id_equipo, fecha),
  KEY idx_permisos_fecha (fecha),
  CONSTRAINT fk_permisos_equipo
    FOREIGN KEY (id_equipo) REFERENCES equipos (id_equipo)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE torneos (
  id_torneo        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  nombre           VARCHAR(120)  NOT NULL,
  fecha_inicio     DATE          NOT NULL,
  fecha_fin        DATE          NULL,
  tabla_publicada  TINYINT(1)    NOT NULL DEFAULT 0,
  estado           ENUM('Pendiente','En curso','Finalizado') NOT NULL DEFAULT 'Pendiente',
  PRIMARY KEY (id_torneo),
  CONSTRAINT ck_torneos_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE participantes (
  id_participante  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_torneo        INT UNSIGNED  NOT NULL,
  id_equipo        INT UNSIGNED  NOT NULL,
  estado           TINYINT(1)    NOT NULL DEFAULT 1,
  PRIMARY KEY (id_participante),
  UNIQUE KEY uq_participantes_torneo_equipo (id_torneo, id_equipo),
  CONSTRAINT fk_participantes_torneo
    FOREIGN KEY (id_torneo) REFERENCES torneos (id_torneo)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_participantes_equipo
    FOREIGN KEY (id_equipo) REFERENCES equipos (id_equipo)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE partidos (
  id_partido         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_torneo          INT UNSIGNED  NOT NULL,
  jornada            SMALLINT UNSIGNED NOT NULL,
  fecha              DATE          NOT NULL,
  hora               TIME          NULL,
  id_equipo_local      INT UNSIGNED NOT NULL,
  id_equipo_visitante  INT UNSIGNED NOT NULL,
  estado             ENUM('Programado','Jugado','Suspendido') NOT NULL DEFAULT 'Programado',
  PRIMARY KEY (id_partido),
  UNIQUE KEY uq_partidos_enfrentamiento (id_torneo, id_equipo_local, id_equipo_visitante),
  KEY idx_partidos_fecha (id_torneo, fecha),
  CONSTRAINT fk_partidos_torneo
    FOREIGN KEY (id_torneo) REFERENCES torneos (id_torneo)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_partidos_local
    FOREIGN KEY (id_equipo_local) REFERENCES equipos (id_equipo)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_partidos_visitante
    FOREIGN KEY (id_equipo_visitante) REFERENCES equipos (id_equipo)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT ck_partidos_equipos_distintos CHECK (id_equipo_local <> id_equipo_visitante)
) ENGINE=InnoDB;

CREATE TABLE resultados (
  id_resultado          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_partido            INT UNSIGNED NOT NULL,
  sets_equipo_local     TINYINT UNSIGNED NOT NULL,
  sets_equipo_visitante TINYINT UNSIGNED NOT NULL,
  fecha_registro        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_resultado),
  UNIQUE KEY uq_resultados_partido (id_partido),
  CONSTRAINT fk_resultados_partido
    FOREIGN KEY (id_partido) REFERENCES partidos (id_partido)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ck_resultados_sets CHECK (
        (sets_equipo_local = 3 AND sets_equipo_visitante < 3)
     OR (sets_equipo_visitante = 3 AND sets_equipo_local < 3))
) ENGINE=InnoDB;

CREATE VIEW vista_resultados_equipo AS
  SELECT p.id_torneo, p.id_equipo_local AS id_equipo,
         r.sets_equipo_local AS sets_favor, r.sets_equipo_visitante AS sets_contra
  FROM partidos p JOIN resultados r ON r.id_partido = p.id_partido
  UNION ALL
  SELECT p.id_torneo, p.id_equipo_visitante,
         r.sets_equipo_visitante, r.sets_equipo_local
  FROM partidos p JOIN resultados r ON r.id_partido = p.id_partido;

-- puntos: 3-0 y 3-1 = 3, 3-2 = 2, 2-3 = 1, 1-3 y 0-3 = 0
CREATE VIEW vista_tabla_posiciones AS
  SELECT pa.id_torneo,
         e.id_equipo,
         e.nombre                                              AS equipo,
         COUNT(v.id_equipo)                                    AS pj,
         COALESCE(SUM(v.sets_favor > v.sets_contra), 0)        AS pg,
         COALESCE(SUM(v.sets_favor < v.sets_contra), 0)        AS pp,
         COALESCE(SUM(v.sets_favor), 0)                        AS sets_favor,
         COALESCE(SUM(v.sets_contra), 0)                       AS sets_contra,
         COALESCE(SUM(v.sets_favor), 0) - COALESCE(SUM(v.sets_contra), 0) AS dif_sets,
         COALESCE(SUM(CASE
              WHEN v.sets_favor = 3 AND v.sets_contra <= 1 THEN 3
              WHEN v.sets_favor = 3 AND v.sets_contra = 2  THEN 2
              WHEN v.sets_favor = 2 AND v.sets_contra = 3  THEN 1
              ELSE 0 END), 0)                                  AS puntos
  FROM participantes pa
  JOIN equipos e ON e.id_equipo = pa.id_equipo
  LEFT JOIN vista_resultados_equipo v
         ON v.id_torneo = pa.id_torneo AND v.id_equipo = pa.id_equipo
  GROUP BY pa.id_torneo, e.id_equipo, e.nombre;

-- usuario: admin / contraseña: admin123 (guardada con hash)
INSERT INTO usuarios (nombre, usuario, password, estado)
VALUES ('Administrador', 'admin', '$2y$10$D6gBnBXREcJ9s5HQWfmccutxtF9Wkk.odOFEs/wGo/nLayvKgD4WG', 1);
