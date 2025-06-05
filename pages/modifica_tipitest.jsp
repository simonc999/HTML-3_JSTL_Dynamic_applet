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
<%------------------------------------ CONTROLLO DEI PERMESSI DI GOV ------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- QUERY PER IL GENERATORE -------------------------------------------%>
<%-----------------------------------------  AUTOMATICO DEL ID_TIPO -------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:if test="${!empty param.aggiungi}">
  <sql:query var="idmax">
    select max(convert(substring(id_tipo, 5),decimal))  as id_max   <%-- devo convertire in decimale i numeri di user che sono in stringa --%>
    from TIPO_TEST
  </sql:query>

  <c:if test="${not empty idmax.rows}">
    <c:set var="id" value="${idmax.rows[0].id_max + 1}" scope="session"/>  <%-- incremento del massimo valore --%>
  </c:if>
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------- QUERY PER LA TABELLA --------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<sql:query var="rset_tipitest">
  select id_tipo, tipo, descrizione, costo_min, costo_max
  from TIPO_TEST
</sql:query>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ LAYOUT TOP -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



<%@ include file="top.jspf"%>

<%------------------ COMANDO BACK ---------------------%> 

<td align="right" width="60" >
  <a href="elenco_tipitest.jsp"> 
    <img style="width:60px;height:60px" src="indietro.png">
  </a>
</td>
           
            


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- LAYOUT MID ----------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="middle.jspf"%>

<table width="100%" cellpadding="7" cellspacing="0" align="center">
  <form method="post" action="modifica_tipitest1.jsp">   <%-- form per la action --%>
    <tr align="left" >

      <td width="1%"></td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------ SEZIONE DESCRITTIVA MODIFICA -------------------------------------------%>
<%------------------------ sfrutto il parametro del tasto modifica per presentare  ----------------------------%>
<%-------------------------------- solo la parte descrittiva di modifica --------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <c:if test="${!empty param.modifica}">
        <td width="30%" style="font-family:arial"> <p style="font-size:23px;font-weight:bold;color: #007171;">AREA MODIFICA TIPO DI TEST</p>
          <p style="font-size:15px;font-style: italic;">-modificare i dati interessati e confermare</p>
          <p style="font-size:15px;font-style:italic; <c:if test="${!empty flagequ}">color:red</c:if>">-costo minimo deve essere minore del costo massimo </p>
          <p style="font-size:15px;font-style: italic;">-accettare i termini d'uso</p>
          <p style="font-size:15px;font-style: italic;">-per tornare all'elenco test cliccare sul back button in alto a destra</p>
        </td>
        <input type="hidden" name="modifica" value="${param.modifica}"/>   <%-- ripasso il valore del bottone modifica --%>
      </c:if>                                                                <%-- per diversificare l'action modifica --%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------ SEZIONE DESCRITTIVA AGGIUNGI -------------------------------------------%>
<%------------------------ sfrutto il parametro del tasto aggiungi per presentare  ----------------------------%>
<%-------------------------------- solo la parte descrittiva di aggiungi --------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <c:if test="${!empty param.aggiungi}">
        <td width="30%" style="font-family:arial"> 
          <p style="font-size:23px;font-weight:bold;color: #007171;">AREA CREAZIONE TIPO DI TEST</p>
          <p style="font-size:15px;">-inserire codice del tipo di test</p>
          <p style="font-size:15px;">-inserire il tipo (analisi di laboratorio o prova materiale)</p>
          <p style="font-size:15px;">-inserire una breve descrizione</p>
          <p style="font-size:15px;">-indicare il costo minimo e il costo massimo [&euro;] </p>
          <p style="font-size:15px;font-style:italic; <c:if test="${!empty flagequ}">color:red</c:if>">-costo minimo deve essere minore del costo massimo</p>
          <p style="font-size:15px;">-accettare i termini d'uso per continuare</p>
          <p style="font-size:15px;">-per tornare all'elenco test cliccare sul back button in alto a destra</p>
        </td>
        <input type="hidden" name="aggiungi" value="${param.aggiungi}"/>   <%-- ripasso il valore del bottone aggiungi --%> 
      </c:if>                                                                <%-- per diversificare l'action aggiungi --%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------ INPUT ID E NOME --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <td style="font-family:arial; background-color:#a5bacd;font-size:16px;font-weight:bold;color: #007171">

        <c:if test="${!empty param.modifica}">    <%-- sfrutto il parametro del tasto modifica per far uscire l'id della tupla da modificare --%>
          <p>Id : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:black;font-size:20px">${param.id}</span></p> 
          <input type="hidden" name="id" value="${param.id}"/>
        </c:if>

        <c:if test="${!empty param.aggiungi}">   <%-- sfrutto il parametro del tasto aggiungi per far uscire l'id nuovo grazie al generatore sopra --%>
          <p>Id : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:black;font-size:20px">tipo${id}</span></p> 
        </c:if>

        <br/>
        <p <c:if test="${not empty flagtipo}"> style="color: #ff0000;"</c:if>>Tipo: </p>
        <select name="tipo">
          <c:if test="${!empty param.aggiungi}">
            <option selected>--Selezionare un tipo--</option>
          </c:if>
          <option value="analisi di laboratorio" <c:if test="${param.tipo=='analisi di laboratorio'}">selected</c:if>>analisi di laboratorio</option>
          <option value="prova materiale" <c:if test="${param.tipo=='prova materiale'}">selected</c:if>>prova materiale</option>
        </select>
      </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- INPUT DESCRIZIONE -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <td style="font-family:arial;background-color:#a5bacd;font-size:16px;font-weight:bold;color: #007171">    
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <p  <c:if test="${not empty flagdescrizione}"> style="color: #ff0000;"</c:if>>Descrizione: </p>
        <textarea name="descrizione" cols="30" rows="7" value="${param.descrizione}">${param.descrizione}</textarea>
        <br/>
        <br/>
        <br/>

        <%-------------------------%>
        <%-- MESSAGGIO DI ERRORE --%>
        <%-------------------------%>
        
        <c:if test="${ not empty messaggio}">
          <b> ${messaggio}</b>
        </c:if>

        <br/>
        <br/>
        <br/>
        <br/>
      </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- INPUT COSTO E BOTTONE ---------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <td style="font-family:arial; background-color:#a5bacd;font-size:16px;font-weight:bold;color: #007171;">     
        <br/>
        <br/>
        <br/>  
        <br/>
        <p <c:if test="${not empty flagmin}"> style="color: #ff0000;"</c:if>>Costo Minimo:</p>
        <input type="text" placeholder="0000 &euro;" name="min" value="${param.min}"/>
        <p  <c:if test="${not empty flagmax}"> style="color: #ff0000;"</c:if>>Costo Massimo:</p>
        <input type="text" placeholder="0000 &euro;" name="max" value="${param.max}"/>
        <br/>
        <br/>
        <input type="checkbox" style="cursor: pointer;" id="check" name="set" required/>
        <label style="cursor: pointer;" for="check">Accetto i termini d'uso</label>
        <br/>
        <br/>
        <button  style="border-color:#007171;background-color:#009c9c;width:200px;height:50px;">
        <b align="center" style="font-size:16px;color:black;font-family:arial;"> CONFERMA TEST</b>
        </button>
      </td>

    </tr> 
  </form>
</table>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ LAYOUT BOT -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%@ include file="bottom.jspf"%>
