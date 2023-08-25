<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%-----------------------------------------------------------------------%>
<%-----------RIMOZIONE VARIABILI DI SESSIONE CON RITORNO ALLA INDEX-------%>
<%-----------------------------------------------------------------------%>

<c:remove var="user_userid" scope="session"/>
<c:remove var="user_mail" scope="session"/>
<c:remove var="user_descrizione_ruolo" scope="session"/>
<c:remove var="user_cod_ruolo" scope="session"/>

<jsp:forward page="index.jsp" />