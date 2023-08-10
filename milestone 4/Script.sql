CREATE TABLE Agent (
    AID char(10) PRIMARY KEY, 
    first_name char(20), 
    last_name char(20)
);
 
CREATE TABLE Player (
    PID char(10) PRIMARY KEY,
    AID char(10) NOT NULL, 
    first_name char(20), 
    last_name char(20), 
    date_of_birth date, 
    health_status char(1), 
    national_team char(3), 
    position char(20),
    FOREIGN KEY (AID) REFERENCES Agent (AID)
        ON DELETE CASCADE
);

CREATE TABLE Club (
    clubID CHAR(10) PRIMARY KEY,
    club_name CHAR(20),
    country CHAR(20),
    city CHAR(20),
    ownership CHAR(20)
);

CREATE TABLE Team (
    clubID CHAR(10),
    team_name CHAR(20),
    PRIMARY KEY (clubID, team_name),
    FOREIGN KEY (clubID) REFERENCES Club (clubID)
   	 ON DELETE CASCADE
);

CREATE TABLE PlayerPlaysForTeam (
    PID char(10), 
    clubID char(10), 
    team_name char(20), 
    year_started int,
    PRIMARY KEY (PID, clubID, team_name),
    FOREIGN KEY (PID) REFERENCES Player (PID)
        ON DELETE CASCADE,
    FOREIGN KEY (clubID, team_name) REFERENCES Team (clubID, team_name)
);

CREATE TABLE Sponsor (
    SID char(10) PRIMARY KEY, 
    company_name char(20)
);
 
CREATE TABLE Sponsors (
    SID char(10), 
    clubID char(10),
    PRIMARY KEY (SID, clubID),
    FOREIGN KEY (SID) REFERENCES Sponsor (SID),
    FOREIGN KEY (clubID) REFERENCES Club (clubID)
);

CREATE TABLE Stadium_PNAS (
    postal_code INTEGER UNIQUE,
    address CHAR(30),
    stad_name CHAR(20),
    seats INTEGER,
    PRIMARY KEY (address, postal_code)
);

CREATE TABLE Stadium_PCI (
    postal_code INTEGER PRIMARY KEY,
    city CHAR(20),
    FOREIGN KEY (postal_code) REFERENCES Stadium_PNAS (postal_code)
);

CREATE TABLE Stadium_PCO (
    postal_code INTEGER PRIMARY KEY,
    country CHAR(20),
    FOREIGN KEY (postal_code) REFERENCES Stadium_PNAS (postal_code)
);

CREATE TABLE teamHasStad (
    team_name CHAR(20),
    clubID CHAR(10),
    address CHAR(30),
    postal_code INTEGER,
    PRIMARY KEY (team_name, clubID, address, postal_code),
    FOREIGN KEY (team_name, clubID) REFERENCES Team (team_name, clubID),
    FOREIGN KEY (address, postal_code) REFERENCES Stadium_PNAS (address, postal_code)
);

CREATE TABLE Game (
    GID CHAR(10) PRIMARY KEY,
    address CHAR(30) NOT NULL,
    postal_code INTEGER NOT NULL,
    date_played date,
    referee CHAR(20),
    winner CHAR(10),
    goals_scored INTEGER,
    FOREIGN KEY (address, postal_code) REFERENCES Stadium_PNAS (address, postal_code) 
      ON DELETE SET NULL,
    FOREIGN KEY (winner) REFERENCES Club (clubID)
);

CREATE TABLE teamPlaysInGame (
    clubID CHAR(10),
    team_name CHAR(20),
    GID CHAR(10),
    goals INTEGER,
    PRIMARY KEY(clubID, team_name, GID),
    FOREIGN KEY(clubID, team_name) REFERENCES Team,
    FOREIGN KEY(GID) REFERENCES Game
);

CREATE TABLE Coach_C1 (
    years_of_experience INT PRIMARY KEY,
    salary INT
);

CREATE TABLE Coach_C2 (
    CID CHAR(10) PRIMARY KEY,
    first_name CHAR(20),
    last_name CHAR(20),
    nationality CHAR(3),
    years_of_experience INT, 
    FOREIGN KEY (years_of_experience) REFERENCES Coach_C1
);

CREATE TABLE Coaches (
    CID CHAR(10) NOT NULL,
    clubID CHAR(10),
    team_name CHAR(20),
    years INT,
    PRIMARY KEY (CID, clubID, team_name),
    FOREIGN KEY (CID) REFERENCES Coach_C2,
    FOREIGN KEY (clubID, team_name) REFERENCES Team
);

CREATE TABLE Stage (
    SID CHAR(10) PRIMARY KEY,
    letter CHAR(1)
);

CREATE TABLE GameIsInStage (
    clubID CHAR(10),
    team_name CHAR(20),
    GID CHAR(10),
    SID CHAR(10), 
    PRIMARY KEY (clubID, team_name, GID),
    FOREIGN KEY (clubID, team_name) REFERENCES Team,
    FOREIGN KEY (GID) REFERENCES Game, 
    FOREIGN KEY (SID) REFERENCES Stage
);

/* Populate tuples: */

