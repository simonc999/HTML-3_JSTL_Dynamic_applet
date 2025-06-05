<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----------------------------------------------------------------------%>
<%--------------- AUTORIZZAZIONE AREA LAB   ----------------------------%>
<%----------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>

<form method="post" action="scheda_test.jsp"> 

<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       
       <input type="hidden" name="id_test" value="${param.id_test}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
</td> 
       </form>



<%@ include file="middle.jspf"%>

<%--------------------------------------------------------------------------------------%>
<%-- QUERY CHE FA L'UPDATE: QUANDO UN NUOVO MESSAGGIO RICEVUTO  VIENE VISUALIZZATO 
     PER LA PRIMA VOLTA, VIENE MODIFICATO L'ATTRIBUTO 'NUOVO' DELLA TABELLA MESSAGGI
     CHE DIVENTA DA TRUE A FALSE.
     METTO IL C:IF PERCHE' L'UPDATE LO DEVO FARE SOLO PER I MESSAGGI RICEVUTI E NUOVI --%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${not empty param.visualizza && param.inviato == 'false'}">
<sql:update>
     UPDATE MESSAGGI set nuovo = false
     where id_messaggio = ?
     <sql:param value="${param.mess}"/>
</sql:update>
</c:if>
<%--------------------------------------------------------------------------------%>
<%--QUERY CHE ESTRAE TUTTI I MESSAGGI SCAMBIATI, PER IL RELATIVO TEST PRESCRITTO,
    CON IL LAB---%>
<%--------------------------------------------------------------------------------%>
<sql:query var="rset_messaggi">
    select m.data_ora, m.oggetto, m.testo, c.nome, m.inviato, p.nome_prod, m.nuovo, m.id_messaggio
    from MESSAGGI m, TEST t, SCHEDA_PROD p, CPR c
    where t.id_test=m.id_test and c.user_cpr=p.user_cpr and t.id_scheda = p.id_scheda and m.id_test="${param.id_test}"

</sql:query>



<sql:query var="data_esito">
    select t.data_ora_esito
    from TEST t
    where t.id_test="${param.id_test}"

</sql:query>


    <TABLE border="0" align="center" width="100%" height="100%">
             <tr height="25%">
                 <td align="center">
                     <h1><font color="008080">POSTA LAB </font> </h1> 
                     <h3>Area di messaggistica relativa al ${param.id_test} sul prodotto ${rset_messaggi.rows[0].nome_prod}: puoi scambiare messaggi con ${param.nome} </h3> 
                     <br/>
                 </td>  
             </tr>
            <tr height="5%">
            <%--------------------------------------------------------------------------------%>
            <%--MESSAGGIO CHE APPARE SE L'INVIO DEL MESSAGGIO AL LAB E' AVVENUTO CON SUCCESSO --%>
            <%--------------------------------------------------------------------------------%>
                <td>
                    <c:if test="${not empty mess_inviato}">
                    <font color="green">${mess_inviato}</font>
                    </c:if>
                </td
            </tr>
<%--NUOVO MESSAGGIO--%>
                    <form method="post" action="chat1.jsp"> 
                      <tr height="7%">
                       <td align="center" valign="top">
                        <table>
                          <c:if test="${empty data_esito.rows[0].data_ora_esito}" > 
                           <tr width="100%">
                            <td  align="center">  
                                <font color="008080"><u> + NUOVO MESSAGGIO &nbsp &nbsp </u>
                                <input type="image" name="submit" src="invia.png" style="width:30px;height:30px"/>    
                                
                                </font>

                             <td width="50%" align="left" >
                                 <input type="hidden" name="id_test" value="${param.id_test}"/>
                                 <input type="hidden" name="messaggio_lab" value="${param.messaggio_lab}">
                                 <input type="hidden" name= "nome_lab" value="${param.nome_lab}">
                            <%--     <input type="hidden" name="oggetto" value="${param.oggetto}">
                                 <input type="hidden" name="data" value="${param.data}"> --%>
                                 <input type="hidden" name="id_test" value="${param.id_test}"/>
                                 <input type="hidden" name="nome" value="${param.nome}"/>
                                 <input type="hidden"  name="n_mess1" value="${param.n_mess1}">

                              </td>
                           </tr>
                          </c:if>
                        </table>
                       </td> 
                      </tr>
                     </form>

             
                 <tr>
                    <td valign="top">
                        <TABLE border="0" align="center" width="100%" height="100%">
                            <tr>
                               <td width="60%" height="100%">
                                    <table border="0"  width="100%" height="100%">
                                          <tr height="100%">
                                          <td width="65%" height="100%">
                                                <table border="0"  width="100%" height="100%">
                                                  <tr height="20%">
                                                  <td valign="top">
                                                      <table cellspacing="0" cellpadding="1" border="1" bgcolor="007171" width="800">
                                                         <tr bgcolor="#008080">
                                                             <th WIDTH="35%"><font color="9ad6d6"  align="center"> OGGETTO</font></th>
                                                             <th WIDTH="25%"><font color="9ad6d6"   align="center">DATA</font></th>
                                                             <th WIDTH="20%"><font color="9ad6d6"   align="center">TIPO</font></th>
                                                             <th WIDTH="20%"><font color="9ad6d6"  align="center" >VISUALIZZA</font></th>
                                                         </tr>
                                                       </table><br/>
                                                    </td>
                                                  </tr>
                                                  <tr >
                                                    <c:choose>
                                                     <c:when test="${empty rset_messaggi.rows[0].id_messaggio}" >
                                                      <td valign="top">
                                                       <p align="center"><font color="black" style="font-size:15px;font-weight:bold;font-family:arial">Non ci sono messaggi da visualizzare</font> </p>
                                                      </td>
                                                     </c:when>
                                                     <c:otherwise>
                                                      <td valign="top">
                                                      <div style="width:850px; height:270px; overflow:auto;">
                                                      		<table border="1" cellpadding="1" cellspacing="1" width="800px"   bgcolor="white" >
                                                             <c:forEach items ="${rset_messaggi.rows}" var= "mex"> 
                                                 <form method="post" action="messaggi.jsp">
                                                                <tr

