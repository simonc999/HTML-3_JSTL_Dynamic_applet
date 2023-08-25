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



<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO TOP     ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%>



<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:choose>
<%---------------------------------------------------------------------%>
<%--- QUANDO CI ARRIVO DAL TASTO 'MODIFICA SCHEDA' IN VISUAL_SCHEDA ---%>
<%---------------------------------------------------------------------%>
<c:when test="${not empty param.modifica}">
 <form method="post" action="visual_scheda.jsp">
<td align="right" width="60" >
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
     </td>       
</form>
</c:when>

<%-----------------------------------------------------------------------%>
<%--- QUANDO CI ARRIVO DAL TASTO 'CREA NUOVA SCHEDA' IN GESTIONE_PROD ---%>
<%-----------------------------------------------------------------------%>
<c:otherwise>
 <form method="post" action="gestione_prod.jsp">
<td align="right" width="60" >
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/> 
     </td>       
</form>
</c:otherwise>
</c:choose>



<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO MIDDLE  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>

<%------------------------------------------------------------------------%>
<%--  QUERY PER ESTRARRE I DATI DELLA SCHEDA, SE ARRIVO ALLA PAGINA DA 
               (visual_scheda) e QUINDI DA UNA SCHEDA GIA ESISTENTE     --%>
<%------------------------------------------------------------------------%>
<sql:query var="dettagli">
SELECT id_scheda, nome_prod, tipo, uso, materiali, beneficio,foto1, foto2, foto3
FROM SCHEDA_PROD
WHERE id_scheda LIKE ?
<sql:param value="${param.id_scheda}"/>
</sql:query>


<%-------------------------------------------%>
<%-- PREISTANZIATO - CARICA I DATI DAL  DB --%>
<%-------------------------------------------%>
<c:if test="${not empty param.id_scheda}">
   <c:set var="nome_prod"               value="${dettagli.rows[0].nome_prod}"/>
   <c:set var="beneficio_prod"          value="${dettagli.rows[0].beneficio}"/>
   <c:set var="uso_prod"                value="${dettagli.rows[0].uso}"/>
   <c:set var="materiali_prod"          value="${dettagli.rows[0].materiali}"/>
   <c:set var="tipo_prod"               value="${dettagli.rows[0].tipo}"/>
</c:if>


<%-----------------%>
<%-- INIZIO HTML --%>
<%-----------------%>
<html>


<%-------------------------%>
<%-- MESSAGGIO DI ERRORE --%>
<%-------------------------%>
<font color="#007171"><h3>${errore}</h3></font>


<%-------------------------------------------------------------------%>
<%-- TABELLA CON INPUT TYPE PER INSERIRE I DATI DI UNA NUOVA SCHEDA--%>
<%-------------------------------------------------------------------%>
<TABLE width="100%" height="100%">
<tr height="60%"><td>

<table align="center" border="1" cellspacing="2" bordercolor="#007171" width="700">
  <form action="salva_prod.jsp" method="post" enctype="multipart/form-data">
  <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>

<tr>

 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial"><b>SCHEDA NUMERO:</font></b></td>
 <td align="left" bgcolor="white">  ${param.id_scheda} 
 
<c:if test="${empty param.id_scheda}">
CODICE GENERATO AUTOMATICAMENTE
</c:if>
 </td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial">NOME:</font> </td>
 <td align="center" bgcolor="white"> <input type="text"  name="nome_prod" value="${nome_prod}"
 placeholder="NOME PRODOTTO" size="23" style="border:0px;font-size:15px"></td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial"> TIPO:</font></td>
 <td align="center" bgcolor="white" >  

          <SELECT NAME="tipo_prod" width="30" align="center" style="border:0px;font-size:15px">
        <option value="" checked>--TIPO-- </option>
        <c:forTokens delims="," items="Alimentare,Farmaceutico,Beauty,Cura e benessere,Igiene,Dispositivi medici" var="scelta">
             <option value="${scelta}"

             <c:if test="${scelta == tipo_prod}"> selected="selected" </c:if>
              > ${scelta} </option>
           </c:forTokens>
          </select> 
 </td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial"> USO:</font></td>
 <td align="center" bgcolor="white">
   <textarea cols="23" rows="5" name="uso_prod" style="border:0px;font-size:15px"> ${uso_prod} </textarea>
 </td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial">MATERIALI:</font></td>
 <td align="center" bgcolor="white">
   <textarea cols="23" rows="5" name="materiali_prod" style="border:0px;font-size:15px"> ${materiali_prod}</textarea>
 </td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial"> BENEFICIO:</font></td>
 <td align="center" bgcolor="white">
    <textarea cols="23" rows="5" name="beneficio_prod" style="border:0px;font-size:15px"> ${beneficio_prod}</textarea>
 </td>
</tr>


<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial">INSERISCI FOTO 1:</font></td>
 <td align="center">

<c:if test="${empty dettagli.rows[0].foto1}">
 <input type="file" name="form_foto1" value="${param.form_foto1}"/>
</c:if>
<c:if test="${not empty dettagli.rows[0].foto1}">
 <IMG border="0" title="clicca per visualizzare le immagini" src="${dettagli.rows[0].foto1}" width="30" height="30"/>
</c:if>
 </td>
</tr>

<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial">INSERISCI FOTO 2:</font></td>
 <td align="center">
<c:if test="${empty dettagli.rows[0].foto2}">
 <input type="file" name="form_foto2" value="${param.form_foto2}"/>
</c:if>
<c:if test="${not empty dettagli.rows[0].foto2}">
 <IMG border="0" title="clicca per visualizzare le immagini" src="${dettagli.rows[0].foto2}" width="30" height="30"/>
</c:if>
 </td>
</tr>
<tr>
 <td bgcolor="bbccdc"><font color="#007171" size="4" face="Arial">INSERISCI FOTO 3:</font></td>
 <td align="center">
<c:if test="${empty dettagli.rows[0].foto3}">
  <input type="file" name="form_foto3" value="${param.form_foto3}" />

 </c:if>
<c:if test="${not empty dettagli.rows[0].foto3}">
 <IMG border="0" title="clicca per visualizzare le immagini" src="${dettagli.rows[0].foto3}" width="30" height="30"/>
</c:if>
    </td>
</tr>


<tr>
 <td align="center" colspan="2">
 <input type="submit"  style="color:white; border-color:#007171;background-color:#009c9c;width:145px;height:30px;"value="salva"/>
 </td> 
</tr>

</form>
</table>
</td>
<td>

<%-----------------------------------%>
<%-----  SEZIONE PRINCIPALE DX  -----%>
<%-----------------------------------%>
<table border="2" align="center">
<img src="questionario1.jpg" width="350" />
</table>
</td>
</tr>
<tr height="20">
<td></td>
</tr>
</TABLE>
</html>

<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf"%>

