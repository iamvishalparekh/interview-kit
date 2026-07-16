-- Sample table to verify Flyway + H2 are working
CREATE TABLE hello (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO hello (name) VALUES ('Interview Kit');
