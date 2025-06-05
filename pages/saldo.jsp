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

<%---------------------------------------------------------------%>
<%--SE NON VENGONO COMPILATI TUTTI I CAMPI MESSAGGIO DI ERRORE---%>
<%---------------------------------------------------------------%>
<c:if test="${empty param.importo || empty param.causale}">
   <c:set var="errmsg"  value="Per ricaricare il tuo saldo devi compilare tutti i campi!" scope="request"/>
 <jsp:forward page="ricarica.jsp"/>
</c:if>

<%--------------------------------------------------------------%>
<%---ESTRAZIONE DALLA TABELLA CPR il SALDO DELLA CPR COLLEGATA--%>
<%--------------------------------------------------------------%>
<sql:query var="pagamento">
     select saldo
            from CPR
            where user_cpr = ?
            <sql:param value="${user_userid}"/>
</sql:query>

<%-------------------------------------------%>
<%--  VARIABILE CON SALDO CHE SI AGGIORNA  --%>
<%-------------------------------------------%>
<c:set var="tot" value="${pagamento.rows[0].saldo+param.importo}"/>

<%-----------------------------------------------%>
<%----- QUERY CHE AGGIORNA IL SALDO DELLA CPR ---%>
<%-----------------------------------------------%>
<sql:update>
UPDATE CPR SET saldo = ?
               where user_cpr = ?
              <sql:param value="${tot}"/>
              <sql:param value="${user_userid}"/>
</sql:update>
<jsp:forward page="ricarica.jsp"/>  

