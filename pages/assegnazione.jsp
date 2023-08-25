<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%-------------------------------------------------------------------%>
<%-------------------- CONTROLLO PERMESSI GOV -----------------------%>
<%-------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>


<%-------------------------------------------------------------------%>
<%--------------------------FRAMMENTO TOP----------------------------%>
<%-------------------------------------------------------------------%>

<%@ include file="top.jspf"%>

<form method="post" action="scheda_prod_gov.jsp">          
<td align="right" width="60" >
        <%-- COMANDO INDIETRO --%>

       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
      
</td>
 </form>


<%-------------------------------------------------------------------%>
<%------------------------------FRAMMENTO MIDDLE---------------------%>
<%-------------------------------------------------------------------%>

<%@ include file="middle.jspf"%>


<%-------------------------------------------------------------------%>
<%-------------------------------QUERY-------------------------------%>
<%-------------------------------------------------------------------%>

  <sql:query var="rset_sceltacert">
    select U.telefono, U.mail, C.nome, C.cognome, U.username
    from UTENTE_RUOLO U, CERT C
    where C.user_cert=U.username
    and U.attivo=true
    order by convert(substring(U.username, 5),decimal)
  </sql:query>





<%-------------------------------------------------------------------%>
<%-----------------------------TABELLA-------------------------------%>
<%-------------------------------------------------------------------%>


<TABLE  width="75%" align="center">
<br>
 <tr align="center">
  <td width="70%" style="font-size:18px; font-family:arial"> 
   <p style="font-size:23px;font-weight:bold;color: #007171;">ASSEGNAZIONE</p>
   <p style="font-size:15px;font-style: italic;">scegliere l'username corrispondente al CERT desiderato e confermare l'assegnazione cliccando il bottone CONFERMA </p>
  </td>
 </tr>

<c:set var="n" value="0"/> 
 <tr>
  <td>
  <br>
  <br>
   <table cellspacing="0" cellpadding="1" width="100%" align="center">
    <tr style="font-family: arial;font-size:13px;" bgcolor="#008080">       
     <th height="7%" width="14%"><font color="#bfebfc">USERNAME</font></th>
     <th height="7%" width="14%"><font color="#bfebfc">CERTIFICATORE</font></th>
     <th height="7%" width="12.5%"><font color="#bfebfc">TELEFONO</font></th>
     <th height="7%" width="12.5%"><font color="#bfebfc">MAIL</font></th>
     <th height="7%" width="12.5%"><font color="#bfebfc"> &nbsp  PRATICHE 
<img title="Numero pratiche con stato del prodotto certificato" src="verde.png" width="15" height="15"/></font></th>
          <th height="7%" width="12.5%"><font color="#bfebfc"> PRATICHE 
<img title="Numero pratiche con stato del prodotto non certificato"src="rosso.png" width="15" height="15"/> </font></th>
          <th height="7%" width="12.5%"><font color="#bfebfc"> PRATICHE 
<img title="Numero pratiche con stato del prodotto in corso" src="giallo.png" width="15" height="15"/> </font></th>
    </tr>                
   </table>
   <br>
  </td>
 </tr>
 <tr>
  <td align="center">
   <form method="post" action="assegnazione1.jsp">   <%----VAI ALL'ACTION DI ASSEGNAZIONE---%>
    <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>  
     <div style=" height:160px; overflow:auto;">
      <table width="100%" color="#a5bacd" cellspacing="0" bgcolor="#eeeeee" cellpadding="1" border="1" bordercolor="#bbccdc" >
      <c:forEach items="${rset_sceltacert.rows}" var="row">



<%-------------------------------------------------------------------%>
<%-----------------------------QUERY---------------------------------%>
<%-------------------------------------------------------------------%>

  <sql:query var="cert_ban">
    select b.user_cert
    from BAN b, SCHEDA_PROD p
    where b.user_cpr=p.user_cpr 
       and (b.data_inizio_ban <= p.inizio_prat)
       and (p.inizio_prat <= b.data_fine_ban or b.data_fine_ban is null)
       and p.id_scheda LIKE ?
       and b.user_cpr LIKE ?
       and b.user_cert LIKE ?
  <sql:param value="${param.id_scheda}"/>
  <sql:param value="${param.ban_cpr}"/>
  <sql:param value="${row.username}"/>
  </sql:query>

