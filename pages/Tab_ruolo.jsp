<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists RUOLO
</sql:update>

<sql:update>
CREATE TABLE RUOLO (
	cod_ruolo         NUMERIC(1) PRIMARY KEY,
	descrizione_ruolo  VARCHAR(25)
)
</sql:update>

<sql:update>
INSERT INTO RUOLO VALUES ('1',  'ALA')
</sql:update>

<sql:update>
INSERT INTO RUOLO VALUES ('2',  'agenzia governativa')
</sql:update>

<sql:update>
INSERT INTO RUOLO VALUES ('3',  'certificatore')
</sql:update>

<sql:update>
INSERT INTO RUOLO VALUES ('4',  'laboratorio')
</sql:update>

<sql:update>
INSERT INTO RUOLO VALUES ('5',  'casa produttrice')
</sql:update>

Table RUOLO creata e popolata
