<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<sql:update>
DROP TABLE if exists MESSAGGI
</sql:update>

<sql:update>
CREATE TABLE MESSAGGI (
	user_lab       VARCHAR(15),
        id_messaggio   VARCHAR(30) PRIMARY KEY,
        id_test        VARCHAR(15),
        data_ora       DATETIME ,
        oggetto        VARCHAR(40),
        testo          VARCHAR(40000),
        nuovo          BOOLEAN,
        inviato        BOOLEAN
)
</sql:update>


<sql:update>
INSERT INTO MESSAGGI VALUES ('USER1', 'mess1','test1', '2020-03-03 12:00:00','richiesta','Gentile CPR, grazie per averci scelto!', '0','1')
</sql:update>

<sql:update>
INSERT INTO MESSAGGI VALUES ('USER1', 'mess2','test1', '2020-03-04 10:00:00','risposta','Gentile LAB, attendiamo risposte sullo svolgimento del test', '0','0')
</sql:update>




Table MESSAGGI creata e popolata
