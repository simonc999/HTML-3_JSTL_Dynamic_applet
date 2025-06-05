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
<%------------------------------AUTORIZZAZIONE AREA LAB---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%---------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE LA DATA DEL PAGAMENTO DEL LAB SCELTO               ----%>
<%---------------------------------------------------------------------------%>

<sql:query var="chat1">
    select u.mail, p.Nome_prod, tt.tipo, c.nome
    from  TEST t, SCHEDA_PROD p, CPR c, UTENTE_RUOLO u,TIPO_TEST tt
    where c.user_cpr=p.user_cpr and u.username=c.user_cpr and t.id_tipo=tt.id_tipo and t.id_scheda = p.id_scheda and t.id_test ="${param.id_test}"
</sql:query>

<sql:query var="data_pag">
select c.data_pagamento
from CANDIDATURA c, TEST t
where t.id_test = c.id_test and c.data_pagamento is not null and t.id_test="${param.id_test}"
</sql:query>

<fmt:formatDate var="var_data" 
                value="${data_pag.rows[0].data_pagamento}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${data_pag.rows[0].data_pagamento}"
                type="time"
                pattern="HH:mm"/>


<%@ include file="top.jspf"%>

<%---------------------------------------------------------------------------------------------------------------------------%>
<%-- TASTO BACK CHE RIMANDA ALLA SCHEDA TEST O ALL'ELENCO MESSAGGI A SECONDA CHE IL MESSAGGIO SIA STATO COMPILATO O MENO ----%>
<%---------------------------------------------------------------------------------------------------------------------------%>

<c:if test="${param.n_mess1 > 0}" >
<form method="post" action="messaggi.jsp"> 

<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       
       <input type="hidden" name="id_test" value="${param.id_test}"/>
       <input type="hidden" name="nome" value="${param.nome}"/>
       <input type="hidden"  name="n_mess1" value="${param.n_mess1}">
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
</td> 
       </form>
</c:if>

<c:if test="${param.n_mess1 == 0}" >
<form method="post" action="scheda_test.jsp"> 

<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       
       <input type="hidden" name="id_test" value="${param.id_test}"/>
       <input type="hidden" name="nome" value="${param.nome}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
</td> 
       </form>
</c:if>


<%@ include file="middle.jspf"%>
<%---------------------------------------------------------------------------------------------------------------------------%>
<%---------- SEZIONE CENTRALE DELLA PAGINA CONTIENE TABELLA TRAMITE CUI COMPILARE NUOVA MAIL              -------------------%>
<%---------------------------------------------------------------------------------------------------------------------------%>

    <form method="post" action="invia.jsp">
        <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
        <input type="hidden" name="descrizione" value="${param.descrizione}"/>
        <input type="hidden" name="id_lab" value="${param.id_lab}"/>
        <input type="hidden" name="id_test" value="${param.id_test}"/>
        <input type="hidden"  name="var_data" value="${var_data}"/>
        <input type="hidden"  name="var_ora" value="${var_ora}"/>
        <input type="hidden"  name="n_mess1" value="${param.n_mess1}"/>
        <input type="hidden"  name="nome" value="${chat1.rows[0].nome}"/>

        <br/>
   <c:if test="${not empty errmsg}">
                     <h4 align="center"><font color="red">${errmsg}</font></h4>
                    </c:if>
              
        <table border="1" cellpadding="1" bgcolor="007171">
            
            <tr>
                <td align="right"><img src="invia1.png" width="20" valign="middle" align="left"> 
                  <input type="date" min="${var_data}" name="data" value="${param.data}">
                  <input type="time" name="ora" value="${param.ora}">

                  <input type="submit" value="invia">
                </td>
            </tr>
            <tr>
                <td>
                <table bgcolor="#007171" height="90%" width="100%">
                    <tr>
                        <td width="15%"><font color="9ad6d6">A:</font></td>
                        <td><input type="text" size="70"  name="mail_lab" value="${chat1.rows[0].mail}" disabled></td>
                    </tr>
                    <tr>
                        <td width="15%"><font color="9ad6d6">OGGETTO:</font></td>
                        <td><input type="text" size="70" name="oggetto" value="${param.oggetto}"/></td>
                    </tr>
                </table>
                </td>
             </tr>
            <tr>
                 <td>
                 <textarea name="messaggio" cols = 81 rows=10  placeholder="Scrivi..." value="${param.messaggio}">${param.messaggio}</textarea>
                 </td>
             </tr>
        </table>
    </form>

<br/><br/>




<%@ include file="bottom.jspf"%>