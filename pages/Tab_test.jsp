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
DROP TABLE if exists TEST
</sql:update>

<sql:update>
CREATE TABLE TEST (
	id_test             VARCHAR(15),
        id_tipo             VARCHAR(15) ,
        scopo               VARCHAR(1000),
        risultati_attesi    VARCHAR(1000),
        id_prescrizione     VARCHAR(15) PRIMARY KEY,
        data_ora_presc      DATETIME,
        motivi              VARCHAR(1000),
        nuova               BOOLEAN,
        user_cert           VARCHAR(15),
        id_scheda           VARCHAR(20),
        data_ora_esito      DATETIME,
        superato            BOOLEAN,
        rapporto            VARCHAR(1000),
        annullo_motivo      VARCHAR(500)
)

</sql:update>

<sql:update>
INSERT INTO TEST VALUES ('test1','tipo1','Rispettare regolamento dell agenzia AIFA','effetti collaterali minimi','presc1', '2021-01-06 12:00:00', 'verificare che se assunto in dosi elevate, non abbia effetti collaterali','1', 'USER4','scheda2', null, null, null, null)
</sql:update>



Table TEST creata e popolata