<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists CANDIDATURA
</sql:update>

<sql:update>
CREATE TABLE CANDIDATURA (
        id_candidatura    VARCHAR(20) PRIMARY KEY,
	user_lab          VARCHAR(15) ,
        id_test           VARCHAR(15) ,
        pagamento         VARCHAR(20) ,
        data_cand         DATETIME ,
        campioni          VARCHAR(70) ,
        tempi             VARCHAR(70) ,
        scelto            DECIMAL(1),
        nuova             BOOLEAN ,
        data_pagamento    DATETIME
)
</sql:update>


<sql:update>
INSERT INTO CANDIDATURA VALUES ('cand1','USER1','test1','40,99','2021-01-23 10:00:00', '50', '3 ore', 1,0,'2021-02-27 10:50:00')
</sql:update>


<sql:update>
INSERT INTO CANDIDATURA VALUES ('cand2','USER2','test1',null,'2021-02-04 10:00:00', '30', '2 ore', 2,0,null)
</sql:update>

<sql:update>
INSERT INTO CANDIDATURA VALUES ('cand3','USER3','test1',null,'2021-01-24 10:00:00', '30', '2 ore', 2,0,null)
</sql:update>



Table CANDIDATURA creata e popolata
