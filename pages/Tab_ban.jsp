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
DROP TABLE if exists BAN
</sql:update>

<sql:update>
CREATE TABLE BAN (
        user_cpr            VARCHAR(20),
        user_cert           VARCHAR(20),
        data_inizio_ban     DATETIME,
        data_fine_ban       DATETIME,
        PRIMARY KEY (user_cpr,user_cert)
)
</sql:update>





Table BAN creata e popolata
