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

<%-------------------------------------------------------%>
<%-- VALIDATORE: CONTROLLO SE I CAMPI SONO VUOTI --%>
<%-------------------------------------------------------%>

<c:if test="${empty param.data ||
              empty param.ora }">

<c:set var="errmsg" scope="request" value="Per procedere, devi prima inserire la data di     
                                           avvio della pratica"/>
<jsp:forward page="visual_scheda.jsp"/>
</c:if>



<%------------------------------------------------------------------%>
<%-- SE I CAMPI NON  SONO VUOTI,  PROCEDO CON L'UPDATE 
     E RITORNO ALLA PAGINA DELLA GESTIONE
     PRODOTTI AGGIORNANDO LA DATA DI INIZIO PRATICA --%>
<%------------------------------------------------------------------%>

  <c:set var="id_scheda" value="${param.id_scheda}"/>
  <c:set var="data_inizio" value="${param.data} ${param.ora}"/>

<%----------------------------------------------------------------------------------%>
<%---- CONVERSIONE DELLE DATE-------------%>
<%----------------------------------------------------------------------------------%>
<fmt:parseDate value="${data_inizio}"
                var="inizio_prat"
                pattern="yyyy-MM-dd HH:mm"/>
<sql:update>
UPDATE SCHEDA_PROD SET  inizio_prat = ? ,
                        stato = ?,
                        nuovo = ?
                        where id_scheda = ?
<sql:dateParam type="timestamp"
               value="${inizio_prat}"/>
<sql:param value="2"/>
<sql:param value="1"/>
<sql:param value="${param.id_scheda}"/>
</sql:update> 

<%----------------------------------------------------------------------------------%>
<%---- MESSAGGIO CHE RESTITUISCO ALLA PAGINA   GESTIONE_PROD           -------------%>
<%----------------------------------------------------------------------------------%>
<c:set var="pratica_aggiunta" scope="request">La pratica e' stata avviata con successo ed   
       e' stata inoltrata all'agenzia governativa. <br/>
       Gov si occupera' dell'assegnazione del certificatore che prescrivera' i test da    
       affettuare sul prodotto.
</c:set>
<jsp:forward page="gestione_prod.jsp"/>