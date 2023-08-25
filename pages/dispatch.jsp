<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----------------------------------------------------------------------------------%>
<%----   QUANDO USERNAME E' VUOTO, SI VIENE RIMANDATI ALLA PAGINA DI LOGIN      ----%>
<%----------------------------------------------------------------------------------%>
<c:if test="${empty user_userid}">
 <jsp:forward page="login.jsp"/>
</c:if>


<%----------------------------------------------------------------------------------%>
<%-------      IN BASE AL RUOLO DELL' UTENTE CHE STA EFFETTUADO IL LOGIN,
                       SI VIENE MANDATI ALLA PROPRIA HOMEPAGE               --------%>
<%----------------------------------------------------------------------------------%>
<c:choose>
<c:when test="${not empty user_userid && user_descrizione_ruolo == 'ALA'}">
  <jsp:forward page="home_ala.jsp"/>
</c:when>

<c:when test="${not empty user_userid && user_descrizione_ruolo  == 'agenzia governativa'}">
  <jsp:forward page="home_gov.jsp"/>
</c:when>

<c:when test="${not empty user_userid && user_descrizione_ruolo  == 'certificatore'}">
  <jsp:forward page="home_cert.jsp"/>
</c:when>


<c:when test="${not empty user_userid && user_descrizione_ruolo  == 'laboratorio'}">
  <jsp:forward page="home_lab.jsp"/>
</c:when>

<c:when test="${not empty user_userid && user_descrizione_ruolo  == 'casa produttrice'}">
  <jsp:forward page="home_cpr.jsp"/>
</c:when>

        <c:otherwise>
  <jsp:forward page="login.jsp"/>
       </c:otherwise>
</c:choose>