INSERT INTO Club VALUES ('JUV', 'Juventus', 'Italy', 'Turin', 'Private');
INSERT INTO Club VALUES ('BVB', 'Borussia Dortmund', 'Germany', 'Dortmund', 'Private');
INSERT INTO Club VALUES ('ARS', 'Arsenal', 'England', 'London', 'Private');
INSERT INTO Club VALUES ('ASM', 'AS Monaco', 'France', 'Monaco', 'Private');
INSERT INTO Club VALUES ('ATM', 'Atletico Madrid', 'Spain', 'Madrid', 'Private');
INSERT INTO Club VALUES ('LEV', 'Bayer 04 Leverkusen', 'Germany', 'Leverkusen', 'Private');
INSERT INTO Club VALUES ('SCH', 'FC Schalke 04', 'Germany', 'Gelsenkirchen', 'Public');
INSERT INTO Club VALUES ('RMA', 'Real Madrid', 'Spain', 'Madrid', 'Public');
INSERT INTO Club VALUES ('PSG', 'Paris Saint-Germain', 'France', 'Paris', 'Private');
INSERT INTO Club VALUES ('CHE', 'Chelsea', 'England', 'London', 'Private');
INSERT INTO Club VALUES ('MCI', 'Manchester City', 'England', 'Manchester', 'Private');
INSERT INTO Club VALUES ('FCB', 'Barcelona', 'Spain', 'Barcelona', 'Public');
INSERT INTO Club VALUES ('BAS', 'Basel', 'Switzerland', 'Basel', 'Private');
INSERT INTO Club VALUES ('FCP', 'FC Porto', 'Portugal', 'Porto', 'Public');
INSERT INTO Club VALUES ('SHA', 'Shakhtar Donetsk', 'Ukraine', 'Lviv', 'Private');
INSERT INTO Club VALUES ('BMU', 'Bayern Munich', 'Germany', 'Munich', 'Public');

INSERT INTO Sponsor VALUES ('SPO', 'Spotify');
INSERT INTO Sponsor VALUES ('QAT', 'Qatar Airways');
INSERT INTO Sponsor VALUES ('GAT', 'Gatorade');
INSERT INTO Sponsor VALUES ('NIK', 'Nike');
INSERT INTO Sponsor VALUES ('ADI', 'Adidas');
INSERT INTO Sponsor VALUES ('EMI', 'Emirates');

INSERT INTO Sponsors VALUES ('NIK', 'FCB');
INSERT INTO Sponsors VALUES ('EMI', 'RMA');
INSERT INTO Sponsors VALUES ('QAT', 'FCB');
INSERT INTO Sponsors VALUES ('ADI', 'BMU');
INSERT INTO Sponsors VALUES ('GAT', 'FCP');
INSERT INTO Sponsors VALUES ('SPO', 'ARS');
INSERT INTO Sponsors VALUES ('ADI', 'JUV');
INSERT INTO Sponsors VALUES ('NIK', 'LEV');

INSERT INTO Team VALUES ('JUV', 'Juventus');
INSERT INTO Team VALUES ('BVB', 'Borussia Dortmund');
INSERT INTO Team VALUES ('ARS', 'Arsenal');
INSERT INTO Team VALUES ('ASM', 'AS Monaco');
INSERT INTO Team VALUES ('ATM', 'Atletico Madrid');
INSERT INTO Team VALUES ('LEV', 'Bayer 04 Leverkusen');
INSERT INTO Team VALUES ('SCH', 'FC Schalke 04');
INSERT INTO Team VALUES ('RMA', 'Real Madrid');
INSERT INTO Team VALUES ('PSG', 'Paris Saint-Germain');
INSERT INTO Team VALUES ('CHE', 'Chelsea');
INSERT INTO Team VALUES ('MCI', 'Manchester City');
INSERT INTO Team VALUES ('FCB', 'Barcelona');
INSERT INTO Team VALUES ('BAS', 'Basel');
INSERT INTO Team VALUES ('FCP', 'FC Porto');
INSERT INTO Team VALUES ('SHA', 'Shakhtar Donetsk');
INSERT INTO Team VALUES ('BMU', 'Bayern Munich');

INSERT INTO Agent VALUES ('A1', 'Mino', 'Raiola');
INSERT INTO Agent VALUES ('A2', 'Jorge', 'Mendes');
INSERT INTO Agent VALUES ('A3', 'Jorge', 'Messi');
INSERT INTO Agent VALUES ('A4', 'Volker', 'Struth');
INSERT INTO Agent VALUES ('A5', 'Jonathan', 'Barnett');
INSERT INTO Agent VALUES ('A6', 'Jose', 'Otin');
INSERT INTO Agent VALUES ('A7', 'Fernando', 'Felicevich');
INSERT INTO Agent VALUES ('A8', 'Giuliano', 'Bertolucci');
INSERT INTO Agent VALUES ('A9', 'Thomas', 'Kroth');
INSERT INTO Agent VALUES ('A10', 'Pini', 'Zahavi');

INSERT INTO Player VALUES ('P1', 'A1', 'Paul', 'Pogba', DATE '1993-03-14', 'N', 'Fra', 'MF');
INSERT INTO Player VALUES ('P2', 'A1', 'Leonardo', 'Bonucci', DATE '1987-05-01', 'H', 'Ita', 'DF');
INSERT INTO Player VALUES ('P3', 'A10', 'Gianluigi', 'Buffon', DATE '1978-01-28', 'H', 'Ita', 'GK');
INSERT INTO Player VALUES ('P4', 'A2', 'Andrea', 'Pirlo', DATE '1979-05-19', 'H', 'Ita', 'MF');
INSERT INTO Player VALUES ('P5', 'A3', 'Giorgio', 'Chiellini', DATE '1984-08-14', 'H', 'Ita', 'DF');

