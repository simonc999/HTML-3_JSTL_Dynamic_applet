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

<%@ include file="top.jspf" %>

        <!-- COMANDO INDIETRO -->
       <form method="post" action="candidature.jsp"> 
         <td align="right" width="60" >
       <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
       <input type="hidden" name="descrizione" value="${param.descrizione}"/>
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="test" value="${param.test}"/>
     <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
      
   </td>
 </form>


<%@ include file="middle.jspf" %>

<%------------------------------------------------%>
<%-- QUERY CHE ESTRAE I DATI DELLA CANDIDATURA  --%>
<%------------------------------------------------%>
<sql:query var="lista">
  select c.user_lab, c.data_cand, c.campioni, c.tempi, l.nome, a.prezzo,t.data_ora_presc,    
         c.id_candidatura, t.id_test
           from CANDIDATURA c, LAB l, TEST t, AVERE_LISTINO a
           where l.user_lab=c.user_lab and
                 c.id_test=t.id_test   and
                 a.id_tipo=t.id_tipo   and
                 c.user_lab=a.user_lab and 
                 t.id_prescrizione  LIKE ?
                <sql:param value="${param.test}"/>
</sql:query>
<%-----------------------------------------------%>
<%--QUERY CHE ESTRAE IL NOME DELLA CPR LOGGATA --%>
<%-----------------------------------------------%>

<sql:query var="cp">
SELECT nome
FROM CPR 
WHERE user_cpr = ?
<sql:param value="${user_userid}"/>
</sql:query>

<%---------------------------------------------%>
<%--CONVERSIONE DELLA DATA DI CANDIDATURA -----%>
<%---------------------------------------------%>

<fmt:formatDate var="data" 
                value="${lista.rows[0].data_cand}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="ora"
                value="${lista.rows[0].data_cand}"
                type="time"
                pattern="HH:mm"/> 


<fmt:parseNumber var="costo" value="${param.costo}"/>


<table cellspacing="0" cellpadding="0" bgcolor="bbccdc"  width="100%" height="100%">
<tr><td><form method="post" action="paga_test.jsp">

        <input type="hidden" name="data_cand" value="${param.data_cand}"/>
        <input type="hidden" name="ora_cand" value="${param.ora_cand}"/>
        <input type="hidden" name="data" value="${data}"/>
        <input type="hidden" name="ora" value="${ora}"/> 

        <input type="hidden" name="lab" value="${param.lab}"/>
        <input type="hidden" name="costo" value="${costo}"/>
        <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
        <input type="hidden" name="descrizione" value="${param.descrizione}"/>
        <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
        <input type="hidden" name="test" value="${param.test}"/>
        <input type="hidden" name="candidatura"     value="${param.candidatura}"/>


<%------------------------------------------------------%>
<%-- TABELLA PER SELEZIONARE IL METODO DI PAGAMENTO   --%>
<%------------------------------------------------------%>
   <table cellspacing="0" cellpadding="0" bgcolor="bbccdc" align="center" height="65%">
   <caption valign="top" align="center" > <font size="4" color="#008080"><b>
    Seleziona metodo di pagamento:</b>    </font></caption> </br>
        
        <tr><td><input type="radio" name="parte" value="Carta di credito"
                <c:if test="${param.parte=='Carta di credito'}">checked</c:if>/>
             <font size="4"> Carta di credito </font>
             <img valign="bottom" width="80" height="40" src="visa.png">      </img>
              &nbsp&nbsp
             <img valign="middle" width="80" height="50" src="mastercard.png"></img>
              &nbsp&nbsp
             <img valign="middle" width="80" height="40" src="maestro.png">   </img>
        </td></tr>

        <tr><td><input type="radio" name="parte" value="Paypal"
                 <c:if test="${param.parte=='Paypal'}">checked</c:if>/>
             <font size="4"> Paypal </font>
              &nbsp&nbsp  
             <img valign="middle" width="70" height="40" src="paypal.png">    </img>
        </td></tr>

        <tr><td><input type="radio" name="parte" value="Bonifico online"
                <c:if test="${param.parte=='Bonifico online'}">checked</c:if>/>
            <font size="4"> Bonifico online </font>
             &nbsp&nbsp  
            <img valign="middle" width="60" height="40" src="bonifico.png">   </img>
        </td></tr>

        <tr><td colspan="2" align="center" >
        </br>  
        <INPUT TYPE="submit" style="border-color:#007171;background-color:#009c9c;width:130px;height:30px;" VALUE="Avanti"/>
             </td> 
         </tr> 
        
    </table>
    </form>
</td>
<%----------------------------------------------------------------------------%>
<%---- TABELLA CHE APPARE DOPO AVER SELEZIONATO IL METODO DI PAGAMENTO,DIVERSA
       A SECONDA DEL METODO SCELTO   ----%>
<%----------------------------------------------------------------------------%>
      <form method="post" action="action_paga.jsp">

       
       <input type="hidden" name="data" value="${data}"/>
       <input type="hidden" name="ora" value="${param.ora}"/>
       <input type="hidden" name="costo" value="${param.costo}"/> 
       <input type="hidden" name="parte" value="${param.parte}"/>
       <input type="hidden" name="lab" value="${param.lab}"/>
       <input type="hidden" name="test" value="${param.test}"/>
       <input type="hidden" name="candidatura" value="${param.candidatura}"/>

