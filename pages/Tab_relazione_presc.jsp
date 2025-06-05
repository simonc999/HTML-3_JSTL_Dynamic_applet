<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists VISUALIZZARE_PRESC
</sql:update>

<sql:update>
CREATE TABLE VISUALIZZARE_PRESC (
	id_presc       VARCHAR(20),
        user_lab       VARCHAR(20),
        nuova          BOOLEAN,
        PRIMARY KEY (id_presc,user_lab)
)
</sql:update>





Table VISUALIZZARE_PRESC creata e popolata