INSERT INTO Player VALUES ('P6', 'A1', 'Marco', 'Reus', DATE '1989-05-31', 'N', 'Ger', 'MF');
INSERT INTO Player VALUES ('P7', 'A2', 'Henrikh', 'Mkhitaryan', DATE '1989-01-21', 'H', 'Arm', 'MF');
INSERT INTO Player VALUES ('P8', 'A10', 'Ilkay', 'Gundogan', DATE '1990-10-24', 'H', 'Ger', 'MF');
INSERT INTO Player VALUES ('P9', 'A7', 'Mats', 'Hummels', DATE '1988-12-16', 'H', 'Ger', 'DF');
INSERT INTO Player VALUES ('P10', 'A3', 'Roman', 'Weidenfeller', DATE '1980-08-16', 'H', 'Ger', 'GK');

INSERT INTO Player VALUES ('P11', 'A4', 'Olivier', 'Giroud', DATE '1986-09-30', 'H', 'Fra', 'FW');
INSERT INTO Player VALUES ('P12', 'A5', 'Alexis', 'Sanchez', DATE '1988-12-19', 'H', 'Chi', 'FW');
INSERT INTO Player VALUES ('P13', 'A6', 'Hector', 'Bellerin', DATE '1995-03-19', 'H', 'Esp', 'DF');
INSERT INTO Player VALUES ('P14', 'A7', 'Danny', 'Welbeck', DATE '1990-11-26', 'N', 'Eng', 'FW');
INSERT INTO Player VALUES ('P15', 'A8', 'David', 'Ospina', DATE '1988-08-31', 'H', 'Col', 'GK');

INSERT INTO Player VALUES ('P16', 'A9', 'Anthony', 'Martial', DATE '1995-12-05', 'H', 'Fra', 'FW');
INSERT INTO Player VALUES ('P17', 'A8', 'Fabio', 'Tavares', DATE '1993-10-23', 'H', 'Bra', 'MF');
INSERT INTO Player VALUES ('P18', 'A7', 'Almamy', 'Toure', DATE '1996-04-28', 'N', 'Mli', 'DF');
INSERT INTO Player VALUES ('P19', 'A7', 'Dimitar', 'Berbatov', DATE '1981-01-30', 'N', 'Bul', 'FW');
INSERT INTO Player VALUES ('P20', 'A8', 'Danijel', 'Subasic', DATE '1984-10-27', 'H', 'Cro', 'GK');

INSERT INTO Player VALUES ('P21', 'A4', 'Heung-min', 'Son', DATE '1992-07-08', 'H', 'Kor', 'FW');
INSERT INTO Player VALUES ('P22', 'A3', 'Karim', 'Bellarabi', DATE '1990-04-08', 'H', 'Ger', 'MF');
INSERT INTO Player VALUES ('P23', 'A6', 'Josip', 'Drmic', DATE '1992-08-08', 'N', 'Sui', 'FW');
INSERT INTO Player VALUES ('P24', 'A1', 'Emir', 'Spahic', DATE '1980-08-18', 'H', 'Bih', 'DF');
INSERT INTO Player VALUES ('P25', 'A8', 'Bernd', 'Leno', DATE '1992-05-04', 'H', 'Ger', 'GK');

INSERT INTO Player VALUES ('P56', 'A4', 'Antoine', 'Griezmann', DATE '1991-03-21', 'H', 'Fra', 'FW');
INSERT INTO Player VALUES ('P57', 'A5', 'Diego', 'Godin', DATE '1986-02-16', 'H', 'Uru', 'DF');
INSERT INTO Player VALUES ('P58', 'A7', 'Mario', 'Mandzukic', DATE '1986-05-21', 'H', 'Cro', 'FW');
INSERT INTO Player VALUES ('P59', 'A3', 'Saul', 'Niguez', DATE '1994-11-21', 'N', 'Esp', 'MF');
INSERT INTO Player VALUES ('P60', 'A8', 'Miguel', 'Moya', DATE '1984-04-02', 'H', 'Esp', 'GK');

INSERT INTO Player VALUES ('P26', 'A4', 'Kevin-Prince', 'Boateng', DATE '1987-03-06', 'N', 'Gha', 'MF');
INSERT INTO Player VALUES ('P27', 'A1', 'Joel', 'Matip', DATE '1991-08-08', 'H', 'Cmr', 'DF');
INSERT INTO Player VALUES ('P28', 'A2', 'Marco', 'Hoger', DATE '1989-09-16', 'H', 'Ger', 'MF');
INSERT INTO Player VALUES ('P29', 'A7', 'Benedikt', 'Howedes', DATE '1998-02-28', 'N', 'Ger', 'DF');
INSERT INTO Player VALUES ('P30', 'A7', 'Timon', 'Wellenreuther', DATE '1995-12-03', 'H', 'Ger', 'GK');

INSERT INTO Player VALUES ('P31', 'A2', 'Cristiano', 'Ronaldo', DATE '1985-02-05', 'H', 'Por', 'FW');
INSERT INTO Player VALUES ('P32', 'A1', 'Toni', 'Kroos', DATE '1990-01-04', 'H', 'Ger', 'MF');
INSERT INTO Player VALUES ('P33', 'A6', 'Gareth', 'Bale', DATE '1989-07-16', 'H', 'Wal', 'FW');
INSERT INTO Player VALUES ('P34', 'A2', 'Marcelo', 'Vieira', DATE '1988-05-12', 'N', 'Bra', 'DF');
INSERT INTO Player VALUES ('P35', 'A2', 'Iker', 'Casillas', DATE '1981-05-20', 'H', 'Esp', 'GK');

