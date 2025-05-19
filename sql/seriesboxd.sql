-- Creación de la base de datos
CREATE DATABASE SeriesDB;

USE SeriesDB;

-- Tabla de Usuarios
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_picture_url VARCHAR(255)
);

-- Tabla de Directores
CREATE TABLE Directors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    photo_url VARCHAR(255),
    birth_date DATE
);

-- Tabla de Actores
CREATE TABLE Actors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    photo_url VARCHAR(255),
    birth_date DATE
);

-- Tabla de Géneros
CREATE TABLE Genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Series
CREATE TABLE Series (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    release_year INT,
    end_year INT DEFAULT NULL,
    cover_url VARCHAR(255)
);

-- Tabla de relación Series-Directores
CREATE TABLE SeriesDirector (
    director_id INT NOT NULL,
    serie_id INT NOT NULL,
    work_year INT,
    PRIMARY KEY (director_id, serie_id),
    FOREIGN KEY (director_id) REFERENCES Directors (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de relación Series-Actores
CREATE TABLE SeriesActors (
    actor_id INT NOT NULL,
    serie_id INT NOT NULL,
    role_name VARCHAR(100),
    work_year INT,
    PRIMARY KEY (actor_id, serie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de relación Series-Géneros
CREATE TABLE SeriesGenres (
    genre_id INT NOT NULL,
    serie_id INT NOT NULL,
    PRIMARY KEY (genre_id, serie_id),
    FOREIGN KEY (genre_id) REFERENCES Genres (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de Temporadas
CREATE TABLE Seasons (
    id INT AUTO_INCREMENT,
    serie_id INT NOT NULL,
    number INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (serie_id, number),
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de Episodios
CREATE TABLE Episodes (
    id INT AUTO_INCREMENT,
    serie_id INT NOT NULL,
    season_id INT NOT NULL,
    number INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    air_date DATE,
    duration INT, -- En minutos
    PRIMARY KEY (id),
    UNIQUE KEY (serie_id, season_id, number),
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE,
    FOREIGN KEY (season_id) REFERENCES Seasons (id) ON DELETE CASCADE
);

-- Tabla de Watchlist (Lista de series para ver)
CREATE TABLE Watchlist (
    user_id INT NOT NULL,
    serie_id INT NOT NULL,
    PRIMARY KEY (user_id, serie_id),
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de Series Vistas
CREATE TABLE SeriesWatched (
    user_id INT NOT NULL,
    serie_id INT NOT NULL,
    finish_date DATE,
    rating DECIMAL(3, 1),
    PRIMARY KEY (user_id, serie_id),
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE,
    CHECK (
        rating >= 0
        AND rating <= 10
    )
);

-- Tabla de Series que se están viendo actualmente
CREATE TABLE StartedWatching (
    user_id INT NOT NULL,
    serie_id INT NOT NULL,
    start_date DATE,
    PRIMARY KEY (user_id, serie_id),
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Tabla de Series Favoritas (máximo 5 por usuario)
CREATE TABLE FavoritesSeries (
    user_id INT NOT NULL,
    serie_id INT NOT NULL,
    PRIMARY KEY (user_id, serie_id),
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (serie_id) REFERENCES Series (id) ON DELETE CASCADE
);

-- Trigger para limitar a 5 series favoritas por usuario
DELIMITER $$

CREATE TRIGGER check_favorites_limit
BEFORE INSERT ON FavoritesSeries
FOR EACH ROW
BEGIN
    DECLARE count_favorites INT;
    
    SELECT COUNT(*) INTO count_favorites
    FROM FavoritesSeries
    WHERE user_id = NEW.user_id;
    
    IF count_favorites >= 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se pueden agregar más de 5 series favoritas por usuario';
    END IF;
END$$

DELIMITER;

-- Inserción de datos de ejemplo

-- Insertar Usuarios
INSERT INTO
    Users (
        username,
        email,
        password,
        profile_picture_url
    )
VALUES (
        'user1',
        'user1@example.com',
        'password123',
        'https://example.com/profiles/user1.jpg'
    ),
    (
        'user2',
        'user2@example.com',
        'securepass',
        'https://example.com/profiles/user2.jpg'
    ),
    (
        'user3',
        'user3@example.com',
        'pass1234',
        'https://example.com/profiles/user3.jpg'
    ),
    (
        'user4',
        'user4@example.com',
        'strongpwd',
        'https://example.com/profiles/user4.jpg'
    ),
    (
        'user5',
        'user5@example.com',
        'user5pass',
        'https://example.com/profiles/user5.jpg'
    );

-- Insertar Directores
INSERT INTO
    Directors (name, photo_url, birth_date)
VALUES (
        'Vince Gilligan',
        'https://example.com/directors/vince_gilligan.jpg',
        '1967-02-10'
    ),
    (
        'David Benioff',
        'https://example.com/directors/david_benioff.jpg',
        '1970-09-25'
    ),
    (
        'Shonda Rhimes',
        'https://example.com/directors/shonda_rhimes.jpg',
        '1970-01-13'
    ),
    (
        'Mike Flanagan',
        'https://example.com/directors/mike_flanagan.jpg',
        '1978-05-20'
    ),
    (
        'Ava DuVernay',
        'https://example.com/directors/ava_duvernay.jpg',
        '1972-08-24'
    );

-- Insertar Actores
INSERT INTO
    Actors (name, photo_url, birth_date)
VALUES (
        'Bryan Cranston',
        'https://example.com/actors/bryan_cranston.jpg',
        '1956-03-07'
    ),
    (
        'Emilia Clarke',
        'https://example.com/actors/emilia_clarke.jpg',
        '1986-10-23'
    ),
    (
        'Pedro Pascal',
        'https://example.com/actors/pedro_pascal.jpg',
        '1975-04-02'
    ),
    (
        'Viola Davis',
        'https://example.com/actors/viola_davis.jpg',
        '1965-08-11'
    ),
    (
        'Sarah Paulson',
        'https://example.com/actors/sarah_paulson.jpg',
        '1974-12-17'
    ),
    (
        'Oscar Isaac',
        'https://example.com/actors/oscar_isaac.jpg',
        '1979-03-09'
    ),
    (
        'Victoria Pedretti',
        'https://example.com/actors/victoria_pedretti.jpg',
        '1995-03-23'
    ),
    (
        'Jon Bernthal',
        'https://example.com/actors/jon_bernthal.jpg',
        '1976-09-20'
    );

-- Insertar Géneros
INSERT INTO
    Genres (name)
VALUES ('Drama'),
    ('Ciencia Ficción'),
    ('Fantasía'),
    ('Thriller'),
    ('Comedia'),
    ('Horror'),
    ('Acción'),
    ('Aventura'),
    ('Sci-Fi');

-- Insertar Series
INSERT INTO Series (
    title,
    description,
    release_year,
    end_year,
    cover_url
)
VALUES
(
    'Breaking Bad',
    'Un profesor de química diagnosticado con cáncer inoperable de pulmón recurre a la fabricación y venta de metanfetaminas para asegurar el futuro de su familia.',
    2008,
    2013,
    'https://m.media-amazon.com/images/M/MV5BMjI3NjY3Njk3MF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg'
),
(
    'Game of Thrones',
    'Nueve familias nobles luchan por el control de las tierras de Poniente, mientras que un antiguo enemigo regresa después de estar inactivo durante milenios.',
    2011,
    2019,
    'https://m.media-amazon.com/images/M/MV5BMjE3MzY3NDk4NV5BMl5BanBnXkFtZTgwNzY2NzQ2NzM@._V1_.jpg'
),
(
    'How to Get Away with Murder',
    'Un grupo de ambiciosos estudiantes de derecho y su brillante profesora de defensa criminal se ven envueltos en un retorcido caso de asesinato.',
    2014,
    2020,
    'https://m.media-amazon.com/images/M/MV5BMTc5MTQ2MTU2N15BMl5BanBnXkFtZTgwNTk2MTc0MzE@._V1_.jpg'
),
(
    'The Haunting of Hill House',
    'La historia alterna entre dos líneas temporales, siguiendo a cinco hermanos adultos cuyas experiencias paranormales en Hill House continúan persiguiéndolos.',
    2018,
    2018,
    'https://m.media-amazon.com/images/M/MV5BMjA3NDkwMjY5MV5BMl5BanBnXkFtZTgwNzU5MTg2NjM@._V1_.jpg'
),
(
    'When They See Us',
    'Cinco adolescentes de Harlem quedan atrapados en una pesadilla cuando son acusados falsamente de un ataque brutal en Central Park.',
    2019,
    2019,
    'https://m.media-amazon.com/images/M/MV5BMjA3MjQzNDMwNF5BMl5BanBnXkFtZTgwMDczNTgxNzM@._V1_.jpg'
),
(
    'The Mandalorian',
    'Las aventuras de un pistolero solitario en los confines de la galaxia, lejos de la autoridad de la Nueva República.',
    2019,
    NULL,
    'https://m.media-amazon.com/images/M/MV5BM2YxYzg3YzYtODg2Yy00ZTI0LWJkZGItZTYxYmRkNmY0ZTFkXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg'
);


-- Insertar relaciones SeriesDirector
INSERT INTO
    SeriesDirector (
        director_id,
        serie_id,
        work_year
    )
VALUES (1, 1, 2008), -- Vince Gilligan - Breaking Bad
    (2, 2, 2011), -- David Benioff - Game of Thrones
    (3, 3, 2014), -- Shonda Rhimes - How to Get Away with Murder
    (4, 4, 2018), -- Mike Flanagan - The Haunting of Hill House
    (5, 5, 2019), -- Ava DuVernay - When They See Us
    (1, 6, 2019);
-- Vince Gilligan - The Mandalorian (ejemplo ficticio)

-- Insertar relaciones SeriesActors
INSERT INTO
    SeriesActors (
        actor_id,
        serie_id,
        role_name,
        work_year
    )
VALUES (1, 1, 'Walter White', 2008), -- Bryan Cranston - Breaking Bad
    (
        2,
        2,
        'Daenerys Targaryen',
        2011
    ), -- Emilia Clarke - Game of Thrones
    (
        4,
        3,
        'Annalise Keating',
        2014
    ), -- Viola Davis - HTGAWM
    (7, 4, 'Nell Crain', 2018), -- Victoria Pedretti - Hill House
    (8, 5, 'Korey Wise', 2019), -- Jon Bernthal - When They See Us (ficticio)
    (3, 6, 'Din Djarin', 2019), -- Pedro Pascal - The Mandalorian
    (
        5,
        3,
        'Bonnie Winterbottom',
        2014
    ), -- Sarah Paulson - HTGAWM (ficticio)
    (
        6,
        2,
        'Personnaje Ficticio',
        2011
    );
-- Oscar Isaac - Game of Thrones (ficticio)

-- Insertar relaciones SeriesGenres
INSERT INTO
    SeriesGenres (genre_id, serie_id)
VALUES (1, 1), -- Drama - Breaking Bad
    (4, 1), -- Thriller - Breaking Bad
    (1, 2), -- Drama - Game of Thrones
    (3, 2), -- Fantasía - Game of Thrones
    (1, 3), -- Drama - HTGAWM
    (4, 3), -- Thriller - HTGAWM
    (1, 4), -- Drama - Hill House
    (6, 4), -- Horror - Hill House
    (1, 5), -- Drama - When They See Us
    (2, 6), -- Ciencia Ficción - The Mandalorian
    (7, 6), -- Acción - The Mandalorian
    (8, 6);
-- Aventura - The Mandalorian

-- Insertar Temporadas
INSERT INTO
    Seasons (serie_id, number)
VALUES (1, 1), -- Breaking Bad Temporada 1
    (1, 2), -- Breaking Bad Temporada 2
    (1, 3), -- Breaking Bad Temporada 3
    (1, 4), -- Breaking Bad Temporada 4
    (1, 5), -- Breaking Bad Temporada 5
    (2, 1), -- Game of Thrones Temporada 1
    (2, 2), -- Game of Thrones Temporada 2
    (2, 3), -- Game of Thrones Temporada 3
    (3, 1), -- HTGAWM Temporada 1
    (3, 2), -- HTGAWM Temporada 2
    (4, 1), -- Hill House Temporada 1
    (5, 1), -- When They See Us Temporada 1
    (6, 1), -- The Mandalorian Temporada 1
    (6, 2);
-- The Mandalorian Temporada 2

-- Insertar Episodios (solo algunos ejemplos)
INSERT INTO
    Episodes (
        serie_id,
        season_id,
        number,
        title,
        air_date,
        duration
    )
VALUES
    -- Breaking Bad Temporada 1
    (
        1,
        1,
        1,
        'Pilot',
        '2008-01-20',
        58
    ),
    (
        1,
        1,
        2,
        'Cat\'s in the Bag...',
        '2008-01-27',
        48
    ),
    (
        1,
        1,
        3,
        '...And the Bag\'s in the River',
        '2008-02-10',
        48
    ),
    -- Breaking Bad Temporada 2
    (
        1,
        2,
        1,
        'Seven Thirty-Seven',
        '2009-03-08',
        47
    ),
    (
        1,
        2,
        2,
        'Grilled',
        '2009-03-15',
        48
    ),
    -- Game of Thrones Temporada 1
    (
        2,
        6,
        1,
        'Winter Is Coming',
        '2011-04-17',
        62
    ),
    (
        2,
        6,
        2,
        'The Kingsroad',
        '2011-04-24',
        56
    ),
    -- HTGAWM Temporada 1
    (
        3,
        9,
        1,
        'Pilot',
        '2014-09-25',
        43
    ),
    (
        3,
        9,
        2,
        'It\'s All Her Fault',
        '2014-10-02',
        43
    ),
    -- Hill House Temporada 1
    (
        4,
        11,
        1,
        'Steven Sees a Ghost',
        '2018-10-12',
        60
    ),
    (
        4,
        11,
        2,
        'Open Casket',
        '2018-10-12',
        51
    ),
    -- When They See Us Temporada 1
    (
        5,
        12,
        1,
        'Part One',
        '2019-05-31',
        64
    ),
    (
        5,
        12,
        2,
        'Part Two',
        '2019-05-31',
        75
    ),
    -- The Mandalorian Temporada 1
    (
        6,
        13,
        1,
        'Chapter 1: The Mandalorian',
        '2019-11-12',
        39
    ),
    (
        6,
        13,
        2,
        'Chapter 2: The Child',
        '2019-11-15',
        32
    ),
    -- The Mandalorian Temporada 2
    (
        6,
        14,
        1,
        'Chapter 9: The Marshal',
        '2020-10-30',
        54
    ),
    (
        6,
        14,
        2,
        'Chapter 10: The Passenger',
        '2020-11-06',
        42
    );

-- Insertar datos en Watchlist
INSERT INTO
    Watchlist (user_id, serie_id)
VALUES (1, 2), -- user1 quiere ver Game of Thrones
    (1, 4), -- user1 quiere ver Hill House
    (2, 1), -- user2 quiere ver Breaking Bad
    (2, 5), -- user2 quiere ver When They See Us
    (3, 6), -- user3 quiere ver The Mandalorian
    (4, 3), -- user4 quiere ver HTGAWM
    (5, 2);
-- user5 quiere ver Game of Thrones

-- Insertar datos en SeriesWatched
INSERT INTO
    SeriesWatched (
        user_id,
        serie_id,
        finish_date,
        rating
    )
VALUES (1, 1, '2020-05-15', 9.5), -- user1 vio Breaking Bad
    (1, 3, '2020-07-20', 8.0), -- user1 vio HTGAWM
    (2, 2, '2020-06-10', 9.0), -- user2 vio Game of Thrones
    (2, 4, '2020-08-05', 7.5), -- user2 vio Hill House
    (3, 1, '2020-04-20', 9.8), -- user3 vio Breaking Bad
    (3, 5, '2020-09-12', 8.5), -- user3 vio When They See Us
    (4, 1, '2020-07-30', 9.2), -- user4 vio Breaking Bad
    (5, 1, '2020-08-25', 9.7);
-- user5 vio Breaking Bad

-- Insertar datos en StartedWatching
INSERT INTO
    StartedWatching (user_id, serie_id, start_date)
VALUES (1, 6, '2023-01-10'), -- user1 empezó a ver The Mandalorian
    (2, 3, '2023-02-05'), -- user2 empezó a ver HTGAWM
    (3, 2, '2023-01-15'), -- user3 empezó a ver Game of Thrones
    (4, 5, '2023-02-20'), -- user4 empezó a ver When They See Us
    (5, 6, '2023-03-01');
-- user5 empezó a ver The Mandalorian

-- Insertar datos en FavoritesSeries (respetando el límite de 5 por usuario)
INSERT INTO
    FavoritesSeries (user_id, serie_id)
VALUES (1, 1), -- user1 favorita: Breaking Bad
    (1, 3), -- user1 favorita: HTGAWM
    (2, 2), -- user2 favorita: Game of Thrones
    (2, 4), -- user2 favorita: Hill House
    (3, 1), -- user3 favorita: Breaking Bad
    (3, 5), -- user3 favorita: When They See Us
    (3, 6), -- user3 favorita: The Mandalorian
    (4, 1), -- user4 favorita: Breaking Bad
    (5, 1);
-- user5 favorita: Breaking Bad