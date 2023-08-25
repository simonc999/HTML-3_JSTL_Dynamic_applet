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

<%---------------------------------------------- COMANDO BACK -------------------------------------------------%>

<td align="right" width="60">
  <a href="home_gov.jsp"> 
    <img style="width:60px;height:60px" src="indietro.png">
  </a>
</td>
           
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- QUERY PER LA TABELLA ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>  

     
<sql:query var="rset_tipitest">
    select id_tipo, tipo, descrizione, costo_min, costo_max
    from TIPO_TEST
    order by convert(substring(id_tipo, 5),decimal)   <%-- ordino in base al numero di user convertito in decimale e non stringa --%>
</sql:query>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT MID --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="middle.jspf"%>

<table>
  <tr>
  
    <td  align="left">
      <p>
        <h style="font-size:25px;color:007171;font-weight:bold;">AREA TEST</h>
      </p>
      <p>
        <h style="font-size:17px;">In questa sezione sara' possibile :</h>
      </p>
      <p>
        <h style="font-size:17px;">-visualizzare il codice, il tipo, la descrizione, il costo minimo e il costo massimo di ogni tipo di test;</h>
      </p>
      <p>
        <h style="font-size:17px;">-effettuare la gestione (creazione / modifica) dei tipi di test.</h>
      </p>
    </td>
  </tr>

  <tr height="40" align="center">
    <td>      

     <%----------------------------------------%>
     <%-- MESSAGGIO DI SUCCESSO DELLA ACTION --%>
     <%----------------------------------------%>

      <c:if test="${not empty messaggio}">
        <b>${messaggio}</b>
      </c:if>
    </td>
  </tr>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ TABELLA ----------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <tr align="center">
    <td>
      <table  cellspacing="0" cellpadding="1" border="0" width="930" align="center">
        <tr align="center" style="font-family: arial ;" bgcolor="#008080">
          <th width="10%"><font color="#bfebfc">ID_TIPO</font></th>
          <th width="22%"><font color="#bfebfc">TIPO</font></th>
          <th width="29%"><font color="#bfebfc">DESCRIZIONE</font></th>
          <th width="9%"><font color="#bfebfc">MIN [&euro;]</font></th>
          <th width="10%"><font color="#bfebfc">MAX [&euro;]</font></th>
          <th><font color="#bfebfc">MODIFICA &nbsp;&nbsp;&nbsp;</font></th>
        </tr>
      </table>
      <br/>
    </td>
  </tr>

<%-------------------------------------------------------------------------------------------------------------%>
<%---------------------------------------------- C FOR EACH ---------------------------------------------------%>
<%----------------------------------------- FORM PER IL MODIFICA ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <tr>
    <td>
      <div style=" height:200px; overflow:auto;">
        <table width="900" color="#a5bacd" cellspacing="0" cellpadding="0" border="1" bordercolor="#bbccdc" align="center" >
          <c:forEach items="${rset_tipitest.rows}" var="row">
            <tr height="10" bgcolor="white" align="center" >
              <form method="post" action="modifica_tipitest.jsp">            <%-- form che porta alla gestione di modifica --%>
                <td width="8%" ><c:out value="${row.id_tipo}"/></td>
                <td width="22%"><c:out value="${row.tipo}"/></td>
                <td width="28%"><c:out value="${row.descrizione}"/></td>
                <td width="9%"><c:out value="${row.costo_min}"/></td>
                <td width="10%"><c:out value="${row.costo_max}"/></td>
                <td width="18%">
                
                         <%--------------------------------------%>
                         <%-- PARAMETRI DA PASSARE AL MODIFICA --%>
                         <%--------------------------------------%>

                  <input type="hidden"  name="id" value="${row.id_tipo}"/>
                  <input type="hidden"  name="tipo" value="${row.tipo}"/>
                  <input type="hidden"  name="descrizione" value="${row.descrizione}"/>
                  <input type="hidden"  name="min" value="${row.costo_min}"/>
                  <input type="hidden"  name="max" value="${row.costo_max}"/>

                  <button name="modifica" value="modifica" style="border-color:#007171;background-color:#009c9c;width:100px;height:40px;">
                    <b style="font-size:12px;color:#eaf0f0;font-family:Arial;" >MODIFICA</b>
                  </button>
                </td>
              </form>
            </TR>
          </c:forEach>
        </table>
      </div>
    </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------- FORM AGGIUNGI ---------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <form method="post" action="modifica_tipitest.jsp">         <%-- form che porta alla gestione di aggiungi --%>
      <td width="20%" align="center" style="font-size:14px;font-family:arial;">
        <button name="aggiungi" value="aggiungi" style="border-color:#007171;background-color:#009c9c;width:190px;height:40px;">
          <b style="font-size:17px;color:#eaf0f0;font-family:Arial;">AGGIUNGI</b>
        </button>
      </td>
    </form>
  </tr>
</table>

<tr>
  <td>
    <br/>
  </td>
</tr>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT BOT --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
      
<%@ include file="bottom.jspf"%>
