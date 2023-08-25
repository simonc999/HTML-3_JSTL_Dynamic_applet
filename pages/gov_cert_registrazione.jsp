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
<%------------------------------------------ CONTROLLO DEI PERMESSI DI GOV ------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT TOP --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="top.jspf"%>
<td align="right" width="60">
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- COMANDO INDIETRO ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
        <a href="elenco_cert.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
</td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT MID --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%@ include file="middle.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------- IMPOSTAZIONE LIMITE MASSIMO PER LA DATA DI NASCITA -------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<jsp:useBean id="data_odierna" class="java.util.Date"/>
<fmt:formatDate var="data_odierna_ymd" pattern="yyyy-MM-dd" value="${data_odierna}"/>



<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- QUERY PER IL GENERATORE -------------------------------------------%>
<%-------------------------------------- AUTOMATICO DEL NUMERO ID CERT ----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-- nella sql di seguito estratta viene estratto l'ultimo numero di id cert presente nel db e lo si incrementa di 1 --%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<sql:query var="idmax">
     select max(convert(substring(username, 5),decimal))  as id_max 
     from UTENTE_RUOLO

</sql:query>

 
<c:if test="${not empty idmax.rows}">
     <c:set var="id_numerocert" value="${idmax.rows[0].id_max + 1}" scope="session"/>
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------- nella riga della tabella di seguito vengono riportati i messaggi di errore ricevuti dalla action gov_cert_registrazione1.jsp -----------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<table  width="100%" cellpadding="7" cellspacing="0" align="center">
    <tr align="left" height="60">
        <td></td>
        <td width="30%" ></td>
        <td colspan="3" style="background-color:#a5bacd;color: #007171;">

            <c:if test="${not empty msg}">
                <font style="font-size:12px" color="red" >L'utente ha dimenticato i seguenti campi, separati da punto (.) :
                </font>
                ${msg}
            </c:if>
            
            <c:if test="${not empty msg3}"> 
                ${msg3}
            </c:if>
            <c:if test="${not empty msg4}"> 
                ${msg4}
            </c:if>
        </td>
    </tr>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-- nella riga della tabella di seguito vengono riportate le descrizioni e i campi da compilare --%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<tr align="left" height="80%" >
        <td>

        </td>
        <td width="30%"  style="font-family:arial"> 
            <p style="font-size:23px;font-weight:bold;color: #007171;">AREA REGISTRAZIONE CERT
            </p>
            <p style="font-size:15px;font-style: italic;">-inserire codice cert
            </p>
            <p style="font-size:15px;font-style: italic;">-inserire email
            </p>
            <p style="font-size:15px;font-style: italic;">-la password dovra' essere costituita 
                <br>da ALMENO 8 CARATTERI
            </p>
            <p style="font-size:15px;font-style: italic;">-il numero d'albo dovra' essere costituito 
                <br>da ALMENO 11 CARATTERI
            </p>
            <p style="font-size:15px;font-style: italic;">-il codice fiscale dovra' essere costituito 
                <br>da ALMENO 16 CARATTERI
            </p>
            <p style="font-size:15px;font-style: italic;">-per tornare all'elenco cert cliccare sul back button in alto a destra
            </p>
        </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------- APERTURA FORM PER GOV_CERT_REGISTRAZIONE1.JSP ---------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
           
           <form method="post" action="gov_cert_registrazione1.jsp">
                <input type="hidden" name="attivo" value="1">
                <input type="hidden" name="codice" value="3">
                <td width="15%" style="font-size:15px;font-weight:bold;font-family:arial;background-color:#a5bacd;color: #007171;" >
                    <p <c:if test="${not empty flagusername}"> style="color: #ff0000;"</c:if>>Username </p>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------- ASSEGNO IN AUTOMATICO L'ID CERT -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

                    <p style="color:black;">USER${id_numerocert}</p>
                    
                    <p <c:if test="${not empty flagnome}"> style="color: #ff0000;"</c:if>>Nome</p>
                    <input type="text" placeholder="Nome" name="name" value="${param.name}"><br>

                    <p <c:if test="${not empty flagcognome}"> style="color: #ff0000;"</c:if>>Cognome</p>
                    <input type="text" placeholder="Cognome" name="surname" value="${param.surname}">
                    <br>

                    <p <c:if test="${not empty flagcf || not empty flagcf1}"> style="color: #ff0000;"</c:if>>C.F.</p>
                    <input type="text" placeholder="Codice Fiscale" name="codicefiscale" value="${param.codicefiscale}"><br>
                      <c:if test="${not empty flagcf1_msg}"> <font color="red" size="1">${flagcf1_msg}</font></c:if>

                    <p <c:if test="${not empty flagsesso}"> style="color: #ff0000;"</c:if>>Sesso<br></p>
                    <input type="radio" name="gender" value="m"  <c:if test="${param.gendermf=='m'}">checked</c:if>>
                    <span style="font-size:12px;font-family:arial;color: #000000;">Maschio
                    </span>
                    <br>
                    <input type="radio" name="gender" value="f" <c:if test="${param.gendermf=='f'}">checked</c:if>>
                    <span style="font-size:12px;font-family:arial;color: #000000;">Femmina 
                    </span>
                </td>
                <td width="15%" style="font-size:15px;font-weight:bold;font-family:arial;background-color:#a5bacd;color: #007171;" >
                    <p <c:if test="${not empty flagdata}"> style="color: #ff0000;"</c:if>>Data di nascita </p>
                    <input type="date" name="data" max="${data_odierna_ymd}" value="${param.data}">
                    <p <c:if test="${not empty flagubicazione}"> style="color: #ff0000;"</c:if>>Ubicazione ente </p>
                    <input type="text" placeholder="Indirizzo" name="indirizzo" value="${param.indirizzo}">
                    <p <c:if test="${not empty flagalbo || not empty flagalbo1}"> style="color: #ff0000;"</c:if>>N. Albo</p>
                    <input type="num" placeholder="numero" name="albo" value="${param.albo}" >
                    <br/>  <c:if test="${not empty flagalbo1_msg}"> <font color="red" size="1">${flagalbo1_msg}</font> </c:if> 

                    <p <c:if test="${not empty flagtelefono}"> style="color: #ff0000;"</c:if>>N. di telefono</p>
                    <input type="num" placeholder="(+39)" name="telefono" value="${param.telefono}" >
                </td>
                <td  style="font-size:15px;font-weight:bold;font-family:arial;background-color:#a5bacd;color: #007171;">
                    <p <c:if test="${not empty flagemail}"> style="color: #ff0000;"</c:if>>Pec</p>
                    <input type="email" placeholder="esempio@esempio.it" name="email" value="${param.email}" >

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------PASSWORD-----------------------------------------------------------------------%>
<%------------------------------E CONFERMA---------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

                    <p <c:if test="${not empty flagpassword || not empty flagpassword1}"> style="color: #ff0000;"</c:if><c:if test="${not empty flagpasswordCC}">style="color: #ff9900;"</c:if>>PASSWORD</p>
                    <input type="password" placeholder="password" name="password" value="${param.password}"> <br>
                    <c:if test="${not empty flagpassword1_msg}"> <font color="red" size="1">${flagpassword1_msg}</font> </c:if> 
                    <p <c:if test="${not empty flagconfpassword}"> style="color: #ff0000;"</c:if><c:if test="${not empty flagpasswordCC}">style="color: #ff9900;"</c:if>>CONFERMA PASSWORD</p>
                    <input type="password" placeholder="verifica" name="confirm_password" value="${param.confirm_password}">
                    
                    <br>
                    <br>
                    <label for="cond" style="cursor:pointer">
                        <span <c:if test="${not empty msg3}"> style="color: #ff0000;"</c:if>>Accetto le condizioni per presa visione
                        </span>
                        <input style="cursor:pointer" type="checkbox" name="cond" id="cond"  <c:if test="${not empty param.condd}">checked</c:if>>
                    </label>
                    <br>
                    <br>
                    
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------CONFERMA-----------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

                    <button style="border-color:#007171;background-color:#009c9c;width:180px;height:40px;">
                        <b style="font-size:13px;color:#eaf0f0;font-family:Arial;" >COMPLETA REGISTRAZIONE
                        </b>
                    </button>
                </td>
            </form>
        </tr>
    </table>
</td>
</tr>
</table>

<%-- la pagina restituisce, oltre al messaggio di errore dei campi non compilati, un indicatore di scritta rosso
     per ogni campo non compilato. E' inoltre possibile identificare nel campo di password le due opzioni di scelta
    colore rosso nel caso in cui il campo rimane vuoto, arancio se la password e la conferma non corrispondono. --%>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------- LAYOUT BOT ------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="bottom.jspf"%>