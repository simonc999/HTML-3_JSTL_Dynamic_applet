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
<%------------------------------AUTORIZZAZIONE AREA ALA----------------------------%>
<%---------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="1"/>
<c:set var="auth_page" value="home_ala.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Alambiccus S.R.L."/>

<%@ include file="auth.jspf"%>


<%---------------------------------------------------------------------------------%>
<%----------------------------------FRAMMENTO TOP----------------------------------%>
<%---------------------------------------------------------------------------------%>



<%@ include file="top.jspf"%>
 <td align="right" width="60" >
   <%-- COMANDO INDIETRO --%>
    <a href="home_ala.jsp"> 
     <img style="width:60px;height:60px" src="indietro.png">
    </a>
 </td>

<%---------------------------------------------------------------------------------%>
<%--------------------------------FRAMMENTO MIDDLE---------------------------------%> 
<%---------------------------------------------------------------------------------%>     
<%@ include file="middle.jspf"%>

<%---------------------------------------------------------------------------------%> 
<%---------------------------------QUERY DI NUOVO----------------------------------%>
<%---------------------------------------------------------------------------------%> 


<c:if test="${not empty param.tasto}">
<sql:update>
update CPR set nuovo=false
where user_cpr like ?
<sql:param value="${param.tasto}"/>
</sql:update>
</c:if>

<%---------------------------------------------------------------------------------%> 
<%-------------------------------QUERY DI CONVALIDA--------------------------------%>
<%---------------------------------------------------------------------------------%> 


<c:if test="${not empty param.convalida}">
<sql:update>
  UPDATE UTENTE_RUOLO
  SET attivo=true
  WHERE username LIKE ?
<sql:param value="${param.convalida}"/>
</sql:update>


<sql:update>
  UPDATE CPR
  SET messaggio=true, nuovo=false
  WHERE user_cpr LIKE ?
<sql:param value="${param.convalida}"/>
</sql:update>

</c:if>

<%---------------------------------------------------------------------------------%> 
<%------------------------QUERY PER TABELLA PRINCIPALE-----------------------------%>
<%---------------------------------------------------------------------------------%> 


<sql:query var="rset_cpr">
  select C.user_cpr, C.nome, C.link_sito, C.p_iva, C.sede_legale, U.telefono, C.dirigente, C.mercato, C.nuovo, U.attivo
  from CPR C, UTENTE_RUOLO U
  where C.user_cpr=U.username
  order by U.attivo
</sql:query>


<%---------------------------------------------------------------------------------%> 
<%--------------------------------INTESTAZIONE-------------------------------------%>
<%---------------------------------------------------------------------------------%> 


<br>
<br>
<p style="font-size:32px;color:#008080; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold;margin-bottom:2px" > Benvenuto nell'area CPR</p>
<p style="font-size:16px;color:#008080; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold;margin-bottom:2px" >In questa sezione e' possibile visualizzare le Case produttrici gia' registrate sul sito<br/>e covalidare qualora ci fossero richieste in elenco</p>
<br>
<br>

<%---------------------------------------------------------------------------------%> 
<%---------------------------------TABELLA-------------------------------------------%>
<%---------------------------------------------------------------------------------%>



<table  align="center" cellspacing="0" cellpadding="1" border="0" width="90%"  >
 <tr bgcolor="#008080">
    <th width="14%"><font color="#bfebfc">NOME AZIENDA</font></th>
    <th width="14%"><font color="#bfebfc">LINK SITO</font></th>
    <th width="14%"><font color="#bfebfc">PARTITA IVA</font></th>
    <th width="14%"><font color="#bfebfc">SEDE LEGALE</font></th>
    <th width="14%"><font color="#bfebfc">RECAPITO TELEFONICO</font></th>
    <th width="14%"><font color="#bfebfc">DIRIGENTE</font></th>
    <th width="14%"><font color="#bfebfc">MERCATO</font></th>
 </tr>
</table>
<br>
<br>
<form method="post" action="#">           <%----RICARICA SULLA STESSA PAGINA---%>
  <div style="height:250px; overflow:auto;">
  <table align="center" cellpadding="0" cellspacing="1" border="1" bgcolor="white" bordercolor="#bbccdc" width="90%">
   <c:set var="n" value="0"/>                 <%----- setto variabile che si aggiorna ad ogni ciclo per la label di notifica------%>
       <c:forEach items="${rset_cpr.rows}" var="row">      
          <TR <c:if test="${row.attivo=='true'}">bgcolor="white"</c:if>   <%---CONDIZIONI PER COVALIDA COLORE RIGA-----%>
              <c:if test="${row.attivo=='false'}">bgcolor="add8e6"</c:if> <%---CONDIZIONI PER COVALIDA COLORE RIGA-----%>
            align="center" height="30">
            <TD width="14%">
             <c:if test="${row.nuovo=='true'}">                          <%---CONDIZIONI PER IMMAGINE NOTIFICA-----%>
              <input type="checkbox" name="tasto" value="${row.user_cpr}" onchange="this.form.submit()" id="bottone${n}" style="display:none"/>
                <label for="bottone${n}"><image src="0.png" style="width:25px;height:25px;"/></label>
             </c:if>
             <c:if test="${row.attivo=='false'}">                         <%-----CONDIZIONE PER CONVALIDA----%>
              <input type="checkbox" name="convalida" value="${row.user_cpr}" onchange="this.form.submit()"/>
             </c:if><c:out value="${row.nome}"/></TD>
            <TD width="14%"><c:out value="${row.link_sito}"/></TD>
            <TD width="14%"><c:out value="${row.p_iva}"/></TD>
            <TD width="14%"><c:out value="${row.sede_legale}"/></TD>
            <TD width="14%"><c:out value="${row.telefono}"/></TD>
            <TD width="14%"><c:out value="${row.dirigente}"/></TD>
            <TD width="14%"><c:out value="${row.mercato}"/></TD>
         </TR>
 <c:set var="n" value="${n}+1"/> <%--risetto variabile a fine ciclo--%>
      </c:forEach>
 </table>
</div>
</form>
<p style="font-size:16px;color:red; font-family:Arial">*Cliccare sul checkbox per convalidare la nuova Casa Produttrice <br/>solo dopo aver verificato la veridicita' dei dati</p> 



<%---------------------------------------------------------------------------------%>
<%---------------------------------FRAMMENTO BOTTOM--------------------------------%>
<%---------------------------------------------------------------------------------%>


<%@ include file="bottom.jspf"%>

