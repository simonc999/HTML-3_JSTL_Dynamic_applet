<%@ page session="true" 
         language="java" 
         contentType="text/html; charset=UTF-8" 
         import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<sql:update>
DROP TABLE if exists LAB
</sql:update>

<sql:update>
CREATE TABLE LAB (
	user_lab       VARCHAR(15) PRIMARY KEY,
        nome           VARCHAR(40) ,
        dirigente      VARCHAR(50) ,
        link_sito      VARCHAR(100) ,
        p_iva          NUMERIC(11) ,
        sede_legale    VARCHAR(40) 
)
</sql:update>

<sql:update>
INSERT INTO LAB VALUES ('USER1','Analysis','Francesco Caputo','www.analysis.com','27368290279','Via Roma,9 (VR)')
</sql:update>


<sql:update>
INSERT INTO LAB VALUES ('USER2','Bayer','Giovanni Milazzo','www.bayer.com','78549632478','Via Adige,26A (ME)')
</sql:update>

<sql:update>
INSERT INTO LAB VALUES ('USER3','Bioaesis','Carlo Incappato','www.bioaesis.com','23126789029','Via matteotti,26 (PV)')
</sql:update>





Table LAB creata e popolata