INSERT INTO Player VALUES ('P36', 'A1', 'Zlatan', 'Ibrahimovic', DATE '1981-10-03', 'N', 'Swe', 'FW');
INSERT INTO Player VALUES ('P37', 'A2', 'Marco', 'Verratti', DATE '1992-11-05', 'H', 'Ita', 'MF');
INSERT INTO Player VALUES ('P38', 'A1', 'Edinson', 'Cavani', DATE '1987-02-14', 'N', 'Uru', 'FW');
INSERT INTO Player VALUES ('P39', 'A5', 'Thiago', 'Silva', DATE '1984-09-22', 'N', 'Bra', 'DF');
INSERT INTO Player VALUES ('P40', 'A3', 'Salvatore', 'Sirigu', DATE '1987-01-12', 'H', 'Ita', 'GK');

INSERT INTO Player VALUES ('P41', 'A2', 'Diego', 'Costa', DATE '1988-10-07', 'H', 'Esp', 'FW');
INSERT INTO Player VALUES ('P42', 'A8', 'Eden', 'Hazard', DATE '1991-01-07', 'H', 'Bel', 'FW');
INSERT INTO Player VALUES ('P43', 'A9', 'Cesc', 'Fabregas', DATE '1987-05-04', 'H', 'Esp', 'MF');
INSERT INTO Player VALUES ('P44', 'A2', 'John', 'Terry', DATE '1980-12-07', 'N', 'Eng', 'DF');
INSERT INTO Player VALUES ('P45', 'A10', 'Thibaut', 'Courtois', DATE '1992-05-11', 'H', 'Bel', 'GK');

INSERT INTO Player VALUES ('P46', 'A8', 'Sergio', 'Aguero', DATE '1988-06-02', 'N', 'Arg', 'FW');
INSERT INTO Player VALUES ('P47', 'A9', 'Martin', 'Demichelis', DATE '1980-12-20', 'H', 'Arg', 'DF');
INSERT INTO Player VALUES ('P48', 'A7', 'Vincent', 'Kompany', DATE '1986-04-10', 'H', 'Bel', 'DF');
INSERT INTO Player VALUES ('P49', 'A10', 'Edin', 'Dzeko', DATE '1986-03-17', 'N', 'Bih', 'FW');
INSERT INTO Player VALUES ('P50', 'A8', 'Joe', 'Hart', DATE '1987-04-19', 'H', 'Eng', 'GK');

INSERT INTO Player VALUES ('P51', 'A3', 'Lionel', 'Messi', DATE '1987-06-24', 'H', 'Arg', 'FW');
INSERT INTO Player VALUES ('P52', 'A1', 'Luis', 'Suarez', DATE '1987-01-24', 'N', 'Uru', 'FW');
INSERT INTO Player VALUES ('P53', 'A1', 'Neymar', 'Da Silva', DATE '1992-02-05', 'N', 'Bra', 'FW');
INSERT INTO Player VALUES ('P54', 'A7', 'Andres', 'Iniesta', DATE '1984-05-11', 'H', 'Esp', 'MF');
INSERT INTO Player VALUES ('P55', 'A10', 'Marc-Andre', 'ter Stegen', DATE '1992-04-30', 'H', 'Ger', 'GK');

INSERT INTO Player VALUES ('P61', 'A10', 'Marco', 'Streller', DATE '1981-06-18', 'H', 'Sui', 'FW');
INSERT INTO Player VALUES ('P62', 'A3', 'Luca', 'Zuffi', DATE '1990-09-27', 'N', 'Sui', 'MF');
INSERT INTO Player VALUES ('P63', 'A2', 'Fabian', 'Frei', DATE '1989-01-08', 'H', 'Sui', 'MF');
INSERT INTO Player VALUES ('P64', 'A8', 'Marek', 'Suchy', DATE '1988-03-29', 'H', 'Cze', 'DF');
INSERT INTO Player VALUES ('P65', 'A10', 'Tomas', 'Vaclik', DATE '1989-03-29', 'N', 'Cze', 'GK');

INSERT INTO Player VALUES ('P66', 'A2', 'Carlos', 'Casemiro', DATE '1992-02-23', 'H', 'Bra', 'MF');
INSERT INTO Player VALUES ('P67', 'A9', 'Cristian', 'Tello', DATE '1991-08-11', 'H', 'Esp', 'MF');
INSERT INTO Player VALUES ('P68', 'A2', 'Oliver', 'Torres', DATE '1994-11-10', 'N', 'Esp', 'MF');
INSERT INTO Player VALUES ('P69', 'A1', 'Hector', 'Herrera', DATE '1990-04-19', 'H', 'Mex', 'MF');
INSERT INTO Player VALUES ('P70', 'A7', 'Fabiano', 'Freitas', DATE '1988-02-29', 'H', 'Bra', 'GK');

INSERT INTO Player VALUES ('P71', 'A5', 'Luiz', 'Adriano', DATE '1987-04-12', 'H', 'Bra', 'FW');
INSERT INTO Player VALUES ('P72', 'A4', 'Yaroslav', 'Rakitskyi', DATE '1989-08-03', 'H', 'Ukr', 'DF');
INSERT INTO Player VALUES ('P73', 'A1', 'Douglas', 'Costa', DATE '1990-09-14', 'H', 'Bra', 'MF');
INSERT INTO Player VALUES ('P74', 'A9', 'Oleksandr', 'Kucher', DATE '1982-10-22', 'H', 'Ukr', 'DF');
INSERT INTO Player VALUES ('P75', 'A8', 'Andriy', 'Pyatov', DATE '1984-06-28', 'H', 'Ukr', 'GK');