<%-------------------------------------------------------------------%>
<%-----------------QUERY PER VALUTAZIONE-----------------------------%>
<%-------------------------------------------------------------------%>



  <sql:query var="pratiche_concluse">
   select S.id_scheda
   from SCHEDA_PROD S
   where S.fine_prat is not null
   and S.user_cert LIKE ?
  <sql:param value="${row.username}"/>
  </sql:query>

  <sql:query var="prat_concluse_succ">
    select p.id_scheda
    from UTENTE_RUOLO U, CERT C, SCHEDA_PROD p
    where C.user_cert=U.username and
          p.user_cert=C.user_cert and 
          p.fine_prat is not null and  
          p.stato=1 and 
          p.user_cert LIKE ?
  <sql:param value="${row.username}"/>
  </sql:query>

  <sql:query var="prat_concluse_nosucc">
    select p.id_scheda
    from UTENTE_RUOLO U, CERT C, SCHEDA_PROD p
    where C.user_cert=U.username and
          p.user_cert=C.user_cert and 
          p.fine_prat is not null and  
          p.stato=3 and 
          p.user_cert LIKE ?
  <sql:param value="${row.username}"/>
  </sql:query>


  <sql:query var="prat_incorso">
    select p.id_scheda
    from UTENTE_RUOLO U, CERT C, SCHEDA_PROD p
    where C.user_cert=U.username and 
          p.user_cert=C.user_cert and
          p.fine_prat is null and 
          p.user_cert LIKE ?
  <sql:param value="${row.username}"/>
  </sql:query>

<c:set var="n_prat_succ" value="${prat_concluse_succ.rowCount}"/>
<c:set var="n_prat_nosucc" value="${prat_concluse_nosucc.rowCount}"/>
<c:set var="n_prat_incorso" value="${prat_incorso.rowCount}"/>
<c:set var="n_prat_concluse" value="${pratiche_concluse.rowCount}"/>

<c:choose>
 <c:when test="${n_prat_concluse>0}">
<c:set var="percentuale" value="${(n_prat_succ/n_prat_concluse)*100}"/>
 </c:when>
 <c:otherwise>
  <c:set var="percentuale" value="0"/>
</c:otherwise>
</c:choose>




       <tr style="font-family: arial;font-size:12px;" height="40">
        <td width="14%">
         <input type="radio" name="sas" id="user${n}" value="${row.username}"  
          <c:if test="${param.username==row.username}">checked</c:if>
          <c:if test="${not empty cert_ban.rows[0].user_cert}"> disabled </c:if> />
            <label for="user${n}">
          <c:if test="${not empty cert_ban.rows[0].user_cert}"><font color="red">
           <c:out value="${row.username}"/></font> <img title="Utente bannato!" src="ban.png" width="15" height="15"/></c:if>
          <c:if test="${empty cert_ban.rows[0].user_cert}"><font color="black">
           <c:out value="${row.username}"/></font></c:if> 
            </label> 
         </td>
       <td width="20%">   ${row.nome} ${row.cognome} 
<%-------------------------------------------------------------------%>
<%-------------------------VALUTAZIONE CERT--------------------------%>
<%-------------------------------------------------------------------%>
         <c:if test="${percentuale>10 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
         <c:if test="${percentuale>30 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
         <c:if test="${percentuale>50 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
         <c:if test="${percentuale>70 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
         <c:if test="${percentuale>90 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if> 
       </td>
      <td width="12.5%">
       <c:out value="${row.telefono}"/>
      </td>
      <td width="12.5%">
       <c:out value="${row.mail}"/>
      </td>
      <td width="12.5%">
       <c:out value="${n_prat_succ}"/>
      </td>
      <td width="12.5%">
       <c:out value="${n_prat_nosucc}"/>
      </td>
      <td width="12.5%">
       <c:out value="${n_prat_incorso}"/>
      </td>
     </tr>
  <c:set var="n" value="${n}+1"/> 
   </c:forEach>
   </table>  
  </div> 
 </td>
</tr>
<tr>
  <td align="center" style="font-size:14px;color:black;font-family:arial;" >
  <br>
  <button  style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
  <b  style="font-size:17px;color:#eaf0f0;font-family:Arial;" >CONFERMA</b>
  </button>
  <br>
  <br>
  </td>       
</tr>
</TABLE>
</form>

<%-------------------------------------------------------------------%>
<%---------------MESSAGGIO ERRORE USER NON SELEZIONATO---------------%>
<%-------------------------------------------------------------------%>

<c:if test="${not empty msgerror}">${msgerror}</c:if>

<%-------------------------------------------------------------------%>
<%-----------------------FRAMMENTO BOTTOM----------------------------%>
<%-------------------------------------------------------------------%>


<%@ include file="bottom.jspf"%>