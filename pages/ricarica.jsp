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
<%------------------------------    FRAMMENTO TOP      ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf" %>

<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<td align="right" width="60" >
       <a href="pagamenti.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png"/>
       </a>
</td>

<%------------------------------------------------------------------------%>
<%-------- QUERY CHE ESTRAE IL SALDO E IL NOME DELLA CPR LOGGATA    ------%>
<%------------------------------------------------------------------------%>
<sql:query var="pagamento">
  select nome, saldo
    from CPR
    where user_cpr = ?
  <sql:param value="${user_userid}"/>
</sql:query>

<%--------------------------------------------------------------------------------------%>
<%------------------------------    FRAMMENTO MIDDLE   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf" %>





<table width="90%" height="80%" align="center" cellspacing="0" cellpadding="2" border="0" bgcolor="bbccdc">

<form method="post" action="saldo.jsp">

<tr>
    <td align="center" width="50%" bgcolor="#ADD8E6"><i><font size="5" color="#007171">Inserisci i tuoi dati <br/> per ricaricare il tuo conto. <br/><br/></font></i></td>
    <td rowspan="5" align="center" width="50%" bgcolor="#9ad6d6"><h2><font color="black" size="6">Il tuo saldo attuale e' </br> </font></h2> <font color="green" size="8"><b>${pagamento.rows[0].saldo}&nbsp &euro;<b></font></td>
</tr>
<tr>
  <td align="center" bgcolor="#ADD8E6"><b><font size="4"> Il saldo e' intestato a : ${pagamento.rows[0].nome}</font></b><br/><br/><br/></td>
</tr>
<tr>
  <td align="center" bgcolor="#ADD8E6"><b><font size="4"> Importo (&euro;): </font></b> <br/><br/>

<select name="importo">
  <option value="" checked>--Seleziona l'importo--</option>
   <c:forTokens delims="," items="50.00 ,100.00 ,200.00 ,500.00 ,1000.00 ,2000.00 ,5000.00 " 
     var="scelta">
       <option value="${scelta}"
         <c:forEach var="myimporto" items="${paramValues.importo}">
             <c:if test="${scelta==myimporto}">selected="selected"</c:if>             
         </c:forEach>
        > ${scelta} </option>
   </c:forTokens>
</select> 
      <br/><br/><br/>
    
</td>
</tr>
<tr>
  <td align="center" bgcolor="#ADD8E6"><b><font size="4"> Causale : </font></b> <br/><br/>
  <textarea name="causale" rows="5" cols="50" placeholder="Inserisci Causale">${param.causale}</textarea>
</td>
</tr>

<tr>
<td align="center" bgcolor="#ADD8E6">
</br>
<input type="submit" align="center" style="border-color:#007171;background-  
     color:#009c9c;width:90px;height:25px;" value="Ricarica"/>
                    
</td>
</tr>
</form>
</table>

<%---------------------------------------------%>
<%--STAMPO MESSAGGIO DI ERRORE SE CAMPI VUOTI--%>
<%---------------------------------------------%>
<c:if test="${not empty errmsg}">
     <font color="red">${errmsg}</font>
</c:if>

<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf" %>