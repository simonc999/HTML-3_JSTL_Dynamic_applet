<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%--------------------------------------------------------------------------------------%>
<%------------------------------AUTORIZZAZIONE AREA CPR---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="5"/>
<c:set var="auth_page" value="home_cpr.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Casa Produttrice"/>

<%@ include file="auth.jspf"%>

<%------------------------------------------------------------------%>
<%---- QUERY CHE FA L' UPDATE DELLE MODIFICHE FATTE SUL PROFILO ----%>
<%------------------------------------------------------------------%>

 <sql:update>
UPDATE CPR SET  dirigente = ?,
                sede_legale = ?,
                link_sito = ?,
                mercato = ?  
     where user_cpr = ? 
     <sql:param value="${param.dirigente}"/>
     <sql:param value="${param.sede_legale}"/>
     <sql:param value="${fn:trim(param.sito)}"/>
     <sql:param value="${fn:trim(param.mercato)}"/> 
     <sql:param value="${user_userid}"/>


 </sql:update>

 <sql:update>

UPDATE UTENTE_RUOLO SET  telefono = ?,
                mail = ?
     where username = ? 
     <sql:param value="${param.telefono}"/>
     <sql:param value="${param.mail}"/>
     <sql:param value="${user_userid}"/>


  </sql:update>



<%------------------------------------------------------%>
<%-------  MESSAGGIO DELL' AVVENUTA MODIFICA   ---------%>
<%------------------------------------------------------%>
<c:set var="profilo_salvato" scope="request">Il salvataggio e' avvenuto con successo</c:set>
<jsp:forward page="visual_profilo.jsp"/>


