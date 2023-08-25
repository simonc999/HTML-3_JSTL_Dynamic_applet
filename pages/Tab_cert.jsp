<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists CERT
</sql:update>

<sql:update>
CREATE TABLE CERT (
	user_cert       VARCHAR(15) PRIMARY KEY,
        cf              VARCHAR(160),
        sesso           VARCHAR(1) ,
        nome            VARCHAR(40),
        cognome         VARCHAR(40),
        data_nascita    VARCHAR(10),
        n_albo          VARCHAR(100),
        ubicazione      VARCHAR(40)
)
</sql:update>


<sql:update>
INSERT INTO CERT VALUES ('USER4','vrddro87l12f58a', 'M','Dario', 'Verdi', '12-12-1987','12343672356','Via vittoria,12')
</sql:update>

<sql:update>
INSERT INTO CERT VALUES ('USER5','fldlco56l12f58a','M', 'Luca', 'Michelin', '23-10-1956','67890298126','Via Griziotti,9')
</sql:update>

<sql:update>
INSERT INTO CERT VALUES ('USER6','rssmri87j14f158k','M', 'Mario', 'Rossi', '14-05-1987','43247872463','Via Verdi,1')
</sql:update>


Table CERT creata e popolata
