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

<%------------------------------------------------------%>
<%-- CONVERSIONE DATA SE LE DATE NON SONO NULLE 
E AGGIORNAMENTO DELLE QUERY SCHEDA_PROD E TEST        --%>
<%------------------------------------------------------%>
<c:if test="${not empty param.data_annullo  &&
              not empty param.ora_annullo   &&
              not empty fn:trim(param.motivo)}">


<%------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA DELLA PRESCRIZIONE DEL TEST, 
CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELLA PRESCRIZIONE. --%>
<%------------------------------------------------------------------------%>

<c:if test="${param.data_annullo == param.var_data}">
<c:if test="${param.ora_annullo <= param.var_ora}">
<c:set var="errmsg" scope="request" value="Affinche' il test venga annullato, 
      l'ora deve essere successiva all' ora della data della prescrizione del test."/>
<jsp:forward page="candidature.jsp"/>
</c:if>
</c:if>
<%-----------------------------------------------------------%>
<%-- CONVERSIONE DATA SE LE DATE NON SONO NULLE E GIUSTE
     E AGGIORNAMENTO DELLE QUERY SCHEDA_PROD E TEST        --%>
<%-----------------------------------------------------------%>

<c:set var="mydata" value="${param.data_annullo} ${param.ora_annullo}"/>

<fmt:parseDate value= "${mydata}" 
               var= "var_mydata"
               pattern= "yyyy-MM-dd HH:mm"/>

<sql:update>

UPDATE TEST SET  annullo_motivo = ?
                 where id_prescrizione = ? 
     <sql:param value="${fn:trim(param.motivo)}"/>
     <sql:param value="${param.test}"/>

</sql:update>

<sql:update>

UPDATE SCHEDA_PROD SET  stato = ?, 
                        fine_prat = ?,
                        concluso = ?
                        where id_scheda = ? 
     <sql:param value="3"/>
     <sql:dateParam value="${var_mydata}" type="timestamp"/>
     <sql:param value="1"/>
     <sql:param value="${param.id_scheda}"/>

</sql:update>

  <jsp:forward page="visualizza_test.jsp">
   <jsp:param name="presc" value="${param.test}"/>
   <jsp:param name="id_scheda" value="${param.id_scheda}"/>
  </jsp:forward>

</c:if>


<%------------------------------------------------------%>
<%-- VALIDATORE: CONTROLLO CHE I CAMPI SIANO NON VUOTI--%>
<%------------------------------------------------------%>

<c:if test="${empty fn:trim(param.motivo) ||
              empty (param.data_annullo) ||
              empty (param.ora_annullo)}" >

<c:set var="msg" scope="request" >
   Se vuoi davvero annullare questo test, devi inserire il motivo e la data in cui annulli    
   il test! </c:set>
<jsp:forward page="candidature.jsp">
<jsp:param name="test" value="${param.test}"/>
</jsp:forward>
</c:if>






