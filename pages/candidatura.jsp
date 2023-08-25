<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<%----------------------------------------------%>
<%-------------- AUTORIZZAZIONE  LAB -----------%>
<%----------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>

<%--------------------------------------------------------------------------------------%>
<%------------------------------CONTROLLO PARAMETRI-------------------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:if test="${empty param.date  || 
              empty param.campioni ||
              empty param.tempi ||
              empty param.date ||
              empty param.time}">
    
  <c:set var="errmsg" scope="request">Compilare tutti i campi!</c:set>
     <jsp:forward page="scheda_presc.jsp">
     <jsp:param name="errmsg" value="true"/>
     </jsp:forward>
</c:if> 
<%-------------------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA DELL AVVIO DELLA PRATICA DI----------------- 
 -----------------------------CERTIFICAZIONE-------------------------------------------- 
-------------CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELL'AVVIO
--------------------------- PRATICA CERTIFICAZIONE.---------------------------------- --%>
<%------------------------------------------------------------------------%>


<c:if test="${param.date == param.var_data}">
  <c:if test="${param.time <= param.var_ora}">
    <c:set var="errmsg" scope="request" value="Affinche' avvenga la candidatura al test, l'ora deve essere successiva all' ora della data dell'avvio della prescrizione: ${param.var_ora}"/>
<jsp:forward page="scheda_presc.jsp"/>
    </c:if>
</c:if>

<sql:query var="id_cand">
     select max(convert(substring(id_candidatura,5),decimal)) as id_maxi 
     from CANDIDATURA 
  </sql:query> 


  <%-----Passo3:  Incremento di +1 ---------%>
  <c:if test="${not empty id_cand.rows}">
     <c:set var="id_cand" value="${id_cand.rows[0].id_maxi + 1}"/>
  </c:if>
<%--------------------------------------------------------------------------------------%>
<%------------------------------INSERIMENTO PARAMETRI---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<sql:update>
 INSERT into CANDIDATURA( id_candidatura, user_lab, id_test, data_cand, campioni, tempi, scelto, nuova)
   VALUES(?,?,?,?,?,?,?,?)
 <sql:param value="cand${id_cand}"/>
 <sql:param value="${user_userid}"/>
 <sql:param value="${param.id_test}"/>
 <sql:param value="${param.date}/${param.time}"/>
 <sql:param value="${param.campioni}"/>
 <sql:param value="${param.tempi}"/>
 <sql:param value="0"/>
 <sql:param value="1"/>
</sql:update>

<c:set var="messaggio3" scope="request" value="Candidatura effettuata con successo"/>
<jsp:forward page="test.jsp"/> 


