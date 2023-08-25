<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%---------------------------------------------------------------------------------%>
<%------------------------AUTORIZZAZIONE AREA ALA----------------------------------%>
<%---------------------------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="1"/>
<c:set var="auth_page" value="home_ala.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Alambiccus S.R.L."/>

<%@ include file="auth.jspf"%>

<%---------------------------------------------------------------------------------%>
<%-----------------------------FRAMMENTO TOP---------------------------------------%>
<%---------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%>

 <td align="right"  width="60">
  <%----------COMANDO INDIETRO-----%>
    <a href="home_ala.jsp"> 
      <img style="width:60px;height:60px" src="indietro.png">
    </a>
  </td>


<%---------------------------------------------------------------------------------%>
<%---------------------------FRAMMENTO MIDDLE--------------------------------------%>   
<%---------------------------------------------------------------------------------%>          

<%@ include file="middle.jspf"%>


<%---------------------------------------------------------------------------------%> 
<%------------------------------------QUERY----------------------------------------%>
<%---------------------------------------------------------------------------------%> 
<sql:query var="rset_elencolab">
    select nome, p_iva, sede_legale
    from LAB
</sql:query>

<%---------------------------------------------------------------------------------%> 
<%-------------------------------INTESTAZIONE--------------------------------------%>
<%---------------------------------------------------------------------------------%> 

<br>
<p style="font-size:32px;color:#008080; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold;margin-bottom:2px" > Benvenuto nell'area LAB</p>

<br>
<br>

<%---------------------------------------------------------------------------------%> 
<%-----------------------------MESSAGGIO DI AGGIUNTA-------------------------------%>
<%---------------------------------------------------------------------------------%> 

<c:if test="${not empty messaggi}">
 <font color="green"> ${messaggi}</font>
</c:if>
<br/>
<br/>


<%---------------------------------------------------------------------------------%> 
<%----------------------------------TABELLA----------------------------------------%>
<%---------------------------------------------------------------------------------%>    
 <table  align="center" cellspacing="0" cellpadding="1" border="0"  bordercolor="#bbccdc" width="1240px">
  <tr bgcolor="#008080">
    <th width="25%"><font color="#bfebfc">NOME</font></th>
    <th width="25%"><font color="#bfebfc">PARTITA IVA</font></th>
    <th width="25%"><font color="#bfebfc">SEDE LEGALE</font></th>
  </tr>
 </table> 
<br/>
<div style="width:1250px;height:250px;overflow-y:scroll;">
 <table align="center" cellpadding="0" cellspacing="1" border="1" bgcolor="white" bordercolor="#bbccdc" width="1200px">
     <c:forEach items="${rset_elencolab.rows}" var="row">
       <TR bgcolor="white" align="center" height="30">
         <TD width="25%"><c:out value="${row.nome}"/></TD>
         <TD width="25%"><c:out value="${row.p_iva}"/></TD>
         <TD width="25%"><c:out value="${row.sede_legale}"/></TD>
       </TR>
    </c:forEach>
 </table>
</div>


<br/>


<table align="center" cellspacing="0" cellpadding="1" border="0" width="1200" bgcolor="#bbccdc" >
    <tr align="center">
      <form method="post" action="crealab.jsp">      <%-----PASSAGGIO AL CREA NUOVO ACCOUNT LAB-----%>
       <td colspan="3" align="center"><br/>
        <button type="submit" style="border-color:#007171;background-color:#008080;width:230px;height:40px;"><b style="font-size:13px;color:#bfebfc;font-family:Arial;">CREA NUOVO ACCOUNT</b></button>
      </td>
      </form>
    </tr>
</table>
<br/>


<%---------------------------------------------------------------------------------%> 
<%------------------------------FRAMMENTO BOTTOM-----------------------------------%>
<%---------------------------------------------------------------------------------%> 
<%@ include file="bottom.jspf"%>
