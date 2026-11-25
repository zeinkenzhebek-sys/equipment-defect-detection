-- Жабдық ақауларын анықтау жүйесінің деректер қоры (PostgreSQL)

CREATE TABLE roles (
    role_id   INTEGER PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id   INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NOT NULL UNIQUE,
    role_id   INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    location     VARCHAR(100) NOT NULL
);

CREATE TABLE equipment_assignments (
    user_id       INTEGER NOT NULL,
    equipment_id  INTEGER NOT NULL,
    assigned_date DATE NOT NULL,
    PRIMARY KEY (user_id, equipment_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

CREATE TABLE ml_models (
    model_id   INTEGER PRIMARY KEY,
    version    VARCHAR(30) NOT NULL UNIQUE,
    trained_at DATE NOT NULL,
    is_active  BOOLEAN NOT NULL
);

CREATE TABLE inspections (
    inspection_id INTEGER PRIMARY KEY,
    equipment_id  INTEGER NOT NULL,
    user_id       INTEGER NOT NULL,
    model_id      INTEGER NOT NULL,
    image_path    VARCHAR(200) NOT NULL,
    inspected_at  TIMESTAMP NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (model_id) REFERENCES ml_models(model_id)
);

CREATE TABLE defects (
    defect_id     INTEGER PRIMARY KEY,
    inspection_id INTEGER NOT NULL,
    x             INTEGER NOT NULL,
    y             INTEGER NOT NULL,
    width         INTEGER NOT NULL,
    height        INTEGER NOT NULL,
    confidence    NUMERIC(4,3) NOT NULL,
    FOREIGN KEY (inspection_id) REFERENCES inspections(inspection_id)
);

INSERT INTO roles VALUES (1,'Оператор'),(2,'Инженер'),(3,'Әкімші');

INSERT INTO users VALUES
(1,'Асқар Нұрлан','askar@plant.kz',1),
(2,'Айгүл Сәрсен','aigul@plant.kz',1),
(3,'Марат Бекұлы','marat@plant.kz',2),
(4,'Дана Ермек','dana@plant.kz',2),
(5,'Нұрсұлтан Әлім','nursultan@plant.kz',3);

INSERT INTO equipment VALUES
(1,'Конвейер лентасы №1','1-цех'),
(2,'Қазандық құбыры','2-цех'),
(3,'Гидравликалық пресс','1-цех');

INSERT INTO equipment_assignments VALUES
(1,1,'2026-09-01'),
(1,3,'2026-09-05'),
(2,2,'2026-09-02'),
(2,3,'2026-09-10'),
(3,1,'2026-09-03');

INSERT INTO ml_models VALUES
(1,'v1.0','2026-08-15',FALSE),
(2,'v1.1','2026-09-20',FALSE),
(3,'v2.0','2026-10-25',TRUE);

INSERT INTO inspections VALUES
(1,1,1,1,'img/conv_001.jpg','2026-10-01 09:15:00'),
(2,2,2,2,'img/pipe_001.jpg','2026-10-02 10:40:00'),
(3,3,1,2,'img/press_001.jpg','2026-10-03 11:05:00'),
(4,1,1,3,'img/conv_002.jpg','2026-10-05 14:20:00');

INSERT INTO defects VALUES
(1,1,120,80,40,25,0.912),
(2,1,300,150,30,30,0.847),
(3,2,50,60,60,45,0.955),
(4,3,200,210,35,20,0.781),
(5,4,90,40,25,25,0.823);

-- Сұраныс 1: 4 кестені JOIN арқылы біріктіру
SELECT e.name AS equipment, u.full_name AS operator,
       i.inspected_at, d.confidence
FROM defects d
JOIN inspections i ON d.inspection_id = i.inspection_id
JOIN equipment e   ON i.equipment_id = e.equipment_id
JOIN users u       ON i.user_id = u.user_id
ORDER BY i.inspected_at;

-- Сұраныс 2: GROUP BY (жабдық бойынша ақаулар саны)
SELECT e.name AS equipment, COUNT(d.defect_id) AS defect_count
FROM equipment e
JOIN inspections i ON i.equipment_id = e.equipment_id
JOIN defects d     ON d.inspection_id = i.inspection_id
GROUP BY e.name
ORDER BY defect_count DESC;
