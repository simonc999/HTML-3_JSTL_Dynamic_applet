${param.n_mess1}
<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>



<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>

<%------------------------------------------------------%>
<%-- VALIDATORE: CONTROLLO CHE I CAMPI SIANO NON VUOTI--%>
<%------------------------------------------------------%>

<c:if test="${empty param.oggetto                   ||
              empty fn:trim(param.messaggio)        ||
              empty param.ora                       ||
              empty param.data }">


  <c:set var="messaggio" value="Per poter inviare il messaggio, compila tutti i campi" />
  <jsp:forward page="chat1.jsp">
    <jsp:param name="errmsg" value="${messaggio}"/>
  </jsp:forward>
</c:if>





<%---------------------------------------------------------------------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA DEL PAGAMENTO DEL TEST, CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DEL PAGAMENTO.---%>
<%-----SE SONO GIA' STATI MANDATI MESSAGGI, CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELL'ULTIMO MESSAGGIO INVIATO.-----------%>
<%---------------------------------------------------------------------------------------------------------------------------------------%>
<c:if test="${param.data == param.var_data1 && param.ora <= param.var_ora1}">
    <c:set var="errmsg" scope="request" value="Affinche' il messaggio venga inviato, l'ora deve essere successiva all' ora della data dell'invio dell'ultimo messaggio"/>
<jsp:forward page="chat1.jsp"/>
</c:if>

<c:if test="${param.data == param.var_data && param.ora <= param.var_ora}">
    <c:set var="errmsg" scope="request" value="Affinche' il messaggio venga inviato, l'ora deve essere successiva all' ora della data del pagamento del test."/>
<jsp:forward page="chat1.jsp"/>
</c:if>

<%------------------------------------------------------%>
<%-- CONVERSIONE DATA SE LE DATE NON SONO NULLE 
    E INSERIMENTO DEL NUOVO MESSAGGIO NEL DB          --%>
<%------------------------------------------------------%>


<c:set var="mydata" value="${param.data} ${param.ora}"/>


<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>



  <%-----Passo1:  Trovo l'ultimo messaggio registrato ---------%>

  <sql:query var="id_mess">
     select max(convert(substring(id_messaggio,5),decimal)) as id_max 
     from MESSAGGI
  </sql:query> 

   <%-----Passo2:  Incremento di +1 ---------%>

  <c:if test="${not empty id_mess.rows}">
     <c:set var="id_mess" value="${id_mess.rows[0].id_max + 1}"/>
  </c:if>

<%--------------------------------------------------------------------------%>
<%--------------------- INSERIMENTO DATI NELLA TABELLA----------------------%>
<%--------------------------------------------------------------------------%>
<sql:update>

insert into MESSAGGI (user_lab,id_messaggio,id_test,data_ora,oggetto,testo,nuovo,inviato)
              values (?,?,?,?,?,?,?,?)

<sql:param value="${user_userid}"/>
<sql:param value="mess${id_mess}"/>
<sql:param value="${param.id_test}"/>
<sql:dateParam value="${var_mydata}"/>
<sql:param value="${param.oggetto}"/>
<sql:param value="${param.messaggio}"/>
<sql:param value="1"/>
<sql:param value="1"/>

</sql:update>

<c:set var="mess_inviato" scope="request" value="Il messaggio e' stato inviato con successo!"/>
<c:set var="n_mess1" scope="request" value="${param.n_mess1}"/>

  <jsp:forward page="messaggi.jsp"/>







 