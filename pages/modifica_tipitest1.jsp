<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------- CONTROLLO DEI PERMESSI DI GOV  ----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------- CONTROLLO DEI PARAMETRI PASSATI  --------------------------------------%>
<%--------------------------------------- E GENERO MESSAGGIO DI ERRORE  ---------------------------------------%>
<%------------------- risolvo il problema dei numeri scritti col punto sfruttando split and join --------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:set var = "min_senzapunto" value = "${fn:split(param.min, '.')}" />      <%-- splitto il minimo levando il punto se e' presente --%>
<c:set var = "min_convirgola" value = "${fn:join(min_senzapunto, ',')}" />         <%-- riunisco il minimo con la virgola --%>

<c:set var = "max_senzapunto" value = "${fn:split(param.max, '.')}" />       <%-- splitto il massimo levando il punto se e' presente --%>
<c:set var = "max_convirgola" value = "${fn:join(max_senzapunto, ',')}" />         <%-- riunisco il massimo con la virgola --%>

<c:if test="${empty param.tipo or param.tipo=='--Selezionare un tipo--'}">
  <c:set var="flagtipo" value="true" scope="request"/>
</c:if>

<c:if test="${empty param.descrizione}">
  <c:set var="flagdescrizione" value="true" scope="request"/>
</c:if>

<fmt:parseNumber var="min" value="${min_convirgola}"/>  <%-- converto la stringa in numero --%>
<fmt:parseNumber var="max" value="${max_convirgola}"/>

<c:if test="${min > max}">
  <c:set var="flagmin" value="true" scope="request"/>
  <c:set var="flagmax" value="true" scope="request"/>
  <c:set var="flagequ" value="true" scope="request"/>
</c:if>

<c:if test="${empty param.min }">
  <c:set var="flagmin" value="true" scope="request"/>
</c:if>

<c:if test="${empty param.max }">
  <c:set var="flagmax" value="true" scope="request"/>
</c:if>



<c:if test="${(empty param.tipo)   or
              (param.tipo=='--Selezionare un tipo--') or
              (empty param.descrizione)  or
              (empty param.min)      or
              (empty param.max)   or
              (min>max)    }">
  <c:set var="messaggio" scope="request">
    <font size="3px"color="red"> Si sono omessi alcuni campi.</font>   <%-- genero messaggio errore --%>
  </c:set>

  <jsp:forward page="modifica_tipitest.jsp"/>
</c:if>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------- SQL PER LA MODIFICA DELLA RIGA  --------------------------------------%>
<%-------------------------------------- E GENERO MESSAGGIO DI SUCCESSO  --------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

 
<c:if test="${not empty param.modifica}">   <%-- se c'e' il parametro del bottone del modifica allora faccio update --%>
  <sql:update>
    UPDATE TIPO_TEST
    SET tipo= ?,
        descrizione= ?,
        costo_min= ?,
        costo_max= ?
    WHERE id_tipo= ?
    <sql:param value="${param.tipo}"/>
    <sql:param value="${param.descrizione}"/>
    <sql:param value="${param.min}"/>
    <sql:param value="${max}"/>
    <sql:param value="${param.id}"/>
  </sql:update>

  <c:set var="messaggio" scope="request">
    <font size="4px"color="green">-- Il test e' stato modificato correttamente. --</font>
  </c:set>
  <jsp:forward page="elenco_tipitest.jsp"/>
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------- SQL PER L'AGGIUNTA DELLA RIGA  ---------------------------------------%>
<%-------------------------------------- E GENERO MESSAGGIO DI SUCCESSO  --------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:if test="${not empty param.aggiungi}">  <%-- se c'e' il parametro del bottone dell'aggiungi allora faccio insert --%>
  <sql:update>
    INSERT into TIPO_TEST( id_tipo, tipo, descrizione, costo_min, costo_max)
    VALUES(?,?,?,?,?)
    <sql:param value="tipo${id}"/>
    <sql:param value="${param.tipo}"/>
    <sql:param value="${param.descrizione}"/>
    <sql:param value="${min_convirgola}"/>
    <sql:param value="${max_convirgola}"/>
  </sql:update>

  <c:set var="messaggio" scope="request">
    <font size="4px"color="green">-- Il nuovo test e' stato aggiunto correttamente. --</font>
  </c:set>
  <jsp:forward page="elenco_tipitest.jsp"/>
</c:if>


