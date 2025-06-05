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


<%---------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE LA DATA DEL PAGAMENTO DEL LAB SCELTO               ----%>
<%---------------------------------------------------------------------------%>
<sql:query var="data_pag">
select c.data_pagamento
from CANDIDATURA c, TEST t
where t.id_test = c.id_test and c.data_pagamento is not null and t.id_prescrizione LIKE ?
<sql:param value="${param.test}"/>
</sql:query>

<%--------------------------------------------------------------------------------------%>
<%----------------------------- CONVERSIONE DELLE DATE ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<fmt:formatDate var="var_data" 
                value="${data_pag.rows[0].data_pagamento}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${data_pag.rows[0].data_pagamento}"
                type="time"
                pattern="HH:mm"/>


<%--------------------------------------------------------------------------------------%>
<%----------------------------      TOP                         ------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%>
<form method="post" action="posta_lab.jsp">
<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       
         <input type="hidden" name="data"          value="${param.data}"/>
         <input type="hidden" name="ora"           value="${param.ora}"/>
         <input type="hidden" name="data_pag"      value="${var_data}"/>
         <input type="hidden" name="ora_pag"       value="${var_ora}"/>
         <input type="hidden" name="id_scheda"     value="${param.id_scheda}"/>
         <input type="hidden" name="test"          value="${param.test}"/>
         <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
         <input type="hidden" name="descrizione"   value="${param.descrizione}"/>

<input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
       
</td>
</form>

<%--------------------------------------------------------------------------------------%>
<%------------------------------       INIZIO HTML     ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>
<form method="post" action="invia_mess.jsp">
<input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
<input type="hidden" name="descrizione" value="${param.descrizione}"/>
<input type="hidden" name="id_lab" value="${param.id_lab}"/>
<input type="hidden" name="test" value="${param.test}"/> 
<input type="hidden" name="var_data" value="${var_data}"/>
<input type="hidden" name="var_ora" value="${var_ora}"/> 
<input type="hidden" name="mail_lab" value="${param.mail_lab}"/>


<br/>

<table border="1" cellpadding="1" bgcolor="007171">
<%--------------------------------------------------------------------------------------%>
<%------- C:IF DEI MESSAGGI DI ERRORI CHE PROVENGONO DALLA ACTION (invia_mess)----------%>
<%--------------------------------------------------------------------------------------%>
 <tr><td><c:if test="${not empty param.errmsg}">
          <h5 align="center"><font color="red">${param.errmsg}</font></h5>
         </c:if>
     </td>
 </tr>
 <tr><td><c:if test="${not empty errmsg1}">
          <h5 align="center"><font color="red">${errmsg1}</font></h5>
         </c:if>
     </td>
 </tr>
<%--------------------------------------------------------------------------------------%>
<%--- INPUT CON I DATI DA INSERIRE (DATA, MITTENTE, OGGETTO, MESSAGGIO)  ---------------%>
<%--------------------------------------------------------------------------------------%>
 <tr>
     <td align="right"><img src="invia1.png" width="20" valign="middle" align="left"> 
       <input type="date" min="${var_data}" name="data" value="${param.data}">
       <input type="time" name="ora" value="${param.ora}">
       <input type="submit" value="invia">
     </td>
 </tr>

 <tr>
     <td><font color="9ad6d6">Mittente:</font> &nbsp
     <input type="text" size="80"  name="mail_lab" value="${param.mail_lab}" disabled>
     </td>
 </tr>

  <tr>
     <td><font color="9ad6d6">Oggetto:</font> &nbsp
         <input type="text" size="80" name="oggetto" value="${param.oggetto}" >
     </td>
  </tr>

  <tr>
      <td><textarea name="messaggio" cols = 81 rows=10  placeholder="Scrivi..." 
           value="${param.messaggio}">${param.messaggio}</textarea>
      </td>
  </tr>
 <tr>
    <td align="center"><font color="red" size="4">${errmsg} </font></td>
  </tr>
</table>
</form>

<br/><br/>



<%--------------------------------------------------------------------------------------%>
<%------------------------------            BOTTOM     ---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<%@ include file="bottom.jspf"%>

