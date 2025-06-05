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
<%-- QUERY CHE FA L'UPDATE: QUANDO UNA PRESCRIZIONE  VIENE VISUALIZZATA
     PER LA PRIMA VOLTA, VIENE MODIFICATO L'ATTRIBUTO 'NUOVA' DELLA TABELLA VISUALIZZARE_PRESC
     CHE DIVENTA DA TRUE A FALSE.
     METTO IL C:IF PERCHE' L'UPDATE LO DEVO FARE SOLO PER LE PRESCRIZIONI NUOVE --%>
<%--------------------------------------------------------------------------------------%>

<sql:update>
     UPDATE VISUALIZZARE_PRESC set nuova = false
     where id_presc ="${param.id_prescrizione}"
     and user_lab="${user_userid}"
</sql:update>


<%------------------------------------------------------------------------%>
<%---------------  AUTORIZZAZIONE AREA LAB -------------------------------%>
<%------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>

<form method="post" action="nuove_presc.jsp"> 

<td align="right"  width="60">
        <!-- COMANDO INDIETRO -->
       <input type="hidden" name="id_scheda" value="${param.id_prescrizione}"/>
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="presc" value="${param.test}"/>
    <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
</td> 
       </form>

<%@ include file="middle.jspf"%>


<%--------------------------------------------------------------------------------------%>
<%------------------------------------QUERY PRINCIPALE----------------------------------%>
<%--------------------------------------------------------------------------------------%>

<sql:query var="rset_schedapresc">
    select p.Nome_prod, t.user_cert, p.id_scheda, t.id_prescrizione, tt.tipo, t.id_test, al.prezzo, t.data_ora_presc, t.motivi, t.risultati_attesi, t.scopo
    from SCHEDA_PROD p, TIPO_TEST tt, TEST t, AVERE_LISTINO al
    where t.id_scheda=p.id_scheda and t.id_tipo=tt.id_tipo and al.id_tipo=tt.id_tipo and al.user_lab="${user_userid}" and t.id_prescrizione LIKE ?
  <sql:param value="${param.id_prescrizione}"/>
</sql:query>

<%--------------------------------------------------------------------------------------%>
<%--------------------------------------FORMATO DATE------------------------------------%>
<%--------------------------------------------------------------------------------------%>

<fmt:formatDate var="var_data" 
                value="${rset_schedapresc.rows[0].data_ora_presc}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${rset_schedapresc.rows[0].data_ora_presc}"
                type="time"
                pattern="HH:mm"/>

     <TABLE  cellspacing="0" border="0" bgcolor="#bbccdc"
              width="100%" height="100%" bordercolor="#41140E"  >
    
    <tr>
<%--------------------------------------------------------------------------------------%>
<%------------------------------SEZIONE DESTRA------------------------------------------%>
<%--------------------------------------------------------------------------------------%>
        <td align="left" width="70%" height="100%" style="padding: 0px;border-left-width: 3px ">
                <table border="0" width="100%" height="100%">
                   <tr width="30%">
                             <td width="100%" height="15%" valign="bottom"><p align="center"  
                             style="font-size:23px;color: #007171;font-weight:bold;font-family:arial" ><BR>SCHEDA PRESCRIZIONE</p>
                             </td>
                   </tr>
                   <tr height="70%" width="100%">
                       <td>
<%--------------------------------------------------------------------------------------%>
<%-----------------------TABELLA CON INFORMAZIONI PRESCRIZIONE--------------------------%>
<%--------------------------------------------------------------------------------------%>
                          <table border="0" width="70%" align="center">
                            <tr>
                                <td  align="left"; width="50%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px">
                                <p style="font-size:17px;font-weight:bold;color: 
                                 #007171;">PRODOTTO:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].Nome_prod}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: 
                                 #007171;">CODICE PRODOTTO:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].Id_scheda}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: 
                                 #007171;">CERT:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].user_cert}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: 
                                 #007171;">CODICE PRESCRIZIONE:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].id_prescrizione}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: 
                                 #007171;">TEST PRESCRITTO:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].tipo}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: #007171;">COSTO:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].prezzo} &euro; </font></p>
                                <p style="font-size:17px;font-weight:bold;color: #007171;">MOTIVI PRESCRIZIONE:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].motivi}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: #007171;">RISULTATI ATTESI:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].risultati_attesi}</font></p>
                                <p style="font-size:17px;font-weight:bold;color: #007171;">SCOPO:&nbsp<font style="font-weight: normal;color:black;">${rset_schedapresc.rows[0].scopo}</font></p>
                                </td>
                                <td align="center" height="100%" width="50%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px">       
                                    <form method="post" action="candidatura.jsp">
                                <p style="font-size:17px;font-weight:bold;color: #007171;">Data e ora</p><input name="date" type="date" min="${var_data}" value="${param.date}"><input name="time" type="time" value="${param.time}"> 
                                <p style="font-size:17px;font-weight:bold;color: #007171;">Tempi previsti</p><input name="tempi"  type="text" placeholder="---"  value="${param.tempi}">
                                <p style="font-size:17px;font-weight:bold;color: #007171;">Campioni necessari</p><input name="campioni" type="text" placeholder="---"  value="${param.campioni}">
     
                                 
                                </td>
                            </tr>
                          </table>
                        </td>                        
                    </tr>
                </table>
             </td>
                        
<%--------------------------------------------------------------------------------------%>
<%-----------------------------------SEZIONE SINISTRA-----------------------------------%>
<%--------------------------------------------------------------------------------------%>

                 <td width="30%" height="100%">
                     <table  cellspacing="0" border="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
                        <tr height="20%">
                           <td valign="top">
                            <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px"><br>CANDIDATURA</p>
                            <hr color="#53667a" size="9px">
                           </td>
                        </tr>
                          <tr>
                            <td align="center">  
                                 <c:if test="${not empty errmsg}">
                                     <font color="red" >${errmsg}</font>
                                  </c:if>
                            </td>
                          </tr>
                          <tr height="80%">
                          <td align="center" valign="top">
                            <table border="0" width="85%" height="70%">
                               <tr height="50%">
                                 <td>
                                 <p style="text-align: justify;font-size:20,5px;color:#3b4957; font-family:Arial, Helvetica, sans-serif; font-weight: bold;">La richiesta di candidatura deve essere processata e accettata dalla Casa di produzione del prodotto.<br>Al termine dell'operazione verranno accreditati i costi del test.<br>Il procedimento potrebbe richiedere qualche giorno.</p>
                                 </td>
                               </tr>
                               <tr height="20%">
                                        <td align="center">
                                        <br>
                                           <input type="checkbox" id="username" name="username" required><font style="font-size:17px;font-weight:bold;color: #007171;">&nbsp Ho capito </font>
                                           <br>
                                           <br>
                                           <br>
                                              <input type="submit" name="submission" value="Invia Richiesta"/>
                                              <input type="hidden" name="id_scheda" value="${param.id_prescrizione}"/>
                                              <input type="hidden" name="id_test" value="${rset_schedapresc.rows[0].id_test}"/> 
                                              <input type="hidden" name="costo" value="${rset_schedapresc.rows[0].prezzo}"/>
                                              <input type="hidden"  name="var_data" value="${var_data}"/>
                                              <input type="hidden"  name="var_ora" value="${var_ora}"/>
                                        </td>
                                   </form>
                               </tr>
                               
                            </table>
                           </td>
                         </tr>
                        </table>
                  </td>
                 </tr>
      </TABLE> 

<%@ include file="bottom.jspf"%>