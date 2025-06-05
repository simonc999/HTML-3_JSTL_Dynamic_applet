<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists AVERE_LISTINO
</sql:update>

<sql:update>
CREATE TABLE AVERE_LISTINO (
	id_tipo       VARCHAR(20),
        user_lab      VARCHAR(20),
        prezzo        VARCHAR(20),
        PRIMARY KEY (id_tipo,user_lab)
)
</sql:update>


<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo1', 'USER1', '40,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo2', 'USER1', '99,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo1', 'USER2', '40,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo2', 'USER2', '120,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo2', 'USER3', '130,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo1', 'USER3', '45,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo3', 'USER1', '230,99')
</sql:update>
<sql:update>
INSERT INTO AVERE_LISTINO VALUES ('tipo4', 'USER3', '45,99')
</sql:update>


Table AVERE_LISTINO creata e popolata
