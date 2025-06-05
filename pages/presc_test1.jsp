<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/> 

<%@ include file="auth.jspf"%>

<%------------------------------------------------------------------------------------------%>
<%------CONTROLLO CAMPI SE SONO VUOTI-------------------------------------------------------%>
<%------------------------------------------------------------------------------------------%>

<c:if test="${empty param.Note || empty param.tipotest ||
              empty param.Note1 || empty param.Note2 || empty param.date || empty param.time}">
    
  <c:set var="errmsg" scope="request">Compilare tutti i campi!</c:set>
     <jsp:forward page="presc_test.jsp">
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
    <c:set var="errmsg" scope="request" value="Affinche' avvenga la prescrizione del test, l'ora deve essere successiva all' ora della data dell'avvio della pratica di certificazione."/>
<jsp:forward page="presc_test.jsp"/>
    </c:if>
</c:if>

<%------------------------------------------------------------------------------%>
<%----------------- QUERY CHE SELEZIONA L'USERNAME DEI LABORATORI --------------%>
<%----------------- CHE AVRANNO LA VISIBILITA' SULLE PRESCRIZIONI --------------%>
<%------------------------------------------------------------------------------%>

<sql:query var="user_lab">
     select user_lab 
     from LAB
  </sql:query> 

<%---QUERY PER SELEZIONARE L'ULTIMO ID TEST INSERITO----%>
 <sql:query var="id_test">
     select max(convert(substring(id_test,5),decimal)) as id_maxi 
     from TEST 
  </sql:query>

  <%--------- Incremento di +1 ---------%>
  <c:if test="${not empty id_test.rows}">
     <c:set var="id_test" value="${id_test.rows[0].id_maxi + 1}"/>
  </c:if>

<%---QUERY PER SELEZIONARE L'ULTIMO ID PRESCRIZIONE INSERITO----%>
  <sql:query var="id_presc">
     select max(convert(substring(id_prescrizione,6),decimal)) as id_maxi1 
     from TEST 
  </sql:query> 

  <%-------- Incremento di +1 ---------%>
  <c:if test="${not empty id_presc.rows}">
     <c:set var="id_presc" value="${id_presc.rows[0].id_maxi1 + 1}"/>
  </c:if>

<%------------------------------------------------------------------------------------%>
<%---------------------------------AGGIORNAMENTO TABELLE------------------------------%>
<%------------------------------------------------------------------------------------%>

<c:set var="mydata" value="${param.date} ${param.time}"/>


<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>

<sql:update>
 INSERT into TEST( id_test, id_tipo, scopo, motivi, risultati_attesi, id_prescrizione, data_ora_presc, user_cert, id_scheda, nuova )
   VALUES(?,?,?,?,?,?,?,?,?,?)
 <sql:param value="test${id_test}"/>
 <sql:param value="${param.tipotest}"/>
 <sql:param value="${param.Note}"/>
 <sql:param value="${param.Note1}"/>
 <sql:param value="${param.Note2}"/>
 <sql:param value="presc${id_presc}"/>
 <sql:dateParam value="${var_mydata}" type="timestamp"/>
 <sql:param value="${user_userid}"/>
 <sql:param value="${param.id_scheda}"/>
 <sql:param value="1"/>

</sql:update>


<c:forEach items="${user_lab.rows}" var="row">
<sql:update>

 INSERT into VISUALIZZARE_PRESC( id_presc, user_lab, nuova)
   VALUES(?,?,?)
 <sql:param value="presc${id_presc}"/>
 <sql:param value="${row.user_lab}"/>
 <sql:param value="1"/>
 ON DUPLICATE KEY UPDATE nuova= "1"

</sql:update>
</c:forEach>

<%------------------------------------------------------------------------------------------------%>
<%----SE PRESCRIZIONE E' STATA PRESCRITTA AGGIORNO LE PRESCRIZIONI--------------------------------%>
<%------------------------------------------------------------------------------------------------%>

<c:set var="messaggio1" value="La prescrizione e' stata processata con successo!" scope="request"/> 
<jsp:forward page="test_presc.jsp"/>




 