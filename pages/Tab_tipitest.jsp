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
DROP TABLE if exists TIPO_TEST
</sql:update>

<sql:update>
CREATE TABLE TIPO_TEST (
	id_tipo           VARCHAR(30) PRIMARY KEY,
        tipo              VARCHAR(50),
	descrizione       VARCHAR(150),
        costo_min         VARCHAR(50),
        costo_max         VARCHAR(50)
       
)
</sql:update>


<sql:update>
INSERT INTO TIPO_TEST VALUES ('tipo1','prova materiale','elasticita','30,25','50,78')
</sql:update>

<sql:update>
INSERT INTO TIPO_TEST VALUES ('tipo2','analisi di laboratorio','calcolo ph','80,89','150,79')
</sql:update>

<sql:update>
INSERT INTO TIPO_TEST VALUES ('tipo3','analisi di laboratorio','analisi nutritiva minima','160,89','250,79')
</sql:update>

<sql:update>
INSERT INTO TIPO_TEST VALUES ('tipo4','analisi di laboratorio','analisi basale','20,79','80,79')
</sql:update>





Table TIPO_TEST creata e popolata
