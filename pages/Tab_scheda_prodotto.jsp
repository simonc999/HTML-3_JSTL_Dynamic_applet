<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists SCHEDA_PROD
</sql:update>

<sql:update>
CREATE TABLE SCHEDA_PROD (
	id_scheda       VARCHAR(15) PRIMARY KEY,
        nome_prod       VARCHAR(100) ,
        user_cpr        VARCHAR(15),
        tipo            VARCHAR(100),
        uso             VARCHAR(250),
        materiali       VARCHAR(250),
        beneficio       VARCHAR(250),
        inizio_prat     DATETIME,
        fine_prat       DATETIME,
        stato           NUMERIC(1),
        verbale         VARCHAR(300),
        nuovo           BOOLEAN,
        nuovo_assegnato BOOLEAN,
        concluso        BOOLEAN,
        user_cert       VARCHAR(15),
        foto1           VARCHAR(128),
        foto2           VARCHAR(128),
        foto3           VARCHAR(128)

)
</sql:update>


<sql:update>
INSERT INTO SCHEDA_PROD VALUES ('scheda1','Oki', 'Farmaka12', 'Farmaceutico','diluire in acqua, assumere ogni 8 ore', 'ketoprofene sale di lisina 40 mg', 'anti-infiammatorio', null ,null,0, null,'0', '0','0', null,null, null, null)
</sql:update>



<sql:update>
INSERT INTO SCHEDA_PROD VALUES ('scheda2', 'Gaviscon','Farmaka12', 'Farmaceutico','assumere per via orale', 'sodio bicarbonato, sodio alginato', 'allieva il bruciore allo stomaco', '2020-09-20 12:00:00' ,null,2, null,'0', '0','0', 'USER4',null, null, null)
</sql:update>





Table SCHEDA_PROD creata e popolata
