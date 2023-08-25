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
<%-- VALIDATORE: CONTROLLO CHE I CAMPI SIANO NON VUOTI--%>
<%------------------------------------------------------%>

<c:if test="${empty (param.data_ban) ||
              empty (param.ora_ban)         }" >

<c:set var="msg" scope="request" > Se vuoi davvero bannare il certificatore, devi inserire   
        la data e l' ora in cui desideri abbia inizio il ban! 
</c:set>
<jsp:forward page="elenco_cert_cpr.jsp"/>
</c:if>


<%------------------------------------------------------%>
<%------QUERY CHE ESTRAE NOME E COGNOME DEL CERT--------%>
<%------------------------------------------------------%>
<sql:query var="cert">
     select nome, cognome
     from CERT 
     where user_cert LIKE ?
<sql:param value="${param.user}"/>
</sql:query>


<%-------------------------------------------------------------------%>
<%-- CONVERSIONE DATA SE LA DATA DI INIZIO BAN  NON E' NULLA       --%>
<%-------------------------------------------------------------------%>

<c:if test="${not empty param.data_ban  &&
              not empty param.ora_ban   }">

<c:set var="mydata" value="${param.data_ban} ${param.ora_ban}"/>

<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>

<%----------------------------------------------------------------------------------%>
<%---- CASO 1: BANNO L'USER E QUINDI FACCIO L'INSERT, CIO' VUOL DIRE CHE SONO ARRIVATO  
       ALLA ACTION CLICCANDO IL SUBMIT BANNA -------------%>
<%----------------------------------------------------------------------------------%>
<c:if test="${not empty param.banna}">

<c:choose>
<%----------------------------------------------------------------------------------%>
<%---- CASO IN CUI INSERISCO LA DATA E L'ORA DI INIZIO E FACCIO L'INSERT
       E INSERISCO SOLO LA DATA E ORA DI INIZIO E NON QUELLA DI FINE   -------------%>
<%----------------------------------------------------------------------------------%>
<c:when test="${empty param.fine_data_ban && empty param.fine_ora_ban}">
<sql:update>
     INSERT INTO BAN (user_cpr, user_cert, data_inizio_ban)
            values (?,?,?)
     <sql:param value="${user_userid}"/>
     <sql:param value="${param.user}"/>
     <sql:dateParam value="${var_mydata}" type="timestamp"/>
</sql:update>

<c:set var="caricato_no_fine" scope="request" value="Il ban sul certificatore      
   ${cert.rows[0].nome} ${cert.rows[0].cognome} e' avvenuto con successo"/>
</c:when>


<%----------------------------------------------------------------------------------%>
<%---- CASO IN CUI SONO PRESENTI ANCHE LA DATA E ORA DI FINE DEL BAN        --------%>
<%----------------------------------------------------------------------------------%>
<c:otherwise>

<%----------------------------------------------------------------------------------%>
<%---- SE INSERISCO CORRETTAMENTE I PARAMETRI, CONVERTO LE DATE E PROSEGUO
       CON UPDATE E MESSAGGIO DI COMPLETAMENTO CON SUCCESSO  -------------%>
<%----------------------------------------------------------------------------------%>
<c:if test="${param.data_ban < param.fine_data_ban ||
     (param.data_ban == param.fine_data_ban && param.ora_ban < param.fine_ora_ban)}">

<c:set var="mydata1" value="${param.fine_data_ban} ${param.fine_ora_ban}"/>

<fmt:parseDate value="${mydata1}" 
               var="var_mydata1"
               pattern="yyyy-MM-dd HH:mm"/>

<sql:update>
    INSERT INTO BAN (user_cpr, user_cert, data_inizio_ban, data_fine_ban)
           values (?,?,?,?)
   <sql:param value="${user_userid}"/>
   <sql:param value="${param.user}"/>
   <sql:dateParam value="${var_mydata}" type="timestamp"/>
   <sql:dateParam value="${var_mydata1}" type="timestamp"/>
</sql:update>

<c:set var="caricato_si_fine" scope="request" value="Il ban sul certificatore      
       ${cert.rows[0].nome} ${cert.rows[0].cognome} e' avvenuto con successo"/>

</c:if>

<%----------------------------------------------------------------------------------%>
<%----SE LA VAR CREATA NEL C:IF PRECEDENTE E' VUOTA E QUINDI LE DATE NON
      RISPETTANO LE CONDIZIONI DI TEMPORALITA' ALLORA SI SETTA UN MESSAGGIO 
      DI ERRORE CHE VIENE RIPORTATO NELLA PRESENTATION------------%>
<%----------------------------------------------------------------------------------%> 
<c:if test="${empty caricato_si_fine}">
<c:set var="errore1" scope="request" value="La data e l'ora di fine deve essere posteriore 
                                     alla data di inzio del ban!"/>
