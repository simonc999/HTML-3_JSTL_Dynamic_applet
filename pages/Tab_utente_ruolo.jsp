<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists UTENTE_RUOLO
</sql:update>

<sql:update>
CREATE TABLE UTENTE_RUOLO (
	username       VARCHAR(15) PRIMARY KEY,
	password       VARCHAR(30) ,
        telefono  VARCHAR(14) ,
        mail      VARCHAR(50) ,
        attivo     BOOLEAN ,
        cod_ruolo  NUMERIC (1)
        
)
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('Alambiccus',  'intermed','+39 0384123456', 'alambiccussrl@gmail.com', '1', '1')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('Gov',  'agenziagov','+39 3475687840', 'agenziagov@gmail.it', '1', '2')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('Angelini','angelini2021','+39 3473995817', 'angelini@gmail.com','1','5')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('nivea2021','niveanivea2021','+39 3473465817', 'nivea2021@gmail.com','1','5')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('Farmaka12','farmaka2021','+39 3435465817', 'mailbox@farmaka.com','1','5')
</sql:update>


<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER1','analysis2020','+39 3435488817', 'labanalysis@gmail.com','1','4')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER2','bayer2021','+39 3432565813', 'mailbox@bayer.com','1','4')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER3','bioesis2021','+39 3435465817', 'bioesis@live.it','1','4')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER4','dario2020','+39 3435488817', 'darioverdi@gmail.com','1','3')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER5','luca2021','+39 3432565813', 'luca.miche@gmail.com','1','3')
</sql:update>

<sql:update>
INSERT INTO UTENTE_RUOLO VALUES ('USER6','mario2021','+39 3435465817', 'mariorossi@live.it','1','3')
</sql:update>

Table UTENTE_RUOLO creata e popolata