INSERT INTO Player VALUES ('P76', 'A1', 'Mario', 'Gotze', DATE '1992-06-03', 'H', 'Ger', 'FW');
INSERT INTO Player VALUES ('P77', 'A8', 'Jerome', 'Boateng', DATE '1988-09-03', 'H', 'Ger', 'DF');
INSERT INTO Player VALUES ('P78', 'A5', 'David', 'Alaba', DATE '1992-06-24', 'N', 'Aut', 'DF');
INSERT INTO Player VALUES ('P79', 'A4', 'Bastian', 'Schweinsteiger', DATE '1984-08-01', 'H', 'Ger', 'MF');
INSERT INTO Player VALUES ('P80', 'A2', 'Manuel', 'Neuer', DATE '1986-03-27', 'H', 'Ger', 'GK');

INSERT INTO PlayerPlaysForTeam VALUES ('P1', 'JUV', 'Juventus', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P2', 'JUV', 'Juventus', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P3', 'JUV', 'Juventus', 2001);
INSERT INTO PlayerPlaysForTeam VALUES ('P4', 'JUV', 'Juventus', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P5', 'JUV', 'Juventus', 2005);

INSERT INTO PlayerPlaysForTeam VALUES ('P6', 'BVB', 'Borussia Dortmund', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P7', 'BVB', 'Borussia Dortmund', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P8', 'BVB', 'Borussia Dortmund', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P9', 'BVB', 'Borussia Dortmund', 2009);
INSERT INTO PlayerPlaysForTeam VALUES ('P10', 'BVB', 'Borussia Dortmund', 2002);

INSERT INTO PlayerPlaysForTeam VALUES ('P11', 'ARS', 'Arsenal', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P12', 'ARS', 'Arsenal', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P13', 'ARS', 'Arsenal', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P14', 'ARS', 'Arsenal', 2006);
INSERT INTO PlayerPlaysForTeam VALUES ('P15', 'ARS', 'Arsenal', 2006);

INSERT INTO PlayerPlaysForTeam VALUES ('P16', 'ASM', 'AS Monaco', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P17', 'ASM', 'AS Monaco', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P18', 'ASM', 'AS Monaco', 2007);
INSERT INTO PlayerPlaysForTeam VALUES ('P19', 'ASM', 'AS Monaco', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P20', 'ASM', 'AS Monaco', 2009);

INSERT INTO PlayerPlaysForTeam VALUES ('P21', 'LEV', 'Bayer 04 Leverkusen', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P22', 'LEV', 'Bayer 04 Leverkusen', 2009);
INSERT INTO PlayerPlaysForTeam VALUES ('P23', 'LEV', 'Bayer 04 Leverkusen', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P24', 'LEV', 'Bayer 04 Leverkusen', 2007);
INSERT INTO PlayerPlaysForTeam VALUES ('P25', 'LEV', 'Bayer 04 Leverkusen', 2010);

INSERT INTO PlayerPlaysForTeam VALUES ('P56', 'ATM', 'Atletico Madrid', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P57', 'ATM', 'Atletico Madrid', 2009);
INSERT INTO PlayerPlaysForTeam VALUES ('P58', 'ATM', 'Atletico Madrid', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P59', 'ATM', 'Atletico Madrid', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P60', 'ATM', 'Atletico Madrid', 2014);

INSERT INTO PlayerPlaysForTeam VALUES ('P26', 'SCH', 'FC Schalke 04', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P27', 'SCH', 'FC Schalke 04', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P28', 'SCH', 'FC Schalke 04', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P29', 'SCH', 'FC Schalke 04', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P30', 'SCH', 'FC Schalke 04', 2010);

INSERT INTO PlayerPlaysForTeam VALUES ('P31', 'RMA', 'Real Madrid', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P32', 'RMA', 'Real Madrid', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P33', 'RMA', 'Real Madrid', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P34', 'RMA', 'Real Madrid', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P35', 'RMA', 'Real Madrid', 2013);

INSERT INTO PlayerPlaysForTeam VALUES ('P36', 'PSG', 'Paris Saint-Germain', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P37', 'PSG', 'Paris Saint-Germain', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P38', 'PSG', 'Paris Saint-Germain', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P39', 'PSG', 'Paris Saint-Germain', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P40', 'PSG', 'Paris Saint-Germain', 2014);

INSERT INTO PlayerPlaysForTeam VALUES ('P41', 'CHE', 'Chelsea', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P42', 'CHE', 'Chelsea', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P43', 'CHE', 'Chelsea', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P44', 'CHE', 'Chelsea', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P45', 'CHE', 'Chelsea', 2014);

INSERT INTO PlayerPlaysForTeam VALUES ('P46', 'MCI', 'Manchester City', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P47', 'MCI', 'Manchester City', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P48', 'MCI', 'Manchester City', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P49', 'MCI', 'Manchester City', 2014);
INSERT INTO PlayerPlaysForTeam VALUES ('P50', 'MCI', 'Manchester City', 2011);

INSERT INTO PlayerPlaysForTeam VALUES ('P51', 'FCB', 'Barcelona', 2005);
INSERT INTO PlayerPlaysForTeam VALUES ('P52', 'FCB', 'Barcelona', 2014);
INSERT INTO PlayerPlaysForTeam VALUES ('P53', 'FCB', 'Barcelona', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P54', 'FCB', 'Barcelona', 2003);
INSERT INTO PlayerPlaysForTeam VALUES ('P55', 'FCB', 'Barcelona', 2013);

INSERT INTO PlayerPlaysForTeam VALUES ('P61', 'BAS', 'Basel', 2005);
INSERT INTO PlayerPlaysForTeam VALUES ('P62', 'BAS', 'Basel', 2002);
INSERT INTO PlayerPlaysForTeam VALUES ('P63', 'BAS', 'Basel', 2003);
INSERT INTO PlayerPlaysForTeam VALUES ('P64', 'BAS', 'Basel', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P65', 'BAS', 'Basel', 2012);

INSERT INTO PlayerPlaysForTeam VALUES ('P66', 'FCP', 'FC Porto', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P67', 'FCP', 'FC Porto', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P68', 'FCP', 'FC Porto', 2012);
INSERT INTO PlayerPlaysForTeam VALUES ('P69', 'FCP', 'FC Porto', 2013);
INSERT INTO PlayerPlaysForTeam VALUES ('P70', 'FCP', 'FC Porto', 2014);

INSERT INTO PlayerPlaysForTeam VALUES ('P71', 'SHA', 'Shakhtar Donetsk', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P72', 'SHA', 'Shakhtar Donetsk', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P73', 'SHA', 'Shakhtar Donetsk', 2009);
INSERT INTO PlayerPlaysForTeam VALUES ('P74', 'SHA', 'Shakhtar Donetsk', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P75', 'SHA', 'Shakhtar Donetsk', 2008);

INSERT INTO PlayerPlaysForTeam VALUES ('P76', 'BMU', 'Bayern Munich', 2009);
INSERT INTO PlayerPlaysForTeam VALUES ('P77', 'BMU', 'Bayern Munich', 2008);
INSERT INTO PlayerPlaysForTeam VALUES ('P78', 'BMU', 'Bayern Munich', 2010);
INSERT INTO PlayerPlaysForTeam VALUES ('P79', 'BMU', 'Bayern Munich', 2011);
INSERT INTO PlayerPlaysForTeam VALUES ('P80', 'BMU', 'Bayern Munich', 2012);

INSERT INTO Stadium_PNAS VALUES (08028, 'Arístides Maillol 12', 'Camp Nou', 95639);
INSERT INTO Stadium_PNAS VALUES (80939, '25 Werner-Heisenberg-Allee', 'Allianz Arena', 75024);
INSERT INTO Stadium_PNAS VALUES (75016, '24 Rue du Commandant Guilbaud', 'Parc des Princes', 47929);
INSERT INTO Stadium_PNAS VALUES (10151, 'Corso Gaetano Scirea 50', 'Allianz Stadium', 41507);
INSERT INTO Stadium_PNAS VALUES (51211, 'Highbury House 75', 'Emirates Stadium', 59868);
INSERT INTO Stadium_PNAS VALUES (28005, 'Paseo Virgen del Puerto 67', 'Vicente Calderon', 54907);
INSERT INTO Stadium_PNAS VALUES (28036, 'Av. de Concha Espina', 'Santiago Bernabeu', 81044);
INSERT INTO Stadium_PNAS VALUES (43504, 'Via Futebol Clube do Porto', 'Estadio do Dragao', 43108);

INSERT INTO Stadium_PCI VALUES (08028, 'Barcelona');
INSERT INTO Stadium_PCI VALUES (80939, 'Munich');
INSERT INTO Stadium_PCI VALUES (75016, 'Paris');
INSERT INTO Stadium_PCI VALUES (10151, 'Turin');
INSERT INTO Stadium_PCI VALUES (51211, 'London');
INSERT INTO Stadium_PCI VALUES (28005, 'Madrid');
INSERT INTO Stadium_PCI VALUES (28036, 'Madrid');
INSERT INTO Stadium_PCI VALUES (43504, 'Porto');

INSERT INTO Stadium_PCO VALUES (08028, 'Spain');
INSERT INTO Stadium_PCO VALUES (80939, 'Germany');
INSERT INTO Stadium_PCO VALUES (75016, 'France');
INSERT INTO Stadium_PCO VALUES (10151, 'Italy');
INSERT INTO Stadium_PCO VALUES (51211, 'England');
INSERT INTO Stadium_PCO VALUES (28005, 'Spain');
INSERT INTO Stadium_PCO VALUES (28036, 'Spain');
INSERT INTO Stadium_PCO VALUES (43504, 'Portugal');

INSERT INTO teamHasStad VALUES ('Barcelona', 'FCB', 'Arístides Maillol 12', 08028);
INSERT INTO teamHasStad VALUES ('Paris Saint-Germain', 'PSG', '24 Rue du Commandant Guilbaud', 75016);
INSERT INTO teamHasStad VALUES ('Bayern Munich', 'BMU', '25 Werner-Heisenberg-Allee', 80939);
INSERT INTO teamHasStad VALUES ('Juventus', 'JUV', 'Corso Gaetano Scirea 50', 10151);

INSERT INTO Game VALUES ('G1', 'Corso Gaetano Scirea 50', 10151, DATE '2015-02-24', 'Antonio Lahoz', 'JUV', 6);
INSERT INTO Game VALUES ('G2', 'Highbury House 75', 51211, DATE '2015-02-25', 'Deniz Aytekin', 'ASM', 6);
INSERT INTO Game VALUES ('G3', 'Paseo Virgen del Puerto 67', 28005, DATE '2015-03-17', 'Nicola Rizzoli', 'ATM', 7);
INSERT INTO Game VALUES ('G4', 'Av. de Concha Espina', 28036, DATE '2015-03-10', 'Damir Skomina', 'RMA', 9);
INSERT INTO Game VALUES ('G5', '24 Rue du Commandant Guilbaud', 75016, DATE '2015-02-17', 'Cuneyt Cakir', 'PSG', 6);
INSERT INTO Game VALUES ('G6', 'Arístides Maillol 12', 08028, DATE '2015-03-18', 'Gianluca Rocchi', 'FCB', 4);
INSERT INTO Game VALUES ('G7', 'Via Futebol Clube do Porto', 43504, DATE '2015-03-10', 'Jonas Eriksson', 'FCP', 6);
INSERT INTO Game VALUES ('G8', '25 Werner-Heisenberg-Allee', 80939, DATE '2015-03-11', 'William Collum', 'BMU', 7);

INSERT INTO Game VALUES ('G9', 'Corso Gaetano Scirea 50', 10151, DATE '2015-04-14', 'Pavel Kralovec', 'JUV', 1);
INSERT INTO Game VALUES ('G10', 'Paseo Virgen del Puerto 67', 28005, DATE '2015-04-14', 'Milorad Mazic', 'RMA', 1);
INSERT INTO Game VALUES ('G11', '24 Rue du Commandant Guilbaud', 75016, DATE '2015-04-21', 'Mark Clattenburg', 'FCB', 6);
INSERT INTO Game VALUES ('G12', 'Via Futebol Clube do Porto', 43504, DATE '2015-04-21', 'Carlos Carballo', 'BMU', 11);

INSERT INTO Game VALUES ('G13', 'Av. de Concha Espina', 28036, DATE '2015-05-13', 'Martin Atkinson', 'JUV', 5);
INSERT INTO Game VALUES ('G14', '25 Werner-Heisenberg-Allee', 80939, DATE '2015-05-06', 'Nicola Rizzoli', 'FCB', 8);

INSERT INTO Game VALUES ('G15', 'Arístides Maillol 12', 08028, DATE '2015-06-06', 'Cuneyt Cakir', 'FCB', 4);

INSERT INTO teamPlaysInGame VALUES ('JUV', 'Juventus', 'G1', 5);
INSERT INTO teamPlaysInGame VALUES ('BVB', 'Borussia Dortmund', 'G1', 1);
INSERT INTO teamPlaysInGame VALUES ('ARS', 'Arsenal', 'G2', 3);
INSERT INTO teamPlaysInGame VALUES ('ASM', 'AS Monaco', 'G2', 3);
INSERT INTO teamPlaysInGame VALUES ('LEV', 'Bayer 04 Leverkusen', 'G3', 3);
INSERT INTO teamPlaysInGame VALUES ('ATM', 'Atletico Madrid', 'G3', 4);
INSERT INTO teamPlaysInGame VALUES ('SCH', 'FC Schalke 04', 'G4', 4);
INSERT INTO teamPlaysInGame VALUES ('RMA', 'Real Madrid', 'G4', 5);
INSERT INTO teamPlaysInGame VALUES ('PSG', 'Paris Saint-Germain', 'G5', 3);
INSERT INTO teamPlaysInGame VALUES ('CHE', 'Chelsea', 'G5', 3);
INSERT INTO teamPlaysInGame VALUES ('MCI', 'Manchester City', 'G6', 1);
INSERT INTO teamPlaysInGame VALUES ('FCB', 'Barcelona', 'G6', 3);
INSERT INTO teamPlaysInGame VALUES ('BAS', 'Basel', 'G7', 1);
INSERT INTO teamPlaysInGame VALUES ('FCP', 'FC Porto', 'G7', 5);
INSERT INTO teamPlaysInGame VALUES ('SHA', 'Shakhtar Donetsk', 'G8', 0);
INSERT INTO teamPlaysInGame VALUES ('BMU', 'Bayern Munich', 'G8', 7);

INSERT INTO teamPlaysInGame VALUES ('JUV', 'Juventus', 'G9', 1);
INSERT INTO teamPlaysInGame VALUES ('ASM', 'AS Monaco', 'G9', 0);
INSERT INTO teamPlaysInGame VALUES ('ATM', 'Atletico Madrid', 'G10', 0);
INSERT INTO teamPlaysInGame VALUES ('RMA', 'Real Madrid', 'G10', 1);
INSERT INTO teamPlaysInGame VALUES ('PSG', 'Paris Saint-Germain', 'G11', 1);
INSERT INTO teamPlaysInGame VALUES ('FCB', 'Barcelona', 'G11', 5);
INSERT INTO teamPlaysInGame VALUES ('FCP', 'FC Porto', 'G12', 4);
INSERT INTO teamPlaysInGame VALUES ('BMU', 'Bayern Munich', 'G12', 7);

INSERT INTO teamPlaysInGame VALUES ('JUV', 'Juventus', 'G13', 3);
INSERT INTO teamPlaysInGame VALUES ('RMA', 'Real Madrid', 'G13', 2);
INSERT INTO teamPlaysInGame VALUES ('FCB', 'Barcelona', 'G14', 5);
INSERT INTO teamPlaysInGame VALUES ('BMU', 'Bayern Munich', 'G14', 3);

INSERT INTO teamPlaysInGame VALUES ('JUV', 'Juventus', 'G15', 1);
INSERT INTO teamPlaysInGame VALUES ('FCB', 'Barcelona', 'G15', 3);


INSERT INTO Coach_C1 VALUES (12, 37000000);
INSERT INTO Coach_C1 VALUES (8, 12000000);
INSERT INTO Coach_C1 VALUES (22, 10000000);
INSERT INTO Coach_C1 VALUES (1, 14000000);
INSERT INTO Coach_C1 VALUES (10, 25800000);
INSERT INTO Coach_C1 VALUES (2, 15800000);

INSERT INTO Coach_C2 VALUES ('C1', 'Massimiliano','Allegri', 'Ita', 12); 
INSERT INTO Coach_C2 VALUES ('C2', 'Jurgen', 'Klopp', 'Ger', 8);
INSERT INTO Coach_C2 VALUES ('C3', 'Arsen', 'Wenger', 'Fra', 22);
INSERT INTO Coach_C2 VALUES ('C4', 'Leonardo', 'Jardim', 'Por', 1);
INSERT INTO Coach_C2 VALUES ('C5', 'Diego', 'Simeone', 'Arg', 10);
INSERT INTO Coach_C2 VALUES ('C6', 'Roger', 'Schmidt', 'Ger', 1);
INSERT INTO Coach_C2 VALUES ('C7', 'Erwin', 'Smith', 'Ger', 2);
INSERT INTO Coach_C2 VALUES ('C8', 'Zinedine', 'Zidane', 'Fra', 1);
INSERT INTO Coach_C2 VALUES ('C9', 'Laurent', 'Blanc', 'Fra', 1);
INSERT INTO Coach_C2 VALUES ('C10', 'Guus', 'Hiddink', 'Ned', 22);
INSERT INTO Coach_C2 VALUES ('C11', 'Manuel', 'Pellegrini', 'Chi', 8);
INSERT INTO Coach_C2 VALUES ('C12', 'Luis', 'Enrique', 'Esp', 2);
INSERT INTO Coach_C2 VALUES ('C13', 'Levi', 'Ackerman', 'Fra', 1);
INSERT INTO Coach_C2 VALUES ('C14', 'Jose', 'Mourinho', 'Por', 10);
INSERT INTO Coach_C2 VALUES ('C15', 'Alexander', 'Schevchenko', 'Ukr', 2);
INSERT INTO Coach_C2 VALUES ('C16', 'Josep', 'Guardiola', 'Esp', 8);

INSERT INTO Coaches VALUES ('C1', 'JUV', 'Juventus', 2);
INSERT INTO Coaches VALUES ('C2', 'BVB', 'Borussia Dortmund', 4);
INSERT INTO Coaches VALUES ('C3', 'ARS', 'Arsenal', 3);
INSERT INTO Coaches VALUES ('C4', 'ASM', 'AS Monaco', 1);
INSERT INTO Coaches VALUES ('C5', 'ATM', 'Atletico Madrid', 6);
INSERT INTO Coaches VALUES ('C6', 'LEV', 'Bayer 04 Leverkusen', 3);
INSERT INTO Coaches VALUES ('C7', 'SCH', 'FC Schalke 04', 2);
INSERT INTO Coaches VALUES ('C8', 'RMA', 'Real Madrid', 1);
INSERT INTO Coaches VALUES ('C9', 'PSG', 'Paris Saint-Germain', 1);
INSERT INTO Coaches VALUES ('C10','CHE', 'Chelsea', 6);
INSERT INTO Coaches VALUES ('C11', 'MCI', 'Manchester City', 5);
INSERT INTO Coaches VALUES ('C12', 'FCB', 'Barcelona', 3);
INSERT INTO Coaches VALUES ('C13', 'BAS', 'Basel', 1);
INSERT INTO Coaches VALUES ('C14', 'FCP', 'FC Porto', 4);
INSERT INTO Coaches VALUES ('C15', 'SHA', 'Shakhtar Donetsk', 3);
INSERT INTO Coaches VALUES ('C16', 'BMU', 'Bayern Munich', 2);

INSERT INTO Stage VALUES ('S_1/8', NULL);
INSERT INTO Stage VALUES ('S_1/4', NULL);
INSERT INTO Stage VALUES ('S_1/2', NULL);
INSERT INTO Stage VALUES ('S_Final', NULL);

INSERT INTO GameIsInStage VALUES ('JUV', 'Juventus', 'G1', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('BVB', 'Borussia Dortmund', 'G1', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('ARS', 'Arsenal', 'G2', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('ASM', 'AS Monaco', 'G2','S_1/8');
INSERT INTO GameIsInStage VALUES ('LEV', 'Bayer 04 Leverkusen', 'G3', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('ATM', 'Atletico Madrid', 'G3', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('SCH', 'FC Schalke 04', 'G4', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('RMA', 'Real Madrid', 'G4', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('PSG', 'Paris Saint-Germain', 'G5', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('CHE', 'Chelsea', 'G5', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('MCI', 'Manchester City', 'G6', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('FCB', 'Barcelona', 'G6', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('BAS', 'Basel', 'G7', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('FCP', 'FC Porto', 'G7', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('SHA', 'Shakhtar Donetsk', 'G8', 'S_1/8');
INSERT INTO GameIsInStage VALUES ('BMU', 'Bayern Munich', 'G8', 'S_1/8');

INSERT INTO GameIsInStage VALUES ('JUV', 'Juventus', 'G9', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('ASM', 'AS Monaco', 'G9', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('ATM', 'Atletico Madrid', 'G10', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('RMA', 'Real Madrid', 'G10', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('PSG', 'Paris Saint-Germain', 'G11', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('FCB', 'Barcelona', 'G11', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('FCP', 'FC Porto', 'G12', 'S_1/4');
INSERT INTO GameIsInStage VALUES ('BMU', 'Bayern Munich', 'G12', 'S_1/4');

INSERT INTO GameIsInStage VALUES ('JUV', 'Juventus', 'G13', 'S_1/2');
INSERT INTO GameIsInStage VALUES ('RMA', 'Real Madrid', 'G13', 'S_1/2');
INSERT INTO GameIsInStage VALUES ('FCB', 'Barcelona', 'G14', 'S_1/2');
INSERT INTO GameIsInStage VALUES ('BMU', 'Bayern Munich', 'G14', 'S_1/2');

INSERT INTO GameIsInStage VALUES ('JUV', 'Juventus', 'G15', 'S_Final');
INSERT INTO GameIsInStage VALUES ('FCB', 'Barcelona', 'G15', 'S_Final');