</c:if>
</c:otherwise>

</c:choose>
</c:if>
<%----------------------------------------------------------------------------------%>
<%---- FINE CASO 1  -------------%>
<%----------------------------------------------------------------------------------%>


<%-----------------------------------------------------------------------%>
<%--  CASO 2: SE LA DATA DI INIZIO BAN E' PRESENTE, SE SCHIACCIO MODIFICA , 
     AGGIORNA DATA NEL DB --%>
<%-----------------------------------------------------------------------%>

<c:if test="${not empty param.modifica}">
<c:choose>
<%----------------------------------------------------------------------------------%>
<%---- SE MODIFICO SOLO LA DATA DI INIZIO (DATA FINE ASSENTE)          -------------%>
<%----------------------------------------------------------------------------------%>
<c:when test="${empty param.fine_data_ban && empty param.fine_ora_ban}">
  <sql:update>
  UPDATE BAN SET data_inizio_ban = ?
             WHERE user_cert = ? 
             AND user_cpr = ?
  <sql:dateParam value="${var_mydata}" type="timestamp"/>
  <sql:param value="${param.user}"/>
  <sql:param value="${user_userid}"/>
  </sql:update>

<c:set var="modificato_no_fine" scope="request" value="Il ban sul certificatore      
   ${cert.rows[0].nome} ${cert.rows[0].cognome} e' stato modificato con successo"/>

</c:when>

<%----------------------------------------------------------------------------------%>
<%---- SE MODIFICO/INSERISCO ANCHE LA DATA DI FINE  -------------%>
<%----------------------------------------------------------------------------------%>
<c:otherwise>

<%----------------------------------------------------------------------------------%>
<%---- SE SONO RISPETTATE LE CONDIZIONI DI TEMPORALITA' (DATA INIZIO PRIMA DI DATA FINE) 
       ALLORA PROCEDO CON CONVERSIONE DATE, UPDATE E MESSAGGIO DA RESTITUIRE ALLA    
       PRESENTATION -------------%>
<%----------------------------------------------------------------------------------%>
<c:if test="${param.data_ban < param.fine_data_ban ||
      (param.data_ban == param.fine_data_ban && param.ora_ban < param.fine_ora_ban)}">

<c:set var="mydata1" value="${param.fine_data_ban} ${param.fine_ora_ban}"/>

<fmt:parseDate value="${mydata1}" 
               var="var_mydata1"
               pattern="yyyy-MM-dd HH:mm"/>
  <sql:update>
  UPDATE BAN SET data_inizio_ban = ?,
                 data_fine_ban = ?
             WHERE user_cert = ? 
             AND user_cpr = ?
  <sql:dateParam value="${var_mydata}" type="timestamp"/>
  <sql:dateParam value="${var_mydata1}" type="timestamp"/>
  <sql:param value="${param.user}"/>
  <sql:param value="${user_userid}"/>
  </sql:update>

<c:set var="modificato_si_fine" scope="request" value="Il ban sul certificatore      
   ${cert.rows[0].nome} ${cert.rows[0].cognome} e' stato modificato con successo"/>
</c:if>

<%----------------------------------------------------------------------------------%>
<%----SE LA VAR CREATA NEL C:IF PRECEDENTE E' VUOTA E QUINDI LE DATE NON
      RISPETTANO LE CONDIZIONI DI TEMPORALITA' ALLORA SI SETTA UN MESSAGGIO 
      DI ERRORE CHE VIENE RIPORTATO NELLA PRESENTATION-------------%>
<%----------------------------------------------------------------------------------%>
<c:if test="${empty modificato_si_fine}">
<c:set var="errore2" scope="request" value="La data e l'ora di fine deve essere posteriore 
                                            alla data di inzio del ban!"/>
</c:if>

</c:otherwise>
</c:choose>

</c:if>
<%----------------------------------------------------------------------------------%>
<%---- FINE CASO 2 -------------%>
<%----------------------------------------------------------------------------------%>


<%------------------------------------------------------------------------%>
<%--   SE SCHIACCIO ELIMINA, ELIMINO L'INTERA RIGA DEL BAN SELEZIONATO  --%>
<%------------------------------------------------------------------------%>

<c:if test="${not empty param.elimina}">
 
  <sql:update>
  DELETE FROM BAN WHERE user_cert = ? 
              AND user_cpr = ?
  <sql:param value="${param.user}"/>
  <sql:param value="${user_userid}"/>
  </sql:update>

<c:set var="ban_eliminato" scope="request"> Il ban di ${cert.rows[0].nome}  
       ${cert.rows[0].cognome} e' stato eliminato con successo! 
</c:set>

</c:if>
<jsp:forward page="elenco_cert_cpr.jsp"/>
</c:if>




