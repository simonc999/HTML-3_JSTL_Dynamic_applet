<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<c:remove var="user_userid" scope="session"/>
<c:remove var="user_mail" scope="session"/>
<c:remove var="user_descrizione_ruolo" scope="session"/>

<%------------------------------------------------------------%>
<%-----   VALIDATORE CAMPI: CONTROLLO CHE NON SIANO VUOTI ----%>
<%------------------------------------------------------------%>
<c:if test="${empty param.form_username || empty param.form_password }">
  <c:set var="errmsg" value="Compila tutti i campi!" scope="request"/>
     <jsp:forward page="login.jsp"/>
</c:if>

<%--------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE I DATI DAL DB RELATIVI AGLI ACCOUNT GIA' REGISTRATI --%>
<%--------------------------------------------------------------------------%>
<sql:query var="rset">
    SELECT u.username, 
           u.mail,  
           r.descrizione_ruolo,
           u.cod_ruolo
    FROM UTENTE_RUOLO u, RUOLO r
    WHERE u.username = ?
      AND u.password = ?
      AND r.cod_ruolo = u.cod_ruolo
      <sql:param value="${param.form_username}"/>
      <sql:param value="${param.form_password}"/>
            
</sql:query>

<c:choose>
<%----------------------------------------------------------------------------------%>
<%-- MESSAGGIO DI ERRORE CHE SI RICEVE QUANDO USERNAME INSERITO NON ESISTE NEL DB --%>
<%----------------------------------------------------------------------------------%>
    <c:when test="${empty rset.rows}">
        <jsp:forward page="login.jsp">
            <jsp:param name="login_errMsg"  
                       value="Attenzione, i valori introdotti non sono validi. Riprovare!"/> 
        </jsp:forward>
    </c:when>
    
<%----------------------------------------------------------------------------------%>
<%----- QUANDO USERNAME INSERITO ESISTE NEL DB , SI RIMANDA ALLA DISPATCH CHE, IN 
                 BASE AL RUOLO DELL'UTENTE, MANDA ALLA HOMEPAGE DEDICATA        ----%>
<%----------------------------------------------------------------------------------%>    
    <c:otherwise>
           <c:set var="user_userid" scope="session"
                            value="${rset.rows[0].username}"/>
           <c:set var="user_mail" scope="session" 
                            value="${rset.rows[0].mail}"/>
           <c:set var="user_descrizione_ruolo" scope="session" 
                            value="${rset.rows[0].descrizione_ruolo}"/>
            <c:set var="user_cod_ruolo" scope="session" 
                            value="${rset.rows[0].cod_ruolo}"/>
          <jsp:forward page="dispatch.jsp"/>  
    </c:otherwise>    
</c:choose>