<td>
<%------------------------------------------------------%>
<%--- TABELLA PER I PRIMI DUE METODI        ---%>
<%------------------------------------------------------%>
<c:if test="${param.parte == 'Paypal' ||
              param.parte == 'Carta di credito'}">
      <table cellspacing="0" cellpadding="0" bgcolor="bbccdc" align="center" height="65%">
      <caption valign="top" align="center" >
      <font size="4" color="#008080"><b>Inserisci i dati della tua carta:</b></font>   
      </caption> </br>

        <tr><td>Intestatario:</td>
            <td><input type="text" name="intestatario" size="25" maxlength="40" 
                 value= "${cp.rows[0].nome}"/>
            </td>
        </tr> 
   
        <tr><td>Numero carta:</td>
            <td><input type="num" name="numero" value="${param.numero}" placeholder="1111 1111 1111 1111"/> 
            </td> 
        </tr> 

        <tr><td>Data scadenza:</td>
        <td> <select name="form_month">
             <option value=""> Mese </option>
               <c:forEach begin="1" end="12" var="var_month">
             <option value="${var_month}"
              <c:if test="${param.form_month == var_month}"> selected="selected" </c:if>
             >${var_month}</option>
               </c:forEach>
            </select>

            <select name="form_year">
              <option value=""> Anno </option>
                <c:forEach begin="2021" end="2030" var="var_year">
                 <option value="${var_year}"
              <c:if test="${param.form_year == var_year}"> selected="selected" </c:if>
               >${var_year}</option>
                  </c:forEach>
            </select> 
        </td> 
        </tr> 

        <tr><td>Codice di sicurezza:</td>
        <td><input type="num" name="codice" value="${param.codice}" /> 
        </td>
        </tr> 

        <tr><td>Totale da pagare:</td>
            <td><input type="text" name="costo" value="${param.costo} &euro;" disabled 
                 maxlength="27" value= "${param.costo}"/>
            </td>
        </tr>

        <tr>
            <td><input type="date" min="${param.data}" name="data_pagamento" 
                 value="${param.data_pagamento}"/>
                <input type="time" name="ora_pagamento" value="${param.ora_pagamento}"/>
            </td></tr>

        <tr>
            <td colspan="2" align="center" >
            </br>  
        <INPUT TYPE="submit"  style="border-color:#007171;background-color:#009c9c;width:130px;height:30px;" VALUE="Effettua pagamento"/>
            </td> 
       </tr> 
<%------------------------------------------------------%>
<%--- MESSAGGI DI ERRORE     ---%>
<%------------------------------------------------------%>
       <tr><td colspan="2"> <font color="red" size="4"> ${errmsg}              </font></td></tr>
       <tr><td colspan="2"> <font color="red" size="4"> ${msg}                 </font></td></tr>
       <tr><td colspan="2"> <font color="red" size="4"> ${controllo_numero}    </font></td></tr>
       <tr><td colspan="2"> <font color="red" size="4"> ${controllo_codice}    </font></td></tr>    
</table>
</c:if>

<%------------------------------------------------------%>
<%--- TABELLA PER IL TERZO METODO DI PAGAMENTO       ---%>
<%------------------------------------------------------%>
<c:if test="${param.parte == 'Bonifico online'}">
       <table cellspacing="0" cellpadding="0" bgcolor="bbccdc" align="center" 
        height="65%">
       <caption valign="top" align="center" ><font size="4" color="#008080">
        <b>Inserisci i dati per il bonifico:</b></font></caption></br>

        <tr><td>Intestatario:</td>
            <td><input type="text" name="intestatario" size="25" maxlength="40" 
                 value= "${cp.rows[0].nome}"/>
            </td>
        </tr>

        <tr><td>Iban:</td>
            <td><input type="text" name="iban" value="${param.iban}" size="25" 
                 value= "${param.iban}"/>
            </td>
        </tr>

        <tr><td>Totale da pagare:</td>
            <td><input type="text" name="costo" disabled value="${param.costo} &euro;"       
                 size="25"  value= "${param.costo}"/>
            </td>
        </tr>

        <tr>
            <td><input type="date" min="${param.data}" name="data_pagamento" 
                 value="${param.data_pagamento}"/>
                <input type="time" name="ora_pagamento" value="${param.ora_pagamento}"/>
            </td>
        </tr>

        <tr>
           <td colspan="2" align="center" ></br>  
           <INPUT TYPE="submit"  style="border-color:#007171;background-color:#009c9c;width:130px;height:30px;" VALUE="Effettua pagamento"/>
           </td> 
       </tr> 
<%------------------------------------------------------%>
<%--- MESSAGGI DI ERRORE  ---%>
<%------------------------------------------------------%>
    <tr><td colspan="2"> <font color="red" size="4"> ${errmsg}            </font></td></tr>
    <tr><td colspan="2"> <font color="red" size="4"> ${msg1}              </font></td></tr>
    <tr><td colspan="2"> <font color="red" size="4"> ${controllo_iban}    </font></td></tr>


     </table>
</c:if>

</td>
<br/>

</form>
</tr>

</table>


<%@ include file="bottom.jspf" %>