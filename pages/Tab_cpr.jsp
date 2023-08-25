<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists CPR
</sql:update>

<sql:update>
CREATE TABLE CPR (
	user_cpr       VARCHAR(15) PRIMARY KEY,
        p_iva          NUMERIC(11) ,
        dirigente      VARCHAR(50) ,
        sede_legale    VARCHAR(40) ,
        link_sito      VARCHAR(100) ,
        mercato        VARCHAR(20) ,
        d_sicurezza    VARCHAR(100) ,
        risposta       VARCHAR(10) ,
        nuovo          BOOLEAN,
        nome           VARCHAR(40),
        saldo          VARCHAR(20),
        messaggio      BOOLEAN
)
</sql:update>

<sql:update>
INSERT INTO CPR VALUES ('nivea2021','12345678345','Mario Rossi', 'Via Roma,12 Milano (MI)', 'www.nivea.it', 'Eureopeo','Qual e il tuo colore preferito?', 'rosso','0','Nivea','12500,80','0')
</sql:update>

<sql:update>
INSERT INTO CPR VALUES ('Farmaka12','12345678923','Alessandro Verdi', 'Via torino,12 Milano (MI)', 'www.farmaka.it', 'Internazionale','Qual e il tuo colore preferito?', 'Blu','0','Farmaka srl','16500,80','0')
</sql:update>

<sql:update>
INSERT INTO CPR VALUES ('Angelini','12345678023','Maria Rossetti', 'Piazza vittoria,2 Pavia (PV)', 'www.angelini.it', 'Italiano','Qual e il nome di tua mamma?', 'Viola','0','Angelini srl','8500,80','0')
</sql:update>


Table CPR creata e popolata