<%--------------------------------------------------------------------------------%>
<%--C:IF CHE PERMETTE DI VEDERE LA RIGA EVIDENZIATA DI AZZURO PER I MESSAGGI NUOVI
    RICEVUTI E QUINDI ANCORA NON LETTI--%>
<%--------------------------------------------------------------------------------%>
        <c:if test="${mex.nuovo == 'true' && mex.inviato == 'false'}"> 
         bgcolor="#ADD8E6" </c:if>>
        
                                                            <td WIDTH="35%"><c:out value="${mex.oggetto}"/></td>
                                                            <td WIDTH="25%"> <c:out value="${mex.data_ora}"/></td>
                                                            <c:if test="${mex.inviato}"><td align="center" WIDTH="20%"> <IMG SRC="posta_invia.png" width="25" title="messaggio inviato"></td></c:if>  
                                                            <c:if test="${not mex.inviato}"><td align="center" WIDTH="20%">    <IMG SRC="posta_ricevi.png" width="25" title="messaggio ricevuto"></td></c:if>
                                                            
                                                            <td align="center" valign="middle" WIDTH="20%" valign="top" >
                 
                                                                <input type="hidden" name="id_test" value="${param.id_test}"/>
                                                                <input type="hidden" name="n_mess1" value="${param.n_mess1}"/>
                                                                <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                                                                <input type="hidden" name="nome" value="${mex.nome}"/>
                                                                <input type="hidden" name="data" value="${mex.data_ora}"/>
                                                                <input type="hidden" name="oggetto1" value="${mex.oggetto}"/>
                                                                <input type="hidden" name="testo" value="${mex.testo}"/>
                                                                <input type="hidden" name="mess" value="${mex.id_messaggio}"/>
                                                                <input type="hidden" name="inviato" value="${mex.inviato}"/>
                                                                <input type="submit" name="visualizza" value="Visualizza messaggio" style="background:#a5bacd;"/>
                                                           </td>
                                                    </tr>
                                                     </form>  
                                                 </c:forEach>
                                             
                                                            </table>
                                                      </div>
                                                  	 </td>
                                            </c:otherwise>
                                           </c:choose>
                                                  </tr>                                                  	
                                            	</table>
                                                                               
                                          </td>
                                          </tr>
                                      </table>
                               </td>
                               <td>
<%--------------------------------------------------------------------------%>
<%-------- IF PER VISUALIZZARE LA MAIL UNA VOLTA CLICCATO SU VISUALIZZA-----%>
<%--------------------------------------------------------------------------%>
                                    <c:if test="${not empty param.visualizza}">
                                       <table border="0" width="70%" height="80%" align="center">
                                        <tr height="5%">
                                         <form method="post" action="messaggi.jsp">
                                            <td valign="top" align="right">
                                                <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
                                                <input type="hidden"  name="id_test" value="${param.id_test}"> 
                                                <input type="hidden"  name="nome" value="${param.nome}"> 
                                            </td>
                                         </form>
                                        </tr>
                                        <tr>
                                        <td>
                                        <table width="100%" height="100%" border="1" cellpadding="0" bordercolor="black" bgcolor="bbccdc">
                                          <tr>
                                            <td align="right" bgcolor="#ADD8E6" height="10%">
                                               <font size="2"> ${param.data}</font>
                                            </td>
                                         </tr>
                                         <tr>
                                            <td align="left" bgcolor="#ADD8E6" height="20%" > 
                                               Mittente:  ${param.nome} 
                                            </td> 
                                         </tr>
                                         <tr>
                                            <td align="left" bgcolor="#ADD8E6" height="20%" > 
                                               Oggetto:  ${param.oggetto1} 
                                            </td> 
                                         </tr>
                                         <tr>
                                            <td align="center" >
                                              ${param.testo}
                                            </td>
                                         </tr>
                                        </table>
                                        </td>
                                        </tr>
                                        </table>
                                        </c:if>
                               </td>
                            </tr>
                        </table>
                      </td>
              </tr>
           </TABLE>
      
 
<%@ include file="bottom.jspf"%>

